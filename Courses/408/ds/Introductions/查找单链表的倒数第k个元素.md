[toc]



## 确定倒数第k个元素

确定单链表第$i$个元素和确定表的长度的时间复杂度都是O(n)

如果要确定单链表的倒数第$k$个元素,算法复杂度显然至少为O(n),本文介绍相关算法的实现

## 分析

方案1:

- 扫描整个链表,确定链表长度$n$
- 第二次扫描链表,确定链表的第$n-k+1$个元素,就是倒数第$k$个元素
- 算法复杂度仍然为O(n),但是扫描了2遍链表

方案2:

- 使用两个辅助指针变量$p,q$,让两个指针闭区间内的元素数量为$k$个(也就是差值为$k-1$(注意差值不是$k$))
  - 可将它们都初始化为头指针或首元结点指针,两种方案都可以,但是代码判断的边界地方有所不同
  - 这样当$p$走到表尾元素时(`p->next==NULL`),指针$q$就停留在倒数第$k$个元素上,就能完成算法
- 如何得到位序差值为$k-1$的指针组合$p,q$?
  - 为了记录指针前进的结点数(位置),需要一个计数变量`c`来记录
  - 首先尝试让指针$p$前进$k$个位置,如果前进成功,说明链表长度足够$k$个元素,需要的元素存在
  - 以$p,q$都初始化为首元结点为例,当$p$前进到第$k$个数据结点后,让指针$q$也和$p$指针同步前进(保持$p,q$结点的位序差值为$k-1$,此时就满足$p,q$区间内的结点数量为$k$
  - 此时同时移动$p,q$两个指针,直到指针$p$到达最后一个数据结点,那么$q$就是倒数第$k$个元素
- 这个算法只需要扫描1遍链表,只不过是2个指针同时扫描(使用一个循环就可以完成算法),算法时间复杂度还是O(n)
- **双指针法小结**
  - 初始化两个指针 `p1` 和 `p2`，都指向链表的头结点。
  - 先让 `p1` 向前移动 $k$ 个节点。
  - 然后同时移动 `p1` 和 `p2`，直到 `p1` 到达链表末尾。
  - 此时 `p2` 所指向的节点就是倒数第 $k$ 个节点。

以下这段代码用C语言编写，定义了一个单链表结构，并包含一个函数用以查找链表的倒数第 $k$ 个元素。以下是这段代码的详细信息：

```c
typedef int ElemType; // 链表数据的类型定义
typedef struct LNode
{                       // 链表节点的结构定义
    ElemType data;      // 节点数据
    struct LNode *next; // 节点链接指针
} LNode, *LinkList;

/**
 * @brief Searches for the k-th node from the end of a singly linked list recursively.
 *
 * This function takes a pointer to the head of a singly linked list and an integer k,
 * then finds and prints the data of the k-th node from the end of the list.
 * If the list has fewer than k nodes, it returns 0 indicating failure to find the node.
 * Otherwise, it prints the data and returns 1.
 *
 * @param list Pointer to the head of the singly linked list.
 * @param k The position from the end of the list to find.
 * @return int Returns 1 if the k-th node from the end is found and printed, otherwise returns 0.
 */
int Search_k(LinkList list, int k)
{                                           // 指针p、q指向第一个节点
    LNode *p = list->next, *q = list->next; // 初始化两个辅助指针,都指向首元(此时不保证首元非空)
    // 初始化很重要,不同的初始化方式会影响到后面的判断和条件语句,比如初始化为头指针和初始化为首元指针就不同
    int count = 0; // count用来统计p指针指向链表的第几个(非空)数据结点
    while (p != NULL)
    { // 遍历链表直到最后一个节点
        if (count < k)
            count++; // p指向的非空数据结点位置(当count达到k值时不再增加);显然count==k时,不会立即移动q
        else
            q = q->next; // 如果count < k只移动p(p指向第k+1个元素时,才会第一次移动q)
        p = p->next;     // p始终移动,当count到达k值 之后让p、q同步移动
    }
    // 离开while后p指向尾结点的后继（NULL)
    if (count < k) // 查找失败返回0(非空结点数量小于k)
        return 0;
    else
    {
        printf("%d", q->data); // 否则打印并返回1
    }
    return 1;
}

```

这段代码功能如下：
- **定义了链表节点的结构体** `LNode`，其中包含一个数据域 `data` 和一个指向下一节点的指针 `link`。
- **`Search_k` 函数** 用于查找倒数第 $k$ 个节点：
  - 使用两个指针 `p` 和 `q`，都指向链表的头节点。
  - 通过 `count` 变量计数，当计数达到 $k$ 时，指针 `q` 开始移动。
  - 当 `p` 遍历完链表时，指针 `q` 所指向的节点就是倒数第 $k$ 个节点。

希望这对你有帮助！如果你有任何问题或需要进一步的解释，随时告诉我。

### 小结

算法1和算法2的时间复杂度都是O(n),但是前这需要2个循环,一个辅助指针变量,后者只需要一次循环,但是需要2个辅助指针变量;两个算法都需要一个整数变量来统计当前指针处在哪一个位置上(算法2统计到$k$之后可以不再继续统计);

实际上,虽然算法1需要2次循环,但是和算法2需要做的指针刷新操作的次数是相当的,算法1内部每次循环执行1次指针刷新,而算法2内部每次循环执行大约2次刷新

## 其他方案

- 使用辅助数组`a[n]`来保存链表的第$1\sim{n}$个元素,最后扫描完链表后取出数组的倒数第$k-1$个元素就是所需要的;(`a[n-k]`)

  - 但是事先确定$n$(分配多大的数组是不能直接确定的,需要扫描完链表后才能确定$n$)
  - 但是如果都已经确定了链表的长度了,那通过一个统计结点位置的变量就可以在第二次扫描确定第$n-k+1$个元素,也就是倒数第$k$个元素,回到了方案1

- 递归法

  - 使用递归法确定单链表的倒数第 $k$ 个元素的步骤如下：

    1. **递归到底**：通过递归调用到链表的末尾，开始回溯。
    2. **计数返回**：在回溯过程中，用一个计数器来计数已经回溯了多少个节点。
    3. **找到节点**：当计数器等于 $k$ 时，该节点就是我们要找的节点。

  - ```c
    
    // 定义一个函数，用于递归地找到链表中倒数第 k 个节点
    /**
     * Recursively finds the kth node from the end of a singly linked list.
     *
     * @param head Pointer to the head of the linked list.
     * @param k The position of the node from the end to find.
     * @param count Pointer to an integer that keeps track of the current position from the end.
     * @return Pointer to the kth node from the end if found, otherwise NULL.
     * head,count 会随着递归调用发生变换,而k值始终不变(可以考虑放到外面作为外部变量)
     */
    LNode *findKthFromEndRecursive(LNode *head, int k, int *count)
    {
        // 如果链表为空，则将计数置为 0，并返回 NULL
        if (!head)
        {
            *count = 0;
            return NULL;
        }
        // 递归地调用函数，处理下一个节点(当此处调用head->next为NULL时,开始回归)
        // 此时head是最后一个数据结点(非空),此返回返回NULL
        // 在count累计到k前,都是返回NULL,直到count累计到k,返回head(倒数第k个结点(非空)),
        // 之后的回归总是返回这个倒数第k个结点
        LNode *node = findKthFromEndRecursive(head->next, k, count);
        // 增加计数
        *count += 1; // 可以统计出链表长度
        // 如果当前计数等于 k，则返回当前节点(算法主要任务完成,继续回退)
        printf("count=%d\t", *count);
        if (node)
        {
    
            printf("node.data=%d\n", node->data);
        }
        else
        {
            printf("node=NULL\n");
        }
        if (*count == k)
        {
            printf("Get target node\n");
            return head;
        }
    
        // 否则，返回之前找到的节点
        return node;
    }
    
    LNode *findKthFromEnd(LNode *head, int k)
    {
        int count = 0;
        return findKthFromEndRecursive(head, k, &count);
    }
    ```

  - 算法时间复杂度为$O(n)$,但是递归使用的辅助空间比较多,$O(n)$

### 递归法可执行代码示例



```c
#include <stdio.h>
#include <stdlib.h>

// typedef struct LNode
// {
//     int data;
//     struct LNode *next;
// } LNode;

typedef int ElemType; // 链表数据的类型定义
typedef struct LNode
{                       // 链表节点的结构定义
    ElemType data;      // 节点数据
    struct LNode *next; // 节点链接指针
} LNode, *LinkList;

LNode *createNode(int value)
{
    LNode *newNode = (LNode *)malloc(sizeof(LNode));
    newNode->data = value;
    newNode->next = NULL;
    return newNode;
}

// 定义一个函数，用于递归地找到链表中倒数第 k 个节点
/**
 * Recursively finds the kth node from the end of a singly linked list.
 *
 * @param head Pointer to the head of the linked list.
 * @param k The position of the node from the end to find.
 * @param count Pointer to an integer that keeps track of the current position from the end.
 * @return Pointer to the kth node from the end if found, otherwise NULL.
 * head,count 会随着递归调用发生变换,而k值始终不变(可以考虑放到外面作为外部变量)
 */
LNode *findKthFromEndRecursive(LNode *head, int k, int *count)
{
    // 如果链表为空，则将计数置为 0，并返回 NULL
    if (!head)
    {
        *count = 0;
        return NULL;
    }
    // 递归地调用函数，处理下一个节点(当此处调用head->next为NULL时,开始回归)
    // 此时head是最后一个数据结点(非空),此返回返回NULL
    // 在count累计到k前,都是返回NULL,直到count累计到k,返回head(倒数第k个结点(非空)),
    // 之后的回归总是返回这个倒数第k个结点
    LNode *node = findKthFromEndRecursive(head->next, k, count);
    // 增加计数
    *count += 1; // 可以统计出链表长度
    // 如果当前计数等于 k，则返回当前节点(算法主要任务完成,继续回退)
    printf("count=%d\t", *count);
    if (node)
    {

        printf("node.data=%d\n", node->data);
    }
    else
    {
        printf("node=NULL\n");
    }
    if (*count == k)
    {
        printf("Get target node\n");
        return head;
    }

    // 否则，返回之前找到的节点
    return node;
}

LNode *findKthFromEnd(LNode *head, int k)
{
    int count = 0;
    return findKthFromEndRecursive(head, k, &count);
}
int Search_k(LinkList list, int k);

int main()
{
    // 创建不带头结点的单链表
    LNode *head = createNode(0);
    head->next = createNode(1);
    head->next->next = createNode(2);
    head->next->next->next = createNode(3);
    head->next->next->next->next = createNode(4);

    int k = 2;

    // LNode *kthNode = findKthFromEnd(head, k);

    // if (kthNode)
    // {
    //     printf("The %d-th node from the end is %d\n", k, kthNode->data);
    // }
    // else
    // {
    //     printf("The list is shorter than %d nodes.\n", k);
    // }

    Search_k(head, k);
    // 释放内存
    LNode *temp;
    while (head)
    {
        temp = head;
        head = head->next;
        free(temp);
    }
    return 0;
}

/**
 * @brief Searches for the k-th node from the end of a singly linked list recursively.
 *
 * This function takes a pointer to the head of a singly linked list and an integer k,
 * then finds and prints the data of the k-th node from the end of the list.
 * If the list has fewer than k nodes, it returns 0 indicating failure to find the node.
 * Otherwise, it prints the data and returns 1.
 *
 * @param list Pointer to the head of the singly linked list.
 * @param k The position from the end of the list to find.
 * @return int Returns 1 if the k-th node from the end is found and printed, otherwise returns 0.
 */
int Search_k(LinkList list, int k)
{                                           // 指针p、q指向第一个节点
    LNode *p = list->next, *q = list->next; // 初始化两个辅助指针,都指向首元(此时不保证首元非空)
    // 初始化很重要,不同的初始化方式会影响到后面的判断和条件语句,比如初始化为头指针和初始化为首元指针就不同
    int count = 0; // count用来统计p指针指向链表的第几个(非空)数据结点
    while (p != NULL)
    { // 遍历链表直到最后一个节点
        if (count < k)
            count++; // p指向的非空数据结点位置(当count达到k值时不再增加);显然count==k时,不会立即移动q
        else
            q = q->next; // 如果count < k只移动p(p指向第k+1个元素时,才会第一次移动q)
        p = p->next;     // p始终移动,当count到达k值 之后让p、q同步移动
    }
    // 离开while后p指向尾结点的后继（NULL)
    if (count < k) // 查找失败返回0(非空结点数量小于k)
        return 0;
    else
    {
        printf("%d", q->data); // 否则打印并返回1
    }
    return 1;
}

```