[toc]





# abstract

## 官方文档

- [config-sample|Configuration Reference | ChatGPT Learn](https://learn.chatgpt.com/docs/config-file/config-sample)
- [OpenAI开发者|config-reference](https://developers.openai.com/codex/config-reference)
- [模型目录|learn.chatgpt.com/docs/config-schema.json](https://learn.chatgpt.com/docs/config-schema.json)

汉化中文版:

- [Codex 配置参考 | 配置键与选项](https://www.codex-docs.com/docs/config-file/config-reference)
- [示例配置 | 配置文件 | ChatGPT 文档 --- Sample Configuration | Config file | ChatGPT Docs](https://www.codex-docs.com/en/docs/config-file/config-sample)

## 接入第三方api

Codex 接入第三方 API 时，真正决定能不能用的核心只有四件事：

1. `model_provider` 必须与 `[model_providers.<id>]` 的 `<id>` **完全一致**；
2. `base_url` 必须是第三方提供的 **Responses API 根地址**；
3. `model` 必须是第三方实际接受的 **精确模型 ID**；
4. 必须配置正确的鉴权方式，第三方中转通常应使用 `env_key`，而不是 `requires_openai_auth = true`。

> 尤其要注意：当前 Codex 只支持 `wire_api = "responses"`，旧的 `wire_api = "chat"` 已被移除。因此，一个中转站即使号称“兼容 OpenAI API”，但如果只实现了 `/chat/completions`，仍然不能直接供新版 Codex 使用。([GitHub](https://github.com/openai/codex/blob/main/codex-rs/model-provider-info/src/lib.rs))
>
> 可以考虑使用cc switch进行兼容.

### 第三方供应商和参考文档

- [接入 Codex | DeepSeek API Docs](https://api-docs.deepseek.com/zh-cn/quick_start/agent_integrations/codex)
- [Codex CLI 集成 - OpenRouter --- Codex CLI Integration - OpenRouter](https://openrouter.ai/docs/cookbook/coding-agents/codex-cli)

### 身份认证和auth块配置🎈

最简单的配置方案是使用`env_key`字段:

```toml
env_key = "OPENROUTER_API_KEY"
```

虽然简单的 `env_key = "OPENROUTER_API_KEY"` 也可用于身份验证，但 Codex 在这种模式下，不会获取 OpenRouter **模型目录**(model_catalog)。

| Key                                         | Type / Values | Details                               |
| ------------------------------------------- | ------------- | ------------------------------------- |
| `model_providers.<id>.env_key`              | `string`      | 提供商 API 密钥所在的环境变量。       |
| `model_providers.<id>.env_key_instructions` | `string`      | 提供商 API 密钥的可选设置说明。(可选) |

非 OpenAI 模型将会 显示“未知模型”备用元数据警告。建议使用**基于命令行的方法**。

```toml
[model_providers.openrouter]
name = "openrouter"
base_url="https://openrouter.ai/api/v1"

[model_providers.openrouter.auth]
command = "sh"
args = ["-c", "echo $OPENROUTER_API_KEY"]
```

从云端获取**模型目录**(model_catalog)

| Key                                 | Type / Values   | Details                                                      |
| ----------------------------------- | :-------------- | :----------------------------------------------------------- |
| `model_providers.<id>.auth.command` | `string`        | Codex 需要 Bearer Token 时要**运行的命令**。该命令必须将 Token 输出到 **stdout**。 |
| `model_providers.<id>.auth.args`    | `array<string>` | 传递给 Token 获取命令的参数。                                |

`[model_providers.openrouter.auth]`：定义 Codex 如何获取 API 密钥。

> `command = "sh"`、`args = ["-c", "echo $OPENROUTER_API_KEY"]`：Codex 会执行 `sh -c "echo $OPENROUTER_API_KEY"`，从环境变量 `OPENROUTER_API_KEY` 中读取密钥作为认证凭据。

这种"命令式"认证方式（而非简单的 `env_key = "OPENROUTER_API_KEY"`）会**触发 Codex 拉取 OpenRouter 的模型目录**，使非 OpenAI 模型显示正确的元数据，否则会出现 "Unknown model" 的回退警告。效果如下:

- Codex 通过实际执行一条 shell 命令来"取"密钥，而不是静态读取变量名。
- 这种动态取值方式会顺带触发 Codex 向 OpenRouter 请求模型目录，从而获得各模型的真实元数据。
- 结果：非 OpenAI 模型能正确显示名称、能力等信息，不再出现 "Unknown model" 警告。

## 基本配置模板🎈

此外，`model_provider` 和 `model_providers` 应放在用户级：

```text
~/.codex/config.toml
```

> 不要放在项目目录的 `.codex/config.toml` 中，因为当前 Codex 会**忽略项目级配置里的 provider 和鉴权相关字段**。

最小可用配置示例如下:

```toml
# profile.toml配置模板
# 1. model_provider = "provider-id"  # 使用批量替换而不是仅替换第一个位置,可以自定义,后续引用保持一致即可
# 2. model = "model-id" # 要求严格,只能填写供应商提供的可用模型型号名称
# 3. base_url="" # 要求严格,按供应商提供的url填写.

# provider-id
model_provider = "provider-id" 

# 上下文(未必要用满,例如对于1M=1000k上下文,可以仅用到258k,防止大上下文高收费);
# 请设置models-catalog.json中的上下文窗口参数,这里不负责该部分配置(例如模型名称自定义和思考深度)

# 其他
preferred_auth_method = "apikey"
forced_login_method = "api"
# 安全和权限配置
## cli_auth_credentials_store = "file" # auto,file,keyring

# 默认的:workspace-write,读取整个电脑上的文件,但修改仅限当前 Workspace（打开的项目）
## sandbox_mode = "workspace-write" # read-only,workspace-write,danger-full-access

## 默认的询问策略是on-request,模型自己判断是否询问用户,untrusted,大部分危险操作都询问
# approval_policy = "never" # 永远不要弹确认框(yolo模式)。如果权限允许：直接执行。如果权限不允许：立即失败。

# 模型配置
model = "model-id" # 例如:gpt-5.6-luna
model_reasoning_effort = "low" # low medium high xhigh max
show_raw_agent_reasoning = true # 显示原始推理

# OpenRouter 的 command auth 可在联网环境刷新官方目录;
# 这里同时提供确定性本地元数据,避免目录刷新失败时回退为无元数据。
# 注意,必须在默认配置config.toml中设置auth.command方式才有效,在-p 参数中指定配置不生效.
# model_catalog_json = "/home/opcxxu/.codex/openrouter-models.json"

# 工具配置(网络搜索)
web_search=live # disabled | cached | indexed | live(实时性)

# 供应商配置
[model_providers.provider-id]
name = "provider-id" 
base_url = "" # 记得填写,否则提示builder error这类错误,更不可能配置成功.
wire_api = "responses"
requires_openai_auth = true # openai 风控时可能需要此配置,和其读取auth.json配置与否有关.(如果接入非openai模型,可以不配置)

# 按需设置下面的属性,这些配置在model_providers.<id>块下,不能单独移到前面去!
## 如果是主配置文件profile.toml,则下面的env_key可以不设置,可以通过配置.codex/auth.json中写入密钥代替,但是灵活度不高
## 将密钥配置在shell或系统的环境变量中(变量名和这里配置的值对应),这样启动codex时指定profile后,能够读同名的环境变量作为api key.(而不是直接将密钥填写在此.toml配置文件中,这看起来有点繁琐,但是更加安全.)
env_key = "API_KEY" # 多配置用户记得修改此处
# experimental_bearer_token = "" # 密钥不推荐直接填写,优先考虑使用env_key;如果确实要集中用配置文件的方式管理,考虑在本地目录(主要安全,不要放在git可以提交的目录中)中创建一个类似于 ~/.config/model_credentials.local.env

## 这里的环境变量名取值要和env_key的取值要相同
env_key_instructions = "请设置env_key配置字段所指的环境变量名取值来提供密钥." 
# supports_websockets = false 

# 其他验证(密钥传递)方式: 参考openrouter 配置的元数据块,信息更完善,代替env_key(不同系统平台使用不同的shell,command和args数组上有差异)
## windows powershell
# [model_providers.<provider-id>.auth]
# command = "powershell"
# args = ["-NoProfile", "-Command", "Write-Output $env:OPENROUTER_API_KEY"]

## unix shell
# [model_providers.<provider-id>.auth]
# command = "sh"
# args = ["-c", "echo $OPENROUTER_API_KEY"]
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

# 配置项可以分成三类

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



# OpenRouter 推荐配置

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

------

# 中转站必须满足的兼容性要求

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

# 接入前的两个测试

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

