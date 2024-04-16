以k折交叉验证为例，说明次级训练集的生成过程

1. 初始训练集$D$被随机划分为k个大小相似的集合$D_1,D_2,\cdots,D_k$。
2. 令$D_j$和$\overline{D_j}=D\backslash{D_{j}}$分别表示第$j$折的测试集和训练集。
3. 给定$T$个初级学习算法,初级学习器$h_{t}^{(j)}$通过在$\overline{D_{j}}$上使用第$t$个学习算法而得。
4. 对$D_j$(测试集)中每个样本$\boldsymbol{x}_i$，令 $z_{it}=h_t^{(j)}(\boldsymbol{x}_i)$，($i$表示$D_j$的第$i$个样本，而t表示第t个学习算法,设$D_j$中含有$p\approx{m/k}$个样本,由于交叉验证完成后所有样本都等完成映射，$p$值仅做参考)。
5. 则由$\boldsymbol{x}_i$所产生的**次级训练样例**的<u>示例部分</u>为$\boldsymbol{z}_i=(z_{i1};z_{i2};\cdots;z_{iT})$，<u>标记部分</u>为$y_i$.(注意到,此时示例的维数此时是`T`,和元学习器的个数一致)，示例维数变换关系：$\boldsymbol{x}_i\in{\mathbb{R}^{U}}
   \to{\boldsymbol{z}_i}\in{\mathbb{R}^{T}}$。
6. 在整个交叉验证过程结束后,从这T个初级学习器产生的**次级训练集**是$D'=\{(\boldsymbol{z}_i,y_i)\}_{i=1}^{m}$,然后$D'$将用于训练次级学习器。
