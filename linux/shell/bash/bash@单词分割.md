[toc]

## bash 单词分割Word Splitting

Bash 单词分割（Word Splitting）详解

本文使用`printf`命令来清晰地呈现分割是否发生下的区别;

## 基本概念

哪些参数(变量)扩展(展开)会触发单词分割

###  未加双引号的参数扩展会被分割

```bash
var="hello   world   foo"

# 未加引号 → 触发单词分割
printf '[%s]\n' $var
# 输出：
# [hello]
# [world]
# [foo]
# 多个空格被视为一个分隔符，分割成3个字段

# 加了双引号 → 不触发单词分割
printf '[%s]\n' "$var"
# 输出：
# [hello   world   foo]
# 保持原样，作为一个整体
```

###  未加双引号的命令替换会被分割

`$(echo "hello   world")`->`"$(echo "hello   world")"`

为整个命令替换表达式加双引号不分割;

> `"$(echo "hello   world")"`这个式子看起来像是双引号嵌套.**在 `$(...)` 内部会开启一个全新的引用上下文**，所以内外的双引号是**独立的**，互不干扰。
>
> `$(...)` 内部是独立的解析上下文，**里面的引号从零开始计算，和外面的引号完全无关**，所以不存在"双引号嵌套"的问题。
>
> 反引号语法才有嵌套问题,这就是为什么 `$(...)` 比老式反引号 ``...`` 更好：
>
> 类似的,`prefix="${P%"$suffix"}"`这种参数扩展的写法看起来也像是嵌套引号,但也是合法的语句;`${}`内部也是独立的上下文

```bash
# 命令替换的结果也会被分割
printf '[%s]\n' $(echo "hello   world")
# 输出：
# [hello]
# [world]

# 为整个命令替换表达式加双引号则不分割
printf '[%s]\n' "$(echo "hello   world")"
# 输出：
# [hello   world]
```

###  未加双引号的算术扩展会被分割

```bash
# 算术扩展通常结果是数字，不太容易看出分割效果
# 但原理一样：未加引号就会经历单词分割过程
printf '[%s]\n' $((1 + 2))
# 输出：[3]
```



## IFS 的作用

###  默认 IFS（空格、制表符、换行符）

```bash
# 默认 IFS=$' \t\n'
var="hello   world		foo
bar"

printf '[%s]\n' $var
# 输出：
# [hello]
# [world]
# [foo]
# [bar]
# 连续的空格/制表符/换行符都被当作一个分隔符
```

###  自定义 IFS 为非空白字符（如冒号）

```bash
IFS=":"
var="one:two:three"

printf '[%s]\n' $var
# 输出：
# [one]
# [two]
# [three]

unset IFS  # 恢复默认
```

###  用 IFS 解析 PATH

```bash
IFS=":"
printf '[%s]\n' $PATH
# 输出类似：
# [/usr/local/bin]
# [/usr/bin]
# [/bin]
# [/usr/sbin]
# [/sbin]

unset IFS
```

###  用 IFS 读取 CSV 风格数据

```bash
line="Alice,30,Engineer"
IFS=","
read -r name age job <<< "$line"
echo "Name: $name, Age: $age, Job: $job"
# 输出：Name: Alice, Age: 30, Job: Engineer

unset IFS
```

---

`unset IFS` 到底发生了什么？

当你执行 `unset IFS` 时，Bash 会将 `IFS` 恢复为它的**默认行为**。

在 Bash 中，`IFS` 的默认值是：**空格（Space）、制表符（Tab）和换行符（Newline）**。

虽然 `unset IFS` 能解决大部分问题，更严谨的做法是在修改前**备份**，完成后**还原**。这样可以确保即使环境中有特殊的 `IFS` 设置（虽然罕见），你也不会破坏它。

但如果可以,优先的做法是使用 `IFS="," read ...` 这种临时更改IFS(仅对当前命令有效)赋值方式。

```bash
old_ifs="$IFS"         # 1. 备份当前IFS
IFS=","
read -r name age job <<< "$line"
IFS="$old_ifs"         # 2. 还原IFS
```

或者，利用 **子 shell** 或 **命令前置赋值**（如果适用）来限制作用域，避免污染全局环境：

```bash
# 仅对 read 命令临时设置 IFS，不需要手动 unset 或还原
IFS="," read -r name age job <<< "$line"

# 验证：这里的 IFS 依然是系统默认值
echo "Current IFS is safe"
```



## IFS 空白字符 vs 非空白字符的区别

###  IFS 仅含空白字符：连续分隔符合并，不产生空字段

```bash
IFS=" "
var="one   two   three"

printf '[%s]\n' $var
# 输出：
# [one]
# [two]
# [three]
# 连续空格被合并为一个分隔符，没有空字段
```

###  IFS 含非空白字符：相邻分隔符产生空字段

```bash
IFS=":"
var="one::two:::three"

printf '[%s]\n' $var
# 输出：
# [one]
# []          ← :: 之间的空字段
# [two]
# []          ← ::: 产生两个空字段
# []
# [three]
# 每两个相邻的冒号之间都会产生一个空字段

unset IFS
```

###  非空白分隔符 + 相邻空白：空白被吸收

```bash
IFS=": "
var="one : two :  : three"

printf '[%s]\n' $var
# 输出：
# [one]
# [two]
# []          ← 两个冒号之间（空白被冒号吸收）
# [three]
# 空格作为IFS空白字符，会被相邻的冒号"吸收"

unset IFS
```

这是文档中说的 **"非IFS空白字符，连同相邻的IFS空白字符，一起构成一个分隔符"**：

```bash
IFS=","
var="  hello , world , foo  "

printf '[%s]\n' $var
# 输出：
# [hello]       ← 开头的空格不会被去除（因为空格不在IFS中）
# [ world ]     ← 逗号两边的空格保留在字段中
# [ foo  ]

# 对比：
IFS=", "        # 逗号 + 空格 都在IFS中
var="  hello , world , foo  "

printf '[%s]\n' $var
# 输出：
# [hello]       ← 开头的IFS空白被去除
# [world]       ← 逗号+空格一起作为一个分隔符
# [foo]         ← 末尾的IFS空白被去除

unset IFS
```

---

## 首尾 IFS 空白字符的移除

###  扩展结果首尾的 IFS 空白会被去除

```bash
var="   hello world   "

printf '[%s]\n' $var
# 输出：
# [hello]
# [world]
# 首尾的空格被移除，中间的空格作为分隔符

# 对比加引号：
printf '[%s]\n' "$var"
# 输出：
# [   hello world   ]
# 首尾空格保留
```

###  非空白 IFS 字符在首尾不会被去除（会产生空字段）

```bash
IFS=":"
var=":hello:world:"

printf '[%s]\n' $var
# 输出：
# []            ← 开头冒号前的空字段
# [hello]
# [world]
# []            ← 末尾冒号后的空字段

unset IFS
```

---

## IFS 为空 vs IFS 未设置

###  IFS 为空字符串：不进行单词分割

```bash
IFS=""
var="hello world foo"

printf '[%s]\n' $var
# 输出：
# [hello world foo]
# IFS为空，不进行任何分割，整体作为一个字段

unset IFS  # 恢复默认
```

###  IFS 未设置：等同于默认值

```bash
unset IFS
var="hello   world   foo"

printf '[%s]\n' $var
# 输出：
# [hello]
# [world]
# [foo]
# 行为与 IFS=$' \t\n' 完全一致
```

---

## 显式空参数 vs 隐式空参数

###  显式空参数（"" 或 ''）被保留

```bash
printf '[%s]\n' "" '' hello
# 输出：
# []          ← "" 保留为空字符串
# []          ← '' 保留为空字符串
# [hello]
```

```bash
# 实际用途：创建空文件名参数、传递空字符串给命令
somearray=("" "hello" "" "world")
printf '[%s]\n' "${somearray[@]}"
# 输出：
# []
# [hello]
# []
# [world]
```

###  隐式空参数（未设值的变量扩展）被移除

```bash
unset empty_var

printf '[%s]\n' $empty_var hello $empty_var world
# 输出：
# [hello]
# [world]
# $empty_var 扩展为空 → 隐式空参数 → 被移除，就好像它不存在

# 对比：显式空参数不会被移除
printf '[%s]\n' "" hello "" world
# 输出：
# []
# [hello]
# []
# [world]
```

###  双引号内扩展空变量 → 保留为空字符串

```bash
unset empty_var

printf '[%s]\n' "$empty_var" hello
# 输出：
# []          ← 在双引号内，即使变量为空，也保留为一个空字段
# [hello]

# 这与不加引号的行为完全不同：
printf '[%s]\n' $empty_var hello
# 输出：
# [hello]
# 不加引号 → 隐式空参数 → 被移除
```

###  经典陷阱：用这个特性检测变量是否为空

```bash
unset myvar

# 危险写法（如果 myvar 为空，$myvar 消失，变成 [ = "hello" ]，语法错误）
# [ $myvar = "hello" ]  # 报错！

# 安全写法（加引号，空变量保留为空字符串）
[ "$myvar" = "hello" ]  # 正确：等价于 [ "" = "hello" ]
echo $?  # 1 (false)
```

---

## 引号空参数作为单词的一部分

###  `-d''` 中的空引号被移除

```bash
# -d'' 在 shell 解析后：
# -d 是字面量部分，'' 是显式空参数
# 合并后整个词的扩展结果是非空的 "-d"
# 所以空参数部分被移除，最终得到 -d

# 实际演示：
printf '[%s]\n' -d''
# 输出：
# [-d]

# 等价于：
printf '[%s]\n' -d
# 输出：
# [-d]
```

```bash
# 常见用法：read 命令读取整行（NUL分隔符）
# 以下两种写法等价：
IFS= read -r -d'' line    # -d'' → -d → 使用空字符(NUL)作为分隔符
IFS= read -r -d '' line   # -d '' → -d 和 '' 是两个参数
# 注意：这两个其实不太一样！
# -d'' 合并成一个词 "-d"，read 把下一个参数当 delimiter
# -d '' 是 -d 选项加上空字符串参数
```

###  更多组合示例

```bash
prefix=""
printf '[%s]\n' ${prefix}hello
# 输出：
# [hello]
# $prefix 扩展为空 → 与 hello 拼接 → "hello"

prefix="pre_"
printf '[%s]\n' ${prefix}hello
# 输出：
# [pre_hello]
```

---

## 综合实战示例

###  为什么要给变量加双引号（经典 bug）

```bash
filename="my document.txt"

# 错误：不加引号 → 单词分割 → rm 收到两个参数
# rm $filename
# 等价于 rm my document.txt → 删除 "my" 和 "document.txt" 两个文件！

# 正确：加引号
# rm "$filename"
# 等价于 rm "my document.txt" → 删除一个文件
```

###  遍历带空格的文件列表

```bash
# 错误做法：
files=$(ls)
for f in $files; do
    echo "File: $f"
done
# 如果文件名含空格，会被错误分割

# 正确做法：
for f in *; do
    echo "File: $f"
done
```

###  IFS 配合 read 解析结构化数据

```bash
# 解析 /etc/passwd 的一行
line="root:x:0:0:root:/root:/bin/bash"
IFS=':' read -r user pass uid gid desc home shell <<< "$line"
echo "User: $user, UID: $uid, Home: $home, Shell: $shell"
# 输出：User: root, UID: 0, Home: /root, Shell: /bin/```Bash
###  利用 IFS="" 防止分割

```bash
data="hello:world:foo bar:baz"

# 临时修改 IFS（在子 shell 中）
(IFS=""; printf '[%s]\n' $data)
# 输出：
# [hello:world:foo bar:baz]
# 不分割

# 正常分割
IFS=":"; printf '[%s]\n' $data
# 输出：
# [hello]
# [world]
# [foo bar]
# [baz]

unset IFS
```

---

## 总结速查表

| 场景                       | 行为                       |
| -------------------------- | -------------------------- |
| `$var`（不加引号）         | 触发单词分割               |
| `"$var"`（加引号）         | **不**触发单词分割         |
| `$(cmd)`（不加引号）       | 触发单词分割               |
| `"$(cmd)"`（加引号）       | **不**触发单词分割         |
| IFS 未设置（`unset IFS`）  | 等同于 `IFS=$' \t\n'`      |
| `IFS=""`（空值）           | 不进行任何分割             |
| IFS 纯空白字符             | 连续空白合并，不产生空字段 |
| IFS 含非空白字符（如 `:`)  | 相邻分隔符产生空字段       |
| `""` / `''`（显式空参数）  | 保留为空字符串             |
| `$unset_var`（隐式空参数） | 被移除                     |
| `"$unset_var"`             | 保留为空字符串             |
