[toc]



## Bash 参数扩展操作符 `${parameter@operator}` 总结

| 操作符       | 名称       | 功能描述                         | Bash版本 |
| ------------ | ---------- | -------------------------------- | -------- |
| `${param@Q}` | Quote      | 输出可作为输入重用的引用格式     | 4.4+     |
| `${param@E}` | Escape     | 展开转义序列（如`\n`, `\t`）     | 4.4+     |
| `${param@P}` | Prompt     | 按提示符规则展开（如`\u`, `\h`） | 4.4+     |
| `${param@A}` | Assign     | 输出变量的声明/赋值语句          | 4.4+     |
| `${param@a}` | Attributes | 输出变量的属性标志               | 4.4+     |
| `${param@U}` | Uppercase  | 转换为全大写                     | 5.1+     |
| `${param@u}` | Capitalize | 首字母大写                       | 5.1+     |
| `${param@L}` | Lowercase  | 转换为全小写                     | 5.1+     |
| `${param@K}` | Keys       | 关联数组键值对展开               | 5.1+     |

---

## 详细案例演示

### 1. `@Q` - 引用格式

```bash
#!/bin/bash
# 用于安全地输出可重用的字符串

str="Hello World"
special="It's a \"test\" with \$var"

echo "${str@Q}"        # 输出: 'Hello World'
echo "${special@Q}"    # 输出: 'It'\''s a "test" with $var' (分为3部分子串的拼接)

# 实际用途：生成可执行的命令(将构造的命令打印出来)
cmd="cmd is: echo"
args="-e hello\nworld"
echo "${cmd} ${args@Q}"  # 安全传递参数

cmd="cmd is: echo"
args="-e hello\nworld"
echo "${cmd} ${args}"  # 安全传递参数
```

---

关于`"${special@Q}"`给出的`'It'\''s a "test" with $var'`的解释

原始变量 `special` 的内容是：`It's a "test" with $var`

Bash 为了确保这个字符串在任何环境下都能原样输出，采用了**单引号包裹**的策略，但**单引号内部不能直接嵌套单引号**，所以它进行了如下处理：

1. **`'It'`**：起始部分。用单引号包裹 `It`。
2. **`\'`**：**关键点**。**退出之前的单引号**，用反斜杠转义一个真实的单引号。
3. **`'s a "test" with $var'`**：剩余部分。**再次开启单引号，包裹剩下的所有字符**。

### 2. `@E` - 转义序列展开

```bash
#!/bin/bash
# 展开反斜杠转义序列

text='Line1\nLine2\tTabbed'

echo "$text"       # 输出: Line1\nLine2\tTabbed（原样）
echo "${text@E}"   # 输出: 
                   # Line1
                   # Line2	Tabbed

# 处理颜色代码
color='\e[31mRed Text\e[0m'
echo -e "${color@E}"  # 显示红色文字
```

---

### 3. `@P` - 提示符展开

```bash
#!/bin/bash
# 按PS1提示符规则展开

prompt='\u@\h:\w\$ '

echo "${prompt@P}"   # 输出类似: user@hostname:/home/user$

# 自定义状态提示
status='[\t] \u >'
echo "${status@P}"   # 输出: [14:30:25] username >
```

**常用提示符转义：**

| 序列 | 含义      |
| ---- | --------- |
| `\u` | 用户名    |
| `\h` | 主机名    |
| `\w` | 当前目录  |
| `\t` | 时间(24h) |
| `\d` | 日期      |

---

### 4. `@A` - 声明语句

```bash
#!/bin/bash
# 输出变量的完整声明

declare -i num=42
declare -a arr=(a b c)
declare -A map=([key1]=val1 [key2]=val2)
declare -r const="readonly"

echo "${num@A}"    # 输出: declare -i num='42'
echo "${arr@A}"    # 输出: declare -a arr=([0]="a" [1]="b" [2]="c")
echo "${map@A}"    # 输出: declare -A map=([key1]="val1" [key2]="val2")
echo "${const@A}"  # 输出: declare -r const='readonly'

# 用途：序列化变量状态
save_state() {
    echo "${arr@A}" > state.sh
}
```

---

### 5. `@a` - 属性标志

```bash
#!/bin/bash
# 获取变量属性

declare -i integer_var=10
declare -r readonly_var="constant"
declare -a array_var=(1 2 3)
declare -A assoc_var=([k]=v)
declare -x export_var="exported"
declare -l lower_var="TEXT"

echo "${integer_var@a}"   # 输出: i
echo "${readonly_var@a}"  # 输出: r
echo "${array_var@a}"     # 输出: a
echo "${assoc_var@a}"     # 输出: A
echo "${export_var@a}"    # 输出: x
echo "${lower_var@a}"     # 输出: l

# 组合属性
declare -ir combo=100
echo "${combo@a}"         # 输出: ir
```

**属性标志含义：**

| 标志 | 含义        |
| ---- | ----------- |
| `a`  | 索引数组    |
| `A`  | 关联数组    |
| `i`  | 整数        |
| `r`  | 只读        |
| `x`  | 导出        |
| `l`  | 小写转换    |
| `u`  | 大写转换    |
| `n`  | nameref引用 |

---

### 6. `@U` / `@u` / `@L` - 大小写转换 (Bash 5.1+)

```bash
#!/bin/bash
# 大小写转换操作

str="hello WORLD"

echo "${str@U}"   # 输出: HELLO WORLD（全大写）
echo "${str@u}"   # 输出: Hello WORLD（首字母大写）
echo "${str@L}"   # 输出: hello world（全小写）

# 数组操作
arr=("hello" "WORLD" "MixEd")
echo "${arr[@]@U}"  # 输出: HELLO WORLD MIXED
echo "${arr[@]@L}"  # 输出: hello world mixed
```

---

### 7. `@K` - 关联数组键值对 (Bash 5.1+)

```bash
#!/bin/bash
# 展开关联数组的键值对

declare -A user=(
    [name]="John"
    [age]="30"
    [city]="NYC"
)

echo "${user[@]@K}"
# 输出: name "John" age "30" city "NYC"

# 用于调试
debug_assoc() {
    local -n ref=$1
    echo "Contents: ${ref[@]@K}"
}
debug_assoc user
```

---

## 综合实战案例

```bash
#!/bin/bash
# 配置管理脚本示例

# 定义配置
declare -A CONFIG=(
    [host]="localhost"
    [port]="8080"
    [debug]="true"
)
declare -r APP_NAME="MyApp"
declare -i MAX_CONN=100

# 导出配置（保留类型和属性）
export_config() {
    echo "# Auto-generated config"
    echo "${CONFIG@A}"
    echo "${APP_NAME@A}"
    echo "${MAX_CONN@A}"
}

# 显示配置信息
show_config() {
    echo "=== Configuration ==="
    echo "App: ${APP_NAME@Q}"
    echo "Max Connections: $MAX_CONN (type: ${MAX_CONN@a})"
    echo "Settings: ${CONFIG[@]@K}"
}

# 日志函数（带颜色）
log_msg='\e[32m[INFO]\e[0m Config loaded'
echo "${log_msg@E}"

show_config
export_config > config.backup
```

---

## 快速参考卡片

```bash
┌─────────────────────────────────────────────┐
│  ${var@Q}  → 引用格式    'value'            │
│  ${var@E}  → 展开转义    \n → 换行          │
│  ${var@P}  → 提示符展开  \u → 用户名        │
│  ${var@A}  → 声明语句    declare -x var=... │
│  ${var@a}  → 属性标志    irxaA...           │
│  ${var@U}  → 全大写      HELLO              │
│  ${var@u}  → 首字母大写  Hello              │
│  ${var@L}  → 全小写      hello              │
│  ${var@K}  → 键值展开    key "val"...       │
└─────────────────────────────────────────────┘
```

