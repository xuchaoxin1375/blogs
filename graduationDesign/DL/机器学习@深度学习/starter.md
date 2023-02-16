@[toc]
#  参考资料
##  overview
- [[深度学习\]什么是深度学习 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/72415675)
- [一文看懂深度学习（白话解释+8个优缺点+4个典型算法） (easyai.tech)](https://easyai.tech/ai-definition/deep-learning/)
- [通俗讲解深度学习和神经网络！ - 云+社区 - 腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1915578)


- [ 什么是深度学习？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/24097648)

- [神经网络15分钟入门！足够通俗易懂了吧 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/65472471)
##  深度学习入门框架keras
- 可能需要魔法加速打开

- [主页 - Keras 中文文档](https://keras.io/zh/)
- [一些基本概念 - Keras中文文档 (keras-cn.readthedocs.io)](https://keras-cn.readthedocs.io/en/latest/for_beginners/concepts/)



##  detial 
- github 教程项目
	-  	[DeepLearning-500-questions (gitee.com)](https://gitee.com/xuchaoxin1375/DeepLearning-500-questions)
	-  [MingchaoZhu/DeepLearning: Python for《Deep Learning》，该书为《深度学习》(花书) 数学推导、原理剖析与源码级别代码实现 (github.com)](https://github.com/MingchaoZhu/DeepLearning)
	- [nndl/nndl.github.io: 《神经网络与深度学习》 邱锡鹏著 Neural Network and Deep Learning](https://github.com/nndl/nndl.github.io)

		- [nndl.github.io/nndl-book.pdf at master · nndl/nndl.github.io](https://github.com/nndl/nndl.github.io/blob/master/nndl-book.pdf)
- [Search · 深度学习 (github.com)](https://github.com/search?o=desc&q=深度学习&s=stars&type=Repositories)

- [ Dive-into-DL-PyTorch (tangshusen.me)](http://tangshusen.me/Dive-into-DL-PyTorch/#/)

- [microsoft/ML-For-Beginners: 12 weeks, 26 lessons, 52 quizzes, classic Machine Learning for all (github.com)](https://github.com/microsoft/ML-For-Beginners#pdfs)



## 在github上搜索栏优质资源集合：
- `awesome + <keyword>`

-   对于·机器学习资源·，搜索 `awesome machine learning`


-   [try it (awesome) list](https://github.com/josephmisiti/awesome-machine-learning)

#  机器学习模型
![在这里插入图片描述](https://img-blog.csdnimg.cn/51e6f012b2e140948da6bd8aa5e10199.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
在机器学习中，通常是以线性代数的眼光来看到一些表达式的
- 输入向量$x$
- 参数向量$\theta$
- 向量在应刷上一般会议粗体来以示区别与单值变量记号

![在这里插入图片描述](https://img-blog.csdnimg.cn/6cfdeaee018d4bb7ad75a1eb7f18ea79.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)
# 神经网络
神经元结构
![在这里插入图片描述](https://img-blog.csdnimg.cn/4efbacc47cf34db0bdb644758ff4ff28.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_11,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2aff14fe0d404b9eb9d72bd95c938c3e.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)

![在这里插入图片描述](https://img-blog.csdnimg.cn/9843b11c1f964f8294dcbc805f886b48.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_16,color_FFFFFF,t_70,g_se,x_16)


##  卷积
- [如何通俗易懂地解释卷积0 - 知乎 (zhihu.com)](https://www.zhihu.com/question/22298352/answer/50940942)
-  这篇文章通过复利来解释卷积,我觉得很好
- [如何通俗易懂地解释卷积1 - 知乎 (zhihu.com)](https://www.zhihu.com/question/22298352)
- [如何通俗易懂地解释卷积2 - 知乎 (zhihu.com)](https://www.zhihu.com/question/22298352/answer/228543288)

###  wikipedia:convolution
- 在[泛函分析](https://zh.wikipedia.org/wiki/泛函分析)中，**卷积**（又称**叠积**（convolution）、**褶积**或**旋积**），是透过两个[函数](https://zh.wikipedia.org/wiki/函数) *f* 和 *g* 生成第三个函数的一种数学[算子](https://zh.wikipedia.org/wiki/算子)
- `表征函数` *f* 与经过`翻转和平移(对齐)`的 *g* `的乘积函数` 所围成的曲边梯形的面积。
- 如果将参加卷积的一个函数看作[区间](https://zh.wikipedia.org/wiki/区间)的[指示函数](https://zh.wikipedia.org/wiki/指示函数)，卷积还可以被看作是“[移动平均](https://zh.wikipedia.org/wiki/滑動平均)”的推广。
- 在理解卷积的形式化定义前,可以从特殊(具体)到一般的过程来理解(从离散到连续)


###  personal option:
 - 卷积形式化定义中,强调`加权求和的约束`
##  积分运算和初等加成运算
### 积分运算和简单的加法与乘法运算有什么关联?

- 事实上,我觉得积分运算是一种表达能力更强的运算
- 乘法运算也可以写作积分形式(到底写成那种形式取决于我们的需要,如果在高等数学中需要研究比如卷积相关的动心,为了形式上的同一,我们可能会用积分的形式来表示乘法,或者说,采用积分的形式可以更加本质的描述一些模型)