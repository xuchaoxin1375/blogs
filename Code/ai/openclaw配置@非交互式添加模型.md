

[toc]



## 命令模板参考:

获取命令帮助[onboard - OpenClaw](https://docs.openclaw.ai/cli/onboard)

```bash
 openclaw onboard --non-interactive -h
```

您可以通过以下几种方式在命令行中非交互式地添加新的模型/API：

### 1. 使用 `openclaw onboard --non-interactive` 1. 使用 `openclaw onboard --non-interactive`

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

wizard-cli-automation.md:20-31 wizard-cli-automation.md:148-162
wizard-cli-automation.md:20-31 wizard-cli-automation.md:148-162

### 2. 使用环境变量和 SecretRef 模式

为了更安全地存储 API 密钥，可以使用 `--secret-input-mode ref`：

```
export ANTHROPIC_API_KEY="your-key"  
openclaw onboard --non-interactive \  
  --mode local \  
  --auth-choice anthropic-api-key \  
  --secret-input-mode ref \  
  --accept-risk
```

wizard-cli-automation.md:42-49

### 3. 直接使用 `openclaw config set`

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

index.md:396-410

### 4. 使用 `openclaw models auth` 命令组

虽然 `models auth add` 是交互式的，但 `paste-token` 子命令可以非交互使用：

```
# 粘贴 token（非交互）  
openclaw models auth paste-token \  
  --provider anthropic \  
  --profile-id default \  
  --expires-in 365d \  
  --token "your-token-here"
```

models-cli.ts:296-303 index.md:954-956
models-cli.ts:296-303 index.md:954-956

## Notes  笔记

- 使用 `--non-interactive` 时必须提供所有必需的参数，否则命令会失败 wizard-cli-automation.md:14-16
- 对于自定义提供商，`--custom-api-key` 是可选的，如果省略会检查对应的环境变量（如 `CUSTOM_API_KEY`） wizard-cli-automation.md:162-163
- 添加模型后，可以使用 `openclaw models set <model-id>` 设置为默认模型 set.ts:6-14
- 所有支持的提供商都有对应的 `--provider-api-key` 参数格式，如 `--together-api-key`、`--kilocode-api-key` 等 together.md:39-44