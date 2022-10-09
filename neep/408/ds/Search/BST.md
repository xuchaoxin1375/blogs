@[toc]
## 二叉排序树BST

- BinarySortTree(BST)

### 二叉排序树的查找算法(非递归)

```c
BSTNode * BST_Search(BiTree T,ElemType key){
    while(T!=NULL && key!=T->data){//如果树二叉查找树T(或子树)空,或者key==T->data,直接范围T(根)结点
        if(key<T->data){//如果key小于根结点,则继续访问左子树,否则访问右子树,表现为T的更新
            T=T->lchild
        }else{
            T=T->rchild
        }
    }
    return T;
}
```

### 递归版

```cpp
BSTNode * BST_Search(BiTree T,ElemType key){
	if(T==NULL){//T==NULL,直接结束调用
        return T
    }//否则T非空
    else if(key==T->data){//good luck!找到了
          return T;//递归出口
    }// 没找到,继续往合适的子树继续找下去
    else if(key<T->data){//如果key小于根结点,则继续访问左子树,否则访问右子树,表现为T的更新
        T=T->lchild//可以分步
        BST_Search(T,key)
    }else{
        BST_Search(T->rchild,key)//或者一步到位
    }
  
}
```

## BST的维护

### 插入

- BST作为一种动态树表,树的结构通常不是一次性生成的,
  - 在查找过程中当BST树的结点不存在关键值等于给定的key的结点的时候再进行插入
  - 新key值结点N作为叶子结点插入
  - 插入在查找失败F的结点下:
    - (注意在插入之前要走一遍查找的流程,以便确定查找失败会停在那个结点)
      - 这意味着,算法得包含查找元素的逻辑
    - $如果key<F\to key,则N作为F的左孩子(F\to lchild=N)$
    - $否则,F\to rchild=N$

### 插入算法(递归版)

```py
int BST_Insert(BiTree *T,KeyType k){
    /*当原树为空,那么k将作为新值(构建一个新结点插入作为根结点)*/
    if(T==NULL){
        //整个递归函数只在这一块逻辑内执行插入操作,这保证了,只有可能在出度为1或0的结点上有插入
        T=(BiTree)malloc(sizeof(BSTNode)):
        T->data=k;
        T->lchild=T->rchild=NULL;
        return 1;
    }
    //上面这块逻辑是插入递归插入函数和递归查找函数的主要区别(如果把函数名全用F表示),它在查找(失败)的基础上试图做插入操作
    //如果BST在插入前已经有值为key的结点,在直接结束,不执行插入
    else if(k==T->data){
        return 0;
    }
    else if(k<T->data){//如果key<当前根结点关键字
    
        BST_Insert(T->lchild,k)//继续往左子树查找并插入
    }else{
		BST_Insert(T->rchild,k)//继续往右子树查找并插入
    }
}
```

### 构造BST

- 通过合适的方式(遍历要被参与构建BST的元素,对他们分别对它们调用BST_Insert函数,就可以构造出二叉排序树

- ```c
  void Creat_BST(BiTree *T,KeyType str[],int n){
  	//初始化一棵空树
      T=NULL;
  	int i=0;//计数器,累计已经插入的结点
  	while(i<n){
  		BST_Insert(T,str[i]);
          i++;
  	}
  }
  ```

### 删除BST结点

- 删除结点的操作往往比插入操作复杂一些

  - 这主要体现在被删除结点所在的位置的上下文环境种比较多,以及删除之后的剩余部部分需要维持排序二叉树的特性,要做维护操作,需要分类讨论

    - 我们记被删除的结点为z结点

    - case1:z是0度(叶子)结点,则可以直接删除,不需要进一步维护

    - case2:z是1度结点,则需要让z结点的唯一子树o(根结点)直接代替z

    - cases3:z是2度结点,则需要计算z的<u>后继s结点</u>(前驱p也是可以的),

      - 用s代替z(注意s只是后继,但未必是z的直接孩子,也可能是孙子结点...)

      - 将z删除,这个操作必定属于case1或case2

        - 根据中序遍历(二叉排序树的定义),z的后继s必然满足:

          - s->lchild=NULL(即s没有左孩子,右孩子我们不关心)

            - 如果有左孩子,那么z的后继不可能是z,顶多是z的左孩子

            - 而这又对应了两类情况:

              - s既没有左孩子,也没有右孩子(对应case1)

              - s没有左孩子,但是有右孩子(对应cases2)

                

### BST性能分析

- 最好性能是当BST是平衡树的时候,达到和二分查找一样的高性能(O($\log_2 n$))
- 最坏的情况下,形式上,退化为单链表,最差性能O(n)

## 平衡二叉树BBT/AVL树

- BBT(BalancedBinaryTree):平衡二叉树,其任意(分支)结点的左右子树的高度相差(绝对值)不超过1)

- 平衡二叉树也叫AVL树:三个发明人的首字母

  - It is the name of the inventors like you guessed. From [wiki](https://en.wikipedia.org/wiki/AVL_tree):

    > AVL tree is named after its two Soviet inventors, Georgy **A**delson-**V**elsky and Evgenii **L**andis

    Their names spell the acronym, **AVL**.

### 结点平衡因子BF(Node)

- BF:*Balance Factor*
- BF(Tree)或者BF(TreeRootNode)

- 结点N的平衡因子<u>左右子树的的高度差</u>:
  - BF(A)=H(L)-H(R)
  - H(X)子树X的高度,X=L,R
- $平衡树的平衡因子bf取值为-1,0,1(|bf|\leqslant1)$
  - BF(A)=0时,可以称为等高平衡
  - BF(A)$=\pm1$时,可以称为瑕疵平衡
- 当BST的平衡因子绝对值超过1,就需要维护

### 插入结点BBT_Insert(Node )

- 在BST的插入算法的基础上,需要做一些维护平衡的判断和操作

- 判断BST方式插入后,是否引起BBT的失衡

- 主要讨论失衡的情况

  

#### 最小不平衡树MUT

- MinimunUnbalanceTree

- 设插入结点为z
- 当插入新结点z后,导致BBT失衡,那么
  - 插入z的路径上,离z最近的|BF|>1的结点记为M,以M为根结点的子树为MUT(z)
- 找MUT结点的时候,可以自底向上计算BF,遇到第一个$BF=\pm2$的时候就是失衡调整单位了
- 最小不平衡树至少是一棵具有三个结点的三层或者以上的二叉树
  - 0/1/2层的二叉树都是平衡树


### 四类失衡下的维护操作

- 插入后,引起失衡的情况无非就是BF(A)!=0(等高平衡)
  - 另外|BF(A)|=1瑕疵平衡
- 通过下列的维护操作,可以使得BF(A)在插入新结点后不超过1
- <u>***一定要注意,只有在下面这四种情况下才有维护平衡的需要,否则是徒劳的***</u>
- 设A为失衡后的MUT根结点
  - B是A的一个孩子
  - C是B的一个孩子
- 分类:
  - 单支MUT:LL/RR
  - 双支非单支MUT:LR/RL
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/4f9f66007eb844e6938db1a792676394.png)
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/c199fe28067b46ab9c273c4cd6acbdbc.png)
  - 因此,这里给出结论,对于插入引起的失衡,先找新结点C=z所在的MUT的三个结点A,B,C(必定是上述4中类型之一)
    - 再按照中序遍历的顺序写出三个结点的前后继关系,就得到左孩子,根结点,右孩子
    - 其他B或C上原来的孩子结点也是按照前后继关系调整到旋转后的三个结点上(通常是A)

#### 旋转维护平衡的要诀

- 4类情况中,无论是那种情况都是以上4中模型的一种
- 可以利用中序遍历的顺序,写出每种模型的遍历顺序(前中后三个位置的元素将作为调整后的LNR,N作为根结点位置)
  - LL:CBA
  - RR:ABC
  - LR:BCA
  - RL:ACB(以本情况为例,C是A的后继,B是C的后继)

#### 树的孩子标记法说明

##### NX型:AL/AR(BL/BR)

- N=A或B
- X=L或R

- 即AL/AR分别为(子树)根结点A的的左孩子和右孩子
- BL/BR类似

##### NXX型:ALL/ALR/BLL/BLR

- 类似上面的定义,比如,
  - ALL表示A的左孩子(L)的左子树(L)
  - ALR表示A的左孩子(L)的右孩子(R)



#### LL旋转

- 由于结点A的左孩子的左子树(LL)上被插入了新结点z,BF(A)>1(左重右轻)

- LL可以理解为新插入的结点相对于A而言是ALL的位置

  



#### RR旋转

- 和LL情况类似



#### LR旋转

- 实例
  - ![image-20221005084446305](https://img-blog.csdnimg.cn/img_convert/8ffd76bff59d43fc8018a91c0276ce1c.png)
  - ![image-20221005085024550](https://img-blog.csdnimg.cn/img_convert/f9cdde8f8874e50c8b1e8b17bcff2165.png)
  - 其中的大框包裹的三个结点就是MUT的主要上点(ABC)
    - 这里BF(A)=H(B)-H(F)=3-1=2
    - 调整成将三点按照中序遍历先后顺序分别对应于LNR
    - 即C的左右孩子将分别被改成B和A
    - 并且将C的E孩子挂到后它原来的前驱或者后继上
      - 这取决于E是C的左孩子还是右孩子
  - 

#### RL旋转

- 实例
  - ![image-20221005083124281](https://img-blog.csdnimg.cn/img_convert/30f6404a304900d965583a5f8f8c4a07.png)

## BBT删除

- 和插入操作类似,按照BST的删除方法将需要删除的结点删除掉
  - 初步删除后,可能导致BBT失衡
  - 这个时候从被删除的结点的双亲结点开始(向上)找到MUT
  - 对MUT执行四类维护操作中的一种
- 但是,一次维护对于删除而言可能是不够的,这时候继续向上找MUT,重新维护

## BBT的查找

### 递推

- [递推关系式 ](https://zh.wikipedia.org/zh-cn/遞迴關係式)
  - 线性递推
  - ...

#### 协递推

- $约定,形如F(n)=g(F(\phi_i(n)))的递推式,其中$
  - $\phi_i(n)是互不相同的$
  - $i=1,2,3,\cdots,当i\geqslant2时是协递推的$
  - 这个概念是我造的,私用(✿◡‿◡)(✿◡‿◡)(✿◡‿◡)
- 例如
  - F(n)=F(n-1)+F(n-2),Fibonacci递推(协递推)
  - F(n)=qF(n-1),等比递推
  - F(n)=d+F(n-1),等差递推

### 高度为h的BBT含有的最少结点数

- 设高度为h的平衡二叉树含有的结点数的下限值为$n_h$
  - 当h层BBT的结点数N(BBT)=$n_h$时,该BBT是**具有最少结点h层平衡二叉树MNBBT(h)(Minimum Nodes Balance Binary Tree Of h)**,简单记为MBBT(h)
- 枚举数列{$n_h$}中的前几个数
  - $n_0=0$(空树也是BBT的一种)
  - $n_1=1$
  - $n_2=2$
  - $n_3=4$
  - $\vdots$
  - $n_h$
- 容易知道,
  - $n_h>h$
  - 除了$n_0$以外,等高BBT一定不是MBBT
    - 因为,等高BBT总是可以找到删除后仍然保持平衡的叶子结点,平衡因子绝对值顶多加到1
  - MBBT去掉一个结点后,不再是MBBT(h)(不再平衡或者高度变矮)!(反证法,如果MBBT去掉一个结点x后,依然平衡,那么去掉结点x前的就不是MBBT)
  - 类似的,如果给MBBT增加一个结点,它也不再MBBT(h)(结点数不是最少的了/高度变高了)
- 事实上,由于BBT的定义是递归的,所以:
  - 而且,从自底向上的角度看,更有利于理解递推关系
  - 因为任意BBT分为左子树+根结点+右子树三部分
  - 根据定义,设$T_h$是一棵h层的BBT,
    - 根据前面的分析,如果一棵树的左右子树都是BBT(包括MBBT),且高度差不超过1,那么这个树也一定是BBT
    - $T_h$的左右子树分别是一棵矮1层或者矮2层的BBT
      - 如果希望$T_h$在保持平衡的条件下取值也是最小的(即是一棵MBBT)
        - 那么左右子树也必须都是MBBT,且这两棵MBBT高度相差1
        - 则可以设子树中较矮的一棵为高度为h-2,另一颗较高的位h-1
        - $则n_h=n_{h-1}+1+n_{h-2}$
      - 左右子树可以调换,而不会影响$n_h$的取值
  - 根据公式:$n_h=n_{h-1}+1+n_{h-2}$,可以帮助我们轻松的计算数列{$n_h$}前n个元素
    - 这个数列的递推公式和Fibonacci数列很像
    - 通过构造法,可以取出$n_h$数列的通项公式的
      - [math_数学表达式&等式方程的变形&组合/构造操作](https://blog.csdn.net/xuchaoxin1375/article/details/125514117)

#### 性能

- $平衡树的平均查找长度为O(\log_2n)$
