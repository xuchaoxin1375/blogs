[toc]

## 摘要

国内网络访问 **npm**(Node Package Manager) 官方源 `https://registry.npmjs.org` 时常出现延迟高、下载中断或安装卡住的问题。最直接的解决办法是把 **registry**(包注册表) 换成国内镜像，一条命令即可生效：

```shell
npm config set registry https://registry.npmmirror.com
```

但“换源”只是起点。实际排障时还需要弄清三件事：

- 配置写到了哪一层，为什么会被别的配置覆盖。
- 镜像只代理 registry，哪些依赖仍然会走 GitHub 或独立下载站。
- 镜像不是官方源，发布、私有包和锁文件分别要注意什么。

本指南按“快速配置 → 配置层级 → 包管理器差异 → 镜像边界 → 排障”的顺序展开。Node.js 与 npm 的安装不在本文范围，见[Linux 上安装 Node.js 与 npm](../OS/linux/nodejs@安装方案@linux系统上安装nodejs@npm.md)和[npm、pnpm 等包管理器选择](nodejs@包管理器选择指南.md)。

## 快速开始

### 设置并验证镜像

```shell
npm config set registry https://registry.npmmirror.com
```

该命令默认写入用户级 `.npmrc`，对当前用户的所有项目生效。设置完成后验证：

```shell
$ npm config get registry
https://registry.npmmirror.com

$ npm view react version
19.3.1
```

第二条命令会真正向 registry 请求元数据，比只回显配置更能确认网络可达。输出的版本号随镜像同步进度变化，不必与示例一致。

### 只想临时用一次

在单条命令上覆盖，不修改任何配置文件：

```shell
npm install react --registry=https://registry.npmmirror.com
```

这种方式适合临时排障或对比镜像质量。需要长期生效时仍应写入配置文件，避免每条命令都带参数。

### 恢复官方源

```shell
npm config delete registry
```

删除用户级配置后，npm 回到内置默认值 `https://registry.npmjs.org`。如果项目级 `.npmrc` 里也写了 `registry`，需要一并处理，否则项目内仍然使用镜像。

## 配置层级与优先级

### 配置来源的优先级

npm 合并多层配置，优先级从高到低如下：

| 优先级 | 来源 | 示例 |
| --- | --- | --- |
| 最高 | 命令行参数 | `--registry=...` |
| 高 | 环境变量 | `NPM_CONFIG_REGISTRY` |
| 中 | 项目级 `.npmrc` | 项目根目录下的 `.npmrc` |
| 低 | 用户级 `.npmrc` | `~/.npmrc` |
| 更低 | 全局级 `npmrc` | `$PREFIX/etc/npmrc` |
| 最低 | npm 内置 `npmrc` 与默认值 | npm 安装目录下的 `npmrc` |

**同名配置以优先级高者为准**。排查“明明设置了却不生效”时，先确认是不是被更高层覆盖。

### npmrc 的四个层级

| 层级 | 默认位置 | 查询命令 | 典型用途 |
| --- | --- | --- | --- |
| 项目级 | `<project>/.npmrc` | 无直接查询命令，位于项目根目录 | 固定团队镜像、声明私有 scope(作用域) |
| 用户级 | `~/.npmrc`，Windows 为 `%USERPROFILE%\.npmrc` | `npm config get userconfig` | 个人默认镜像 |
| 全局级 | `$PREFIX/etc/npmrc` | `npm config get globalconfig` | 整机或 CI 统一配置 |
| 内置级 | npm 安装目录下的 `npmrc` | 无 | npm 自身默认值，通常不改 |

`$PREFIX` 随安装方式变化，不要凭经验拼路径，直接用 `npm config get globalconfig` 查询。Windows 上用户级路径也可能因 `HOME` 变量而不同，同样以命令输出为准。

### 查看与修改配置

```shell
$ npm config get registry
https://registry.npmmirror.com

$ npm config list
; "user" config from /path/to/home/.npmrc

registry = "https://registry.npmmirror.com"

; node bin location = /path/to/node
; node version = v24.21.0
; npm version = 11.19.0
; cwd = /path/to/project
; HOME = /home/user
; Run `npm config ls -l` to show all defaults.
```

`npm config list` 开头的注释会列出实际加载的配置文件路径，是确认“哪份文件在生效”的快捷方式。其他常用操作：

- `npm config ls -l`：列出全部默认值与当前值，用于查不熟悉的配置项。
- `npm config edit`：用默认编辑器打开用户级 `.npmrc`。
- `npm config set <key>=<value> --location=project`：写入项目级 `.npmrc`。
- `npm config delete <key>`：删除指定配置，拼写错误时通常不会报错，容易误以为已生效。

### 项目级 .npmrc 示例

```ini
registry=https://registry.npmmirror.com
@mycompany:registry=https://registry.example.com/
//registry.example.com/:_authToken=${NPM_TOKEN}
```

这三行分别表示：默认走国内镜像；`@mycompany` 作用域的包走公司私有 registry；私有 registry 的凭据从环境变量 `NPM_TOKEN` 读取。

项目级 `.npmrc` 可以提交到仓库，让团队和 **CI**(Continuous Integration, 持续集成) 使用同一套源，但不要把真实 token(凭据) 写进去。npm 会在读取时展开 `${NPM_TOKEN}`，在 CI 中通过 secret 注入即可。

## 镜像源怎么选

| 镜像 | registry 地址 | 说明 |
| --- | --- | --- |
| npmmirror(淘宝 NPM 镜像) | `https://registry.npmmirror.com` | 阿里维护，同步较及时，另有 Electron、node-sass 等二进制镜像，适合作为默认 |
| 华为云 | `https://mirrors.huaweicloud.com/repository/npm/` | 企业网络或华为云环境可优先，末尾斜杠不要漏 |
| 腾讯云 | `https://mirrors.cloud.tencent.com/npm/` | 腾讯云内网或华南地区可优先 |
| npm 官方 | `https://registry.npmjs.org` | 发布新包、核对最新版本、镜像缺包时的回退 |

以上地址在 2026-11-06 实测均能返回 `react` 的包元数据，但可用性会随网络和站点策略变化，选型前建议用 `npm view` 实测。旧的淘宝域名 `registry.npm.taobao.org` 已废弃，不要继续使用。

选择镜像时的判断顺序：

- **同步及时性**优先于峰值速度：刚发布的包在镜像上可能还不存在。
- **网络位置**决定实际体验：云主机优先选同厂商内网镜像。
- **可信度**决定供应链风险：优先选长期维护的大厂镜像，不使用来源不明的私人源。
- **可回退**：保留一条切换到官方源的命令，镜像故障时不至于卡死。

## 各包管理器的配置

### npm

npm 读取 `.npmrc`，配置方法同上。作用域与认证信息写在 `.npmrc` 中，不在命令行传 token，避免进入 shell 历史。

`cnpm` 是早期常见的替代方案，本质是固定使用 npmmirror 的独立命令行工具。既然 npm 本身就能通过 registry 配置达到同样效果，通常不必额外安装 `cnpm`，少一层工具也少一处版本差异。

### pnpm

pnpm 复用 npm 的 `.npmrc`，以下命令写入的是用户级配置：

```shell
pnpm config set registry https://registry.npmmirror.com
pnpm config get registry
```

已有 npm 用户级配置时通常无需重复设置。pnpm 锁文件默认不写入 registry 主机，换源后一般不必重建；如果团队开启过 `lockfileIncludeTarballUrl`，注意锁文件里可能固定了旧镜像的下载地址。

### Yarn

Yarn 1 与 Yarn 2+ 的配置方式不同：

- Yarn 1 读取 `.npmrc` 与 `.yarnrc`：`yarn config set registry https://registry.npmmirror.com`。
- Yarn 2+ 不再读取 `.npmrc` 的 `registry`，改用 `.yarnrc.yml` 的 `npmRegistryServer`。

```yaml
npmRegistryServer: "https://registry.npmmirror.com"
```

修改后用 `yarn config get npmRegistryServer` 验证。私有 scope 和认证的字段名也与 npm 不同，按 Yarn 当前版本文档配置。

## 镜像的边界：哪些东西不会被加速

更换 registry 只影响 npm 包的元数据与 tarball(包压缩包) 下载。以下依赖仍走各自的下载渠道，**只换镜像不会提速**：

| 下载对象 | registry 是否生效 | 需要额外配置 |
| --- | --- | --- |
| 普通 npm 依赖 | 是 | 无 |
| Git 或 GitHub 依赖 | 否 | 代理，或改用带镜像地址的依赖写法 |
| Electron 二进制 | 否 | `.npmrc` 中 `electron_mirror=https://npmmirror.com/mirrors/electron/` |
| Puppeteer 浏览器 | 否 | 环境变量 `PUPPETEER_DOWNLOAD_BASE_URL=https://cdn.npmmirror.com/binaries/chrome-for-testing` |
| node-sass 二进制 | 否 | 环境变量 `SASS_BINARY_SITE=https://npmmirror.com/mirrors/node-sass/` |
| Docker 基础镜像 | 否 | 单独配置容器 registry 镜像加速 |

补充说明：

- `node-sass` 已停止维护，新项目应使用纯 JavaScript 实现的 `sass`，从根源上避免二进制下载问题。
- 二进制镜像的环境变量名会随工具版本调整，配置前查对应版本文档，不要照抄旧教程。
- 原生模块即使二进制下载成功，首次编译仍会消耗 CPU，这部分时间与镜像无关。

需要代理而不是镜像时，参见[Windows 系统配置代理的若干方法](../../Miscellaneous/windows系统配置代理的若干方法.md)。npm 本身也支持 `proxy` 与 `https-proxy` 配置项，但代理只解决通路问题，不改变包来源。

## 发布与私有包

镜像适合安装，不适合发布。**发布和账号操作应显式指向官方源**：

```shell
npm publish --registry=https://registry.npmjs.org
npm whoami --registry=https://registry.npmjs.org
```

注意事项：

- 刚发布的版本可能在镜像上暂时不可见，这是同步延迟，不是发布失败。
- 私有包必须通过 `@scope:registry` 指向私有 registry，否则会向镜像请求而得到 404。
- 不要把 `_authToken` 明文写进项目 `.npmrc`；提交前检查 diff，必要时用 `git secrets` 一类工具拦截。
- 公司内网无法访问公网镜像时，用 Nexus、Verdaccio 等搭建私有代理，并把 registry 指向内网地址，而不是让每台机器各自配代理。

## 常见问题与排障

| 现象 | 常见原因 | 处理 |
| --- | --- | --- |
| `npm config get registry` 已是镜像，安装仍走官方 | 命令行参数、环境变量或项目 `.npmrc` 覆盖了用户配置 | 用 `npm config list` 查看加载的文件与来源，逐层排查 |
| 设置后立即生效，换项目又变回官方 | 项目级 `.npmrc` 写死了官方源，或被 `NPM_CONFIG_REGISTRY` 覆盖 | 检查项目根目录与 CI 环境变量 |
| 安装某个包报 404，官方源可以找到 | 镜像尚未同步，或包属于私有 scope | 用官方源验证后临时指定 registry，或补 `@scope:registry` |
| 换源后安装还是很慢 | 依赖含 Git 依赖、Electron、Puppeteer 等非 registry 资源 | 按“镜像的边界”一节逐项配置，或检查网络代理 |
| 出现证书错误 | 企业代理替换了证书，或系统根证书缺失 | 配置 `cafile` 或 `NODE_EXTRA_CA_CERTS`，不要用 `strict-ssl=false` 绕过 |
| 同事拉取后从旧镜像下载 | 锁文件里保存了旧的 `resolved` 地址 | 统一项目 `.npmrc` 后重新生成锁文件，评审时留意来源变化 |
| 镜像站返回 5xx 或超时 | 镜像临时故障或网络抖动 | 用 `--registry=https://registry.npmjs.org` 临时回退，不长期写死 |
| `npm ci` 在 CI 中很慢 | CI 未继承开发机的用户级配置 | 在 CI 中设置 `NPM_CONFIG_REGISTRY`，或提交项目级 `.npmrc` |

排查安装请求实际发往哪里，可以打开 HTTP 日志：

```shell
npm install --loglevel=http
```

日志中的请求主机能直接说明是否命中镜像。若怀疑缓存了旧的 404 结果，执行 `npm cache verify`；仍有异常时再考虑 `npm cache clean --force`，不要把它当成常规操作。

## 安全与可靠性

- **镜像不是官方源**：镜像运营方能看到你请求的包名，也可能延迟或遗漏同步。生产依赖应固定版本与锁文件，关键包可用官方源交叉核对。
- **不要关闭 TLS 校验**：TLS(Transport Layer Security, 传输层安全) 校验关闭后，中间人攻击风险会进入整条依赖链；证书问题应从根证书或代理配置解决。
- **凭据最小化**：token 只放在用户级配置或 CI secret 中，项目级 `.npmrc` 只引用环境变量。
- **锁文件入库**：npm 的 `package-lock.json` 会把 `resolved` 下载地址写进锁文件，团队统一源后再生成，避免不同机器解析出不同来源。
- **保留回退路径**：镜像故障时能一条命令切回官方源，是比“选一个永远可用的镜像”更现实的做法。

## 检查清单

- [ ] `npm config get registry` 返回预期的镜像地址。
- [ ] 用 `npm view <package> version` 或实际安装验证过网络可达。
- [ ] 项目级 `.npmrc` 已提交，且不含明文 token。
- [ ] CI 使用与开发机一致的 registry 配置。
- [ ] 发布与账号操作显式使用官方源。
- [ ] Electron、Puppeteer、node-sass 等二进制依赖已单独配置或已替换。
- [ ] 锁文件来源与团队镜像一致，`npm ci` 可复现安装。
- [ ] 知道如何用 `--registry` 临时回退官方源。

## 参考资料

- [npm config 文档](https://docs.npmjs.com/cli/v11/using-npm/config)
- [npmrc 配置说明](https://docs.npmjs.com/cli/v11/configuring-npm/npmrc)
- [npm registry 文档](https://docs.npmjs.com/cli/v11/using-npm/registry)
- [npmmirror 镜像站](https://npmmirror.com/)
- [pnpm 配置文档](https://pnpm.io/npmrc)
- [Yarn 配置文档](https://yarnpkg.com/configuration/yarnrc)
