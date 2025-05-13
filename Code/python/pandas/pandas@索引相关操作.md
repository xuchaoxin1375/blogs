[toc]





##  索引相关操作🎈

### 设置索引

移动某一列作为行索引

```python
# 将姓名设为索引
df_indexed = df.set_index('姓名')
print(df_indexed)
"""
     年龄  城市     薪资
姓名                 
张三  25  北京  15000
李四  30  上海  20000
王五  35  广州  25000
赵六  28  深圳  18000
钱七  32  北京  22000
"""

# 使用索引访问
print(df_indexed.loc['王五'])
"""
年龄      35
城市     广州
薪资    25000
Name: 王五, dtype: object
"""
```

### 重置索引

```python
# 重置索引
df_reset = df_indexed.reset_index()
print(df_reset)
"""
   姓名  年龄  城市     薪资
0  张三  25  北京  15000
1  李四  30  上海  20000
2  王五  35  广州  25000
3  赵六  28  深圳  18000
4  钱七  32  北京  22000
"""
```

