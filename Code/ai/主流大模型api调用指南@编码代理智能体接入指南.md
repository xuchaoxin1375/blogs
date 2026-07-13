[toc]



# OpenAI、Anthropic、Gemini API 与编码工具接入指南

**调查时间：2026 年 7 月 10 日。**
模型名称、预览功能和接口兼容范围变化较快，生产系统应把模型 ID、Base URL 和能力开关配置化，不要写死在业务代码中。

## 一、核心结论

目前三家的主接口已经形成三种不同路线：

| 平台          | 新项目首选接口          | 主要 SDK       | 默认环境变量        | 核心特点                                       |
| ------------- | ----------------------- | -------------- | ------------------- | ---------------------------------------------- |
| OpenAI        | Responses API           | `openai`       | `OPENAI_API_KEY`    | 统一文本、多模态、工具、MCP、状态与流式事件    |
| Anthropic     | Messages API            | `anthropic`    | `ANTHROPIC_API_KEY` | Content Blocks、工具调用、思考块、提示缓存     |
| Gemini        | Interactions API        | `google-genai` | `GEMINI_API_KEY`    | 新一代统一交互接口；仍保留 generateContent     |
| Gemini 兼容层 | OpenAI Chat Completions | `openai`       | `GEMINI_API_KEY`    | 修改 API Key、Base URL、模型名即可迁移部分应用 |

OpenAI 已明确建议直接模型调用使用 Responses API；Anthropic 的核心仍是 Messages API；Gemini 已将 Interactions API 作为新项目推荐接口，而 `generateContent` 被标为旧接口但仍受支持。Gemini 还提供 OpenAI Chat Completions 兼容入口。([OpenAI 开发者](https://developers.openai.com/api/docs/guides/text?utm_source=chatgpt.com))

最重要的一点是：

> **“OpenAI 兼容”通常只意味着某些请求字段和返回字段相似，并不代表 Responses、工具调用、流式事件、思考内容、缓存、文件接口和编码代理全部兼容。**

------

# 二、三家官方 API 调用

## 1. OpenAI API

### 推荐接口

```text
POST https://api.openai.com/v1/responses
Authorization: Bearer $OPENAI_API_KEY
```

Responses API 使用 `input` 作为主要输入，可以返回文本消息、函数调用、工具结果等结构化输出；官方 SDK 提供 `response.output_text` 便捷属性。OpenAI 当前文档的新示例均优先采用 Responses API。([OpenAI 开发者](https://developers.openai.com/api/docs/quickstart?utm_source=chatgpt.com))

### Python 最小示例

```python
from openai import OpenAI

client = OpenAI()  # 自动读取 OPENAI_API_KEY

response = client.responses.create(
    model="gpt-5.6",
    input="分析这个项目可能存在的性能问题。"
)

print(response.output_text)
```

### REST 示例

```bash
OPENAI_API_KEY=""
curl https://api.openai.com/v1/responses \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.6",
    "input": "一句话介绍你自己。"
  }'
```

### 多轮状态

有两种方式：

```python
response2 = client.responses.create(
    model="gpt-5.6",
    previous_response_id=response1.id,
    input="把它改成异步版本。"
)
```

或者由应用自己保存完整输入历史。前者方便，后者更容易跨供应商迁移和控制数据生命周期。

### 适合编码代理的功能

Responses API 更适合编码代理，因为它原生组织以下输出：

- 文本消息；
- 函数调用；
- Shell、Apply Patch 等工具；
- 远程 MCP；
- 推理配置；
- 流式事件；
- 对话状态与压缩。

OpenAI 官方 Codex 也将 Responses 作为自定义模型供应商唯一支持的 wire protocol。([OpenAI 开发者](https://developers.openai.com/codex/config-reference))

------

## 2. Anthropic Claude API

### 核心接口

```text
POST https://api.anthropic.com/v1/messages
x-api-key: $ANTHROPIC_API_KEY
anthropic-version: 2023-06-01
```

Anthropic 使用 Messages API。响应的 `content` 是内容块数组，而不只是一个字符串，可能包括：

- `text`
- `tool_use`
- `thinking`
- 其他新增内容块

官方 SDK 会自动读取 `ANTHROPIC_API_KEY`。([Claude Platform](https://platform.claude.com/docs/en/get-started?utm_source=chatgpt.com))

### Python 最小示例

```python
import anthropic

client = anthropic.Anthropic()

message = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=2048,
    system="你是一名资深软件架构师。",
    messages=[
        {
            "role": "user",
            "content": "分析微服务系统中分布式事务的实现方案。"
        }
    ]
)

for block in message.content:
    if block.type == "text":
        print(block.text)
```

### REST 示例

```bash
ANTHROPIC_API_KEY=""
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{
    "model": "claude-sonnet-4-6",
    "max_tokens": 2048,
    "messages": [
      {
        "role": "user",
        "content": "检查以下代码的并发安全问题。"
      }
    ]
  }'
```

### 与 OpenAI 格式的主要区别

1. 系统指令通常放在顶层 `system`，而不是普通 `messages` 项。
2. `max_tokens` 通常需要显式给出。
3. 响应文本位于 `content[]` 内容块内。
4. 工具调用使用 `tool_use` 和 `tool_result` 内容块。
5. 多轮调用通常由客户端重新发送历史消息。
6. Claude 的思考块、签名、缓存断点等不能简单映射为普通文本。

因此，不应只写：

```python
message.content[0].text
```

生产代码应遍历内容块并按 `type` 分发。

------

## 3. Gemini API

## 新项目：Interactions API

Google 当前将 Interactions API 作为最简单、功能最新的调用方式；官方推荐使用 `google-genai` SDK。([Google AI for Developers](https://ai.google.dev/gemini-api/docs/get-started?utm_source=chatgpt.com))

### Python 示例

```python
from google import genai

client = genai.Client()  # 自动读取 GEMINI_API_KEY

interaction = client.interactions.create(
    model="gemini-3.5-flash",
    input="解释一个编译器从源代码到机器码的主要步骤。"
)

print(interaction.output_text)
```

### REST 示例

```bash
GEMINI_API_KEY=""
curl -X POST \
  "https://generativelanguage.googleapis.com/v1beta/interactions" \
  -H "x-goog-api-key: $GEMINI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-3.5-flash",
    "input": "解释一个编译器从源代码到机器码的主要步骤。"
  }'
```

## 旧项目：generateContent

`generateContent` 仍然可用，很多现有库和示例仍使用：

```python
from google import genai

client = genai.Client()

response = client.models.generate_content(
    model="gemini-3.5-flash",
    contents="生成一个 FastAPI 项目结构。"
)

print(response.text)
```

Google 已将其称为 legacy API，并建议新应用优先使用 Interactions API。([Google AI for Developers](https://ai.google.dev/gemini-api/docs/generate-content/get-started?utm_source=chatgpt.com))

## 其他提供商

### agens-ai.com

```shell
# git-bash 中调用可能会失败,这可能是UA问题
YOUR_API_KEY=""
curl https://apihub.agnes-ai.com/v1/chat/completions \
-H "Authorization: Bearer $YOUR_API_KEY" \
-H "Content-Type: application/json" \
-d '{
    "model": "agnes-2.0-flash",
    "messages": [
      {
        "role": "user",
        "content": "你好！"
      }
    ]
  }'
```



------

# 三、Gemini 的 OpenAI 兼容接口

Gemini 官方提供 OpenAI Chat Completions 兼容入口：

```text
https://generativelanguage.googleapis.com/v1beta/openai/
```

Python 中只需替换三个位置：

```python
import os
from openai import OpenAI

client = OpenAI(
    api_key=os.environ["GEMINI_API_KEY"],
    base_url="https://generativelanguage.googleapis.com/v1beta/openai/",
)

response = client.chat.completions.create(
    model="gemini-3.5-flash",
    messages=[
        {"role": "system", "content": "你是一名编码助手。"},
        {"role": "user", "content": "写一个异步任务队列。"},
    ],
)

print(response.choices[0].message.content)
```

官方当前示例使用的是 `chat.completions.create`，而不是 OpenAI Responses API。因此，已有的 Chat Completions 应用容易迁移，但依赖 Responses API、OpenAI 内置工具、Responses 流式事件或 `previous_response_id` 的系统不能假定直接兼容。([Google AI for Developers](https://ai.google.dev/gemini-api/docs/openai))

------

# 四、兼容三家接口的第三方 API

## 1. OpenAI 兼容型接口

这是目前最普遍的第三方格式。典型调用模式是：

```python
from openai import OpenAI

client = OpenAI(
    api_key="第三方密钥",
    base_url="第三方 Base URL",
)

response = client.chat.completions.create(
    model="第三方模型 ID",
    messages=[{"role": "user", "content": "Hello"}],
)
```

主要供应商如下。

| 供应商       | Base URL 示例                                              | 主要兼容范围                             | 编码代理注意点                       |
| ------------ | ---------------------------------------------------------- | ---------------------------------------- | ------------------------------------ |
| Azure OpenAI | `https://资源名.openai.azure.com/openai/v1/`               | Responses、Chat Completions              | `model` 往往是部署名称               |
| Gemini       | `https://generativelanguage.googleapis.com/v1beta/openai/` | 主要是 Chat Completions                  | 不应假定完整 Responses 兼容          |
| OpenRouter   | `https://openrouter.ai/api/v1`                             | Chat、部分 Responses、Anthropic Messages | 需要检查具体模型及上游能力           |
| Together AI  | `https://api.together.ai/v1`                               | Chat、Responses、工具、图像等部分接口    | 一些 OpenAI 参数被忽略或返回形态不同 |
| Groq         | `https://api.groq.com/openai/v1`                           | Chat，另有测试中的 Responses             | Responses 能力取决于具体模型         |
| DeepSeek     | `https://api.deepseek.com`                                 | OpenAI 和 Anthropic 两种格式             | 思考字段和多轮回传方式需特别处理     |

### Azure OpenAI

Azure 当前提供 `/openai/v1/` 风格端点，并推荐 OpenAI 模型使用 Responses API：

```python
from openai import OpenAI
import os

client = OpenAI(
    api_key=os.environ["AZURE_OPENAI_API_KEY"],
    base_url="https://YOUR-RESOURCE.openai.azure.com/openai/v1/",
)

response = client.responses.create(
    model="YOUR_DEPLOYMENT_NAME",
    input="检查当前项目的测试覆盖率。"
)
```

Azure 中 `model` 可能需要填写 Azure 部署名称，而不是公共模型别名；不同区域、部署和 API 版本的能力也可能不同。([Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/responses?utm_source=chatgpt.com))

### OpenRouter

OpenRouter 提供统一的多模型入口，常见调用为：

```python
from openai import OpenAI
import os

client = OpenAI(
    api_key=os.environ["OPENROUTER_API_KEY"],
    base_url="https://openrouter.ai/api/v1",
)

response = client.chat.completions.create(
    model="provider/model-name",
    messages=[{"role": "user", "content": "Review this function."}],
)
```

它还提供 Anthropic Messages 兼容入口，并有 Claude Code 集成说明。不同模型来自不同上游，工具、缓存、思考、结构化输出和数据策略可能因路由结果而异。([OpenRouter](https://openrouter.ai/docs/quickstart))

### Together AI

```python
client = OpenAI(
    api_key=os.environ["TOGETHER_API_KEY"],
    base_url="https://api.together.ai/v1",
)
```

Together 同时实现 Chat Completions 和 `/v1/responses`，但官方兼容矩阵也明确列出差异：Assistants、Threads、OpenAI 形状的 Batch 等并非全部实现；某些参数会被接受但忽略，推理字段和 usage 字段也可能使用不同形态。([Together AI docs](https://docs.together.ai/docs/inference/openai-compatibility))

### Groq

```python
client = OpenAI(
    api_key=os.environ["GROQ_API_KEY"],
    base_url="https://api.groq.com/openai/v1",
)
```

Groq 的 Chat Completions 与 OpenAI SDK 基本兼容，并提供测试中的 Responses API。使用 Codex 等依赖 Responses 的工具时，应先确认目标模型是否支持 `/responses`、函数调用和所需流式事件。([GroqCloud](https://console.groq.com/docs/openai?utm_source=chatgpt.com))

### DeepSeek

DeepSeek 同时提供：

```text
OpenAI 格式：https://api.deepseek.com
Anthropic 格式：https://api.deepseek.com/anthropic
```

因此既可以使用 OpenAI SDK，也可以使用 Anthropic SDK。其推理模式还可能使用 `thinking`、`reasoning_effort` 或特定的思考内容字段，多轮工具调用时必须按照其文档保留并回传相应内容。([DeepSeek API Docs](https://api-docs.deepseek.com/))

------

## 2. Anthropic 兼容型接口

常见配置方式：

```python
import anthropic
import os

client = anthropic.Anthropic(
    api_key=os.environ["GATEWAY_KEY"],
    base_url="https://gateway.example.com",
)
```

第三方需要至少正确实现：

```text
POST /v1/messages
```

若用于 Claude Code，还应支持：

```text
POST /v1/messages?beta=true
POST /v1/messages/count_tokens     # 可选
GET  /v1/models                    # 模型发现，可选
```

并正确转发：

```text
anthropic-version
anthropic-beta
Authorization 或 x-api-key
```

Claude Code 要求推理响应实时使用 SSE 流传输；若网关先缓冲完整结果再返回，客户端会表现为长期卡住。错误响应也应尽量原样转发，因为 Claude Code 会依据上游错误内容判断是否自动降级某项能力。([Claude](https://code.claude.com/docs/en/llm-gateway-protocol))

------

## 3. AWS Bedrock、Google Cloud、Microsoft Foundry

这些平台虽然能够运行 Claude 或 Gemini，但不一定只是“换一个 Base URL”：

- Amazon Bedrock 可能使用 AWS SigV4、InvokeModel 或 Converse；
- Google Cloud 使用 OAuth/ADC、项目和区域配置；
- Microsoft Foundry 可能使用 Azure API Key、Entra ID 或其 Anthropic 格式入口；
- 模型 ID 往往带区域、发布者或部署前缀。

AWS 支持 Claude Messages 请求格式，也提供 Bedrock 自己的 Converse API；Claude Code 官方支持 Bedrock、Google Cloud Agent Platform 和 Microsoft Foundry，并分别使用专用环境变量。([AWS 文档](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html?utm_source=chatgpt.com))

------

# 五、为什么“能聊天”不代表“能接编码工具”

普通聊天只要求：

```text
输入文本 → 输出文本
```

编码代理实际上是循环：

```text
用户任务
   ↓
模型分析代码库
   ↓
模型返回工具调用
   ↓
本地代理执行 Read / Grep / Shell / Edit
   ↓
工具结果重新发给模型
   ↓
模型继续调用工具
   ↓
测试、修复、生成最终答复
```

因此，一个接口要真正支持编码代理，至少要处理：

1. 工具定义；
2. 多个并行工具调用；
3. 工具调用 ID；
4. 工具结果回传；
5. SSE 流；
6. 长上下文；
7. 历史压缩；
8. 推理字段；
9. 中断与重试；
10. 文件编辑和 Shell 权限。

Claude Agent SDK 已直接提供 Read、Write、Edit、Bash、Glob、Grep、MCP、权限、Hooks 和会话管理；Codex 也将交互组织为 Thread、Turn、Item，并在运行时执行命令和文件修改。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/sdk))

------

# 六、Codex 如何通过 API 接入编码模型

## 1. 官方 OpenAI API Key

Codex CLI 可以通过 ChatGPT 登录，也可以使用 API Key。自动化和 CI/CD 场景官方更推荐 API Key。([OpenAI 开发者](https://developers.openai.com/codex/auth?utm_source=chatgpt.com))

```bash
export OPENAI_API_KEY="sk-..."

printenv OPENAI_API_KEY | codex login --with-api-key
codex login status
codex
```

非交互调用：

```bash
codex exec "检查项目中的 SQL 注入风险并给出修复"
```

## 2. Codex 接第三方 Responses API

用户级配置文件：

```text
~/.codex/config.toml
```

示例：

```toml
model = "provider-model-id"
model_provider = "my_gateway"

approval_policy = "on-request"
sandbox_mode = "workspace-write"

[model_providers.my_gateway]
name = "My Responses Gateway"
base_url = "https://gateway.example.com/v1"
wire_api = "responses"
env_key = "GATEWAY_API_KEY"
request_max_retries = 4
stream_max_retries = 5
stream_idle_timeout_ms = 300000
```

然后：

```bash
export GATEWAY_API_KEY="..."
codex
```

Codex 当前自定义供应商的 `wire_api` **只支持 `responses`**。所以只有 `/chat/completions` 的第三方服务，即使号称 OpenAI 兼容，也不能直接视为 Codex 兼容；需要供应商实现 Responses API，或者在前面部署 Chat→Responses 协议转换层。([OpenAI 开发者](https://developers.openai.com/codex/config-reference))

## 3. Codex 接 Azure

```toml
model = "AZURE_DEPLOYMENT_NAME"
model_provider = "azure"

[model_providers.azure]
name = "Azure"
base_url = "https://YOUR-RESOURCE.openai.azure.com/openai"
wire_api = "responses"
query_params = { api-version = "SUPPORTED_API_VERSION" }
env_key = "AZURE_OPENAI_API_KEY"
```

注意核对：

- URL 是否包含正确的 `/openai` 或 `/openai/v1`；
- `model` 是模型名还是部署名；
- 当前 Azure 部署是否支持 Responses；
- API 版本是否匹配。

------

# 七、Claude Code 如何通过 API 接入编码模型

## 1. 直接使用 Anthropic API

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
claude
```

Claude Code 也支持 Claude.ai 订阅登录、Anthropic Console、Bedrock、Google Cloud Agent Platform 和 Microsoft Foundry。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/iam?utm_source=chatgpt.com))

## 2. 连接 Anthropic 格式网关

Bearer Token 网关：

```bash
export ANTHROPIC_BASE_URL="https://gateway.example.com"
export ANTHROPIC_AUTH_TOKEN="gateway-token"
claude
```

`x-api-key` 网关：

```bash
export ANTHROPIC_BASE_URL="https://gateway.example.com"
export ANTHROPIC_API_KEY="gateway-key"
claude
```

两者的区别：

| 变量                   | 实际请求头                  |
| ---------------------- | --------------------------- |
| `ANTHROPIC_AUTH_TOKEN` | `Authorization: Bearer ...` |
| `ANTHROPIC_API_KEY`    | `x-api-key: ...`            |

可以使用：

```text
/status
```

检查当前 Base URL 和认证来源。([Claude](https://code.claude.com/docs/en/llm-gateway-connect))

## 3. 持久化配置

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://gateway.example.com",
    "ANTHROPIC_AUTH_TOKEN": "gateway-token"
  }
}
```

文件放在：

```text
~/.claude/settings.json
```

不要把密钥写入会提交到 Git 的项目级 `.claude/settings.json`。项目私有配置可使用 `.claude/settings.local.json` 并确保被 `.gitignore` 排除。([Claude](https://code.claude.com/docs/en/llm-gateway-connect))

## 4. 使用非 Claude 模型

技术上，网关可以把 Anthropic Messages 转换为其他模型协议，但 Anthropic 明确表示：

- 不维护或审计第三方网关；
- 不正式支持通过网关把 Claude Code 路由到非 Claude 模型；
- 新版 Claude Code 持续增加 beta headers 和请求字段，转换层可能随升级失效。([Claude Platform Docs](https://docs.anthropic.com/en/docs/claude-code/llm-gateway))

因此，用 DeepSeek、Gemini 或开源模型驱动 Claude Code 时，应重点测试：

- `tool_use` 和 `tool_result`；
- 并行工具调用；
- 流式 JSON；
- `thinking` 字段；
- `anthropic-beta`；
- 上下文管理；
- 提示缓存；
- 模型是否遵循 Claude Code 的工具使用提示。

------

# 八、Gemini CLI 如何通过 API 接入

安装后设置 API Key：

```bash
export GEMINI_API_KEY="..."
gemini
```

并在登录选项中选择 Gemini API Key。默认模型可以通过：

```bash
export GEMINI_MODEL="gemini-model-id"
```

配置。Gemini CLI 官方认证路径包括 Google 账号、Gemini API Key 和 Google Cloud/Vertex 类后端。([Gemini CLI](https://geminicli.com/docs/get-started/authentication/?utm_source=chatgpt.com))

使用 API Key 或 Vertex 后端时，Gemini CLI 可以利用上下文缓存优化重复上下文成本；OAuth 类型后端的缓存能力可能不同。([Gemini CLI](https://geminicli.com/docs/cli/token-caching/?utm_source=chatgpt.com))

与 Codex 和 Claude Code 相比，Gemini CLI 官方资料更强调 Gemini API 和 Google Cloud 后端。需要任意 OpenAI 兼容第三方模型时，通常选择支持自定义供应商的通用编码工具，或者在本地部署协议适配器更稳妥。

------

# 九、自己实现编码代理的推荐架构

## 1. 不要直接让业务层依赖某一家格式

建议内部定义自己的统一结构：

```python
from dataclasses import dataclass
from typing import Any, Literal

@dataclass
class ToolCall:
    id: str
    name: str
    arguments: dict[str, Any]

@dataclass
class ModelResult:
    text: str
    tool_calls: list[ToolCall]
    finish_reason: str | None
    usage: dict[str, int]
    raw: Any

@dataclass
class ProviderConfig:
    api_style: Literal[
        "openai_responses",
        "openai_chat",
        "anthropic_messages",
        "gemini_interactions",
    ]
    base_url: str
    model: str
    api_key_env: str
```

然后分别实现：

```text
OpenAIResponsesAdapter
OpenAIChatAdapter
AnthropicMessagesAdapter
GeminiInteractionsAdapter
```

不要试图把所有供应商都强行塞入 `chat.completions.create()`。

## 2. 工具循环

```python
for step in range(MAX_STEPS):
    result = model.generate(
        messages=history,
        tools=tool_schemas,
    )

    if not result.tool_calls:
        return result.text

    for call in result.tool_calls:
        tool_result = execute_tool_safely(call)
        history.append(
            make_tool_result_message(call.id, tool_result)
        )

raise RuntimeError("Agent exceeded maximum steps")
```

必须设置：

- 最大轮数；
- 最大累计 Token；
- 最大执行时间；
- 最大工具输出；
- 单次 Shell 超时；
- 重复调用检测；
- 用户取消信号。

## 3. 不能只保存文本

历史记录中必须保存原始结构，包括：

- 工具调用 ID；
- 工具参数；
- 工具结果；
- Claude 内容块；
- Responses output items；
- Gemini function call；
- 必须回传的思考签名或推理字段。

否则第二轮工具调用可能报错，或者模型失去之前的工具上下文。

------

# 十、生产实现中最容易出错的地方

## 1. 流式协议

不同接口的流式事件不能只当作文本拼接：

```text
OpenAI Responses:
response.output_text.delta
response.function_call_arguments.delta
response.completed

Anthropic:
message_start
content_block_start
content_block_delta
content_block_stop
message_delta
message_stop

Chat Completions:
choices[].delta.content
choices[].delta.tool_calls
```

工具参数 JSON 可能被拆成多个增量片段，必须先按调用 ID 累积，再解析 JSON。Claude Code 官方还特别提醒网关不能缓冲完整响应后再发送。([Claude](https://code.claude.com/docs/en/llm-gateway-protocol))

## 2. 兼容参数被静默忽略

第三方接口可能接受但忽略：

```text
store
metadata
service_tier
seed
logit_bias
reasoning_effort
response_format
parallel_tool_calls
```

因此启动时应执行能力探测，而不是只看请求是否返回 200。Together 的兼容文档就明确列出了部分被忽略的参数和返回字段差异。([Together AI docs](https://docs.together.ai/docs/inference/openai-compatibility))

## 3. 模型名称

同一个模型在不同平台可能是：

```text
gpt-...
部署名称
provider/model
region.provider.model-version
publishers/.../models/...
```

应配置模型别名映射：

```yaml
models:
  coding_fast:
    provider: groq
    model: provider/model-id

  coding_deep:
    provider: anthropic
    model: claude-version-id
```

不要在代码中通过模型字符串猜测上下文长度或功能。

## 4. 重试

建议只对下列情况自动重试：

- 408；
- 429；
- 500；
- 502；
- 503；
- 504；
- SSE 意外中断。

采用指数退避和抖动：

```python
delay = min(base_delay * 2**attempt, max_delay)
delay *= random.uniform(0.8, 1.2)
```

对于有副作用的工具操作，模型请求可以重试，但工具执行不能无条件重放。应为写数据库、发邮件、创建 PR 等动作增加幂等键。

## 5. 上下文管理

编码代理会迅速积累：

- 源代码；
- Git diff；
- 测试输出；
- 编译日志；
- 工具定义；
- 多轮思考。

推荐：

1. 只发送相关文件；
2. 搜索后再读取；
3. 大日志只保留尾部和错误附近；
4. 工具输出设置长度上限；
5. 对旧轮次做结构化摘要；
6. 保留未完成任务、已修改文件和测试状态；
7. 使用供应商缓存时保持系统提示前缀稳定。

## 6. 安全边界

编码代理的风险主要来自工具执行，而不是模型文本。最低限度应实施：

- 默认只读；
- 写入限定在工作区；
- 禁止访问 SSH、云凭据和浏览器数据目录；
- 网络默认关闭或域名白名单；
- 删除、发布、部署、推送前人工批准；
- Shell 超时和进程树清理；
- 密钥通过环境或密钥管理器注入；
- 对网页、Issue、README 中的提示注入内容视为不可信；
- 操作前后创建 Git checkpoint；
- CI 中使用短期、最小权限凭据。

Codex 提供 `approval_policy` 和 `sandbox_mode`；Claude Agent SDK 提供工具白名单、权限模式和 PreToolUse/PostToolUse Hooks。([OpenAI 开发者](https://developers.openai.com/codex/config-basic?utm_source=chatgpt.com))

------

# 十一、推荐选择

## 普通应用开发

直接使用各自原生接口：

```text
OpenAI → Responses API
Claude → Messages API
Gemini → Interactions API
```

这样能获得最完整的工具、多模态、缓存和推理能力。

## 多模型平台

在自己的后端增加适配层：

```text
业务代码
   ↓
统一 Provider Interface
   ├── OpenAI Responses Adapter
   ├── OpenAI Chat Adapter
   ├── Anthropic Adapter
   └── Gemini Adapter
```

OpenAI Chat Completions 可作为最低公共能力，但不能作为所有高级功能的唯一抽象。

## 使用 Codex

优先顺序：

1. OpenAI 官方 API；
2. Azure/OpenAI Responses 兼容端点；
3. 完整实现 `/v1/responses` 的第三方服务；
4. Chat Completions-only 服务不建议直接接入。

## 使用 Claude Code

优先顺序：

1. Anthropic 官方 API；
2. Bedrock、Google Cloud Agent Platform、Microsoft Foundry；
3. 完整 Anthropic Messages 网关；
4. Anthropic→非 Claude 模型转换仅适合经过完整回归测试的环境。

## 自建编码系统

需要完整控制、安全审计和自定义流程时：

- OpenAI 可使用 Responses/Agents SDK 或 Codex SDK、app-server；
- Anthropic 可使用 Claude Agent SDK；
- Gemini 可基于 Interactions API、函数调用和自建工具循环；
- 工具执行层必须和模型供应商层解耦。

------

## 最终检查清单

接入任何第三方 API 或编码模型前，至少测试：

-  普通文本请求；
-  SSE 首 Token 延迟；
-  单工具调用；
-  并行工具调用；
-  工具参数分片；
-  工具失败回传；
-  结构化 JSON；
-  长上下文；
-  上下文缓存；
-  推理配置；
-  429 与 5xx 重试；
-  流中断续传；
-  Token usage 字段；
-  模型 ID 更新；
-  代理最大轮数；
-  Shell 沙箱；
-  网络白名单；
-  密钥脱敏；
-  Git 回滚；
-  供应商切换回归测试。

API 和编码工具接口更新频繁，可以按月检查 OpenAI、Anthropic、Gemini、Codex 和 Claude Code 的兼容性变化并生成变更摘要。