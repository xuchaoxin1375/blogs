[toc]



## 通用代码仓库治理 Skill

> 适用范围：任何语言、任何类型的开源代码仓库（Web / CLI / 库 / 工具 / 服务等）
> 适用阶段：**新建仓库初始化** 与 **存量仓库规范化改造** 均适用; 保护项目所有者和维护者的私密信息,防止敏感信息泄露.



## 使用说明

本文件是仓库的 AI 编码指令与治理规范，适用于：

- **新建仓库**：按 Checklist 逐项建立
- **存量仓库**：按 Checklist 逐项审计，对缺失项补全，对不合规项修正

AI Agent 在本仓库执行任何任务前，须先读取并遵守本文件的全部规则。

---

## 治理 Checklist

每项标注适用阶段：`[新建]` / `[改造]` / `[通用]`

### 基础文件

- [ ] `[通用]` `LICENSE` — 开源许可证（缺省则默认保留所有权利，必须补充）
- [ ] `[通用]` `README.md` — 项目描述、安装、使用、许可证声明
- [ ] `[通用]` `.gitignore` — 排除构建产物、依赖、密钥、系统文件
- [ ] `[通用]` `.gitattributes` — 统一行尾为 LF，防止跨平台污染
- [ ] `[通用]` `.editorconfig` — 跨编辑器缩进、编码格式统一

### 开源社区文件

- [ ] `[通用]` `CONTRIBUTING.md` — 贡献流程、分支策略、提交规范
- [ ] `[通用]` `CODE_OF_CONDUCT.md` — 行为准则（推荐 Contributor Covenant）
- [ ] `[通用]` `SECURITY.md` — 漏洞上报渠道（禁止在 Issue 中公开披露）
- [ ] `[通用]` `CODEOWNERS` — 代码 Owner，自动分配 Review
- [ ] `[通用]` `CHANGELOG.md` — 版本变更记录（可手写或工具自动生成）

### 质量保障

- [ ] `[通用]` 配置语言对应的 Linter 和 Formatter（见「工具参考表」）
- [ ] `[通用]` Husky + lint-staged — pre-commit 自动 Lint / Format
- [ ] `[通用]` commitlint — commit-msg hook，强制 Conventional Commits
- [ ] `[通用]` `.github/workflows/ci.yml` — 自动化 Lint + Test + Build
- [ ] `[通用]` `.github/dependabot.yml` — 依赖自动更新

### AI Coding

- [ ] `[通用]` `AGENTS.md` — 本文件，AI 通用指令（已完成）
- [ ] `[通用]` 可选：`CLAUDE.md` symlink 至 `AGENTS.md`

### 改造专项

- [ ] `[改造]` 审计 Git 历史，确认无密钥、无大体积二进制文件
- [ ] `[改造]` 补充 `.gitignore` 缺失的排除项（用 `git ls-files --ignored` 排查）
- [ ] `[改造]` 对存量提交历史不作强制规范，但从**当前节点起**开始执行新规范
- [ ] `[改造]` 补充缺失的 Issue / PR 模板
- [ ] `[改造]` 检查 `.gitattributes`，如行尾已混乱，执行一次全仓库行尾归一化提交

---

## 隐私与安全：绝对禁止提交的内容

> **最高优先级规则**，AI Agent 在生成任何文件或提交建议时均须遵守。

### 永远不提交

| 类别 | 典型文件或模式 |
|---|---|
| 环境变量 / 密钥 | `.env`、`.env.*`（`.env.example` 除外）、`.envrc` |
| 云服务凭证 | `*.pem`、`*.p12`、`*.key`、`credentials.json`、`serviceAccountKey.json` |
| 数据库配置 | 含密码的 `database.yml`、`config/secrets.yml` |
| SSH / TLS 私钥 | `id_rsa`、`id_ed25519`、`*.crt`（私钥类） |
| 构建产物 | `dist/`、`build/`、`out/`、`target/`、`bin/`、`__pycache__/` |
| 依赖目录 | `node_modules/`、`.venv/`、`vendor/`（Go modules 除外）|
| 日志 / 临时文件 | `*.log`、`*.tmp`、`.DS_Store`、`Thumbs.db` |
| 测试覆盖率 | `coverage/`、`.nyc_output/`、`htmlcov/` |
| 编辑器私有配置 | `.idea/`、`.vscode/settings.json`（共享配置可例外） |
| 本地证书 | `localhost.*`、`127.0.0.1.*` |

### 敏感信息管理规则

1. 只提交 `.env.example`，列出变量名，值用占位符（如 `YOUR_API_KEY_HERE`）
2. 生产密钥通过 CI/CD 平台的 Secrets 注入，不写入任何文件
3. 意外提交敏感信息后：
   - 用 **BFG Repo Cleaner** 或 `git filter-repo` 清除历史
   - **立即吊销并轮换泄露的密钥**（历史清除不等于安全，曾公开即视为泄露）

### AI Agent 安全操作规则

- **禁止**在代码中硬编码任何密钥、Token、密码、API Key
- **禁止**生成或覆盖 `.env`（可读取和修改 `.env.example`）
- 不主动将疑似私密或项目无关的**独立文件**纳入提交,并且发现要向用户警告(例如大量公网ip或非知名域名);
- 发现代码中存在硬编码敏感信息时，**主动提示**并建议移至环境变量;
- 涉及文件路径操作时，检查路径遍历风险
- 涉及用户输入时，提示输入验证与注入防护

## 非代码文件管理规则

### 默认忽略的非代码文件类型

除非用户明确声明需要纳入版本管理，以下类型文件**一律忽略**，不得提交：

| 类别              | 典型扩展名示例                                       | 原因                                            |
| ----------------- | ---------------------------------------------------- | ----------------------------------------------- |
| 压缩包            | `.zip` `.tar` `.gz` `.tgz` `.bz2` `.xz` `.rar` `.7z` | 内容不透明，diff 无意义，体积大                 |
| 可执行二进制      | `.exe` `.bin` `.out` `.app` `.dmg` `.deb` `.rpm`     | 无法 diff，来源不可审计，存在安全风险           |
| 动态 / 静态链接库 | `.so` `.dll` `.dylib` `.a` `.lib`                    | 属于构建产物，应由构建系统生成                  |
| 编译中间产物      | `.o` `.obj` `.class` `.pyc` `.pyo`                   | 属于构建产物，因平台和编译器版本而异            |
| 大体积媒体文件    | `.mp4` `.mov` `.avi` `.mp3` `.wav` `.psd` `.ai`      | 显著膨胀仓库体积，克隆和操作变慢                |
| 数据库文件        | `.db` `.sqlite` `.sqlite3` `.mdb`                    | 可能含用户数据，且二进制格式无法有效 diff       |
| Office 文档       | `.docx` `.xlsx` `.pptx`                              | 二进制格式，diff 无意义；文档应以 Markdown 维护 |



### 允许提交的例外情况

以下情况**经用户明确声明后**可提交，但须遵守附加约束：

| 例外场景                                          | 附加约束                                                     |
| ------------------------------------------------- | ------------------------------------------------------------ |
| 测试用的小型 fixture 文件（如测试图片、样本数据） | 体积严格控制（建议单文件 < 1 MB），放在 `testdata/` 或 `fixtures/` 目录，在注释中说明用途 |
| 项目必要的静态资源（如 `favicon.ico`、字体文件）  | 限于小体积文件，在 `.gitignore` 中用 `!` 语法显式解除忽略    |
| 预编译的工具二进制（如项目依赖特定版本工具）      | 在 `README.md` 中说明来源和校验方式（提供 SHA256 校验和）    |
| 发布产物归档（Release Assets）                    | **不提交到仓库**，应上传到 GitHub Releases / 制品仓库（Artifact Registry），仓库只保存源码 |

显式解除忽略示例（`.gitignore`）：

```gitignore
# 默认忽略所有图片
*.png
*.jpg

# 但保留测试 fixture 和项目图标
!testdata/**/*.png
!assets/favicon.ico
```

### AI Agent 的操作规则

- 生成脚本或 Makefile 时，构建产物的输出路径须已在 `.gitignore` 中覆盖，否则**主动提示**补充
- 用户要求提交二进制文件时，须**先确认**用途，并提示替代方案（如 Releases、制品仓库）
- 发现仓库中已追踪了应被忽略的非代码文件，主动提示执行清理：

```bash
# 从 Git 追踪中移除（文件本身保留在本地）
git rm --cached <file>
# 或批量清理
git rm -r --cached .
git add .
git commit -m "chore: untrack ignored non-code files"
```

### 大文件的正确处理方式

如确实需要版本管理大型二进制文件，使用专用方案而非直接提交：

| 方案                                            | 适用场景                                 |
| ----------------------------------------------- | ---------------------------------------- |
| **Git LFS**（Large File Storage）               | 设计资源、模型权重等需要版本追踪的大文件 |
| **GitHub Releases**                             | 发布产物（可执行文件、安装包、压缩包）   |
| **制品仓库**（如 GitHub Packages、Artifactory） | 构建产物、Docker 镜像、依赖包            |
| **对象存储**（如 S3、OSS）                      | 媒体文件、数据集，通过 URL 引用          |

---

## .gitignore 通用模板

按语言追加对应部分，以下为各语言常见规则。

```gitignore
# ── 环境变量（核心安全规则）──
.env
.env.*
!.env.example
.envrc

# ── 日志 / 临时文件 ──
*.log
*.tmp
*.bak
*.swp
*.swo

# ── 系统文件 ──
.DS_Store
Thumbs.db
desktop.ini

# ── 编辑器 ──
.idea/
.vscode/settings.json
.vscode/launch.json
*.suo
*.sw?

# ── 密钥 / 证书 ──
*.pem
*.p12
*.key
*.crt
serviceAccountKey.json
credentials.json
localhost.*

# ─────── 按语言追加 ───────

# Node.js / Web
node_modules/
dist/
build/
.next/
.nuxt/
out/
.cache/
coverage/
.nyc_output/
npm-debug.log*
yarn-error.log*
pnpm-debug.log*

# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/
.pytest_cache/
htmlcov/
.mypy_cache/
dist/

# Go
bin/
vendor/     # 如使用 go mod vendor 则保留，否则忽略

# Rust
target/

# Java / Kotlin
*.class
*.jar
*.war
target/
.gradle/
build/

# C / C++
*.o
*.a
*.so
*.out
CMakeFiles/
cmake_install.cmake

# Ruby
.bundle/
vendor/bundle/
*.gem

# ── 非代码文件（默认忽略）──

# 压缩包
*.zip
*.tar
*.tar.gz
*.tgz
*.tar.bz2
*.tar.xz
*.rar
*.7z
*.gz
*.bz2
*.xz

# 可执行二进制
*.exe
*.bin
*.out
*.app
*.dmg
*.deb
*.rpm
*.msi

# 链接库
*.so
*.so.*
*.dll
*.dylib
*.a
*.lib

# 编译中间产物
*.o
*.obj
*.class
*.pyc
*.pyo

# 数据库文件
*.db
*.sqlite
*.sqlite3
*.mdb

# 大体积媒体（按需调整）
*.mp4
*.mov
*.avi
*.mkv
*.mp3
*.wav
*.psd
*.ai
```

---

## .gitattributes 通用模板

```gitattributes
# 所有文本文件统一使用 LF，防止跨平台行尾污染
* text=auto eol=lf

# Shell 脚本强制 LF（CRLF 会导致 Linux 上无法执行）
*.sh   text eol=lf
*.bash text eol=lf

# Windows 批处理保持 CRLF
*.bat text eol=crlf
*.cmd text eol=crlf

# 二进制文件禁止行尾转换
*.png  binary
*.jpg  binary
*.jpeg binary
*.gif  binary
*.ico  binary
*.pdf  binary
*.zip  binary
*.tar  binary
*.gz   binary
*.woff binary
*.woff2 binary
*.ttf  binary
*.otf  binary
*.mp4  binary
*.mp3  binary
```

> **存量仓库行尾归一化**：`.gitattributes` 加入后，对旧文件行尾不会自动修正。
> 执行一次归一化提交：
> ```bash
> git add --renormalize .
> git commit -m "chore: normalize line endings to LF"
> ```

---

## .editorconfig 通用模板

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true

# Markdown：行尾空格有语义（换行），不裁剪
[*.md]
trim_trailing_whitespace = false

# Python / Rust：4 空格缩进
[*.{py,rs}]
indent_size = 4

# Go / Makefile：必须使用 Tab
[*.go]
indent_style = tab

[Makefile]
indent_style = tab
```

---

## 提交规范（Conventional Commits）

格式：`<type>(<scope>): <subject>`

| 占位符 | 说明 |
|---|---|
| `type` | 提交类型，限定枚举值（见下表） |
| `scope` | 影响范围，通常为模块名，可选 |
| `subject` | 简短描述，不超过 72 字符，不以句号结尾 |

常用 type：

| type | 用途 |
|---|---|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `docs` | 仅文档变更 |
| `refactor` | 重构（不影响功能） |
| `test` | 添加或修改测试 |
| `chore` | 构建 / 工具 / 依赖变更 |
| `ci` | CI/CD 配置变更 |
| `perf` | 性能优化 |
| `revert` | 回滚提交 |

示例：

- `feat(auth): add OAuth2 login`
- `fix(parser): handle empty input gracefully`
- `chore(deps): bump requests from 2.31.0 to 2.32.0`
- `docs: add architecture decision record for caching layer`

破坏性变更在 footer 中声明：

```
feat(api)!: rename /users endpoint to /accounts

BREAKING CHANGE: all clients must update the base URL
```

---

## 分支策略

```
main          ← 始终可部署，受保护分支，不允许直接 push
  ├─ feature/<issue-id>-short-desc   ← 新功能，从 main 切出
  ├─ fix/<issue-id>-short-desc       ← Bug 修复，从 main 切出
  └─ hotfix/<desc>                   ← 紧急修复，从 main 切出，合并回 main
```

- 合并策略：**Squash Merge**（保持 main 历史线性整洁）
- 发布时打 tag：`v<MAJOR>.<MINOR>.<PATCH>`（遵循 SemVer）
- 分支命名不使用大写字母，单词间用 `-` 连接

---

## Linter / Formatter 工具参考表

| 语言 | Linter | Formatter | 备注 |
|---|---|---|---|
| JavaScript / TypeScript | ESLint | Prettier | 安装 `eslint-config-prettier` 消除冲突 |
| Python | Ruff | Ruff / Black | Ruff 同时承担 Lint 和 Format，速度极快 |
| Go | golangci-lint | `gofmt` / `goimports` | `gofmt` 为语言内置，必须使用 |
| Rust | Clippy | `rustfmt` | 均为官方工具链内置 |
| Shell | ShellCheck | `shfmt` | 开源项目中常被忽视，强烈推荐 |
| Java / Kotlin | Checkstyle / Detekt | Spotless / ktlint | |
| C / C++ | Clang-Tidy | `clang-format` | 用 `.clang-format` 配置文件 |
| Ruby | RuboCop | RuboCop | 同时承担 Lint 和 Format |

---

## 安全扫描（推荐集成）

| 工具 | 用途 | 集成方式 |
|---|---|---|
| **gitleaks** | 扫描提交中的密钥泄露 | pre-commit hook + CI |
| **GitHub Secret Scanning** | 自动检测公开仓库已知密钥格式 | GitHub 原生，免费开启 |
| **Dependabot Alerts** | 依赖漏洞通知 | `dependabot.yml` |
| 各语言 audit 工具 | 运行时依赖漏洞检查 | CI 流水线 |

各语言 audit 命令参考：

| 语言 | 命令 |
|---|---|
| Node.js | `npm audit` / `pnpm audit` |
| Python | `pip-audit` |
| Go | `govulncheck ./...` |
| Rust | `cargo audit` |
| Ruby | `bundle audit` |

---

## AI Agent 编码约束

- 遵循 Conventional Commits，不使用 `update`、`misc`、`fix stuff` 等模糊描述
- 优先使用项目已有的工具函数，避免重复实现
- 新功能必须附带对应测试用例
- 禁止修改：`LICENSE`、`SECURITY.md`、`.github/workflows/` 中的发布流水线、任何 `*.lock` 文件（除非明确要求依赖升级）
- 对文件的批量修改前，先说明变更范围，再执行

---

## 存量仓库规范化改造顺序建议

按以下顺序推进，避免相互干扰：

1. **先加 `.gitattributes`，执行行尾归一化提交**（放在最前，否则后续 diff 会被行尾变更污染）
2. **补全 `.gitignore`**，执行 `git rm --cached` 清理已被追踪的应忽略文件
3. **补充基础文档**（`LICENSE`、`README.md`、`CONTRIBUTING.md` 等）
4. **引入 Linter / Formatter**，格式化全仓库代码（单独一次提交）
5. **接入 Husky + lint-staged + commitlint**
6. **配置 CI 流水线**
7. **编写 `AGENTS.md`（本文件）**，从当前节点起对 AI Coding 行为生效

---

**初始化方式**：

```bash
# 新仓库：直接复制本文件至根目录
cp AGENTS.md /path/to/new-repo/

# Claude Code 用户：创建 symlink
ln -sf AGENTS.md CLAUDE.md

# Windows（管理员权限）
mklink CLAUDE.md AGENTS.md
```