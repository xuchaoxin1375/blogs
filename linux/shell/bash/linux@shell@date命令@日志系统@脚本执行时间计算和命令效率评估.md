[toc]



## Linux date 命令详解

`date` 命令用于显示或设置系统日期和时间，是 Linux 中最常用的时间管理工具。

- [date(1) — Arch manual pages](https://man.archlinux.org/man/date.1.zh_CN)
  - [指定 `date` 输出格式](https://www.gnu.org/software/coreutils/manual/html_node/Date-format-specifiers.html)
  - [ 日历](https://www.gnu.org/software/coreutils/manual/html_node/Calendars.html)
  - [ 设置时间](https://www.gnu.org/software/coreutils/manual/html_node/Setting-the-time.html)
  - [`date` 选项](https://www.gnu.org/software/coreutils/manual/html_node/Options-for-date.html)
  - [`date` 示例](https://www.gnu.org/software/coreutils/manual/html_node/Examples-of-date.html)
- [date invocation (GNU Coreutils 9.9)](https://www.gnu.org/software/coreutils/manual/html_node/date-invocation.html)

---

## 基本用法

```bash
# 显示当前日期和时间
date

# 输出示例：Thu Jun 12 14:30:45 CST 2025
```

---



## 常用选项快速参考

```bash
date +%F          # 2025-06-12
date +%T          # 14:30:45
date +%s          # 时间戳
date -d yesterday # 昨天
date -d @时间戳   # 时间戳转换
```

## 选项总览

| 选项 | 长选项               | 说明                     |
| ---- | -------------------- | ------------------------ |
| `-d` | `--date=STRING`      | 显示指定字符串描述的时间 |
| `-f` | `--file=FILE`        | 从文件读取日期字符串     |
| `-r` | `--reference=FILE`   | 显示文件的最后修改时间   |
| `-s` | `--set=STRING`       | 设置系统时间             |
| `-u` | `--utc, --universal` | 使用 UTC 时间            |
| `-I` | `--iso-8601[=FMT]`   | ISO 8601 格式输出        |
| `-R` | `--rfc-email`        | RFC 5322 格式输出        |
|      | `--rfc-3339=FMT`     | RFC 3339 格式输出        |
|      | `--debug`            | 调试日期解析             |
|      | `--help`             | 显示帮助                 |
|      | `--version`          | 显示版本                 |

## 时间戳

在 Linux/Unix 系统中，使用 `date` 命令获取时间戳非常直接。根据你的需求，最常用的有以下几种形式：

### 1. 获取当前秒级时间戳 (Unix Timestamp)

这是最标准的写法，返回自 1970-01-01 00:00:00 UTC 以来的秒数。

```bash
date +%s
```

### 2. 获取毫秒/纳秒级时间戳

如果你需要更高精度（例如用于性能测试或唯一 ID 生成）：

#### **毫秒 (**Milliseconds**):**

`date` 命令原生没有 `%L`（毫秒），通常通过纳秒截取：

```bash
date +%s%3N
```

#### 纳秒 (Nanoseconds):

```bash
date +%s%N
```

------

### 3. 时间戳与可读时间的相互转换

在调试时，你经常需要在这两种格式之间“横跳”：

| **转换方向**                      | **命令示例 (以 Linux 为例)**        | **备注**           |
| --------------------------------- | ----------------------------------- | ------------------ |
| **时间戳 $\rightarrow$ 时间**     | `date -d @1735689600`               | 将秒数转回本地时间 |
| **指定时间 $\rightarrow$ 时间戳** | `date -d "2025-01-01 12:00:00" +%s` | 获取特定时刻的秒数 |

> **注意：** 如果你在 **macOS (BSD date)** 上运行，转换语法略有不同：
>
> - 时间戳转时间：`date -r 1735689600`
> - 指定时间转时间戳：`date -j -f "%Y-%m-%d %H:%M:%S" "2025-01-01 12:00:00" +%s`

------



## 详细说明与示例

### 1️⃣ `-d, --date=STRING` 解析日期字符串

- ' `-d datestr` ' 或长选项形式' `--date=datestr` '
- 显示 `datestr` 中指定的日期和时间，而不是当前日期和时间。`datestr` 可以是几乎任何常用格式。它可以包含月份名称、时区、' am '和' pm '、' yesterday '等。使用`now`表示当前时间(时:分:秒),这在基于当前时间计算偏移日期很有用
  - 例如， --date="2020-07-21 14:19:13.489392193 +0530" 指定了 2020 年 7 月 21 日下午 2:19:13 之后 489,392,193 纳秒的时刻，该时刻位于 UTC 以东 5 小时 30 分钟的时区。 datestr 必须采用与区域设置无关的格式。
  - 例如， 在许多地区，需要使用下面的“ LC_TIME=C ”来打印正确的日期：`date -d "$(LC_TIME=C date)" `请参阅[日期输入格式 ](https://www.gnu.org/software/coreutils/manual/html_node/Date-input-formats.html)。

**最常用的选项**，用于日期计算和转换。

```bash
# 相对时间表达
date -d "yesterday"              # 昨天
date -d "tomorrow"               # 明天
date -d "3 days ago"             # 3天前
date -d "2 weeks"                # 2周后
date -d "next Monday"            # 下周一
date -d "last Friday"            # 上周五

# 指定日期
date -d "2025-12-25"             # Thu Dec 25 12:00:00 AM CST 2025
date -d "Dec 25, 2025"           # 同上
date -d "25 Dec 2025"            # 同上

# 时间偏移
date -d "2025-06-12 +3 hours"    # 指定日期加3小时
date -d "now + 30 minutes"       # 当前时间加30分钟

# 时间戳转换
date -d "@1749714645"            # Unix时间戳转可读时间

# 组合使用
date -d "yesterday" +"%Y-%m-%d"  # 昨天的日期格式化输出
```

例如,计算两天后的这个时间点,并以`%F-%T`的格式打印计算结果

```bash
# cxxu@CxxuDesk 14:42:19> <~>
$ date +'%F-%T'
2026-01-06-14:42:46

# cxxu@CxxuDesk 14:42:46> <~>
$ date -d 'now +2 day' +'%F-%T'
2026-01-08-14:42:48
```

#### -d 支持的时间表达式(单词)

```bash
# 数字 + 单位(单词的单数或者复数都可被接收和理解,用`/`分隔)
second/seconds, minute/minutes, hour/hours
day/days, week/weeks, month/months, year/years

# 特殊词
now, today, yesterday, tomorrow
this, next, last
ago
```

---

### 2️⃣ `-f, --file=FILE` 从文件批量读取

```bash
# 创建日期列表文件
cat > dates.txt << EOF
2025-01-01
2025-06-12
yesterday
next Friday
EOF

# 批量转换
date -f dates.txt +"%A, %B %d, %Y"
```

**输出：**
```
Wednesday, January 01, 2025
Thursday, June 12, 2025
Wednesday, June 11, 2025
Friday, June 20, 2025
```

---

### 3️⃣ `-r, --reference=FILE` 显示文件修改时间

```bash
# 显示文件的最后修改时间
date -r /etc/passwd

# 格式化输出
date -r /var/log/syslog +"%F %T"

# 实际应用：检查文件年龄
file_time=$(date -r myfile.txt +%s)
now=$(date +%s)
age_days=$(( (now - file_time) / 86400 ))
echo "文件已存在 $age_days 天"
```

---

### 4️⃣ `-s, --set=STRING` 设置系统时间

```bash
# ⚠️ 需要 root 权限

# 设置完整日期时间
sudo date -s "2025-06-12 14:30:00"

# 只设置时间
sudo date -s "14:30:00"

# 只设置日期
sudo date -s "2025-06-12"

# 使用相对时间
sudo date -s "now + 1 hour"

# 同步到硬件时钟
sudo hwclock --systohc
```

---

### 5️⃣ `-u, --utc` UTC 时间

```bash
# 显示 UTC 时间
date -u
# 输出: Thu Jun 12 06:30:45 UTC 2025

# UTC 时间戳
date -u +%s

# 组合使用
date -u -d "yesterday" +"%F %T %Z"
# 输出: 2025-06-11 06:30:45 UTC
```

---

### 6️⃣ `-I, --iso-8601[=FMT]` ISO 8601 格式

```bash
# 仅日期（默认）
date -I
date -Idate
# 输出: 2025-06-12

# 精确到小时
date -Ihours
# 输出: 2025-06-12T14+08:00

# 精确到分钟
date -Iminutes
# 输出: 2025-06-12T14:30+08:00

# 精确到秒
date -Iseconds
# 输出: 2025-06-12T14:30:45+08:00

# 精确到纳秒
date -Ins
# 输出: 2025-06-12T14:30:45,123456789+08:00
```

---

### 7️⃣ `-R, --rfc-email` RFC 5322 邮件格式

```bash
date -R
# 输出: Thu, 12 Jun 2025 14:30:45 +0800

# 常用于邮件头 Date 字段
```

---

### 8️⃣ `--rfc-3339=FMT` RFC 3339 格式

```bash
# 仅日期
date --rfc-3339=date
# 输出: 2025-06-12

# 精确到秒
date --rfc-3339=seconds
# 输出: 2025-06-12 14:30:45+08:00

# 精确到纳秒
date --rfc-3339=ns
# 输出: 2025-06-12 14:30:45.123456789+08:00
```

---

### 9️⃣ `--debug` 调试日期解析

```bash
date --debug -d "next Friday + 2 weeks"
```

**输出：**
```
date: parsed day part: next Friday
date: parsed relative part: +2 weeks
date: input timezone: system default
date: ...
Fri Jun 27 14:30:45 CST 2025
```

---



## 常用格式化选项

```bash
date +FORMAT
```

| 格式符                                         | 含义                | 示例输出   |
| ---------------------------------------------- | ------------------- | ---------- |
| 日期(年,月,日),除年(`Y`),月和日(`m,d`)都是小写 |                     |            |
| `%Y`                                           | 四位年份            | 2025       |
| `%m`                                           | 月份 (01-12)        | 06         |
| `%d`                                           | 日期 (01-31)        | 12         |
| 一天内的时间(时,分,秒),都是大写字母            |                     |            |
| `%H`                                           | 小时 (00-23)        | 14         |
| `%M`                                           | 分钟 (00-59)        | 30         |
| `%S`                                           | 秒 (00-59)          | 45         |
| 常见格式的内置组合                             |                     |            |
| `%F`                                           | 完整日期 (%Y-%m-%d) | 2025-06-12 |
| `%T`                                           | 完整时间 (%H:%M:%S) | 14:30:45   |
| 日期相关的单词                                 |                     |            |
| `%A`                                           | 星期全称            | Thursday   |
| `%a`                                           | 星期缩写            | Thu        |
| `%B`                                           | 月份全称            | June       |
| 其他                                           |                     |            |
| `%s`                                           | Unix 时间戳         | 1749714645 |

---

### 常用组合

完整日期和时间组合("**年-月-日 时:分:秒**"):

- `date +"%F %T"`(空格分开日期和时间,由于存在空格,需要使用引号包裹`%F %T`)

- `date +%F-%T`(使用连字符`-`连接日期和时间)

- `date +%Y-%m-%d--%H-%M-%S`(自定义分隔符,例如2026-01-05--13-57-49)

  

## 实际应用场景

### 组合使用示例

```bash
# UTC 时间 + ISO 格式 + 指定日期
date -u -Iseconds -d "2025-12-31 23:59:59"
# 输出: 2025-12-31T15:59:59+00:00

# 文件修改时间 + 自定义格式
date -r /etc/hosts +"%Y年%m月%d日 %H:%M"

# 日期计算 + 格式化
date -d "2025-01-01 +100 days" +"%F 是第 %j 天"
# 输出: 2025-04-11 是第 101 天
```



### 📁 带时间戳的备份文件

```bash
# 创建备份
cp myfile.txt "myfile_$(date +%Y%m%d_%H%M%S).bak"

# 创建日志文件
echo "Log entry" >> "app_$(date +%F).log"
```

### 📊 脚本中记录时间

```bash
#!/bin/bash
echo "脚本开始时间: $(date '+%F %T')"
# ... 执行操作 ...
echo "脚本结束时间: $(date '+%F %T')"
```

### ⏱️ 计算脚本执行时间

```bash
start=$(date +%s)
# ... 执行操作 ...
sleep 5
end=$(date +%s)
echo "耗时: $((end - start)) 秒"
```

---

