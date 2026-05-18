[toc]

# `str()` vs `repr()` in Python

两者都将对象转换为字符串，但目的不同：

|                | `str()`              | `repr()`                                 |
| -------------- | -------------------- | ---------------------------------------- |
| 目的           | 给人看的，可读性优先 | 给开发者看的，精确性优先                 |
| 调用的魔术方法 | `__str__`            | `__repr__`                               |
| 设计目标       | 友好展示             | 无歧义，理想情况下可用 `eval()` 还原对象 |
| 触发场景       | `print()`、f-string  | 交互式解释器、容器内元素展示             |

## 基本区别

```python
s = "hello\nworld"

print(str(s))   # hello
                # world

print(repr(s))  # 'hello\nworld'
```

`str()` 输出人类可读的内容，转义符被解释；

`repr()` 保留引号和转义符，展示字符串的真实结构。

## 对日期对象的区别

```python
from datetime import datetime

now = datetime.now()

str(now)   # '2024-01-15 10:30:00.123456'  — 可读
repr(now)  # 'datetime.datetime(2024, 1, 15, 10, 30, 0, 123456)'  — 可还原
```

## 容器中的行为

容器（list、dict）展示元素时，**始终调用**元素的 `__repr__`：

```python
words = ["hello\nworld", "foo"]

print(words)        # ['hello\nworld', 'foo']  — 用的是 repr
print(str(words))   # 同上，list 的 __str__ 内部对元素调用 repr
```

## 自定义类中的实现

```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Point({self.x}, {self.y})"

    def __str__(self):
        return f"({self.x}, {self.y})"


p = Point(3, 4)

print(repr(p))  # Point(3, 4)
print(str(p))   # (3, 4)
print(p)        # (3, 4)  — print 调用 __str__
print([p])      # [Point(3, 4)]  — 容器内用 __repr__
```

## 回退机制

- 如果只定义了 `__repr__` 而没有 `__str__`，`str()` 会回退到 `__repr__`。
- 反过来不行：只定义 `__str__` 时，`repr()` 不会用它，而是回退到默认的 `<ClassName object at 0x...>`。

所以实践中的建议：**至少实现 `__repr__`**，它是更基础的那个。

## 实用总结

- 调试、日志记录用 `repr()`——能看到类型和精确值。
- 面向用户的输出用 `str()`——干净、友好。
- f-string 中想用 repr 可以加 `!r`：`f"{value!r}"`。

# `eval()` in Python

`eval()` 将一个字符串当作 Python 表达式来执行，并返回结果。

```python
eval("3 + 4")       # 7
eval("[1, 2, 3]")   # [1, 2, 3]
```

## 基本用法

```python
# 签名
eval(expression, globals=None, locals=None)
```

- `expression`：一个合法的 Python 表达式字符串
- `globals`/`locals`：可选，控制表达式能访问的命名空间

```python
x = 10
eval("x * 2")  # 20 — 能访问当前作用域的变量

eval("x + y", {"x": 1, "y": 2})  # 3 — 使用自定义命名空间
```

## 与 `repr()` 的关系

`repr()` 的设计目标是生成一个字符串，使得 `eval(repr(obj))` 能还原出等价对象：

```python
from datetime import datetime

dt = datetime(2024, 1, 15, 10, 30)
repr(dt)  # 'datetime.datetime(2024, 1, 15, 10, 30)'

eval(repr(dt)) == dt  # True — 成功还原
s = "hello\nworld"
eval(repr(s)) == s  # True

lst = [1, 2, 3]
eval(repr(lst)) == lst  # True
```

不是所有对象都能做到这一点（比如文件句柄、网络连接），但内置类型基本都支持。

## `eval()` vs `exec()`

|        | `eval()`     | `exec()`                           |
| ------ | ------------ | ---------------------------------- |
| 接受   | 单个表达式   | 任意语句（赋值、循环、函数定义等） |
| 返回值 | 表达式的结果 | 始终返回 `None`                    |
| 用途   | 计算并取值   | 执行代码块                         |

```python
eval("3 + 4")       # 7
exec("x = 3 + 4")   # None，但 x 被赋值了

# eval 不能执行语句
eval("x = 5")  # SyntaxError
```

## 安全风险

`eval()` 会执行任意代码，绝不能用于不可信输入：

```python
# 危险示例 — 用户输入可以执行任意操作
user_input = "__import__('os').system('rm -rf /')"
eval(user_input)  # 灾难性后果
```

即使限制 globals/locals 也不安全，因为可以通过 `__builtins__` 绕过：

```python
# 看似安全，实际仍可绕过
eval(user_input, {"__builtins__": {}})
# 仍有方法通过对象的 __subclasses__() 链逃逸
```

## 安全替代方案

根据场景选择合适的替代：

```python
# 1. 解析字面量 — ast.literal_eval（只接受字面量，安全）
import ast
ast.literal_eval("[1, 2, 3]")      # [1, 2, 3]
ast.literal_eval("{'a': 1}")       # {'a': 1}
ast.literal_eval("__import__('os')")  # ValueError — 拒绝执行

# 2. 数学表达式 — 用专门的解析库
# 比如 simpleeval、asteval

# 3. JSON 数据 — 用 json.loads
import json
json.loads('{"name": "alice", "age": 30}')
```

## 实用总结

- `eval()` 适合受控环境下的元编程、调试、REPL 工具。
- 永远不要对用户输入使用 `eval()`。
- 需要解析数据结构字面量时用 `ast.literal_eval()`。
- 需要执行多行代码时用 `exec()`（同样有安全风险）。