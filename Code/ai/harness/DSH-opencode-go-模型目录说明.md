# DSH 接入 opencode go 订阅：模型目录缺失问题与解决方案

> 排查日期：2026-09（对应 DSH 包内 pi-ai 目录快照 2026-09-15）
> 涉及环境：Windows，DSH_HOME = `C:\Users\cxxu1375\.dsh`

---

## 1. 问题现象

用 opencode go 订阅接入 DeepSeek Harness 后，模型选择列表**不是端点支持的全部模型**：

- 官网 / 端点 `https://opencode.ai/zen/go/v1/models` 返回 **37 个模型**（含 `deepseek-v4.1-flash`）
- DSH 里 `opencode-go` 路由只列出 **27 个**，缺少 `deepseek-v4.1-flash` 等 10 个
- 在设置界面点"获取可用模型"也**拉不到**缺失的模型

**这不是订阅权限问题**，端点和权限都正常，是 DSH 侧的模型目录滞后。

---

## 2. 结论速览（TL;DR）

| 项目 | 结论 |
|---|---|
| 模型列表来源 | DSH 打包的 **pi-ai 静态目录快照**，不是 live 端点 |
| 目录快照时间 | **2026-09-15**（`dist/providers/data/opencode-go.json`） |
| 端点实际模型数 | 37 |
| 内置目录模型数 | 27 |
| 缺失数量 | 10 |
| "获取可用模型"为何失效 | 目录里已有该路由 → **直接用目录回答，完全不发网络请求** |
| 手写模型为何不显示 | `models` 条目**没有 `api` 字段**；目录外模型只能靠**路由级 `api`** 拿协议，缺失即静默剔除（[7.8](#78-目录外模型漏写路由级-api-会静默消失本次实际踩到)） |
| 修复思路 | ① 给路由写显式 `models` 列表 **+ 路由级 `api`**；② 新建一个**目录不认识**的路由，让它走在线拉取 |

---

## 3. 根因：DSH 的模型目录是打包的静态快照

### 3.1 数据流

```
settings.yaml (llm-pi-ai.providers.<路由>)
        │
        ▼
dsh-llm-pi-ai 插件  ──►  @earendil-works/pi-ai 内置目录（打包快照）
        │                        │
        │                        └─ dist/providers/data/opencode-go.json  ← 权威列表（离线）
        ▼
模型选择器 / 请求
```

`/v1/models` 端点**在正常使用路径上完全不参与**。它只在一种情况下被访问：配置界面点"获取可用模型"，**且**该路由不在 pi-ai 目录里。

### 3.2 官方文档中的明确表述

`dsh-llm-pi-ai\lib\types\discovery.d.ts`：

> A route the installed pi-ai catalog ships is answered **from that catalog, with no network call at all** … Only a route the catalog does not describe — a gateway, a self-hosted server — is **interrogated over the wire**.

`dsh-llm-pi-ai\lib\types\config.d.ts`：

> `modelOverrides` … Only meaningful on a catalog route with no `models` list — … **or naming a model the catalog does not describe is refused rather than skipped.**

→ 两点关键推论：
1. `opencode-go` 是目录内路由 ⇒ 永远不查端点，快照多旧就列多旧。
2. `modelOverrides` **无法新增**目录外的模型 id（会被直接拒绝），只能改写已有模型。

### 3.3 证据链

```powershell
# ① 端点真实列表（37 个）
curl https://opencode.ai/zen/go/v1/models

# ② 内置目录快照（27 个）
$p = "C:\Users\cxxu1375\AppData\Roaming\npm\node_modules\@deepseek-ai\dsh\node_modules\@earendil-works\pi-ai\dist\providers\data\opencode-go.json"
(Get-Item $p).LastWriteTime      # → 2026/9/15 21:26:34
```

---

## 4. 目录 vs 端点差异（37 vs 27）

内置目录缺失的 **10 个**模型：

| 缺失模型 | 所属档位判断 |
|---|---|
| `deepseek-v4.1-flash` | **低价**（flash 档） |
| `deepseek-flash` | **低价**（flash 稳定别名） |
| `hy3-preview` | **低价**（preview，比照 hy3） |
| `minimax-m2.5` | **低价**（老一代，比照 m2.7） |
| `kimi-k2.5` | **低价**（老一代，比照 k2.6） |
| `qwen3.5-plus` | **低价**（老一代，比照 3.6-plus） |
| `glm-5` | **低价**（比照 5.x 系列） |
| `grok-4.5` | 非低价（grok 为高价位档） |
| `mimo-v2-omni` | 非低价（新发布） |
| `mimo-v2-pro` | 非低价（旗舰） |

> 注：定价梯度来自内置目录中同系列已有模型的 `cost` 字段，见[附录 A](#附录-a内置目录里的成本梯度)。

---

## 5. 解决方案

### 方案 A：给**已有路由**写显式 `models` 列表

适用于"就想在原来那个路由里看到新模型"。

```yaml
# C:\Users\cxxu1375\.dsh\settings.yaml
llm-pi-ai:
  providers:
    opencode-go:
      apiKeyEnv: OPENCODE_GO_API_KEY
      api: openai-completions        # ← 必需！漏了这行，手写模型会静默消失（见 7.8）
      baseURL: https://opencode.ai/zen/go/v1
      models:
        - id: deepseek-v4.1-flash
          name: DeepSeek V4.1 Flash
          contextWindow: 1000000
          maxTokens: 384000
          input: [ text, image ]
          reasoningEfforts:
            off:
            low: low
            high: high
            xhigh: high
            max: max
        # ……其余模型
```

**⚠️ 两个关键代价**：

1. `models` 是**整表替换**，不是追加。写进去之后，内置目录里那 27 个模型**全部失效**，除非你逐个列全。
2. **必须在路由级写 `api:`**，否则目录外（手写）的模型**既不显示也不报错**——它们解析失败后只留下一条诊断，然后被静默剔除。血泪教训见 [7.8](#78-目录外模型漏写路由级-api-会静默消失本次实际踩到)。

### 方案 B：新建一个目录**不认识**的路由（推荐用于"要全量"）

```yaml
llm-pi-ai:
  providers:
    oc-go-latest:                      # 路由名不在 pi-ai 目录里
      apiKeyEnv: OC_GO_LATEST_API_KEY
      api: openai-completions          # 目录外路由必须显式声明协议
      baseURL: https://opencode.ai/zen/go/v1
      models:
        - id: deepseek-v4.1-flash
          name: deepseek-v4.1-flash
        # ……
```

因为路由名不在目录中，配置界面点**"获取可用模型"会真实访问 `/v1/models`**，把端点上全部模型拉出来。

### 方案对比

| | 方案 A（改写已有路由） | 方案 B（新建路由） |
|---|---|---|
| 模型列表来源 | 手写 | 在线拉取 ✅ |
| 是否受快照滞后影响 | 是（手写除外） | 否 ✅ |
| 是否保留目录元数据 | 整表替换后**丢失** | 自定义路由本就无元数据 |
| 新模型能否出现 | 只能手写的那几个 | 端点有什么就有什么 ✅ |
| 协议混杂处理 | 目录自带 per-model `api`，但**手写模型无法继承** → 必须写路由级 `api` | 路由级 `api` 本就需要写 ✅ |

> `modelOverrides` 是第三种写法，但它**不能新增**模型，只能修正目录已有模型（如缩短 ctx、声明图片能力），所以无法解决本问题。

---

## 6. 本次改动记录

**文件**：`C:\Users\cxxu1375\.dsh\settings.yaml`
**位置**：`llm-pi-ai.providers.opencode-go`（方案 A 路由）

| 步骤 | 改动 | 结果 |
|---|---|---|
| ① | `models` 追加 7 个低价模型 | 27 → 34 条，但**这 7 条实际未生效** |
| ② | 路由级补 `api: openai-completions` | ✅ 34 个模型全部解析成功 |

> ①单独的改动是**无效的**：手写模型没有协议可继承，解析失败后被静默剔除（详见 [7.8](#78-目录外模型漏写路由级-api-会静默消失本次实际踩到)）。②才是让它们真正出现的那一步。

新增的 7 个低价模型：

| id | 名称 | contextWindow | maxTokens | 元数据来源 / 置信度 |
|---|---|---|---|---|
| `deepseek-v4.1-flash` | DeepSeek V4.1 Flash | 1000000 | 384000 | 实测值（与 `oc-go-latest` 中一致），含 `reasoningEfforts`，**高** |
| `deepseek-flash` | DeepSeek Flash | 1000000 | 384000 | flash 稳定别名，比照 v4.1-flash，**中高** |
| `hy3-preview` | Hy3 Preview | 256000 | 128000 | 比照同系列 `hy3`，**中高** |
| `minimax-m2.5` | MiniMax-M2.5 | 204800 | 131072 | 比照 `minimax-m2.7`，**中** |
| `kimi-k2.5` | Kimi K2.5 | 262144 | 65536 | 比照 `kimi-k2.6`，**中** |
| `qwen3.5-plus` | Qwen3.5 Plus | 1000000 | 65536 | 比照 `qwen3.6-plus`，**中** |
| `glm-5` | GLM-5 | 1000000 | 131072 | 比照 GLM-5.x 系列，**中低** |

**未加入**（判定非低价档）：`grok-4.5`、`mimo-v2-omni`、`mimo-v2-pro`

**未改动**：`oc-go-latest` 路由、`agent-default-model`（仍为 `oc-go-latest` / `deepseek-v4.1-flash`）

---

## 7. 注意事项与坑

### 7.1 `models` 是整表替换，不是追加

在方案 A 路由里写 `models`，会**顶掉内置目录的全部模型**。上面这次改动之所以看起来像"追加"，是因为那个列表此前已经把 27 个目录模型抄了一遍——**真正的新增能力来自手写，不是来自目录**。

### 7.2 `maxTokens` 会变成"每请求默认上限"

按 `catalog.d.ts` 的说明：**手工配置的 `maxTokens` 会同时成为该模型每次请求的默认输出上限**；而从内置目录继承的值只是"能力描述"，不会自动变成请求上限。所以手写 `maxTokens` 时填错会直接影响实际输出长度。

### 7.3 `input` 声明宁少勿多

- **少声明**（该支持图片却只写 `text`）：图片在**附加前**就被拒，并点名模型 → 安全。
- **多声明**（不支持图片却写 `image`）：请求发出后被 provider 拒绝，此时消息已落盘，会话会反复重试一个**不可能成功**的请求 → 危险。

所以本次 7 个模型里，只有两个 deepseek 系标了 `[ text, image ]`，其余留空（默认 `text`）。

### 7.4 ctx/maxTokens 不确定时的兜底

若某个模型在 `models` 里既没写 ctx/max，内置目录里也没有，则用**路由级兜底**：

- `defaultContextWindow` = **262144**
- `defaultMaxTokens` = **32768**
- `defaultInput` = `[text]`

对 1M 上下文的模型来说，32768 的输出兜底偏小，建议显式声明。

### 7.5 端点协议是混杂的

opencode go 端点同时提供三种线协议，**不是所有模型都能用 `openai-completions` 访问**：

| 协议 | baseURL | 模型 |
|---|---|---|
| `openai-completions` | `https://opencode.ai/zen/go/v1` | 绝大多数（deepseek / glm / kimi / qwen / mimo / hy / longcat / minimax-m2.7 / omen-alpha） |
| `anthropic-messages` | `https://opencode.ai/zen/go` | `minimax-m3`、`qwen3.8-flash` |
| `openai-responses` | （见目录） | `gpt-5.6-luna`、`grok-4.6`、`muse-spark-1.2/1.3-contributor` |

方案 B 这种单路由 + 单 `api` 的自定义供应商，如果给全部 37 个模型统一标 `openai-completions`，那几个 anthropic / responses 协议模型**要到实际请求时才会失败**。

### 7.6 快照会随 DSH 版本更新

内置目录是 npm 包的一部分。`npm i -g @deepseek-ai/dsh@latest` 升级后，`data/opencode-go.json` 可能被刷新，届时手写的列表**不会自动合并**——需要重新比对。

### 7.7 排查时的环境限制

本会话 `web_search` 不可用（缺 `DEEPSEEK_API_KEY`），因此新模型的**官方定价无法在线核实**，"低价档"判断依据是内置目录里同系列已有模型的 `cost` 梯度 + 命名档位（flash / preview / 老一代）。若要精确判定，请以官网定价页为准。

### 7.8 目录外模型漏写路由级 `api` 会静默消失（本次实际踩到）

**现象**：按方案 A 补了 7 个模型后，`deepseek-v4.1-flash` **依然不出现在 opencode-go 列表里**；而自定义供应商 `oc-go-latest` 里却有。两者唯一的差别是：自定义路由写了 `api: openai-completions`，目录路由没写。

**机制**（`dsh-llm-pi-ai\lib\index.js`）：

```js
// ① models 条目的 schema —— 注意：没有 api / baseURL 字段！
const modelFields = {
  name: z.string(),
  contextWindow: z.number()...,
  maxTokens: z.number()...,
  input: z.array(z.union(MODALITIES)),
  reasoningEfforts: z.union([z.const(false), reasoningEfforts]),
  compat: compatProfile
};
const modelProfile = z.object({ id: z.string().required(), ...modelFields });

// ② 协议的解析顺序：路由级 → 目录同名模型 → 目录共享协议
const api = request.api ?? base?.api ?? routeApi;
if (api === void 0) invalid(provider,
  `model "${entry.id}" needs an api; the installed catalog does not describe it, ...`);

// ③ 失败不抛出，只记诊断并把模型从可服务列表剔除
} catch (error) {
  if (validation === "strict" || !(error instanceof PiAiCatalogError)) throw error;
  modelErrors.set(entry.id, error.message);
  continue;
}
const serviceableModels = models.filter((model) => !modelErrors.has(model.id));  // ← 静默消失
```

**为什么 `opencode-go` 拿不到协议**：

```js
function sharedCatalogApi(defaults) {
  const apis = new Set();
  for (const model of defaults.values()) apis.add(model.api);
  return apis.size === 1 ? [...apis][0] : void 0;   // 多协议 → undefined
}
```

opencode-go 目录里同时存在 `openai-completions` / `anthropic-messages` / `openai-responses` 三种协议 → 没有"共享协议"可继承 → 手写模型 `api` 解析为 `undefined` → 报错被降级为诊断 → 从列表里消失。源码注释把这条规则写得很直白：

> A route whose shipped models **disagree** … has no such answer, so a model it does not describe **must name its protocol at the route**.

**结论**：`models` 条目**无法**逐条指定协议，只能在**路由级**指定一次。所以对目录外模型而言：

- 要么整条路由统一一个协议（如 `api: openai-completions`）；
- 要么把不同协议的模型拆到多条路由。

**本次修复**（加一行即可）：

```yaml
    opencode-go:
      apiKeyEnv: OPENCODE_GO_API_KEY
      api: openai-completions        # ← 新增
      baseURL: https://opencode.ai/zen/go/v1
```

**这个改动顺带修掉了一个既有隐患**：你的 `opencode-go` 路由级 `baseURL` 早已是 `/zen/go/v1`，而 `minimax-m3`、`qwen3.8-flash` 在目录里的协议是 `anthropic-messages`（其目录 `baseUrl` 是**不带 `/v1`** 的 `/zen/go`）——"anthropic 协议 + `/v1` 地址"本身就是错配。统一成 `openai-completions` + `/v1` 后反而自洽，也与 `/zen/go/v1/models` 能列出全部 37 个模型、以及 `oc-go-latest` 全量用 OpenAI 协议可用这两点相互印证。

**副作用范围**：目录中协议本不是 `openai-completions` 的 6 个模型（`minimax-m3`、`qwen3.8-flash`、`gpt-5.6-luna`、`grok-4.6`、`muse-spark-1.2/1.3-contributor`）现在也会走 OpenAI 协议。若其中某个请求异常，为它单独建一条对应协议的路由即可（例：`api: anthropic-messages` + `baseURL: https://opencode.ai/zen/go`）。

**排查提示**：这类错误在"直接编辑文件"时是**静默**的（延迟读只保留诊断）；如果改用设置界面保存，`strict` 校验会直接把错误抛出来 —— 所以 UI 报错时不要忽略，它往往正是手写模型没生效的原因。

---

## 8. 校验与排查命令

### 8.1 校验 settings.yaml 是否合法、模型是否生效

```powershell
$nm  = "C:\Users\cxxu1375\AppData\Roaming\npm\node_modules\@deepseek-ai\dsh\node_modules"
$env:MOD = "yaml"   # 或 js-yaml
node -e "const p=require(process.env.MOD); const fs=require('fs'); const d=p.parse(fs.readFileSync(process.env.USERPROFILE+'/.dsh/settings.yaml','utf8')); const m=d['llm-pi-ai'].providers['opencode-go'].models; console.log('models:', m.length); console.log(m.map(x=>x.id).join(', '));"
```

> 需在 DSH 安装目录下执行（`workdir` 指向 `...\@deepseek-ai\dsh`），否则 `require` 解析不到 `yaml` 包。

### 8.2 对比"端点 vs 内置目录"

```powershell
# 端点
curl https://opencode.ai/zen/go/v1/models

# 内置目录
$p = "C:\Users\cxxu1375\AppData\Roaming\npm\node_modules\@deepseek-ai\dsh\node_modules\@earendil-works\pi-ai\dist\providers\data\opencode-go.json"
$j = Get-Content $p -Raw | ConvertFrom-Json
foreach ($api in $j.PSObject.Properties.Name) { $j.$api.PSObject.Properties.Name }
```

### 8.3 查目录里各模型的成本梯度

```powershell
$j = Get-Content $p -Raw | ConvertFrom-Json
$rows = foreach ($api in $j.PSObject.Properties.Name) {
  foreach ($m in $j.$api.PSObject.Properties) {
    $v = $m.Value
    [pscustomobject]@{ id=$m.Name; api=$api; ctx=$v.contextWindow; maxTok=$v.maxTokens; costIn=$v.cost.input; costOut=$v.cost.output }
  }
}
$rows | Sort-Object costIn | Format-Table -AutoSize
```

### 8.4 生效方式

`settings.yaml` 是**热读取**的（改 baseURL / 目录 / key 对下一次请求即生效），但**网页模型选择器需要刷新**才能看到新列表。

---

## 9. 关键路径速查

| 用途 | 路径 |
|---|---|
| 用户设置 | `C:\Users\cxxu1375\.dsh\settings.yaml` |
| DSH 安装根 | `C:\Users\cxxu1375\AppData\Roaming\npm\node_modules\@deepseek-ai\dsh` |
| pi-ai 目录数据 | `…\dsh\node_modules\@earendil-works\pi-ai\dist\providers\data\opencode-go.json` |
| pi-ai 目录注册表 | `…\pi-ai\dist\models.generated.js` |
| pi-ai provider 定义 | `…\pi-ai\dist\providers\opencode-go.js` |
| discovery 语义文档 | `…\@deepseek-ai\dsh-llm-pi-ai\lib\types\discovery.d.ts` |
| 配置 schema 文档 | `…\@deepseek-ai\dsh-llm-pi-ai\lib\types\config.d.ts` |
| 模型字段定义 | `…\@deepseek-ai\dsh-llm-pi-ai\lib\types\catalog.d.ts` |

---

## 附录 A：内置目录里的成本梯度

判定"低价"的依据（单位：USD / 百万 token，来自内置目录 `cost` 字段）：

| id | 输入 | 输出 | ctx | maxTokens |
|---|---|---|---|---|
| `glm-5.3-flash` | 0.07 | 0.25 | 1000000 | 131072 |
| `muse-spark-1.3-contributor` | 0.10 | 0.20 | 1048576 | 131072 |
| `muse-spark-1.2-contributor` | 0.10 | 0.20 | 1048576 | 131072 |
| `mimo-v2.5` | 0.14 | 0.28 | 1000000 | 128000 |
| `hy3` | 0.14 | 0.58 | 256000 | 128000 |
| `qwen3.8-flash` | 0.15 | 0.47 | 1000000 | 131072 |
| `gpt-5.6-luna` | 0.20 | 1.20 | 1050000 | 128000 |
| `omen-alpha` | 0.20 | 0.66 | 500000 | 128000 |
| `deepseek-v4-flash` | 0.22 | 0.66 | 1000000 | 384000 |
| `deepseek-v4-flash-vision-exp` | 0.22 | 0.66 | 1000000 | 384000 |
| `minimax-m2.7` | 0.30 | 1.20 | 204800 | 131072 |
| `longcat-2.0` | 0.30 | 1.20 | 1000000 | 131072 |
| `minimax-m3` | 0.30 | 1.20 | 1000000 | 131072 |
| `qwen3.7-plus` | 0.40 | 1.60 | 1000000 | 65536 |
| `mimo-v2.5-pro` | 0.43 | 0.87 | 1048576 | 128000 |
| `qwen3.6-plus` | 0.50 | 3.00 | 1000000 | 65536 |
| `deepseek-v4-pro` | 0.66 | 1.98 | 1000000 | 384000 |
| `hy4-preview` | 0.83 | 2.50 | 1024000 | 64000 |
| `kimi-k2.6` | 0.95 | 4.00 | 262144 | 65536 |
| `kimi-k2.7-code` | 0.95 | 4.00 | 262144 | 262144 |
| `glm-5.3` | 1.40 | 4.40 | 1000000 | 131072 |
| `glm-5.2` | 1.40 | 4.40 | 1000000 | 131072 |
| `glm-5.1` | 1.40 | 4.40 | 202752 | 32768 |
| `qwen3.8-max` | 2.00 | 6.00 | 1000000 | 131072 |
| `grok-4.6` | 2.00 | 6.00 | 500000 | 500000 |
| `qwen3.7-max` | 2.50 | 7.50 | 1000000 | 65536 |
| `kimi-k3` | 3.00 | 15.00 | 1048576 | 131072 |

**观察**：`flash` / `preview` / 老一代后缀是低价信号；同 series 内 `-max` / `-pro` 后缀价格最高（`kimi-k3` 输出 $15 为全表最贵）。

---

## 附录 B：另一条独立路由 `deepseek-official`

排查中发现，如果将来改用 `deepseek-official` 路由（`dsh-llm-deepseek` 插件），它有**自己的、完全不共用 pi-ai 的**硬编码目录：

```js
// …\dsh-llm-deepseek\lib\index.js
const DEFAULT_MODELS = [
  { id: "deepseek-flash",               name: "DeepSeek-V41-Flash", ... },
  { id: "deepseek-v4-flash",            name: "DeepSeek-V4-Flash",  ... },
  { id: "deepseek-v4-pro",              name: "DeepSeek-V4-Pro",    ... },
  { id: "deepseek-v4-flash-vision-exp", name: "DeepSeek-V4-Flash-Vision-Exp", ... }
];
```

**要点**：

1. 该目录只有 4 个模型，同样不查 `/v1/models`。
2. 其中 `deepseek-flash` 的显示名就是 **"DeepSeek-V41-Flash"**，即它本身就是 V4.1-flash 的稳定别名 —— 这是 DeepSeek 常见的"稳定别名 + 版本号 id 并存"策略。
3. 它的 `Config.models` 是可通过 `llm-deepseek` 设置段覆盖的 `z.array(catalogModel)`，字段为 `id` / `name` / `description` / `contextWindow` / `maxTokens` / `inputModalities` / `imagePixelBudget` / `imageMaxBytes` / `systemPromptUpdate`（**与 pi-ai 的字段名不同**，注意别混用）。

---

## 附：一句话总结

> DSH 的模型列表来自**打包时的目录快照**而非端点实时查询；目录里已有的路由永远不会去问 `/v1/models`。想让新模型出现，要么手写 `models`（整表替换，且**必须同时写路由级 `api`**，否则静默消失），要么新建一个目录不认识的路由换取在线拉取能力。手写时最需要小心的四件事：**漏写路由级 `api`**、整表替换、`maxTokens` 会变成请求默认上限、`input` 模态宁少勿多。
