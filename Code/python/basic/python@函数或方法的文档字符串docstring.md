[toc]

# Python 函数字符串文档编写指南

在Python中，函数的文档字符串（docstring）是用来解释函数用途、参数、返回值等重要信息的标准化方式。以下是编写Python函数文档字符串的最佳实践：

## 基本格式

```python
def function_name(arg1, arg2):
    """函数的简要描述
    
    函数的详细描述，可以跨多行。
    
    Args:
        arg1 (type): 参数1的描述
        arg2 (type): 参数2的描述，包括
            可能的默认值，如默认是None
    
    Returns:
        type: 返回值的描述
    
    Raises:
        ValueError: 当输入参数无效时引发
        
    Examples:
        >>> function_name(1, 2)
        3
    """
    # 函数实现
    pass
```

## 常用文档字符串风格

### 1. Google风格

```python
def add(a, b):
    """计算两个数的和
    
    Args:
        a (int): 第一个加数
        b (int): 第二个加数
    
    Returns:
        int: 两个数的和
    
    Examples:
        >>> add(2, 3)
        5
    """
    return a + b
```

### 2. NumPy/SciPy风格

```python
def subtract(a, b):
    """
    计算两个数的差
    
    Parameters
    ----------
    a : int
        被减数
    b : int
        减数
    
    Returns
    -------
    int
        两个数的差
    
    Examples
    --------
    >>> subtract(5, 3)
    2
    """
    return a - b
```

### 3. reStructuredText风格

```python
def multiply(a, b):
    """计算两个数的乘积
    
    :param a: 第一个因数
    :type a: int
    :param b: 第二个因数
    :type b: int
    :return: 两个数的乘积
    :rtype: int
    
    :example:
    >>> multiply(3, 4)
    12
    """
    return a * b
```

注意,这种格式,每一行参数解释严格遵循`:param paramname: comments`

特别注意一对`:`符号包裹着`param paramname`,不要有多余`:`对包裹的内容和`:`不要有多余的空格,而`param`,`paramname`之间至少要一个空格隔开

第二个`:`和`comments`要you

## 文档字符串内容建议

1. **第一行**：简洁的函数功能描述，以句号结尾
2. **空一行**：分隔简要描述和详细描述
3. **详细描述**：函数的行为、使用方法和注意事项
4. **参数部分**：列出所有参数及其类型和描述
5. **返回值**：描述返回值的类型和含义
6. **异常**：列出可能抛出的异常
7. **示例**：提供使用示例（可选但推荐）

## 多行文档字符串示例

```python
def divide(dividend, divisor):
    """执行除法运算
    
    这个函数执行两个数的除法运算，处理除零错误。
    如果除数为零，将引发ValueError异常。
    
    Args:
        dividend (float): 被除数
        divisor (float): 除数
    
    Returns:
        float: 除法结果
    
    Raises:
        ValueError: 当除数为零时引发
    
    Examples:
        >>> divide(10, 2)
        5.0
        >>> divide(5, 0)
        Traceback (most recent call last):
            ...
        ValueError: 除数不能为零
    """
    if divisor == 0:
        raise ValueError("除数不能为零")
    return dividend / divisor
```

## 类型提示与文档字符串结合

Python 3.5+支持类型提示，可以与文档字符串结合使用：

```python
from typing import Union, List

def process_items(items: List[Union[int, str]]) -> List[str]:
    """处理项目列表
    
    将列表中的每个项目转换为字符串并添加前缀。
    
    Args:
        items: 要处理的整数或字符串列表
    
    Returns:
        添加前缀后的字符串列表
    
    Examples:
        >>> process_items([1, 'two', 3])
        ['item_1', 'item_two', 'item_3']
    """
    return [f"item_{item}" for item in items]
```

良好的文档字符串可以提高代码的可读性和可维护性，是专业Python开发的重要实践。