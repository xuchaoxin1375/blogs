[toc]

## abstract

**常用的 Scoop bucket（软件源仓库）清单**，并按用途分类，方便你按需添加。

------

### 官方维护的 bucket

| 名称           | 地址                          | 特点                                         |
| -------------- | ----------------------------- | -------------------------------------------- |
| **main**       | 默认安装                      | 基础常用工具，最核心的软件集合               |
| **extras**     | `scoop bucket add extras`     | 扩展软件，包含常见桌面应用、开发工具         |
| **versions**   | `scoop bucket add versions`   | 同一软件的多个版本（旧版/预览版/长期支持版） |
| **nirsoft**    | `scoop bucket add nirsoft`    | NirSoft 系列小工具                           |
| **php**        | `scoop bucket add php`        | PHP 各版本及相关组件                         |
| **nerd-fonts** | `scoop bucket add nerd-fonts` | 常见 Nerd Fonts 字体                         |

------

### 社区常用 bucket

| 名称            | 地址                                                         | 特点                                          |
| --------------- | ------------------------------------------------------------ | --------------------------------------------- |
| **scoop-cn**    | `scoop bucket add scoop-cn https://github.com/duzyn/scoop-cn` | 国内镜像，适合网络不稳定时                    |
| **java**        | `scoop bucket add java`                                      | 各版本 Java JDK/JRE                           |
| **jetbrains**   | `scoop bucket add jetbrains`                                 | JetBrains 系列 IDE                            |
| **nonportable** | `scoop bucket add nonportable`                               | 安装需要修改系统的非便携软件（注册表/安装包） |
| **games**       | `scoop bucket add games`                                     | 常见游戏工具、模拟器等                        |
| **bucket**      | `scoop bucket add bucket https://github.com/Ash258/Scoop-Ash258` | 收录大量第三方应用（活跃度高）                |
| **scoopet**     | `scoop bucket add scoopet https://github.com/ivaquero/scoopet` | 国内开发者维护，偏向学术/科研软件             |
| **extras-cn**   | `scoop bucket add extras-cn https://github.com/huanghongxun/extras-cn` | `extras` 的国内镜像                           |
| **dorado**      | `scoop bucket add dorado https://github.com/chawyehsu/dorado` | 中文社区维护，包含不少国内常用软件            |

------

### bucket聚合🎈

https://gitee.com/wlzwme/scoop-proxy-cn

这是聚合了场景scoop bucket的大型bucket,在gitee，github上都有仓库添加方式

```powershell
scoop bucket add spc https://gitee.com/wlzwme/scoop-proxy-cn.git
```

优先使用gitee,比较快,但是部分链接有错误可能安装不了(可以换一个名称相近实际上是同一个软件到名字来安装,当然也可以酌情添加其他小的bucket,提高可用性)

### 按需求推荐组合

- **开发环境**：`main` + `extras` + `versions` + `java` + `php` + `jetbrains`
- **日常办公**：`main` + `extras` + `nerd-fonts`
- **科学/学术工具**：`main` + `extras` + `scoopet` + `dorado`
- **国内加速**：在以上基础上加 `scoop-cn` / `extras-cn`

------

### 查看已添加的 bucket

```powershell
scoop bucket list
```

### 添加 bucket 示例

```powershell
scoop bucket add extras
scoop bucket add dorado https://github.com/chawyehsu/dorado
```

------

## 便于批量添加的列表形式

并且用可以直接复制粘贴运行的命令形式来展示，这样你直接在 PowerShell 里就能一键添加需要的 bucket

### bucket聚合

添加这一个基本就够了,下面到可以酌情添加

```bash
scoop bucket add spc https://gitee.com/wlzwme/scoop-proxy-cn.git
```

------

### 官方 bucket

```powershell
scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nirsoft
scoop bucket add php
scoop bucket add nerd-fonts
```

------

### 开发相关 bucket

```powershell
scoop bucket add java
scoop bucket add jetbrains
scoop bucket add games
```

------

### 社区维护 bucket

```powershell
scoop bucket add dorado https://github.com/chawyehsu/dorado
scoop bucket add scoopet https://github.com/ivaquero/scoopet
scoop bucket add Ash258 https://github.com/Ash258/Scoop-Ash258
scoop bucket add nonportable
```

------

### 国内优化 / 镜像 bucket

```powershell
scoop bucket add scoop-cn https://github.com/duzyn/scoop-cn
scoop bucket add extras-cn https://github.com/huanghongxun/extras-cn
```

------

### 其他实用 bucket（选用）

```powershell
scoop bucket add scoop-games https://github.com/Calinou/scoop-games
scoop bucket add scoop-completion https://github.com/Moeologist/scoop-completion
scoop bucket add scoop-emulators https://github.com/hermanjustnu/scoop-emulators
scoop bucket add scoop-nonportable https://github.com/TheRandomLabs/scoop-nonportable
scoop bucket add scoop-bucket https://github.com/lukesampson/scoop-bucket
```

------

### 建议使用方式

1. 想最小化安装 → 只加 `main extras versions`
2. 想开发环境 → 再加 `java php jetbrains dorado scoopet`
3. 想国内加速 → 加 `scoop-cn extras-cn`
4. 想尝试更多软件 → 加 `Ash258 nonportable games nerd-fonts`

------

