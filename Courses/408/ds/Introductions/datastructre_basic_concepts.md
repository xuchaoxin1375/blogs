@[toc]

# 数据结构三要素/逻辑结构和物理存储结构/线性表与顺序表链表/队列与循环队列

## ref

- [Data structure - Wikipedia](https://en.wikipedia.org/wiki/Data_structure)

##  数据结构的基本概念和内容(三要素)（outline)

- In [computer science](https://en.wikipedia.org/wiki/Computer_science), a **data structure** is a [data](https://en.wikipedia.org/wiki/Data) organization, management, and storage format that is usually chosen for [efficient](https://en.wikipedia.org/wiki/Efficiency) [access](https://en.wikipedia.org/wiki/Data_access) to data.[[1\]](https://en.wikipedia.org/wiki/Data_structure#cite_note-1)[[2\]](https://en.wikipedia.org/wiki/Data_structure#cite_note-2)[[3\]](https://en.wikipedia.org/wiki/Data_structure#cite_note-3) 
- More precisely, a data structure is **a collection of**
  -  **data values**, 
  - the **relationships** among them, 
  - and **the functions or operations** that <u>can be applied to the data</u>,[[4\]](https://en.wikipedia.org/wiki/Data_structure#cite_note-4) 
  - i.e., it is an [algebraic structure](https://en.wikipedia.org/wiki/Algebraic_structure) about [data](https://en.wikipedia.org/wiki/Data).

- 逻辑结构
- 存储结构
- 数据运算/操作



- 一种具体的数据结构体现了这三方面
  - 例如,链队列,
    - 它的逻辑结构是队列
    - 它的物理结构(存储结构)是链式存储
    - 操作集是队列所具有的,pop/push/get/等

- 在面向对象程序设计中的编写类(class)的完整过程,就很好的体现了数据结构的三要素

## ADT(抽象数据类型)

- Data structures serve as the basis for [abstract data types](https://en.wikipedia.org/wiki/Abstract_data_type) (ADT). 
  - The ADT **defines** the logical form of the data type. 
  - The data structure **implements** the physical form of the data type.[[5\]](https://en.wikipedia.org/wiki/Data_structure#cite_note-5)
- Different types of data structures are suited to different kinds of applications, and some are highly specialized to specific tasks. 
  - For example, relational databases commonly use [B-tree](https://en.wikipedia.org/wiki/B-tree) indexes for data retrieval,[[6\]](https://en.wikipedia.org/wiki/Data_structure#cite_note-6) while [compiler](https://en.wikipedia.org/wiki/Compiler) implementations usually use [hash tables](https://en.wikipedia.org/wiki/Hash_table) to look up identifiers.[[7\]](https://en.wikipedia.org/wiki/Data_structure#cite_note-7)
- Data structures provide a means to manage large amounts of data efficiently for uses such as large [databases](https://en.wikipedia.org/wiki/Database) and internet indexing services. 
  - Usually, efficient data structures are key to designing efficient [algorithms](https://en.wikipedia.org/wiki/Algorithm). 
  - Some formal design methods and [programming languages](https://en.wikipedia.org/wiki/Programming_language) <u>emphasize data structures, rather than algorithms,</u> as **the key organizing factor** in software design. 
  - Data structures can be used to organize the storage and retrieval of information stored in both [main memory](https://en.wikipedia.org/wiki/Main_memory) and secondary memory.[[8\]](https://en.wikipedia.org/wiki/Data_structure#cite_note-8)



## 逻辑结构

- 指数据元素之间的逻辑关系,从逻辑关系上描述数据

- <u>它于数据的存储结构无关,是独立于计算机的</u>

- 逻辑结构分为

  - 线性结构(三大类)

    - 一般**线性表**

      - $L=(a_1,a_2,\cdots,a_i,\cdots,a_n);n\geqslant0$
      - 它的实现方式(存储方式)可以是
        - 顺序存储,此时称为`顺序表`(存储结构上顺序表的方式是基于一片连续的物理地址)
        - 链式存储,此时称为`单链表`(单叉链表)(存储结构上链表可以不连续)
          - 可以基于数组实现`链表`
          	- 数组中的不连续元素在逻辑上可能是连续的(借助伪指针,可由数组下标实现逻辑上的连续);换句话说,逻辑上连续的元素可以不连续的分布在一个数组里,通过整形值来指向后继元素所在的下标) 
          - 即,不仅仅是链式存储才能实现链表(只是说,线性表的链式存储实现的一定是链表)
          - (比如静态链表,基于数据组实现链表)

    - (操作)受限线性表

      - stack
      - queue
      - string

    - 线性表的推广

      - array

    - 线性结构经常可以由顺序存储结构实现，也可以由链式存储实现

      

  - 非线性结构

    - 集合
    - 树形结构
      - 一般树
      - 二叉树
    - 图状结构
      - 有向图
      - 无向图

### 逻辑结构小结

- 通过上面的分析可以知道,下面这些都还是属于逻辑结构的范畴:
  - 线性结构
    - 线性表
      - 栈
      - 队列
    - ⛔注意,如果一个"名字"可以体现出存储结构,那么一般就认为他是具体的数据结构(默认包含了数据运算)
      - 顺序表:线性表的顺序存储
      - 单链表:线性表的链式存储
      - 哈希表:非线性结构的散列存储
      - 循环队列:线性结构逻辑结构(队列)的顺序存储
  - 非线性结构
    - 集合
    - 树
      - 二叉树
      - 一般树
    - 图
      - 有向图
      - 无线图

## 物理结构(存储结构)

- 数据结构在计算机中的表示
- 包括以下方面:
  - 数据元素的表示
  - 关系表示（存储数据时，通常不仅仅存储各数据元素的值，还要存储数据元素之间的关系）
    - 比如前驱、后继 
  - 用计算机语言实现的逻辑结构(依赖于计算机语言)

### 最常见的4类存储

- 存储结构主要大类:
  - 顺序存储
    - 顺序存储也可以用来实现线性结构和非线性结构(比如:树/图)
  - 链式存储
    - 注意，链式存储设计的时候，各个不同结点的存储空间可以不连续
    - 但是结点内的存储单元地址必须连续
  - 索引
  - 散列

> 前两类最为基础

### 具体存储结构举例

- 线索二叉树
  -  二叉树则是逻辑结构
  - 线索二叉树是加上线索(指针域)后的**链表结构**(链式存储结构) 

### 顺序存储和链式存储

#### 顺序存储

- 把**逻辑上相邻的元素**存储在**物理位置上也相邻**的存储单元中
  - 元素之间的关系由**存储单元的相邻**
  - 缺点是只能够使用相邻的一整块存储单元(不然就不是顺序存储了)

#### 链式存储

- 不要求逻辑上相邻物理上也相邻
  - 借助指示元素存储地址的指针(<u>广义指针</u>)来**表示**元素之间的**逻辑关系**
  - 缺点一般是存储密度较低
  - 一般能够充分利用所有存储单元,不会出现碎片现象
    - 但是也有像个别实现(比如静态链表,依然需要分配较大的连续空间)	
      - 静态链表的指针是指下一个元素在数组中的位置(下标)
      - 注意,静态链表中的元素用到数组,但是逻辑上相邻的元素在物理结构上不一定相邻,因此称呼它是链式存储
        - 而不是顺序存储!!!
    - 但是和其他链表有本质的优点在于:**<u>删除和插入元素的时候不需要移动元素</u>**

## 逻辑结构和存储结构关联

- 数据的逻辑结构和存储结构密不可分
  - 另外,逻辑结构独立于存储结构;而存储结构建立在逻辑结构上思考
  - 对于一种数据存储结构而言，必定有<u>包括它的逻辑结构</u>，
  - <u>某一种逻辑结构在计算机语言中映射其存储结构</u>
  - 相比于某一种逻辑结构和某一种数据结构,存储结构关乎代码结构,是更具体的
    - 在计算机语言编写代码上就可以看出
    - 给定一种数据结构
- 算法的设计取决于逻辑结构的选定
- 算法的**实现**取决于物理结构的采用

## 数据运算

- 施加在数据上的运算包括运算的**定义**和**实现**
  - 运算的定义是针对逻辑结构的,指出**运算的功能**
  - 运算的实现是针对存储结构的,指出运算的**具体操作步骤**

# 数据结构示例

## 线性表

- 栈,队列,循环队列这几种数据结构<u>都属于线性表</u>(逻辑结构)的范畴

  - 它们既可以通过**顺序存储**来实现也可以通过**链式存储**来实现
- 如果给定一个完整定义完整的数据结构DS,并告诉你它是线性表(从逻辑结构的角度描述),那么可以推测,它可能是
  - 栈/队列/串/数组





### 以队列为例

- 队列的顺序存储实现的可以称为顺序队列

  - ```c
    #define MaxSize 50
    typedef struct{
        ElemType data[MaxSize];
        int front,rear;
    }SequentialQueue
    ```

    

  - 顺序存储的队列基本缺点在于空间分配上不容易把握,(比如容易发生溢出或者空间利用率低下)

  - 因此,基于顺序存储结构的这一缺点,改进出来`循环队列`(任然基于顺序存储结构)实现的

    - 循环队列可以一定程度提高空间利用率以及降低溢出的发生
    - 但是在链式存储中,`循环队列`就显得多余,应为链式存储的灵活性,基本不用考虑溢出问题
    - 而且对于操作受限的线性表而言,基本操作只允许在端(队列是两端,栈只有一端)操作,没有随机访问栈内或者队列内的某个元素的需求,链式存储往往更加合适用来实现这类逻辑结构

- 队列的链式存储实现可以称为**链队列**

  - ```c
    typedef struct LinkNode{
        ElemType data;
        struct LinkNode *next;
    }LinkNode;
    typedef struct{
    	LinkNode *front,*rear;
    }LinkQueue;
    ```

### 链表

- 在[计算机科学](https://zh.wikipedia.org/wiki/電腦科學)中，**链表**（Linked list）是一种常见的基础数据结构，是一种[线性表](https://zh.wikipedia.org/wiki/线性表)(的链式实现)，
  - 但是并不会按线性的顺序存储数据，而是在每一个节点里存到下一个节点的[指针](https://zh.wikipedia.org/wiki/指標_(電腦科學))(Pointer)。
  - 由于不必须按顺序存储，链表在插入的时候可以达到O(1)的[复杂度](https://zh.wikipedia.org/wiki/複雜度)，比另一种线性表[顺序表](https://zh.wikipedia.org/wiki/顺序表)快得多，但是查找一个节点或者访问特定编号的节点则需要O(n)的时间，而顺序表相应的时间复杂度分别是O(logn)和O(1)。

#### 相关结构

[结构](https://zh.wikipedia.org/wiki/链表#结构)(wikipedia)

- [2.1单向链表](https://zh.wikipedia.org/wiki/链表#单向链表)

- [2.2双向链表](https://zh.wikipedia.org/wiki/链表#双向链表)

- [2.3循环链表](https://zh.wikipedia.org/wiki/链表#循环链表)

- [2.4块状链表](https://zh.wikipedia.org/wiki/链表#块状链表)

- [2.5其它扩展](https://zh.wikipedia.org/wiki/链表#其它扩展)

  
