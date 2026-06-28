[toc]



Python 的 `logging` 模块是开发者用于记录程序运行状态、调试代码和监控错误的标准工具。虽然它功能强大，但其设计哲学源自 Java 的 Log4j，因此对初学者来说，**复杂的层级结构**和**配置逻辑**往往是最大的门槛。

------

## 一、 Python Logging 核心组件

理解 `logging` 模块，只需要掌握这四个核心类：

1. **Logger（记录器）**：提供给代码直接调用的接口（如 `logger.info()`）。
2. **Handler（处理器）**：决定日志去哪。发送到控制台、写入文件或通过网络发送。
3. **Formatter（格式器）**：决定日志长什么样。比如是否包含时间、文件名、行号。
4. **Filter（过滤器）**：更精细地控制哪些日志记录被输出。

------

## 二、 基础使用：四步走方案

这是一个标准的、可用于生产环境的基础配置流程：



```Python
import logging

# 1. 创建 Logger
logger = logging.getLogger("my_app")
logger.setLevel(logging.DEBUG)  # 设置总门槛级别

# 2. 创建 Handler (控制台输出)
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)

# 3. 创建 Formatter 并绑定到 Handler
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
console_handler.setFormatter(formatter)

# 4. 将 Handler 添加到 Logger
logger.addHandler(console_handler)

# 使用
logger.info("这是一条信息")
logger.error("这是一个错误")
```

------

## 三、 初学者容易犯的错误与误区

### 1. 滥用 `logging.basicConfig()`

- **误区**：以为 `basicConfig` 可以在程序任何地方修改配置。
- **真相**：`basicConfig` **只有在第一次调用时生效**。如果你的第三方库已经调用过它，或者你在代码后面又调了一次，第二次调用通常会被忽略。
- **建议**：在大型项目中，尽量手动配置 Logger，或者使用 `logging.config.dictConfig()`。

### 2. 混淆 Logger 的级别与 Handler 的级别

- **误区**：设置了 `handler.setLevel(logging.DEBUG)` 但没看到输出。
- **真相**：日志像过安检一样，首先要通过 **Logger 的门槛**，然后再通过 **Handler 的门槛**。如果 Logger 默认是 WARNING，那么即便 Handler 是 DEBUG，低级别的日志也会在第一关被拦截。

### 3. 日志消息的字符串格式化（性能陷阱）

- **误区**：使用 `logger.debug(f"Result: {expensive_func()}")` 或 `logger.debug("Result: %s" % data)`。
- **真相**：即使日志级别是 INFO（不打印 DEBUG），f-string 也会**立即执行**函数或进行字符串拼接。
- **建议**：使用 `logger.debug("Result: %s", data)`。这样只有当确定要输出这条日志时，logging 才会进行字符串格式化。

### 4. 重复添加 Handler 导致日志翻倍

- **误区**：在循环或频繁调用的函数里执行 `logger.addHandler(handler)`。
- **后果**：每执行一次，Logger 就会多一个“耳朵”。结果就是打印一次日志，控制台会出现 10 行重复的内容。
- **建议**：确保 `addHandler` 只执行一次，或者在添加前检查 `if not logger.handlers:`。

### 5. 忽视日志层级传播 (Propagate)

- **误区**：子 Logger 打印了一遍，Root Logger 又打印了一遍。
- **真相**：默认情况下，子 Logger 的日志会向上“传播”给父级。如果你给子 Logger 挂了 Handler，而 Root 也有 Handler，就会导致双重输出。
- **建议**：如果不希望向上传递，设置 `logger.propagate = False`。

------

## 四、 最佳实践建议

| **场景**     | **推荐做法**                                                 |
| ------------ | ------------------------------------------------------------ |
| **库开发**   | 永远只使用 `logger = logging.getLogger(__name__)`，不要加 Handler。 |
| **应用开发** | 在入口文件（如 `main.py`）配置 Handler。                     |
| **错误追踪** | 使用 `logger.exception("message")`，它会自动记录异常堆栈信息。 |
| **文件滚动** | 使用 `RotatingFileHandler` 避免单个日志文件过大撑爆硬盘。    |

------

