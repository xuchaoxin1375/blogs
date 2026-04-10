[toc]



## Bash 参数扩展操作符 `${parameter@operator}` 总结



---

| 操作符                    | 名称       | 功能描述                                                     | 示例                                                         | Bash版本 |
| ------------------------- | ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------- |
| `${param@Q}`              | Quote      | 输出可作为输入重用的引用格式(比如回车符编码为`\n`)           | `"line\"line2"->'line"line2'`                                | 4.4+     |
| `${param@E}`              | Escape     | 展开转义序列（如`\n`, `\t`）,需要把 `\n` 等转义真正变成换行时 | `\n -> 换行`                                                 | 4.4+     |
| `${param@P}`              | Prompt     | 按提示符规则展开（如`\u`, `\h`）,自定义提示符相关玩法        | `\u -> 用户名 `                                              | 4.4+     |
| `${param@A}`              | Assign     | 输出变量的声明/赋值语句                                      | `${str@A}->str='line"line2'`                                 | 4.4+     |
| `${param@a}`              | Attributes | 输出变量的属性标志                                           | `echo ${arr@a}-> a`                                          | 4.4+     |
| `${param@U}`              | Uppercase  | 转换为全大写                                                 | `hello->HELLO`                                               | 5.1+     |
| `${param@u}`              | Capitalize | 首字母大写                                                   | `hello->Hello`                                               | 5.1+     |
| `${param@L}`              | Lowercase  | 转换为全小写                                                 | `Hello->hello`                                               | 5.1+     |
| `${param@K}`/`${param@k}` | Keys       | 输出数组 key/value（`K` 更偏“可重用输入格式”；`k` 会把 key/value 分成多个词） | `declare -A CONFIG=([debug]="true" [port]="8080" [host]="localhost" )`->`debug "true" port "8080" host "localhost"` | 5.1+     |



## 展开说明

> 这些扩展操作符大多支持"向量化"操作,也就是当`param`是一个数组变量时,使用`arr[@]`表达式可以对数组中的每个元素做相同的扩展操作.

### 1. `@Q` - 引用格式

类似于将字符串中的特殊字符(换行,回车等)做转义表示,"编码"处理,与之相反的"解码"在bash中也提供了转换操作符`@E`

把变量的值，转换成一个 **合法的 Bash 字符串表示形式**，并自动加上必要的**转义或引号**。

shell quoting（Shell 引号/转义）

reusable shell literal（可复用的 shell 字面量）

```bash
#!/bin/bash
# 用于安全地输出可重用的字符串

str="Hello World"
special="It's a \"test\" with \$var"

echo "${str@Q}"        # 输出: 'Hello World'
echo "${special@Q}"    # 输出: 'It'\''s a "test" with $var' (分为3部分子串的拼接)

$ declare -p special
declare -- special="It's a \"test\" with \$var"
```

---

关于`"${special@Q}"`给出的`'It'\''s a "test" with $var'`的解释

> 和`declare -p str`中给出的变量定义序列类似,都是可重入的,不过在引号的处理上可能有点区别,但是表达效果相同

原始变量 `special` 的内容是：`It's a "test" with $var`

Bash 为了确保这个字符串在任何环境下都能原样输出，采用了**单引号包裹**的策略，但**单引号内部不能直接嵌套单引号**，所以它进行了如下处理：

1. **`'It'`**：起始部分。用单引号包裹 `It`。
2. **`\'`**：**关键点**。**退出之前的单引号**，用反斜杠转义一个真实的单引号。
3. **`'s a "test" with $var'`**：剩余部分。**再次开启单引号，包裹剩下的所有字符**。

可重入命令行

```bash
#!/bin/bash

# ~/demo.sh
args=("$@")

echo "Re-run command:"
# 打印脚本名
echo -n "$HOME/demo.sh"
for a in "${args[@]}"; do
  printf ' %s' "${a@Q}"
done
echo

```



```bash
# 赋予~/demo.sh可执行权限.
chmod +x ~/demo.sh

# 提供带有特殊字符的参数字符串,测试输出
$ ~/demo.sh "[abc'def]" 'a2'
Re-run command:
/home/cxxu/demo.sh '[abc'\''def]' 'a2'

#将打印的命令行重新执行,效果和上面的一样
# (base) cxxu@CxxuDesk 17:50:59> <~>
$ /home/cxxu/demo.sh '[abc'\''def]' 'a2'
Re-run command:
/home/cxxu/demo.sh '[abc'\''def]' 'a2'
```



### 2. `@E` - 转义序列展开

作用类似于"解码"转义字符序列

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
# 显示红色文字
echo "${color@E}" 
# 不过还是使用-e参数方便些
echo -e "$color"
```

---

对于没有`echo -e`这种处理转义序列的选项,使用`${str@E}`可以完成相同的解释转义序列的处理.

### 3. `@P` - 按PS1提示符规则展开

提示符规则(转义规则)

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

和`declare -p`效果类似

```bash
#!/bin/bash
# 输出变量的完整声明(和变量定义时采用的形式相关.)

declare -i num=42
declare -r const="readonly"

echo "${num@A}"    # 输出: declare -i num='42'
echo "${const@A}"  # 输出: declare -r const='readonly'

str='line"line2'
echo ${str@A} # 输出:str='line"line2' (而不是declare -- str="line\"line2")

# 数组比较特别,在 Bash 中，当你直接引用数组名（如 ${arr}）而不指定索引时，它等同于引用下标为 0 的元素
declare -a arr=(a b c)
echo "${arr[@]@A}"    # 输出: declare -a arr=([0]="a" [1]="b" [2]="c")
echo "${arr@A}"   	# 输出 declare -a arr='a'
# 关联数组也是类似的
declare -A map=([key1]=val1 [key2]=val2)
echo "${map@A}" 	#输出 declare -p map
echo "${map[@]@A}"    # 输出: declare -A map=([key1]="val1" [key2]="val2")


```

---

`${var@A}` 是用于返回**能够重新创建该变量的赋值语句**。但是对于数组,要小心.

对于数组`declare -a arr=("a\"b" b c)`,我们可以对比一下不同的用法：

| **表达式**           | **结果**                                      | **说明**                         |
| -------------------- | --------------------------------------------- | -------------------------------- |
| `echo "${arr@A}"`    | `declare -a arr='a"b'`                        | 只处理第一个元素，结果具有误导性 |
| `echo "${arr[0]@A}"` | `declare -a arr='a"b'`                        | 处理特定索引的元素               |
| `echo "${arr[@]@A}"` | `declare -a arr=([0]="a\"b" [1]="b" [2]="c")` | **推荐做法**：展开整个数组的定义 |

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
echo "${arr[@]^^}" # 效果 同上

echo "${arr[@]@L}"  # 输出: hello world mixed
echo "${arr[@],,}" # 效果同上
```

---

### 7. `@K`/`@k` - 关联数组键值对 (Bash 5.1+)

`@K`将关联数组打印出来,对于值带空格的情况会带上引号,处理较好,偏向可重入

`@k`类似,但是不带引号保护

```bash
#!/bin/bash
# 展开关联数组的键值对

declare -A user=(
    [name]="John X"
    [age]="30"
    [city]="NYC"
)

echo "${user[@]@K}"
# 输出: city "NYC" age "30" name "John X"
echo ${user[@]@k}
# 输出: city NYC age 30 name John X

# 用于调试,可以包装为函数
debug_assoc() {
	# 定义参数1的引用变量(局部)
    local -n ref=$1
    echo "Contents: ${ref[@]@K}"
}
debug_assoc user
```

---

```bash
# (base) cxxu@CxxuDesk 20:36:18> <~>
$ declare -A Q=(city "NYC" age "30" name "John X")

# (base) cxxu@CxxuDesk 20:37:59> <~>
$ declare -p Q
declare -A Q=([city]="NYC" [age]="30" [name]="John X" )
```



## 综合示例

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

# 导出配置（保留类型和属性）,可重定向输出到文件.
export_config() {
    echo "# Auto-generated config"
    echo "${CONFIG[@]@A}"
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
# === Configuration ===
#App: 'MyApp'
#Max Connections: 100 (type: i)
#Settings: debug "true" port "8080" host "localhost"
export_config > config.backup
```



