[toc]



## Copies and Views

When operating and manipulating arrays, their data is sometimes copied into a new array and sometimes not. This is often a source of confusion for beginners. There are three cases:

### No Copy at All

Simple assignments make no copy of objects or their data.

```
>>> a = np.array([[ 0,  1,  2,  3],
...               [ 4,  5,  6,  7],
...               [ 8,  9, 10, 11]])
>>> b = a            # no new object is created
>>> b is a           # a and b are two names for the same ndarray object
True
```

Python passes mutable objects as references, so function calls make no copy.

```
>>> def f(x):
...     print(id(x))
...
>>> id(a)  # id is a unique identifier of an object 
148293216  # may vary
>>> f(a)   
148293216  # may vary
```

### View or Shallow Copy

Different array objects can share the same data. The `view` method creates a new array object that looks at the same data.

```
>>> c = a.view()
>>> c is a
False
>>> c.base is a            # c is a view of the data owned by a
True
>>> c.flags.owndata
False
>>>
>>> c = c.reshape((2, 6))  # a's shape doesn't change
>>> a.shape
(3, 4)
>>> c[0, 4] = 1234         # a's data changes
>>> a
array([[   0,    1,    2,    3],
       [1234,    5,    6,    7],
       [   8,    9,   10,   11]])
```

Slicing an array returns a view of it:

```
>>> s = a[:, 1:3]
>>> s[:] = 10  # s[:] is a view of s. Note the difference between s = 10 and s[:] = 10
>>> a
array([[   0,   10,   10,    3],
       [1234,   10,   10,    7],
       [   8,   10,   10,   11]])
```

### Deep Copy

- The `copy` method makes a complete copy of the array and its data.

- ```
  >>> d = a.copy()  # a new array object with new data is created
  >>> d is a
  False
  >>> d.base is a  # d doesn't share anything with a
  False
  >>> d[0, 0] = 9999
  >>> a
  array([[   0,   10,   10,    3],
         [1234,   10,   10,    7],
         [   8,   10,   10,   11]])
  ```


### 节约内存的技巧

- Sometimes `copy` should be called after slicing if the original array is not required anymore. For example, suppose `a` is a huge intermediate result and the final result `b` only contains a small fraction of `a`, a deep copy should be made when constructing `b` with slicing:

- ```
  >>> a = np.arange(int(1e8))
  >>> b = a[:100].copy()
  >>> del a  # the memory of ``a`` can be released.
  ```

- If `b = a[:100]` is used instead, `a` is referenced by `b` and will persist in memory even if `del a` is executed.

## 补充试验

- 以下试验在jupyter notebook 下进行


```python
import numpy as np


a = np.array([[ 0,  1,  2,  3],
               [ 4,  5,  6,  7],
               [ 8,  9, 10, 11]])
b=a
print(a==b)
print(a is b)
print(id(a)==id(b))
```

```
    [[ True  True  True  True]
     [ True  True  True  True]
     [ True  True  True  True]]
    True
    True
```

- ​    浅拷贝,得到源对象`a`的视图`c`



```python
c=a.view()

c,type(c)
```



```
    (array([[ 0,  1,  2,  3],
            [ 4,  5,  6,  7],
            [ 8,  9, 10, 11]]),
     numpy.ndarray)
```

- `a,c`的类型都是ndarray,他们又一定的联系,但是他们并不等价


```python
print(c is a,id(c),id(a),c.base is a)
```

```
False 2296426462928 2296415339600 True

```

- 检查`c`和`c.base`的类型(都是ndarray)


```python
type(c.base),type(c)
```



```
(numpy.ndarray, numpy.ndarray)
```

- 检查一个ndarray对象是否为其他某个对象的视图


```python
c.flags.owndata,a.flags.owndata
#说明c的数据是来自于其他对象(比如是其他对象调用view生成的),而a的数据是来自自己的
```



```
    (False, True)
```




```python
print(id(c))
c=c.reshape(2,6)
print(id(c))
```

```
    2296426462928
    2296415340656
```

- ​    修改视图c的形状,并不会影响源对象a的形状



```python
c,a
```



```
    (array([[ 0,  1,  2,  3,  4,  5],
            [ 6,  7,  8,  9, 10, 11]]),
     array([[ 0,  1,  2,  3],
            [ 4,  5,  6,  7],
            [ 8,  9, 10, 11]]))
```

- 试验通过修改视图c的某个元素来修改源对象a的元素


```python
c[0,4]=123
#如果对一个对象a的view(记为c)作修改,那么对象a会受到c的变换的影响(因为c.base=a)
#然而ndarray对象的形状(shape)和数据(data)又相对独立,修改c的某个元素,a中对应的元素也被修改,但是修改c的形状,a的形状却不会改变
#元素的对应关系可以分别flatten后对应起来
c,a
```



```
    (array([[  0,  10,  10,   3, 123,  10],
            [ 10,   7,   8,  10,  10,  11]]),
     array([[  0,  10,  10,   3],
            [123,  10,  10,   7],
            [  8,  10,  10,  11]]))
```

- 改变完视图c的shape,再次检查`c.base`是否依然等价于`a`


```python
c.base is a
```

```
    True
```



## Slicing an array returns a view of it:


```python
s = a[:, 1:3]
s[:] = 10  # s[:] is a view of s. Note the difference between s = 10 and s[:] = 10
a,s

```

```
    (array([[  0,  10,  10,   3],
            [123,  10,  10,   7],
            [  8,  10,  10,  11]]),
     array([[10, 10],
            [10, 10],
            [10, 10]]))
```




```python
t=a[:,1:3]
t
```



```
    array([[10, 10],
           [10, 10],
           [10, 10]])
```




```python
t=100
t
```


​    100




```python
x=np.arange(12).reshape(4,3)
x,id(x)
```




​    (array([[ 0,  1,  2],
​            [ 3,  4,  5],
​            [ 6,  7,  8],
​            [ 9, 10, 11]]),
​     2296338927792)




```python
x=99
x,id(x)
```




​    (99, 2296148266288)




```python
# a="str1"
# b=a
# print(b is a)
```

​    True
​    

## Deep Copy


```python
d = a.copy()  # a new array object with new data is created
a,d
```




​    (array([[  0,  10,  10,   3],
​            [123,  10,  10,   7],
​            [  8,  10,  10,  11]]),
​     array([[  0,  10,  10,   3],
​            [123,  10,  10,   7],
​            [  8,  10,  10,  11]]))




```python

d is a,id(d),id(a)

```




​    (False, 2296338931824, 2296415339600)




```python
d.base,a.base#可以发现a的深拷贝d,其d.base,与a本身的a.base是None,因为他们的地位是等同的,除了具有一样的元素,在内存上完全独立
# d doesn't share anything with a

```




​    (None, None)




```python
c.base#而c是a的浅拷贝(view),所以具有非None的base(c.base 就是 a)
```




​    array([[  0,  10,  10,   3],
​           [123,  10,  10,   7],
​           [  8,  10,  10,  11]])




```python
d.base==a,
```




​    (array([[False, False, False, False],
​            [False, False, False, False],
​            [False, False, False, False]]),)




```python
d[1,1]=9999
d,a
```



​    (array([[   0,   10,   10,    3],
​            [ 123, 9999,   10,    7],
​            [   8,   10,   10,   11]]),
​     array([[  0,  10,  10,   3],
​            [123,  10,  10,   7],
​            [  8,  10,  10,  11]]))







