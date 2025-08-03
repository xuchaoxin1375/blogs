[toc]

## 常见死循环

| 编号 | 类型                                              | 典型示例（简化）                   | 死循环原因                                   | 建议解决方式                                                 |
| ---- | ------------------------------------------------- | ---------------------------------- | -------------------------------------------- | ------------------------------------------------------------ |
| 1    | 明确死循环 (`while True`)                         | `while True:\n  do_something()`    | 没有 `break`，永远执行                       | 添加退出条件，如输入/时间/状态；加 `break` 控制              |
| 2    | 循环变量未更新                                    | `while x > 0:\n  print(x)`         | 条件变量未变化，循环条件永远满足             | 确保变量如 `x -= 1` 在每轮循环中更新                         |
| 3    | 更新方向错误                                      | `while x > 0:\n  x += 1`           | 变量反向更新，条件永不为 False               | 修正为正确的更新方向，例如改为 `x -= 1`                      |
| 4    | 条件变量作用域错误                                | `def f(): flag = False`            | 局部变量未影响外部条件，导致外层循环条件不变 | 使用 `global` 或 `nonlocal` 正确修改外部变量                 |
| 5    | `for` 循环配合无限迭代器                          | `for x in infinite():`             | 自定义或误用无限迭代器，导致永不结束循环     | 加入退出判断，或使用有限数据结构                             |
| 6    | 输入判断永远无法满足                              | `while input() != "q":`            | 用户输入总是错误，循环永不终止               | 限制重试次数、设置默认退出条件                               |
| 7    | `try` 异常使变量未更新                            | `try: x = int(input()) except:`    | 异常发生导致变量未变，条件始终成立           | 在 `except` 中合理设置或提示退出                             |
| 8    | 条件写法错误                                      | `while x = 1:`（或拼错变量）       | 写法错误或变量名拼错，实际循环条件总为 True  | 仔细检查条件语句，避免拼写和逻辑错误                         |
| 9    | 缺少退出语句                                      | `if found:\n  print("yes")`        | 找到目标但未加 `break`，继续循环             | 找到目标后及时退出，如 `break` 或 `return`                   |
| 10   | 多线程状态未同步                                  | `while not shutdown:`              | 多线程变量未共享或未同步，主线程无法察觉变化 | 使用 `threading.Event` 或其他同步机制                        |
| 11   | 异步条件未触发                                    | `while not stop_flag:` 异步未更新  | 协程或事件未触发，条件永不变                 | 使用 `asyncio.Event` 或 await 合理协作                       |
| 12   | 用户输入永远错误导致死循环                        | `while input("pw") != correct:`    | 用户可能永远输错密码                         | 增加最大尝试次数、超时退出等限制                             |
| 13   | `for`循环遍历列表的过程中被遍历的列表元素持续增加 | `for item in lst: lst.append(...)` | 列表中的元素永远遍历不完                     | 检查变量名的引用是否混淆,使用断点调试进行调试(这种死循环的特点是计算机内存快速被耗尽,机器迅速变得卡顿,即便cpu强大也是如此,是最严重的死循环类型之一,语法检查可能不会报告潜在的错误) |

本文主要讨论变量名命名不当或错误引用引起死循环与快速耗尽内存的案例

将代码片段询问AI,也是检查死循环的简便方法,通常可以快速定位问题,包括最后一种情况

## for循环遍历列表时增加列表元素

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

然而,语句`names = domains.get("items", [])`中,`=`右边赋值给`names`(覆盖掉了`if`语句上面的`names=[]`,一般是不经意的取名不当造成的),而且下面的for循环在遍历names列表的时候,一直调用`names.append()`方法往`names`中增加元素,这就导致`names`中的元素数量一直在增加,且永远遍历不玩,导致死循环,最终内存枯竭,计算机卡死

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



