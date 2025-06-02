 

- 多个模块使用 `logging`；
- 模块之间共享和继承 logger 配置；
- 使用不同的 handler（控制台、文件）；
- 设置不同 level；
- 使用 filter 和 formatter；
- 展示 propagate 机制；
- 支持集中配置与模块化使用。

---

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

 