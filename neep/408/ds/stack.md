[toc]

# pythony异常处理/catalan数和出栈排列数

## python异常处理

- [ 错误和异常 ](https://docs.python.org/zh-cn/3/tutorial/errors.html#raising-exceptions)

### 示例:数值异常和抛出

- [Python ValueError Exception Handling Examples | DigitalOcean](https://www.digitalocean.com/community/tutorials/python-valueerror-exception-handling-examples)

## 卡特蓝数

- [卡塔兰数 wikipedia](https://zh.m.wikipedia.org/zh-hans/卡塔兰数)

```py
def factorial(n):

    if(n<0):
        # 对于非法输入(负数,我们抛出异常)
        raise ValueError(f"{n} must be a positive number!!")
    f=1
    while(n):
       f*=n
       n-=1
    return f

# print(factorial(5))
def catalan(n):
    # c=1/(n+1)*(factorial(2*n))/(factorial(n)**2)
    c=factorial(2*n)/(factorial(n+1)*factorial(n))
    return int(c)
# print(catalan(4))

# 打印前n个catalan数
def get_catalan_seq_tops(n):
    # l=[catalan(i) for i in range(1,n+1)]#如果从n=1开始计数
    print("n:catalan(n)")
    for i in range(0,n+1):#从n=0开始
        c=catalan(i)
        print(f"{i}:{c}")    
if __name__=="__main__":
    get_catalan_seq_tops(10)
#前十个: [1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796]
# PS D:\repos\PythonLearn>  py catalan.py
# n:catalan(n)
# 0:1
# 1:1
# 2:2
# 3:5
# 4:14
# 5:42
# 6:132
# 7:429
# 8:1430
# 9:4862
# 10:16796
```

### 通项

$$
C_n=\frac{1}{n+1}\binom{2n}{n} =\frac{2n!}{(n+1)!n!}
$$

### 递推

$$
C_0=1
\\
C_{n+1}=\sum\limits_{i=0}^{n}C_iC_{n-i}
=\frac{2(2n+1)}{n+2}C_n
$$

## 栈和catalan数

- 如果n个不同元素进栈{$1,2,3,4,...$}(允许栈非空的时候出栈,即使还有元素未进栈)
- 那么出栈的序列数(不同的排列数)为catalan(n)种

### 例如

> 用s表示push(入栈)
>
> 用x表示pop(出栈)

- 例如 2个元素({1,2})先后进栈(中途允许出栈),则出栈序列可能有如下2种
  - 12
    - 出入栈操作序列:(sxsx)
  - 21
    - 出入栈操作序列(ssxx)

- 例如 3个元素({1,2,3})先后进栈(中途允许出栈),则出栈序列可能有如下5种
  - 123
  - 132
  - 213
  - 231
  - 321

- 例如 4个元素({1,2,3,4})先后进栈(中途允许出栈),则出栈序列可能有如下14种

  - 1234
  - 1243
  - 1324
  - 1342
  - 1432

  

  - 2134

  - 2143

  - 2314

  - 2341

  - 2431

    

  - 3214

  - 3241

  - 3421

    

  - 4321

