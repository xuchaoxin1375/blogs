[toc]



## Bash 中逻辑取反

Bash 中有多种实现逻辑取反的方式，适用于不同的场景。

```bash
$ help !
!: ! PIPELINE
    Execute PIPELINE, which can be a simple command, and negate PIPELINE's
    return status.

    Exit Status:
    The logical negation of PIPELINE's return status.
```

这表示 `!` 后面跟的是一个 **PIPELINE（管道）**。管道可以是**单个简单命令**，也可以是多个命令通过 `|` 连接。

执行管道（可以是简单命令），然后**对其返回状态取反**。

`!` 的退出状态是管道返回状态的**逻辑取反**。也就是说，如果管道返回 `0`（成功），`!` 让它变成 `1`（失败）；如果管道返回非零（失败），`!` 让它变成 `0`（成功）。

```bash
# true 返回 0
true; echo $?        # 输出 0
! true; echo $?      # 输出 1（取反）

# false 返回 1
false; echo $?       # 输出 1
! false; echo $?     # 输出 0（取反）

# 管道示例：grep 找不到时返回 1
! grep -q "不存在的内容" file.txt; echo $?  
# 如果没找到，grep 返回 1，取反后变成 0
```

为什么是 PIPELINE 而非 COMMAND

Bash 的命令层级是：简单命令 → 管道 → 列表。`!` 作用于管道级别，意味着它取反的是**整个管道的最终状态**（即**最后一个命令的退出状态**）：

```bash
! cat file.txt | grep "pattern" | wc -l
# 取反的是 wc -l 的退出状态，而非 cat 的
```

又比如

```bash

# cxxu@CxxuDesk 15:35:18> <~>
$  cat file.txt | grep "X";echo $?
XXXX BBBB CCCC
0

# cxxu@CxxuDesk 15:35:21> <~>
$ ! cat file.txt | grep "X";echo $?
XXXX BBBB CCCC
1

# cxxu@CxxuDesk 15:35:34> <~>
$ ! cat file.txt | grep "XY";echo $?
0

# cxxu@CxxuDesk 15:35:39> <~>
$ cat file.txt | grep "XY";echo $?
1
```

```bash
# 反转命令的退出状态
if ! grep -q "pattern" file.txt; then
    echo "pattern 未找到"
fi

# 反转条件表达式
if ! [ -f "file.txt" ]; then
    echo "文件不存在"
fi
```

需要注意的是，`!` 后面**通常需要一个空格**，否则可能触发历史扩展功能。



## 在 `[[ ]]` 和 `[ ]` 内部的`!`

- `! expr` expr 为假时为真。

```bash
# 在 [[ ]] 内部
if [[ ! -d "/path/to/dir" ]]; then
    echo "目录不存在"
fi

# 在 [ ] 内部
if [ ! -z "$var" ]; then
    echo "变量非空"
fi

# 字符串不相等
if [[ ! "$a" == "$b" ]]; then
    echo "a 和 b 不相等"
fi
```

## 在算术运算`(())`中使用

在 `(( ))` 算术上下文中，`!` 的行为类似于 C 语言的逻辑非。

```bash
a=0
if (( !a )); then
    echo "a 为 0（逻辑假）"
fi

b=5
if (( !b )); then
    echo "不会执行"
else
    echo "b 非零（逻辑真）"
fi
```

```bash
$ ! (( 1>2 )) && echo yes
yes
```



##  配合 `&&` 和 `||` 使用

```bash
# 如果命令失败则执行
! command && echo "命令失败了"

# 等价于
command || echo "命令失败了"
```

```bash
# cxxu@CxxuDesk 15:45:43> <~>
$ ! false && echo "failed"
failed

# cxxu@CxxuDesk 15:46:04> <~>
$ false || echo "failed"
failed
```



## 退出状态的理解

Bash 中退出状态 `0` 表示成功（逻辑真），非零表示失败（逻辑假）。`!` 操作符会将 `0` 变为 `1`，将非零变为 `0`。

```bash
true
echo $?   # 输出 0

! true
echo $?   # 输出 1

false
echo $?   # 输出 1

! false
echo $?   # 输出 0
```

##  常见陷阱

历史扩展冲突是一个需要注意的问题。在交互式 shell 中，`!` 可能触发历史扩展，解决方法是使用空格或单引号：

```bash
# 可能出问题
echo "hello!"     # ! 可能触发历史扩展

# 解决方案
echo "hello"'!'   # 使用单引号
echo 'hello!'     # 整体用单引号
set +H            # 临时关闭历史扩展
```

## 逻辑取反 `!` 的位置

```bash
# 正确：反转整个测试
if ! [ -f file ]; then

# 正确：在测试内部反转
if [ ! -f file ]; then

# 两者等价，但语义上有细微差别
```

## 总结

| 场景     | 语法              | 说明             |
| -------- | ----------------- | ---------------- |
| 反转命令 | `! command`       | 反转命令退出状态 |
| 测试内部 | `[ ! condition ]` | 在测试括号内反转 |
| 双括号   | `[[ ! expr ]]`    | Bash 扩展测试    |
| 算术运算 | `(( !var ))`      | C 风格逻辑非     |