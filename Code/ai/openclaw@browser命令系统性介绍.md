[toc]



# 🦞 OpenClaw Browser 命令完全指南

- [browser - OpenClaw](https://docs.openclaw.ai/zh-CN/cli/browser)

## 一、概述

OpenClaw browser 命令用于管理浏览器控制服务器，并执行浏览器操作（标签页管理、快照、截图、导航、点击、输入等）。

### 核心设计理念

OpenClaw 的浏览器控制能力建立在一个核心理念上：直接代码执行，而非视觉推断。 OpenClaw 通过 CDP 协议直接与浏览器引擎通信，实现毫秒级响应。

### 架构三层

系统架构分为三层：**Browser 层**（独立的 Chromium 实例，与个人浏览器完全隔离）、**Control 层**（Gateway HTTP API 提供统一控制接口）、**Agent 层**（AI 模型通过 OpenClaw CLI 调用浏览器操作）。

### 底层技术

一个**小型控制服务器**接受 HTTP 请求，通过 **CDP** 连接到基于 Chromium 的浏览器（Chrome/Brave/Edge/Chromium）。对于高级操作（click/type/snapshot/PDF），它在 CDP 之上使用 **Playwright**。

---

## 二、浏览器 Profile（配置文件）

OpenClaw 支持多个命名的 profile（路由配置），Profile 可以是：**openclaw-managed**（独立 Chromium 实例 + 独立用户数据目录 + CDP 端口）、**remote**（指向远程 CDP URL）、**extension relay**（通过本地 relay + Chrome 扩展控制现有 Chrome 标签页）。

一个浏览器上可以有多个用户,不同用户可以创建自己的配置(profile);

### 两种默认 Profile

| Profile           | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| `openclaw`        | 启动或附加到一个由 OpenClaw 管理的专用 Chrome 实例（隔离的用户数据目录）。 |
| `chrome` / `user` | 通过 Chrome DevTools MCP 控制你现有的已登录 Chrome 会话。    |

### 查看已有配置

```bash
$ openclaw browser profiles

🦞 OpenClaw 2026.3.24 (cff6dc9) — If it's repetitive, I'll automate it; if it's hard, I'll bring jokes and a rollback plan.

│
◇
remote: running (4 tabs) [default]
  port: 9222, color: #00AA00
openclaw: stopped
  port: 18800, color: #FF4500
user: stopped [existing-session]
  transport: chrome-mcp, color: #00AA00
```

### 查看具体的profile

在`openclaw browser`这个命令范畴下,通过全局选项:`--browser-profile`这个来指定具体的profile;

```bash
# (base) (node:v22.22.1)[wsl][Ubuntu 24.04][bash]opcxxu@OP-XCX in /mnt/c/Users/opcxxu/Desktop [17:26:31]
$ openclaw browser --browser-profile openclaw status

🦞 OpenClaw 2026.3.24 (cff6dc9) — Hot reload for config, cold sweat for deploys.

│
◇
profile: openclaw
enabled: true
running: true
transport: cdp
cdpPort: 18800
cdpUrl: http://127.0.0.1:18800
browser: custom
detectedBrowser: custom
detectedPath: /usr/bin/google-chrome-stable
profileColor: #FF4500
```

```bash
$ openclaw browser --browser-profile remote status

🦞 OpenClaw 2026.3.24 (cff6dc9) — Finally, a use for that always-on Mac Mini under your desk.

│
◇
profile: remote
enabled: true
running: true
transport: cdp
cdpPort: 9222
cdpUrl: http://localhost:9222
browser: unknown
detectedBrowser: custom
detectedPath: /usr/bin/google-chrome-stable
profileColor: #00AA00
```



### 使用已有的profile配置

```bash
# (base) (node:v22.22.1)[wsl][Ubuntu 24.04][bash]opcxxu@OP-XCX in /mnt/c/Users/opcxxu [17:21:36]
$ openclaw browser --browser-profile openclaw open https://www.baidu.com

🦞 OpenClaw 2026.3.24 (cff6dc9) — Your .zshrc wishes it could do what I do.

│
◇
opened: https://www.baidu.com/
id: FFA3A714E5C30160A10E7A6C8EA2E021
```

这里使用`--browser-profile openclaw`指定上述查询到的配置中的`openclaw`profile,并利用其打开`www.baidu.com`这个网站



### Profile 管理命令

```bash
# 列出所有 profile
openclaw browser profiles

# 创建自定义 profile(需要小心,容易出错)
openclaw browser create-profile --name work --color "#FF5A36"

# 创建 existing-session profile
openclaw browser create-profile --name chrome-live --driver existing-session

# 删除 profile
openclaw browser delete-profile --name work
```

默认的 `openclaw` profile 如果缺失会自动创建。

```bash
$ openclaw browser profiles

remote: running (3 tabs) [default]
  port: 9222, color: #00AA00
openclaw: stopped
  port: 18800, color: #FF4500
user: stopped [existing-session]
  transport: chrome-mcp, color: #00AA00
```

这里我配置了远程浏览器(remote),例如在wsl2中的openclaw就可以调用windows上的浏览器执行操作;

### windows上设置浏览器

#### 使用remote CDP模式

使用 remote CDP 模式（最稳定）避免 WSL 直接启动 Windows 浏览器的问题

1. 在 Windows (powershell)上启动 Edge（远程调试）：

   这里端口通过`--remote-debugging-port`来设置,默认使用9222.

   ```powershell
   & "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --remote-debugging-port=9222 --user-data-dir="C:\temp\edge-debug"
   ```

   > 注意浏览器安装路径,如果不是默认的,请自行修改
   >
   > 这里使用`&`让相关浏览器进程在后台运行,避免阻塞当前shell会话.

2. 在 WSL 中配置参考：

   ```powershell
   openclaw config set browser.profiles.remote '{"cdpUrl":"http://WINDOWS_HOST_OR_IP:9222","attachOnly":true,"color":"#00AA00"}' --strict-json
   openclaw config set browser.defaultProfile "remote"
   ```

#### WINDOWS_HOST_OR_IP

> 这里的`http://WINDOWS_HOST_OR_IP:9222`,如果wsl在启用了wsl中的mirrored网络,则`WINDOWS_HOST_OR_IP`可以替换为`localhost`,如果不是mirrored模式,请自行查询windows ip在wsl中的值;

下面有`WINDOWS_HOST_OR_IP`代指正确的windows ip地址

### 验证修复

```bash
# 检查浏览器状态  
openclaw browser status  
  
# 测试基本功能  
openclaw browser open https://www.baidu.com
```



### 正确和规范地配置浏览器profile

`openclaw browser create-profile`命令目前不稳定,官方文档中的示例语句

```bash
openclaw browser create-profile --name work --color "#FF5A36"
```

可能都无法运行

错误的示例如下

```bash
# (base) (node:v22.22.1)[wsl][Ubuntu 24.04][bash]opcxxu@OP-XCX in /mnt/c/Users/opcxxu/Desktop [16:29:30]
$ openclaw browser create-profile --name remote --color "#00AA00"

🦞 OpenClaw 2026.3.24 (cff6dc9) — I don't judge, but your missing API keys are absolutely judging you.

│
◇
GatewayClientRequestError: browser.request cannot create or delete persistent browser profiles


```

错误分析:

> `openclaw browser create-profile` 这个命令在 CLI 里确实存在；
>
> 但返回的 `browser.request cannot create or delete persistent browser profiles` 来看，推断当前这次调用走到的是 `browser.request`/代理式浏览器后端，而不是一个允许直接持久化修改 profile 的本地配置路径。

OpenClaw 文档把持久化浏览器 profile 放在 `browser.profiles` 配置里；并且在 node/browser proxy 场景下，profile 也是来自对应主机自己的 `browser.profiles` 配置。

因此你这里更稳妥的做法不是继续依赖 `browser create-profile`，而是**直接写配置**。这是基于文档结构做的推断。[2](https://openclawlab.com/en/docs/tools/browser/)

另一方面:

```bash
🦞 OpenClaw 2026.3.24 (cff6dc9) — Type the command with confidence—nature will provide the stack trace if needed.

Error: Config validation failed: browser.profiles.remote.color: Invalid input: expected string, received undefined
[ble: exit 1]
```

`openclaw config set browser.profiles.remote.cdpUrl "http://localhost:9222"` 之所以报 `remote.color` 缺失，是因为 OpenClaw 对配置做**严格校验**；

浏览器 profile 的官方示例是一个完整对象，至少包含 `cdpUrl` 和 `color`，而你只写了一个子字段，导致候选配置里的 `remote` profile 变成“不完整对象”，所以校验失败。

文档也明确说配置必须完整匹配 schema，校验失败时会拒绝应用。[2](https://openclawlab.com/en/docs/tools/browser/)

所以正确做法是：**一次性把整个 `remote` profile 写进去**，不要分两步只写叶子节点。`openclaw config set` 的值支持按 JSON5 解析，因此你可以直接把整个对象作为 value 传入。[3](https://docs.openclaw.ai/cli/config)

如果你不想用命令行，也可以直接编辑 `~/.openclaw/openclaw.json`；文档说明这个文件就是主配置文件，而且 Gateway 会监视该文件并自动应用大多数变更。[4](https://openclawlab.com/en/docs/gateway/configuration/)

对应的配置长这样：

```json
{
  "browser": {
    "defaultProfile": "remote",
    "profiles": {
      "remote": {
        "cdpUrl": "http://WINDOWS_HOST_OR_IP:9222",
        "attachOnly": true,
        "color": "#00AA00"
      }
    }
  }
}
```

官方 WSL2 文档明确说，如果 Chrome 跑在 Windows、Gateway 跑在 WSL2，就应该使用**WSL2 能访问到的 Windows 地址**，而不是“只在 Windows 自己那边可用”的地址；

并且建议先在 WSL2 里用 `curl` 测试这个地址(如果是mirrored网络模式,可以用`localhost`)。对于外部管理的浏览器，文档也建议保留 `attachOnly: true`。[5](https://docs.openclaw.ai/tools/browser-wsl2-windows-remote-cdp-troubleshooting)

官方给的排查顺序是：

```bash
# 先在 Windows 验证 Chrome 真开了 CDP
curl http://127.0.0.1:9222/json/version

# 再在 WSL2 里验证 WSL 能不能连到那个 Windows 地址
curl http://WINDOWS_HOST_OR_IP:9222/json/version
curl http://WINDOWS_HOST_OR_IP:9222/json/list
```

只有当这一步通了，OpenClaw 里的 `cdpUrl` 才应该写成同一个 `WINDOWS_HOST_OR_IP`。[5](https://docs.openclaw.ai/tools/browser-wsl2-windows-remote-cdp-troubleshooting)

然后再测试：

```bash
openclaw browser open https://example.com --browser-profile remote
openclaw browser tabs --browser-profile remote
```

这是文档给出的端到端验证方式。[5](https://docs.openclaw.ai/tools/browser-wsl2-windows-remote-cdp-troubleshooting)

**一句话总结：**

1. `create-profile` 在你当前环境里没真正创建成功；
2. `config set ...cdpUrl` 单独写会因为 profile 不完整而校验失败；
3. 在 WSL2 场景下，`localhost:9222` 还可能是错地址；
4. 最稳的是**一次性写完整 profile 对象**，并把 `cdpUrl` 改成 **WSL2 实际可达的 Windows 地址**。[2](https://openclawlab.com/en/docs/tools/browser/)

---

## 三、全局通用选项

所有命令都接受 `--browser-profile <name>` 来指定目标 profile。 所有命令也接受 `--json` 获取机器可读的稳定输出。

---

## 四、生命周期管理命令

| 命令                             | 说明                   |
| -------------------------------- | ---------------------- |
| `openclaw browser status`        | 查看浏览器控制服务状态 |
| `openclaw browser start`         | 启动受管浏览器实例     |
| `openclaw browser stop`          | 停止受管浏览器实例     |
| `openclaw browser reset-profile` | 重置 profile 数据      |

**示例：**
```bash
openclaw browser --browser-profile openclaw status
openclaw browser --browser-profile openclaw start
```

---

## 五、标签页（Tab）管理命令

OpenClaw 提供确定性的标签页控制（list/open/focus/close）。

| 命令                                | 说明                         |
| ----------------------------------- | ---------------------------- |
| `openclaw browser tabs`             | 列出所有打开的标签页         |
| `openclaw browser open <url>`       | 打开新标签页并导航到指定 URL |
| `openclaw browser focus <targetId>` | 聚焦到指定标签页             |
| `openclaw browser close <targetId>` | 关闭指定标签页               |
| `openclaw browser navigate <url>`   | 当前标签页导航到新 URL       |

**示例：**
```bash
openclaw browser open https://docs.openclaw.ai
openclaw browser tabs
openclaw browser focus <targetId>
openclaw browser close <targetId>
```

---

例如focus切换浏览器当前标签:

查询指定profile的已开启标签tabs

```bash
$ openclaw browser --browser-profile remote tabs
...
6. 百度一下，你就知道
   https://www.baidu.com/
   id: 2FB2A53F893935CD01C01C2A8F98E824
```

假设我们要切换到第6个标签,但是指定的时候要`id`号,在不引起混淆的情况在,可以指定id中的前几位,比如`2FB`就足够了

```bash
# (base) (node:v22.22.1)[wsl][Ubuntu 24.04][bash]opcxxu@OP-XCX in /mnt/c/Users/opcxxu/Desktop [18:03:12]
$ openclaw browser --browser-profile remote focus 2FB

🦞 OpenClaw 2026.3.24 (cff6dc9)
   I read logs so you can keep pretending you don't have to.

│
◇
focused tab 2FB
```



## 六、快照（Snapshot）命令 ⭐ 核心

快照是 AI Agent 理解**页面结构**的关键工具。

`openclaw browser snapshot`执行指定页面的节点解析(快照)

它有两种模式：

### 1. AI/ARIA 快照（默认）

输出包含数字引用的文本快照。

内部通过 Playwright 的 aria-ref 解析引用。

### 2. Role 快照（交互模式）

通过 `openclaw browser snapshot --interactive`（或 `--compact`、`--depth`、`--selector`、`--frame`）获取基于角色的列表/树，带有 `[ref=e12]` 标记。操作示例：`openclaw browser click e12`，`openclaw browser highlight e12`。

### Snapshot 主要参数

| 参数                 | 说明                                       |
| -------------------- | ------------------------------------------ |
| `--format aria\|ai`  | 快照格式                                   |
| `--interactive`      | 输出可交互元素的扁平列表（最适合驱动操作） |
| `--compact`          | 紧凑输出，减少 token 消耗                  |
| `--depth <n>`        | 控制快照深度                               |
| `--selector <sel>`   | 限定范围到特定 CSS 选择器                  |
| `--frame "<iframe>"` | 将 role 快照限定到 iframe 范围             |
| `--labels`           | 在视口截图上叠加引用标签                   |
| `--target-id <id>`   | 指定目标标签页                             |
| `--out <path>`       | 输出到文件                                 |

**推荐组合：**
```bash
openclaw browser snapshot --interactive --compact --depth 6
```

> ⚠️ 元素引用（@e1、@e2 等）在任何 DOM 变化（点击、输入、导航、重渲染）后会立即失效。每次操作后必须重新获取快照。

---

## 七、交互操作命令（Actions）

click/type 等操作**需要来自 snapshot给出的引用**（数字 `12` 或 role 引用 `e12`）。CSS 选择器有意不被支持。

> 通过focus命令切换到指定标签后,然后执行snapshot命令解析该tab(页面)

| 命令                                 | 说明             |
| ------------------------------------ | ---------------- |
| `openclaw browser click <ref>`       | 点击元素         |
| `openclaw browser type <ref> <text>` | 在元素中输入文本 |
| `openclaw browser drag`              | 拖拽元素         |
| `openclaw browser select`            | 下拉框选择       |
| `openclaw browser highlight <ref>`   | 高亮元素         |
| `openclaw browser upload`            | 文件上传         |
| `openclaw browser dialog`            | 处理对话框       |

### Click 详细参数

```bash
openclaw browser click <ref> [--double] [--button <left|right|middle>] [--modifiers <csv>] [--target-id <id>]
```

### Type 详细参数

```bash
openclaw browser type <ref> <text> [--submit] [--slowly] [--target-id <id>]
```

> 💡 `upload` 和 `dialog` 是预设调用（arming calls），需要在触发选择器/对话框的 click/press 之前运行。

---

## 八、截图（Screenshot）与 PDF

```bash
# 视口截图
openclaw browser screenshot

# 全页截图
openclaw browser screenshot --full-page

# 指定元素截图
openclaw browser screenshot --ref 12

# 保存到文件
openclaw browser screenshot --out ./my-screenshot.png

# 导出 PDF
openclaw browser pdf
```

---

截图示例:

```bash
# (base) (node:v22.22.1)[wsl][Ubuntu 24.04][bash]opcxxu@OP-XCX in /mnt/c/Users/opcxxu/Desktop [18:18:11]
$ openclaw browser --browser-profile remote screenshot

🦞 OpenClaw 2026.3.24 (cff6dc9) — We ship features faster than Apple ships calculator updates.

│
◇
MEDIA:~/.openclaw/media/browser/859fefa3-578a-4908-abc6-0d7bc2cc5dfb.jpg
```



## 九、典型工作流程

以下是一个完整的自动化交互流程：

```bash
# 1. 启动受管浏览器
openclaw browser --browser-profile openclaw start

# 2. 打开目标页面
openclaw browser open https://example.com

# 3. 获取页面快照（获取可交互元素及引用）
openclaw browser snapshot --interactive --compact

# 4. 使用引用执行操作（例如点击 e1）
openclaw browser click e1

# 5. 重新获取快照（引用已失效！）
openclaw browser snapshot --interactive --compact

# 6. 在输入框中输入文本
openclaw browser type e3 "hello world" --submit

# 7. 截图确认结果
openclaw browser screenshot --out result.png

# 8. 关闭浏览器
openclaw browser stop
```

---

## 十、浏览器配置

浏览器设置位于 `~/.openclaw/openclaw.json` 中。

关键配置项：

```json5
{
  browser: {
    enabled: true,
    defaultProfile: "openclaw",    // 默认 profile
    // executablePath: "/path/to/chrome",  // 可选：指定浏览器路径
  }
}
```

### 远程 CDP / Browserless 配置

Browserless 是一个托管 Chromium 服务，通过 HTTPS 暴露 CDP 端点。你可以将 OpenClaw 浏览器 profile 指向 Browserless 区域端点并使用 API key 认证。

---

## 十一、安全注意事项

- 浏览器控制仅限 loopback；访问通过 Gateway 的认证或 node 配对流转。
- 将远程 CDP URL/token 视为敏感信息；建议使用环境变量或密钥管理器。
- `browser.ssrfPolicy.dangerouslyAllowPrivateNetwork` 默认为 `true`（可信网络模型），设为 `false` 可启用严格的公网浏览模式。

---

## 十二、常见问题排查

| 问题               | 解决方案                                                     |
| ------------------ | ------------------------------------------------------------ |
| Playwright 不可用  | 安装完整的 Playwright 包（不是 playwright-core）并重启 Gateway |
| 元素未找到         | 使用 `snapshot --labels` 生成带标签的截图                    |
| 操作超时           | 增大 `--timeout-ms` 参数值                                   |
| 登录过期           | 使用 `cookies --json` 检查 cookie 状态                       |
| Gateway 在远程机器 | 必须在实际有浏览器的机器上运行 node host，Gateway 会将操作代理到该 node。 |

---

## 参考链接

- 📚 官方文档：`docs.openclaw.ai/tools/browser` 和 `docs.openclaw.ai/cli/browser`

  
