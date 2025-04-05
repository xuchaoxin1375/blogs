[toc]



## abstract

[PEP 343 – “with” 声明 |peps.python.org](https://peps.python.org/pep-0343/#abstract)

在 Python 中，`with ... as ...` 是一种上下文管理协议（Context Management Protocol）的语法糖，用于简化资源管理。它确保资源在使用后能够被正确释放，即使发生异常也不会导致资源泄漏。

---

## **1. 基本概念**

### **1.1 上下文管理器**
- **上下文管理器** 是一个实现了 `__enter__()` 和 `__exit__()` 方法的对象。
- `__enter__()`：在进入 `with` 语句块时调用，通常用于获取资源。
- `__exit__()`：在退出 `with` 语句块时调用，无论是否发生异常都会执行，通常用于释放资源。

### **1.2 使用场景**
- 文件操作
- 数据库连接
- 网络连接
- 锁（如线程锁）
- 自定义资源管理

---

## **2. 语法结构**

```python
with expression [as variable]:
    # 在这里使用资源
```

- `expression`：必须返回一个上下文管理器对象。
- `variable`（可选）：绑定到 `expression.__enter__()` 的返回值，通常是资源对象。

---

## **3. 示例**

### **3.1 文件操作🎈**

文件是最常见的资源之一，使用 `with` 可以确保文件在操作完成后自动关闭。

#### 不使用 `with` 的方式：
```python
f = open("example.txt", "r")
try:
    content = f.read()
    print(content)
finally:
    f.close()  # 手动关闭文件
```

#### 使用 `with` 的方式：
```python
with open("example.txt", "r") as f:
    content = f.read()
    print(content)
# 文件会在退出 with 语句块时自动关闭
```

上述代码中，`open()` 返回了一个文件对象，该对象是一个上下文管理器，`with` 语句会自动调用其 `__enter__()` 和 `__exit__()` 方法。

---

### **3.2 数据库连接**

数据库连接也需要显式关闭，`with` 可以简化这一过程。

```python
import sqlite3

# 使用 with 管理数据库连接
with sqlite3.connect("example.db") as conn:
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    rows = cursor.fetchall()
    for row in rows:
        print(row)
# 数据库连接会在退出 with 语句块时自动关闭
```

---

### **3.3 多线程锁**

在多线程编程中，锁需要手动获取和释放，`with` 可以确保锁在使用后被正确释放。

```python
import threading

lock = threading.Lock()

def worker():
    with lock:  # 自动获取锁
        print(f"线程 {threading.current_thread().name} 获取了锁")
        # 模拟临界区操作
    # 自动释放锁

threads = [threading.Thread(target=worker) for _ in range(5)]
for t in threads:
    t.start()
for t in threads:
    t.join()
```

---

## **4. 自定义上下文管理器**

如果内置类型不满足需求，可以通过自定义类实现上下文管理器。

### **4.1 实现 `__enter__` 和 `__exit__`**

```python
class MyContextManager:
    def __enter__(self):
        print("进入上下文")
        return self  # 返回值会绑定到 as 后的变量

    def __exit__(self, exc_type, exc_value, traceback):
        print("退出上下文")
        if exc_type is not None:
            print(f"捕获异常: {exc_value}")
        return True  # 返回 True 表示异常已被处理

# 使用自定义上下文管理器
with MyContextManager() as cm:
    print("正在使用上下文管理器")
    raise ValueError("测试异常")
```

**输出：**
```
进入上下文
正在使用上下文
退出上下文
捕获异常: 测试异常
```

---

### **4.2 使用 `contextlib` 装饰器**

对于简单的上下文管理器，可以使用 `contextlib.contextmanager` 装饰器。

```python
from contextlib import contextmanager

@contextmanager
def my_context_manager():
    print("进入上下文")
    try:
        yield  # 挂起，等待 with 语句块执行完成
    except Exception as e:
        print(f"捕获异常: {e}")
    finally:
        print("退出上下文")

# 使用装饰器创建的上下文管理器
with my_context_manager():
    print("正在使用上下文管理器")
    raise ValueError("测试异常")
```

**输出：**
```
进入上下文
正在使用上下文管理器
捕获异常: 测试异常
退出上下文
```

---

## **5. 高级用法**

### **5.1 嵌套多个上下文管理器**

可以嵌套多个 `with` 语句，或者在一个 `with` 中同时管理多个资源。

```python
# 嵌套方式
with open("file1.txt", "r") as f1:
    with open("file2.txt", "w") as f2:
        f2.write(f1.read())

# 单行方式
with open("file1.txt", "r") as f1, open("file2.txt", "w") as f2:
    f2.write(f1.read())
```

---

### **5.2 动态管理资源**

可以通过动态生成上下文管理器来管理不同类型的资源。

```python
class ResourceManager:
    def __init__(self, resource_name):
        self.resource_name = resource_name

    def __enter__(self):
        print(f"打开资源: {self.resource_name}")
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        print(f"关闭资源: {self.resource_name}")

# 动态管理资源
resource_names = ["file.txt", "database", "network"]
for name in resource_names:
    with ResourceManager(name):
        print(f"正在使用资源: {name}")
```

---

## **6. 总结**

`with ... as ...` 是一种优雅且安全的资源管理方式，适用于任何需要获取和释放资源的场景。以下是关键点总结：

1. **核心机制**：通过 `__enter__()` 和 `__exit__()` 方法实现资源的获取和释放。
2. **优点**：
   - 自动释放资源，避免资源泄漏。
   - 简化代码结构，减少冗余。
   - 在异常情况下也能正确释放资源。
3. **应用场景**：文件、数据库连接、网络连接、锁等。
4. **扩展性**：可以通过自定义类或 `contextlib` 创建自己的上下文管理器。

 