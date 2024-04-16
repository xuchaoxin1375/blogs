[toc]



# Pandas starter

- [UserGuide:10 minutes to pandas — pandas 1.4.2 documentation (pydata.org)](https://pandas.pydata.org/docs/user_guide/10min.html)

##  starter:学习第一步

### numpy ndarray vs pandas Series and datafram

- NumPy ndarray是一个多维数组对象，其中的所有元素必须是相同类型的。它是用于数值计算和科学计算的核心库之一，提供了高效的数据操作和运算。

  而Pandas Series和DataFrame是基于NumPy构建的数据结构，用于处理具有异构数据类型的表格数据。Series是一个带有标签的一维数组，可以存储任何数据类型；而DataFrame则是一个带有标签的二维表格数据结构，可以包含多个Series，并且支持列级别的操作。

  总的来说，NumPy ndarray适合处理具有相同数据类型的数值型数据，而Pandas Series和DataFrame则更适合处理具有异构数据类型的表格数据。

- 假设我们有一份数据集，其中包含了不同城市的房价、面积和人口数量等信息。如果我们想要进行数值计算或科学统计分析，比如计算平均房价或者人口密度等，那么使用NumPy ndarray是最为合适的选择。

  但是，如果我们需要对这个数据集进行更加复杂的操作，比如筛选出某些城市的房价高于平均值的记录，并将它们保存在一个新的数据集中，这时候就需要使用Pandas Series和DataFrame了。

  具体来说，我们可以使用Pandas读取数据集并将其转换为DataFrame对象。然后，我们可以针对其中的每一列数据创建一个Series对象，并通过Series对象进行相应的筛选和操作。例如，我们可以使用DataFrame对象的groupby方法对数据进行分组，然后计算每组数据的平均值，并将结果保存在一个新的DataFrame对象中。这样，我们就可以方便地进行数据探索和分析了。

###  pandas数据结构概念

- [first article to read](https://pandas.pydata.org/docs/getting_started/intro_tutorials/01_table_oriented.html#min-tut-01-tableoriented)

###  十分钟了解pandas的基本特性

- [UserGuide:10 minutes to pandas — pandas 1.4.2 documentation (pydata.org)](https://pandas.pydata.org/docs/user_guide/10min.html)

## references

- [Getting started(入门)](https://pandas.pydata.org/docs/getting_started/index.html)
- [User Guide(进一步)](https://pandas.pydata.org/docs/user_guide/10min.html)
- [api reference(专业需求)](https://pandas.pydata.org/docs/reference/io.html)
- [搜索引擎](cn.bing.com)
  - (使用搜索引擎来获取特定问题的解决方案,在入门篇的时候也可以穿插使用来快速解惑
  - 然而,我还是认为,先将getting started看完,有了基本概念在看各种解决方案才是高效的

##  DataFrame&Series

- [pandas.DataFrame — pandas 1.4.2 documentation (pydata.org)](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html)

### 取多列数据(得到子集dataframe)

- 无论是单列还是多列,使用`[[]]`得到的数据都是dataframe
- `[]`取得的数据如果是单列的,那么就是Series类型的

## 

### Boolean indexing

Using a single column’s values to select data:

```
In [39]: df[df["A"] > 0]
Out[39]: 
                   A         B         C         D
2013-01-01  0.469112 -0.282863 -1.509059 -1.135632
2013-01-02  1.212112 -0.173215  0.119209 -1.044236
2013-01-04  0.721555 -0.706771 -1.039575  0.271860
```

Selecting values from a DataFrame where a boolean condition is met:

```
In [40]: df[df > 0]
Out[40]: 
                   A         B         C         D
2013-01-01  0.469112       NaN       NaN       NaN
2013-01-02  1.212112       NaN  0.119209       NaN
2013-01-03       NaN       NaN       NaN  1.071804
2013-01-04  0.721555       NaN       NaN  0.271860
2013-01-05       NaN  0.567020  0.276232       NaN
2013-01-06       NaN  0.113648       NaN  0.524988
```

Using the [`isin()`](https://pandas.pydata.org/docs/reference/api/pandas.Series.isin.html#pandas.Series.isin) method for filtering:

```python
In [41]: df2 = df.copy()

In [42]: df2["E"] = ["one", "one", "two", "three", "four", "three"]

In [43]: df2
Out[43]: 
                   A         B         C         D      E
2013-01-01  0.469112 -0.282863 -1.509059 -1.135632    one
2013-01-02  1.212112 -0.173215  0.119209 -1.044236    one
2013-01-03 -0.861849 -2.104569 -0.494929  1.071804    two
2013-01-04  0.721555 -0.706771 -1.039575  0.271860  three
2013-01-05 -0.424972  0.567020  0.276232 -1.087401   four
2013-01-06 -0.673690  0.113648 -1.478427  0.524988  three

In [44]: df2[df2["E"].isin(["two", "four"])]
Out[44]: 
                   A         B         C         D     E
2013-01-03 -0.861849 -2.104569 -0.494929  1.071804   two
2013-01-05 -0.424972  0.567020  0.276232 -1.087401  four
```


##  pandas数据的读入和写出

> - 支持二进制文件(excel等)
> - 文本文件(csv等)

- pandas.read_excel()
- pandas.read_csv()
- ....

## pandas read excel/csv file skip header

> - [关于dataFrame的标题行的若干问题的解决方案(header row)](https://www.delftstack.com/howto/python-pandas/how-to-add-header-row-to-a-pandas-dataframe/)

> - dataframe的数据行插入/追加操作大多基于对应的表头,如果读入数据的时候将没有表头,应当使用参数告诉pandas,否则第一行正文被当作是header,不正确的表头也使得基于表头的操作难以利用
> - 总之,在读入的时候就把表头解决了(如果没有表头可用,通过传参让pandas生成默认的表头,然后表头更名可以在读入的时候,更改)

### 读入没有表头的csv

- ![image-20220416150009519](https://img-blog.csdnimg.cn/img_convert/4b6cefff2d5e747b154bf37d1af7be73.png)
- 读入的时候指定表头:
  - ![image-20220416150047676](https://img-blog.csdnimg.cn/img_convert/7d4987dee0ced949e269995502527928.png)

### 读入没有表头的excel

- 被读取数据:(无表头(字段名),第一行(line1)数据就是正文)
  - ![image-20220416145732013](https://img-blog.csdnimg.cn/img_convert/19a6209733e320096e0409ad67c2a9f6.png)

- [How to read a excel file without taking its first row as header ? Pandas, Python - Stack Overflow](https://stackoverflow.com/questions/59797259/how-to-read-a-excel-file-without-taking-its-first-row-as-header-pandas-python)
- 由于我们的源数据没有表头,我们设置参数`header=None`,以免第一行正文被读入为表头
  - 处理方式和csv有所不同
  - 读入完毕后,我们可以对表头进行修改,使得其具有明确的含义
- ![image-20220416145645704](https://img-blog.csdnimg.cn/img_convert/24cb36b4a2463c13bc44f5dfdad67f4d.png)
- 截取前三列作为演示素材:
  - ![image-20220416150734643](https://img-blog.csdnimg.cn/img_convert/63ed90f5a42e9413f25e8d4a4588d787.png)
  - 重新设定表头header labels
    - ![image-20220416150818020](https://img-blog.csdnimg.cn/img_convert/accba9dbcd341a12916762178d48c4ea.png)

###  检查数据的读入情况

#### pandas读写文件小结

![在这里插入图片描述](https://img-blog.csdnimg.cn/efe0864b895346509218fb2fea0ee609.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_15,color_FFFFFF,t_70,g_se,x_16)

可用的方法有:

> 调用形式:df.info()...

- head
- tail
- info
- dtypes

当然还有`DataFrame.shape`来检查维度

>- `DataFrame.shape` is an attribute (remember tutorial on reading and writing, do not use parentheses for attributes) of a pandas `Series and DataFrame` containing the number of rows and columns: `(nrows, ncolumns). `
>
>- A pandas Series is 1-dimensional and only `the number of rows is returned`.


![在这里插入图片描述](https://img-blog.csdnimg.cn/5c563e25ab414ae7aeb9624b8f75fcbe.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  dataFrame操作

这里注意双重括号的含义
在截取dataFrame的多个列子集时,通过一个python list 来指定列
To select multiple columns, use a list of column names within the selection brackets [].

![在这里插入图片描述](https://img-blog.csdnimg.cn/e16cbbd80ba5460bb548ce1efb8b6f94.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
dataframe[]可以接受series关系表达式(其实该值还是series),pandas提供了一些优化的方法来代替关系表达式的符号)
例如:

- notna()
- isin()

##  loc与iloc 对dataFrame的筛选

- 一般地,`loc`依赖于具体的标签名(或者通过传入bool序列来截取dataframe的部分(子集),不依赖于dataFrame的规格(shape)
- `iloc`不依赖于具体的标签名,但是依赖于dataFrame的规格(维度,从0开始计数)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7ff84b88cb0f4251b081fab77e3459d3.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

![在这里插入图片描述](https://img-blog.csdnimg.cn/4685ac0545044a67aea5bca1de612d6d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/57b7ce42d692490f8f97c03138fa8412.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

## loc/iloc获取datafram子集的

> df.loc/df.iloc 是访问df行的有力工具(但不仅限于对行的访问)

- [pandas.DataFrame.loc — pandas 1.4.2 documentation (pydata.org)](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.loc.html)

### 类型为dataframe的子集

#### [[]]

![image-20220416125058854](https://img-blog.csdnimg.cn/img_convert/fca9d667c652b5f551c3195bacf5a584.png)

#### bool list 截取

![image-20220416125422042](https://img-blog.csdnimg.cn/img_convert/b2974252a96d14da051a17148d293683.png)

### 类型为series的子集

![image-20220416125126319](https://img-blog.csdnimg.cn/img_convert/09d76e217fe09b41efd906b982c78f49.png)

![image-20220416130857250](https://img-blog.csdnimg.cn/img_convert/4217fd088181627a957ebcfcad67f02f.png)



### dataframe/series扩增

- [Indexing and selecting data — pandas 1.4.2 documentation (pydata.org)](https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#setting-with-enlargement)

#### 对dataframe插入行

##### 基于dataframe.append()来间接插入

- 此处被插入的行newline也是一个dataframe,该对象需要配置和插入目标dataframe有一致的表头
- newline可以是多行,也可以是单行

![image-20220416133009693](https://img-blog.csdnimg.cn/img_convert/2bb1a3327639e6bb9a60580ef160b6be.png)

![image-20220416133126596](https://img-blog.csdnimg.cn/img_convert/6ccff2d848bd83d66c8bb4782c14b92f.png)

## 组织python pandas 将NULL 转化为NAN(NULL 消失问题)/排序bool & str 问题

- [python - How to treat NULL as a normal string with pandas? - Stack Overflow](https://stackoverflow.com/questions/50683765/how-to-treat-null-as-a-normal-string-with-pandas)
- [python - How to take column-slices of dataframe in pandas - Stack Overflow](https://stackoverflow.com/questions/10665889/how-to-take-column-slices-of-dataframe-in-pandas)

### 排序bool 问题

- 如果pandas 从文件中读取到`TRUE`& `FALSE`,会将其转化为bool型,而导致出错,使用`astype`指定为str(object)也无作用
- 可以考虑使用`datafram.applymap()`对元素做类型强制转化.


#### pandas 按指定列值排序

- `sort_value(by=columnName)`
  - `df = pd.DataFrame(nprand.rand(6,2), index=range(0,18,3), columns=['A', 'B'])`
  - ![image-20220423131416480](https://img-blog.csdnimg.cn/img_convert/20d51d0d0c926a60dc48d015c11bf751.png)
