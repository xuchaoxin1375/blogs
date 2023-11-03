[toc]

-  [Youden's J statistic - Wikipedia](https://en.wikipedia.org/wiki/Youden's_J_statistic)

-  一下内容是chatgpt生成,待验证TODO

-  Informedness是对多类问题的一般化。

- 在多类分类问题中，Informedness的计算方式为所有<u>真实标签为当前类别</u>的样本被正确地预测为<u>该类别</u>的数量与所有被预测为该类别的样本数之比。
- Informedness的取值范围在-1到1之间，越接近1表示模型性能越好。Informedness是一种常用的评估多类分类模型性能的指标。

- Informedness是一种用于多类分类模型性能评估的指标，它是Youden's J统计量在多分类问题中的一般化。Informedness估计了做出明智决策的概率，计算公式如下： 

  - $$
    \text{Informedness} = \frac{\sum_{k=1}^{K} TP_{k}}{\sum_{i=1}^{K}(\sum_{j=1}^{K} TP_{ij})} - \frac{\sum_{k=1}^{K} FP_{k}}{\sum_{i=1}^{K}(\sum_{j=1}^{K} FP_{ij})}-1,
    $$

-  其中，$K$表示类别总数，$TP_{k}$表示真实标签为$k$的样本被正确地预测为$k$的数量，$TP_{ij}$表示真实标签为$i$的样本被错误地预测为$j$的数量，

- $FP_{k}$表示真实标签不为$k$的样本被错误地预测为$k$的数量，$FP_{ij}$表示真实标签不为$i$的样本被错误地预测为$j$的数量。

- 在Informedness中，第一项表示所有真实标签为当前类别的样本被正确地预测为该类别的数量与所有被预测为该类别的样本数之比的平均值，第二项表示所有真实标签不为当前类别的样本被错误地预测为该类别的数量与所有被预测为该类别的样本数之比的平均值。

- Informedness的取值范围在-1到1之间，越接近1表示模型性能越好。当Informedness为0时表示模型的预测能力等同于随机猜测，即没有预测能力。