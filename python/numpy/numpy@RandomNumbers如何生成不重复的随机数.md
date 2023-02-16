[toc]

# 生成指定范围内的随机数序列@python随机数模块@javascript

## 算法

###  特殊的

- 得到[0,right)半开区间内的随机数,通过$right\times{r}$的方式得到,其中$r\in[0,1)$

  - $$
    r\in[0,1)
    \\
    y=right\times{r}\in[0,right)
    $$

    

###  一般的

- 欲要得到[left,right)范围的随机数,可以:

  - $$
    令y=left+(right-left)\times{r},r\in[0,1)
    \\
    则y\in[left,right)
    $$

    

##  numpy接口

### numpy得到指定范围内的浮点数矩阵

- 假设我们要得到[4,7)内的随机浮点数矩阵

#### 使用uniform函数(均匀分布)

- [numpy.random.Generator.uniform — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.uniform.html)

- [python - How to get a random number between a float range? - Stack Overflow](https://stackoverflow.com/questions/6088077/how-to-get-a-random-number-between-a-float-range)

- ```python
  ##
  import numpy.random as npr
  rng=npr.default_rng()
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

  - 上述代码生成[0,14]范围内序列,返回3行4列的矩阵(元素不重复)

  - output

    - ```
      array([[ 2,  5,  9, 14],
              [13, 10,  4,  3],
              [ 6,  7,  1,  0]], dtype=int64))
      ```

- 其他例

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

    

# numpy&随机数🎈

## 随机数模块api文档

- [Random Generator — NumPy  Manual](https://numpy.org/doc/stable/reference/random/generator.html#simple-random-data)

### 概要

Random sampling ([`numpy.random`](https://numpy.org/doc/stable/reference/random/index.html#module-numpy.random))

- Numpy’s random number routines produce pseudo random numbers using combinations of a [`BitGenerator`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.BitGenerator.html#numpy.random.BitGenerator) to create sequences and a [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) to use those sequences to sample **from different statistical distributions**:


- BitGenerators: Objects that generate random numbers. These are typically unsigned integer words filled with sequences of either 32 or 64 random bits.
- Generators: Objects that transform sequences of random bits from a BitGenerator into sequences of numbers that follow a specific probability distribution (such as uniform, Normal or Binomial) within a specified interval.

- Since Numpy version 1.17.0 the Generator can be initialized with a number of different BitGenerators. 

  - It exposes many different probability distributions. See [NEP 19](https://www.numpy.org/neps/nep-0019-rng-policy.html) for context on the updated random Numpy number routines. 


  - <u>The legacy [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) random number routines are still available, but limited to a single BitGenerator.</u> 
  - See [What’s New or Different](https://numpy.org/doc/stable/reference/random/new-or-different.html#new-or-different) for a complete list of improvements and differences from the legacy `RandomState`.

  - For convenience and backward compatibility, a single [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) instance’s methods are imported into the numpy.random namespace, see [Legacy Random Generation](https://numpy.org/doc/stable/reference/random/legacy.html#legacy) for the complete list.


### Random Generator

- rng:**r**a**n**dom-**g**enerator

- The [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) provides access to a wide range of distributions, and served as a replacement for [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState). 
- The main difference between the two is that `Generator` relies on an additional BitGenerator to manage state and generate the random bits, which are then transformed into random values from useful distributions.
- The default BitGenerator used by `Generator` is [`PCG64`](https://numpy.org/doc/stable/reference/random/bit_generators/pcg64.html#numpy.random.PCG64). 
- The BitGenerator can be changed by passing an instantized BitGenerator to `Generator`.

### 新旧API

- [Random sampling (numpy.random) — NumPy v1.24 Manual](https://numpy.org/doc/stable/reference/random/index.html)

- [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) can be used as a replacement for [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState). Both class instances hold an internal [`BitGenerator`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.BitGenerator.html#numpy.random.BitGenerator) instance to provide the bit stream, it is accessible as `gen.bit_generator`. 

- Some long-overdue API cleanup means that legacy and compatibility methods have been removed from [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator)

  | [`RandomState`](https://numpy.org/doc/stable/reference/random/legacy.html#numpy.random.RandomState) | [`Generator`](https://numpy.org/doc/stable/reference/random/generator.html#numpy.random.Generator) | Notes                                                        |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | `random_sample`,                                             | `random`                                                     | Compatible with [`random.random`](https://docs.python.org/3/library/random.html#random.random) |
  | `rand`                                                       |                                                              |                                                              |
  | `randint`,                                                   | `integers`                                                   | Add an `endpoint` kwarg                                      |
  | `random_integers`                                            |                                                              |                                                              |
  | `tomaxint`                                                   | removed                                                      | Use `integers(0, np.iinfo(np.int_).max,` `endpoint=False)`   |
  | `seed`                                                       | removed                                                      | Use [`SeedSequence.spawn`](https://numpy.org/doc/stable/reference/random/bit_generators/generated/numpy.random.SeedSequence.spawn.html#numpy.random.SeedSequence.spawn) |

  See [What’s New or Different](https://numpy.org/doc/stable/reference/random/new-or-different.html#new-or-different) for more information.

##  随机数模块的基本使用🎈

- ```py
  import numpy as np
  # 随机数模块
  # 实例化一个默认的随机数产生器
  rng = np.random.default_rng()
  print("@rng:", rng)
  ##
  # 生成一个随机浮点数[0,1)
  rfloat = rng.random()
  print("@rfloat:", rfloat)
  ##
  # 生成一个随机整数数组(元素大小范围[0,10),包含3个随机整数
  rints = rng.integers(low=0, high=10, size=3)
  print("@rints:", rints)
  ##
  # 生成一个元素大小范围为[5,10),3行4列的随机整数矩阵
  rints = rng.integers(low=5, high=10, size=(3,4))
  print("%s@rints:"% rints)
  ##
  # 产生元素在[0,1)随机浮点数矩阵(shape=(3,3))
  arr1 = rng.random((3, 3))
  print("@arr1:\n", arr1)
  ##
  #产生元素在[-3,3)内的3行4列的随机整数矩阵
  arr2 = rng.integers(low=-3, high=3, size=(3, 4))
  print("@arr2:\n", arr2)
  ##
  #生成元素在[10,11)的3行3列随机浮点数矩阵
  arr3 = rng.random((3, 3))+10
  print("@arr3:\n", arr3)
  #生成元素在[10,15)的3行3列随机浮点数矩阵
  arr3 = rng.random((3, 3))*(15-10)+10
  print("@arr3:\n", arr3)
  ##
  # 生成0~10间的随机数浮点数
  arr4 = rng.random((3, 3))*10
  print("@arr4:\n", arr4)
  
  
  ##
  # 概率论&数理统计:符合泊松分布的数据集使用案例
  rng = np.random.default_rng()
  s = rng.poisson(5, 10000)
  count, bins, ignored = plt.hist(s, 14, density=True)
  plt.show()
  ```


- ```bash
  (d:\condaPythonEnvs\pytorch_CCSER) PS D:\repos\PythonLearn>  py tmp.py
  @rng: Generator(PCG64)
  @rfloat: 0.7232751864521993
  @rints: [4 3 6]
  @arr1:
   [[0.21711558 0.89461884 0.253653  ]
   [0.0789561  0.1810651  0.71422056]
   [0.64865338 0.92168298 0.82581813]]
  @arr2:
   [[ 2  0 -1  2]
   [-1 -1  0  1]
   [ 2  2  1 -2]]
  @arr3:
   [[10.37774146 10.38586036 10.03035809]
   [10.21706005 10.32268481 10.54266128]
   [10.34390948 10.16692222 10.23991047]]
  @arr4:
   [[7.9223881  7.4593437  2.74110034]
   [4.16468593 7.48200982 2.73602606]
   [5.66400518 2.16993866 2.65882017]]
  ```

### 随机矩阵元素精度设置

- ```python
  import numpy as np
  # a = np.arange(16).reshape(4,4)
  #rng:random generator
  # Construct a new Generator with the default BitGenerator (PCG64).
  rng = np.random.default_rng()
   
  ##
  c=rng.random(size=(4,4))
  # 保留三位小数(可以确保打印的时候每个元素的小数位数不超过3位)
  d=c.round(3)
  print(d)
  ##
  # 一种可能的实现(存在精度表示问题,仅作为一种理论上的方法)
  p=c%0.001
  # p=c%1e*3
  d=c-p
  print(d)
  #两种方式在打印的时候都不打印结尾的0串(如果有的话)
  ##矩阵转置的一种实现
  d=c.round(3)
  for i in d:
      # print(i)
      for j in i:
          print(j,end="\t")
      print()
  print("translating...","-"*10)
  l=len(d)
  for i in range(l):
      # print(i)
      for j in range(l):
          print(d[j,i],end="\t")
      print()
  
  ```

- ```bash
  0.067	0.367	0.923	0.795	
  0.086	0.041	0.033	0.969	
  0.572	0.868	0.353	0.908	
  0.196	0.508	0.374	0.743	
  translating... ----------
  0.067	0.086	0.572	0.196	
  0.367	0.041	0.868	0.508	
  0.923	0.033	0.353	0.374	
  0.795	0.969	0.908	0.743	
  ```

  

## Generator对象提供的api文档列表🎈

- [numpy.random.Generator.bit_generator](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.bit_generator.html)
- [numpy.random.Generator.integers](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.integers.html)
- [numpy.random.Generator.random](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.random.html)
- [numpy.random.Generator.choice](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.choice.html)
- [numpy.random.Generator.bytes](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.bytes.html)
- [numpy.random.Generator.shuffle](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.shuffle.html)
- [numpy.random.Generator.permutation](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.permutation.html)
- [numpy.random.Generator.permuted](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.permuted.html)
- [numpy.random.Generator.beta](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.beta.html)
- [numpy.random.Generator.binomial](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.binomial.html)
- [numpy.random.Generator.chisquare](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.chisquare.html)
- [numpy.random.Generator.dirichlet](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.dirichlet.html)
- [numpy.random.Generator.exponential](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.exponential.html)
- [numpy.random.Generator.f](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.f.html)
- [numpy.random.Generator.gamma](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.gamma.html)
- [numpy.random.Generator.geometric](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.geometric.html)
- [numpy.random.Generator.gumbel](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.gumbel.html)
- [numpy.random.Generator.hypergeometric](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.hypergeometric.html)
- [numpy.random.Generator.laplace](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.laplace.html)
- [numpy.random.Generator.logistic](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.logistic.html)
- [numpy.random.Generator.lognormal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.lognormal.html)
- [numpy.random.Generator.logseries](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.logseries.html)
- [numpy.random.Generator.multinomial](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.multinomial.html)
- [numpy.random.Generator.multivariate_hypergeometric](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.multivariate_hypergeometric.html)
- [numpy.random.Generator.multivariate_normal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.multivariate_normal.html)
- [numpy.random.Generator.negative_binomial](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.negative_binomial.html)
- [numpy.random.Generator.noncentral_chisquare](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.noncentral_chisquare.html)
- [numpy.random.Generator.noncentral_f](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.noncentral_f.html)
- [numpy.random.Generator.normal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.normal.html)
- [numpy.random.Generator.pareto](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.pareto.html)
- [numpy.random.Generator.poisson](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.poisson.html)
- [numpy.random.Generator.power](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.power.html)
- [numpy.random.Generator.rayleigh](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.rayleigh.html)
- [numpy.random.Generator.standard_cauchy](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_cauchy.html)
- [numpy.random.Generator.standard_exponential](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_exponential.html)
- [numpy.random.Generator.standard_gamma](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_gamma.html)
- [numpy.random.Generator.standard_normal](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_normal.html)
- [numpy.random.Generator.standard_t](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.standard_t.html)
- [numpy.random.Generator.triangular](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.triangular.html)
- [numpy.random.Generator.uniform](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.uniform.html)
- [numpy.random.Generator.vonmises](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.vonmises.html)
- [numpy.random.Generator.wald](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.wald.html)
- [numpy.random.Generator.weibull](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.weibull.html)
- [numpy.random.Generator.zipf](https://numpy.org/doc/stable/reference/random/generated/numpy.random.Generator.zipf.html)





