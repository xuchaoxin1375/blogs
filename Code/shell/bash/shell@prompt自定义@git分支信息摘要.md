[toc]

## shell prompt自定义-git信息

```bash
# 直接找 .git/HEAD，找不到就用 git rev-parse
head_file="$(git rev-parse --git-dir 2> /dev/null)/HEAD"
if [[ -f "$head_file" ]]; then
    local head_content
    IFS= read -r head_content < "$head_file"
    local branch
    if [[ "$head_content" == ref:\ * ]]; then
        branch="${head_content#ref: refs/heads/}"
    else
        branch="${head_content:0:7}"
    fi
    git_info=" ${yellow}on${reset} ${red}git:${branch}${reset}"
fi
```



## 逐行分析

```bash
head_file="$(git rev-parse --git-dir 2> /dev/null)/HEAD"
```
- `git rev-parse --git-dir` → 返回 `.git` 目录的**绝对路径**
- `2> /dev/null` → 丢弃错误输出（不在 git 仓库时静默失败）
- 拼接 `/HEAD` → 得到完整的 HEAD 文件路径，如 `/project/.git/HEAD`

---

```bash
if [[ -f "$head_file" ]]; then
```
- 检查 HEAD 文件是否**存在且是普通文件**
- 不存在说明不在 git 仓库中

---

```bash
IFS= read -r head_content < "$head_file"
```
- `IFS=` → 清空分隔符，防止首尾空白被裁剪
- `-r` → 禁止反斜杠转义（raw 模式）
- 读取 HEAD 文件**第一行**内容

---

```bash
if [[ "$head_content" == ref:\ * ]]; then
    branch="${head_content#ref: refs/heads/}"
else
    branch="${head_content:0:7}"
fi
```

HEAD 文件有两种状态：

| 状态          | HEAD 内容              | 含义                |
| ------------- | ---------------------- | ------------------- |
| 正常分支      | `ref: refs/heads/main` | 指向某个分支        |
| Detached HEAD | `a1b2c3d4e5f6...`      | 直接指向某个 commit |

- **分支模式**：`${head_content#ref: refs/heads/}` → 前缀剥离，得到 `main`
- **游离模式**：`${head_content:0:7}` → 截取前 7 位 commit hash，如 `a1b2c3d`

---

```bash
git_info=" ${yellow}on${reset} ${red}git:${branch}${reset}"
```
- 拼接带 ANSI 颜色的提示字符串
- 最终显示效果：` on git:main`（on 黄色，git:main 红色）

---

## 为什么不直接用 `git branch` 命令？

```bash
# 慢：需要启动 git 进程，遍历引用
git branch --show-current

# 快：直接读文件，无子进程开销
cat .git/HEAD
```

> 提示符每次刷新都会执行，**性能敏感**，读文件比启动进程快 10-50 倍

---

## PowerShell 版本

```powershell
function Get-GitInfo {
    # ── 1. 获取 .git 目录路径 ──────────────────────────────────────
    $gitDir = git rev-parse --git-dir 2>$null
    if (-not $gitDir) { return "" }          # 不在 git 仓库，直接返回

    # ── 2. 构建 HEAD 文件路径 ──────────────────────────────────────
    $headFile = Join-Path $gitDir "HEAD"
    if (-not (Test-Path $headFile -PathType Leaf)) { return "" }

    # ── 3. 读取 HEAD 内容 ──────────────────────────────────────────
    $headContent = Get-Content -LiteralPath $headFile `
                               -TotalCount 1 `    # 只读第一行，等价于 read
                               -Encoding utf8

    # ── 4. 判断分支 or Detached HEAD ──────────────────────────────
    $branch = if ($headContent -match '^ref: refs/heads/(.+)$') {
        $Matches[1]                              # 捕获组1 = 分支名
    } else {
        $headContent.Substring(0, [Math]::Min(7, $headContent.Length))
    }                                            # 游离状态取前7位 hash

    # ── 5. 构建带颜色的输出 ────────────────────────────────────────
    $yellow = "`e[33m"    # ANSI 黄色  (PowerShell 7+ 支持 `e 转义)
    $red    = "`e[31m"    # ANSI 红色
    $reset  = "`e[0m"     # 重置颜色

    return " ${yellow}on${reset} ${red}git:${branch}${reset}"
}
```

---

## 集成到 PowerShell 提示符

```powershell
function prompt {
    $gitInfo = Get-GitInfo

    # 当前路径（取最后一段，类似 bash 的 \W）
    $path = Split-Path -Leaf (Get-Location)

    # 构建提示符
    $cyan  = "`e[36m"
    $reset = "`e[0m"

    "${cyan}${path}${reset}${gitInfo} $ "
}
```

---

## 兼容性处理（PowerShell 5.x）

```powershell
# PowerShell 5.x 不支持 `e，改用 [char]27
function Get-AnsiColor {
    param([int]$Code)
    return "$([char]27)[${Code}m"
}

$yellow = Get-AnsiColor 33
$red    = Get-AnsiColor 31
$reset  = Get-AnsiColor 0
```

---

## 对比总结

| 特性       | Bash            | PowerShell                  |
| ---------- | --------------- | --------------------------- |
| 读文件     | `IFS= read -r`  | `Get-Content -TotalCount 1` |
| 前缀剥离   | `${var#prefix}` | `-match` + `$Matches[1]`    |
| 字符串截取 | `${var:0:7}`    | `.Substring(0, 7)`          |
| ANSI 转义  | `\e[33m`        | `` `e[33m `` (PS7+)         |
| 错误静默   | `2>/dev/null`   | `2>$null`                   |
| 路径拼接   | `"$dir/HEAD"`   | `Join-Path $dir "HEAD"`     |