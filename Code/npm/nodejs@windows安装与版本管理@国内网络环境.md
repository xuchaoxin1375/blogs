[toc]

**Windows 上安装 Node.js：方案选择与国内网络实践**

## 摘要

Windows 上安装 **Node.js** 本身不收费。如果按字面理解成价格比较，Node.js、npm、fnm、nvm-windows 都是免费开源软件，真正需要比较的是**时间成本、维护成本和网络可靠性**。国内网络环境下，安装过程通常被拆成两段：先下载 Node.js 二进制，再下载 npm 包；两段走的是不同通道，只换其中一个往往仍会觉得慢。

截至 2026-11-06，版本选择可以先记结论：

- **新项目**优先 **Node.js 26 “Lithium”**，它已于 2026-10-28 进入 Active LTS，支持到 2029-04-30。
- **已有项目**如果依赖尚未验证 Node 26，继续用 **Node.js 24 “Krypton”**；它已转入 Maintenance LTS，支持到 2028-04-30。
- **Node.js 22** 处于 Maintenance LTS，2027-04-30 结束支持；**Node.js 20** 已于 2026-04-30 EOL，不应再用于新环境。
- 从 **Node.js 27** 开始改为每年一个主版本，且每个主版本都会进入 LTS；Node 27 目前是 Alpha，不适合生产。

安装方案按使用场景选择：

| 场景 | 推荐方案 | 理由 |
| --- | --- | --- |
| 只用一个 Node 版本，希望少折腾 | 官方 MSI，或 `winget install OpenJS.NodeJS.LTS` | 官方安装器、PATH 与卸载流程完整，和大多数教程一致 |
| 多个项目需要不同 Node 版本 | **fnm** | 原生支持 Windows，切换快，能按 `.node-version` / `.nvmrc` 自动切换 |
| 已经习惯 nvm 命令或团队要求 | **nvm-windows** | 命令与 nvm 接近，GUI 安装器友好；注意 v1 与 v2 的差异 |
| 团队要求 Node、npm、Yarn 版本随项目锁定 | **Volta** 或 fnm + `package.json` 的 `engines` | Volta 把版本写进 `package.json`，新成员无需手工切换 |
| 需要 Linux 工具链或 CI 与 Linux 一致 | WSL2 中的 Node | 与 Windows 原生 Node 隔离，但不要把 Windows 项目放在 `/mnt/c` 下跑重型构建 |
| 只是临时试一下 | 官方 ZIP 解压后当前终端改 PATH | 不写系统 PATH，退出终端即失效；不适合长期使用 |

本文的重点是前三种方案，以及国内网络下 Node 二进制、npm registry、GitHub 下载三层的配置边界。npm 镜像与 `.npmrc` 的完整说明见[npm 国内镜像加速与 registry 配置](npm@国内镜像加速与registry配置.md)，Linux 上的安装见[Linux 上安装 Node.js 与 npm](../OS/linux/nodejs@安装方案@linux系统上安装nodejs@npm.md)。

## 先分清装的是什么

Windows 上容易装乱，通常是因为把下面几件事混在一起：

- **Node.js 运行时**：提供 `node.exe`，也自带 `npm` 和 `npx`。
- **版本管理器**：fnm、nvm-windows、Volta 等，负责安装多个 Node 版本并切换 PATH。
- **包管理器**：npm、pnpm、Yarn、Bun，负责安装项目依赖；其中 npm 随 Node 自带，其他通常要单独安装。
- **安装形态**：MSI 安装器、ZIP 便携包、包管理器（winget / Scoop）分发的版本，三者写入 PATH 的方式不同。

Windows 与 Linux 最关键的区别是 **PATH 顺序决定实际运行的 `node.exe`**。同一台机器上同时存在 MSI 安装的 `C:\Program Files\nodejs\node.exe`、Scoop 的 `C:\scoop\apps\nodejs\current\node.exe` 和 fnm 的临时目录时，`node -v` 只会命中其中第一个。出现“明明切换了版本却不变”时，先用下面的命令确认实际路径，而不是反复重装：

```powershell
Get-Command node -All | Select-Object Source
where.exe node
```

**最佳实践是只保留一种主安装方式**。需要用 fnm 管理多版本时，建议卸载 MSI 版 Node，避免系统级 `node.exe` 与 fnm 的 `system` 版本互相干扰。

## 方案对比与成本视角

下表把“成本”拆成可比较的维度。所有方案本身都免费，差异在于安装步骤、权限要求、后续维护和国内下载体验。

| 方案 | 安装成本 | 多版本切换 | 权限要求 | 国内网络注意点 | 主要缺点 |
| --- | --- | --- | --- | --- | --- |
| 官方 MSI | 低，双击安装 | 不支持，需覆盖安装 | 安装到 `Program Files` 需要管理员 | MSI 可从国内镜像下载 | 只能保留一个主版本，切换靠重装 |
| winget | 低，一条命令 | 不支持 | 取决于安装器 | 包源与下载链路可能慢 | 仍受 MSI 单版本限制 |
| fnm | 中，要配置 PowerShell profile | 支持，按目录自动切换 | 普通用户即可，但需符号链接权限 | 可设置 `FNM_NODE_DIST_MIRROR` | 需要 Developer Mode 或符号链接策略 |
| nvm-windows | 中，GUI 安装器 | 支持，命令切换 | v1 常需管理员，v2 默认 shim | 可设置 `node_mirror` / `npm_mirror` | 切换有额外开销，v1/v2 命令不同 |
| Scoop | 低，适合已有 Scoop 环境 | 可用 `scoop reset` 切换 | 普通用户 | 依赖 Scoop bucket 与下载源 | 与 MSI、fnm 混装时 PATH 容易冲突 |
| Volta | 低到中 | 支持，按项目自动路由 | 普通用户 | 需要 `hooks.json` 配镜像 | 更偏团队工具链，不是纯 Node 版本管理器 |
| WSL2 | 高，需安装发行版 | 支持（Linux 侧） | 需启用虚拟化 | 走 Linux 镜像与代理体系 | 与 Windows 原生工具链隔离，跨文件系统性能差 |

如果只想要一个“不会错”的默认答案：**单版本用官方 MSI，多版本用 fnm**。nvm-windows 适合已有使用习惯的人，不建议为了“看起来专业”而额外引入。

## 推荐方案一：官方 MSI 或 winget

适合初学者、只需要一个 Node 版本、或者希望和团队文档完全一致的场景。

### 选择版本并下载

先到 [Node.js Releases](https://nodejs.org/en/about/previous-releases) 确认当前 LTS，不要凭旧文章里的版本号下载。下面以 `v26.13.0` 为例，实际使用时替换成当前版本。ARM64 设备把文件名中的 `x64` 换成 `arm64`；fnm 会按自身架构选择，winget 则以包清单为准。

官方地址：

```powershell
Invoke-WebRequest `
  -Uri https://nodejs.org/dist/v26.13.0/node-v26.13.0-x64.msi `
  -OutFile .\node-v26.13.0-x64.msi
```

国内镜像地址（二选一，先小文件测速再决定）：

```powershell
# 清华 TUNA：完整镜像，含 SHASUMS256.txt
Invoke-WebRequest `
  -Uri https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/v26.13.0/node-v26.13.0-x64.msi `
  -OutFile .\node-v26.13.0-x64.msi

# 腾讯云：同样提供 Node.js release 镜像
Invoke-WebRequest `
  -Uri https://mirrors.cloud.tencent.com/nodejs-release/v26.13.0/node-v26.13.0-x64.msi `
  -OutFile .\node-v26.13.0-x64.msi
```

`Invoke-WebRequest` 在大文件上可能偏慢；已有 aria2、IDM 或浏览器时，直接用这些工具下载也可以，后续校验步骤不变。

### 校验安装包

镜像只解决“下载快”，不解决“文件是否可信”。优先从官方或完整镜像取得 `SHASUMS256.txt`，再核对本地文件：

```powershell
Invoke-WebRequest `
  -Uri https://nodejs.org/dist/v26.13.0/SHASUMS256.txt `
  -OutFile .\SHASUMS256.txt

Get-FileHash .\node-v26.13.0-x64.msi -Algorithm SHA256
Select-String -Path .\SHASUMS256.txt -Pattern 'node-v26.13.0-x64.msi'
```

两处 SHA256 必须完全一致。**npmmirror 的 Node 镜像目录实测未提供 `SHASUMS256.txt`**，因此它适合交给 fnm/nvm 直接下载，不适合作为需要人工校验时的唯一来源。校验失败时不要继续安装，重新从官方或完整镜像下载。

### 运行安装器

双击 MSI，按默认选项安装即可。几个需要留意的选项：

- **安装路径**：默认 `C:\Program Files\nodejs` 没问题；如果自定义，避免中文、空格和过深的目录，减少原生模块与旧工具链的路径问题。
- **Tools for Native Modules**：只有在需要编译原生模块（`node-gyp`）时才勾选。它会额外下载 Python 与 Visual Studio Build Tools，体积大、耗时长，国内网络下容易卡住；不确定时先不勾，遇到 `node-gyp` 报错再补。
- **不要用管理员终端做日常 `npm install -g`**：Node 安装器已经把全局包目录指向用户目录，提权反而会制造权限混乱。

也可以用 winget 安装同一套 MSI：

```powershell
winget install --id OpenJS.NodeJS.LTS -e
```

安装完成后**新开一个终端**，不要在当前终端里反复试，因为 PATH 变更不会自动刷新到已打开的进程。

### 验证安装

```powershell
node -v
npm -v
where.exe node
npm config get prefix
```

预期结果：

- `node -v` 输出 `v26.x` 或你选择的 LTS 版本。
- `npm -v` 输出随 Node 捆绑的 npm 版本，以实际输出为准。
- `where.exe node` 指向 `C:\Program Files\nodejs\node.exe`。
- `npm config get prefix` 默认指向 `C:\Users\<user>\AppData\Roaming\npm`，而不是 `Program Files`。

如果 `npm config get prefix` 指向 `C:\Program Files\nodejs`，后续 `npm install -g` 很可能报 `EPERM`。此时应修正用户级配置，而不是长期用管理员终端：

```powershell
npm config set prefix "$env:APPDATA\npm"
```

并把 `%APPDATA%\npm` 加回用户 PATH，重新打开终端。

### 升级与卸载

升级 MSI 版可以用 winget：

```powershell
winget upgrade --id OpenJS.NodeJS.LTS -e
```

也可以下载新 MSI 覆盖安装。**不要同时保留多个 MSI 大版本**；Node 的 MSI 会替换同一安装目录，跨大版本升级前先确认项目依赖支持新版本。

卸载通过“设置 → 应用 → 已安装的应用”完成。卸载后如果还要彻底清理，再手动检查：

- 用户 PATH 中是否残留 `C:\Program Files\nodejs`。
- `%APPDATA%\npm` 与 `%LOCALAPPDATA%\npm-cache` 是否还需要保留；删除前者会丢失全局安装的工具。
- 项目目录中的 `node_modules` 与锁文件不受影响。

## 推荐方案二：fnm

fnm 用 Rust 编写，启动快，原生支持 Windows，能读取 `.node-version` 与 `.nvmrc`。对需要同时维护多个项目的开发者，它通常比 nvm-windows 更省心。

### 先启用符号链接权限

fnm 在 Windows 上切换版本需要创建符号链接。普通账户默认没有这个权限，必须先二选一：

- 打开“设置 → 系统 → 开发者选项”（Windows 10 在“更新和安全”下），启用 **开发者模式**。
- 或者运行 `secpol.msc`，在“本地策略 → 用户权限分配 → 创建符号链接”中加入当前用户，然后重启。

没有这一步，常见报错是 `A required privilege is not held by the client` 或 `os error 1314`。这不是 fnm 安装失败，而是 Windows 权限没开。

### 安装 fnm

```powershell
winget install --id Schniz.fnm -e
```

已有 Scoop 时也可以：

```powershell
scoop install fnm
```

如果通过 Scoop 安装，注意 `FNM_DIR` 可能指向 `C:\scoop\apps\fnm\current`；升级 fnm 前先确认 Node 版本目录不会被替换，必要时把 `FNM_DIR` 设为稳定目录（如 `%LOCALAPPDATA%\fnm`）再安装版本。

安装后新开终端，确认：

```powershell
fnm --version
```

### 配置 PowerShell profile

先查看 profile 路径：

```powershell
$PROFILE
```

如果文件不存在，创建它：

```powershell
$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}
notepad $PROFILE
```

在 profile 中加入两行，顺序不能反：

```powershell
$env:FNM_NODE_DIST_MIRROR = "https://npmmirror.com/mirrors/node"
fnm env --use-on-cd | Out-String | Invoke-Expression
```

第一行把 Node 二进制下载指向国内镜像；第二行初始化 fnm，并在进入含 `.node-version` / `.nvmrc` 的目录时自动切换版本。也可以把镜像写成用户级环境变量，避免每个 shell 都重复设置：

```powershell
[Environment]::SetEnvironmentVariable(
    "FNM_NODE_DIST_MIRROR",
    "https://npmmirror.com/mirrors/node",
    "User"
)
```

设置用户级变量后要新开终端才生效。之后用下面的命令确认 fnm 看到的镜像地址：

```powershell
fnm env | Select-String FNM_NODE_DIST_MIRROR
```

如果仍显示 `https://nodejs.org/dist`，说明 profile 没加载、变量设置在了错误的会话，或另一处配置覆盖了它。

### 安装与切换 Node

```powershell
fnm install --lts
fnm default 26
fnm list
node -v
```

`fnm install --lts` 会安装当前最新 LTS；`fnm default 26` 把 26.x 设为默认；`fnm list` 中带 `*` 的是当前版本。需要固定精确版本时写完整版本号：

```powershell
fnm install 26.13.0
fnm use 26.13.0
```

项目级锁定只需在仓库根目录生成版本文件：

```powershell
node -v > .node-version
```

或兼容 nvm 的写法：

```powershell
"26.13.0" > .nvmrc
```

把版本文件提交到仓库，团队成员进入目录后由 `--use-on-cd` 自动切换。`package.json` 中的 `engines` 字段仍建议保留，用于声明兼容范围；它不会自动切换版本，只会在不满足时给出警告或报错。

### 与系统 Node 共存时的注意事项

如果机器上已有 MSI 版 Node，`fnm list` 里通常会出现一个 `system` 条目。它表示 fnm 找到了系统安装的 Node，而不是 fnm 自己安装的版本。此时：

- 在 fnm 初始化的 shell 中，`where.exe node` 应优先指向 `%LOCALAPPDATA%\fnm_multishells\...`。
- 如果 `node -v` 仍是系统版本，检查 profile 是否加载、`fnm env` 是否执行、PATH 中 `C:\Program Files\nodejs` 是否排在前面。
- 最彻底的做法是卸载 MSI 版 Node，只保留 fnm，减少“到底在用哪个 Node”的歧义。

切换 Node 版本后，**全局安装的包不会自动共享**。旧版本下的 `pnpm`、`typescript` 等需要在新版本下重新安装；项目本地依赖不受影响。

### 升级 fnm

```powershell
winget upgrade --id Schniz.fnm -e
```

或：

```powershell
scoop update fnm
```

升级 fnm 不需要重装 Node 版本，已安装的版本仍在 fnm 的数据目录中。

## 方案三：nvm-windows

nvm-windows 是 Windows 上另一个成熟的版本管理器，命令与 nvm 接近。它适合已经使用 nvm 工作流、或团队统一要求 nvm 的场景。注意 nvm-windows 与 nvm-sh 不是同一个项目；在 Git Bash 或 WSL 中执行 `nvm` 时，可能命中另一套实现，先看 `nvm version` 的输出再操作。

### 安装

v2 版本（当前稳定版）可以用 winget：

```powershell
winget install --id AuthorSoftware.NVMWindows -e
```

旧版 v1 的包名不同：

```powershell
winget install --id CoreyButler.NVMforWindows -e
```

安装前先确认自己拿到的是哪一代，因为镜像配置命令不同：

```powershell
nvm version
```

v1 通常需要管理员权限，并通过符号链接把当前版本映射到 `C:\Program Files\nodejs`；v2 改为 shim 模式，默认不强制管理员，但具体仍以安装器提示为准。安装路径避免空格和中文，否则旧版本容易出现 `nvm use` 失败。

### 配置国内镜像

v2 使用 `nvm config` 子命令：

```powershell
nvm config set node_mirror=https://npmmirror.com/mirrors/node
nvm config set npm_mirror=https://registry.npmmirror.com
nvm config get node_mirror
```

v1 使用独立命令，值会写入 nvm 安装目录的 `settings.txt`：

```powershell
nvm node_mirror https://npmmirror.com/mirrors/node/
nvm npm_mirror https://npmmirror.com/mirrors/npm/
```

这里要区分两个概念：

- **`node_mirror`** 只影响 Node.js 二进制的下载地址。
- **`npm_mirror`** 在 shim 模式下作为 npm（及相关包管理器）registry 的兜底地址，但**不等于**项目安装依赖时一定使用的 registry。项目依赖仍由 `.npmrc` 的 `registry` 决定，按[npm 国内镜像配置](npm@国内镜像加速与registry配置.md)另行设置。

### 安装与切换

```powershell
nvm install lts
nvm list
nvm use lts
node -v
```

nvm-windows 的默认版本就是最近一次 `nvm use` 切换到的版本，这一点和 nvm-sh 的 `nvm alias default` 不同；v2 若要命名别名，用 `nvm alias add <name> <version>`。切换后如果 `node -v` 没变，先检查是否有其他 Node 安装排在 PATH 前面，再检查 nvm 的 `path` 设置是否与实际目录一致。

### 适用边界

nvm-windows 的优点是命令直观、GUI 安装器友好；缺点是切换有额外开销，v1 对权限和路径较敏感，全局包按版本隔离。它不是“比 fnm 更高级”的方案，只是另一套取舍。新环境如果没有历史包袱，优先 fnm 更简单。

## 国内网络：把下载链路拆成三层

只设置 `npm config set registry` 往往不够，因为 Node 安装、npm 包下载、GitHub 资源下载走的是不同域名。按下面三层分别处理，才能判断“慢在哪一段”。

### 第一层：Node.js 二进制

MSI、ZIP、fnm、nvm-windows 默认都从 `nodejs.org/dist` 下载对应版本的 Node.js 文件。国内可用镜像：

| 镜像 | 地址 | 适用 | 备注 |
| --- | --- | --- | --- |
| npmmirror | `https://npmmirror.com/mirrors/node/` | fnm、nvm-windows、手工下载 | 速度快；目录实测未提供 `SHASUMS256.txt` |
| 清华 TUNA | `https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/` | MSI、ZIP、fnm | 完整镜像，提供 `SHASUMS256.txt` |
| 腾讯云 | `https://mirrors.cloud.tencent.com/nodejs-release/` | MSI、ZIP、fnm | 腾讯云内网或华南地区可优先 |
| 华为云 | `https://mirrors.huaweicloud.com/nodejs/` | 企业网络、华为云 | 可用性随站点策略变化，使用前实测 |

选择顺序建议：**先看是否提供校验文件，再看速度**。只追求速度而放弃校验，会把供应链风险带进开发机；至少第一次安装时用官方或 TUNA 的 `SHASUMS256.txt` 核对一次。

### 第二层：npm registry

这一层决定 `npm install` 从哪里取包，和 Node 二进制镜像无关。最小配置：

```powershell
npm config set registry https://registry.npmmirror.com
npm config get registry
npm view react version
```

`npm view` 会真正发起请求，比只回显配置更能确认网络可达。完整的层级、私有 scope、锁文件与排障见[npm 国内镜像加速与 registry 配置](npm@国内镜像加速与registry配置.md)。

pnpm 复用 npm 的 `.npmrc`，通常不需要重复设置；Yarn 2+ 则改用 `.yarnrc.yml` 的 `npmRegistryServer`。这些差异不要混用。

### 第三层：GitHub 与其他二进制资源

fnm、nvm-windows 的安装包、部分工具的 release、Electron/Puppeteer 的浏览器二进制，都不经过 npm registry。可选做法：

- **优先用 winget / Scoop**：让包管理器处理下载与校验，少碰 GitHub 原始链接。
- **GitHub 加速前缀**：在确认可信的前提下，用 `https://gh-proxy.com/` 包裹原始 GitHub 链接；第三方代理能看到请求，不要用于私有仓库或带凭据的地址。
- **单独配置二进制镜像**：Electron、Puppeteer、node-sass 各有自己的环境变量，不能靠 `registry` 一项解决；具体变量见[npm 镜像边界](npm@国内镜像加速与registry配置.md)。

如果公司网络要求代理，npm 自身支持 `proxy` 与 `https-proxy` 配置；Node.js 24.5+/22.21+ 的 `http`/`https` 与 `fetch` 支持 `NODE_USE_ENV_PROXY=1` 读取 `HTTP_PROXY` / `HTTPS_PROXY` / `NO_PROXY`。代理只解决通路，不改变包来源；证书问题应通过 `NODE_EXTRA_CA_CERTS` 或系统根证书解决，不要用 `strict-ssl=false` 绕过。

## Windows 特有的坑

### PowerShell 执行策略拦截 npm

典型报错：

```shell
npm.ps1 cannot be loaded because running scripts is disabled on this system.
```

原因是 PowerShell 不允许执行 `npm.ps1`，不是 npm 损坏。可以为当前用户放开本地脚本：

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

修改后新开终端。`RemoteSigned` 允许本地脚本、要求远程脚本签名，比 `Unrestricted` 更稳妥；不要为了省事直接设成 `Bypass`。如果公司组策略锁定了执行策略，这一步会失败，需要联系管理员申请例外。

### PATH 里有多个 node.exe

MSI、Scoop、fnm、nvm-windows 都可能写入 PATH。排查顺序：

```powershell
where.exe node
Get-Command node -All | Select-Object Source
$env:PATH -split ';' | Select-String -Pattern 'node|fnm|nvm|scoop'
```

确认哪一条在最前面，再决定删除或调整。不要只看“环境变量”对话框里的用户变量，系统变量和当前会话变量也会参与。

### 全局安装报 EPERM

`npm install -g` 默认写入用户目录，一般不需要管理员。报 `EPERM` 时通常是 prefix 被指到了 `C:\Program Files\nodejs`，或者终端以另一个用户身份运行。先查：

```powershell
npm config get prefix
npm config list
```

把 prefix 改回 `%APPDATA%\npm`，并确保该目录在用户 PATH 中。不要用“管理员运行一切”掩盖配置问题。

### 长路径与中文路径

Windows 默认路径长度限制可能让深层 `node_modules` 或原生模块构建失败。可以按需开启长路径：

```powershell
# 需要管理员 PowerShell
New-ItemProperty `
  -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem `
  -Name LongPathsEnabled `
  -Value 1 `
  -PropertyType DWord `
  -Force
```

Git 也要配合：

```powershell
git config --global core.longpaths true
```

项目路径尽量使用全英文、无空格、层级较浅的目录。中文用户名本身通常没问题，但“项目路径 + 全局缓存路径 + 原生模块临时目录”叠加时更容易出错。

### Corepack 不再随 Node 26 分发

Node.js 25 起不再捆绑 **Corepack**，Node 26 也没有。仍在使用 `corepack enable` 获取 pnpm/Yarn 的项目，会直接遇到 `corepack: command not found`。处理方式二选一：

```powershell
npm install -g corepack
corepack enable
```

或直接安装包管理器：

```powershell
npm install -g pnpm
```

如果项目 `package.json` 里有 `packageManager` 字段，保留它是合理的；它表达的是“项目需要哪个版本”，不依赖 Corepack 是否随 Node 分发。

### 符号链接与 pnpm

fnm 切换版本需要符号链接权限，前面已经说明。pnpm 在 Windows 上通常会在没有开发者模式时退化为 **junction**（目录联接），因此普通安装依赖一般不需要提权；但项目自己的 `postinstall` 脚本如果直接调用 `symlinkSync(..., "dir")`，仍可能报 `EPERM`。这类问题优先改脚本为 junction，或为当前用户开启开发者模式，而不是长期用管理员终端。

### 原生模块与构建工具

安装 `better-sqlite3`、`sharp`、`node-sass` 等包时，可能触发本地编译。需要：

- Python 3（`node-gyp` 使用）。
- Visual Studio Build Tools 的 C++ 工作负载，或安装器里的“Tools for Native Modules”。
- 与 Node 版本匹配的预编译二进制；优先升级到提供预编译包的版本。

`node-sass` 已停止维护，新项目应改用纯 JavaScript 实现的 `sass`，从根源上避免二进制下载与编译问题。

### WSL 与 Windows 原生不要混用

WSL 里的 `node` 是 Linux 二进制，Windows 终端里的 `node` 是 PE 二进制，两者不共享全局包和 PATH。常见错误是在 Windows 项目里调用 WSL 的 Node，或在 `/mnt/c` 下跑大量文件监听与构建，导致性能很差。需要 Linux 工具链时，把项目放在 WSL 文件系统内；需要 Windows 原生工具时，用 Windows 侧的 Node。不要把两套安装互相软链。

## 迁移与验收

### 从 MSI 迁移到 fnm

1. 记录当前全局工具：

   ```powershell
   npm ls -g --depth=0
   ```

2. 通过“设置 → 应用”卸载 MSI 版 Node。
3. 检查用户 PATH，移除 `C:\Program Files\nodejs` 残留。
4. 按前文安装 fnm、启用开发者模式、配置 profile。
5. 安装并设为默认：

   ```powershell
   fnm install --lts
   fnm default 26
   ```

6. 重新安装需要的全局工具，例如：

   ```powershell
   npm install -g pnpm typescript
   ```

7. 新开终端，按下面的清单验收。

### 验收清单

- [ ] `node -v` 与 `npm -v` 有输出，版本符合预期。
- [ ] `where.exe node` 只指向计划使用的那一套安装。
- [ ] `npm config get prefix` 指向用户目录，不是 `Program Files`。
- [ ] `npm config get registry` 返回预期镜像，`npm view react version` 能成功。
- [ ] `fnm list` 或 `nvm list` 能看到目标版本，且当前版本正确。
- [ ] 项目目录中的 `.node-version` / `.nvmrc` 能触发自动切换。
- [ ] `npm ci` 能在干净目录中完成，锁文件来源与团队一致。
- [ ] 手工下载的安装包已按 `SHASUMS256.txt` 校验，或至少来自可信的官方/镜像渠道。
- [ ] 没有同时保留多套会争抢 PATH 的 Node 安装。

## 常见问题

| 现象 | 常见原因 | 处理 |
| --- | --- | --- |
| 安装后 `node` 仍找不到 | 当前终端未刷新 PATH | 新开终端；检查用户 PATH 是否包含安装目录 |
| `npm.ps1 cannot be loaded` | PowerShell 执行策略限制 | `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |
| `npm install -g` 报 `EPERM` | prefix 指向 `Program Files`，或权限不足 | 改回 `%APPDATA%\npm`，不要长期用管理员终端 |
| fnm 报 `os error 1314` | 没有符号链接权限 | 开启开发者模式，或在 `secpol.msc` 授予“创建符号链接” |
| `fnm use` 后版本不变 | profile 未加载，或系统 Node 排在 PATH 前面 | 检查 `$PROFILE`、`fnm env`、`where.exe node` |
| `nvm use` 失败或权限错误 | v1 需要管理员，安装路径含空格/中文 | 用管理员终端；换到简单路径；或改用 v2/fnm |
| 下载 Node 很慢 | 仍在走 `nodejs.org` | 设置 `FNM_NODE_DIST_MIRROR` 或 nvm 的 `node_mirror` |
| 镜像下载失败或校验不通过 | 镜像同步不完整，或文件下载损坏 | 换清华 TUNA/官方源；删除未完成的版本目录后重试 |
| `npm install` 仍很慢 | 只换了 Node 镜像，没换 registry；或依赖含 GitHub/Electron | 配置 `.npmrc`，再按“镜像的边界”处理二进制依赖 |
| 新版本在镜像上 404 | 镜像同步延迟 | 临时用官方源安装该版本，不要长期写死回退 |
| 证书错误 | 企业代理替换证书或根证书缺失 | 配置 `NODE_EXTRA_CA_CERTS` / `cafile`，不要关闭 TLS 校验 |
| `corepack` 找不到 | Node 25+ 不再捆绑 | `npm install -g corepack`，或直接安装 pnpm/Yarn |
| 切换版本后全局命令消失 | 全局包按 Node 版本隔离 | 在新版本下重新安装需要的全局工具 |
| 原生模块编译失败 | 缺少 Python / VS Build Tools，或无预编译包 | 安装构建工具，优先升级到有预编译产物的版本 |

## 内容依据与核验日期

- [Node.js Releases](https://nodejs.org/en/about/previous-releases)：Node 26 于 2026-10-28 进入 LTS；Node 24 于 2026-10-20 转入 Maintenance；Node 20 已 EOL。
- [Node.js 下载页](https://nodejs.org/en/download)：2026-11-06 当前 LTS 为 v26.13.0。
- [Node.js 发布计划调整](https://nodejs.org/en/blog/announcements/evolving-the-nodejs-release-schedule)：从 Node 27 起改为每年一个主版本，且每个版本都会进入 LTS。
- [fnm 文档](https://github.com/Schniz/fnm)：Windows 符号链接要求、PowerShell profile 写法、`FNM_NODE_DIST_MIRROR` 环境变量。
- [nvm-windows 镜像文档](https://docs.nvm-windows.com/features/mirrors/)：v2 的 `nvm config set node_mirror` / `npm_mirror` 与 v1 的命令差异。
- [npm config 文档](https://docs.npmjs.com/cli/v11/using-npm/config)：配置层级、`prefix`、`proxy` 与 `https-proxy`。
- [pnpm FAQ](https://pnpm.io/faq)：Windows 无开发者模式时使用 junction。
- [Node.js 企业网络配置](https://nodejs.org/en/learn/http/enterprise-network-configuration)：`NODE_USE_ENV_PROXY=1`、`NODE_USE_SYSTEM_CA=1` 的适用版本。
- [Corepack 移除说明](https://github.com/nodejs/node/commit/570d8d3f10)：Node.js 25 起不再分发 Corepack。
- 本机核验：Windows 11 + PowerShell 7，`winget` 中 `OpenJS.NodeJS.LTS` 为 26.13.0、`Schniz.fnm` 为 1.39.0；npmmirror、清华 TUNA、腾讯云的 Node 镜像路径可访问，具体可用性以实际网络为准。

版本号、包名和镜像地址会变化，执行前先用 `node -v`、`fnm --version`、`winget search` 或镜像目录确认当前值。本文把可变的版本示例写成具体数字，是为了让命令可直接复制；不要把示例当成长期固定的版本要求。
