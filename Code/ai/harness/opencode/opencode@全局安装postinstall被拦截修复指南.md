[toc]

# opencode 全局安装 postinstall 被拦截修复指南

| 项目 | 内容 |
| --- | --- |
| 文档类型 | 故障排查 + 修复指南（Troubleshooting） |
| 影响组件 | `@opencode/cli@latest`（v2，`postinstall: node ./postinstall.mjs`） |
| 错误原文 | `Error: @opencode/cli's postinstall script was not run. This occurs when installation scripts are disabled.` |
| 根因 | npm 11.16+ `allow-scripts` 白名单 / npm 12 默认禁用 install scripts，`postinstall.mjs` 没跑，本地二进制是占位 stub |
| 适用环境 | Linux 优先，附 Windows PowerShell 对照 |
| 报告日期 | 2026-10-12 |

---

## 1. 先纠正一条命令

你贴的这条命令本身写错了：

```bash
# ❌ opencode 没有 install 子命令（v2.0.26 实测 --help 无此命令）
opencode install -g @opencode/cli@latest
```

正确的是二选一：

```bash
# A. 用 npm 重装 / 升级（本次故障的主场景）
npm install -g @opencode/cli@latest

# B. 已经装好的 opencode，用它自带的升级通道（不走 npm postinstall）
opencode upgrade
# 别名：opencode update
```

后文默认你想做的是 `A`。

---

## 2. 故障现象与根因

### 2.1 现象

```text
Error: @opencode/cli's postinstall script was not run.
This occurs when installation scripts are disabled.
Run the package postinstall script or reinstall with scripts enabled.
```

`opencode --version` 直接报错退出，二进制不可用。

### 2.2 根因（已实证）

1. `@opencode/cli` 的真正二进制不是随包发布的 JS，而是 `postinstall.mjs` 按 `platform-arch` 从 `optionalDependencies` 里选包、拷贝/链接出来的：

   ```json
   // $(npm root -g)/@opencode/cli/package.json
   "postinstall": "node ./postinstall.mjs"
   ```

   本机实测该文件 `6024` 字节，装好后 `bin/opencode.exe` 约 `212 MB`。如果 postinstall 被跳过，`bin/` 下只剩一个几百字节的占位 stub（上游 issue #36737 报的是 Windows 下 `479-byte placeholder opencode.exe`，`@opencode/cli` v2 同因，见 issue #48884 / #29270）。

2. npm 11.16 引入 `allow-scripts`，npm 12（2026-07）默认禁用 install scripts。只要命中以下任一，postinstall 就会被跳过但安装仍“成功”：
   - `~/.npmrc` 里有 `allow-scripts=...` 白名单且不含 `@opencode/cli`；
   - 命令行带了 `--ignore-scripts`；
   - `strict-allow-scripts=true`（会直接硬失败）。

3. 本机就是典型现场，可复现：

   ```text
   ; "user" config from C:\Users\Administrator\.npmrc
   allow-scripts = ["@deepseek-ai/dsh-subprocess-local,koffi,node-pty,@google/genai,protobufjs"]
   registry = "https://registry.npmmirror.com"
   ```

   白名单里没有 `@opencode/cli`，所以它的 postinstall 被拦截。Linux 上同理，先查 `~/.npmrc` 和 `npm config get allow-scripts` 即可定性。

---

## 3. 诊断（Linux 优先，30 秒定性）

```bash
# 1. 版本与策略
npm --version; node --version
npm config get allow-scripts
npm config get ignore-scripts
npm config get strict-allow-scripts
cat ~/.npmrc

# 2. 全局路径与残留物
npm root -g
ls -lh "$(npm root -g)/@opencode/cli/bin/"
ls -lh "$(npm root -g)/@opencode/cli/postinstall.mjs"
opencode --version
```

判定标准：

| 检查项 | 正常 | 故障 |
| --- | --- | --- |
| `bin/opencode`（Linux）/ `bin/opencode.exe`（Windows） | 100–220 MB | 只有几百字节，或根本不能执行 |
| `npm config get allow-scripts` | 含 `@opencode/cli` 或为空（未限制） | 有值但不含 `@opencode/cli` |
| `npm config get ignore-scripts` | `false` | `true` |
| `opencode --version` | `opencode v2.0.x` | 报 `postinstall script was not run` |

Windows PowerShell 对照：

```powershell
npm --version; node --version
npm config get allow-scripts
npm config get ignore-scripts
Get-Content ~/.npmrc
npm root -g
Get-ChildItem (Join-Path (npm root -g) "@opencode/cli/bin")
opencode --version
```

---

## 4. 修复（三选一）

### 方案 1：补跑 postinstall（最快，不重装，推荐先试）

原理：包文件已在磁盘，只是二进制没展开，手动把 postinstall 跑一次即可。本机已验证 `exit=0`。

```bash
# Linux
node "$(npm root -g)/@opencode/cli/postinstall.mjs"
opencode --version
ls -lh "$(npm root -g)/@opencode/cli/bin/"
```

```powershell
# Windows PowerShell
node (Join-Path (npm root -g) "@opencode/cli/postinstall.mjs")
opencode --version
```

注意：

- 全局前缀是 `/usr/local` 且当初用了 `sudo npm install -g`，补跑也要加 `sudo`：
  `sudo node "$(npm root -g)/@opencode/cli/postinstall.mjs"`。
- nvm 用户的 `npm root -g` 类似 `~/.nvm/versions/node/v24.x.x/lib/node_modules`，不需要 sudo，直接跑。
- 跑完 `opencode --version` 应返回版本号，`bin/` 下二进制应恢复到百 MB 级。

### 方案 2：重装时单次放行（最干净，推荐根治）

`--allow-scripts` 只对本次命令生效，不会污染 `~/.npmrc`（npm 会提示 `allow-scripts setting is being ignored because --allow-scripts was passed`，属正常）。本机已用 `--dry-run` 验证 flag 被正常接受：

```bash
# Linux / Windows 通用，作用域最小
npm install -g @opencode/cli@latest --allow-scripts=@opencode/cli

# 不想鉴别包名、一次性全放行（CI / 容器里常用，安全性低于上一条）
npm install -g @opencode/cli@latest --dangerously-allow-all-scripts
```

装完验证：

```bash
opencode --version
ls -lh "$(npm root -g)/@opencode/cli/bin/"
```

如果你想**永久**把 opencode 加入白名单（以后每次升级都不用加 flag），把现有值取出来追加即可，不要直接覆盖：

```bash
# 先看现有值
npm config get allow-scripts
# 假设现有值是 a,b,c，则：
npm config set allow-scripts="a,b,c,@opencode/cli"
# 例（按本文 §2.2 现场）：
# npm config set allow-scripts="@deepseek-ai/dsh-subprocess-local,koffi,node-pty,@google/genai,protobufjs,@opencode/cli"
```

> `npm approve-scripts` 是项目级（写 `package.json` 的 `allowScripts`）工作流，用于 `npm install / npm ci --strict-allow-scripts` 的仓库，不适用于 `-g` 全局安装。全局场景用本节的 `--allow-scripts` / `npm config set allow-scripts`。

### 方案 3：绕过 npm（npm 策略实在搞不定，或镜像同步延迟时）

```bash
# 官方安装脚本（Linux / macOS / WSL2）
curl -fsSL https://opencode.ai/install | bash
opencode --version
```

其他等价通道（按需）：`brew install anomalyco/tap/opencode`、`mise use -g github:anomalyco/opencode`、`docker run -it --rm ghcr.io/anomalyco/opencode`。Windows 还可用 `choco install opencode`。

---

## 5. Linux  extra 坑位

1. **权限**：`npm prefix -g` 在 `/usr` 或 `/usr/local` 下 → 全程加 `sudo`；在 `~/.npm-global` 或 nvm 目录下 → 不要加 `sudo`，加了反而把文件属主搞坏。
2. **CPU/libc**：`postinstall.mjs` 会按 `platform-arch` 选包，`linux-x64` 还分 `baseline（无 AVX2）/ musl（Alpine）`。老机器 / Alpine 若选错包会报 `does not provide a binary for ...`，此时贴出 `cat /proc/cpuinfo | grep -m1 avx2; ldd --version` 再查。
3. **国内镜像延迟**：`registry=https://registry.npmmirror.com` 同步慢半拍时 `npm view @opencode/cli version` 可能不是最新，先确认版本再 `install@<version>`  pin 住装。
4. **`ignore-scripts=true` 残留**：有些脚手架 /  hardening 指南会全局写 `ignore-scripts=true`，`allow-scripts` 放行了也不跑，必须 `npm config set ignore-scripts=false` 或 `npm install -g ... --no-ignore-scripts`。

---

## 6. 验证清单（DoD）

```bash
opencode --version
# 期望：opencode v2.0.x，无 postinstall 报错

ls -lh "$(npm root -g)/@opencode/cli/bin/"
# 期望：二进制百 MB 级，不是几百字节 stub

# 可选：重跑一次 postinstall 应幂等成功
node "$(npm root -g)/@opencode/cli/postinstall.mjs"; echo $?
# 期望：exit 0
```

---

## 7. 参考

- npm `allow-scripts / approve-scripts / strict-allow-scripts / dangerously-allow-all-scripts`（`npm install --help`、`npm approve-scripts --help` 可见；npm 11.16 引入，npm 12 默认禁用）。
- 上游同因 issue：`@opencode/cli fails to run when install scripts are disabled #48884`、`opencode-ai postinstall was not run #29270`、`Windows placeholder opencode.exe #36737`。
