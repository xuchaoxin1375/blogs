[toc]



## 变量名命名不当或错误引用引起死循环与快速耗尽内存

以下面的代码为例

```python
names = []
if "items" in domains:
    names = domains.get("items", [])
    for name in names:
        names.append(name)

```

其节选自错误代码片段的简化版本

```python
    def list_domains_names_only(self, take=10, skip=0, order_by="expirationDate"):
        """列出域名列表，只输出域名
        Args:
            take (int, optional): 获取的域名数量. Defaults to 10.
            skip (int, optional): 跳过数量. Defaults to 0.
        Returns:
            list: 域名列表
        """
        domains = self.list_domains(take=take, skip=skip, order_by=order_by)
        names = []
        if "items" in domains:
            if isinstance(domains, dict):
                names = domains.get("items", [])
                for name in names:
                    print(name)
                    names.append(name)
            else:
                print(type(names))
        return names
```

这个代码的问题的意图在于遍历所有域名(domains)信息,将域名名字存储到names列表中;

然而,语句`names = domains.get("items", [])`中,`=`右边赋值给`names`(覆盖掉了`if`语句上面的`names=[]`),而且下面的for循环在遍历names列表的时候,一直调用`names.append()`方法往`names`中增加元素,这就导致`names`中的元素数量一直在增加,且永远遍历不玩,导致死循环,最终内存枯竭,计算机卡死

```python
names = []
if "items" in domains:
    domain_names = domains.get("items", []) #将赋值号左侧的变量名更改为names之外的名字,for循环的对象对应更改,就可以避免死循环
    for name in domain_names:
        names.append(name)

```

## 小结

for循环遍历列表的过程中执行列表append或者其他增加元素的操作时(典型的情况就是收集或统计被遍历列表元素中的信息添加到另一个列表中的情况),一定要注意变量名的命名,以及引用正确的列表变量,防止死循环的出现

这种错误有些代码检查器可能检测不出来,所以需要格外注意



