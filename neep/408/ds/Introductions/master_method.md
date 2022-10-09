@[toc]
# overview
主定理:
![在这里插入图片描述](https://img-blog.csdnimg.cn/2021062108133223.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2021062108140193.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210615123505174.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

我们涉及了三种渐进记号($\Theta,O,\Omega$)来描述主定理的三种情况:

相关的记号含义和例子,参看

- [algorithm_算法分析引入的记号_复杂度分析符号_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/117921380)

#  master method:

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614203538699.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614203432675.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

-  $T(n):算法所有语句的频度之和$

-  $f(n): 语句的频度(一个关于n的表达式(函数))$


## case1:
 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614203751734.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614203503898.png)
这里$n^{\log_{b}{a}}/f(n)比例因子factor=n^{2}/n=n^{1}$
因子满足满足多项式级别:其中$\varepsilon=1$
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210615125019112.png)


##  case2:

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614205127127.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614205141217.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210615125039914.png)

## case3$\bigstar$

- (需要判断正则化规则:regularity condition )

- 幸运的是,大多数多项式界中的函数都满足该正则化条件


![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614205205981.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2021061420521320.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210615125056757.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210615125126947.png)

#  局限性:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210615172020878.png)



# 粗略的记忆：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614205314534.png)

$$
T(n)=增长的快的\\
 如果是增长的速度的量级不足n^𝜀 （比如只有logn量级的)\\
 \\
 那么把增长的n^{\log_{b}{a}}
 乘上一个lgk+1n
$$


## 拓展例题：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614205233545.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210614205245458.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)




​	