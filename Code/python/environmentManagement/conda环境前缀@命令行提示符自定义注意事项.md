[toc]

## Shell 提示符修改机制

许多程序(例如`conda`)会在激活环境后修改shell提示符(比如插入前缀(base)),这是如何实现的?

> 以conda为例:
>
> 在windows上,cmd和powershell都有此效果 (conda init)
>
> 在linux上,shell的提示符也有此效果(shell init)

用户自定义shell提示符,则应该注意什么避免覆盖掉提示符的环境提示?

## 基本原理

程序修改 shell 提示符主要通过 **修改/包装 prompt 函数或环境变量** 实现。

---

## 不同 Shell 的实现方式

### 1. PowerShell 的实现

```powershell
# PowerShell 使用 prompt 函数来生成提示符
# Conda 激活时会这样修改：

# 原始的 prompt 函数
function prompt { "PS $pwd> " }

# Conda 的做法：保存原函数，创建新的包装函数
$_Old_Prompt = $function:prompt
function prompt {
    # 添加环境前缀
    $env_prefix = if ($env:CONDA_DEFAULT_ENV) { "($env:CONDA_DEFAULT_ENV) " } else { "" }
    # 调用原始 prompt 并在前面加上前缀
    $env_prefix + (& $_Old_Prompt)
}
```

### 2. CMD 的实现

```batch
:: CMD 使用 PROMPT 环境变量
:: 原始提示符
PROMPT $P$G

:: Conda 激活后修改为
PROMPT (base) $P$G
```

### 3. Bash/Zsh 的实现

```bash
# 通过修改 PS1 环境变量
# 原始
PS1="\u@\h:\w$ "

# 激活后
PS1="(base) \u@\h:\w$ "
```

---

## Conda 具体实现流程

```
┌─────────────────────────────────────────────────────────┐
│                  conda activate base                     │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│  1. 设置环境变量 CONDA_DEFAULT_ENV = "base"              │
│  2. 保存原始 prompt 函数到 $_Old_Prompt                  │
│  3. 定义新的 prompt 函数（添加前缀 + 调用原函数）          │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                  conda deactivate                        │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│  1. 恢复原始 prompt 函数                                 │
│  2. 清除 CONDA_DEFAULT_ENV                               │
└─────────────────────────────────────────────────────────┘
```

---

## 自定义 PowerShell 提示符的最佳实践

### ❌ 错误做法：直接覆盖

```powershell
# 这会完全覆盖 conda 等工具的修改
function prompt {
    "My Custom Prompt> "
}
```

### ✅ 正确做法 1：检测并保留环境前缀

```powershell
function prompt {
    $prefix = ""
    
    # 检测 Conda 环境
    if ($env:CONDA_DEFAULT_ENV) {
        $prefix += "($env:CONDA_DEFAULT_ENV) "
    }
    
    # 检测 Python venv
    if ($env:VIRTUAL_ENV) {
        $venv_name = Split-Path $env:VIRTUAL_ENV -Leaf
        $prefix += "($venv_name) "
    }
    
    # 检测 Node.js nvm
    if ($env:NVM_SYMLINK) {
        # 可选：添加 node 版本
    }
    
    # 你的自定义提示符
    $custom = "PS $($pwd.Path)> "
    
    return $prefix + $custom
}
```

### ✅ 正确做法 2：链式调用（推荐）

```powershell
# 在 $PROFILE 中这样写：

# 保存可能已存在的 prompt（如 conda 已经修改过的）
if ($function:prompt) {
    $script:OriginalPrompt = $function:prompt
}

function prompt {
    $result = ""
    
    # 如果有原始 prompt，先调用它（获取环境前缀）
    if ($script:OriginalPrompt) {
        $result = & $script:OriginalPrompt
    }
    
    # 或者完全自定义但保留环境信息
    # ... 你的自定义逻辑
    
    return $result
}
```

### ✅ 正确做法 3：使用模块化方法

```powershell
# 创建一个不破坏现有功能的增强 prompt

$script:PromptHooks = @()

function Add-PromptHook {
    param([scriptblock]$Hook)
    $script:PromptHooks += $Hook
}

# 保存原始 prompt
$script:BasePrompt = $function:prompt

function prompt {
    $result = ""
    
    # 执行所有钩子
    foreach ($hook in $script:PromptHooks) {
        $result += & $hook
    }
    
    # 调用基础 prompt
    if ($script:BasePrompt) {
        $result += & $script:BasePrompt
    } else {
        $result += "PS> "
    }
    
    return $result
}

# 使用示例：添加 git 分支显示
Add-PromptHook {
    $branch = git branch --show-current 2>$null
    if ($branch) { "[$branch] " } else { "" }
}
```

---

## 完整的安全自定义示例

```powershell
# 放在 $PROFILE 文件中

function prompt {
    # ========== 环境前缀部分（保留工具修改）==========
    $prefix = ""
    
    # Conda
    if ($env:CONDA_DEFAULT_ENV) {
        $prefix += "`e[33m($env:CONDA_DEFAULT_ENV)`e[0m "  # 黄色
    }
    
    # Python venv
    if ($env:VIRTUAL_ENV) {
        $venv = Split-Path $env:VIRTUAL_ENV -Leaf
        $prefix += "`e[32m($venv)`e[0m "  # 绿色
    }
    
    # ========== 自定义部分 ==========
    $path = $pwd.Path.Replace($HOME, "~")
    
    # Git 分支（可选）
    $git_branch = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git branch --show-current 2>$null
        if ($branch) {
            $git_branch = "`e[36m[$branch]`e[0m "  # 青色
        }
    }
    
    # 组合最终提示符
    return "$prefix`e[34m$path`e[0m $git_branch`n❯ "
}
```

---

## 关键要点总结

| 注意事项             | 说明                                            |
| -------------------- | ----------------------------------------------- |
| **检测环境变量**     | `$env:CONDA_DEFAULT_ENV`, `$env:VIRTUAL_ENV` 等 |
| **不要硬编码**       | 动态检测而非假设环境存在                        |
| **Profile 加载顺序** | Conda 可能在你的 profile 之后初始化             |
| **链式保存**         | 如需完全自定义，先保存 `$function:prompt`       |
| **使用 conda hook**  | 考虑在 `conda init` 之后定义 prompt             |