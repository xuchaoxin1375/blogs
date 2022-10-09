@[toc]

# ref

- 算法导论
#  松弛操作:(relax)

## 初始化操作

- $记v.\pi表示结点v的前驱结点$

  - 在通常情况下，我们不但希望计算出最短路径权重，还希望计算出最短路径上的结点。我们对最短路径的表示与对广度优先搜索树的表示类似。

  - 给定图G=(V,E),对于每个结点,我们维持一个前驱结点$v.\pi$该前驱结点可能是另一个结点或者NIL。
  - 最短路径算法可对每个结点的$\pi$属性进行设置，这样，将从结点v开始的<u>前驱结点链</u>**反转过来**，就是从s到v的一条最短路径。

- 但是也可以用其他方式得到路径,比如设立额外的数组Path,来记录前驱结点

## 最短路径估计v.d

- 对于每个结点v来说,维持属性v.d用来记录从源顶点s到顶点v的<u>最短路径权重的上界</u>
- 并且称,v.d为s到v的<u>最短路径估计</u>

## 松弛操作(Relax)
- 根据情况修改最短路径估计v.d
	- 如果发生修改,则更新前驱
	![在这里插入图片描述](https://img-blog.csdnimg.cn/2021051614472589.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
	![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516145005324.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)



## 各个顶点保存的最短路径估计值v.d

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516144938202.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

# 最短路径不一定具有唯一性

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210516145018538.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)