[toc]

## abstract



`<sitemap>` 的用途是为搜索引擎提供网站的页面结构信息，从而帮助搜索引擎高效地抓取和索引网站的内容。虽然 HTML 中并没有一个直接的 `<sitemap>` 标签，但网站通常会通过 **XML Sitemap 文件** 或 `<link>` 标签告知搜索引擎有关网站的结构信息。

### 用途

1. **帮助搜索引擎抓取**：通过 Sitemap，搜索引擎可以了解网站的重要页面并优先抓取这些内容。
2. **支持大规模网站**：对于拥有数百或数千页面的大型网站，Sitemap 能确保所有页面（包括深层次页面）被索引。
3. **动态内容跟踪**：帮助搜索引擎识别动态生成的 URL 或最近更新的内容。
4. **国际化支持**：多语言站点可以通过 Sitemap 提供语言版本映射。
5. **改善索引效率**：确保搜索引擎不会遗漏任何页面。

### XML Sitemap 示例

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <!-- Homepage -->
    <url>
        <loc>https://www.example.com/</loc>
        <lastmod>2025-01-01</lastmod>
        <changefreq>daily</changefreq>
        <priority>1.0</priority>
    </url>
    <!-- Subpage -->
    <url>
        <loc>https://www.example.com/about</loc>
        <lastmod>2025-01-01</lastmod>
        <changefreq>weekly</changefreq>
        <priority>0.8</priority>
    </url>
</urlset>
```

### 在 HTML 中引用 Sitemap

可以通过 `<link>` 标签告知搜索引擎 Sitemap 的位置：

```html
<link rel="sitemap" type="application/xml" title="Sitemap" href="sitemap.xml">
```

### 提交 Sitemap

- 将生成的 Sitemap 文件上传到网站的根目录，例如 `https://www.example.com/sitemap.xml`。
- 登录搜索引擎工具（如 Google Search Console），并提交 Sitemap 的 URL。

如果需要了解如何为您当前的 HTML 页面生成或应用 Sitemap，请告诉我！

要获取 `sitemap` 的内容，可以通过工具生成或直接在代码中指定。以下是获取 `sitemap` 的方式和一个示例实现：

### 更新 HTML 文件以包含 Sitemap 的声明

在 `<head>` 中加入 `<link>` 元素以指向 Sitemap 文件：

```html
<link rel="sitemap" type="application/xml" title="Sitemap" href="sitemap.xml">
```

## 生成sitemap

- [Sitemap生成器：10款强大的站点地图工具推荐](https://seoasoorm.com/zh/sitemap-generator/#:~:text=10款Sitemap生成器：助您轻松创建完美站点地图 1 1. Screaming Frog SEO Spider（桌面软件） 2,Simple XML Sitemap（Drupal模块） 8 8. SureOak（线上工具） More items)

### 自动生成 Sitemap 示例

可以使用动态工具生成 Sitemap 或手动添加一个静态 `sitemap.xml` 文件。以下是 XML 格式的 Sitemap 示例：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>https://www.example.com/</loc>
        <lastmod>2025-01-01</lastmod>
        <changefreq>daily</changefreq>
        <priority>1.0</priority>
    </url>
    <url>
        <loc>https://www.example.com/#introduction</loc>
        <lastmod>2025-01-01</lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.8</priority>
    </url>
    <url>
        <loc>https://www.example.com/#text-formatting</loc>
        <lastmod>2025-01-01</lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.7</priority>
    </url>
    <url>
        <loc>https://www.example.com/#media</loc>
        <lastmod>2025-01-01</lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.7</priority>
    </url>
    <url>
        <loc>https://www.example.com/#tables</loc>
        <lastmod>2025-01-01</lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.6</priority>
    </url>
    <url>
        <loc>https://www.example.com/#forms</loc>
        <lastmod>2025-01-01</lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.6</priority>
    </url>
</urlset>
```

- **`<loc>`**: 页面 URL。
- **`<lastmod>`**: 最后修改时间（可选）。
- **`<changefreq>`**: 内容更新频率（可选）。
- **`<priority>`**: 优先级（范围 0.0 到 1.0，可选）。

将此文件保存为 `sitemap.xml` 并放置在网站的根目录。

### 提交 Sitemap

1. 将生成的 `sitemap.xml` 上传至您的服务器根目录。
2. 通过工具（如 Google Search Console）提交 Sitemap 地址，通常是 `https://www.example.com/sitemap.xml`。