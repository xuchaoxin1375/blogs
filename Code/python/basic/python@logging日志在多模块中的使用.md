 [toc]

## abstract

python的logging模块被设计为可多层传递的日志记录的,如果某些模块(或库)中使用了logging模块来生成日志,那么调用这些模块的应用程序(主程序)中通常(默认)情况下会接收到模块中传递来的日志记录

这些日志在模块中可能没有详细或具体的配置,那么调用者如果能够接受到模块传递来的日志记录,则会继承调用程序中的日志配置,比如日志消息的输出格式控制,可由调用者中的日志配置(调用者中的日志记录器成为父级记录器,而被调用模块中的日志记录器为子级)



```python
"""测试跨模块调用的日志行为"""

# myapp.py
import logging

import mylib  # 导入其他使用logging的模块中的函数

logger = logging.getLogger(__name__)


def main():
    """模拟跨模块调用的日志行为函数"""
    logging.basicConfig(
        filename="myapp.log",
        format="%(asctime)s- %(name)s -%(levelname)s:%(message)s",
        filemode="w",
        level=logging.INFO,
    )
    logger.info("Started")
    mylib.do_something()
    logger.info("Finished")


if __name__ == "__main__":
    main()
    print("日志已记录到 myapp.log")

```

myapp.py中main函数中配置了`logging.basicConfig()`,配置的是根记录器

而`myapp.py`头部的模块级日志记录器也是作为根记录器的子级,在不设置专门的日志配置时,将沿用根记录器的配置

而使用了logging的模块`mylib.py`内容如下

> 这里我们仅在此模块中创建了模块级的logger,但是不做额外的配置,比如日志的输出格式和日志级别
>
> 当其他python代码调用此模块,并且调用了和logger相关的代码,比如`do_something()`,则logger.info()消息会传递到父级
>
> 本例中消息传递到调用者myapp.py中,消息传递完成后,调用者myapp.py中配置了日志,传递进来的消息也继承此配置使用日志信息

```python
# mylib.py
import logging

logger = logging.getLogger(__name__)


def do_something():
    """模拟跨模块调用的日志行为函数(被调用函数)"""
    logger.info("Doing something")

```

说明:在`myapp.py`中配置了日志记录器的基本行为,比如日志输出格式被指定为`%(asctime)s- %(name)s -%(levelname)s:%(message)s`;现在调用mylib中的`do_something`函数,检查日志文件`myapp.log`可以看到,调用模块mylib中的`do_something`函数,其中的日志语句采用的格式将继承调用者的格式

这种继承的方式可以让模块间使用logging模块更加简单,减少不必要的日志组件的配置,比如handler和formatter,继承相同的日志配置,可以让主调代码和模块中的日志输出更整齐

上述代码运行的一个结果

```bash
2025-06-03 20:07:21,029-__main__ -INFO:Started
2025-06-03 20:07:21,029-mylib -INFO:Doing something
2025-06-03 20:07:21,029-__main__ -INFO:Finished

```

## 案例1(main_aux.py)

设`myliblog`包下有一个`auxiliary.py`模块

```python
"""
# auxiliary.py
This module contains the Auxiliary class and  module function that logs messages."""

import logging

# 创建日志记录器
# module_logger = logging.getLogger("myliblog.auxiliary")
module_logger = logging.getLogger(__name__)


class Auxiliary:
    """This is a class that does something."""

    def __init__(self):
        # self.logger = logging.getLogger("myliblog.auxiliary.Auxiliary")
        # self.logger = logging.getLogger(__name__+".Auxiliary")
        self.logger = module_logger.getChild("Auxiliary")
        self.logger.debug(
            "Auxiliary instance created with logger: %s", self.logger.name
        )
        self.logger.info("creating an instance of Auxiliary")

    def do_something(self):
        """This method does something and logs the process."""
        a = 1 + 1
        self.logger.info("doing something:1+1=%s", a)
        # self.logger.info("done doing something")
        self.logger.warning("this is a warning from Auxiliary")
        self.logger.error("an error demo in Auxiliary")


def some_function():
    """This function does something and logs the process."""
    module_logger.debug("some_function is running")
    module_logger.info('received a call to "some_function"')
    module_logger.warning("this is a warning from some_function")
    module_logger.error("an error demo in some_function")

```

模块的调用者代码`main_aux.py`

```python
"""测试跨模块日志"""

import logging
import myliblog.auxiliary as auxiliary_module

# 创建 本脚本的 日志记录器(分别试验三种方案)
# 1.取名为严格的模块名,从而作为父级日志记录器接受子模块的日志记录
# logger = logging.getLogger("myliblog")
# 2.对于库/模块是合适的,但是主调代码中使用相当于'__main__'的名称的记录器
# logger=logging.getLogger(__name__)
# 3.根日志器,接受可能的任何日志记录
logger = logging.getLogger()

logger.setLevel(logging.DEBUG)
# 创建可记录调试消息的文件处理器(将文件保存到spam.log中)
fh = logging.FileHandler("spam.log", mode="w", encoding="utf-8")
fh.setLevel(logging.DEBUG)
# 创建具有更高日志层级的控制台处理器🎈
ch = logging.StreamHandler()
ch.setLevel(logging.ERROR)

# 创建格式化器并将其添加到处理器
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
fh.setFormatter(formatter)
ch.setFormatter(formatter)
# 将处理器添加到日志记录器
logger.addHandler(fh)
logger.addHandler(ch)

# 模块中的Auxiliary类的日志记录
logger.info("creating an instance of auxiliary_module.Auxiliary")
a = auxiliary_module.Auxiliary()
logger.info("created an instance of auxiliary_module.Auxiliary")


logger.info("calling auxiliary_module.Auxiliary.do_something")
a.do_something()
logger.info("finished auxiliary_module.Auxiliary.do_something")

# 模块级的函数的日志记录
logger.info("calling auxiliary_module.some_function()")
auxiliary_module.some_function()
logger.info("done with auxiliary_module.some_function()")

```

运行代码,并查看保存的日志(为了便于阅读,我手动插入几个空白行)

```bash
2025-06-03 20:59:23,170 - root - INFO - creating an instance of auxiliary_module.Auxiliary
2025-06-03 20:59:23,170 - myliblog.auxiliary.Auxiliary - DEBUG - Auxiliary instance created with logger: myliblog.auxiliary.Auxiliary
2025-06-03 20:59:23,170 - myliblog.auxiliary.Auxiliary - INFO - creating an instance of Auxiliary
2025-06-03 20:59:23,170 - root - INFO - created an instance of auxiliary_module.Auxiliary


2025-06-03 20:59:23,170 - root - INFO - calling auxiliary_module.Auxiliary.do_something
2025-06-03 20:59:23,170 - myliblog.auxiliary.Auxiliary - INFO - doing something:1+1=2
2025-06-03 20:59:23,170 - myliblog.auxiliary.Auxiliary - WARNING - this is a warning from Auxiliary
2025-06-03 20:59:23,171 - myliblog.auxiliary.Auxiliary - ERROR - an error demo in Auxiliary
2025-06-03 20:59:23,171 - root - INFO - finished auxiliary_module.Auxiliary.do_something


2025-06-03 20:59:23,171 - root - INFO - calling auxiliary_module.some_function()
2025-06-03 20:59:23,171 - myliblog.auxiliary - DEBUG - some_function is running
2025-06-03 20:59:23,171 - myliblog.auxiliary - INFO - received a call to "some_function"
2025-06-03 20:59:23,171 - myliblog.auxiliary - WARNING - this is a warning from some_function
2025-06-03 20:59:23,171 - myliblog.auxiliary - ERROR - an error demo in some_function
2025-06-03 20:59:23,171 - root - INFO - done with auxiliary_module.some_function()

```

此外,如果修改`main_aux.py`中的`logger`初始化代码,使用方案2(`logger=logging.getLogger(__name__)`),那么日志文件中的结果形如

```bash
2025-06-03 21:12:40,204 - __main__ - INFO - creating an instance of auxiliary_module.Auxiliary
2025-06-03 21:12:40,204 - __main__ - INFO - created an instance of auxiliary_module.Auxiliary
2025-06-03 21:12:40,204 - __main__ - INFO - calling auxiliary_module.Auxiliary.do_something
2025-06-03 21:12:40,204 - __main__ - INFO - finished auxiliary_module.Auxiliary.do_something
2025-06-03 21:12:40,204 - __main__ - INFO - calling auxiliary_module.some_function()
2025-06-03 21:12:40,204 - __main__ - INFO - done with auxiliary_module.some_function()

```

### logger对象的名字层级关系的体现



模块auxiliary.py中被调用的logging日志相关的语句没有被调用者所利用和输出

而如果将main_aux.py中的`logger`初始化为包名(`myliblog`),则又可以看到`auxiliary.py`中的日志信息又在被调用者的运行中输出

```bash
2025-06-03 21:16:54,818 - myliblog - INFO - creating an instance of auxiliary_module.Auxiliary
2025-06-03 21:16:54,818 - myliblog.auxiliary.Auxiliary - DEBUG - Auxiliary instance created with logger: myliblog.auxiliary.Auxiliary
2025-06-03 21:16:54,818 - myliblog.auxiliary.Auxiliary - INFO - creating an instance of Auxiliary
2025-06-03 21:16:54,818 - myliblog - INFO - created an instance of auxiliary_module.Auxiliary
2025-06-03 21:16:54,818 - myliblog - INFO - calling auxiliary_module.Auxiliary.do_something
2025-06-03 21:16:54,818 - myliblog.auxiliary.Auxiliary - INFO - doing something:1+1=2
2025-06-03 21:16:54,818 - myliblog.auxiliary.Auxiliary - WARNING - this is a warning from Auxiliary
2025-06-03 21:16:54,818 - myliblog.auxiliary.Auxiliary - ERROR - an error demo in Auxiliary
2025-06-03 21:16:54,818 - myliblog - INFO - finished auxiliary_module.Auxiliary.do_something
2025-06-03 21:16:54,818 - myliblog - INFO - calling auxiliary_module.some_function()
2025-06-03 21:16:54,819 - myliblog.auxiliary - DEBUG - some_function is running
2025-06-03 21:16:54,819 - myliblog.auxiliary - INFO - received a call to "some_function"
2025-06-03 21:16:54,819 - myliblog.auxiliary - WARNING - this is a warning from some_function
2025-06-03 21:16:54,819 - myliblog.auxiliary - ERROR - an error demo in some_function
2025-06-03 21:16:54,819 - myliblog - INFO - done with auxiliary_module.some_function()

```

如果将一个程序的名字作为主程序的日志器的名称,这种做法是合适的,相比于使用根记录器,会更加灵活,便于和其他模块配合进一步集成

---

## 案例2(main_cu.py)

```python
"""多模块日志示例"""

import logging

# 测试日志行为的模块myliblog
from myliblog import auxiliary, core, utils

LOG_FILE = "main_cu.log"
# 配置pythonpath环境变量(将myliblog目录添加到PYTHONPATH环境变量中)后可以直接导入模块
# import auxiliary
# import core
# import utils


def setup_logging(level=logging.DEBUG):
    """设置日志级别"""

    # 创建不同名称的日志记录器查看效果上差异

    # 1.普通的日志记录器名:myapp
    # lgr = logging.getLogger("myapp")
    # 或
    lgr = logging.getLogger(__name__)

    # 2.引用自模块myliblog的日志记录器名:myliblog
    # lgr = logging.getLogger("myliblog")

    # 3.根日志记录器名:root
    lgr = logging.getLogger()

    # 设置日志级别
    lgr.setLevel(logging.DEBUG)

    # 创建两个 handler：控制台 + 文件
    # 控制台的日志级别为 INFO
    console_handler = logging.StreamHandler()
    console_handler.setLevel(level=level)

    # 文件的日志级别为 DEBUG
    file_handler = logging.FileHandler(LOG_FILE, mode="w", encoding="utf-8")
    file_handler.setLevel(logging.DEBUG)

    # 定义格式器
    formatter = logging.Formatter(
        fmt="%(asctime)s - %(name)s -[main_cu fmt:%(funcName)s - %(lineno)d]- %(levelname)s - %(message)s"
    )
    console_handler.setFormatter(formatter)
    file_handler.setFormatter(formatter)

    # 添加 handler 到根 logger
    lgr.addHandler(console_handler)
    lgr.addHandler(file_handler)

    # 可选：关闭 propagate，防止重复输出
    lgr.propagate = False
    return lgr


if __name__ == "__main__":
    logger = setup_logging()

    # 获取子模块的 logger
    logger_core = logging.getLogger("myliblog.core")
    logger_utils = logging.getLogger("myliblog.utils")
    logger_auxiliary = logging.getLogger("myliblog.auxiliary")

    # 获取被调用模块的logger对象后,可以通过该对象设置模块代码中的日志行为,比如级别
    logger_core.setLevel(logging.ERROR)  # 设置 core 模块的日志级别为 ERROR
    logger_utils.setLevel(logging.INFO)
    logger_auxiliary.setLevel(logging.WARNING)

    logger.debug("This is a debug message!")
    logger.info("This is an info message!")

    logger.info("(1) Running Module core")
    core.do_core()  # 输出 ERROR 日志
    logger.info("(2) Running Module utils")
    utils.helper()  # 输出 Info 日志
    logger.info("(3) Running Module auxiliary")
    auxiliary.some_function()  # 输出 Warning 日志

```

为`main_cu.py`中的logger取名为`myapp`

```bash
PS>  python main_cu.py
myliblog package initialized
2025-06-14 21:06:01,042 - myapp -[main_cu fmt:<module> - 69]- DEBUG - This is a debug message!
2025-06-14 21:06:01,042 - myapp -[main_cu fmt:<module> - 70]- INFO - This is an info message!
2025-06-14 21:06:01,042 - myapp -[main_cu fmt:<module> - 72]- INFO - (1) Running Module core
2025-06-14 21:06:01,043 - ERROR - [core fmt:myliblog.core -do_core - 27] - An error demo in core module    
2025-06-14 21:06:01,043 - myapp -[main_cu fmt:<module> - 74]- INFO - (2) Running Module utils
2025-06-14 21:06:01,043 - INFO - [utils fmt:myliblog.utils -helper - 16] - Some useful info from utils     
2025-06-14 21:06:01,043 - WARNING - [utils fmt:myliblog.utils -helper - 17] - This is a warning from utils 
2025-06-14 21:06:01,043 - ERROR - [utils fmt:myliblog.utils -helper - 18] - An error demo occurred in utils
2025-06-14 21:06:01,043 - myapp -[main_cu fmt:<module> - 76]- INFO - (3) Running Module auxiliary
```

为`main_cu.py`中的logger取名为`myliblog`

```powershell

#⚡️[Administrator@CXXUDESK][C:\repos\scripts\wp\woocommerce\woo_df\archives\ipynbs\logging][21:06:09][UP:27.37Days]
PS>  python main_cu.py
myliblog package initialized
2025-06-14 21:06:09,218 - myliblog -[main_cu fmt:<module> - 69]- DEBUG - This is a debug message!        
2025-06-14 21:06:09,219 - myliblog -[main_cu fmt:<module> - 70]- INFO - This is an info message!
2025-06-14 21:06:09,219 - myliblog -[main_cu fmt:<module> - 72]- INFO - (1) Running Module core
2025-06-14 21:06:09,219 - ERROR - [core fmt:myliblog.core -do_core - 27] - An error demo in core module  
2025-06-14 21:06:09,219 - myliblog.core -[main_cu fmt:do_core - 27]- ERROR - An error demo in core module
2025-06-14 21:06:09,219 - myliblog -[main_cu fmt:<module> - 74]- INFO - (2) Running Module utils
2025-06-14 21:06:09,219 - INFO - [utils fmt:myliblog.utils -helper - 16] - Some useful info from utils   
2025-06-14 21:06:09,219 - myliblog.utils -[main_cu fmt:helper - 16]- INFO - Some useful info from utils  
2025-06-14 21:06:09,219 - WARNING - [utils fmt:myliblog.utils -helper - 17] - This is a warning from utils
2025-06-14 21:06:09,219 - myliblog.utils -[main_cu fmt:helper - 17]- WARNING - This is a warning from utils
2025-06-14 21:06:09,220 - ERROR - [utils fmt:myliblog.utils -helper - 18] - An error demo occurred in utils
2025-06-14 21:06:09,220 - myliblog.utils -[main_cu fmt:helper - 18]- ERROR - An error demo occurred in utils
2025-06-14 21:06:09,220 - myliblog -[main_cu fmt:<module> - 76]- INFO - (3) Running Module auxiliary
2025-06-14 21:06:09,220 - myliblog.auxiliary -[main_cu fmt:some_function - 33]- DEBUG - some_function is running
2025-06-14 21:06:09,220 - myliblog.auxiliary -[main_cu fmt:some_function - 34]- INFO - received a call to "some_function"
2025-06-14 21:06:09,220 - myliblog.auxiliary -[main_cu fmt:some_function - 35]- WARNING - this is a warning from some_function
2025-06-14 21:06:09,220 - myliblog.auxiliary -[main_cu fmt:some_function - 36]- ERROR - an error demo in some_function
```

为`main_cu.py`中的logger取名为`root`(默认名字)

```bash
PS>  python main_cu.py
myliblog package initialized
2025-06-14 21:09:14,134 - root -[main_cu fmt:<module> - 72]- DEBUG - This is a debug message!
2025-06-14 21:09:14,134 - root -[main_cu fmt:<module> - 73]- INFO - This is an info message!
2025-06-14 21:09:14,134 - root -[main_cu fmt:<module> - 75]- INFO - (1) Running Module core
2025-06-14 21:09:14,135 - ERROR - [core fmt:myliblog.core -do_core - 27] - An error demo in core module  
2025-06-14 21:09:14,135 - myliblog.core -[main_cu fmt:do_core - 27]- ERROR - An error demo in core module
2025-06-14 21:09:14,135 - root -[main_cu fmt:<module> - 77]- INFO - (2) Running Module utils
2025-06-14 21:09:14,135 - INFO - [utils fmt:myliblog.utils -helper - 16] - Some useful info from utils   
2025-06-14 21:09:14,135 - myliblog.utils -[main_cu fmt:helper - 16]- INFO - Some useful info from utils  
2025-06-14 21:09:14,135 - WARNING - [utils fmt:myliblog.utils -helper - 17] - This is a warning from utils
2025-06-14 21:09:14,135 - myliblog.utils -[main_cu fmt:helper - 17]- WARNING - This is a warning from utils
2025-06-14 21:09:14,135 - ERROR - [utils fmt:myliblog.utils -helper - 18] - An error demo occurred in utils
2025-06-14 21:09:14,135 - myliblog.utils -[main_cu fmt:helper - 18]- ERROR - An error demo occurred in utils
2025-06-14 21:09:14,135 - root -[main_cu fmt:<module> - 79]- INFO - (3) Running Module auxiliary
2025-06-14 21:09:14,136 - myliblog.auxiliary -[main_cu fmt:some_function - 33]- DEBUG - some_function is running
2025-06-14 21:09:14,136 - myliblog.auxiliary -[main_cu fmt:some_function - 34]- INFO - received a call to "some_function"
2025-06-14 21:09:14,136 - myliblog.auxiliary -[main_cu fmt:some_function - 35]- WARNING - this is a warning from some_function
2025-06-14 21:09:14,136 - myliblog.auxiliary -[main_cu fmt:some_function - 36]- ERROR - an error demo in some_function
```

## 小结

如果当前脚本(模块调用者,比如`main_cu.py`,`main_aux.py`)中的logger名字是被调用模块(比如`myliblog`库下的`myliblog.core,utils,auxiliary`)的父级(或者更高级,比如顶级)则当前模块可以接收到这些外部模块的日志,从而对这些日志进行处理,但是否输出这些外部模块的日志,取决于当前调用者的代码如何控制

外部模块的默认行为可以在调用者代码中更改,但是如果当前调用者的logger名字和被调用模块没有层级关系,则意味着被调用模块的日志无法传递到当前调用者的程序中,也无法有效地进一步处理

## 🧩 场景描述

我们构建一个简单的 Python 项目结构如下：

```
myapp/
├── __init__.py
├── main.py
├── module_a/
│   ├── __init__.py
│   └── core.py
└── module_b/
    ├── __init__.py
    └── service.py
```

我们要实现：
- 所有模块都使用统一的日志配置；
- `module_a.core` 和 `module_b.service` 中记录日志；
- 主模块 `main.py` 负责配置全局日志；
- 日志输出到 **控制台** 和 **文件**；
- 不同模块设置不同的日志级别；
- 控制是否传播日志事件。

---

## ✅ 典型代码示例

### **1. main.py**

```python
import logging
from module_a import core
from module_b import service

def setup_logging():
    # 创建一个顶级 logger
    logger = logging.getLogger('myapp')
    logger.setLevel(logging.DEBUG)  # 根 logger 级别为 DEBUG

    # 创建两个 handler：控制台 + 文件
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)

    file_handler = logging.FileHandler('app.log')
    file_handler.setLevel(logging.DEBUG)

    # 定义格式器
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    console_handler.setFormatter(formatter)
    file_handler.setFormatter(formatter)

    # 添加 handler 到根 logger
    logger.addHandler(console_handler)
    logger.addHandler(file_handler)

    # 可选：关闭 propagate，防止重复输出
    logger.propagate = False

if __name__ == "__main__":
    setup_logging()

    # 获取子模块的 logger
    logger_a = logging.getLogger('myapp.module_a')
    logger_b = logging.getLogger('myapp.module_b')

    # 单独设置 module_b 的日志级别为 WARNING
    logger_b.setLevel(logging.WARNING)

    print("=== Running Module A ===")
    core.run()  # 输出 INFO 日志

    print("\n=== Running Module B ===")
    service.process()  # 输出 WARNING/ERROR 日志
```

---

### **2. module_a/core.py**

```python
import logging

logger = logging.getLogger('myapp.module_a.core')

def run():
    logger.debug("This is a debug message in module_a.core")  # 会被写入文件，因为 DEBUG >= myapp.level
    logger.info("This is an info message in module_a.core")   # 会被控制台和文件记录
```

---

### **3. module_b/service.py**

```python
import logging

logger = logging.getLogger('myapp.module_b.service')

def process():
    logger.info("This is an info message in module_b.service")     # 不会被记录（被限制在 WARNING）
    logger.warning("This is a warning message in module_b.service")# 会被记录
    logger.error("This is an error message in module_b.service")   # 会被记录
```

---

## 📄 日志输出说明

### 控制台输出（console）：

```
=== Running Module A ===
2025-04-05 12:00:00,000 - myapp.module_a.core - INFO - This is an info message in module_a.core

=== Running Module B ===
2025-04-05 12:00:01,000 - myapp.module_b.service - WARNING - This is a warning message in module_b.service
2025-04-05 12:00:01,001 - myapp.module_b.service - ERROR - This is an error message in module_b.service
```

### 文件输出（app.log）：

```
2025-04-05 12:00:00,000 - myapp.module_a.core - DEBUG - This is a debug message in module_a.core
2025-05-05 12:00:00,000 - myapp.module_a.core - INFO - This is an info message in module_a.core
2025-04-05 12:00:01,000 - myapp.module_b.service - WARNING - This is a warning message in module_b.service
2025-04-05 12:00:01,001 - myapp.module_b.service - ERROR - This is an error message in module_b.service
```

---

## 🔍 特性解析

| 功能                 | 实现方式                                                |
| -------------------- | ------------------------------------------------------- |
| 跨模块使用           | 所有模块使用以 `myapp` 为前缀的 logger 名称             |
| 统一配置             | 在 `main.py` 中配置 root logger，所有子 logger 自动继承 |
| 不同模块设置不同级别 | 对 `myapp.module_b` 设置单独 level                      |
| Handler 分配         | 控制台只显示 INFO 及以上；文件记录 DEBUG 及以上         |
| Formatter            | 统一日志格式                                            |
| Propagate 控制       | 关闭根 logger 的 propagate，避免重复输出                |

---

## 💡 小贴士

- 如果你希望每个模块都有独立的 handler（比如 module_b 写入另一个日志文件），可以在模块初始化时添加自己的 handler。
- 建议不要频繁修改 `propagate`，除非你知道后果。
- 更复杂的项目可以用 `dictConfig` 或 `fileConfig` 来集中管理日志配置。

---

## 🧠 总结

这个案例展示了如何在多模块项目中使用 Python 的 `logging` 模块进行**统一而灵活的日志管理**。通过层级命名、level 控制、handler 分配等特性，你可以轻松实现以下目标：

- 统一的日志风格；
- 精细的输出控制；
- 各模块按需记录；
- 支持调试和生产环境切换；
- 避免日志冗余或丢失。

 