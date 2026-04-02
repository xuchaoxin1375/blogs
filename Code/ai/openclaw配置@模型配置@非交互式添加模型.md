

[toc]





## openclaw 模型配置

- [Configuration - OpenClaw](https://docs.openclaw.ai/gateway/configuration#choose-and-configure-models)
- [模型提供商(concepts) - OpenClaw](https://docs.openclaw.ai/zh-CN/concepts/model-providers#快速规则)
- [模型提供商(providers) - OpenClaw](https://docs.openclaw.ai/zh-CN/providers)
- [通过-models-providers-配置的提供商（自定义/基础-url) - OpenClaw](https://docs.openclaw.ai/zh-CN/concepts/model-providers#通过-models-providers-配置的提供商（自定义/基础-url）)
- [本地代理|模型提供商 - OpenClaw](https://docs.openclaw.ai/zh-CN/concepts/model-providers#本地代理（lm-studio、vllm、litellm-等）)

### 概述

- [Configuration Reference - OpenClaw](https://docs.openclaw.ai/gateway/configuration-examples)

设置主要模型和可选备选模型

## openclaw.json中的重要配置结点

有些结点通过openclaw命令行自动配置和生成;

### agent结点

`~/.openclaw.json`中的`agents`字段(结点),负责声明(注册)可选用的模型列表(但是该节点并不配置模型的详细信息,例如模型上下文,接收的输入形式,模型是否会推理(reasoning)等详细参数)

> 该结点包含的信息量很有限,能否真正可用取决于其他结点(models)中是否正确配置足够的信息;否则模型即便被选中,也不能工作;

```json
{
  agents: {
    defaults: {
      model: {
        primary: "anthropic/claude-sonnet-4-6",
        fallbacks: ["openai/gpt-5.2"],
      },
      models: {
        "anthropic/claude-sonnet-4-6": { alias: "Sonnet" },
        "openai/gpt-5.2": { alias: "GPT" },
      },
    },
  },
}
```

- `agents.defaults.model`定义了默认使用的模型(主默认模型由`primary`指定,而`fallbacks`定义主模型故障时的备用模型),此对象中提及的模型应当在`agents.defaults.models`中列出(有相应定义);
- `agents.defaults.models` 定义了模型目录，并充当 `/model` 的允许列表,可以为模型定义别名(`alias`),也可以为空;应当包含`agents.defaults.model`中提及的模型。
- 模型参考使用 `provider/model` 格式指定模型（例如 `anthropic/claude-opus-4-6` ）。

### models结点

与agents并列的结点还有`models`结点(注意和`agents.models`结点区别开)



又比如mimo模型(models结点)

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "xiaomi": {
        "baseUrl": "https://api.xiaomimimo.com/v1",
        "apiKey": "",
        "api": "openai-completions",
        "models": [
          {
            "id": "mimo-v2-pro",
            "name": "mimo-v2-pro",
            "reasoning": true,
            "input": [
              "text"
            ],
            "contextWindow": 1048576,
            "maxTokens": 32000
          },
          {
            "id": "mimo-v2-omni",
            "name": "mimo-v2-omni",
            "reasoning": true,
            "input": [
              "text",
              "image"
            ],
            "contextWindow": 262144,
            "maxTokens": 32000
          }
        ]
      }
    }
  },
    //中间可能有其他结点;
  "agents": {
    "defaults": {
      "model": {
        "primary": "xiaomi/mimo-v2-pro"
      },
      "models": {
        "xiaomi/mimo-v2-omni": {},
        "xiaomi/mimo-v2-pro": {}
      },
    },
  },
}
```

例如minimax模型

```json
{
  agents: {
    defaults: {
      model: { primary: "lmstudio/minimax-m2.5-gs32" },
      models: { "lmstudio/minimax-m2.5-gs32": { alias: "Minimax" } },
    },
  },
    // 顶层models结点可能在agents结点之前
  models: {
    providers: {
      lmstudio: {
        baseUrl: "http://localhost:1234/v1",
        apiKey: "LMSTUDIO_KEY",
        api: "openai-completions",
        models: [
          {
            id: "minimax-m2.5-gs32",
            name: "MiniMax M2.5",
            reasoning: false,
            input: ["text"],
            cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
            contextWindow: 200000,
            maxTokens: 8192,
          },
        ],
      },
    },
  },
}
```



#### 其他

- `agents.defaults.imageMaxDimensionPx` 控制转录/工具图像的缩小（默认值为 `1200` ）；较低的值通常会减少在大量截图运行中视觉标记的使用。
- 有关在聊天中切换模型的信息，请参阅 Models CLI；有关身份验证轮换和回退行为的信息，请参阅 Model Failover。
- 对于自定义/自托管提供商，请参阅参考资料中的“自定义提供商”。

### auth结点



```json
  "auth": {
    "profiles": {
      "openrouter:default": {
        "provider": "openrouter",
        "mode": "api_key"
      },
      "xiaomi:default": {
        "provider": "xiaomi",
        "mode": "api_key"
      }
    }
  },
```



### 建议：使用 OpenClaw 设置向导

配置 OpenClaw 与 OpenRouter 的最简单方法是使用内置的设置向导：

```bash
openclaw onboard
```



向导将引导您完成以下步骤：

1. 选择 OpenRouter 作为您的服务提供商
2. 输入您的 API 密钥
3. 选择您喜欢的型号
4. 配置消息通道

这是推荐给新用户的方法，可以确保所有配置都正确无误。

### 快速入门（CLI）

> 以openrouter提供的模型为例:

如果您已经拥有 OpenRouter API 密钥并希望跳过向导，请使用以下一行命令：

```bash
openclaw onboard --auth-choice apiKey --token-provider openrouter --token "$OPENROUTER_API_KEY" --non-interactive --accept-risk
```



这将自动配置 OpenClaw 使用推荐型号的 OpenRouter ( `openrouter/auto` )。

## openrouter模型配置

许多模型厂商在openrouter开放免费模型,并可能限时免费开放新模型

OpenClaw 内置了对 OpenRouter 的支持。您无需配置 `models.providers` ，只需设置您的 API 密钥，并使用 `openrouter/<author>/<slug>` 格式引用模型即可。

[与 OpenClaw | OpenRouter | OpenRouter 集成 | 文档 --- Integration with OpenClaw | OpenRouter | OpenRouter | Documentation](https://openrouter.ai/docs/guides/coding-agents/openclaw-integration)

### Openrouter API

[OpenRouter Quickstart Guide | Developer Documentation | OpenRouter | Documentation](https://openrouter.ai/docs/quickstart)

### api测试

```bash
#!/bin/bash
# shellcheck disable=SC2034
OPENROUTER_API_KEY="........." #填写自己的api key
# 定义要测试的模型
# 模型名称说明:对于非openrouter包装过的模型,例如"qwen/qwen3.6-plus-preview:free",# 具体模型开头的路径是模型牌子的标识(例如qwen)
# openrouter包装并提供的模型(主要是自动决策的auto,free)
oa="openrouter/auto"
of="openrouter/free"
# 指定具体模型
qwen="qwen/qwen3.6-plus-preview:free"
n3="nvidia/nemotron-3-super-120b-a12b:free"

curl https://openrouter.ai/api/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENROUTER_API_KEY" \
    -d '{
    "model": "'"$qwen"'",
    "messages": [
      {
        "role": "user",
        "content": "你是什么模型?"
      }
    ]
  }'

```

对于shell,在`''`符号对中的内容是不执行变量扩展的,需要用字符串拼接的技巧来理解和编写这类复杂字符串;

## openclaw config和configure命令

 **OpenClaw 的两套配置范式（configuration paradigms）**：

👉 一套是**声明式修改（declarative config editing）**,适合修改配置
 👉 一套是**流程式引导（procedural setup wizard）**,适合初次配置引导设置.

```bash
config *             Non-interactive config helpers (get/set/unset/file/validate). Default: starts guided
                       setup.
configure            Interactive configuration for credentials, channels,gateway, and agent defaults
```

| 维度                   | openclaw config      | openclaw configure  |
| ---------------------- | -------------------- | ------------------- |
| 类型                   | 声明式 (declarative) | 流程式 (procedural) |
| 是否交互               | 默认非交互           | 默认交互            |
| 操作粒度               | 字段级               | 系统级              |
| 是否安全               | 高（不乱改）         | 可能覆盖            |
| 是否适合脚本           | ⭐⭐⭐⭐⭐                | ⭐⭐                  |
| 是否适合新手           | ⭐⭐                   | ⭐⭐⭐⭐⭐               |
| 是否幂等（idempotent） | ✅                    | ❌                   |
| 是否可预测             | 高                   | 中                  |

## 非交互式配置模型命令模板参考:

获取命令帮助[onboard - OpenClaw](https://docs.openclaw.ai/cli/onboard)

```bash
 openclaw onboard --non-interactive -h
```

您可以通过以下几种方式在命令行中非交互式地添加新的模型/API：

### 使用 `openclaw onboard --non-interactive`

这是最常用的方式，支持所有主流提供商：

```bash
# Anthropic API Key  
openclaw onboard --non-interactive \  
  --mode local \  
  --auth-choice anthropic-api-key \  
  --anthropic-api-key "$ANTHROPIC_API_KEY" \  
  --gateway-port 18789 \  
  --gateway-bind loopback  
  
# OpenAI API Key  
openclaw onboard --non-interactive \  
  --mode local \  
  --auth-choice openai-api-key \  
  --openai-api-key "$OPENAI_API_KEY"  
  
# 自定义 API 提供商  
openclaw onboard --non-interactive \
  --auth-choice custom-api-key \
  --custom-base-url "https://llm.example.com/v1" \
  --custom-model-id "foo-large" \
  --custom-api-key "$CUSTOM_API_KEY" \
  --secret-input-mode plaintext \
  --accept-risk \
  --custom-compatibility openai
#例如
openclaw onboard --non-interactive \
  --custom-base-url "https://openai...."\
  --custom-model-id "gpt-5.4" \
  --custom-api-key "sk-B882bCwUweSeMR..C7WAYhfwa" \
  --custom-provider-id "free..." \
  --custom-compatibility openai\
  --accept-risk \
  
```

 以xiaomi mimo为例,采用默认行为:

```bash
XIAOMI_API_KEY="your api key"
openclaw onboard --non-interactive --accept-risk --xiaomi-api-key $XIAOMI_API_KEY
```

> 该命令会为你设置新模型,包括`agents.defaults.model(s))`,而供应商(`models.providers`有些供应商会写入,有些不会)
>
> 并且默认的,会在`agents/main/agent/`目录中的`auth-profiles.json`中存储你提供的api key(而不是将api key保存到openclaw.json中,`openclaw.json`中的`auth`结点配置了以什么方式访问模型供应商的模型,典型的方式是`api_key`)

### 查看已配置的模型提供商

> 配合`jq`可以获取简洁的输出:

使用`openclaw onboard`配置的模型,有的不会向`models.providers`结点注册信息,特别是资源聚合型厂商(例如openrouter),可能只会修改`agents.defaults.model(s)`结点;

所以下面的方法仅供参考

```bash
$ openclaw config get models.providers | jq 'keys'
[
  "free-high-end",
  "xiaomi"
]
```

如果没有`jq`,则会打印出每个供应商的配置细节;

查看具体的provider配置细节:(例如查看某个指定的自定义第三方供应商)

```bash
openclaw config get models.providers.free-high-end
```

如果某个provider内部配置了`  "apiKey"`,那么输出的相关字段会被脱敏(redacted涂黑,修改),防止密钥泄露

```json
  "apiKey": "__OPENCLAW_REDACTED__",
```



### 查看指定模型供应商提供的模型列表

通过`openclaw config get`查询配置文件中的指定结点的信息;

`models.providers.xiaomi.models`记录了xiaomi提供的模型列表

```bash
openclaw config get models.providers.xiaomi.models
```

注意同一个厂商可能提供多个不同的模型,可以追加`openclaw models set`更改默认模型,例如

设置由openrouter间接提供的xiaomi模型为默认模型

```bash
openclaw models set openrouter/xiaomi/mimo-v2-pro
```



###  使用环境变量和 SecretRef 模式

为了更安全地存储 API 密钥，可以使用 `--secret-input-mode ref`：

```bash
export ANTHROPIC_API_KEY="your-key"  
openclaw onboard --non-interactive \  
  --mode local \  
  --auth-choice anthropic-api-key \  
  --secret-input-mode ref \  
  --accept-risk
```



###  `openclaw config set`

对于更精细的控制，可以直接修改配置：

```bash
# 设置 API 密钥  
openclaw config set env.ANTHROPIC_API_KEY --ref-provider env --ref-source default --ref-id ANTHROPIC_API_KEY  
  
# 设置默认模型  
openclaw config set agents.defaults.model.primary "anthropic/claude-3-5-sonnet-20241022"  
  
# 添加自定义提供商  
openclaw config set models.providers.my-custom.baseUrl "https://api.example.com/v1"  
openclaw config set models.providers.my-custom.apiKey --ref-provider env --ref-source default --ref-id CUSTOM_API_KEY
```

###  `openclaw agent` 绑定模型

------

添加 agent 并绑定模型（更完整）

```bash
openclaw agents add my-agent \
  --workspace ~/.openclaw/workspace \
  --model openai/gpt-4o \
  --non-interactive
```

👉 用于：

- 多 agent 架构
- 明确绑定模型

来源：agents add 支持 non-interactive ([OpenClaw](https://docs.openclaw.ai/cli?utm_source=chatgpt.com))

### 使用 `openclaw models auth` 命令组

虽然 `models auth add` 是交互式的，但 `paste-token` 子命令可以非交互使用：

```bash
# 粘贴 token（非交互）  
openclaw models auth paste-token \  
  --provider anthropic \  
  --profile-id default \  
  --expires-in 365d \  
  --token "your-token-here"
```

 

Notes  笔记

- 使用 `--non-interactive` 时必须提供所有必需的参数，否则命令会失败 
- 对于自定义提供商，`--custom-api-key` 是可选的，如果省略会检查对应的环境变量（如 `CUSTOM_API_KEY`） wizard-cli-automation.md:162-163
- 添加模型后，可以使用 `openclaw models set <model-id>` 设置为默认模型 set.ts:6-14
- 所有支持的提供商都有对应的 `--provider-api-key` 参数格式，如 `--together-api-key`、`--kilocode-api-key` 等  



------

### `openclaw models`设置默认模型

```bash
openclaw models set openai/gpt-4o
```

👉 否则可能 fallback 到 Claude

来源：models CLI ([OpenClaw](https://docs.openclaw.ai/models?utm_source=chatgpt.com))

### 自动化流程

这是我建议你用的组合（CI/CD 或脚本场景）

```bash
# 1. 设置 key（推荐 env）
export OPENAI_API_KEY=sk-xxxx

# 2. 写配置（非交互）
openclaw config set llm.provider openai
openclaw config set llm.model gpt-4o

# 3. 设置默认模型
openclaw models set openai/gpt-4o

# 4. 校验
openclaw config validate
openclaw models status
```

👉 优点：

- 完全无交互
- 不破坏已有配置
- 可脚本化

------

### 关键参数解释

| 参数                     | 含义                     | 说明                         |
| ------------------------ | ------------------------ | ---------------------------- |
| `--custom-provider-id`   | 自定义 provider          | openai / ollama / openrouter |
| `--custom-model-id`      | 模型 ID                  | gpt-4o / deepseek-chat       |
| `--custom-api-key`       | API 密钥                 | 可省略→ENV                   |
| `--custom-compatibility` | 兼容协议 (compatibility) | openai / anthropic           |
| `--non-interactive`      | 非交互模式               | CI 必备                      |
| `--skip-*`               | 跳过模块                 | 提速                         |

------

### 三种方式对比（你要选对）

| 方式                | 推荐度 | 特点        | 场景          |
| ------------------- | ------ | ----------- | ------------- |
| `config set`        | ⭐⭐⭐⭐⭐  | 最干净      | 自动化 / 脚本 |
| `configure --flags` | ⭐⭐⭐⭐   | 接近 wizard | 初次配置      |
| `agents add`        | ⭐⭐⭐⭐   | agent级别   | 多模型系统    |
| 手改 JSON           | ⭐⭐     | 易出错      | debug only    |

------

### 最常见坑（CLI 非交互模式）

❌ 1. 只加模型没设 default

👉 结果：仍然用 Claude

✔ 修复：

```bash
openclaw models set openai/gpt-4o
```

------

❌ 2. provider/model 写法错误

```bash
--model gpt-4o   ❌
--model openai/gpt-4o ✅
```

👉 OpenClaw内部是：

```
provider/model
```

------

❌ 3. key 没绑定 provider

即使你写了：

```bash
OPENAI_API_KEY=xxx
```

但 provider 写成：

```bash
anthropic
```

👉 直接失效

------

❌ 4. configure 会覆盖 models 列表

社区反馈：

> “model list is overridden” ([Reddit](https://www.reddit.com/r/openclaw/comments/1rov7u1/adding_models_to_openclawjson_without_losing/?utm_source=chatgpt.com))

👉 所以自动化尽量用：

```
config set
```

------

### “通用模板”（适配任意 provider）

```bash
openclaw config set models.providers.myprovider '{
  "apiKey": "sk-xxx",
  "baseUrl": "https://api.xxx.com",
  "compatibility": "openai"
}'

openclaw models set myprovider/my-model
```

👉 这个是最灵活的（支持：

- OpenRouter
- vLLM
- 本地代理）

## 移除模型



------

一、先理解 onboard 到底做了什么

假设我用如下命令配置了新模型:

```bash
openclaw onboard --non-interactive --accept-risk --xiaomi-api-key $XIAOMI_API_KEY
```

实际效果是（根据官方 provider 配置）：

- 写入 provider：`xiaomi`
- 写入 key：`XIAOMI_API_KEY`
- 设置默认模型：例如`xiaomi/mimo-v2-flash`

------

二、移除方式（从“轻量 → 完全清理”）

我按工程实践给你分 4 个层级👇

------

方案1：仅更改默认模型（最安全）

👉 如果你只是“不想再用 Xiaomi 模型”

```bash
openclaw models set openai/gpt-4o
```

✔ 效果：

- 不再调用 xiaomi
- 但 config 仍然存在（不会报错）

------

方案2：删除 provider（推荐）

👉 这是最干净的“逻辑移除”

```bash
openclaw config unset models.providers.xiaomi
```

如果有默认 agent：

```bash
openclaw config unset agents.defaults.model
```

✔ 原理：

- 直接删 config 节点（declarative 删除）

------

方案3：删除 API Key（关键一步）

情况1：env 存储（最常见）

你可能是：

```bash
export XIAOMI_API_KEY=xxx
```

👉 删除：

```bash
unset XIAOMI_API_KEY
```

或删 `.env`：

```bash
nano ~/.openclaw/.env
```

------

情况2：config 内写死

```bash
openclaw config unset env.XIAOMI_API_KEY
```

------

📌 注意：

> OpenClaw 会“自动注入 provider”，只要 key 存在 

👉 所以 **不删 key = provider 还会回来**

------

方案4：完全重置（最彻底）

如果你想“回到未配置状态”：

```bash
rm -rf ~/.openclaw
```

✔ 官方推荐 reset 方式 ([OpenClaw Launch](https://openclawlaunch.com/guides/openclaw-uninstall?utm_source=chatgpt.com))

👉 会删除：

- 所有模型
- 所有 key
- agents
- workspace config

------

### 移除模型步骤

以xiaomi模型(提供商)为例

```bash
# 删除 provider
openclaw config unset models.providers.xiaomi
```



```bash


#  删除默认模型（如果是它）
openclaw config unset agents.defaults.model

#  删除 API key
unset XIAOMI_API_KEY

#  校验
openclaw config validate
```

------

四、你一定要注意的坑（很关键）

❗ 坑1：只删 config 不删 env → 会复活

```text
.env 里还有 XIAOMI_API_KEY
→ provider 自动重新出现
```

------

❗ 坑2：agent 仍引用旧模型

```json
agents.defaults.model = "xiaomi/xxx"
```

👉 会报：

```text
model not found / provider missing
```

------

❗ 坑3：key 仍然有效（安全问题）

即使你本地删了：

👉 远程 API key 仍然可用

建议：

- 去 Xiaomi 控制台
- 删除 / rotate key

（安全建议来自官方安全分析） ([openclaw.security](https://www.openclaw.security/post/uninstalling-openclaw-isnt-enough?utm_source=chatgpt.com))

------

五、推荐你的最佳做法（工程实践）

如果你是做自动化/多模型：

👉 建议用这种结构：

```bash
# 切换模型，而不是删 provider
openclaw models set openai/gpt-4o
```

👉 provider 保留，按需切换

------

六、总结一句话

👉 OpenClaw 没有：

```bash
openclaw remove provider ❌
```

👉 正确方式是：

```bash
config unset + 删除 env + 切换 default model
```

------

如果你愿意，我可以帮你：

👉 写一个“一键切换多 provider（openai / xiaomi / ollama）”脚本
👉 或帮你分析你当前 config（贴出来即可）看有没有残留状态