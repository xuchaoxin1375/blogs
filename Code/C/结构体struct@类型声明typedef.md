[toc]

## struct

C语言中`struct name { }`定义的结构体类型,在定义变量时,需要使用`struct name var`这类形式来定义变量;如果想要省略`struct`,需要用`typedef`来修饰`struct name`

而在C++中,定义结构变量时,`struct`一般情况下可以省略不写

## 类型定义（typedef） 

- C 语言提供了一个称为typedef的功能，它用来建立新的数据类型名，例如，声明

```c
typedef int Length; 
```

将`Length`定义为与int具有同等意义的名字。类型`Length`可用于类型声明、类型转换等，它和类型int完全相同，例如： 

```c
Length len, maxlen; 
Length *lengths[]; 
```

类似地，声明 

```c
typedef char* String； 
```

将`String` 定义为与`char *`或字符指针同义，此后，便可以在类型声明和类型转换中使用`String`，例如： 

```c
String p, lineptr[MAXLINES], alloc(int); 
int strcmp(String, String); 
p = (String) malloc(100); 
```

注意，`typedef` 中声明的类型在变量名的位置出现，而不是紧接在关键字`typedef` 之后。`typedef` 在语法上类似于存储类 `extern`、`static` 等。

### 首字母大写

通常以大写字母作为`typedef`定义的类型名的首字母，以示区别。 

### typedef综合应用

- 这里举一个更复杂的例子：用`typedef`定义本章前面介绍的树节点。

- 用结构体定义一个树节点

  ```c
  struct tnode { /* the tree node: */ 
     char *word;           /* points to the text */ 
     int count;            /* number of occurrences */ 
     struct tnode *left;   /* left child */ 
     struct tnode *right;  /* right child */ 
  }
  ```

  

- 如下所示： 

```c
typedef struct tnode *Treeptr; //typedef (struct tnode *) Treeptr

typedef struct tnode { /* the tree node: */ 
   char *word;           /* points to the text */ 
   int count;            /* number of occurrences */ 
   struct tnode *left;   /* left child */ 
   struct tnode *right;  /* right child */ 
} Treenode; 
```

### typedef创建新关键字

上述类型定义创建了两个新类型关键字：`Treenode`（一个结构）和`Treeptr`（一个指向该结构的指针）。
这样，函数talloc可相应地修改为： 


```c
Treeptr talloc(void) 
   { 
       return (Treeptr) malloc(sizeof(Treenode)); 
   }
```

### typedef不会创建新类型


- 这里必须强调的是，从任何意义上讲，`typedef` 声明并没有创建一个新类型，它只是为某个**已存在的类型**增加了一个**新的名称**而已。`typedef` 声明也没有增加任何新的语义;
- 通过这种方式声明的变量与通过普通声明方式声明的变量具有完全相同的属性。

## 拓展

- 实际上，`typedef` 类似于`#define` 语句，但由于`typedef` 是由编译器解释的，因此它的文本替换功能要超过预处理器的能力。例如： 

```c
typedef int (*PFI)(char *, char *); 
```

这个语句有点像是在表达`typedef int (*)(char *, char *)  PFI ; ` 但是C语言中没有名称的`(*)(char *, char *)`不合法因此`PFI`放到第一个括号中`(*PFI)(char *, char *)`

该语句定义了类型`PFI` 是“一个指向函数的指针，该函数具有两个`char *`类型的参数，返回值类型为`int`”，它可用于某些上下文中，例如 

```c
PFI strcmp, numcmp; 
```

除了表达方式更简洁之外，使用`typedef`还有另外两个重要原因。
- 首先，它可以**使程序参数化**，以提高程序的可移植性。
  - 如果`typedef`声明的数据类型同机器有关，那么，当程序移植到其它机器上时，只需改变`typedef`类型定义就可以了。一个经常用到的情况是，对于各种不同大小的整型值来说，都使用通过typedef 定义的类型名，然后，分别为各个不同的宿主机选择一组合适的`short、int 和 long` 类型大小即可。
  - 标准库中有一些例子，例如`size_t`和`ptrdiff_t`等。 

- typedef 的第二个作用是为程序提供更好的说明性——`Treeptr` 类型显然比一个声明为指向复杂结构的指针更容易让人理解。 


----

