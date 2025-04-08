[toc]



## Python Pickle 模块实用教程

Pickle 是 Python 中用于对象序列化和反序列化的标准模块，它可以将 Python 对象转换为字节流（序列化），也可以将字节流转换回 Python 对象（反序列化）。

[pickle --- Python 对象序列化 — Python 文档](https://docs.python.org/zh-cn/3.13/library/pickle.html)



## 1. 基本用法

### pickle基本方法

pickle模块中存在两个基本类方法(无状态方法),`pickle.dump`,`pickle.load`

跟进一步,还有对应的`dumps,loads`方法

> 还有更高级的特性,可以参考官方文档

最后,pickle的常规用法一般设计文件IO,因此，推荐的做法是使用`with open ...as...`来管理相关过程,此外,pickle导出的是二进制文件,因此导出和导入open函数使用的mode分被是`wb`,`rb`

### 序列化对象（pickling）

```python
import pickle

data = {
    'name': 'Alice',
    'age': 30,
    'hobbies': ['reading', 'hiking', 'coding']
}

# 序列化到文件
with open('data.pkl', 'wb') as f:
    pickle.dump(data, f)

# 序列化为字节对象
serialized_data = pickle.dumps(data)
```

### 反序列化对象（unpickling）

```python
import pickle

# 从文件反序列化
with open('data.pkl', 'rb') as f:
    loaded_data = pickle.load(f)
print(loaded_data)

# 从字节对象反序列化
deserialized_data = pickle.loads(serialized_data)
print(deserialized_data)
```

## 2. 高级特性

### 序列化自定义对象

```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def __repr__(self):
        return f"Person(name='{self.name}', age={self.age})"

alice = Person("Alice", 30)

# 序列化
with open('person.pkl', 'wb') as f:
    pickle.dump(alice, f)

# 反序列化
with open('person.pkl', 'rb') as f:
    loaded_person = pickle.load(f)

print(loaded_person)  # 输出: Person(name='Alice', age=30)
```

### 控制序列化协议

Pickle 有多个协议版本，可以通过 protocol 参数指定：

```python
# 使用最高效的协议
with open('data_high_proto.pkl', 'wb') as f:
    pickle.dump(data, f, protocol=pickle.HIGHEST_PROTOCOL)

# 指定协议版本
with open('data_proto4.pkl', 'wb') as f:
    pickle.dump(data, f, protocol=4)
```

### 序列化多个对象

```python
data1 = {'a': 1, 'b': 2}
data2 = [1, 2, 3, 4]
data3 = "Hello, World!"

with open('multi_data.pkl', 'wb') as f:
    pickle.dump(data1, f)
    pickle.dump(data2, f)
    pickle.dump(data3, f)

with open('multi_data.pkl', 'rb') as f:
    loaded1 = pickle.load(f)
    loaded2 = pickle.load(f)
    loaded3 = pickle.load(f)

print(loaded1, loaded2, loaded3)
```

## 3. 安全注意事项

Pickle 模块不安全！永远不要反序列化不受信任的数据，因为它可能导致任意代码执行。

### 安全替代方案

对于需要安全序列化的场景，考虑使用以下替代方案：

1. **JSON** - 用于基本数据类型
   ```python
   import json
   json_data = json.dumps(data)
   ```

2. **marshal** - Python 内部序列化格式（也不完全安全）

3. **第三方库**如 `dill`、`joblib`（扩展了 pickle 的功能）

## 4. 常见问题解决

### 处理大对象

对于大对象，可以使用 `pickletools` 优化：

```python
import pickletools

# 优化序列化数据
optimized = pickletools.optimize(serialized_data)
```

### 调试序列化问题

```python
import pickletools

# 查看序列化数据的详细内容
pickletools.dis(serialized_data)
```

### 处理无法序列化的对象

有些对象（如打开的文件、数据库连接等）无法序列化，可以定义 `__reduce__` 方法：

```python
class Resource:
    def __init__(self, filename):
        self.filename = filename
        self.file = open(filename, 'r')
    
    def __reduce__(self):
        # 返回一个可调用的对象和参数元组
        return (self.__class__, (self.filename,))
    
    def __del__(self):
        if hasattr(self, 'file') and self.file:
            self.file.close()
```

## 5. 性能比较

Pickle 不同协议版本的性能比较：

| 协议版本 | Python 版本 | 特点                                   |
| -------- | ----------- | -------------------------------------- |
| 0        | 所有版本    | 人类可读的 ASCII 格式，速度最慢        |
| 1        | 所有版本    | 较旧的二进制格式                       |
| 2        | Python 2.3+ | 更高效的类序列化                       |
| 3        | Python 3.0+ | 支持 bytes 对象（Python 2.x 不能解码） |
| 4        | Python 3.4+ | 支持大对象和更多数据类型，性能更好     |
| 5        | Python 3.8+ | 支持带外数据，性能进一步提升           |

## 6. 实际应用示例

### 缓存函数结果

```python
import pickle
import os
from functools import wraps

def cache_to_file(filename):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            if os.path.exists(filename):
                with open(filename, 'rb') as f:
                    return pickle.load(f)
            
            result = func(*args, **kwargs)
            with open(filename, 'wb') as f:
                pickle.dump(result, f, protocol=pickle.HIGHEST_PROTOCOL)
            return result
        return wrapper
    return decorator

@cache_to_file('expensive_calculation.pkl')
def expensive_calculation(n):
    print("Performing expensive calculation...")
    return sum(i*i for i in range(n))

# 第一次调用会执行计算
result1 = expensive_calculation(10**6)

# 第二次调用会从缓存加载
result2 = expensive_calculation(10**6)
```

Pickle 是 Python 中强大的序列化工具，但使用时务必注意安全性问题。对于需要长期存储或跨语言兼容的数据，建议考虑 JSON 或其他更安全的格式。