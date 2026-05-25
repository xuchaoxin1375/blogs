[toc]



# sed 分隔符

## abstract

`sed` 默认使用 `/` 作为分隔符，但可以使用**任意字符**作为分隔符，这在处理包含 `/` 的路径时非常有用。

在 `sed` 中，只有执行 **`s` (替换)** 命令时，才可以直接紧跟一个字符作为自定义分隔符（例如 `s|pattern|replacement|`）。

其他命令,例如 **`d` (删除)** 命令或单纯的正则匹配，如果你想更改默认的斜杠 `/` 分隔符，必须在第一个分隔符前加一个**反斜杠 `\`**。

---

### sed的`s`命令语法格式

选择一个**不出现在替换(s命令)内容中**的字符作为分隔符即可:

常见分隔符除了`/`还有:

```bash
sed 's/old/new/标志'
# 等价于
sed 's|old|new|标志'
sed 's#old#new#标志'
sed 's@old@new@标志'
```

---

如果指定的分隔符在"`old`"或者"`new`"中包含(一般是少量包含,否则建议更换分隔符),将分隔符转义(使用`\`转义)

其他命令(非`s`):

例如`d`**匹配/删除命令：** 必须以 `\` 开头来告知 `sed` 紧跟的字符是自定义分隔符(后续使用指定分隔符时,就**不需要每个位置**都使用`\`修饰)。

- 例：`\|pattern|d` (正确)
- 例：`|pattern|d` (**错误**，sed 会把第一个 `|` 当作一个未识别的命令)



## 常用分隔符示例

### 默认分隔符 `/`
```bash
echo "hello world" | sed 's/hello/hi/'
# 输出: hi world
```

### 使用 `|` 作为分隔符
```bash
# 替换路径时避免转义
echo "/usr/local/bin" | sed 's|/usr/local|/opt|'
# 输出: /opt/bin
```

需要转义的情况:为了能够在原串中匹配到`loc|al`,这里在写原串是要将`|`转义,写成`\|`

```bash
$ echo "/usr/loc|al/bin" | sed 's|/usr/loc\|al|/opt|'
/opt/bin
```

打印正则匹配的行(下面使用自定义分隔符界定正则表达式,在表达式中包含大量斜杠时提供方便).

```bash
sed -n '\|include /www/.*/cf-realip\.conf;|p' com_com.conf
# 示例输出:
# include /www/server/nginx/conf/cf-realip.conf;
```



### 使用 `#` 作为分隔符

```bash
echo "/etc/nginx/nginx.conf" | sed 's#/etc/nginx#/etc/apache2#'
# 输出: /etc/apache2/nginx.conf
```

### 使用 `@` 作为分隔符
```bash
echo "/home/user/file" | sed 's@/home/user@/root@'
# 输出: /root/file
```

### 使用 `,` 作为分隔符
```bash
echo "a/b/c" | sed 's,/,-,g'
# 输出: a-b-c
```

---

## 对比：使用 vs 不使用自定义分隔符

```bash
# ❌ 需要大量转义，可读性差
sed 's/\/usr\/local\/bin/\/opt\/bin/g' file

# ✅ 使用自定义分隔符，清晰易读
sed 's|/usr/local/bin|/opt/bin|g' file
```

---

## 地址范围中的分隔符

```bash
# 在地址中也可使用自定义分隔符（需加 \）
sed '\|/usr/local|d' file        # 删除包含 /usr/local 的行
sed '\|/etc/|,\|/end/|d' file    # 删除范围内的行
```

---

## 实际应用场景

```bash
# 1. 修改配置文件路径
sed -i 's|/old/path|/new/path|g' config.conf

# 2. 替换 URL
sed 's|http://|https://|g' urls.txt

# 3. 处理 Windows 路径
echo "C:\Users\test" | sed 's|\\|/|g'

# 4. 替换变量中含有 / 的内容
OLD_PATH="/usr/bin"
NEW_PATH="/usr/local/bin"
sed "s|$OLD_PATH|$NEW_PATH|g" file
```

---

## 总结

| 分隔符 | 使用场景          |
| ------ | ----------------- |
| `/`    | 默认，通用场景    |
| `\|`   | 处理文件路径、URL |
| `#`    | 处理文件路径      |
| `@`    | 处理文件路径      |
| `,`    | 其他特殊场景      |

> **原则**：选择一个**不出现在替换内容中**的字符作为分隔符即可。