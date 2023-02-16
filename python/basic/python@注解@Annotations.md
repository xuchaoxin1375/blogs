[toc]

# 注解

## 函数注解和类型注解

- [函数注解](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#function) 是可选的用户自定义函数类型的元数据完整信息（详见 [**PEP 3107**](https://peps.python.org/pep-3107/) 和 [**PEP 484**](https://peps.python.org/pep-0484/) ）。
  - [PEP 484 – Type Hints | peps.python.org](https://peps.python.org/pep-0484/)
  - [PEP 3107 – Function Annotations | peps.python.org](https://peps.python.org/pep-3107/)

- [标注](https://docs.python.org/zh-cn/3/glossary.html#term-function-annotation) 以字典的形式存放在函数的 `__annotations__` 属性中，并且不会影响函数的任何其他部分。

-  形参标注的定义方式是在形参名后加冒号，后面跟一个表达式，该表达式会被求值为标注的值。 

- 返回值标注的定义方式是加组合符号 `->`，后面跟一个表达式，该标注位于形参列表和表示 [`def`](https://docs.python.org/zh-cn/3/reference/compound_stmts.html#def) 语句结束的冒号之间。 

  - 下面的示例有一个必须的参数，一个可选的关键字参数以及返回值都带有相应的标注:

    - ```python
      def f(ham: str, eggs: str = 'eggs') -> str:
          """演示函数注解的demo
      
          Parameters
          ----------
          ham : str
              形参ham
          eggs : str, optional
              形参eggs, by default 'eggs'
      
          Returns
          -------
          str
              _description_
          """
          print("Annotations:", f.__annotations__)
          print("Arguments:", ham, eggs)
          return ham + ' and ' + eggs
      f("spam")
      ```

    - 输出:

      ```
      Annotations: {'ham': <class 'str'>, 'eggs': <class 'str'>, 'return': <class 'str'>}
      Arguments: spam eggs
      'spam and eggs'
      ```



##  函数注解

Python 3 提供了一种句法，用于为函数声明中的参数和返回值附加元数据。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210616220501406.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
[https://docs.python.org/zh-cn/3/library/typing.html](https://docs.python.org/zh-cn/3/library/typing.html)

##  变量注解和类型注解

```python
import math

def add(x: float, y: float) -> None:
    # 除了函数注解,您当然可以为某个变量使用类型注解:(类似于kotlin风格写法)
    pi: float = 3.142
    
    print(pi)
    print(x+y)
    
if __name__=="__main__":
    add(1,2)
    
 
''' Type Comments[类型注解]:对位置比较严格: '''
def circumference(radius):
    #type: (float) -> float
    return 2 * math.pi * radius
```

###  额外示例:

有注解的 clip 函数:
```python
def clip(text:str, max_len:'int > 0'=80) -> str:  
    """在max_len前面或后面的第一个空格处截断文本
    """
    end = None
    if len(text) > max_len:
        space_before = text.rfind(' ', 0, max_len)
        if space_before >= 0:
            end = space_before
        else:
            space_after = text.rfind(' ', max_len)
            if space_after >= 0:
                end = space_after
    if end is None:  # 没找到空格
        end = len(text)
    return text[:end].rstrip()
```
### numpy.integers() 示例

- ```python
  def integers(  # type: ignore[misc]
          self,
          low: _ArrayLikeInt_co,
          high: None | _ArrayLikeInt_co = ...,
          size: None | _ShapeLike = ...,
          dtype: dtype[int8] | type[int8] | _Int8Codes | _SupportsDType[dtype[int8]] = ...,
          endpoint: bool = ...,
      ) -> ndarray[Any, dtype[int8]]: ...
  ```

  - ```bash
    integers(low, high=None, size=None, dtype=np.int64, endpoint=False)
    
    Return random integers from low (inclusive) to high (exclusive), or if endpoint=True, low (inclusive) to high (inclusive). Replaces RandomState.randint (with endpoint=False) and RandomState.random_integers (with endpoint=True)
    
    Return random integers from the "discrete uniform" distribution of the specified dtype. If high is None (the default), then results are from 0 to low.
    
    Parameters
    low : int or array-like of ints
        Lowest (signed) integers to be drawn from the distribution (unless high=None, in which case this parameter is 0 and this value is used for high).
    high : int or array-like of ints, optional
        If provided, one above the largest (signed) integer to be drawn from the distribution (see above for behavior if high=None). If array-like, must contain integer values
    size : int or tuple of ints, optional
        Output shape. If the given shape is, e.g., (m, n, k), then m * n * k samples are drawn. Default is None, in which case a single value is returned.
    dtype : dtype, optional
        Desired dtype of the result. Byteorder must be native. The default value is np.int64.
    endpoint : bool, optional
        If true, sample from the interval [low, high] instead of the default [low, high) Defaults to False
    
    Returns
    out : int or ndarray of ints
        size-shaped array of random integers from the appropriate distribution, or a single such random int if size not provided.
    
    Notes
    When using broadcasting with uint64 dtypes, the maximum value (2**64) cannot be represented as a standard integer type. The high array (or low if high is None) must have object dtype, e.g., array([2**64]).
    
    Examples
    >>> rng = np.random.default_rng()
    >>> rng.integers(2, size=10)
    array([1, 0, 0, 0, 1, 1, 0, 0, 1, 0])  # random
    >>> rng.integers(1, size=10)
    array([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    Generate a 2 x 4 array of ints between 0 and 4, inclusive:
    
    >>> rng.integers(5, size=(2, 4))
    array([[4, 0, 2, 1],
           [3, 2, 2, 0]])  # random
    Generate a 1 x 3 array with 3 different upper bounds
    
    >>> rng.integers(1, [3, 5, 10])
    array([2, 2, 9])  # random
    Generate a 1 by 3 array with 3 different lower bounds
    
    >>> rng.integers([1, 5, 7], 10)
    array([9, 8, 7])  # random
    Generate a 2 by 4 array using broadcasting with dtype of uint8
    
    >>> rng.integers([1, 3, 5, 7], [[10], [20]], dtype=np.uint8)
    array([[ 8,  6,  9,  7],
           [ 1, 16,  9, 12]], dtype=uint8)  # random
    References
    ```

  

##  NewType:

NewType(新类型名,类型名要对应的类型)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210620110336620.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  泛型注解(容器):

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210620094755334.png)


- 容器类型混用错误警告
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210620094855298.png)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210620110254263.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  Notes:

- 函数声明中的各个参数可以在 : 之后增加注解表达式。如果参数有默认值，注解放在参数名和 = 号之间。

- 如果想注解返回值，在' ) '和函数声明末尾的 : 之间添加 -> 和一个表达式。

  - 那个表达式可以是任何类型解中最常用的类型是类（如 str 或 int）和字符串（如 'int >0'）。


  - 在示例 中，max_len 参数的注解用的是字符串。


- Python 对注解所做的唯一的事情是，把它们存储在函数的__annotations__ 属性里。
  - 仅此而已，Python 不做检查、不做强制、不做验证，什么操作都不做。

- 换句话说，**注解对 Python 解释器没有任何意义**。
- 注解只是**元数据**，可以供 IDE、框架和装饰器等工具使用。



