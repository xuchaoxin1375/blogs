[toc]



### 声学

- [声学控制方程和范围简介 (comsol.com)](https://cn.comsol.com/multiphysics/acoustics)
- [频谱图_百度百科 (baidu.com)](https://baike.baidu.com/item/频谱图/7709772)

### ML@DL

- 监督@无监督学习
  - [一文看懂无监督学习（基本概念+使用场景+2类典型算法） (easyai.tech)](https://easyai.tech/ai-definition/unsupervised-learning/)

  - 无监督学习是一种机器学习的训练方式，它**本质上是一个统计手段**，

  - 在没有标签的数据里可以<u>发现潜在的一些结构</u>的一种训练方式。

  - **通过无监督学习，我们可以快速把行为进行分类，虽然我们不知道这些分类意味着什么，但是通过这种分类，可以快速排出正常的用户，更有针对性的对异常行为进行深入分析**

- **硬标签**和**软标签**两个概念，在生成模型中我们使用软标签（即使用数据作为每一类的概率），而在自学习中使用的是硬标签（即强行根据设定的方法将未标注数据划归到某一类中）
- 迁移学习
  - [初识迁移学习之基础简介 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/33172587)

  - [迁移学习 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.m.wikipedia.org/zh-cn/迁移学习)

  - **迁移学习** 是属于机器学习的一种研究领域。它专注于存储已有问题的解决模型，并将其利用在其他不同但相关问题上。[[1\]](https://zh.m.wikipedia.org/zh-cn/迁移学习#cite_note-1) 比如说，用来辨识汽车的知识（或者是模型）也可以被用来提升识别卡车的能力。计算机领域的迁移学习和心理学常常提到的学习迁移在概念上有一定关系，但是两个领域在学术上的关系非常有限。

- 多任务学习（MTL:Multi-Task Learning)
  - [深度学习中的多任务学习介绍_fengbingchun的博客-CSDN博客_多任务学习深度学习算法](https://blog.csdn.net/fengbingchun/article/details/115265417)
  - 多任务学习是机器学习的一个重要组成部分，是迁移学习的一种。**多任务学习作为迁移学习的一个分支**有着其自己独特的学习背景和应用。
  - 在给定几个相关联任务的输入数据和输出数据的情况下，多任务学习能够发挥任务之间的关系，同时学习多个模型。**与单任务学习相比，主要有以下几个方面的优势**：
    - A.多任务学习通过挖掘任务之间的关系，能够得到额外的有用信息，大部分情况下都要比单任务学习的效果要好。在有标签样本比较少的情况下，单任务学习模型往往不能够学习得到足够的信息，表现较差，多任务学习能克服当前任务样本较少的缺点，从其他任务里获取有用信息，学习得到效果更好、更鲁棒的机器学习模型。
    - B.多任务学习有更好的模型泛化能力，通过同时学习多个相关的任务，得到的共享模型能够直接应用到将来的某个相关联的任务上。相比于单任务学习，上面的优点使得多任务学习在很多情况下都是更好的选择。
- 域不变特征提取
- 源域和目标域
- 多模态数据集
  - 在[人工智能](https://baike.baidu.com/item/人工智能/9180?fromModule=lemma_inlink)领域中，往往指**感知信息**，如<u>图像、文本、语音等协同</u>，帮人工智能更准确地理解外部世界。
  - 可用方法包含：双路卷积神经网络 [2] 等

- 目标域数据集标签
- 正则化约束
  - 正则化是通过对学习算法的修改，如在原约束函数上添加额外的**约束和惩罚**，<u>改善模型在测试集上的表现</u>，达到减少泛化误差、<u>提高模型泛化能力</u>的目的的技术。
  - 在实际的深度学习场景，最好的拟合模型（从最小化泛化误差的意义上）通常是一个适当正则化的大型模型。

- 学习投影矩阵
- 标签空间
- 类区分度
- 领域对齐
- MMD最大平均差异
- LMMD基于局部最大均值差异(local maximum mean discrepancy,LMMD)
- 联合学习模型
- 注意力机制
  - [注意力机制 - 维基百科，自由的百科全书 (wikipedia.org)](https://zh.m.wikipedia.org/zh-hans/注意力机制)
  - **注意力机制**（英语：attention）是[人工神经网络](https://zh.m.wikipedia.org/wiki/人工神经网络)中一种模仿[认知注意力](https://zh.m.wikipedia.org/wiki/注意)的技术。这种机制可以增强神经网络**输入数据中某些部分的权重**，同时<u>减弱其他部分的权重</u>，以此将**网络的关注点聚焦于数据中最重要的一小部分**。
  - 数据中哪些部分比其他部分更重要取决于**上下文**。可以通过[梯度下降法](https://zh.m.wikipedia.org/wiki/梯度下降法)对注意力机制进行训练。
- 低秩维特征空间
- CNN
  - [Convolutional neural network - Wikipedia](https://en.wikipedia.org/wiki/Convolutional_neural_network)
  - 卷积神经网络
  - [一文看懂卷积神经网络-CNN（基本原理+独特价值+实际应用）- 产品经理的人工智能学习库 (easyai.tech)](https://easyai.tech/ai-definition/cnn/)
- RNN
  - 递归神经网络
  - [Recurrent neural network - Wikipedia](https://en.wikipedia.org/wiki/Recurrent_neural_network)
- LSTM
  - 长短期记忆(是RNN的扩展)
  - [Long short-term memory - Wikipedia](https://en.wikipedia.org/wiki/Long_short-term_memory)
- DANN
  - 领域对抗神经网络(domain adversarial neural network,DANN)
- CCEmoGAN
  - 条件循环情感生成对抗网络(conditional cycle emotion generative adversarial network,CCEmo GAN)

- 传统的机器学习方法主要是基于单任务的学习(Single-task Learning)模式进行学习，对于复杂的学习任务也可将其分解为多个独立的单任务进行学习，然后对学习得到的解决进行组合，得到最终的结果

- [一文读懂机器学习分类算法（附图文详解） - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/82114104)
  - 一文读懂机器学习分类算法（附图文详解）
    - 监督学习
    - 分类问题
      - 逻辑回归
      - K-近邻算法（K-NN）
      - 支持向量机（SVM）
      - 朴素贝叶斯
      - 决策树分类
    - 分类的集成算法
      - 梯度提升分类器
    - 分类器的性能
      - 混淆矩阵
      - 接受者操作曲线（ROC）和曲线下的面积（AUC）
      - 文章被以下专栏收录
    - 大数据分析·人工智能

- 分类是一种基于一个或多个自变量确定因变量所属类别的技术