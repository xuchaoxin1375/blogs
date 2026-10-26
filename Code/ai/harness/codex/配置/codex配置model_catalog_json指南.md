[toc]





## model_catalog_json 对第三方模型至关重要

Codex CLI 内置了一份 GPT 系模型的目录(catalog),内部记录了每个模型的能力位(能力开关)、上下文窗口、工具类型、推理等级、系统提示等。

当你把 `model` 指到一个 **非 GPT 的第三方模型**(如 GLM、Qwen、DeepSeek、MiniMax、MiMo、Kimi、Claude、Gemini 等)时:

- 如果 Codex 找不到匹配的条目,它会用 **最长前缀匹配(longest prefix matching)** 去猜一个最接近的 ModelInfo 作为回退。当请求某个 model slug 时,ModelsManager 会在缓存列表中根据最长匹配的 slug 前缀来解析出最合适的 ModelInfo。
- 猜错的后果:发送模型不支持的 `reasoning.effort` 字段导致报错、上下文窗口按 GPT-5 的默认值裁剪、工具调用形态不匹配、`/model` 面板里显示为 "custom" 甚至无从切换。

`model_catalog_json` 就是让你**替换**这份内置目录的正式扩展口。注意关键词是"替换":catalog 是"替换"而不是"合并"。model_catalog_json 会替换整个模型列表,而不是追加(实测:目录里只写 2 个模型,codex debug models 就只显示这 2 个,所有内置 gpt-5.x 模型都会消失)。如果你想两类都保留,就把它们一起写进自定义目录里。

---

## 三层目录合并模型:先搞清楚加载顺序

Layer 3 — 本地覆盖。`model_catalog_json` 配置键指向一个在启动时加载的本地 JSON 文件。这一层**优先于内置的和远程的模型目录**。

```mermaid
flowchart LR
    A["内置目录<br>(编译进二进制)"] --> B["远程刷新<br>(启动时拉取)"]
    B --> C["本地覆盖<br>(model_catalog_json)"]
    C --> D["运行时模型视图"]
    D --> E["会话使用"]
```

排查建议: `codex debug models` 子命令会打印三层合并后的原始模型目录 JSON。

`codex debug models --bundled` 标志跳过刷新只打印编译进去的目录,对定位刷新相关的差异非常有用。

Profile 层还能做进一步覆盖:Profile 文件也可以覆盖 model_catalog_json;当基础 config 和 profile 都设置了这个值时,Codex 使用 profile 中的值。

---

## 顶层文件结构

一个最小合法的 catalog 文件长这样:

```json
{
  "models": [
    { "slug": "...", "display_name": "...", "...": "..." }
  ]
}
```

`models` 是一个数组,每个元素描述一个模型条目(ModelInfo)。下面逐字段解释。

---

## ModelInfo 字段全景表

以下字段名和类型综合自 Codex 官方 `codex-rs/models-manager/models.json`、SDK 类型定义和主流第三方接入指南。**必须使用 snake_case**——解析报告 unknown variant。目录 JSON 里有个字段名或值是 Codex 不认识的(常见于 camelCase 的老格式,比如 displayName/hidden)。改用本文的 snake_case 字段集。

### 标识与展示类(几乎必填)

| 字段               | 类型                          | 作用                                              | 备注                                        |
| ------------------ | ----------------------------- | ------------------------------------------------- | ------------------------------------------- |
| `slug`             | string                        | 模型唯一 ID,`config.toml` 的 `model =` 必须匹配它 | 建议与 provider 上游 API 的 model name 一致 |
| `display_name`     | string                        | `/model` 面板显示名                               |                                             |
| `description`      | string                        | 一句话描述                                        | 出现在 `/model` 详情                        |
| `visibility`       | enum: `list` / `hidden` / ... | 是否在 `/model` 里可选                            | 想给普通用户看就写 `list`                   |
| `priority`         | integer                       | 排序权重(越小越靠前)                              | 常用模型给 0                                |
| `supported_in_api` | boolean                       | 通过 API 而非 ChatGPT 订阅时是否可用              | 第三方接入固定 `true`                       |

slug / display_name:Codex 配置和 /model 列表中使用的模型标识和显示名。保持它与 API 使用的 model name 一致。

### 推理等级(reasoning effort)——第三方模型最容易踩坑的地方

| 字段                           | 类型                                               | 作用                                   |
| ------------------------------ | -------------------------------------------------- | -------------------------------------- |
| `default_reasoning_level`      | enum: `none` / `low` / `medium` / `high` / `xhigh` | 默认推理档                             |
| `supported_reasoning_levels`   | array<{effort, description}>                       | `/model` 里可切换的档位清单            |
| `supports_reasoning_summaries` | boolean                                            | 是否走 Responses API 的 reasoning 分支 |
| `default_reasoning_summary`    | enum: `auto` / `none` / ...                        | 是否请求推理摘要                       |
| `reasoning_summary_format`     | enum                                               | 摘要格式(纯文本/Markdown)              |

关键行为:supports_reasoning_summaries 启用 Codex 针对该模型的 Responses API reasoning 路径。设为 true 后 Codex 会发送 reasoning.effort;否则即便配置了 default_reasoning_level,Codex 也会省略 reasoning 字段。

对于**根本不支持 thinking 的模型**(如很多本地 Ollama 模型),必须显式关掉:两个关键字段是 supported_reasoning_levels: [] 和 supports_reasoning_summaries: false。否则 Codex 会发送一个 thinking 参数,而 Ollama 会以 "does not support thinking" 拒绝。

对于**只有"开/关"两档思考**的模型(如 MiniMax、MiMo),约定俗成的写法是只保留 `none` 和 `high`:

```json
"supported_reasoning_levels": [
  { "effort": "none", "description": "Think-Off" },
  { "effort": "high", "description": "Deep" }
]
```
对 MiniMax-M3,任何非 none 的值都会启用 Adaptive Thinking;具体值并不会调节推理深度。supported_reasoning_levels 是用户在 /model 中可切换的推理选项。none 关掉思考;high 启用 Adaptive Thinking。

对于**多档位模型**(如通义千问系列),可以完整定义 low/medium/high/xhigh:参考 QwenCloud 样例——supported_reasoning_levels 中三档:low "Fast responses with lighter reasoning"、medium "Greater reasoning depth for complex problems"、xhigh "Extra high reasoning depth for complex problems"。

### 上下文窗口

| 字段                               | 类型             | 作用                       |
| ---------------------------------- | ---------------- | -------------------------- |
| `context_window`                   | integer (tokens) | 有效上下文上限             |
| `max_context_window`               | integer          | 硬上限(通常等于上者)       |
| `effective_context_window_percent` | integer 1-100    | 留出 buffer 的比例,常见 95 |
| `auto_compact_token_limit`         | integer          | 触发自动压缩的阈值         |

注意:`config.toml` 里的 `model_context_window` 会**再覆盖一层**该模型条目里的窗口大小——第三方 provider 常用它来做保险,例如 MiniMax 官方示例就用 `model_context_window = 1000000`。config.toml 中示例:model = "MiniMax-M3", model_provider = "minimax", model_context_window = 1000000, [model_providers.minimax] base_url = "https://api.minimax.io/v1", wire_api = "responses"。

### 工具调用形态(tool shape)——决定命令能不能执行

| 字段                             | 类型                              | 作用                                    |
| -------------------------------- | --------------------------------- | --------------------------------------- |
| `shell_type`                     | `shell_command` / `default` / ... | shell 工具的 schema 形态                |
| `apply_patch_tool_type`          | 枚举 / null                       | 是否使用 `apply_patch` 补丁工具及其形态 |
| `supports_parallel_tool_calls`   | boolean                           | 是否允许一次并发发起多个 tool call      |
| `experimental_supported_tools`   | array<string>                     | 白名单式启用实验工具                    |
| `supports_search_tool`           | boolean                           | 是否具备原生 web_search 工具            |
| `input_modalities`               | array<string>                     | `text` / `image` / ...                  |
| `supports_image_detail_original` | boolean                           | 是否支持原始分辨率图片                  |
| `truncation_policy`              | object `{ mode, limit }`          | 工具输出截断策略                        |

对国产/开源模型的经验值:
- 大多数第三方模型**不支持并发工具调用**,应写 `"supports_parallel_tool_calls": false`(如 MiMo 官方示例即如此)。MiMo 示例含 "supports_parallel_tool_calls": false, "context_window": 1048576, "input_modalities": ["text"], "supports_search_tool": false。
- 兼容 OpenAI Chat Completions 但对 `apply_patch` 结构化补丁支持不佳的模型,把 `shell_type` 设为 `"shell_command"`,让 Codex 用普通 shell 命令跑 `apply_patch` 而不是 native tool。
- `truncation_policy` 常用 `{ "mode": "bytes", "limit": 10000 }`,防止一次 tool output 撑爆上下文。

### 系统提示与行为

| 字段                     | 类型                   | 作用                                       |
| ------------------------ | ---------------------- | ------------------------------------------ |
| `base_instructions`      | string                 | Codex 追加的系统提示(定义 Agent 角色/风格) |
| `minimal_client_version` | string                 | 该模型最低要求的 Codex 版本                |
| `upgrade`                | string / object / null | 让 UI 提示升级到某个更好模型               |
| `availability_nux`       | object / null          | 首次使用引导(NUX = New User Experience)    |

base_instructions:Codex 使用此模型时追加的基础系统提示。用它来描述模型身份和协作风格。

提示:第三方接入通常把 `base_instructions` 写成 "You are Codex, a coding agent based on <你的模型名>. Your knowledge cutoff date is <日期>."。也可以复制内置模型的完整 prompt,只改身份句——脚本只覆盖每个模型独有的字段(slug、display_name、description、context_window 等);其他必需字段都从内置模板克隆——正好是上文的字段集,只是 base_instructions 用官方完整 prompt。生成文件较大(每条包含完整 base_instructions,大约 1-2 MB),这是正常的。

### SDK 层面的完整类型参考

以 Elixir SDK 中的类型别名为例(可看作字段的权威清单)——model_info 包含:slug、display_name、description、default_reasoning_level、supported_reasoning_levels、shell_type、visibility、minimal_client_version、supported_in_api、priority、upgrade、base_instructions、supports_reasoning_summaries、support_verbosity、default_verbosity、apply_patch_tool_type、truncation_policy、supports_parallel_tool_calls、context_window、reasoning_summary_format、experimental_supported_tools。

---

## 一个"最小可用"的第三方模型条目(推荐骨架)

面向"OpenAI Chat/Responses 兼容 + 单档思考开关 + 无图像 + 无并发工具"的常见国产模型,骨架如下:

```json
{
  "models": [
    {
      "slug": "your-model-slug",
      "display_name": "Your Model",
      "description": "Third-party model via OpenAI-compatible API",

      "visibility": "list",
      "supported_in_api": true,
      "priority": 0,

      "default_reasoning_level": "high",
      "supported_reasoning_levels": [
        { "effort": "none", "description": "Disable Thinking" },
        { "effort": "high", "description": "Enable Thinking" }
      ],
      "supports_reasoning_summaries": true,
      "default_reasoning_summary": "none",
      "support_verbosity": false,

      "shell_type": "shell_command",
      "supports_parallel_tool_calls": false,
      "experimental_supported_tools": [],
      "input_modalities": ["text"],
      "supports_search_tool": false,
      "truncation_policy": { "mode": "bytes", "limit": 10000 },

      "context_window": 262144,
      "max_context_window": 262144,
      "effective_context_window_percent": 95,

      "base_instructions": "You are Codex, a coding agent based on Your Model. Your knowledge cutoff date is 2024-12.",

      "availability_nux": null,
      "upgrade": null
    }
  ]
}
```

对应的 `~/.codex/config.toml` 侧要点(以 MiniMax 官方为例)——model = "MiniMax-M3", model_provider = "minimax", model_context_window = 1000000, [model_providers.minimax] name = "MiniMax", base_url = "https://api.minimax.io/v1", experimental_bearer_token = "<MINIMAX_API_KEY>", wire_api = "responses"。

以及 catalog 指针:向 ~/.codex/config.toml 添加:model_catalog_json = "~/.codex/model-catalogs/custom-catalog.json"。

---

## 场景化"字段档案"(按模型类型给推荐值)

下表是不同类型第三方模型的推荐字段值,直接照抄能规避 80% 的坑。

| 字段                           | 无思考的本地/开源模型<br>(Ollama、通用 Chat 模型) | 单档思考开关模型<br>(MiniMax M3、MiMo v2.5) | 多档思考模型<br>(Qwen 系、GLM 深度思考) | Anthropic/Gemini 转译代理 |
| ------------------------------ | ------------------------------------------------- | ------------------------------------------- | --------------------------------------- | ------------------------- |
| `default_reasoning_level`      | `"low"`                                           | `"high"`                                    | `"medium"`                              | `"medium"`                |
| `supported_reasoning_levels`   | `[]`                                              | `[none, high]`                              | `[low, medium, high, xhigh]`            | `[low, medium, high]`     |
| `supports_reasoning_summaries` | `false`                                           | `true`                                      | `true`                                  | 视代理而定,通常 `true`    |
| `default_reasoning_summary`    | `"none"`                                          | `"none"`                                    | `"none"` 或 `"auto"`                    | `"none"`                  |
| `shell_type`                   | `"shell_command"`                                 | `"shell_command"`                           | `"shell_command"` 或 `"default"`        | `"shell_command"`         |
| `supports_parallel_tool_calls` | `false`                                           | `false`                                     | `false`                                 | `true`(Claude 支持)       |
| `input_modalities`             | `["text"]`                                        | `["text"]`                                  | `["text", "image"]`(若模型支持)         | 视模型                    |
| `context_window`               | 模型实际值(如 262144)                             | 1000000 左右                                | 900k-1M                                 | 200k-1M                   |
| `wire_api`(在 config.toml)     | `"chat"`                                          | `"responses"`                               | `"responses"`                           | `"chat"`                  |

无思考模型的最短组合来自实际实测——两个关键字段是 supported_reasoning_levels: [] 和 supports_reasoning_summaries: false。否则 Codex 会发送 thinking 参数,而 Ollama 会以 "does not support thinking" 拒绝。

---

## 常见问题与排错

### 报 `missing field` 或 `unknown variant`

先运行 codex debug models。如果它报 missing field...(最常见——缺必填字段)或 unknown variant...就说明字段名或枚举值错了。步骤:

1. `codex debug models --bundled` 打印内置目录,拿来当模板;
2. 找到内置某个 GPT 模型条目,**复制字段集**再改值;
3. 保持 snake_case,不要写 `displayName`、`hidden` 之类旧驼峰键。

### `/model` 里只显示一两个模型,其他消失

因为 catalog 是"替换"关系。要么把所有想要的都写进你的自定义目录,要么改用 profile-scoped `model_catalog_json` 只在特定 profile 里替换。

### 桌面 App 只显示 "custom" 或没有模型名

如果 codex debug models 已经能看到所有模型,但 Desktop App 只显示一两个而且当前模型显示为 "custom" —— 这是 Desktop App 的已知 bug:它在本地目录之上又叠加了一层 official-slug 白名单过滤,把非官方模型从选择器里去掉了(见 GitHub Issues #19694、#15138)。模型实际上仍按 config.toml 中的 model = "..." 正常调用(可以在 AIHubMix 日志中确认);只是名字显示不出来。要正确显示,请用终端 codex CLI / TUI;在 Desktop App 上你只能在 config.toml 中硬编码 model = "想用的模型" 然后等官方修复。

### 修改后 `/model` 没变

Codex 会在启动时读一次 catalog,并把远端结果缓存到 `models_cache.json`——刷新行为由 RefreshStrategy 枚举控制。models_cache.json 中包含 fetched_at 时间戳,决定 TTL 新鲜度。缓存包含 client_version 字段,存储写入缓存时的 API 客户端版本。当 ModelsManager 加载缓存时,会验证缓存版本是否与运行中二进制的 client_version 一致。如果版本不同,缓存被视为过时。所以改完记得:退出所有会话再重启 Codex,必要时 `codex debug models --bundled` 对比。

补充:只退出 TUI 不一定生效,配置由宿主进程在启动时读取一次。

| 宿主 | 何时读配置 | 怎么做 |
| --- | --- | --- |
| `codex` TUI / `codex exec` | 进程启动 | 退出重开;要完全隔离用 `codex --no-daemon` |
| 共享 app-server daemon | daemon 启动 | `codex app-server daemon restart`;`stop` 也行,下次自动拉起 |
| VSCode 扩展 | 扩展自己的 app-server 启动 | `Developer: Reload Window`,或直接关窗口 |
| Desktop App | 应用内 app-server 启动 | 完全退出(含托盘)再启动 |

判断当前有没有 daemon:跑 `codex app-server daemon version`。报连接失败说明没有,退出 TUI 重开即可;有输出说明 daemon 还活着,只重开 TUI 仍会用旧配置。改前改后各跑一次,看运行版本或启动时间是否变化即可确认换新。残留 socket 让该命令报错时先 `daemon restart`,仍不行再按 PID 结束那一个 `codex.exe`,不要批量杀。

### 用了新模型仍报错

这些模型可能尚未进入内置目录:Codex CLI 老版本 默认模型表里只有老模型。运行 /model 看不到新模型,直接在 `config.toml` 里写 model = "新模型" 会报错。

**扩展注册表**的官方方式是通过**模型目录**配置文件 `model-catalog.json`。——**同样的机制也适用于第三方新模型**,你需要给它写一条 catalog 条目。

### 托管 web_search 不生效:先查 use_responses_lite

0.164.0 实测。现象:profile 里已经写了 `web_search = "live"`,但模型从没发起过搜索,回答靠 shell `curl` 抓网页。

原因不只在 `web_search` 开关,还在目录条目的 `use_responses_lite`。该字段为 `true` 时请求走 Responses Lite:整份工具清单被挪进 `input[]` 的 `additional_tools` 条目,顶层 `tools` 为空或省略,托管 `web_search` 根本不出现。第三方网关通常只实现 `/v1/responses` 的顶层 `tools`,也没有 `/v1/alpha/search`,于是搜索静默失效。

---

判定(三层,由软到硬):

1. 配置层:`codex -c model_catalog_json='"/abs/<profile>-models.json"' debug models`,看该 slug 的 `use_responses_lite`。
2. 请求层:把 `base_url` 临时指向本地回显代理跑一次 `codex exec`,看 `/v1/responses` 请求。Lite 生效时请求头带 `x-openai-internal-codex-responses-lite: true`、顶层无 `tools`、`parallel_tool_calls: false`;关掉后这三项反过来。
3. 行为层:`codex exec --json "<时效问题>"` (例如"google下个月可能要推出什么产品/服务 相关爆料"),输出里应出现 `"type":"web_search"` 的 item 事件(之所以这里指定`json`格式输出,是其能够比较清楚的看到工具调用时间),最终回答带 `url_citation`。

---

修法:目录里该条改 `"use_responses_lite": false`,顶层保持 `web_search = "live"`,完全退出后重启。

用 `--clone-from` 克隆旗舰骨架会把 `true` 一起继承,合成后要显式改回。网关须原样透传顶层 `tools`;透传后上游仍拒收,按上游拒收处理关搜索或换 MCP 搜索。

负对照:`web_search = "disabled"` 时顶层 `tools` 应无 `web_search`,搜索事件消失;改回 `live` 恢复。回滚删掉 `model_catalog_json` 或把字段改回 `true`。`codex --search` 只在 TUI 生效,`codex exec` 不接受该参数。

证据来源:字段取值见官方 `models.json`;Lite 把工具挪进 `additional_tools`、省略顶层 `tools` 见 openai/codex#32086(源码 `codex-rs/core/src/client.rs`)。公开配置文档未描述这层影响,以上结论来自抓包对照。

顺带修正:上面字段表把 `supports_search_tool` 写成"是否具备原生 web_search 工具",实际它管的是延迟工具发现(MCP / app 扩展的 `tool_search`),与托管搜索无关。

#### codex --json 发起搜索测试

```shell
 codex exec --json --skip-git-repo-check  "不使用任何skill,直接做一次简单一次性的搜索:新兴的爬虫管理框架"
```



```json
{
    "type": "item.started",
    "item": {
        "id": "item_5",
        "type": "web_search",
        "id": "ws_08ced15d6a537d93016ade9ff0d34887d18eeba72208810dad",
        "query": "",
        "action": {
            "type": "other"
        }
    }
}
{
    "type": "item.completed",
    "item": {
        "id": "item_5",
        "type": "web_search",
        "id": "ws_08ced15d6a537d93016ade9ff0d34887d18eeba72208810dad",
        "query": "开源 爬虫管理 平台 新兴 Crawlab Crawlee Scrapling",
        "action": {
            "type": "search",
            "query": "开源 爬虫管理 平台 新兴 Crawlab Crawlee Scrapling",
            "queries": [
                "开源 爬虫管理 平台 新兴 Crawlab Crawlee Scrapling",
                "open source crawler orchestration management framework 2026 scheduling monitoring GitHub"
            ]
        }
    }
}
{
    "type": "item.completed",
    "item": {
        "id": "item_6",
        "type": "agent_message",
        "text": "这轮搜索（2026-10-26）里，**Estela 最贴近“爬虫管理平台”这个需求**：集中部署、调度和监控爬虫。([estela.dev](https://estela.dev/?utm_source=openai))\n\n| 项目 | 定位与主要能力 | 适合关注的场景 |\n|---|---|---|\n| **Estela** | 开源爬虫编排平台，支持自托管，覆盖部署、调度和监控 | 希望统一管理多个爬虫任务。([estela.dev](https://estela.dev/open-source?utm_source=openai)) |\n| **mocra** | Rust 分布式采集框架，支持定时任务、中间件、单机与分布式运行，内置只读监控面板 | 想把采集、调度和观测集成到代码里。([docs.rs](https://docs.rs/crate/mocra/latest?utm_source=openai)) |\n| **Crawlab**（对照候选） | 多语言分布式爬虫管理平台，支持节点、任务、定时调度、结果导出和通知 | 已有 Python、Node.js 等不同技术栈的爬虫，需要统一管理。([github.com](https://github.com/crawlab-team/crawlab?utm_source=openai)) |\n\n按需求初筛，我会先看 **Estela**；偏 Rust 开发则看 **mocra**。这是一次搜索的候选清单，尚未核验发布时间、近期维护情况或实际部署体验。"
    }
}
{
    "type": "turn.completed",
    "usage": {
        "input_tokens": 153568,
        "cached_input_tokens": 101248,
        "cache_write_input_tokens": 0,
        "output_tokens": 1161,
        "reasoning_output_tokens": 391
    }
}
```

#### 在codex内部要求自检网络搜索能力

**测试1**

**User**

> 不使用skills,也不需要实际请求,你能看到有这个工具吗?我还想指导工具列表.

**Assistant**

> 能看到，当前会话有 **`web.run`** 工具，支持搜索和网页访问。没有单独名为 `web_search` 的工具，搜索通过 `web.run` 的 `search_query` 参数调用。
>

当前可见的工具按用途分为：

| 类别       | 工具 / 功能                                                |
| ---------- | ---------------------------------------------------------- |
| 网络搜索   | `web.run → search_query`                                   |
| 网页访问   | `web.run → open、click、find`                              |
| 图片与截图 | `web.run → image_query、screenshot`（截图限 PDF）          |
| 专项查询   | 天气、金融行情、体育、时间、计算器                         |
| 本地执行   | `functions.exec`，可调用终端命令、文件补丁、查看本地图片等 |
| 交互       | 用户输入请求工具                                           |
| 多代理协作 | 创建代理、发送任务、等待结果等                             |
| 等待       | `functions.wait`、`clock.sleep`                            |

**测试2**

**User**

> 不用任何skills,你检查一下能否**看到**`web_search`这类工具吗? 能否尝试调用一次

**Assistant**

> 我会检查当前工具列表，并实际调用一次搜索来确认可用性。
> • Browsing the web
> • Searched the web for OpenAI
> 能看到，也能实际调用。本次未使用任何 skills。
>
> - 工具名是 web.run，通过 search_query 参数执行联网搜索。
> - 刚才已搜索 OpenAI，成功返回结果。
> - 当前没有看到独立名为 web_search 的工具；对应搜索能力由 web.run 提供。
> - 同一工具还支持打开网页（open）、点击链接（click）、查找文本（find）等操作

#### app-server daemon后端服务版本对齐

`npm` install的codex cli版本在这方面有同步更新的设计缺口.

社区已经多次报告了这个问题，并指出理想情况下 CLI 升级后应当自动检测版本不匹配并触发 daemon 更新，但目前的行为是：升级 CLI 并不保证会更新 managed app-server。官方文档也承认，对于 brew/npm 等包管理器安装方式，daemon“不会自动将运行中的 app-server 迁移到更新的二进制文件上”。

所以，你遇到的情况是当前版本的一个已知局限。要解决它，需要手动执行 `codex app-server daemon update --from-cli`（将当前 CLI 的版本复制给 daemon）并重启，或者确保 daemon 的自动更新机制在正确的前提下被启用。

> 直接手动更新可能会失败(国内网络问题)

```shell
$ codex app-server daemon update

Error: failed to fetch standalone Codex updater: error sending request for url (https://chatgpt.com/codex/install.sh): client error (Connect): tcp connect error: Operation timed out (os error 110)
^CError: failed to connect to /home/opcxxu/.codex/app-server-control/app-server-control.sock
```

使用`--frome-cli`或许可以,但是这会锁定版本.

```shell
codex app-server daemon update --from-cli
```

混用 npm CLI 和 daemon 管理命令的根源，在于安装方式与 daemon 的设计假设不匹配。

> 官方 daemon 的自动更新和生命周期管理，是围绕 `install.sh` 独立安装 + `bootstrap` 来设计的。如果你需要 daemon 的稳定版本管理，可以考虑改用官方独立安装方式：

```shell
# 如果能访问 install.sh，用它安装(或者配置一下网络代理)
curl -fsSL https://chatgpt.com/codex/install.sh | sh

# 然后用新安装的 codex 执行 bootstrap
~/.codex/packages/standalone/current/codex app-server daemon bootstrap --remote-control
```

这样 daemon 就会带有内置的更新循环，后续 CLI 升级时版本脱节的问题会减轻很多。但前提是你需要先解决 `chatgpt.com` 的访问问题。如果网络环境确实无法直连，你可能需要为 daemon 的更新流程配置代理，或者接受手动管理版本的现状。

#### 彻底重启codex

即便正确更改完所有配置,如果重新进入codex也可能因为后台服务没有重启而新配置不生效.

> 以linux系统为例

```shell
pgrep -fl codex #查看codex进程/服务
pkill codex #结束codex相关进程/服务
codex #重新启动

```

也可以仅尝试

```shell
codex app-server daemon restart # 重启服务
```



---

## 最佳实践 Checklist

- **一开始就克隆内置模板**:`codex debug models --bundled > baseline.json`,再改字段。这样能自动获得所有当前版本要求的必填字段。
- **保持 slug 与上游 API model 名一致**:避免同时维护映射;`/model` 切换和 API 调用是同一个名字。
- **给 provider 里所有想暴露的模型都写进同一个 catalog**:替换语义决定了不能"只加不减"。
- **`base_instructions` 里明确写"You are Codex, a coding agent based on <本模型>"**:很多开源模型会说自己是 GPT,替换身份声明可以缓解此类幻觉。
- **`supports_reasoning_summaries` 一定要与模型能力匹配**:不支持 thinking 的模型必须关掉,否则 400/500 满天飞。
- **`shell_type: "shell_command"`是保守可用选项**:让 Codex 通过 shell 执行 `apply_patch` 而不是走 native tool,兼容性最好。
- **`supports_parallel_tool_calls` 默认写 false**:绝大多数第三方 Chat/Responses 兼容层都不支持真正的并发工具调用。
- **用 profile 隔离实验**:把新加的第三方目录挂在 `~/.codex/experimental.config.toml` 的 `model_catalog_json` 上,用 `codex --profile experimental` 试跑,不污染主配置。在 profile 文件中示例:model_catalog_json = "/Users/me/.codex/model-catalogs/deep-review.json",然后 codex --profile deep-review。
- **改完必重启**:模型解析在启动期发生,热改无效。各宿主的分层动作、判定证据与常见"假重启"见 [codex@配置生效与重启指南](codex@配置生效与重启指南.md)。
- **持续对齐官方**:官方文档:Advanced Configuration|Configuration Reference;官方内置目录格式参考:codex-rs/models-manager/models.json。

---

## 关键概念速记

- **Catalog(目录)**:模型元数据 JSON 的总称,决定 `/model` 列表能力位。
- **Slug**:模型 ID,用于配置匹配和 API 调用。
- **Longest Prefix Matching(最长前缀匹配)**:找不到精确 slug 时的回退策略,是"意外用了错误能力位"的元凶。
- **Reasoning Effort(推理力度)**:`none/low/medium/high/xhigh` 五档枚举,通过 Responses API 的 `reasoning.effort` 传给模型。
- **Wire API(线路协议)**:`chat`(Chat Completions)或 `responses`(Responses API),在 `config.toml` 的 provider 段配置,与 catalog 中 `supports_reasoning_summaries` 需要匹配。
- **Provider-owned Discovery(提供方自发现)**:自 v0.125.0 起,模型 provider 自行拥有模型发现。这意味着每个 provider 可以向客户端暴露其可用模型和账户状态。对于像 AWS Bedrock 这样的 provider,你可能不需要手动写 catalog。

---

## 参考资料与知识截止

- OpenAI 官方仓库 `openai/codex` 中的 `codex-rs/models-manager/models.json`(权威字段清单与内置模板)
- OpenAI Developers 站点:*Sample Configuration* 和 *Advanced Configuration*
- DeepWiki 对 `models-manager` 模块的源码级说明
- 第三方接入官方指南:MiniMax、Xiaomi MiMo、QwenCloud、AIHubMix、QCode 等
- 社区实践:dalenguyen 关于本地 Ollama 接入的记录
- `openai/codex` issue #32086:Responses Lite 把整份工具清单挪进 `additional_tools` 并省略顶层 `tools`(附源码位置 `codex-rs/core/src/client.rs`)
- 社区实践:WangChuDi/codex-enable-web-search-catalog,用 `model_catalog_json` 关掉 Responses Lite 以恢复托管 web_search

**总体知识截止**:本文所依据的公开资料时间点最新至 **2026 年 8 月**;字段命名与行为以 Codex CLI **0.125.x** 为主要参照。由于该字段集会随版本演进,请以你本机的 `codex debug models --bundled` 输出与 GitHub 上对应 tag 的 `models.json` 为最终事实来源。其中 `use_responses_lite` 一节为后续增补,以 CLI **0.164.0** 实测为准。