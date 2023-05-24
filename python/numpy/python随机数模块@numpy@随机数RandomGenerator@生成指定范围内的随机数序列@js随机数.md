[toc]



- python随机数模块@numpy@随机数RandomGenerator@生成指定范围内的随机数序列@js随机数

# 生成自定范围内不重复的随机数序列

##  公式

###  一般的

- 欲要得到[left,right)范围的随机数,可以:

  - $$
    令y=left+(right-left)\times{r},r\in[0,1)
    \\
    则y\in[left,right)
    $$


###  特殊的

- 得到[0,right)半开区间内的随机数,通过$right\times{r}$的方式得到,其中$r\in[0,1)$

  - $$
    r\in[0,1)
    \\
    y=right\times{r}\in[0,right)
    $$

    

## numpy接口@得到指定范围内的浮点数矩阵

#### 使用uniform函数(均匀分布)

- [numpy.random.Generator.uniform — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.uniform.html)

- [python - How to get a random number between a float range? - Stack Overflow](https://stackoverflow.com/questions/6088077/how-to-get-a-random-number-between-a-float-range)

- 假设我们要得到[4,7)内的随机浮点数矩阵
  
- ```python
  import numpy.random as npr
  rng=npr.default_rng()
  size=(3,4)
  C=rng.uniform(4,7,size)
  print(f"{C=}")
  ```

  - ```
    C=array([[6.0436931 , 5.63331156, 6.11905388, 5.77916688],
           [5.6442441 , 5.61249485, 6.79054321, 6.7742957 ],
           [4.80639433, 6.3189182 , 6.72264963, 4.94990386]])
    ```

    

#### 使用上一节介绍的公式

- ```python
  ##
  import numpy.random as npr
  #旧api
  size=(3,4)# size 规格
  A=npr.random(size)*(7-4)+4
  #新api
  rng=npr.default_rng()
  B=rng.random(size)*(7-4)+4
  print(f"{A=}\n{B=}")
  
  ```

- output

  - ```
    A=array([[0.73924313, 0.86760037, 0.18800622, 0.8370736 ],
           [0.10841024, 0.0564878 , 0.83902755, 0.64796633],
           [0.32000126, 0.21304282, 0.0333497 , 0.33100477]])
    B=array([[0.93182649, 0.40417216, 0.06125742, 0.36432193],
           [0.48754533, 0.69363528, 0.34998984, 0.70583201],
           [0.41260264, 0.11074999, 0.83018146, 0.24863994]])
    ```

###  numpy得到指定范围内的整数矩阵

- numpy得到[4,7]内的范围的整数矩阵(3行4列)

  - 
    ```python
    import numpy.random as npr
    #旧api
    size=(3,4)# size 规格
    A=npr.randint(4,7+1,size)
    #新api
    rng=npr.default_rng()
    B=rng.integers(4,8,size=size)
    print(f"{A=}\n{B=}")
    ```

  - output

    - ```
      A=array([[6, 5, 7, 4],
             [4, 6, 4, 5],
             [5, 5, 6, 6]])
      B=array([[6, 6, 6, 7],
             [6, 6, 7, 5],
             [6, 6, 6, 6]], dtype=int64)
      ```

#  js@指定范围内的随机数

##  reference link

- [Math.random() - JavaScript | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Math/random)
  - [示例 (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Math/random#examples) 

##  指定范围内的随机数

- ```python
  Math.floor(Math.random() * (max - min + 1)) + min
  ```

  - 这里用到向下取整

#  python@得到不重复的指定范围内的随机数🎈

## python自带实现(sample)

- [random --- 生成伪随机数 — Python 3.10.4 文档](https://docs.python.org/zh-cn/3/library/random.html#random.sample)

  ```py
  population=('a', 'b', 'c', 'd')
  rand_sample_immutable2 = random.sample( population,k=len(population))
  print("@rand_sample_immutable2:", rand_sample_immutable2)
  #output
  #@rand_sample_immutable2: ['d', 'c', 'a', 'b']
  ```




## 简单的实现算法

- [Non-repetitive random number in numpy - Stack Overflow](https://stackoverflow.com/questions/8505651/non-repetitive-random-number-in-numpy)

- 打乱数组法
在python中,可以用shuffle函数进行打乱,然后返回这个被打乱的数组(部分或者全部)
- 返回随机抽取的对象
手动生成指定范围内的序列,存储在容器中(例如列表/数组)
打乱这个序列(执行shuffle操作/或者自行实现shuffle操作)
再以这些随机(乱序)数作为key/index,到容器中取出对象
- 例如:生成指定数目(譬如20个)值在20~100内的数(20个值不重复)
### 借助shuffle函数

```python
import random as rand
def get_range_randoms(low=20, high=100, size=10, is_contain_high=0, is_sorted=1):
    '''

    :param low: 随机数下界
    :type low:
    :param high: 随机数上界
    :type high:
    :param size: 需要取出多少个随机数
    :type size:
    :param is_contain_high:默认开区间; 0表示开区间;1表示闭区间
    :type is_contain_high:
    :param is_sorted: 默认排序;0表示排序;1表示排序;
    :type is_sorted:
    :return:
    :rtype:
    '''
    if is_contain_high:
        high += 1
    range_list = list(range(low, high))  # 如果需要闭区间,可以为upper_bound+1
    rand.shuffle(range_list)
    shuffled_list = range_list
    sized_list = shuffled_list[:size]
    # print(randon_list)
    ##
    # 可选(排序这些随机数)
    if (is_sorted):
        sized_list.sort()

    # 查看结果
    return sized_list


res=get_range_randoms(55, 177, 10, is_contain_high=0,is_sorted=1)
print(res)


```

## python随机数模块

```py
# from random import random
import random

# 获取闭区间内的随机数
rand_int = random.randint(1, 10)
print("@rand_int:", rand_int)
rand_int = random.randrange(1, 10 + 1)
print("@rand_int:", rand_int)
# 获取0-2^k次幂内的整数(左闭右开)0...(111..1)
rand_bits = random.getrandbits(2)
print("@rand_bits:", rand_bits, type(rand_bits))
# 从给定的序列(集合)中随机选中一个元素
rand_choice = random.choice(['a', 'b', 'c', 'd'])
print("@rand_choice:", rand_choice)
# 从给定的序列中返回子集
rand_choices = random.choices(population=['a', 'b', 'c', 'd'], k=3)
print("@rand_choices:", rand_choices)
# rand_shuffle = random.shuffle(['a', 'b', 'c', 'd'])# 不恰当当用法,返回None;被随机排序的对象会发生改变!
seq_mutable= ['a', 'b', 'c', 'd']
seq_mutable_bak=seq_mutable.copy()
random.shuffle(seq_mutable)

print("@rand_shuffle:", seq_mutable,'<-',seq_mutable_bak)
rand_sample_immutable = random.sample(population=('a', 'b', 'c', 'd'), k=3)
print("@rand_sample_immutable:", rand_sample_immutable,'<-',('a', 'b', 'c', 'd'))
population=('a', 'b', 'c', 'd')
seq_sample = random.sample(population, k=len(population))
print("@rand_sample_immutable2:", seq_sample, '<-', population)

```

###  输出(某一次)

```py
@rand_int: 3
@rand_int: 9
@rand_bits: 3 <class 'int'>
@rand_choice: d
@rand_choices: ['a', 'a', 'c']
@rand_shuffle: ['d', 'b', 'a', 'c'] <- ['a', 'b', 'c', 'd']
@rand_sample_immutable: ['a', 'b', 'd'] <- ('a', 'b', 'c', 'd')
@rand_sample_immutable2: ['c', 'd', 'b', 'a'] <- ('a', 'b', 'c', 'd')
```

## numpy.Generator.choice方法🎈

- [numpy.random.Generator.choice — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.choice.html#numpy.random.Generator.choice)

  - ```python
    import numpy.random as npr
    rng=npr.default_rng()
    RF=rng.choice(15,size=(3,4),replace=False)
    print(RF)
    ```

  - 关键是参数`replace=False`

    - Whether the sample is with or without replacement. Default is True, <u>meaning that a value of `a` can be selected multiple times.</u>
    - 这不能理解为元素去重
    - 例如,从一个本身含有重复元素的序列`a=[1,2,2,3,3]`
    - 将`replace=False`,只能够保证取得的元素是来自a中的不同位置,但是不同位置上的元素不保证互异
    - 只有当a序列中的元素本身是互异的,`replace=False`才可以确保取得的子序列中元素都是互异的

  - 上述代码生成[0,14]范围内序列,返回3行4列的矩阵(元素不重复)

  - output

    - ```
      array([[ 2,  5,  9, 14],
              [13, 10,  4,  3],
              [ 6,  7,  1,  0]], dtype=int64))
      ```

- 其他demo

  - ```python
    D=rng.integers(0,10,size=15)
    RTD=rng.choice(D,size=(3,4))
    RFD=rng.choice(D,size=(3,4),replace=False)
    print(f'{D=}\n{RTD=}\n{RFD=}')
    ```

  - ```
    D=array([8, 2, 8, 6, 1, 8, 3, 9, 7, 8, 6, 6, 1, 4, 7], dtype=int64)
    RTD=array([[1, 1, 8, 1],
           [9, 7, 8, 8],
           [6, 8, 7, 6]], dtype=int64)
    RFD=array([[4, 8, 2, 6],
           [6, 8, 8, 1],
           [9, 6, 7, 7]], dtype=int64)
    ```

    

