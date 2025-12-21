[toc]



## 1. 基础日志记录

### 1.1 最简单的日志记录

就像是调用带有预置格式的print()语句

```python
import logging

# 基本日志记录
logging.warning('这是一个警告信息')
logging.error('这是一个错误信息')

# 输出:
# WARNING:root:这是一个警告信息
# ERROR:root:这是一个错误信息
```

### 1.2 日志级别🎈

Python logging 有5个标准级别(数值表示重要/严重程度)：

| 级别     | 数值 | 描述                                   |
| -------- | ---- | -------------------------------------- |
| DEBUG    | 10   | 详细信息，通常用于调试                 |
| INFO     | 20   | 确认事情按预期工作                     |
| WARNING  | 30   | 表明发生了意外情况，但软件仍在工作     |
| ERROR    | 40   | 由于更严重的问题，软件无法执行某些功能 |
| CRITICAL | 50   | 严重错误，程序本身可能无法继续运行     |

logging模块中的相关源码

```python
#---------------------------------------------------------------------------
#   Level related stuff
#---------------------------------------------------------------------------
#
# Default levels and level names, these can be replaced with any positive set
# of values having corresponding names. There is a pseudo-level, NOTSET, which
# is only really there as a lower limit for user-defined levels. Handlers and
# loggers are initialized with NOTSET so that they will log all messages, even
# at user-defined levels.
#

CRITICAL = 50
FATAL = CRITICAL
ERROR = 40
WARNING = 30
WARN = WARNING
INFO = 20
DEBUG = 10
NOTSET = 0
```

默认的级别是 `WARNING`，意味着只会追踪该严重程度及以上的事件，除非 logging 包另有其他配置。

- 其中`DEBUG`是我们调试程序的时候使用,是最详细的信息输出级别
- 而`CRITICAL`是在有严重错误的时候才显示的信息级别(比如程序崩溃),最简洁的输出模式,甚至ERROR的信息都不会显示

所追踪事件可以以不同形式处理。最简单的方式是输出到**控制台**。另一种常用的方式是写入**磁盘文件**。

```python
import logging

logging.basicConfig(level=logging.DEBUG)  # 设置日志级别

logging.debug('调试信息')
logging.info('普通信息')
logging.warning('警告信息')
logging.error('错误信息')
logging.critical('严重错误')
```

## 2. 日志配置

### 2.1 基本配置|日志格式|文件文件输出

logging模块不宜在同一个上下文下多次更改配置,如果要运行/测试新的logging配置,请另起一个新的python解释器环境

```python
import logging

logging.basicConfig(
    filename='log.log',          # 日志文件名
    filemode='a',               # 写入模式：'a'追加，'w'覆盖
    level=logging.INFO,         # 记录级别
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

logging.info('这是一条信息日志')
```

### 2.2 日志格式参数🎈

常用格式参数：

- `%(asctime)s`: 日志创建时间
- `%(levelname)s`: 日志级别
- `%(message)s`: 日志消息
- `%(name)s`: 记录器名称
- `%(filename)s`: 文件名
- `%(funcName)s`: 函数名
- `%(module)s`:模块名
- `%(lineno)d`: 行号

## 3. 高级用法

### 3.1 使用记录器(Logger)

```python
import logging

# 创建记录器
logger = logging.getLogger('my_app')
logger.setLevel(logging.DEBUG)

# 创建控制台处理器
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

# 创建文件处理器
fh = logging.FileHandler('app.log')
fh.setLevel(logging.ERROR)

# 创建日志格式
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
ch.setFormatter(formatter)
fh.setFormatter(formatter)

# 添加处理器到记录器
logger.addHandler(ch)
logger.addHandler(fh)

# 使用记录器
logger.debug('调试信息')
logger.info('普通信息')
logger.warning('警告信息')
logger.error('错误信息')
logger.critical('严重错误')
```

### 3.2 日志文件轮转

```python
from logging.handlers import RotatingFileHandler

logger = logging.getLogger('rotating_log')
logger.setLevel(logging.INFO)

# 每个日志文件最大1MB，最多保留3个备份
handler = RotatingFileHandler(
    'app.log', maxBytes=1024*1024, backupCount=3
)
handler.setFormatter(logging.Formatter('%(asctime)s - %(message)s'))
logger.addHandler(handler)

for i in range(10000):
    logger.info(f'这是第 {i} 条日志')
```

### 3.3 定时轮转日志

```python
from logging.handlers import TimedRotatingFileHandler

logger = logging.getLogger('timed_rotating_log')
logger.setLevel(logging.INFO)

# 每天午夜轮转日志，保留7天备份
handler = TimedRotatingFileHandler(
    'app.log', when='midnight', interval=1, backupCount=7
)
handler.setFormatter(logging.Formatter('%(asctime)s - %(message)s'))
logger.addHandler(handler)

logger.info('这条日志会根据时间轮转')
```

## 4. 最佳实践

### 4.1 在模块中使用日志

```python
# mymodule.py
import logging

logger = logging.getLogger(__name__)  # 使用模块名作为记录器名称

def do_something():
    logger.info('正在做一些事情')
    try:
        1 / 0
    except ZeroDivisionError:
        logger.error('发生了除以零错误', exc_info=True)
```

### 4.2 配置日志的推荐方式

```python
import logging
import logging.config

LOGGING_CONFIG = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(levelname)s] %(name)s: %(message)s'
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'standard',
            'level': 'INFO',
            'stream': 'ext://sys.stdout'
        },
        'file': {
            'class': 'logging.FileHandler',
            'formatter': 'standard',
            'level': 'DEBUG',
            'filename': 'app_debug.log'
        },
    },
    'loggers': {
        '': {  # root logger
            'handlers': ['console', 'file'],
            'level': 'DEBUG',
            'propagate': False
        },
        'my_app': {
            'handlers': ['console', 'file'],
            'level': 'DEBUG',
            'propagate': False
        },
    }
}

logging.config.dictConfig(LOGGING_CONFIG)
logger = logging.getLogger('my_app')
```

### 4.3 在生产环境中的日志建议

1. 使用 JSON 或 YAML 文件配置日志
2. 为不同环境（开发、测试、生产）设置不同的日志级别
3. 记录足够的上下文信息
4. 避免记录敏感信息
5. 使用结构化日志（如 JSON 格式）便于日志分析

## 5. 常见问题

### 5.1 为什么我的日志没有显示？

- 检查日志级别设置
- 确保没有禁用日志记录器
- 检查是否有处理器(handler)添加到记录器

### 5.2 如何捕获异常堆栈？

```python
try:
    1 / 0
except ZeroDivisionError:
    logging.error("发生了错误", exc_info=True)
    # 或者简写
    logging.exception("发生了错误")
```

### 5.3 如何临时禁用日志？

```python
logging.disable(logging.CRITICAL)  # 禁用所有低于CRITICAL级别的日志
# 恢复日志
logging.disable(logging.NOTSET)
```

通过本教程，你应该能够掌握 Python logging 模块的基本和高级用法，为你的应用程序添加专业的日志记录功能。

## 案例

- ```python
  import logging
  
  # 配置日志记录器
  logging.basicConfig(filename='example.log', level=logging.DEBUG,
                      format='%(asctime)s %(levelname)s: %(message)s')
  
  def add(a, b):
      """
      Returns the sum of two numbers.
      """
      logging.debug("Adding %s and %s", a, b)
      result = a + b
      logging.debug("Result: %s", result)
      return result
  
  def multiply(a, b):
      """
      Returns the product of two numbers.
      """
      logging.debug("Multiplying %s and %s", a, b)
      result = a * b
      logging.debug("Result: %s", result)
      return result
  
  # 使用函数记录日志
  x = 2
  y = 3
  logging.info("Starting calculation with %s and %s", x, y)
  result1 = add(x, y)
  result2 = multiply(x, y)
  logging.info("Calculation finished: %s %s", result1, result2)
  ```

- 在这个例子中，我们首先使用`basicConfig`函数配置了一个日志记录器，将日志记录到文件`example.log`中，设置日志级别为`DEBUG`，并指定了日志记录的格式。

- 然后，定义了两个函数`add`和`multiply`，这些函数在执行时会记录一些调试信息。最后，我们在主程序中调用这些函数，并使用`info`级别记录了一条日志，指示程序已经开始计算。

- 同时，在当前工作目录下也会生成一个名为`example.log`的日志文件，其中包含所有的日志记录：

  ```
  2023-04-11 11:28:49,675 INFO: Starting calculation with 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Adding 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Result: 5
  2023-04-11 11:28:49,675 DEBUG: Multiplying 2 and 3
  2023-04-11 11:28:49,675 DEBUG: Result: 6
  2023-04-11 11:28:49,675 INFO: Calculation finished: 5 6
  
  ```

  这个例子演示了如何使用`logging`模块记录日志，以及如何配置日志记录器和指定日志级别。

