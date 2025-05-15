[toc]



## Pandas starter

- [Getting started(入门)](https://pandas.pydata.org/docs/getting_started/index.html)
  - [Getting started tutorials — pandas  documentation](https://pandas.pydata.org/docs/getting_started/intro_tutorials/index.html)
  - [First article to read |What kind of data does pandas handle?](https://pandas.pydata.org/docs/getting_started/intro_tutorials/01_table_oriented.html#min-tut-01-tableoriented)

- [User Guide(进一步)](https://pandas.pydata.org/docs/user_guide/10min.html)
- [UserGuide:10 minutes to pandas — pandas  documentation (pydata.org)](https://pandas.pydata.org/docs/user_guide/10min.html)

## references

- [api reference(专业需求)](https://pandas.pydata.org/docs/reference/io.html)



## Boolean indexing

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

- 

## pandas read excel/csv file skip header

- [关于dataFrame的标题行的若干问题的解决方案(header row)](https://www.delftstack.com/howto/python-pandas/how-to-add-header-row-to-a-pandas-dataframe/)
- dataframe的数据行插入/追加操作大多基于对应的表头,如果读入数据的时候将没有表头,应当使用参数告诉pandas,否则第一行正文被当作是header,不正确的表头也使得基于表头的操作难以利用
- 总之,在读入的时候就把表头解决了(如果没有表头可用,通过传参让pandas生成默认的表头,然后表头更名可以在读入的时候,更改)



## dataframe/series扩增

- [Indexing and selecting data setting-with-enlargementetting-with-enlargement— pandas  documentation (pydata.org)](https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#setting-with-enlargement)

### 对dataframe插入行

#### 基于dataframe.append()来间接插入

- 此处被插入的行newline也是一个dataframe,该对象需要配置和插入目标dataframe有一致的表头
- newline可以是多行,也可以是单行

![image-20220416133009693](https://img-blog.csdnimg.cn/img_convert/2bb1a3327639e6bb9a60580ef160b6be.png)

![image-20220416133126596](https://img-blog.csdnimg.cn/img_convert/6ccff2d848bd83d66c8bb4782c14b92f.png)

## element-wise

[How to create new columns derived from existing columns 如何创建从现有列派生的新列](https://pandas.pydata.org/docs/getting_started/intro_tutorials/05_add_columns.html#)

### 映射

[pandas.DataFrame.apply - pandas 文档 --- pandas.DataFrame.apply — pandas 2.2.3 documentation](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.apply.html#pandas.DataFrame.apply)

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
