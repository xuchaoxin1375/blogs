[toc]





---

## 二、基本示例



### 1. 写入文件

```bash
cat << EOF > myfile.txt
这是第一行
这是第二行
变量：$USER
EOF
```

> 💡 `$USER` 会被当前 Shell 展开（除非用引号包裹分隔符 —— 见下文“变量展开控制”）

生成的 `myfile.txt` 内容：

```
这是第一行
这是第二行
变量：cxxu
```

---

### 2. 作为命令输入

```bash
wc -l << EOF
apple
banana
cherry
EOF
```

输出：

```
3
```

---

### 3. 传给交互式命令（如 mail、sql、ssh 等）

```bash
mysql -u root -p << SQL
USE mydb;
SELECT * FROM users;
QUIT;
SQL
```

---

## 三、高级用法

### 1. `<<-`：忽略行首的制表符（Tab）

用于在脚本中保持缩进美观：

```bash
cat <<- EOF
	第一行（前面是 Tab）
	第二行
EOF
```

输出：

```
第一行（前面是 Tab）
第二行
```

> ⚠️ 只能忽略 **Tab**，不能忽略空格！

---

### 2. 禁用变量/命令展开：用引号包裹分隔符

默认情况下，Here Doc 内容中的 `$变量`、`$(命令)`、反引号等会被 Shell 展开。

如需**原样输出**，用单引号或双引号包裹分隔符：

```bash
cat << 'EOF'
当前用户是：$USER
当前日期是：$(date)
EOF
```

输出：

```
当前用户是：$USER
当前日期是：$(date)
```

> ✅ 适合写配置文件、脚本模板等需保留字面值的场景。

---

### 3. 嵌套在函数或条件语句中

```bash
if [ "$DEBUG" = "true" ]; then
    cat << DEBUG_INFO
调试模式开启
时间：$(date)
用户：$USER
DEBUG_INFO
fi
```

---

### 4. 重定向到多个命令（使用 `{ }` 组合）

```bash
{
    head -n 2
    echo "-----"
    tail -n 1
} << DATA
Line 1
Line 2
Line 3
Line 4
DATA
```

输出：

```
Line 1
Line 2
-----
Line 4
```

---

## 🚫 四、常见错误与注意事项

| 问题                   | 原因                   | 解决方法                                                     |
| ---------------------- | ---------------------- | ------------------------------------------------------------ |
| 分隔符不顶格           | Shell 找不到结束标记   | 确保结束分隔符单独一行，且**无前导空格或 Tab**（除非用 `<<-`） |
| 变量被提前展开         | 默认行为               | 用 `<< 'EOF'` 禁用展开                                       |
| 分隔符冲突             | 内容中包含分隔符字符串 | 改用更独特的分隔符，如 `EOF123`、`__END__`                   |
| 语法错误在脚本中难调试 | 缩进或格式问题         | 使用 `<<-` + Tab 缩进；或编辑器开启“显示空白字符”            |

---

## 📊 五、Here Doc vs Here String

| 特性         | Here Document (`<<`)     | Here String (`<<<`)       |
| ------------ | ------------------------ | ------------------------- |
| 输入内容     | 多行文本                 | 单行字符串                |
| 语法         | `cmd << DELIM ... DELIM` | `cmd <<< "string"`        |
| 是否支持变量 | 默认支持，可关闭         | 支持                      |
| 典型用途     | 配置文件、SQL、邮件正文  | 单行输入，如 `read`, `bc` |
| 示例         | `cat <<EOF > file`       | `bc <<< "2+3"`            |

---

## 🎯 六、实用场景推荐

### 1. 生成配置文件

```bash
cat > /etc/myapp/config.conf << 'CONF'
host = localhost
port = 8080
debug = false
CONF
```

### 2. 自动化交互命令（如 ssh、ftp）

```bash
ssh user@host << 'SSH'
cd /var/log
ls -l *.log
exit
SSH
```

> ⚠️ 注意：某些交互式程序（如 `ssh`, `ftp`, `mysql`）可能需要 `-t` 或关闭伪终端，或改用 `expect`。

### 3. 写入带变量的模板（展开变量）

```bash
NAME="Alice"
AGE=30

cat << EOF > welcome.txt
欢迎 $NAME！
你的年龄是：$AGE 岁。
EOF
```

---

## ✅ 七、总结

> **Here Document 是 Shell 脚本中“内嵌多行文本”的利器，避免了临时文件，让脚本更整洁、更易维护。**

✔ 用 `<< DELIMITER` 提供多行输入  
✔ 用 `<<-` + Tab 保持脚本缩进美观  
✔ 用 `<< 'DELIMITER'` 禁用变量展开  
✔ 分隔符必须单独成行且匹配  
✔ 适合生成配置、脚本、SQL、邮件等场景

---

