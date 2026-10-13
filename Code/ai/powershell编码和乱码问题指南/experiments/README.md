[toc]

## 用途

本目录用可重复实验演示**编码相关特殊变量**的作用：`$OutputEncoding`、`[Console]::OutputEncoding`、`[Console]::InputEncoding`、`[System.Text.Encoding]::Default`、`$PSDefaultParameterValues`，以及`Get-Content`、`Set-Content`、`Out-File`、`Select-String`的`-Encoding`默认差异。判读只看计数、布尔值和十六进制，不看字形，避免采集链路本身干扰结论。

## 文件一览

- `Show-EncodingDefaults.ps1`：打印宿主版本、各变量默认值、样例的`UTF-8`与系统默认字节对照。
- `Test-ReadLayer.ps1`：**文件字节到位到字符串String**层，演示默认读取、`-Encoding UTF8`、`BOM`嗅探、`Select-String`计数差异。
- `Test-OutputLayer.ps1`：**字符串String到位到位到字节**层，演示同一字符串按`UTF-8`与`GBK`编码的字节差异，以及`UTF-8`下游解不开`GBK`字节。
- `Test-NativePipe.ps1`：演示`$OutputEncoding`对管道给原生程序（`python`）的影响，无`python`时自动跳过 live 部分。
- `Test-RedirectDefaults.ps1`：演示`>`、`Out-File`、`Set-Content`、显式`UTF-8`、`.NET`无`BOM`五种写法的落盘头字节分类。
- `Run-All.ps1`：按顺序串跑以上五个脚本并汇总退出码。

## 运行方法

```powershell
# PowerShell 7 优先
pwsh -NoProfile -File ./Run-All.ps1

# Windows PowerShell 5.1 对照
powershell -NoProfile -ExecutionPolicy Bypass -File ./Run-All.ps1

# 单个实验，产物落在系统临时目录
pwsh -NoProfile -File ./Test-ReadLayer.ps1
```

说明：有意用`-NoProfile`，以复现`Agent`采集链路（`profile`在该链路下不加载）；脚本内不依赖任何全局配置。

## 预期结果对照

| 实验 | 5.1现象 | 7现象 | 结论 |
|---|---|---|---|
| 默认读无`BOM UTF-8` | `False`，乱码 | `True` | 默认解码器版本断裂，读必须显式`-Encoding` |
| `-Encoding UTF8`读 | `True` | `True` | 正确解码器两边都对 |
| 带`BOM`默认读 | `True` | `True` | `BOM`可被嗅探 |
| `GBK`字节按`UTF-8`严格解码 | 抛异常 | 抛异常 | 下游按`UTF-8`收`GBK`字节必烂 |
| `>`/`Out-File`默认 | `UTF-16LE-BOM` | `UTF-8-NoBOM-or-ASCII` | 重定向默认版本断裂，写必须显式 |
| `Set-Content`默认 | `ANSI-GBK-or-other` | `UTF-8-NoBOM-or-ASCII` | 同上 |

## 源码约束

- 全部`.ps1`源码为纯`ASCII`，中文样例一律用`[char]`码点拼接（如`0x4F60`），因此`5.1`无需`BOM`即可解析，这本身就是文档中**脚本源文件编码**一节的实践。
- 实验产物写系统临时目录`ps-enc-demo`，不污染仓库；必需操作均带`-ErrorAction Stop`，原生程序调用后紧跟`$LASTEXITCODE`检查。
