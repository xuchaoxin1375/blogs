[toc]





---

##  1. **Here Document（推荐用于大段文本）**

使用 `<<` 或 `<<-`，适合嵌入大段文本、配置、SQL、脚本等。

### 基本语法：
```bash
变量名=$(cat <<'EOF'
第一行
第二行
第三行
EOF
)
```

> 注意：`EOF` 可以换成任意标识符（如 `END`, `SQL`, `CONFIG`），**结尾必须顶格写**。

### 示例：

```bash
sql=$(cat <<'EOF'
SELECT user, host
FROM mysql.user
WHERE host != 'localhost';
EOF
)

echo "$sql"
```

 **优点**：
- 保留换行和缩进
- 支持原样输出（使用 `'EOF'` 可避免变量展开）
- 非常适合 SQL、配置文件、脚本块

⚠️ **注意**：
- 如果用 `<<EOF`（不加引号），**会进行变量替换和命令展开**。
- 如果用 `<<'EOF'`（加引号），则**原样输出**，不解析变量。

```bash
server='userx'
str=$(cat <<EOF
SELECT user, host FROM mysql.user
WHERE host != $server;
EOF
)

echo "$str"
```

输出结果为:

```bash
SELECT user, host FROM mysql.user
WHERE host != userx; #变量$server被替换为userx
```

再看不替换的情况

```bash
server='userx'
str=$(cat <<'EOF'
SELECT user, host FROM mysql.user
WHERE host != $server;
EOF
)

echo "$str"
```

会保留`$server`字符串儿不会展开(替换)

```bash
SELECT user, host FROM mysql.user
WHERE host != $server;
```



---

##  2. **使用换行符 `\n` + `echo -e` 或 `printf`**

适合程序化拼接多行。

```bash
msg="第一行\n第二行\n第三行"
echo -e "$msg"
```

或使用 `printf`（更推荐，更可移植）：

```bash
printf "第一行\n第二行\n第三行\n"
```

也可以赋值给变量：

```bash
msg=$(printf "Line 1\nLine 2\nLine 3\n")
echo "$msg"
```

---

##  3. **直接用引号包裹换行（最简单）**

Bash 允许在双引号内直接换行：

```bash
msg="这是第一行
这是第二行
这是第三行"

echo "$msg"
```

 优点：最直观，适合少量换行  
⚠️ 注意：变量和转义符（如 `$`, `\n`）会被解析

---

##  4. **使用数组存储多行（适合逐行处理）**

```bash
lines=(
    "第一行内容"
    "第二行内容"
    "第三行内容"
)

for line in "${lines[@]}"; do
    echo "$line"
done
```

 适合需要逐行操作、过滤、计数等场景

---

## 🆚 对比总结

| 方法              | 是否保留换行 | 是否解析变量  | 适用场景                   |
| ----------------- | ------------ | ------------- | -------------------------- |
| `"多行直接写"`    |              |               | 简单少量文本               |
| `$'line1\nline2'` | （用\n）     | ❌（部分转义） | 程序化拼接，支持 `\n\t` 等 |
| `Here Document`   |              | 可控（引号）  | 大段文本、SQL、配置        |
| 数组              | （每行独立） |               | 需要逐行处理               |

---

## 💡 实用技巧：在脚本中嵌入 SQL 多行语句

```bash
#!/bin/bash

SQL=$(cat <<'END_SQL'
SELECT
    table_schema AS '库名',
    COUNT(*) AS '表数量'
FROM information_schema.tables
WHERE table_schema NOT IN ('mysql', 'sys', 'information_schema')
GROUP BY table_schema;
END_SQL
)

echo "即将执行："
echo "$SQL"
echo "------------------"

# 执行（假设已配置好 mysql 登录）
# mysql -u root -e "$SQL"
```

---

## ⚠️ 注意事项

- 多行字符串赋值给变量时，**必须用双引号包围变量**才能保留换行：
  ```bash
  echo "$msg"   #  保留换行
  echo $msg     # ❌ 换行变成空格（单词拆分）
  ```

- 在 `<<EOF` 中如果想**保留缩进**，可用 `<<-EOF` 并用 **Tab 缩进**（不能用空格）：
  ```bash
  cat <<-EOF
  	第一行（前面是Tab）
  	第二行
  EOF
  ```

---

##  推荐选择

| 场景                   | 推荐方式         |
| ---------------------- | ---------------- |
| 写大段 SQL / 配置      | `Here Document`  |
| 少量换行文本           | 双引号内直接换行 |
| 动态拼接带换行的字符串 | `printf` + `\n`  |
| 需要逐行处理           | 数组             |

