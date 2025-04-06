[toc]



## Python时间和日期处理模块

Python提供了两个主要模块来处理时间和日期：`time`和`datetime`。 

## 一、time模块

`time`模块提供了与时间相关的基础功能，主要处理时间戳和结构化时间。

### 1. 常用函数

```python
import time

# 1. 获取当前时间戳（从1970-1-1 00:00:00 UTC开始的秒数）
timestamp = time.time()
print(timestamp)  # 例如：1634567890.123456

# 2. 将时间戳转换为本地时间的struct_time对象
local_time = time.localtime(timestamp)
print(local_time)
# 输出：time.struct_time(tm_year=2023, tm_mon=10, tm_mday=18, ...)

# 3. 将struct_time转换为时间戳
new_timestamp = time.mktime(local_time)

# 4. 线程休眠（秒）
time.sleep(2.5)  # 休眠2.5秒


```

#### 性能计时🎈

```python
import time
from random import random

start = time.perf_counter()  # 高精度计时器

# 执行一些操作
rt = random()
print(f"随机耗时设定：{rt}")
time.sleep(rt)
# 结束操作

end = time.perf_counter()
print(f"代码段总耗时：{end - start}秒")
```



### 2. 时间格式转换

```python
# 1. struct_time转字符串
time_str = time.strftime("%Y-%m-%d %H:%M:%S", local_time)
print(time_str)  # 例如："2023-10-18 15:30:00"

# 2. 字符串转struct_time
parsed_time = time.strptime("2023-10-18", "%Y-%m-%d")
print(parsed_time)
```

### 3. 常用格式符号

| 符号 | 含义          | 示例      |
| ---- | ------------- | --------- |
| %Y   | 四位年份      | 2023      |
| %m   | 月份（01-12） | 10        |
| %d   | 日期（01-31） | 18        |
| %H   | 24小时制小时  | 15        |
| %M   | 分钟（00-59） | 30        |
| %S   | 秒（00-59）   | 45        |
| %A   | 星期全名      | Wednesday |
| %a   | 星期缩写      | Wed       |
| %B   | 月份全名      | October   |
| %b   | 月份缩写      | Oct       |

## 二、datetime模块

`datetime`模块提供了更高级的日期和时间处理功能，包含几个主要类：

### 1. 主要类介绍

```python
from datetime import datetime, date, time as dt_time, timedelta, timezone

# 1. date类 - 处理日期（年、月、日）
today = date.today()
print(today)  # 例如：2023-10-18

# 2. time类 - 处理时间（时、分、秒、微秒）
current_time = dt_time(15, 30, 45)
print(current_time)  # 15:30:45

# 3. datetime类 - 处理日期和时间
now = datetime.now()
print(now)  # 例如：2023-10-18 15:30:45.123456

# 4. timedelta类 - 时间间隔
one_day = timedelta(days=1)
tomorrow = today + one_day
print(tomorrow)  # 2023-10-19

# 5. timezone类 - 时区处理
tz = timezone(timedelta(hours=8))  # UTC+8
now_with_tz = datetime.now(tz)
print(now_with_tz)  # 2023-10-18 15:30:45.123456+08:00
```

### 2. 常用操作

#### 创建datetime对象

```python
# 1. 当前时间
now = datetime.now()

# 2. 指定日期时间
dt = datetime(2023, 10, 18, 15, 30, 45)

# 3. 从时间戳创建
dt_from_timestamp = datetime.fromtimestamp(1634567890)

# 4. 从字符串解析
dt_from_str = datetime.strptime("2023-10-18 15:30", "%Y-%m-%d %H:%M")
```

#### 时间计算

```python
# 时间差计算
delta = datetime(2023, 12, 31) - datetime(2023, 10, 18)
print(delta.days)  # 74

# 时间加减
one_week = timedelta(weeks=1)
next_week = now + one_week
```

#### 格式化输出

```python
formatted = now.strftime("%Y年%m月%d日 %H时%M分")
print(formatted)  # "2023年10月18日 15时30分"
```

### 3. 时区处理

```python
from datetime import timezone, timedelta

# 创建带时区的时间
beijing_tz = timezone(timedelta(hours=8))
dt_with_tz = datetime.now(beijing_tz)

# 时区转换
utc_time = dt_with_tz.astimezone(timezone.utc)
print(utc_time)
```

## 三、time与datetime模块对比🎈

| 特性     | time模块                 | datetime模块                   |
| -------- | ------------------------ | ------------------------------ |
| 主要功能 | 时间戳操作、基本时间转换 | 高级日期时间处理、时间运算     |
| 精度     | 秒级（部分函数支持微秒） | 微秒级                         |
| 时区支持 | 有限支持                 | 完整支持                       |
| 适用场景 | 简单时间操作、性能计时   | 复杂日期时间计算、业务逻辑处理 |
| 面向对象 | 函数式                   | 面向对象                       |

## 四、实用示例

### 1. 计算程序运行时间

```python
import time
from datetime import datetime

# 方法1：使用time模块
start_time = time.time()
# 执行代码
end_time = time.time()
print(f"耗时：{end_time - start_time:.2f}秒")

# 方法2：使用datetime模块
start_dt = datetime.now()
# 执行代码
end_dt = datetime.now()
print(f"耗时：{(end_dt - start_dt).total_seconds():.2f}秒")
```

### 2. 生成时间范围序列

```python
from datetime import datetime, timedelta

def date_range(start_date, end_date):
    current = start_date
    while current <= end_date:
        yield current
        current += timedelta(days=1)

start = datetime(2023, 1, 1)
end = datetime(2023, 1, 10)
for day in date_range(start, end):
    print(day.strftime("%Y-%m-%d"))
```

### 3. 工作日计算

```python
from datetime import date, timedelta

def get_next_workday(start_date, days=1):
    current = start_date
    while days > 0:
        current += timedelta(days=1)
        if current.weekday() < 5:  # 0-4是周一到周五
            days -= 1
    return current

today = date.today()
next_workday = get_next_workday(today)
print(f"下一个工作日是：{next_workday}")
```

掌握这两个模块的使用，可以满足Python中绝大多数时间处理需求。对于更复杂的时区处理，可以考虑使用`pytz`库（Python 3.9+推荐使用zoneinfo模块）。