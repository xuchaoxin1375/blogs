[toc]



在 Bash 脚本中，可以通过 `read` 命令获取用户输入，并结合条件判断来实现默认值为 `y` 的逻辑。以下是一个优雅的实现方式：

### 实现代码
```bash
#!/bin/bash

# 提示用户输入 y/n，默认为 y
read -p "Do you want to continue? (y/n) [default: y]: " choice

# 将用户输入转换为小写，并检查是否为空或等于 y/Y
if [[ -z "$choice" || "$choice" =~ ^[Yy]$ ]]; then
    echo "User chose to continue."
else
    echo "User chose not to continue."
fi
```

---

### 代码解析

1. **`read -p` 命令**：
   - `-p` 参数允许在提示信息后直接等待用户输入。
   - 提示信息明确告知用户默认选项是 `y`。

2. **`-z` 判断空字符串**：
   - 如果用户直接按回车键，`$choice` 变量将为空。
   - 使用 `-z` 检查变量是否为空，若为空则视为用户选择了默认值 `y`。

3. **正则匹配 `[Yy]`**：
   - 使用 `=~` 运算符进行正则表达式匹配，允许可接受大小写的 `y` 或 `Y`。

4. **逻辑判断**：
   - 如果 `$choice` 为空（即用户直接回车）或者等于 `y`/`Y`，则执行“继续”的逻辑。
   - 否则，执行“不继续”的逻辑。

---

### 示例运行

#### 用户直接按回车：
```bash
Do you want to continue? (y/n) [default: y]: 
User chose to continue.
```

#### 用户输入 `y` 或 `Y`：
```bash
Do you want to continue? (y/n) [default: y]: y
User chose to continue.

Do you want to continue? (y/n) [default: y]: Y
User chose to continue.
```

#### 用户输入 `n` 或其他字符：
```bash
Do you want to continue? (y/n) [default: y]: n
User chose not to continue.

Do you want to continue? (y/n) [default: y]: abc
User chose not to continue.
```

---

### 总结
上述代码通过简单的条件判断和正则匹配，实现了用户输入的灵活性，同时确保了默认值的行为符合预期。这种实现方式简洁且易于维护，适用于大多数需要类似交互的场景。