[toc]



# 一、整体采集架构(v0.1)

## 你的目标字段

你只需要这些字段：

- `Name`
- `Categories`
- `Sale price`
- `ImageUrl`
- `Brand`
- `PageUrl`
- `Description`

输出格式：

- **CSV**

采集入口策略：

1. 优先找 **sitemap**
2. 如果没有 sitemap：
   - 分析分类导航
   - 进入分类 / 列表页
   - 提取产品详情页链接
3. 详情页提取字段

采集执行策略：

1. **先试采**
2. 若普通 HTTP 请求可用：
   - 用普通方式抓
   - 适当设置 UA / header
3. 若网站对客户端要求更高：
   - 调用浏览器抓取
   - 尽量模拟真实浏览器环境
4. 若网站对地区 / IP 有要求：
   - 支持代理配置

下面我把它整理成一个**可落地、可复用、适合 Openclaw 的标准方案**。

---

建议你把每个站点的采集流程统一成这 4 层：

---

## 1. 入口发现层
负责找到产品详情页 URL。

优先级：

### A. Sitemap 模式
如果站点有 sitemap：
- 从 sitemap 中拿产品页 URL
- 如果 sitemap 很多，优先识别：
  - product sitemap
  - page sitemap
  - category sitemap

### B. 分类导航模式
如果没有合适的 sitemap：
- 从首页提取导航分类
- 或从菜单提取类目链接
- 遍历分类页、分页页
- 提取产品详情页 URL

---

## 2. 详情采集层
对每个产品详情页采集：

- Name
- Categories
- Sale price
- ImageUrl
- Brand
- PageUrl
- Description

同时做清洗和字段标准化。

---

## 3. 抓取策略层
每个页面访问时按策略执行：

### 模式 1：HTTP
适合：
- HTML 中直接有内容
- 不需要 JS 渲染

### 模式 2：Browser
适合：
- 页面需要 JS
- 普通请求返回不完整 / 空页面
- 需要更像浏览器

### 模式 3：HTTP + Proxy / Browser + Proxy
适合：
- IP 地区限制
- 某些区域不可访问

---

## 4. 输出存储层
把数据统一写成 CSV：

建议字段顺序固定：

```csv
Name,Categories,Sale price,ImageUrl,Brand,PageUrl,Description
```

如果 `Categories` 有多级，建议保存成字符串，比如：

```text
Herramientas > Taladros > Taladros Percutores
```

---

# 二、建议你在 Openclaw 中采用的“站点任务模板”

建议每个网站都按一个统一配置来描述。  
即使 Openclaw 的语法和我下面写的不完全一样，你也可以按这个结构去组织任务。

---

## 站点级配置建议

每个网站配置这些内容：

```yaml
site:
  name: makpoint
  base_url: https://www.makpoint.es/
  allowed_domains:
    - www.makpoint.es

output:
  type: csv
  file: makpoint_products.csv
  fields:
    - Name
    - Categories
    - Sale price
    - ImageUrl
    - Brand
    - PageUrl
    - Description

crawl:
  entry_strategy:
    - sitemap
    - category_navigation

request:
  mode: auto   # auto / http / browser
  timeout: 30
  retry: 2
  delay_ms: 1000
  headers:
    User-Agent: "Mozilla/5.0 ..."
    Accept-Language: "es-ES,es;q=0.9,en;q=0.8"
  proxy: null  # 可配置

browser:
  enabled: true
  headless: true
  wait_until: networkidle
  timeout: 45000
  viewport:
    width: 1366
    height: 768
  locale: es-ES

discovery:
  product_url_patterns:
    - "/"
  category_url_patterns:
    - "/"
  pagination:
    type: next_link

extract:
  fields:
    Name: ...
    Categories: ...
    Sale price: ...
    ImageUrl: ...
    Brand: ...
    Description: ...
```

这类思路的意义是：

- 一个网站一个配置
- 策略清晰
- 以后换站时可复用

---

# 三、推荐的采集执行流程

这部分最关键。  
你可以把 Openclaw 的任务设计成下面这个决策流。

---

## 步骤 1：站点探测

先访问：

- `/robots.txt`
- `/sitemap.xml`
- 首页 `/`

探测结果决定入口策略。

### 目标：
- 是否存在 sitemap
- sitemap 是否能拿到产品页
- 首页是否能解析出导航分类
- 是否普通 HTTP 就能正常访问内容

---

## 步骤 2：试采页面

建议随机抽 1~2 个页面做试采：

- 一个分类页
- 一个产品页

判断：

### 如果普通 HTTP 返回正常 HTML，且关键字段存在：
- 用 `http` 模式

### 如果 HTTP 返回：
- 内容为空
- 重定向异常
- 页面壳但无核心内容
- 价格/描述/分类缺失明显

则升级为：

- `browser` 模式

### 如果返回的是区域限制页 / 403 / 特定国家提示：
启用：

- `proxy`

---

## 步骤 3：产品 URL 发现

按顺序执行：

### 路径 A：Sitemap
1. 读取 `sitemap.xml`
2. 找出：
   - 产品 sitemap
   - 类目 sitemap
3. 收集产品页 URL

### 路径 B：分类导航
1. 抓首页导航菜单
2. 提取分类链接
3. 进入分类页
4. 处理分页
5. 提取产品 URL

### 路径 C：站内搜索 / 特征规则补充
如果部分站点导航不完整，可以补：
- 搜索页
- 品牌页
- 标签页

不过你现在需求简单，先不建议做太复杂。

---

## 步骤 4：产品详情解析

对每个产品详情页：

- 请求页面
- 提取字段
- 清洗数据
- 生成一条 CSV 记录

---

## 步骤 5：保存 CSV
建议：

- 实时追加写入
- 或批量缓冲写入
- 避免任务中断导致全部丢失

同时最好做一个去重键：

- `PageUrl`

如果 URL 中有跟踪参数，先标准化后再写。

---

# 四、你需要的字段提取规则建议

你字段不多，适合做“多策略提取”，即每个字段不是只写一个选择器，而是写一组回退规则。

---

## 1. Name
优先顺序：

1. `meta[property="og:title"]`
2. `h1`
3. 结构化数据 JSON-LD 中的 `name`
4. 页面主产品标题区域

---

## 2. Categories
优先顺序：

1. 面包屑导航 breadcrumb
2. JSON-LD 中的 breadcrumb / category
3. 页面中的分类标签
4. 如果没有则留空

格式建议统一成：

```text
Cat1 > Cat2 > Cat3
```

---

## 3. Sale price
优先顺序：

1. JSON-LD 中的 `offers.price`
2. 价格主区域
3. meta 标签中的 price
4. 嵌入脚本里的商品 JSON

清洗建议：

- 去掉货币符号
- `1.234,56 €` 转成标准数值字符串或统一格式
- 若做 CSV，建议保留原值或统一成 `1234.56`

对西班牙站点尤其要注意：
- 小数符号可能是 `,`
- 千位符可能是 `.`

---

## 4. ImageUrl
优先顺序：

1. `meta[property="og:image"]`
2. 主图 `<img>` 的 `src`
3. `data-src`
4. JSON-LD 中的 `image`
5. JS 数据对象中的主图

如果拿到相对路径，要补全成绝对 URL。

---

## 5. Brand
优先顺序：

1. JSON-LD 中的 `brand`
2. 产品属性表中的品牌字段
3. 页面中品牌标签
4. 没有则空

---

## 6. PageUrl
直接使用最终详情页 URL。  
建议：

- 去掉无关 query 参数
- 保持标准化

---

## 7. Description
优先顺序：

1. 产品详情描述区域
2. JSON-LD 中的 `description`
3. meta description
4. 页面详情 tabs 中的描述内容

清洗建议：
- 去掉多余空白
- 去掉 HTML 标签
- 保留换行或压缩为空格
- 避免把整页无关文本也抓进去

---

# 五、适合 Openclaw 的“自动抓取策略”

你已经提出了一个很实用的思想：**试采后决定抓取模式**。  
这里我帮你把它变成可执行策略。

---

## 模式选择策略

### 模式 A：HTTP 普通请求
适用条件：
- 状态码正常
- 页面 HTML 中有 Name / Price / Description 中至少 2~3 个关键字段
- 页面非空
- 不依赖前端渲染

配置建议：
- 常规浏览器 UA
- Accept-Language
- Referer 适当设置
- 轻量延迟
- 重试

---

### 模式 B：Browser 抓取
触发条件：
- HTTP 返回页面壳
- 关键字段丢失
- 页面依赖 JS 渲染
- 需要真实浏览器环境

浏览器建议：
- headless 模式可先用
- 如果目标站对 headless 敏感，再试非 headless 或更真实环境
- 设置 viewport、语言、时区、UA
- 等待：
  - 主标题出现
  - 或价格节点出现
  - 或 network idle

---

### 模式 C：启用代理
触发条件：
- 返回地区限制页
- 访问被国家限制
- 同样的请求本地不通、代理后可通
- 某些页面 403 / 451 / 地区提示

代理配置建议：
- 在站点级别可配置
- HTTP 与 Browser 都能套用
- 支持按国家切换

---

# 六、建议你在 Openclaw 中做的模块划分

即使 Openclaw 允许你把逻辑写一起，我也建议你分成这些部分：

---

## 1. discover_sitemap
职责：
- 探测并解析 sitemap
- 提取可能的产品链接和类目链接

输出：
- `product_urls`
- `category_urls`

---

## 2. discover_categories
职责：
- 从首页导航提取分类链接
- 进入分类页并翻页
- 提取详情页链接

输出：
- `product_urls`

---

## 3. fetch_product
职责：
- 自动判断 http / browser
- 下载产品页内容

输出：
- `html`
- `final_url`
- `fetch_mode`

---

## 4. parse_product
职责：
- 从页面中解析字段
- 执行清洗、标准化

输出：
- 单条产品记录

---

## 5. export_csv
职责：
- 写入 CSV
- 去重
- 编码处理（建议 utf-8-sig，方便 Excel 打开）

---

# 七、CSV 输出建议

你习惯 CSV，这很好，简单直接。  
建议你注意下面几点。

---

## 1. 字段顺序固定
建议：

```csv
Name,Categories,Sale price,ImageUrl,Brand,PageUrl,Description
```

---

## 2. 编码
建议使用：

- `utf-8-sig`

这样 Excel 打开中文、西语通常更稳。

---

## 3. Description 清洗
描述里可能有：
- 换行
- 引号
- HTML 残留

CSV 写入时要：
- 正确转义双引号
- 统一空白
- 尽量不要手拼字符串，用标准 CSV writer

---

## 4. Categories 格式
统一保存成：

```text
Cat1 > Cat2 > Cat3
```

不要有时数组、有时字符串。

---

## 5. 重复 URL 去重
建议按 `PageUrl` 去重。  
如果 URL 有 query 参数，可先做规范化。

---

# 八、案例

以 https://www.makpoint.es/ 为例，给出具体分析思路

下面用你给的网址举例说明。  
我这里不做“实时联网验证”，而是给你一个**实际应当如何分析并在 Openclaw 里落地**的方案。你可以按这个步骤自己检查网站。

---

## 1. 首先做站点探测

对 `https://www.makpoint.es/`，你先检查：

### A. robots.txt
访问：

```text
https://www.makpoint.es/robots.txt
```

看是否有 sitemap 提示，例如：

```text
Sitemap: https://www.makpoint.es/sitemap.xml
```

---

### B. 常见 sitemap 路径
如果 robots 没写，也尝试：

```text
https://www.makpoint.es/sitemap.xml
https://www.makpoint.es/sitemap_index.xml
https://www.makpoint.es/1_index_sitemap.xml
```

很多站点用 WordPress / WooCommerce / SEO 插件，会有类似：
- `post-sitemap.xml`
- `page-sitemap.xml`
- `product-sitemap.xml`
- `product_cat-sitemap.xml`

如果是电商 CMS，也可能出现产品与分类 sitemap 分离。

---

## 2. 判断站点技术特征

你需要打开首页和一个产品页，观察：

- 是否像 WooCommerce / Prestashop / Shopify / Magento
- HTML 是否直接包含产品信息
- 是否有 JSON-LD 的 `Product` 结构化数据
- 类目是否在导航菜单中
- 产品列表页是否有分页

### 为什么这一步重要？
因为很多电商站的采集难度差异很大：

- **WooCommerce / Prestashop 类站点**：通常 HTML 和 JSON-LD 都比较友好
- **Shopify**：也通常有较稳定结构
- **完全前端渲染站**：可能要浏览器

像 `makpoint.es` 这类独立站，很大概率不是特别难采，通常先试 HTTP 就对了。

---

## 3. 入口策略：优先 sitemap

如果 sitemap 里能直接拿到产品 URL，这是最省事的。

### 理想情况
发现类似：

- `product-sitemap.xml`
- 或 sitemap 中 URL 明显是产品详情页

那你的 Openclaw 流程就可以是：

1. 下载 sitemap
2. 提取产品详情 URL
3. 逐个采集详情页
4. 输出 CSV

这种情况下甚至**不一定需要爬分类页**。

---

## 4. 如果 sitemap 不理想，再走分类导航

### 你要在首页上找什么？
- 顶部主导航菜单
- “Categorías / Tienda / Productos / Marcas”之类入口
- 首页分类模块卡片
- 页脚分类导航

### 分类页上找什么？
- 产品卡片链接
- 分页链接：
  - 下一页按钮
  - page 参数
  - lazy load / load more

### 要提取什么？
- 只提取产品详情页 URL
- 不要在分类页直接输出最终数据，除非它已经有很完整字段

---

# 九、makpoint.es 的推荐采集流程

假设你分析后发现这个站是比较典型的商品站，我建议如下流程：

---

## 方案 1：优先使用 sitemap 的流程

### Step 1
请求：
- `/robots.txt`
- `/sitemap.xml` 或 sitemap index

### Step 2
从 sitemap 中提取：
- 产品 URL
- 如果只有分类 URL，也可进一步爬分类页

### Step 3
对每个产品 URL 做试采：

先 HTTP 请求，并检查以下字段是否存在：
- Name
- Sale price
- ImageUrl
- Description

如果这些字段大部分能从 HTML / JSON-LD 中拿到，就全站使用 HTTP 模式。

### Step 4
解析详情字段并写 CSV

---

## 方案 2：没有可用 sitemap 时的流程

### Step 1
访问首页，提取分类导航链接

### Step 2
遍历每个分类页：
- 解析产品卡片详情链接
- 处理分页

### Step 3
收集产品详情 URL 去重

### Step 4
逐个详情页抓取

---

# 十、makpoint.es 详情页字段提取建议

对于这类商品站，我建议每个字段都采用“多路提取”。

---

## Name
优先尝试：

1. `script[type="application/ld+json"]` 中 `Product.name`
2. 页面主标题 `h1`
3. `meta[property="og:title"]`

---

## Categories
优先尝试：

1. breadcrumb 面包屑
2. JSON-LD breadcrumb
3. 产品分类标签区

输出格式：

```text
Categoria1 > Categoria2 > Categoria3
```

---

## Sale price
优先尝试：

1. JSON-LD `offers.price`
2. 页面价格节点
3. 产品 schema / embedded JSON

注意西班牙格式转换。

---

## ImageUrl
优先尝试：

1. `og:image`
2. JSON-LD `image`
3. 产品主图元素

---

## Brand
优先尝试：

1. JSON-LD `brand.name`
2. 属性表中的“Marca”
3. 页面品牌标签

---

## PageUrl
直接取最终详情页 URL

---

## Description
优先尝试：

1. 产品描述主区域
2. JSON-LD `description`
3. tab 内容
4. meta description

---

# 十一、建议的页面成功判定逻辑

你很适合加一个“页面成功判定”，帮助自动切换 http / browser。

---

## 对产品页定义一个简单评分

比如：

- 有 Name：+1
- 有 Sale price：+1
- 有 ImageUrl：+1
- 有 Description：+1

### 判定规则
- 分数 ≥ 3：HTTP 成功，可继续 HTTP
- 分数 < 3：改用 Browser 重试

这个方式很适合自动化。

---

# 十二、浏览器模式的具体建议

如果某些站点或某些页面需要浏览器，建议配置成如下思路。

---

## 浏览器启动参数建议
- 使用常规桌面浏览器 UA
- 语言设为站点主要语言，如 `es-ES`
- 时区可考虑欧洲地区
- viewport 正常桌面尺寸
- 允许 JS 执行
- 等待关键元素出现

---

## 等待策略
不要只固定 sleep。  
优先：

1. 等 `h1` 出现
2. 等价格区域出现
3. 等主图出现
4. 或等待 network idle

超时后再 fallback。

---

## 何时截图 / 保存源码
浏览器失败时建议保存：
- 截图
- 最终 HTML

这样你能快速判断是：
- 页面没加载出来
- 被拦截
- 地区限制
- 选择器失效

---

# 十三、代理策略建议

你提到有的网站可能对国家 IP 有要求，这很现实。  
建议你在 Openclaw 中把代理作为**站点级可配置项**，而不是写死。

---

## 代理配置层级建议

### 默认不启用
大多数站直接采，不增加成本。

### 针对站点启用
例如：

```yaml
proxy:
  enabled: true
  type: http
  host: xxx
  port: xxx
  username: xxx
  password: xxx
  country: ES
```

### 对 Browser 与 HTTP 都可生效
避免两套配置分裂。

---

## 代理启用触发条件
- 访问返回地区限制页
- 某地区 IP 可访问，本地 IP 不可访问
- 频繁 403 且确认不是代码问题

---

# 十四、推荐你做的“站点配置模板”

你可以给每个网站建立一个配置文档，大概长这样：

```yaml
site_name: makpoint
base_url: https://www.makpoint.es/

entry:
  use_sitemap_first: true
  sitemap_urls:
    - https://www.makpoint.es/sitemap.xml
  category_start_urls:
    - https://www.makpoint.es/

fetch:
  mode: auto
  timeout: 30
  retries: 2
  delay_ms: 1000
  headers:
    User-Agent: Mozilla/5.0 ...
    Accept-Language: es-ES,es;q=0.9,en;q=0.8
  proxy:
    enabled: false

browser:
  enabled: true
  headless: true
  wait_for:
    - h1
    - .price
  timeout: 45000

selectors:
  product_link:
    - a[href*="/producto/"]
    - .product-item a
  pagination_next:
    - a.next
    - .pagination a.next

fields:
  Name:
    - jsonld.Product.name
    - css:h1
    - css:meta[property="og:title"]@content

  Categories:
    - breadcrumb
    - jsonld.BreadcrumbList

  Sale price:
    - jsonld.Product.offers.price
    - css:.price

  ImageUrl:
    - css:meta[property="og:image"]@content
    - jsonld.Product.image
    - css:.product-image img@src

  Brand:
    - jsonld.Product.brand.name
    - xpath://*[contains(text(),'Marca')]/following-sibling::*

  Description:
    - css:.product-description
    - jsonld.Product.description
    - css:meta[name="description"]@content
```

这个模板非常适合你这种“字段较少、以 CSV 为目标”的需求。

---

# 十五、一个非常适合你的实际工作流

我建议你以后每个站都按这个顺序做：

---

## 第 1 步：站点分析
记录：
- 是否有 sitemap
- 产品页 URL 规则
- 分类页 URL 规则
- 是否需要浏览器
- 是否需要代理
- 字段提取位置

---

## 第 2 步：试采产品页
测试：
- HTTP 是否能拿到字段
- 如果不行，再试浏览器

---

## 第 3 步：确定入口
- sitemap 可用 → 直接跑 sitemap
- sitemap 不可用 → 跑导航 / 分类页

---

## 第 4 步：跑少量样本
先抓：
- 10 个产品页
- 验证 CSV 输出是否干净

---

## 第 5 步：放大规模
再跑全站或目标类目。

---

# 十六、给你的最终建议：最适合你的默认策略

基于你的需求，我建议你的 Openclaw 默认策略就是：

---

## 默认策略
### 1. 先找 sitemap
如果有产品页 sitemap，优先用它。

### 2. 没 sitemap 就走分类页
从首页导航进入分类页，处理分页，提取产品 URL。

### 3. 产品页先 HTTP
加正常 UA、Accept-Language、Referer，进行试采。

### 4. 关键字段不足时切 Browser
如果 Name / Price / Description / ImageUrl 缺失过多，则切浏览器。

### 5. 出现区域限制时启用代理
代理必须是站点级可配置项。

### 6. 最终统一输出 CSV
字段固定，格式统一，去重后写入。

---

# 十七、如果你接下来要真正开始做，我建议先做 makpoint.es 的这份任务清单

你可以按这个 checklist 执行：

---

## makpoint.es 任务清单

### A. 探测
- [ ] 请求 `/robots.txt`
- [ ] 查找 sitemap
- [ ] 请求 sitemap index
- [ ] 判断是否有产品 sitemap

### B. 产品页试采
- [ ] 找一个产品页
- [ ] HTTP 请求
- [ ] 检查 Name / Sale price / ImageUrl / Description
- [ ] 如失败，改 Browser 请求

### C. 入口策略确定
- [ ] 若 sitemap 有产品 URL，走 sitemap
- [ ] 否则抓首页分类导航
- [ ] 分类页翻页提取产品 URL

### D. 详情页解析
- [ ] Name
- [ ] Categories
- [ ] Sale price
- [ ] ImageUrl
- [ ] Brand
- [ ] PageUrl
- [ ] Description

### E. 清洗
- [ ] 类目拼接成字符串
- [ ] 价格格式统一
- [ ] ImageUrl 补全绝对路径
- [ ] Description 去 HTML / 去多余空白

### F. 输出
- [ ] CSV 编码 utf-8-sig
- [ ] 按 PageUrl 去重
- [ ] 实时写入或分批写入

### G. 异常
- [ ] HTTP 失败重试
- [ ] Browser 失败截图
- [ ] 保存失败页面 HTML

---

如果你愿意，下一条我可以直接继续帮你做两件非常具体的事，任选一个：

### 1. 给你写一份 **makpoint.es 的 Openclaw 采集配置草案**
包括：
- sitemap 发现
- 分类页发现
- 产品字段提取策略
- CSV 输出结构

### 2. 给你写一份 **“通用商品站 Openclaw 模板”**
以后你换站，只改域名、选择器和几个配置项就能复用。

如果你希望更实用一点，我建议你下一条直接让我做：  
**“请给我一份 makpoint.es 的 Openclaw 配置草案”**。