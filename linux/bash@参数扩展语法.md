[toc]



在 Bash 中，`${}` 是 **参数扩展（Parameter Expansion）** 的语法，用于对变量进行操作，包括获取值、字符串处理、默认值设置等。它是 Shell 脚本中非常强大且常用的功能。  

---

## **1. 基础用法：变量取值**
最基本的用法是获取变量的值：
```bash
name="Alice"
echo "Hello, ${name}"  # 输出：Hello, Alice
```
- `$name` 和 `${name}` 效果相同，但 `${}` 更清晰，尤其在复杂字符串中：
  ```bash
  echo "Hello, ${name}!"  # 推荐
  echo "Hello, $name!"    # 也可以，但可能引起歧义
  ```

---

## **2. 避免变量名歧义**
如果变量名后面紧跟字母、数字或下划线，必须用 `${}`：
```bash
fruit="apple"
echo "I have ${fruit}s"  # 输出：I have apples
echo "I have $fruits"    # 错误！Bash 会尝试读取变量 `fruits`
```

---

## **3. 默认值设置**
如果变量未定义或为空，可以设置默认值：
| 语法              | 说明                                         |
| ----------------- | -------------------------------------------- |
| `${var-default}`  | 如果 `var` 未定义，使用 `default`            |
| `${var:-default}` | 如果 `var` 未定义 **或为空**，使用 `default` |

**示例：**
```bash
unset name
echo "Hello, ${name:-Guest}"  # 输出：Hello, Guest（因为 name 未定义）
name=""
echo "Hello, ${name:-Guest}"  # 输出：Hello, Guest（因为 name 为空）
name="Alice"
echo "Hello, ${name:-Guest}"  # 输出：Hello, Alice
```

---

## **4. 字符串操作**
### **(1) 获取字符串长度**
```bash
str="Hello"
echo "${#str}"  # 输出：5（字符数）
```

### **(2) 截取子字符串**
```bash
str="Hello World"
echo "${str:0:5}"  # 输出：Hello（从索引 0 开始，取 5 个字符）
```

### **(3) 删除匹配的部分**
| 语法              | 说明                          |
| ----------------- | ----------------------------- |
| `${var#pattern}`  | 从 **开头** 删除 **最短匹配** |
| `${var##pattern}` | 从 **开头** 删除 **最长匹配** |
| `${var%pattern}`  | 从 **结尾** 删除 **最短匹配** |
| `${var%%pattern}` | 从 **结尾** 删除 **最长匹配** |

**示例：**
```bash
file="backup.tar.gz"
echo "${file%.*}"     # 输出：backup.tar（删除最短 `.` 后缀）
echo "${file%%.*}"    # 输出：backup（删除最长 `.` 后缀）
echo "${file#*.}"     # 输出：tar.gz（删除最短前缀）
echo "${file##*.}"    # 输出：gz（删除最长前缀）
```

---

## **5. 查找和替换**
| 语法                          | 说明                 |
| ----------------------------- | -------------------- |
| `${var/pattern/replacement}`  | 替换 **第一个** 匹配 |
| `${var//pattern/replacement}` | 替换 **所有** 匹配   |

**示例：**
```bash
str="hello world hello"
echo "${str/hello/Hi}"    # 输出：Hi world hello（仅替换第一个）
echo "${str//hello/Hi}"   # 输出：Hi world Hi（替换所有）
```

---

## **6. 变量间接引用（间接取值）**
```bash
var="name"
name="Alice"
echo "${!var}"  # 输出：Alice（相当于 ${name}）
```

---

## **7. 检查变量是否设置**
| 语法           | 说明                            |
| -------------- | ------------------------------- |
| `${var?Error}` | 如果 `var` 未定义，报错并退出   |
| `${var+value}` | 如果 `var` 已定义，返回 `value` |

**示例：**
```bash
unset name
echo "${name?Error: name is not set}"  # 报错并退出
```

---

## **总结**
| 功能             | 语法                  |
| ---------------- | --------------------- |
| 变量取值         | `${var}`              |
| 默认值           | `${var:-default}`     |
| 字符串长度       | `${#var}`             |
| 子字符串         | `${var:start:length}` |
| 删除前缀         | `${var#pattern}`      |
| 删除后缀         | `${var%pattern}`      |
| 替换字符串       | `${var/old/new}`      |
| 间接引用         | `${!var}`             |
| 检查变量是否设置 | `${var?Error}`        |

## 案例

```bash
# ==获取字符串中前两个小数点的字段(第二个小数点之前的部分)
get_main_domain() {
    local s="$1"

    if [[ "$s" == *.*.* ]]; then
        local a="${s%%.*}" #利用通配符描述截取/获取第一个点之前的部分
        local b="${s#*.}"; b="${b%%.*}" # 先获取第一个点之后的部分;然后利用上一行的思路再次获取剩余部分的第一个点之前的部分,也就是原串第二个字段(介于第一个和第二个点之间的bu)
        echo "$a.$b"
    else
        echo "$s"
    fi
}
```

```bash
# root @ wnx0020303 in /srv/uploads/uploader/files/xcx [11:52:35]
$ get_main_domain 'ab.com'
ab.com

# root @ wnx0020303 in /srv/uploads/uploader/files/xcx [11:52:50]
$ get_main_domain 'ab.com.tar'
ab.com
# root @ wnx0020303 in /srv/uploads/uploader/files/xcx [11:52:52]  
$ get_main_domain '/asd/sdfa/ab.cdt.ss.ss'
/asd/sdfa/ab.cdt
```

