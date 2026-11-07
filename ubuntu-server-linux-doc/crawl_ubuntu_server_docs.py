#!/usr/bin/env python3
"""Crawl the Ubuntu Server documentation (https://ubuntu.com/server/docs) to Markdown.

Strategy
--------
* The site is a Sphinx + Furo (dirhtml) build: every page is fully rendered
  server-side, so plain HTTP fetching is enough (no headless browser).
* The authoritative page list is Sphinx's own search index
  (``/server/docs/searchindex.js`` -> ``docnames``), which is more complete than
  the sidebar toctree.
* Only ``<article role="main">`` is kept; site chrome is discarded, so no
  boilerplate ends up in the Markdown.
* Sphinx-specific constructs (terminal sessions, highlighted code, admonitions,
  sphinx-design tabs, glossary definition lists) are normalised before the HTML
  fragment is handed to pandoc (html -> gfm).
* Cross-page links are rewritten to relative ``*.md`` paths; Sphinx anchor ids
  that would not survive the heading-slug conversion get an explicit
  ``<a id="..."></a>`` target. Images and downloadable files are downloaded.
* Raw HTML and page lists are cached under ``.cache/`` so re-runs are cheap and
  ``--refresh`` gives a clean re-crawl.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import json
import os
import re
import subprocess
import sys
import time
import unicodedata
from pathlib import Path
from urllib.parse import urljoin, urlsplit, unquote

import requests
from bs4 import BeautifulSoup

BASE_URL = "https://ubuntu.com/server/docs/"
BASE_PATH = "/server/docs/"
DOCS_DIR = Path("docs")
CACHE_DIR = Path(".cache/html")
ASSETS_DIR = Path("_assets")
ASSETS_INDEX = Path(".cache/assets.json")
USER_AGENT = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/124.0 Safari/537.36 ubuntu-server-docs-offline/1.0"
)

session = requests.Session()
session.headers.update({"User-Agent": USER_AGENT, "Accept-Language": "en"})


# --------------------------------------------------------------------------- #
# fetching
# --------------------------------------------------------------------------- #
def fetch(url: str, retries: int = 4, expect_html: bool = False) -> bytes:
    """GET *url* with retries; returns raw bytes.

    ``ubuntu.com`` occasionally closes a connection mid-response, so HTML
    payloads are rejected unless the closing ``</html>`` tag is present.
    """
    last = None
    for attempt in range(retries):
        try:
            r = session.get(url, timeout=60)
            if r.status_code == 200:
                if expect_html and b"</html>" not in r.content:
                    last = RuntimeError(f"truncated response for {url}")
                    time.sleep(1.5 * (attempt + 1))
                    continue
                return r.content
            if r.status_code in (404, 410):
                raise FileNotFoundError(url)
            last = RuntimeError(f"HTTP {r.status_code} for {url}")
        except requests.RequestException as exc:  # network hiccup
            last = exc
        time.sleep(1.5 * (attempt + 1))
    raise RuntimeError(f"failed to fetch {url}: {last}")


def url_key(docname: str) -> str:
    """Directory-URL key for a docname (dirhtml drops a trailing ``/index``)."""
    if docname in ("index", ""):
        return ""
    if docname.endswith("/index"):
        return docname[: -len("/index")]
    return docname


def docname_url(docname: str) -> str:
    """Sphinx dirhtml URL for a docname."""
    key = url_key(docname)
    return BASE_URL if not key else urljoin(BASE_URL, key + "/")


def docname_path(docname: str) -> Path:
    """Local Markdown path for a docname (``index`` pages stay ``index.md``)."""
    if docname in ("index", ""):
        return DOCS_DIR / "index.md"
    return DOCS_DIR / (docname + ".md")


def load_docnames() -> list[str]:
    """Sphinx search index holds the authoritative list of docnames."""
    for attempt in range(4):
        raw = fetch(BASE_URL + "searchindex.js").decode("utf-8", "replace")
        m = re.match(r"Search\.setIndex\((.*)\)\s*;?\s*$", raw, re.S)
        if m:
            try:
                return json.loads(m.group(1))["docnames"]
            except json.JSONDecodeError:
                pass
        time.sleep(2 * (attempt + 1))
    raise RuntimeError("could not read searchindex.js (truncated responses?)")


# --------------------------------------------------------------------------- #
# HTML -> normalised fragment
# --------------------------------------------------------------------------- #
class Doc:
    def __init__(self, docname: str, html: str):
        self.docname = docname
        self.url = docname_url(docname)
        self.soup = BeautifulSoup(html, "lxml")
        self.title = ""
        self.sections: list[tuple[str, int, str]] = []  # (id, level, heading text)
        self.links: list[str] = []
        self.images: list[str] = []

    # -- helpers ------------------------------------------------------------
    def _clean(self, art) -> None:
        for sel in art.select("a.headerlink, script, style, noscript"):
            sel.decompose()
        for sp in art.select("span.copybutton"):
            sp["class"] = [c for c in sp.get("class", []) if c != "copybutton"]
        # Sphinx wraps inline literals as <code><span class="pre">x</span></code>
        for sp in art.select("code span"):
            sp.unwrap()
        # empty anchor spans: explicit RST labels must survive as <a id> targets,
        # auto-generated ones (id1, id2, ...) are noise
        for sp in art.select("span[id]"):
            if not sp.get_text(strip=True):
                sid = sp["id"]
                if re.fullmatch(r"id\d+", sid):
                    sp.decompose()
                else:
                    sp.replace_with("@@ANCHOR:%s@@" % sid)

    def _terminal_blocks(self, art) -> None:
        """``div.terminal`` (prompt + command + output) -> fenced console block."""
        for div in art.select("div.terminal"):
            chunks: list[str] = []
            for node in div.find_all(recursive=False):
                cls = node.get("class") or []
                if "input" not in cls:
                    continue
                line = ""
                for sub in node.find_all(recursive=False):
                    sub_cls = sub.get("class") or []
                    if "prompt" in sub_cls or "command" in sub_cls:
                        line += sub.get_text()
                    elif "terminal-code" in sub_cls:
                        pre = sub.find("pre")
                        if pre is not None:
                            line += "\n" + pre.get_text().rstrip("\n")
                chunks.append(line.rstrip())
            pre = art.new_tag("pre")
            code = art.new_tag("code")
            code["class"] = ["language-console"]
            code.string = "\n".join(chunks) + "\n"
            pre.append(code)
            div.replace_with(pre)

    def _code_blocks(self, art) -> None:
        """Sphinx code blocks -> <pre><code class="language-x"> (pandoc -> fenced)."""
        for pre in art.find_all("pre"):
            code = pre.find("code")
            if code is not None and any(
                c.startswith("language-") for c in (code.get("class") or [])
            ):
                continue  # already normalised (terminal blocks)
            lang = ""
            src = pre
            depth = 0
            while src is not None and depth < 5:
                for c in src.get("class") or []:
                    if c.startswith("highlight-"):
                        cand = c[len("highlight-"):]
                        if cand not in ("default", "none", ""):
                            lang = cand
                            break
                if lang:
                    break
                src = src.parent
                depth += 1
            text = pre.get_text()
            new_pre = art.new_tag("pre")
            new_code = art.new_tag("code")
            if not lang or lang in ("default", "none"):
                lang = "text"
            new_code["class"] = ["language-" + lang]
            new_code.string = text
            new_pre.append(new_code)
            pre.replace_with(new_pre)

    def _strip_attrs(self, art) -> None:
        """Remove Sphinx/docutils attributes: GFM cannot carry them, and pandoc
        falls back to raw HTML for any link/div/span that has attributes."""
        for tag in art.find_all(["div", "span"]):
            tag.unwrap()
        for tag in art.find_all(True):
            keep = {
                "a": {"href", "title"},
                "img": {"src", "alt", "title"},
                "code": {"class"},
                "ol": {"start"},
            }.get(tag.name, set())
            for attr in list(tag.attrs):
                if attr not in keep:
                    del tag[attr]
        for code in art.find_all("code"):
            classes = [c for c in (code.get("class") or []) if c.startswith("language-")]
            if classes:
                code["class"] = classes
            elif code.has_attr("class"):
                del code["class"]

    def _admonitions(self, art) -> None:
        for div in art.select("div.admonition"):
            anchor_id = div.get("id")
            if anchor_id:
                ph = art.new_tag("p")
                ph.string = "@@ANCHOR:%s@@" % anchor_id
                div.insert_before(ph)
            title = div.find(class_="admonition-title")
            if title is not None:
                label = title.get_text(" ", strip=True) or "Note"
                p = art.new_tag("p")
                strong = art.new_tag("strong")
                strong.string = label
                p.append(strong)
                title.replace_with(p)
            bq = art.new_tag("blockquote")
            for child in list(div.contents):
                bq.append(child.extract())
            div.replace_with(bq)

    def _tabs(self, art) -> None:
        for tabset in art.select("div.sd-tab-set"):
            labels = tabset.select("label.sd-tab-label")
            contents = tabset.select("div.sd-tab-content")
            for label, content in zip(labels, contents):
                head = art.new_tag("p")
                strong = art.new_tag("strong")
                strong.string = "[%s]" % label.get_text(" ", strip=True)
                head.append(strong)
                tabset.insert_before(head)
                for child in list(content.contents):
                    tabset.insert_before(child.extract())
            tabset.decompose()

    def _definition_lists(self, art) -> None:
        """<dl> is not expressible in GFM: term becomes bold + explicit anchor."""
        for dl in art.select("dl"):
            for child in list(dl.children):
                if getattr(child, "name", None) == "dt":
                    anchor_id = child.get("id") or ""
                    if anchor_id:
                        ph = art.new_tag("p")
                        ph.string = "@@ANCHOR:%s@@" % anchor_id
                        dl.insert_before(ph)
                    p = art.new_tag("p")
                    strong = art.new_tag("strong")
                    strong.string = child.get_text(" ", strip=True)
                    p.append(strong)
                    dl.insert_before(p)
                    child.decompose()
                elif getattr(child, "name", None) == "dd":
                    for grand in list(child.contents):
                        dl.insert_before(grand.extract())
                    child.decompose()
            dl.decompose()

    def prepare(self) -> "Doc":
        art = self.soup.find("article")
        if art is None:
            return None
        self._clean(art)
        h1 = art.find("h1")
        self.title = h1.get_text(" ", strip=True).rstrip("¶").strip() if h1 else self.docname
        self._terminal_blocks(art)
        self._code_blocks(art)
        self._admonitions(art)
        self._tabs(art)

        for sec in art.find_all("section"):
            sid = sec.get("id")
            h = sec.find(["h1", "h2", "h3", "h4", "h5", "h6"])
            if sid and h is not None:
                text = h.get_text(" ", strip=True)
                self.sections.append((sid, int(h.name[1]), text))
            sec.unwrap()

        self._definition_lists(art)
        self._strip_attrs(art)

        for a in art.find_all("a", href=True):
            self.links.append(a["href"])
        for img in art.find_all("img", src=True):
            self.images.append(img["src"])

        self.fragment = str(art)
        return self


# --------------------------------------------------------------------------- #
# pandoc
# --------------------------------------------------------------------------- #
def html_to_markdown(fragment: str) -> str:
    html_doc = (
        "<!DOCTYPE html><html><head><meta charset='utf-8'></head><body>"
        + fragment
        + "</body></html>"
    )
    proc = subprocess.run(
        ["pandoc", "-f", "html", "-t", "gfm", "--wrap=none", "--eol=lf", "--markdown-headings=atx"],
        input=html_doc.encode("utf-8"),
        capture_output=True,
    )
    if proc.returncode != 0:
        raise RuntimeError(proc.stderr.decode("utf-8", "replace"))
    return proc.stdout.decode("utf-8")


# --------------------------------------------------------------------------- #
# links / anchors / assets
# --------------------------------------------------------------------------- #
def slugify(text: str) -> str:
    text = unicodedata.normalize("NFKC", text).strip().lower()
    out = []
    for ch in text:
        if ch.isalnum() or ch in "-_ ":
            out.append(ch)
        # everything else (dots, slashes, quotes...) is dropped, like GitHub
    return re.sub(r"\s+", "-", "".join(out))


def resolve_docname(href: str, page_url: str) -> tuple[str | None, str]:
    """Map an href to (url key, anchor)."""
    absolute = urljoin(page_url, href)
    parts = urlsplit(absolute)
    if parts.netloc not in ("ubuntu.com", "www.ubuntu.com"):
        return None, parts.fragment
    path = unquote(parts.path)
    if not path.startswith(BASE_PATH):
        return None, parts.fragment
    rel = path[len(BASE_PATH):].strip("/")
    return rel, parts.fragment


def download_assets(urls: set[str]) -> dict[str, str]:
    """Download images; returns absolute URL -> local path (relative to docs/)."""
    ASSETS_DIR.mkdir(parents=True, exist_ok=True)
    mapping: dict[str, str] = {}
    if ASSETS_INDEX.exists():
        mapping = json.loads(ASSETS_INDEX.read_text(encoding="utf-8"))

    def one(url: str) -> tuple[str, str | None]:
        name = os.path.basename(unquote(urlsplit(url).path)) or "asset"
        stem, ext = os.path.splitext(name)
        if not ext:
            ext = ".bin"
        target = ASSETS_DIR / (stem + ext)
        if target.exists() and mapping.get(url) == target.as_posix():
            return url, target.as_posix()
        try:
            target.write_bytes(fetch(url))
            return url, target.as_posix()
        except Exception as exc:  # pragma: no cover - network
            print(f"  ! asset failed {url}: {exc}", file=sys.stderr)
            return url, None

    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        for url, local in pool.map(one, sorted(urls)):
            if local:
                mapping[url] = local
    ASSETS_INDEX.parent.mkdir(parents=True, exist_ok=True)
    ASSETS_INDEX.write_text(json.dumps(mapping, indent=1, sort_keys=True), encoding="utf-8")
    return mapping


MD_LINK = re.compile(r"(!?)\[([^\]]*)\]\(([^)\s]+)(\s+\"[^\"]*\")?\)")


def rewrite_links(md: str, doc: Doc, url_map: dict[str, str], assets: dict[str, str],
                  needed_anchors: set[tuple[str, str]]) -> str:
    def repl(m: re.Match) -> str:
        bang, text, target, title = m.group(1), m.group(2), m.group(3), m.group(4) or ""
        if target.startswith(("mailto:", "tel:", "data:")):
            return m.group(0)
        is_image = bang == "!"
        if is_image:
            absolute = urljoin(doc.url, target)
            local = assets.get(absolute) or assets.get(target)
            if local:
                rel = os.path.relpath(local, doc.md_path.parent.as_posix() or ".")
                rel = Path(rel).as_posix()
                return f"![{text}]({rel}{title})"
            return m.group(0)

        key, anchor = resolve_docname(target, doc.url)
        if key is None:
            return m.group(0)
        docname = url_map.get(key)
        if docname is None:
            return m.group(0)
        dest = docname_path(docname)
        rel = os.path.relpath(dest, doc.md_path.parent.as_posix() or ".")
        rel = Path(rel).as_posix()
        if anchor:
            needed_anchors.add((docname, anchor))
            return f"[{text}]({rel}#{anchor}{title})"
        return f"[{text}]({rel}{title})"

    return MD_LINK.sub(repl, md)


def insert_anchors(md: str, doc: Doc, needed: set[str]) -> str:
    """Add explicit <a id> targets before headings whose Sphinx id != GitHub slug."""
    if not needed:
        return md
    lines = md.split("\n")

    def loose(text: str) -> str:
        """Compare headings ignoring markdown emphasis and punctuation."""
        return re.sub(r"[^a-z0-9]+", "", text.lower())

    section_by_heading = {
        (level, loose(text)): sid for sid, level, text in doc.sections if sid in needed
    }
    out: list[str] = []
    for line in lines:
        m = re.match(r"^(#{1,6})\s+(.*?)\s*$", line)
        if m:
            level, text = len(m.group(1)), m.group(2)
            plain = re.sub(r"[*`\[\]]", "", text)
            sid = section_by_heading.get((level, loose(text)))
            if sid and slugify(plain) != sid:
                out.append(f'<a id="{sid}"></a>')
                out.append("")
        out.append(line)
    return "\n".join(out)


def fix_definition_anchors(md: str) -> str:
    """``@@ANCHOR:id@@`` placeholders -> explicit anchor lines before their block."""
    out: list[str] = []
    for line in md.split("\n"):
        ids = re.findall(r"@@ANCHOR:([^@]+)@@", line)
        if ids:
            line = re.sub(r"\s*@@ANCHOR:[^@]+@@", "", line).rstrip()
        for i in ids:
            out.append(f'<a id="{i}"></a>')
            out.append("")
        out.append(line)
    return "\n".join(out)


def tidy(md: str) -> str:
    md = re.sub(r"^``` (\S+)\s*$", r"```\1", md, flags=re.M)
    md = re.sub(r"\n{3,}", "\n\n", md)
    md = re.sub(r"[ \t]+$", "", md, flags=re.M)
    md = re.sub(r"^\[\]\(([^)]*)\)$", "", md, flags=re.M)
    return md.strip() + "\n"


# --------------------------------------------------------------------------- #
# main pipeline
# --------------------------------------------------------------------------- #
def crawl(args: argparse.Namespace) -> int:
    docnames = load_docnames()
    print(f"pages: {len(docnames)}")

    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    landing = CACHE_DIR / "index.html"

    def download(docname: str) -> tuple[str, bool]:
        cache = CACHE_DIR / (docname + ".html")
        if cache.exists() and not args.refresh:
            return docname, False
        cache.parent.mkdir(parents=True, exist_ok=True)
        try:
            cache.write_bytes(fetch(docname_url(docname), expect_html=True))
        except FileNotFoundError:
            print(f"  ! not found (skipped): {docname_url(docname)}", file=sys.stderr)
            return docname, False
        if args.delay:
            time.sleep(args.delay)
        return docname, True

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        done = 0
        for docname, _fresh in pool.map(download, docnames):
            done += 1
            if done % 25 == 0 or done == len(docnames):
                print(f"  fetched {done}/{len(docnames)}", flush=True)

    if args.refresh or not landing.exists():
        landing.write_bytes(fetch(BASE_URL, expect_html=True))

    # -- parse ------------------------------------------------------------
    docs: dict[str, Doc] = {}
    skipped: list[str] = []
    for docname in docnames:
        cache = CACHE_DIR / (docname + ".html")
        if not cache.exists():
            continue
        html = cache.read_text(encoding="utf-8", errors="replace")
        doc = Doc(docname, html).prepare()
        if doc is None or len(doc.fragment) < 200:
            skipped.append(docname)
            continue
        docs[docname] = doc
    print(f"parsed {len(docs)} pages, skipped {len(skipped)}")
    if skipped:
        (CACHE_DIR.parent / "skipped.json").write_text(json.dumps(skipped, indent=1), encoding="utf-8")
    url_map = {url_key(name): name for name in docs}

    # -- assets -----------------------------------------------------------
    image_urls: set[str] = set()
    for doc in docs.values():
        for src in doc.images:
            image_urls.add(urljoin(doc.url, src))
    assets = download_assets(image_urls)
    print(f"assets: {len(assets)}")

    # -- temp module-level shim so rewrite_links can find the md path ------
    for doc in docs.values():
        doc.md_path = docname_path(doc.docname)

    needed: set[tuple[str, str]] = set()
    markdown: dict[str, str] = {}
    for doc in docs.values():
        md = html_to_markdown(doc.fragment)
        md = fix_definition_anchors(md)
        md = rewrite_links(md, doc, url_map, assets, needed)
        markdown[doc.docname] = md

    for docname, md in markdown.items():
        doc = docs[docname]
        ids = {a for d, a in needed if d == docname}
        md = insert_anchors(md, doc, ids)
        md = tidy(md)
        body = re.sub(r'^(<a id="[^"]*"></a>\s*\n+)+', "", md)
        header = "" if body.lstrip().startswith("# ") else f"# {doc.title.strip()}\n\n"
        footer = f"\n---\n\n> 来源：{doc.url}  \n> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）\n"
        path = docname_path(docname)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(header + md + footer, encoding="utf-8")
    print(f"wrote {len(markdown)} markdown files -> {DOCS_DIR}")

    write_readme(landing.read_text(encoding="utf-8", errors="replace"), docs, url_map, skipped)
    return 0


def nav_tree(landing_html: str) -> list[tuple[int, str, str]]:
    """Extract (level, title, url) from the Sphinx sidebar toctree."""
    soup = BeautifulSoup(landing_html, "lxml")
    root = soup.select_one("div.sidebar-tree")
    if root is None:
        return []
    items: list[tuple[int, str, str]] = []

    def walk(ul, level: int) -> None:
        for li in ul.find_all("li", recursive=False):
            a = li.find("a", recursive=False)
            if a is not None and a.get("href"):
                href = urljoin(BASE_URL, a["href"])
                items.append((level, a.get_text(" ", strip=True), href))
            sub = li.find("ul", recursive=False)
            if sub is not None:
                walk(sub, level + 1)

    top = root.find("ul")
    if top is not None:
        walk(top, 0)
    return items


def write_readme(landing_html: str, docs: dict[str, Doc], url_map: dict[str, str],
                 skipped: list[str]) -> None:
    items = nav_tree(landing_html)
    seen: set[str] = set()
    lines = [
        "# Ubuntu Server documentation（本地 Markdown 副本）",
        "",
        f"- 来源：<{BASE_URL}>",
        "- 上游仓库：<https://github.com/canonical/ubuntu-server-documentation>",
        f"- 抓取时间：{time.strftime('%Y-%m-%d %H:%M %Z')}",
        f"- 页面数量：{len(docs)} 篇（正文取自站点的 Sphinx 渲染结果，已转为 GFM Markdown）",
        "- 本地入口：`docs/index.md`；图片位于 `_assets/`",
        "",
        "",
        "## 抓取策略",
        "",
        "- 站点是 Sphinx + Furo 的 dirhtml 构建，页面完全服务端渲染，因此用普通 HTTP + 解析即可，无需无头浏览器。",
        "- 页面清单取自 Sphinx 自带的搜索索引 `searchindex.js`（255 篇），比侧栏目录更完整。",
        "- 只保留 `<article>` 正文，站点导航、页脚等外围结构全部丢弃。",
        "- 终端会话、代码块、告示块（note/tip/warning）、sphinx-design 标签页、术语表定义列表在转 Markdown 前先归一化；HTML→GFM 由 pandoc 完成。",
        "- 跨页链接改写为相对 `*.md` 路径，Sphinx 锚点若与标题 slug 不一致会补 `<a id=\"...\">` 显式锚点；图片与附件下载到 `_assets/`。",
        "- 原始 HTML 缓存在 `.cache/`，重复运行成本很低。",
        "",
        "依赖：Python 3（`requests`、`beautifulsoup4`、`lxml`）+ pandoc。",
        "",
        "## 目录",
        "",
        "- [首页](docs/index.md)",
    ]
    listed: set[str] = set()
    for level, title, url in items:
        if url in seen:
            continue
        seen.add(url)
        key, _ = resolve_docname(url, BASE_URL)
        docname = url_map.get(key)
        if not docname:
            continue
        listed.add(docname)
        rel = Path(os.path.relpath(docname_path(docname), Path("."))).as_posix()
        lines.append("  " * (level + 1) + f"- [{title}]({rel})")
    rest = sorted(name for name in docs if name not in listed and name != "index")
    if rest:
        lines += ["", "## 其他页面（未出现在侧栏目录）", ""]
        lines += [f"- [{docs[name].title}]({docname_path(name).as_posix()})" for name in rest]
    if skipped:
        lines += ["", "## 未收录页面", "", "以下页面在上游返回了无正文的页面，已跳过：", ""]
        lines += [f"- `{name}`" for name in skipped]
    lines.append("")
    Path("README.md").write_text("\n".join(lines), encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--refresh", action="store_true", help="ignore cached HTML and re-download everything")
    ap.add_argument("--jobs", type=int, default=4, help="parallel HTTP workers (default: 4)")
    ap.add_argument("--delay", type=float, default=0.05, help="seconds to sleep between requests per worker")
    args = ap.parse_args(argv)
    return crawl(args)


if __name__ == "__main__":
    raise SystemExit(main())
