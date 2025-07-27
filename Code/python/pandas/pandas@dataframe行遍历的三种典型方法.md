[toc]



dataframe对象的行遍历方法有3种典型方法,分别调用dataframe对象的`iterrows()`,`itertuples()`,`to_dict()`方法

```python

# for index, row in df.iterrows():
#     # 适合计数
#     domain = row['domain']
#     nameserver1 = row['nameserver1']
#     nameserver2 = row['nameserver2']
#     print(f"Domain: {domain}, NS1: {nameserver1}, NS2: {nameserver2}")


# for row in df.itertuples():
#     # 性能高于iterrows(),支持直接用.varname的方式访问row的属性
#     domain = row.domain
#     nameserver1 = row.nameserver1
#     nameserver2 = row.nameserver2
#     print(f"Domain: {domain}, NS1: {nameserver1}, NS2: {nameserver2}")

for row in df.to_dict("records"):
    # 遍历dataframe行的方法中，性能和可读性最高
    domain = row["domain"]
    nameserver1 = row["nameserver1"]
    nameserver2 = row["nameserver2"]
    # print(f"Parameters: {{Domain: {domain}, NS1: {nameserver1}, NS2: {nameserver2}}}")
```

