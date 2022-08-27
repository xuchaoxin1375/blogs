[toc]

# 生成/得到指定范围内的随机数(数组)(基于[0,1)的随机数制作)/得到不重复的指定范围内的随机数/python随机数模块

##  特殊的

得到[0,right)内的随机数,我们可以:
通过类似`right*randomNumber`的方式得到(randomNumber属于[0,1)

##  一般的

欲要得到[left,right)范围的随机数,可以:
`left+delta*randomNumber`其中($delta=right-left$)

##  numpy为例

假设我们要得到[4,7)内的随机浮点数(不严谨的)
(同时可以指定规格为shape=(14行,2列)
```python
import numpy.random as npr
base_arr=npr.random(size=(14,2))
ret=base_arr*3+4
# base_arr
print(ret)
```
## result
```
[[6.89122681 6.10158659]
 [6.33307061 4.92960413]
 [5.8762254  5.9819728 ]
 [4.03721165 4.23484648]
 [5.24072258 6.1540796 ]
 [5.25448255 5.23909412]
 [5.5258725  6.9564065 ]
 [5.30905859 4.98276731]
 [5.05256872 6.05561397]
 [4.6796204  6.18480935]
 [4.34248753 4.27403326]
 [5.03151893 6.72885987]
 [6.63896369 6.91770448]
 [5.35079495 6.57409296]]
```
 ##  得到指定范围内的整数数组
 既然考虑使用numpy,就可以直接一步到位


```python
import numpy.random as npr
size=(14,2)# size 规格
range_int_arr=npr.randint(4,7+1,size)
print(range_int_arr)
```
## result
```


❯  py random_numpy.py
[[5 7]
 [4 7]
 [5 7]
 [5 7]
 [5 7]
 [6 4]
 [4 7]
 [7 7]
 [7 4]
 [7 7]
 [4 7]
 [4 6]
 [6 5]
 [6 6]]
```
 #  js做法
 您可以这样写
 ```js
 Math.floor(Math.random() * (max - min + 1)) + min
 ```
这里用到向下取整

##  reference link
[Math.random() - JavaScript | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Math/random)
[示例 (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Math/random#examples) 
##  得到不重复的指定范围内的随机数
###  python
>如何生成指定范围内的不重复的一批随机数/乱序数

#### python自带实现(sample)

- [random --- 生成伪随机数 — Python 3.10.4 文档](https://docs.python.org/zh-cn/3/library/random.html#random.sample)

  ```py
  population=('a', 'b', 'c', 'd')
  rand_sample_immutable2 = random.sample( population,k=len(population))
  print("@rand_sample_immutable2:", rand_sample_immutable2)
  
  #@rand_sample_immutable2: ['d', 'c', 'a', 'b']
  ```

  



####  手工实现&可能的实现方式

- 打乱数组法
在python中,可以用shuffle函数进行打乱,然后返回这个被打乱的数组(部分或者全部)
- 返回随机抽取的对象
手动生成指定范围内的序列,存储在容器中(例如列表/数组)
打乱这个序列(执行shuffle操作/或者自行实现shuffle操作)
再以这些随机(乱序)数作为key/index,到容器中取出对象
- 例如:生成指定数目(譬如20个)值在20~100内的数(20个值不重复)
- 
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

###  运行结果(某一次)

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







