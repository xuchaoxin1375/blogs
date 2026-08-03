[toc]





# 一、abstract

## 官方文档

- [config-sample|Configuration Reference | ChatGPT Learn](https://learn.chatgpt.com/docs/config-file/config-sample)
- [Codex 配置参考 | 配置键与选项](https://www.codex-docs.com/docs/config-file/config-reference)

## 接入第三方api

Codex 接入第三方 API 时，真正决定能不能用的核心只有四件事：

1. `model_provider` 必须与 `[model_providers.<id>]` 的 `<id>` **完全一致**；
2. `base_url` 必须是第三方提供的 **Responses API 根地址**；
3. `model` 必须是第三方实际接受的 **精确模型 ID**；
4. 必须配置正确的鉴权方式，第三方中转通常应使用 `env_key`，而不是 `requires_openai_auth = true`。

> 尤其要注意：当前 Codex 只支持 `wire_api = "responses"`，旧的 `wire_api = "chat"` 已被移除。因此，一个中转站即使号称“兼容 OpenAI API”，但如果只实现了 `/chat/completions`，仍然不能直接供新版 Codex 使用。([GitHub](https://github.com/openai/codex/blob/main/codex-rs/model-provider-info/src/lib.rs))
>
> 可以考虑使用cc switch进行兼容.

## 基本配置模板

此外，`model_provider` 和 `model_providers` 应放在用户级：

```text
~/.codex/config.toml
```

> 不要放在项目目录的 `.codex/config.toml` 中，因为当前 Codex 会**忽略项目级配置里的 provider 和鉴权相关字段**。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

最小可用配置示例如下:

```toml
# profile.toml配置模板
# 1. model_provider = "provider-id"  # 使用批量替换而不是仅替换第一个位置,可以自定义,后续引用保持一致即可
# 2. model = "model-id" # 要求严格,只能填写供应商提供的可用模型型号名称
# 3. base_url="" # 要求严格,按供应商提供的url填写.

# provider-id
model_provider = "provider-id" 
# 安全和权限配置
## cli_auth_credentials_store = "file" # auto,file,keyring

# 默认的:workspace-write,读取整个电脑上的文件,但修改仅限当前 Workspace（打开的项目）
## sandbox_mode = "workspace-write" # read-only,workspace-write,danger-full-access

## 默认的询问策略是on-request,模型自己判断是否询问用户,untrusted,大部分危险操作都询问
approval_policy = "never" # 永远不要弹确认框。如果权限允许：直接执行。如果权限不允许：立即失败。

# 模型配置
model = "model-id" # 例如:gpt-5.6-luna
model_reasoning_effort = "low" # low medium high xhigh max

[model_providers.provider-id]
name = "provider-id" 
base_url = "" # 记得填写
wire_api = "responses"

# 按需设置下面的属性,这些配置在model_providers.<id>块下,不能单独移到前面去!
## 如果是主配置文件profile.toml,则下面的env_key可以不设置,可以通过配置.codex/auth.json中写入密钥代替,但是灵活度不高
## 将密钥配置在shell或系统的环境变量中(变量名和这里配置的值对应),这样启动codex时指定profile后,能够读同名的环境变量作为api key.(而不是直接将密钥填写在此.toml配置文件中,这看起来有点繁琐,但是更加安全.)
env_key = "API_KEY" 
# experimental_bearer_token = "" # 密钥不推荐直接填写,优先考虑使用env_key
## 这里的环境变量名取值要和env_key的取值要相同
env_key_instructions = "请设置env_key配置字段所指的环境变量名取值来提供密钥." 
supports_websockets = false 

# requires_openai_auth = true
```



## 常用字段和可用值

### sandbox_mode 

| 值                 | 能读 | 能写      |
| ------------------ | ---- | --------- |
| read-only          | 全部 | 无        |
| workspace-write    | 全部 | Workspace |
| danger-full-access | 全部 | 全部      |

### approval_policy 

| 值         | 是否询问                 |
| ---------- | ------------------------ |
| untrusted  | 大部分危险操作询问       |
| on-request | 模型判断是否询问（推荐） |
| never      | 从不询问                 |
| on-failure | 已废弃                   |

## 最小配置模板

> 以uuapi为例





------

# 二、配置项可以分成三类

## 第一类：名称可以自定义，但引用必须完全一致

例如：

```toml
model_provider = "uuapi"

[model_providers.uuapi]
```

这里的 `uuapi` 是你自己定义的 provider ID，可以改成：

```toml
model_provider = "abc"

[model_providers.abc]
```

但上下必须一致，建议视为**大小写敏感**。

下面这种写法也能表示一个自定义 provider：

```toml
model_provider = "OpenAI"

[model_providers.OpenAI]
```

但不推荐，因为容易和 Codex 内置的、小写的 `openai` 混淆。内置的 `openai`、`ollama`、`lmstudio` 是保留 ID，不能用自定义 provider 覆盖。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

推荐使用：

```toml
model_provider = "uuapi"

[model_providers.uuapi]
```

或者：

```toml
model_provider = "openrouter"

[model_providers.openrouter]
```

------

## 第二类：字段名固定，取值必须准确无误

包括：

```toml
base_url
model
wire_api
env_key
requires_openai_auth
supports_websockets
model_reasoning_effort
```

这些值不是随便写的。特别是 `base_url` 和 `model`，必须按照第三方服务商的实际接口填写。

------

## 第三类：可以自行调优，但不能超出模型真实能力

包括：

```toml
review_model
model_context_window
model_auto_compact_token_limit
request_max_retries
stream_max_retries
stream_idle_timeout_ms
```

它们可以自行设置，但错误设置会造成上下文溢出、过早或过晚压缩、长时间卡住等问题。

------

# 三、逐项解释你的配置

你的原始配置是：

```toml
model_provider = "OpenAI"
model = "gpt-5.5"
review_model = "gpt-5.5"
model_reasoning_effort = "xhigh"

disable_response_storage = true

network_access = "enabled"
windows_wsl_setup_acknowledged = true

model_context_window = 1000000
model_auto_compact_token_limit = 900000

[model_providers.OpenAI]
name = "OpenAI"
base_url = "https://uuapi.net"
wire_api = "responses"
supports_websockets = true
requires_openai_auth = true

[features]
responses_websockets_v2 = true
```

## 1. `model_provider = "OpenAI"`

作用：选择使用哪个 provider。

它必须对应：

```toml
[model_providers.OpenAI]
```

所以你的上下引用是一致的，理论上可以工作。

但是建议修改为：

```toml
model_provider = "uuapi"

[model_providers.uuapi]
```

因为 `OpenAI` 在这里只是自定义 ID，并不代表请求会直接发送给 OpenAI。真正决定请求去向的是 `base_url`。

------

## 2. `model = "gpt-5.5"`

作用：指定主模型。

这个值会原样或近似原样发送给第三方服务商，所以必须使用第三方认可的模型 ID。Codex 官方配置本身接受字符串形式的模型名，例如 `gpt-5.5`。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

但不同平台格式不同：

直接 OpenAI 或某些中转可能使用：

```toml
model = "gpt-5.5"
```

OpenRouter 使用：

```toml
model = "openai/gpt-5.5"
```

OpenRouter 当前列出的准确模型 ID 就是 `openai/gpt-5.5`。([OpenRouter](https://openrouter.ai/openai/gpt-5.5?utm_source=chatgpt.com))

所以对 UUAPI 而言，必须确认它到底接受：

```text
gpt-5.5
```

还是：

```text
openai/gpt-5.5
```

或者它自己定义的渠道别名。

------

## 3. `review_model = "gpt-5.5"`

作用：执行 Codex 的 `/review` 命令时，指定代码审查模型。

它是**可选项**。如果不填写，Codex 默认使用当前会话模型。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

因此下面两种都可以：

```toml
model = "gpt-5.5"
review_model = "gpt-5.5"
```

或者直接省略：

```toml
model = "gpt-5.5"
```

只有想让代码审查使用其他模型时才有必要设置，例如：

```toml
model = "openai/gpt-5.5"
review_model = "openai/gpt-5.5-pro"
```

但 `review_model` 通常仍然通过当前选定的 provider 请求，不能仅靠这一行切换到另一个 provider。

------

## 4. `model_reasoning_effort = "xhigh"`

作用：指定模型推理强度。

当前 Codex 官方允许：

```text
minimal
low
medium
high
xhigh
```

其中 `xhigh` 是否生效取决于模型本身；不支持时，第三方可能忽略、降级，或者直接返回参数错误。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

因此：

```toml
model_reasoning_effort = "xhigh"
```

字段和值的拼写是正确的。

但它要求：

- 模型支持 reasoning；
- 中转站能够转发 reasoning 参数；
- Responses API 实现没有删除或错误转换该参数。

初次调试时建议先用：

```toml
model_reasoning_effort = "high"
```

确认正常后再切换到 `xhigh`，这样更容易区分是接口问题还是推理参数问题。

------

## 5. `disable_response_storage = true`

这是一个需要特别注意的字段。

当前 Codex 正式配置参考和示例配置中已经不再列出 `disable_response_storage`，因此不要依赖它来保证第三方“不保存数据”。现有版本可能忽略它，也可能仅为旧版本兼容字段。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

更重要的是，即使 Codex 请求中设置了类似 `store: false`，也只能表达“不要由上游 API 保存响应”，无法阻止中转站自行记录：

- 请求日志；
- 完整提示词；
- API Key；
- 工具调用内容；
- 返回结果；
- IP 和设备信息。

OpenRouter 的数据保留需要通过 OpenRouter 自身的隐私设置或 ZDR 策略控制，而不是依靠 Codex 的这个旧字段。([OpenRouter](https://openrouter.ai/docs/guides/features/zdr?utm_source=chatgpt.com))

因此可删除：

```toml
disable_response_storage = true
```

至少不要把它当作隐私保证。

------

## 6. `network_access = "enabled"`

这一行不建议继续使用：

```toml
network_access = "enabled"
```

当前正式配置中，工作区沙箱的联网权限写法是：

```toml
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = true
```

这里是布尔值 `true`，而不是字符串 `"enabled"`。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

如果你想启用 Codex 自带的网页搜索，则是另一个配置：

```toml
web_search = "live"
```

可选值包括：

```text
disabled
cached
indexed
live
```

([OpenAI开发者](https://developers.openai.com/codex/config-reference))

这三个概念不要混淆：

- `base_url`：Codex 连接模型 API；
- `[sandbox_workspace_write].network_access`：Codex 执行的命令能否联网；
- `web_search = "live"`：是否允许模型使用实时网页搜索工具。

模型 API 本身是否能够连接，不由顶层 `network_access = "enabled"` 决定。

------

## 7. `windows_wsl_setup_acknowledged = true`

这是 Windows 专用的引导状态记录：

```toml
windows_wsl_setup_acknowledged = true
```

它表示用户已经完成或确认 WSL 相关的初始设置提示，不会影响：

- API 地址；
- API 鉴权；
- 模型选择；
- 上下文；
- Responses API。

这是可选项，不使用 Windows 或不需要压制引导提示时可以删除。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

------

## 8. `model_context_window = 1000000`

作用：告诉 Codex 当前模型可使用多少上下文 token。

它不是向服务器申请 100 万上下文，也不会把一个 128K 模型“变成”1M 模型。它只是 Codex 客户端侧的容量声明。官方定义是“当前模型可用的上下文窗口 token 数”。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

因此，这个值必须尽量符合真实能力。

例如 OpenRouter 当前将 GPT-5.5 标注为约 1M 上下文，并列出约 922K 输入和128K 输出容量。([OpenRouter](https://openrouter.ai/openai/gpt-5.5?utm_source=chatgpt.com))

但是对于 UUAPI，你还需要确认：

- 它是否真的提供原生 GPT-5.5；
- 是否支持完整 1M；
- 是否人为限制为 128K、256K 或 400K；
- 是否会截断超长输入；
- 是否有自己的最大请求体限制。

如果真实上限只有 256K，你却设置：

```toml
model_context_window = 1000000
```

Codex 会错误地认为还能继续塞入内容，最终可能在服务端收到：

```text
context_length_exceeded
maximum context length exceeded
request too large
HTTP 400
```

初次接入时，建议先省略这一项，让 Codex 使用模型默认值：

```toml
# model_context_window = 1000000
```

只有确认中转站真实支持后再手动设置。

------

## 9. `model_auto_compact_token_limit = 900000`

作用：当历史上下文达到指定 token 数时，自动压缩会话历史。官方说明是：不设置时使用模型默认阈值。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

你的设置表示：

```text
上下文声明：1,000,000
达到：900,000
开始压缩
```

逻辑上没有语法错误，但 900K 比较激进。

因为上下文里不只有聊天文字，还包括：

- 系统指令；
- AGENTS.md；
- 工具定义；
- shell 输出；
- 文件内容；
- reasoning 数据；
- 历次工具调用；
- 为模型输出预留的 token。

如果平台实际输入上限约为 922K，那么 900K 才压缩，剩余安全空间可能很小。

更稳妥的做法是先省略：

```toml
# model_auto_compact_token_limit = 900000
```

或者在确认确实支持 1M 后，保守设置，例如：

```toml
model_context_window = 1000000
model_auto_compact_token_limit = 800000
```

这里的 `800000` 是安全余量建议，不是官方强制值。

------

## 10. `[model_providers.OpenAI]`

这是自定义 provider 的定义块。

建议改成：

```toml
[model_providers.uuapi]
```

`name` 只是显示名称，可以自由定义：

```toml
name = "UUAPI"
```

它不会参与服务器认证，也不会决定 API 地址。官方源码中该字段只是 friendly display name。([GitHub](https://github.com/openai/codex/blob/main/codex-rs/model-provider-info/src/lib.rs))

------

## 11. `base_url = "https://uuapi.net"`

这是当前配置里风险最大的地方之一。

Codex 当前使用 Responses API，请求目标通常由：

```text
base_url + /responses
```

组成。

所以如果服务商的完整接口是：

```text
https://uuapi.net/v1/responses
```

那么应该填写：

```toml
base_url = "https://uuapi.net/v1"
```

而不是：

```toml
base_url = "https://uuapi.net"
```

OpenRouter 的官方 Codex 配置就是把 API 根地址写为：

```text
https://openrouter.ai/api/v1
```

随后访问其 `/responses` 端点。([OpenRouter](https://openrouter.ai/docs/cookbook/coding-agents/codex-cli))

因此，UUAPI 这行必须按其文档确认。正确判断方式不是看主页，而是确认完整 Responses endpoint 到底是：

```text
https://uuapi.net/responses
```

还是：

```text
https://uuapi.net/v1/responses
```

如果是后一种，就必须加 `/v1`。

------

## 12. `wire_api = "responses"`

这是正确的，而且目前唯一支持的值。

```toml
wire_api = "responses"
```

也可以省略，因为当前默认就是 `responses`。`chat` 已经不再支持。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

因此下面两种等价：

```toml
wire_api = "responses"
```

或者完全不写。

------

## 13. `supports_websockets = true`

它的含义不是“要求 Codex开启 WebSocket”，而是你向 Codex声明：

> 这个第三方 provider 确实支持 Responses API 的 WebSocket 传输。

这个值必须和服务器实际能力一致。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

很多小型中转站只支持：

- 普通 HTTPS；
- SSE 流式返回；
- `/v1/responses`；
- `/v1/chat/completions`。

但不支持 Responses WebSocket。

错误填写：

```toml
supports_websockets = true
```

可能导致：

- 长时间等待 WebSocket 握手；
- 连接后立即断开；
- 多次重试；
- 最后回退到 HTTPS；
- 表现为 Codex 卡住几十秒或数分钟。

对于不确定的中转站，建议：

```toml
supports_websockets = false
```

或者直接省略，因为默认值是 `false`。([GitHub](https://github.com/openai/codex/blob/main/codex-rs/model-provider-info/src/lib.rs))

只有中转站明确写明支持 Codex Responses WebSocket 时才设为 `true`。

------

## 14. `requires_openai_auth = true`

这行通常不适合普通第三方中转站。

它的真实含义是：

> 这个 provider 需要 Codex 使用 OpenAI API Key 或 ChatGPT 登录令牌，并通过 Codex 的 `auth.json` 管理登录状态。

设为 `true` 后，Codex可能展示登录界面，并把登录选择和 token/key 存入 `auth.json`。设为 `false` 时，Codex跳过 OpenAI 登录，改从 `env_key` 指定的环境变量读取第三方 API Key。([GitHub](https://github.com/openai/codex/blob/main/codex-rs/model-provider-info/src/lib.rs))

对于 OpenRouter、UUAPI 和普通中转站，推荐：

```toml
requires_openai_auth = false
env_key = "UUAPI_API_KEY"
```

或者省略 `requires_openai_auth`，因为默认就是 `false`。

然后设置环境变量。

PowerShell：

```powershell
$env:UUAPI_API_KEY="你的API密钥"
```

永久写入用户环境变量：

```powershell
[Environment]::SetEnvironmentVariable(
    "UUAPI_API_KEY",
    "你的API密钥",
    "User"
)
```

Linux、macOS 或 WSL：

```bash
export UUAPI_API_KEY="你的API密钥"
```

`env_key` 的名称可以自定义，但必须和实际环境变量名称完全一致。官方将它定义为“提供 provider API key 的环境变量”。([OpenAI开发者](https://developers.openai.com/codex/config-reference))

------

## 15. `[features] responses_websockets_v2 = true`

当前建议删除：

```toml
[features]
responses_websockets_v2 = true
```

Codex 当前源码已经将 `responses_websockets_v2` 标为移除的旧兼容功能标志，保留主要是为了让旧配置仍能被解析，不应再依赖它控制传输方式。([GitHub](https://github.com/openai/codex/blob/main/codex-rs/features/src/lib.rs))

目前判断 provider 能否使用 WebSocket，主要看：

```toml
supports_websockets = true
```

而不是旧 feature flag。

------

# 四、推荐的 UUAPI 配置

在假定 UUAPI 的 Responses 根地址为 `https://uuapi.net/v1` 的情况下，推荐先使用最保守配置：

```toml
model_provider = "uuapi"
model = "gpt-5.5"
review_model = "gpt-5.5"
model_reasoning_effort = "high"

# Codex 执行命令时的沙箱设置
sandbox_mode = "workspace-write"

# 需要实时网页搜索时启用
web_search = "live"

# Windows 专用，可选
windows_wsl_setup_acknowledged = true

[model_providers.uuapi]
name = "UUAPI"
base_url = "https://uuapi.net/v1"
env_key = "UUAPI_API_KEY"
wire_api = "responses"

# 默认就是 false，明确写出便于阅读
requires_openai_auth = false
supports_websockets = false

[sandbox_workspace_write]
network_access = true
```

先不要写：

```toml
model_context_window = 1000000
model_auto_compact_token_limit = 900000
```

等确认 UUAPI 的真实上下文限制后再添加。

如果 UUAPI 文档明确说明它的 Responses 地址就是：

```text
https://uuapi.net/responses
```

那么才改成：

```toml
base_url = "https://uuapi.net"
```

------

# 五、OpenRouter 推荐配置

OpenRouter 官方 Codex 集成使用 `https://openrouter.ai/api/v1`，并通过 `OPENROUTER_API_KEY` 环境变量鉴权。([OpenRouter](https://openrouter.ai/docs/cookbook/coding-agents/codex-cli))

```toml
model_provider = "openrouter"
model = "openai/gpt-5.5"
review_model = "openai/gpt-5.5"
model_reasoning_effort = "xhigh"

sandbox_mode = "workspace-write"
web_search = "live"

[model_providers.openrouter]
name = "OpenRouter"
base_url = "https://openrouter.ai/api/v1"
env_key = "OPENROUTER_API_KEY"
wire_api = "responses"
requires_openai_auth = false
supports_websockets = false

[sandbox_workspace_write]
network_access = true
```

设置密钥：

PowerShell：

```powershell
$env:OPENROUTER_API_KEY="sk-or-xxxxxxxx"
```

Linux、macOS 或 WSL：

```bash
export OPENROUTER_API_KEY="sk-or-xxxxxxxx"
```

确认真实使用 OpenRouter 的 GPT-5.5 后，可以选择增加：

```toml
model_context_window = 1000000
model_auto_compact_token_limit = 800000
```

不过优先建议让 Codex 使用模型默认值。

------

# 六、中转站必须满足的兼容性要求

一个中转站想稳定支持新版 Codex，至少应具备：

| 能力                           | 是否关键                                   |
| ------------------------------ | ------------------------------------------ |
| `POST /responses`              | 必须                                       |
| Bearer API Key 鉴权            | 通常必须                                   |
| Responses API 流式 SSE         | 强烈建议                                   |
| function/tool calling          | 必须                                       |
| tool output 回传               | 必须                                       |
| reasoning 参数转发             | 使用推理模型时必须                         |
| 多轮 Responses 消息格式        | 必须                                       |
| 保留 assistant 的 `phase` 字段 | GPT-5.3 Codex、GPT-5.4、GPT-5.5 等建议必须 |
| WebSocket Responses            | 可选                                       |
| `/chat/completions`            | 单独支持它还不够                           |

OpenRouter 明确支持 GPT-5.5 等模型在 Responses API 中使用 `phase` 字段；若中转丢弃该字段，长任务可能提前停止或多轮表现下降。([OpenRouter](https://openrouter.ai/docs/cookbook/evaluate-and-optimize/model-migrations/gpt-5-4?utm_source=chatgpt.com))

所以“能用 curl 调通聊天”不等于“能完整运行 Codex”。有些中转只能返回文字，但在编辑文件、调用 shell、继续多轮工具执行时失败，就是因为 Responses 事件或工具调用格式没有完整实现。

------

# 七、接入前的两个测试

先用第三方 API Key 测试模型列表：

```bash
curl "https://你的域名/v1/models" \
  -H "Authorization: Bearer 你的API密钥"
```

再测试 Responses API：

```bash
curl "https://你的域名/v1/responses" \
  -H "Authorization: Bearer 你的API密钥" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.5",
    "input": "Reply with exactly: OK"
  }'
```

如果第二个接口不存在，而只有：

```text
/v1/chat/completions
```

那么新版 Codex不能直接连接，需要在中间增加一个将 Responses API 转换为 Chat Completions 的适配器。

## 对你这份配置的最终判断

需要修改的重点是：

```toml
model_provider = "uuapi"
base_url = "https://uuapi.net/v1"   # 需按服务商实际接口确认
env_key = "UUAPI_API_KEY"
requires_openai_auth = false
supports_websockets = false
```

建议删除：

```toml
disable_response_storage = true
network_access = "enabled"

[features]
responses_websockets_v2 = true
```

建议暂时注释：

```toml
model_context_window = 1000000
model_auto_compact_token_limit = 900000
```

你原配置最大的问题不是模型名称，而是**鉴权方式、base URL 是否缺少 `/v1`，以及把未知的中转站声明成支持 WebSocket**。