# OS_文件&文件系统

## 文件系统&文件基础概念

> **文件系统的管理功能**是将其管理的**程序和数据**通过**组织为一系列文件**的方式实现的。

- 而文件则是指**具有文件名**的**若干相关元素**的`集合`。

  - **元素**通常是**记录**，
  - 而记录又是<u>一组有意义的</u>**数据项的集合**。

- 可见，基于文件系统的概念，可以把数据组成分为**三级**:

  - 数据项

    - 字段(基本数据项)
      - 最小的逻辑数据单位
      - 具有数据名&数据类型
    - 组项(组合数据项)

  - 记录

    - 一组**相关数据项的集合**,用于描述一个对象在某方面的属性

    - 区分不同记录的数据项(数据项组合)作为唯一标识一个记录的关键字(key)

    - > 类似于数据库的概念

  - 文件

    - 文件是指由创建者所定义的、具有**文件名**的**一组相关元素的集合**，可分为
      - 有结构文件
      - 无结构文件两种。
    - 在**有结构的文件**中，文件由**若干个相关记录组成**，而**无结构文件则被看成是一个字符流**。
    - 文件在文件系统中是一个**最大的数据单位**，它描述了一个**对象集**。
      - 例如，可以将一个班的学生记录作为一个文件。
    - 

### 文件&记录&数据项关系图

![image-20220524184437003](https://s2.loli.net/2022/05/24/RNkxGsWhZLDip4S.png)

![image-20220524185539749](https://s2.loli.net/2022/05/24/6hkZ2U1neXdJboC.png)

(1)I/O控制层，是**文件系统的最低层**，主要由**磁盘驱动程序**等组成，也可称为**设备驱动程序层**。
(2)基本文件系统层，主要用于**处理内存与磁盘之间数据块的交换**。
(3)基本I/O管理程序，该层用于**完成与磁盘I/O有关的事务**

- 如将文件逻辑块号转换为物理块号，
- 管理磁盘中的空闲盘块，
- I/O缓冲的指定等。

(4)逻辑文件系统，用于**处理与记录和文件相关的操作**

- ​	如允许用户和应用程序**使用符号文件名**访问**文件及记录**，
- 实现对**文件和记录的保护**等。

### 文件的逻辑结构&物理结构

- 用户所看到的文件称为逻辑文件，它是由**一系列的逻辑记录**组成的。
- 从用户的观点而言，文件的**逻辑记录是能够被存取的基本单位**。
  - 在进**行文件系统高层设计**时，所涉及的主要问题是文件的**逻辑结构**，即如何<u>将这些逻辑记录构成一个逻辑文件</u>。
  - 在进行**文件系统低层设计**时，所涉及的主要问题是文件的**物理结构**，即如何<u>将一个文件存储在外存</u>上。

### 文件的结构

在系统中的所有文件都存在着以下**两种形式的文件结构**：

- (1)文件的逻辑结构(FileLogicalStructure)
  - 这是从用户观点出发所**观察到的文件组织形式**，即文件是由**一系列的逻辑记录**组成的，是**用户可以直接处理的数据及其结构**，它**独立于文件的物理特性**，又称为**文件组织(FileOrganization),**
- (2)文件的物理结构
  - 又称为文件的**存储结构**。
  - 这是指系统将**文件**存储在**外存**上所形成的一种存储组织形式，是**用户不能看见的**。
  - 文件的物理结构不仅与**存储介质的存储性能**有关，而且与**所采用的外存分配方式**有关。

> 无论是文件的逻辑结构，还是其物理结构，都会**影响对文件的检索速度**。

#### 文件逻辑结构特点

对文件逻辑结构所提出的**基本要求**

- 首先是有助于提高对文件的**检索速度**，
  - 即在将**大批记录组成文件**时，应采用一种有利于**提高检索记录速度和效率**的**逻辑结构形式**。
- 其次是该结构应**方便对文件进行修改**，
  - 即便于<u>在文件</u>中**增加、删除和修改**一个或多个记录。
- 第三是**降低文件存放在外存上的存储费用**，
  - 即尽量减少文件**占用的存储空间**，
  - 不要求大片的**连续存储空间**。

#### 文件逻辑结构分类

文件的逻辑结构从**是否有结构**来分，可分为两大类：

##### 有结构文件



- 一类是**有结构文件**，这是指由**一个以上的记录构成的文件**，故又把它称为**记录式文件**；

  - 在记录式文件中，每个记录都用于**描述实体集中的一个实体**，各记录有着相同或不同
    数目的**数据项**。
    - 记录的长度可分为**定长和不定长**两类。
    - (1)定长记录
      - 是指文件中**所有记录的长度**都是相同的，
      - 所有记录中的**各数据项**都处**在记录中相同的位置**，<u>具有**相同的顺序和长度**</u>，文件的**长度用记录数目表示。**
      - 定长记录能有效地**提高检索记录的速度和效率**，能方便对文件进行**处理和修改**，所以这是目前较常用的一种记录格式，被广泛用于数据处理中。
    - (2)变长记录，
      - 是指文件中**各记录的长度不相同**。
      - 产生变长记录的原因可能是由于一个记录中所包含的数据项数目并不相同，
        - 如书的著作者、论文中的关键词等，
      - 也可能是数据项本身的长度不定，
        - 例如，病历记录中的病因、病史，科技情报记录中的摘要等。
      - 不论是哪一种，在处理前，每个记录的长度都是可知的。
      - 对变长记录的检索速度慢，也不便于对文件进行处理和修改。
        - 但由于变长记录很适合于某些场合的需要，所以也是目前较常用的一种记录格式，被广泛用于许多商业领域。


##### 无结构文件(特殊的有结构文件)

- 另一类是**无结构文件**，这是指由**字符流构成的文**件，故又称为**流式文件**。

  - 无结构文件
    如果说在大量的信息管理系统和数据库系统中，广泛采用了**有结构的文件**形式的话(即
    文件是由定长或变长记录构成的)，

  - 那么在系统中运行的大量的<u>源程序、可执行文件、库函数</u>等，所采用的就是**无结构的文件**形式，即流式文件。

    - 其文件的长度是**以字节为单位**的。
    - 对流式文件的访问，则是利用**读、写指针**来指出**下一个要访问的字符**。

  - > 可以把**流式文件**看做是<u>**记录式文件**</u>的一个**特例**：**一个记录仅有一个字节**。

#### 有结构文件的分类

根据文件的组织方式，可把**有结构文件**分为三类：

##### (1)顺序文件



> 在顺序文件中的记录，可以按照各种不同的顺序进行排列。一般地，可分为两种情况：

###### (1)串结构。

- 在串结构文件中的记录，通常是按存入时间的先后进行排序的，各记录之间的顺序与关键字无关。

- 在对串结构文件进行检索时，每次都必须从头开始，逐个记录地查找，直到找到指定的记录或查完所有的记录为止。显然，对串结构文件进行检索是比较费时的。

###### (2)顺序结构。

- 由用户指定一个字段作为关键字，它可以是任意类型的变量，其中最简单的是正整数，
- 为了能唯一地标识每一个记录，必须使每个记录的关键字值在文件中具有唯一性。
- 这样，文件中的所有记录就可以按关键字来排序，可以按关键字的大小进行排序，或按其英文字母顺序排序。
- 在对顺序结构文件进行检索时，还可以利用某种有效的查找算法，如折半查找法、插值查找法、跳步查找法等方法提高检索效率。
- 故顺序结构文件可有更高的检索速度和效率。









##### (2)索引文件

- 指为**可变长记录文件建立一张索引表**，为每个记录设置一个**表项**，以**加速对记录的检索速度**。


##### (3)索引顺序文件

> 这是顺序文件和索引文件相结合的产物，

- 在为每个文件建立一张索引表时，并不是为每一个记录建立一个索引表项，
- 而是**为一组记录中的第一个记录**建立一个**索引表项**。



## 记录寻址

> 为了**访问顺序文件**中的**一条记录**，首先应**找到该记录的地址**。
>
> 查找**记录地址**的方法有
>
> 隐式寻址和显式寻址方式两种。

### 隐式寻址

对于定长记录的顺序文件，的逻辑地址。

在读一个文件时，如果已知当前记录的逻辑地址，便很容易确定下一个记录为了读文件，在系统中应设置一个读指针Rptr

类似地，为了写文件，也应设置一个写指针Wptr,使之指向要写的记录的首地址

![image-20220524210206467](https://s2.loli.net/2022/05/24/U4TgyGLEhNwZXIz.png)

![image-20220524210218208](https://s2.loli.net/2022/05/24/ApdgwLJtzXUGrW6.png)

### 显式寻址方式

- 该方式可用于对**定长记录**的文件实现**直接或随机访问**。
- 因为**任何记录的位置都很容易通过记录长度**计算出来。
- 而对于**可变长度记录的文件则不能利用显式寻址方式实现**直接或随机访问，必须增加适当的支持机构方能实现。

#### 两种方式对定长记录实现随机访问

- 通过文件中记录的位置

- 利用关键字

## 索引文件(IndexFile)

> - 优化定位特定记录的检索时间()

索引文件(IndexFile)
- 按**关键字**<u>建立索引</u>
- 定长记录的文件可以通过简单的计算，很容易地**实现随机查找。**
- 但**变长记录文件**查找一个记录必须从第一个记录查起，一直顺序查找到目标记录为止，耗时很长。
  - 如果我们为变长记录文件建立一张索引表，为主文件中的**每个记录在索引表**中分别设置一个**表项**，
    - 记录**指向记录的指针**(即记录在逻辑地址空间的首址)以及
    - 记录的**长度,**
  - 索引表**按关键字排序**，
  - 因此其本身也是一个**定长记录**的**顺序文件**，
  - 这样就把对变长记录顺序文件的**顺序检索**转变为对定长记录索引文件的**随机检索**，从而加快对记录检索的速度，实现直接存取
- ![image-20220524211428281](https://s2.loli.net/2022/05/24/z59uRrFpCYDWqyl.png)![image-20220524211457695](https://s2.loli.net/2022/05/24/oZeb3BOdxr6KwRX.png)

- 由于是按关键字建立的索引，所以在对索引文件进行检索时，可以根据用户(程序)提供的关键字利用折半查找法去检索索引表，从中找到相应的表项。
- 再利用该表项中给出的指向记录的指针值去访问所需的记录。
- 而每当要向索引文件中增加一个新记录时，便须对索引表进行修改。
- 由于索引文件可有较快的检索速度，故它主要用于对信息处理的及时性要求较高的场合。

### 具有多个索引表的索引文件



- 使用按关键字建立索引表的索引文件与顺序文件一样，都只能按该关键字进行检索。
- 而实际应用情况往往是：不同的用户，为了不同的目的，希望能按不同的属性(或不同的关键字)来检索一条记录。
- 为实现此要求，需要为顺序文件建立多个索引表，即为每一种可能成为检索条件的域(属性或关键字)都配置一张索引表。
- 在每一个索引表中，都按相应的一种属性或关键字进行排序。
  - 例如，有一个图书文件，为每一本书建立了一个记录，此时可以为该文件建立多个索引表，其中第一个索引表所用的关键字是图书编号，第二个索引表所用的关键字是书名，第三个索引表所用的关键字是作者姓名，第四个索引表所用的关键字是出版时间等。
  - 这样用户也就可以根据自己的需要，用不同的关键字来进行检索。

#### 索引文件的主要优点

- 它<u>将一个需要顺序查找的文件</u>**改造成一个可随机查找的文件**，极大地提高了对文件的查找速度。
- 同时，利用**索引文件插入和删除记录**也非常方便，故索引文件己成为<u>当今应用最为广泛的一种文件形式</u>。

#### 其他特点

- 只是它<u>除了有主文件外</u>，还须**配置一张索引表**，而且**每个记录都要有一个索引项**，因此<u>增加了存储开销</u>。

##	索引顺序文件(IndexSequentialFile)

> 索引顺序文件是顺序文件和索引文件相结合的产物，能有效地克服变长记录文件的缺点，而且所付出的代价也不算太大



- 索引顺序文件是对顺序文件的一种改进，它基本上克服了**变长记录的顺序文件不能随机访问**，以及**不便于记录的删除和插入的缺点**。
- 但它仍保留了顺序文件的关键特征，即记录是按关键字的顺序组织起来的。
- 它又增加了两个新特征：
  - 一个是引**入了文件索引表**，通过该表可以实**现对索引顺序文件的随机访问**；
  - 另一个是增加了**溢出(overflow)文件**，用它来记录新增加的、删除的和修改的记录。

### 一级索引顺序文件

- 最简单的索引顺序文件只使用了一级索引。
- 其具体的建立方法是，首先将**变长记录顺序文件中的所有记录分为若干个组**，如50个记录为一个组。
- 然后**为顺序文件建立一张索引**表，并为**每组中的第一个记录**在索引表中**建立一个索引项**，
  - 其中含有**该记录的关键字**和**指向该记录的指针**。

> 索引顺序文件是**最常见的一种逻辑文件形式**



![image-20220524213206887](https://s2.loli.net/2022/05/24/zfNmOV7bJFTiDeX.png)

- 在对索引顺序文件进行检索时，
  - 首先也是利用用户（程序）所提供的关键字以及某种查找算法去检索索引表，
  - 找到该**记录所在记录组**中**第一个记录的表项**，
  - 从中得到**该记录组**<u>第一个记录</u>在**主文件中的位置**。
  - 然后，再利用顺序查找法去查找主文件，从中找到所要求的记录

### 两级索引顺序文件

> 对于一个非常大的文件，为找到一个记录而须查找的记录数目仍然很多，

- 例如，对于一个含有$10^6$个记录的顺序文件，当把它作为索引顺序文件时，为找到一个记录，平均须查找1000个记录。

- 为了进一步提高检索效率，可以为顺序文件建立多级索引，即为索引文件再建立一张索引表，从而形成两级索引表。
  - 例如，对于一个含有$10^6$个记录的顺序文件,可先为该文件建立一张低级索引表，每100个记录为一组，故低级索引表应含有$1^4$个表项，

- 在每个表项中存放顺序文件中每个组第一个记录的记录键值和指向该记录的指针，然后再为低级索引表建立一张高级索引表。

  - 这时，也同样是每100个索引表项为一组，故具有$10^2$个表项。

  - 这里的每个表项中存放的是低级索引表**每组**第一个表项中的**关键字**，以及**指向该表项的指针**。

- 此时，为找到一个具有指定关键字的记录，所需查找的记录数平均为50+50+50=150。

  - 注意，在未建立索引文件时，所需查找的记录数平均为50万个，

  - 而对于建立了一级索引的顺序索引文件，平均需查找1000次，

  - 建立两级索引的顺序索引文件，平均只需查找150次。










