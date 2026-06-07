[toc]



## abstract

下面从**用途、工作机制、处理模型、适用场景、性能思维**几个角度深入对比 `grep`、`sed`、`awk`。

------

| 工具   | 核心定位               | 最擅长做什么                           |
| ------ | ---------------------- | -------------------------------------- |
| `grep` | **查找/过滤文本行**    | 找出匹配某个模式的行                   |
| `sed`  | **流式编辑器**         | 对文本流做替换、删除、插入、改写       |
| `awk`  | **文本分析与报表语言** | 按字段处理数据、计算、统计、格式化输出 |

可以简单记成：

```bash
grep 负责“找”
sed  负责“改”
awk  负责“分析和生成”
```

------

## 1. grep：面向“行”的模式筛选器

### 典型用途

`grep` 用来从文本中找出符合条件的行。

例如：

```bash
grep "error" app.log
```

含义是：从 `app.log` 中找出包含 `error` 的所有行。

常见用途包括：

```bash
grep "ERROR" app.log
grep -i "error" app.log          ## 忽略大小写
grep -v "debug" app.log          ## 排除匹配行
grep -n "timeout" app.log        ## 显示行号
grep -r "TODO" src/              ## 递归搜索目录
grep -E "error|fail|panic" log   ## 扩展正则
```

### 工作机制

`grep` 的处理模型非常直接：

```text
读取一行
↓
判断这一行是否匹配模式
↓
匹配则输出，不匹配则丢弃
↓
继续下一行
```

它的核心对象是**整行文本**。

例如文件：

```text
alice 18
bob 20
carol 17
```

执行：

```bash
grep "bob" file.txt
```

`grep` 不关心 `bob` 是第几个字段，也不计算年龄，它只是判断：

```text
这一行里有没有 bob？
```

所以输出：

```text
bob 20
```

### grep 的特点

`grep` 很适合：

```text
有没有？
在哪里？
哪些行符合？
哪些行不符合？
```

但它不擅长：

```text
把第 2 列加起来
只输出第 3 个字段
按条件重新格式化
复杂状态处理
```

例如下面这种需求用 `grep` 就不合适：

```text
统计所有年龄大于 18 的人的平均年龄
```

这已经进入 `awk` 的领域。

------

## 2. sed：面向“流”的文本编辑器

### 典型用途

`sed` 是 stream editor，也就是**流式编辑器**。

它常用于对文本做批量修改：

```bash
sed 's/error/ERROR/' app.log
```

含义是：把每行中第一次出现的 `error` 替换为 `ERROR`。

常见用法：

```bash
sed 's/foo/bar/' file.txt       ## 每行替换第一个 foo
sed 's/foo/bar/g' file.txt      ## 每行替换所有 foo
sed '/debug/d' file.txt         ## 删除包含 debug 的行
sed -n '10,20p' file.txt        ## 打印第 10 到 20 行
sed '1d' file.txt               ## 删除第一行
sed 's/^/## /' file.txt          ## 每行开头加注释
```

### 工作机制

`sed` 也是逐行处理，但它比 `grep` 多了一个重要概念：

```text
模式空间 pattern space
```

基本流程是：

```text
读取一行到 pattern space
↓
对 pattern space 执行 sed 脚本命令
↓
默认输出 pattern space
↓
清空 pattern space，读取下一行
```

例如：

```bash
sed 's/cat/dog/' file.txt
```

对于每一行，`sed` 会把这一行放入 pattern space，然后执行替换命令。

如果原始行是：

```text
a cat is here
```

pattern space 初始内容：

```text
a cat is here
```

执行：

```text
s/cat/dog/
```

之后变成：

```text
a dog is here
```

然后输出。

### sed 的关键点：默认输出

很多人刚学 `sed` 会困惑这个命令：

```bash
sed -n '/error/p' app.log
```

为什么要加 `-n`？

因为 `sed` 默认会输出每一行。

如果写：

```bash
sed '/error/p' app.log
```

匹配 `error` 的行会被打印两次：

```text
默认打印一次
p 命令又打印一次
```

所以筛选打印时通常写：

```bash
sed -n '/error/p' app.log
```

这有点像 `grep "error" app.log`。

### sed 的高级机制：hold space

除了 pattern space，`sed` 还有一个辅助缓冲区：

```text
hold space
```

可以理解为临时存储区。

常见命令包括：

```bash
h   把 pattern space 复制到 hold space
H   把 pattern space 追加到 hold space
g   把 hold space 复制回 pattern space
G   把 hold space 追加回 pattern space
x   交换 pattern space 和 hold space
```

因此 `sed` 虽然通常按行处理，但它也能处理一些跨行问题。

不过，复杂跨行逻辑用 `sed` 会变得难读，通常不如 `awk` 或脚本语言清晰。

------

## 3. awk：面向“记录和字段”的文本处理语言

### 典型用途

`awk` 更像一门小型编程语言，特别适合处理结构化文本，比如：

```text
alice 18 90
bob   20 85
carol 17 95
```

执行：

```bash
awk '{print $1, $3}' file.txt
```

输出第 1 列和第 3 列：

```text
alice 90
bob 85
carol 95
```

常见用法：

```bash
awk '{print $1}' file.txt              ## 打印第一列
awk '$2 > 18 {print $1}' file.txt      ## 第二列大于 18 时打印第一列
awk '{sum += $3} END {print sum}' file ## 求第三列总和
awk -F, '{print $1, $3}' data.csv      ## 按逗号分隔字段
```

### 工作机制

`awk` 的基本模型是：

```text
BEGIN 块
↓
逐条读取记录
↓
按分隔符切成字段
↓
执行 pattern { action }
↓
END 块
```

典型结构：

```bash
awk '
BEGIN {
    ## 处理输入前执行
}
pattern {
    ## 每条记录满足条件时执行
}
END {
    ## 所有输入处理完后执行
}
' file
```

例如：

```bash
awk '
BEGIN { print "name score" }
$3 >= 90 { print $1, $3 }
END { print "done" }
' file.txt
```

### awk 的核心概念

#### 1. 记录：record

默认情况下，`awk` 把**一行**当作一条记录。

当前整行是：

```awk
$0
```

例如：

```text
alice 18 90
```

那么：

```awk
$0 = "alice 18 90"
```

#### 2. 字段：field

默认按空白字符分割字段。

```text
alice 18 90
```

在 `awk` 中：

```awk
$1 = "alice"
$2 = "18"
$3 = "90"
```

字段数量保存在：

```awk
NF
```

当前行号保存在：

```awk
NR
```

例如：

```bash
awk '{print NR, NF, $1}' file.txt
```

#### 3. 分隔符

默认字段分隔符是空白字符。

如果是 CSV：

```text
alice,18,90
bob,20,85
```

可以写：

```bash
awk -F, '{print $1, $3}' file.csv
```

也可以在 `BEGIN` 中设置：

```bash
awk 'BEGIN {FS=","} {print $1, $3}' file.csv
```

输出字段分隔符可以用 `OFS` 控制：

```bash
awk 'BEGIN {OFS=" | "} {print $1, $2, $3}' file.txt
```

------

## 4. 三者处理模型对比

### grep 的模型

```text
line -> regex match -> print or discard
```

它的核心是：

```text
匹配整行
```

示例：

```bash
grep "error" log.txt
```

逻辑类似：

```pseudo
for line in file:
    if line contains "error":
        print line
```

------

### sed 的模型

```text
line -> pattern space -> editing commands -> print
```

它的核心是：

```text
修改当前行
```

示例：

```bash
sed 's/error/ERROR/g' log.txt
```

逻辑类似：

```pseudo
for line in file:
    line = replace(line, "error", "ERROR")
    print line
```

------

### awk 的模型

```text
record -> split into fields -> condition/action -> variables/statistics/output
```

它的核心是：

```text
按字段分析记录
```

示例：

```bash
awk '$3 >= 90 {print $1}' scores.txt
```

逻辑类似：

```pseudo
for line in file:
    fields = split(line)
    if fields[3] >= 90:
        print fields[1]
```

------

## 5. 用同一个例子对比

假设有文件 `access.log`：

```text
192.168.1.1 GET /index.html 200
192.168.1.2 POST /login 500
192.168.1.3 GET /about 404
192.168.1.4 GET /index.html 200
```

### 需求 1：找出包含 500 的行

用 `grep` 最合适：

```bash
grep "500" access.log
```

输出：

```text
192.168.1.2 POST /login 500
```

也可以用 `sed`：

```bash
sed -n '/500/p' access.log
```

也可以用 `awk`：

```bash
awk '/500/' access.log
```

但最自然的是 `grep`。

------

### 需求 2：把 GET 改成 METHOD_GET

用 `sed` 最合适：

```bash
sed 's/GET/METHOD_GET/g' access.log
```

这是典型文本替换。

------

### 需求 3：只输出状态码是 200 的 IP

用 `awk` 最合适：

```bash
awk '$4 == 200 {print $1}' access.log
```

输出：

```text
192.168.1.1
192.168.1.4
```

这里需要理解字段：

```text
$1 = IP
$2 = METHOD
$3 = PATH
$4 = STATUS
```

所以 `awk` 比 `grep` 更合适。

------

### 需求 4：统计每种状态码出现次数

用 `awk`：

```bash
awk '{count[$4]++} END {for (code in count) print code, count[code]}' access.log
```

可能输出：

```text
200 2
404 1
500 1
```

这已经是统计分析，`grep` 和 `sed` 都不是最佳选择。

------

## 6. 正则能力对比

三者都支持正则，但使用方式不同。

| 工具   | 正则主要用途           |
| ------ | ---------------------- |
| `grep` | 判断一行是否匹配       |
| `sed`  | 定位行、替换文本       |
| `awk`  | 作为条件判断或字段匹配 |

### grep 中的正则

```bash
grep -E 'error|fail|panic' log.txt
```

含义：

```text
匹配 error、fail 或 panic
```

------

### sed 中的正则

```bash
sed -n '/error/p' log.txt
```

表示打印匹配 `error` 的行。

```bash
sed 's/[0-9]\+/NUMBER/g' file.txt
```

表示把数字替换成 `NUMBER`。

注意：不同 `sed` 版本对正则扩展的开关略有差异，GNU sed 常用：

```bash
sed -E 's/[0-9]+/NUMBER/g' file.txt
```

------

### awk 中的正则

```bash
awk '/error/' log.txt
```

表示整行匹配 `error`。

也可以指定字段：

```bash
awk '$3 ~ /error/ {print $1, $3}' log.txt
```

含义是：第 3 个字段匹配 `error` 时，输出第 1 和第 3 个字段。

反向匹配：

```bash
awk '$3 !~ /error/ {print $0}' log.txt
```

------

## 7. 条件能力对比

### grep 的条件能力很弱

`grep` 的条件主要是：

```text
匹配
不匹配
大小写
前后文
```

例如：

```bash
grep -v "debug" log.txt
```

它不擅长这种逻辑：

```text
第 3 列大于 90 并且第 1 列以 a 开头
```

------

### sed 的条件是“地址 + 命令”

`sed` 的条件称为地址。

例如：

```bash
sed '/error/d' log.txt
```

含义是：

```text
匹配 error 的行执行 d 删除命令
```

也可以指定行号：

```bash
sed '1,10d' file.txt
```

表示删除第 1 到第 10 行。

sed 的逻辑适合：

```text
某些行做某些编辑
```

------

### awk 的条件最强

`awk` 可以写复杂条件：

```bash
awk '$2 > 18 && $3 >= 90 {print $1}' file.txt
```

也可以使用变量、数组、函数：

```bash
awk '
$4 == 200 {ok++}
$4 == 500 {err++}
END {
    print "ok:", ok
    print "error:", err
}
' access.log
```

`awk` 本质上已经接近一门脚本语言。

------

## 8. 状态与记忆能力对比

| 工具   | 是否容易保存状态 | 说明                                         |
| ------ | ---------------- | -------------------------------------------- |
| `grep` | 很弱             | 基本只判断当前行                             |
| `sed`  | 中等             | 有 pattern space 和 hold space，但复杂时难读 |
| `awk`  | 很强             | 有变量、数组、计数器、BEGIN/END              |

例如统计总数：

```bash
awk '{sum += $3} END {print sum}' scores.txt
```

这是 `awk` 非常自然的写法。

用 `sed` 做也不是完全不可能，但会很别扭。

------

## 9. 修改文件能力对比

### grep

`grep` 通常不修改文件，只输出匹配结果。

```bash
grep "error" log.txt
```

------

### sed

`sed` 常用于修改文件内容。

默认只输出修改后的内容，不直接改原文件：

```bash
sed 's/foo/bar/g' file.txt
```

使用 `-i` 可以原地修改：

```bash
sed -i 's/foo/bar/g' file.txt
```

更安全的方式是先备份：

```bash
sed -i.bak 's/foo/bar/g' file.txt
```

------

### awk

`awk` 也可以生成修改后的内容：

```bash
awk '{$2 = $2 + 1; print}' file.txt
```

但它通常不是“原地编辑器”。

如果要保存结果，一般写：

```bash
awk '{$2 = $2 + 1; print}' file.txt > new.txt
```

------

## 10. 选择建议

### 用 grep 的场景

当你的需求是：

```text
找包含某关键词的行
排除某些行
搜索目录中的文件内容
快速定位日志
```

优先用 `grep`。

例子：

```bash
grep -rn "TODO" src/
grep -i "exception" app.log
grep -v "healthcheck" access.log
```

------

### 用 sed 的场景

当你的需求是：

```text
替换文本
删除某些行
打印某个范围
给行首行尾加内容
批量改配置文件
```

优先用 `sed`。

例子：

```bash
sed 's/localhost/127.0.0.1/g' config.txt
sed '/^#/d' config.txt
sed -n '20,40p' file.txt
```

------

### 用 awk 的场景

当你的需求是：

```text
按列处理
条件筛选字段
计算总和、平均值、次数
生成格式化报表
处理结构化日志、CSV、TSV
```

优先用 `awk`。

例子：

```bash
awk '{print $1, $3}' file.txt
awk '$5 > 1000 {print $1, $5}' access.log
awk '{sum += $2} END {print sum}' data.txt
awk -F, '{print $1, $4}' data.csv
```

------

## 11. 它们经常组合使用

这三个工具并不是互斥的，经常在管道中组合。

例如：

```bash
grep "ERROR" app.log | sed 's/^/[ALERT] /'
```

含义：

```text
先找出 ERROR 行
再给每行前面加 [ALERT]
```

再比如：

```bash
grep "GET" access.log | awk '$4 == 200 {print $1}'
```

含义：

```text
先筛出 GET 请求
再找状态码为 200 的 IP
```

不过有时可以直接用 `awk` 替代整条管道：

```bash
awk '$2 == "GET" && $4 == 200 {print $1}' access.log
```

这个版本通常更清晰，也少启动一个进程。

------

## 12. 深层区别：它们的“抽象层级”不同

### grep 的抽象

```text
文本行是否匹配模式
```

它不知道字段，不做编辑，不做统计。

------

### sed 的抽象

```text
文本流经过一组编辑命令后输出
```

它关心文本如何被替换、删除、插入。

------

### awk 的抽象

```text
记录由字段组成，对满足条件的记录执行动作
```

它不仅能匹配，还能计算、保存状态、格式化输出。

------

## 13. 实战判断口诀

看到需求时可以这样判断：

```text
只是找行？用 grep
需要替换、删除、插入？用 sed
需要按列、计算、统计？用 awk
```

更具体一点：

```text
“包含 xxx 的行”           → grep
“把 xxx 改成 yyy”         → sed
“第 N 列满足条件”         → awk
“统计出现次数/求和/平均”   → awk
“删除匹配行”              → sed 或 grep -v
“打印某几行”              → sed
“递归搜代码”              → grep
```

------

## 14. 综合对比表

| 维度             | grep                | sed                  | awk                     |
| ---------------- | ------------------- | -------------------- | ----------------------- |
| 核心用途         | 搜索、过滤          | 编辑、替换           | 分析、统计、格式化      |
| 基本单位         | 行                  | 行 / pattern space   | 记录 / 字段             |
| 默认行为         | 输出匹配行          | 输出处理后的每一行   | 对每行执行动作          |
| 是否擅长字段处理 | 不擅长              | 不擅长               | 很擅长                  |
| 是否擅长替换     | 一般不用            | 非常擅长             | 可以，但不是首选        |
| 是否擅长统计     | 不擅长              | 不擅长               | 非常擅长                |
| 是否支持变量     | 基本不支持          | 很有限               | 支持                    |
| 是否支持数组     | 不支持              | 不支持               | 支持关联数组            |
| 跨行处理         | 很弱                | 可以但复杂           | 可以，较自然            |
| 典型命令         | `grep pattern file` | `sed 's/a/b/g' file` | `awk '{print $1}' file` |

------

### 最核心的区别

`grep` 是**过滤器**：

```bash
grep "error" log.txt
```

`sed` 是**编辑器**：

```bash
sed 's/error/ERROR/g' log.txt
```

`awk` 是**文本处理语言**：

```bash
awk '$3 > 100 {sum += $3} END {print sum}' data.txt
```

所以它们不是简单的“谁更强”，而是面向的问题不同：

```text
grep：我想知道哪些行符合条件
sed：我想把文本流改造成另一种文本流
awk：我想理解文本里的字段，并基于它们做逻辑处理
```
