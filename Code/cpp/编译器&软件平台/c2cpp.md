# [一文带你从C快速过渡到C++](https://blog.csdn.net/Dakhin/article/details/126355480#circle=on)

2022-08-16 18:59:54



## P0 前言

很多同学都有这样的困扰，那就是已经学过C语言了，想学习C++，结果上网一搜发现，很多教程都是"C++重零开始到入门"之类的课，很多知识和C学习是重复，没必要浪费大量的时间重头开始学起。因此为了节约时间，有了以下笔记。本人仅仅是个小白，不是什么大神，只是愿意将自己的学习笔记分享出来而已，如有错漏，欢迎指正。

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/7e2560a5f24daef2901b1d6852082ad7.png)

## P1 C标准库—注释—[条件编译](https://so.csdn.net/so/search?q=条件编译&spm=1001.2101.3001.7020)

C++中包含了C标准库的移植版本，C标准库的头文件xx.h基本上变成了cxx

| C库                  | C++库        |
| -------------------- | ------------ |
| stdio.h              | cstdio       |
| math.h               | cmath        |
| string.h             | cstring      |
| **malloc.h**(特别的) | **malloc.h** |

------

块注释：

```awk
/*...*/
```

单行注释：

```awk
//
```

条件编译

```lasso
#if 0                  #if 1                          #ifdef XXX                    #ifndef XXX      

...                    ...                             ....                          ...

#endif                 #else                           #endif                        #else

                       ...                                                            ...

					   #endif                                       		          #endif
```

------

例子：

```cpp
#define _CRT_SECURE_NO_WARNINGS 
#include <cstdio> //标准输入输出函数 
#include <cmath> 
#include <cstring> //字符串处理函数 
int main() {
	printf("hello\n");
	double x = 3.14;
	printf("%lf %lf\n", sqrt(x), sin(x));

	char s[10] = "hello";
	puts(s);
	char s2[16];
	strcpy(s2, "world");
	puts(s2);
	strcat(s2, "sdfsdf");
	puts(s2);
	printf("%d %d\n", strlen(s), strlen(s2));
	return 0;
}
```

![image-20220808153504265](https://i-blog.csdnimg.cn/blog_migrate/d46a9091ceefec7d6591027577c1ac5a.png)

------

## P2 C++标准输入输出流—名字空间

- 包含头文件#include
- cout是一个标准输出流变量（对象），代表控制台窗口
- <<是一个输出流运算符，o << x : 表示数据x输出到o
- cout是标准名字空间std的一个名字，必须加上名字空间限定std::cout
  - std::cout << “Hello world” << endl;
  - using std::cout;
  - using namespace std

```cpp
#include <iostream> //C++标准输入输出流头文件

using namespace std;

int main()
{
    cout << "hello world!" << endl;
    cout << "https://a.hwdong.com" << endl;
    cout << 3 + 4 << endl;


    double radius;
    cout << "Please enter r:\n";
    std::cin >> radius; //标准输入流对象cin 输入运算符>>

    cout << 3.14 * radius * radius << endl;

    std::cout << " *\n";
    std::cout << " * *\n";
    std::cout << " * *\n";
    return 0;
}
```

![image-20220809103518257](https://i-blog.csdnimg.cn/blog_migrate/7593c05adc1c01e476e65c6784b53914.png)

```cpp
#include <fstream> 
#include <iostream> 
#include <string> 
using namespace std;

int main() {
	ofstream oF("test.txt");
	oF << 3.14 << " " << "hello world\n";
	oF.close();
	ifstream iF("test.txt");
	double d;
	string str;
	iF >> d >> str;
	cout<<d <<" "<< str<<endl;

	return 0;
}
```

------

## P3 引用变量、引用形参、默认形参

### 1.引用变量

- 引用变量是其他变量的别名。如同一个人的外号或小名, 共用同一块内存

- 定义引用变量时必须指明其引用的是哪个变量，且不能再指向其他变量

  ```angelscript
  int a = 3;
  int &r = a;
  ```

### 2.引用形参

- C语言中函数的形参以”值传递“的方式，形参的改变不会改变实参 void Fuction(int x, int y)
- C语言中必须以指针的形式才能使形参改变时也改变形参void Fuction(int *x, int *y)
- C++中可以使用”引用形参“实现指针传参的功能，本质都是地址

![image-20220809204507305](https://i-blog.csdnimg.cn/blog_migrate/66380bce9682c0aa6b69fb575ada4ae0.png)

```cpp
#include <iostream> 
using namespace std;

void swap(int &x, int &y) //X就是a，y就是b，没有产生新的内存块
{
	int t = x;
	x = y;
	y = t;
}

int main() 
{
	int a = 3, b = 4;
	cout << a << '\t' << b << endl;
	swap(a, b);
	cout << a << '\t' << b << endl;
}
```

![image-20220809205430867](https://i-blog.csdnimg.cn/blog_migrate/99e9eeeb29f3976b6de7e33c5c1f3c9e.png)

### 3.默认形参

- 函数的默认形参必须在非默认形参右边，即一律靠右

- [函数传参](https://so.csdn.net/so/search?q=函数传参&spm=1001.2101.3001.7020)时，如果不赋值，按默认形参值执行

  ```arduino
  void add(int x = 1, int y, int z = 3);   //错误
  void add(int y, int x = 1, int z = 3);   //正确
  ```

  ```arduino
  #include <iostream> 
  using namespace std;
  
  void print(char ch, int n = 1) {
  	for (int i = 0; i < n; i++)
  		cout << ch;
  }
  
  int main() {
  	print('*'); cout << endl; //默认n=1,可以不写
  	print('*',3); cout << endl;
  	print('*',5); cout << endl;
  }
  ```

  ![image-20220809210354657](https://i-blog.csdnimg.cn/blog_migrate/6eef05a0cf5b4cc30f331a2d76d4eff0.png)

------

## P4 函数重载⭐

- C++允许同一作用域里有同名的函数，只要它们的形参列表不同。如：

  ```arduino
  int add(int x, int y);
  int add(double x, double y);
  double add(float x, float y);
  ```

- 函数名+形参列表 构成了函数的签名，与返回类型无关,不能以返回类型区分函数。

  ```csharp
  #include <iostream>
  
  using namespace std;
  
  int add(int x, int y)
  {
      return x + y;
  }
  
  double add(double x, double y)
  {
      return x + y;
  }
  
  int main()
  {
      cout << add(5, 3) << endl;
      cout << add(5.3, 7.8) << endl;
      cout << add((double) 5, 7.8) << endl;
  }
  ```

  ![image-20220809211443157](https://i-blog.csdnimg.cn/blog_migrate/f4811e46dfac8c8051fea961b5a41b05.png)

------

## P5 函数模板

- 泛化算法：用template关键字增加一个模板头，将数据类型变成类型模板参数

- 函数模板不是函数，而是产生函数的模板，使用时，加上<类型>就会自动产生该类型的函数

- 模板参数可以自动推断类型，为避免歧义，建议使用时还是加上<类型>

  ```cpp
  template<typename T> //每一个函数模板都需要加这个
  T add(T x, T y)
  {
  	return x + y;
  }
  ```

  例子：

  ```cpp
  #include <iostream>
  #include <string>
  
  using namespace std;
  
  template<typename T>
  T add(T x, T y)
  {
      return x + y;
  }
  
  int main()
  {
      cout << add(5, 3) << endl; //自动推断类型
      cout << add<double>(5, 7.8) << endl; //歧义性
      cout << add<string>("hello", " world") << endl;
  }
  ```

  ![image-20220809214933906](https://i-blog.csdnimg.cn/blog_migrate/79acb674f91d40981766fa4d8fd338f1.png)

------

## P6 用户定义类型（string、vector）

### 1.string（字符串）

- 是一个用户定义类型，表示符串

  ```nix
  string s = "hello", s2 = "world"
  ```

- 可以用成员访问运算符 ” . “访问string类的成员

  ```awk
  int a=s.size() //取大小
  s=s.substr(1,3) //取第1~3位的字符,返回字符串
  int a=s.find("orl") //查找字符串，返回所在下标
  s.insert(3,"ABCD") //在下标3前插入字符串
  s.insert(3,4,'w') //在下标3前插入4个w
  s1.swap(s2) //交换s1,s2的内容
  
  s1.append(s2) //添加s2的内容到s1：s1="123",s2="abc",->s1="123abc"
  s1.append(s2);  // s1 = "123abc"
  s1.append(s2, 1, 2);  // s1 = "123bc"
  s1.append(3, 'K');  // s1 = "123KKK"
  s1.append("ABCDE", 2, 3);  // s1 = "123CDE"，添加 "ABCDE" 的子串(2, 3)
  
  s=s.replace(2,3,"aa") //用aa替换原来字符串的第2-3位，返回字符串
  s=to_string(a) //把数值类型转化为string
  int a=stoi(s1) //把string转化为数值类型int
  float a=stof(s1) //把string转化为数值类型flloat
  
  s1.assign(s2) //用s2给s1赋值
  s1.assign(s2,2,3) //用s2的第2~3位给s1赋值
  s1.assign(10,'c') //用10个c给s1赋值
  ```

- 可以用运算符” + “、” [] “(下标运算符)，处理string

  ```awk
  s + s2 //拼接两个字符串
  s[0] = 'H' //访问s字符的第0个成员
  ```

  例子：

  ```sqf
  #include <iostream>
  #include <string>
  
  using namespace std;
  
  int main()
  {
      string s = "hello", s2("world");
      //访问运算符.
  
      cout << s.size() << endl;
      string s3 = s.substr(1, 3);
      cout << s3 << endl;
  
      string s4 = s + " " + s2;
      cout << s4 << endl; //"hello world"
  
  
      s4[0] = 'H';
      s4[6] = 'W';
      cout << s4 << endl;
  
      int pos = s4.find("orl");
      cout << pos << endl;
      s4.insert(3, "ABCD");
      cout << s4 << endl;
  
      for (int i = 0; i < s4.size(); i++)
          cout << s4[i] << "-";
      cout << "\n";
  
      string s5 = "1234.5";
      float a = stof(s5);
      cout << a << endl;
  
  }
  ```

  ![image-20220809224026835](https://i-blog.csdnimg.cn/blog_migrate/cef0155781d91565caafe6c522398b2a.png)

### 2.vector（动态数组）

在C语言中，定义了一个静态数组后，其大小就固定了，不能再改变。

而在C++中，加入了vector的类，可以随时改变数组的大小。

- 向量，类似于数组，但可以动态增长。头文件
- 是一个类模板，实例化产生一个类，如vector产生一个int类型的vector类（向量）
- 同样可以通过vector类对象去访问其成员，如成员访问函数
- 同样可以用符号运算符进行一些运算

```arduino
vector::push_back(x) //在容器最后一个位置插入元素x
vector::pop_back() //删除最后一个元素
vector::size() //返回元素个数
vector::capacity() //返回空间大小
vector::resize(n) //重新分配成员个数为n
vector::reserve(n) //重新分配空间大小为n
vector::clear() //清空容器内容，但空间没改变
vector::begin() //返回初始地址
vector::end() //返回结尾地址
    
vector::erase()//删除元素或⼀段序列
iterator erase(iterator position);
iterator erase(iterator first, iterator last);

vector::insert()//插⼊新的元素
iterator insert(iterator position, const T &x); //v.insert(v.begin()+1,3)在第1位前插入3
void insert(iterator position, size_type n, const T &x);
void insert(iterator position, InputIterator first, InputIterator last);
//第⼀个函数，在迭代器指定的位置前插⼊值为x的元素
//第⼆个函数，在迭代器指定的位置前插⼊n个值为x的元素
//第三个函数，在迭代器指定的位置前插⼊另外⼀个容器的⼀段序列迭代器first到last若插⼊新的元素后总得元素个数⼤于capacity，则重新分配空间
#include <iostream>
#include <vector>

using namespace std;

int main()
{
    vector<int> v = {7, 5, 16, 8};
    //push_back()，最后添加一个元素

    v.push_back(25);
    v.push_back(13);

    //成员函数size()、下标运算符[]
    for (int i = 0; i < v.size(); i++)
        cout << v[i] << '\t';
    cout << '\n';

    v.insert(v.begin()+1, 9); //插入不能用下标
    v.pop_back();

    for (int i = 0; i < v.size(); i++)
        cout << v[i] << '\t';
    cout << '\n';

    v.resize(2);

    for (int i = 0; i < v.size(); i++)
        cout << v[i] << '\t';
    cout << '\n';
}
```

![image-20220810220019642](https://i-blog.csdnimg.cn/blog_migrate/cfe91029bdcd5f7d98b8cf32051a4acd.png)

------

## P7 指针和动态内存分配

### 1.指针

⭐约定：指针就是地址！变量的指针就是变量的地址。

- 可以用取地址运算符&获得一个变量的地址，如&var
- 指针变量就是存储指针（地址）的变量，如Type *P; //P是存储 ”Type类型变量的地址“ 的变量
- 可以通过取内容运算符*得到一个指针变量指向的变量，如 *P就是P指向的那个变量

```cpp
/* 指针就是地址，变量的指针就是变量的地址。 指针变量就是存储指针（地址）的变量。 */

#include <iostream> 
using namespace std;

int main() {
	int a=3;
	int *p = &a;   //取地址运算符&用于获得a的地址：&a
	cout << p << '\t' << &a << endl;     //p就是a的地址
  
	//取内容运算符*用于获得指针指向的变量(内存块)
	cout << *p << '\t' << a << endl;     //*p就是a
  
	*p = 5;                              //即a = 5;
	cout << *p << '\t' << a << endl;
 
	int *q = p;             //q和p值相同，都是a的地址(指针)
	cout << *p << '\t' << *q << '\t' << a << endl;
}
```

### 2.动态内存分配（new）

- new 可以代替 molloc, 且会对对象进行初始化（在类中很有用）

 int *p = new int; // p在函数的堆栈区，new在全局共享未使用堆存储区

- delete可以代替free

  delete p; //释放p指向的内存，p本身没有被删掉

  delete[] p; //释放数组p指向的内存

```cpp
/* malloc free realloc 动态内存分配：new用于申请内存块、delete用于释放内存块 T *p = new T; delete p; T *q = new T[5]; delete[] q; */
// 堆存储区
#include <iostream>
using namespace std;

int main()
{
    int *p = new int;
    *p = 3;
    cout << p << '\t' << *p << endl;
    delete p;   //内存泄漏，释放p指向内存

    p = new int; //p又指向一个新的内存
    *p = 5;
    cout << p << '\t' << *p << endl;
    delete p;
}
```

![image-20220810223252462](https://i-blog.csdnimg.cn/blog_migrate/2b27d13e057969e5eccb63d4e19035fa.png)

------

## P8 类和对象

### 1.面向对象编程

- 传统的过程式编程：变量（对象）就是一些存储数据的内存块，而过程（函数）对这些数据进行处理。

![image-20220811124633548](https://i-blog.csdnimg.cn/blog_migrate/2244c735ae3efdc745e15a7952214a87.png)

问题：数据不安全、维护困难（一个数据错误，很多函数都可能调用）

- 面向对象编程：程序是由不同种类的许多对象相互协助完成的。对象之间通过发送/接收消息来协作完成各种任务。

![image-20220811124915969](https://i-blog.csdnimg.cn/blog_migrate/507cbd16e21d4e8cad0a5b221b4c7c4d.png)![image-20220811150942421](https://i-blog.csdnimg.cn/blog_migrate/95e834a108c27223d3d324fb1eed0c3f.png)

### 2.对象特性：用户定义类型

- 程序员定义自己的“用户定义类型”，如类类型，来表示各种应用问题中的各种概念

- C++标准库提供了很多实用的标准“用户定义类型”

  1. cout是一个ostream类的对象（变量），cin是一个istream的对象（变量）

  2. string是一个表示字符串的类。向一个string对象发送一个size()消息，查询该对象包含的字符数目

     ```sqf
     string str = "Hello world"; cout << str.size();
     ```

### 3.定义类(class)

- 用struct或class关键字定义一个类。定义的类就是一个数据类型。

  ```thrift
  struct student
  {
  	string name;
  	double score;
  }
  ```

- ```csharp
  class student{
  private:
  	string name;
  	double score;
  public: //接口
  	void print() {cout << this->name << " " << this->score << endl;}
  	string get_name() { return name; }
  	double get_score() { return score; }
  	void set_name(string n) { name = n; }
  	void set_score(double s) { score = s; }
  };
  ```

- 类类型的变量通常称为对象。如：student stu；（对象就是类的一个实例）

- 可以定义类类型的数组，存储一组类对象。如 student stus[3];

- T是一个类类型，则T *就是T指针类型。 T *变量可以指向一个类对象。

  如 student *p = &stu; (p是一个student *指针变量，可以存放一个student类型的地址)

  

![image-20220811154329818](https://i-blog.csdnimg.cn/blog_migrate/666c3a30a8ad2ab29933a7c4536240ea.png)

- 类体定义成员函数

  ```csharp
  struct student{//体内
  	string name;
  	double score;
  	void print(){cout << name << " " << score << endl;}; //函数声明
  }
  ```

  ```cpp
  struct student{//体外
  	string name;
  	double score;
  	void print(); //函数声明
  }
  void student::print(){ //函数的实现
  	cout << name << " " << score << endl;
  }
  ```

  注意：C语言中struct不能定义函数成员，而C++中可以，不过为了区分建议用class，且class有封装特性，自行决定成员公开还是私有，struct默认所有成员公开！！！

### 4.学生成绩分析

```arduino
/* 输入一组学生成绩(姓名和分数)，输出：平均成绩、最高分和最低分。 当然，也要能输出所有学生信息 */
#include <iostream>
#include <string>
#include <vector>
using namespace std;

struct student
{
    string name;
    double score;
    void print();
};

void student::print()
{
    cout << name << " " << score << endl;
}

int main()
{
    /* student stu; stu.name = "Li Ping"; stu.score = 78.5; stu.print(); */
    vector<student> students; //动态类数组

    while (1)
    {
        student stu;
        cout << "请输入姓名 分数:\n";
        cin >> stu.name >> stu.score;
        if (stu.score < 0) break;
        students.push_back(stu);
    }
    for (int i = 0; i < students.size(); i++)
        students[i].print();

    double min = 100, max = 0, average = 0;
    for (int i = 0; i < students.size(); i++)
    {
        if (students[i].score < min) min = students[i].score;
        if (students[i].score > max) max = students[i].score;
        average += students[i].score;
    }
    average /= students.size();
    cout << "平均分、最高分、最低分："
         << average << " " << max << " " << min << endl;
}
```

![image-20220811160939076](https://i-blog.csdnimg.cn/blog_migrate/e471eb6c34bc6682686455a85ac7b6ab.png)

------

------

## P9 访问控制、基础函数⭐⭐

### 1.this指针

```csharp
struct student{//体内
	string name;
	double score;
	void print(){cout << name << " " << score << endl;}; //函数声明
}
```

在类里面定义的成员函数，实际上编译器会自动转化为外部函数，并带this指针

```csharp
struct student{
	string name;
	double score;
    //void print(){cout << name << " " << score << endl;}; //函数声明
}
void print(student *this){//函数声明
	cout << this->name << " " << this->score << endl;
}; 
int main(){
    student stu;
    stu.name = "LI";
    stu.score = 88;
    stu.print(); // print(&stu) 会转化为指针参数
}
```

### 2.访问控制（封装）

private:私有的，只能通过类体内访问

public:公开的，可以在类体外访问

protected：受保护的，只能在类体内访问或在体外通过成员函数访问

```csharp
/* struct和class区别： struct里的成员默认是public(公开的) class里的成员默认是private(私有的) */
#include <iostream> 
#include <string> 
using namespace std;

class student{
public: //接口
	void print() {cout << this->name << " " << this->score << endl;}
	string get_name() { return name; }
	double get_score() { return score; }
	void set_name(string n) { name = n; }
	void set_score(double s) { score = s; }
private:
	string name;
	double score;
protected：
    string lover；
};

int main() {
	student stu;
	stu.set_name("Li Ping");
	stu.set_score(78.5);
	stu.print();   // print(&stu);
	cout << stu.get_name() << " " << stu.get_score() << endl;
}
```

### 3.构造函数

- C++在创建一个类对象的时候，会自动调用被称为“构造函数”的成员函数

- 如果没有定义构造函数，那么C++会自动生成一个构造函数：类名函数，且没有返回、没有形参，函数体里什么也不做

  ```angelscript
  class student
  {
      string name;
      double score;
  public:
      student(string n, double s)：name(n),score(s)//用列表初始化
      { 
          cout << "构造函数\n";
      }
  }
  
  /*等价于*/
      
  class student
  {
      string name;
      double score;
  public:
      student(string n, double s)：
      { 
          name = n;
          score = s;
          cout << "构造函数\n";
      }
  }
  ```

```cpp
/* 构造函数： 函数名和类名相同且无返回类型的成员函数。 */
#include <iostream>
#include <string>
using namespace std;

class student
{
    string name;
    double score;
public:
    student(string n, double s)
    { //不是默认构造函数，重载
        name = n;
        score = s;
        cout << "构造函数\n";
    }
   
    student()
    {
        cout << "构造函数" << endl;
    }

    void print()
    {
        cout << this->name << " " << this->score << endl;
    }
};

int main()
{
    student stu("LiPing", 80.5); //在创建一个类对象时会自动调用称为“构造函数”的成员函数
    stu.print();
    student students[3];
}
```

![image-20220812204708388](https://i-blog.csdnimg.cn/blog_migrate/b354d40fbd663760756f15cdeb7d6bd2.png)

### 4.拷贝构造函数

- 当我们定义一个类的新对象等于一个旧对象时，系统默认调用的是硬拷贝构造函数，即两个对象共用一个内存。

  ```arduino
  class String{
  	char *data;
  	int n;
  public:
  	String(const String &s){//系统默认硬拷贝构造函数
  		data = s.data;
  		n = s.n;
  	}
      String(const char *s = 0) //重载构造函数
      {
          if (s == 0)
          {
              data = 0;
              n = 0;
              return;
          }
          const char *p = s;
          while (*p) p++;
          n = p - s;
          data = new char[n + 1];
          for (int i = 0; i <= n; i++)
              data[i] = s[i];
      }
  }
  ```

- 但实际上我们希望定义的新对象拥有一块单独的内存，因此，需要重构 拷贝构造函数

```reasonml
class String{
	char *data;
	int n;
public:
	String(const String &s){//重载拷贝构造函数->软拷贝
		data = new char[s.n+1]; //开辟新内存
		n = s.n;
		for (int i = 0; i <= n; i++)
            data[i] = s.data[i];
	}
    String(const char *s = 0) //重载构造函数
    {
    }
}
```

例子：

```arduino
#include <iostream>

using namespace std;

class String
{
    char *data; //C风格的字符串
    int n;

public:
    String(const String &s)
    {//重载拷贝构造函数
        data = new char[s.n + 1]; //申请新的内存
        n = s.n;
        for (int i = 0; i <= n; i++)
            data[i] = s.data[i];
    }

    String(const char *s = 0)
    {//重载构造函数
        if (s == 0)
        {
            data = 0;
            n = 0;
            return;
        }
        const char *p = s;
        while (*p) p++;
        n = p - s;
        data = new char[n + 1];
        for (int i = 0; i <= n; i++)
            data[i] = s[i];
    }

    int size()
    { return n; }

    char operator[](int i) const //const对象专用的下标重载
    {
        if (i < 0 || i >= n) throw "下标非法";
        return data[i];
    }

    char &operator[](int i)
    {
        if (i < 0 || i >= n) throw "下标非法";
        return data[i];
    }

    friend ostream &operator<<(ostream &o, String s);//这里也调用了拷贝构造函数
};

ostream &operator<<(ostream &o, String s)
{
    for (int i = 0; i < s.size(); i++)
        cout << s[i];
    return o;
}

int main()
{
    String str, str2("hello world");//注意str分配的内存是0，str不能直接使用
    cout << str2 << endl;
    str2[1] = 'E';
    cout << str2 << endl;
    String const str3 = str2; //重载了拷贝构造函数，str3是单独内存
    str2[0] = 'H';
    cout << "str2: " << str2 << endl;
    cout << "str3: " << str3 << endl;

    return 0;
}
```

![image-20220813232515381](https://i-blog.csdnimg.cn/blog_migrate/8f8e6c70357045105e300dec017da02c.png)

### 5.友元函数

外部函数想要调用类的成员时，可以在类中声明该函数为友元函数。

```csharp
/*友元函数，允许外部函数访问类内部成员*/
class  student
{
	string name;
	double score;
public:
	student(string n, double s)
	{
		name = n; score = s;
	}
	friend ostream& operator<<(ostream &out, student s);//友元函数
}

ostream &operator<<(ostream &out, student s)
{
     cout << s.name << " "<< s.score << endl;
     return o;
}
```

### 6.析构函数

- 很多时候构造函数内申请动态内存，如果不及时释放掉，可能会造成内存泄漏的灾难，因此要有析构函数释放不用的内存
- 析构函数由 ~类名 构成，没有形参列表，也没有返回，后定义的先释放（堆栈类型）。
- 析构函数一般要搭配拷贝构造函数使用，否则，系统默认拷贝会让两个对象共用一块内存，而析构函数会释放两次内存，造成错误

```reasonml
class String {
	char *data; //C风格的字符串
	int n;
public:
	~String() { //重载析构函数
		cout <<n<< " 析构函数!\n";
		if(data)
			delete[] data;
	}
	String(const String &s) { //重载拷贝构造函数
		cout << "拷贝构造函数!\n";	
		data = new char[s.n + 1];		
		n = s.n;		
		for (int i = 0; i < n; i++)
			data[i] = s.data[i];
		data[n] = '\0';
	}
	String(const char *s=0) { //构造函数
	}
```

### 7.const常函数

- 基础，修饰变量

- ```csharp
  const int a=10;//a不可改
  
  const int* a = &b://整型不可修改，但指针指向可以修改，*a不可改，a可改
  
  int *const a = &b；//整型可修改，指针不可修改，*a可改，a不可改
   
  const int *const p//二者都不可以改
      
  void fun(const int i){}//i不能被修改
  ```

- 进阶，const在类函数中的作用

  1.const修饰的函数，不能修改类中的成员变量，这是const修饰函数的基本作用

  2.未重载时，非const对象和const对象都能调用这个函数

  3.重载时， const对象调用const修饰的重载函数；非const对象调用非const函数

  ```nim
  class A
  {
  public:
    void f(int i){......} //一个函数
    void f(int i) const {......} //上一个函数的重载
  };
  ```

  ```kotlin
  #include <iostream>
  #include <string>
  using namespace std;
  
  class Test
  {
  public:
      Test();
      ~Test();
      int num;
      int fun(int b);
      int fun(int b) const;
      int gun(int b) const;
  };
  
  Test::Test()
  {
      cout << "Test()" << endl;
  }
  Test::~Test()
  {
  }
  
  int Test::fun(int b)
  {
      cout << " int fun(int b);" << endl;
      num = 2;
      return 0;
  }
  
  int Test::fun(int b) const
  {
      cout << " int fun(int b) const;" << endl;
      return 0;
  }
  
  int Test::gun(int b) const
  {
      cout << " int gun(int b) const;" << endl;
      return 0;
  }
  
  int main()
  {
      Test test;
      const Test testConst;
  
      test.fun(3); //非const变量调用非const函数
      testConst.fun(3); //const变量调用const函数
      test.gun(3); //非const变量也可以调用const函数
  
      return 0;
  }
  ```

------

------

## P10 运算符重载⭐

operator

### 1.流运算符重载

- 结合P4 函数重载 学习
- c++中允许对运算符进行重载，只要他们的形参列表不一样

```kotlin
ostream& operator << (ostream &out, student s)//重载输出流
{
    cout << s.name << " "<< s.score << endl;
	return out;//引用，返回自身&,不加返回的是一个复制值
}

istream& operator>>(istream &in, student &s) //重载输入流，注意是引用s
{
	in >> s.name >> s.score;
	return in;
}
```

### 2.下标运算符

- 如果想在类中使用下标运算符，必须在成员里定义operator[]

```cpp
class Point{
	double x, y;
public:	
	double operator[](int i) const{ //const函数
  
		if (i == 0) return x;
		else if (i == 1) return y;
		else throw "下标非法!"; //抛出异常
	}
	double& operator[](int i) {
		if (i == 0) return x;
		else if (i == 1) return y;
		else throw "下标非法!"; //抛出异常  
	}
    
	Point(double x_,double y_) {
		x = x_; y = y_;
	}

	//友元函数
	friend ostream & operator<<(ostream &o, Point p);
	friend istream & operator>>(istream &i, Point &p);
};
```

### 3.加法运算符

既可以定义在类体外，也可以定义在类体内，注意两种写法不同

```perl
//类体内
class student{
public:
	Point operator+(const Point q) {
		return Point(this->x + q[0], this->y + q[1]);
	}
}

//类体外
Point operator+(const Point p,const Point q) { return Point(p[0] + q[0], p[1] + q[1]); 
```

例子：

```cpp
#include <iostream> 
#include <string> 
using namespace std;

class Point{
	double x, y;
public:	
	double operator[](int i) const{ //const函数
  
		if (i == 0) return x;
		else if (i == 1) return y;
		else throw "下标非法!"; //抛出异常
	}
	double& operator[](int i) {
		if (i == 0) return x;
		else if (i == 1) return y;
		else throw "下标非法!"; //抛出异常
    
	}
    
	Point(double x_,double y_) {
		x = x_; y = y_;
	}
	Point operator+(const Point q) {
		return Point(this->x+q[0],this->y + q[1]);
	}

	//友元函数
	friend ostream & operator<<(ostream &o, Point p);
	friend istream & operator>>(istream &i, Point &p);
};

ostream & operator<<(ostream &o, Point p) {
	o <<p.x << " " << p.y<< endl;
	return o;
}
istream & operator>>(istream &i, Point &p) {
	i >> p.x >> p.y;
	return i;
}
/* Point operator+(const Point p,const Point q) { return Point(p[0] + q[0], p[1] + q[1]); } */

int main() {
	Point p(3.5, 4.8),q(2.0,3.0);	
  
// cin >> p;
	cout << p;
	cout << p[0] << "-" << p[1] << endl; //p.operator[](0)
  
	p[0] = 3.45; p[1] = 5.67;
	cout << "p: "<<p<<"q: "<<q;	
	Point s = p + q; //p.operator+(q) vs operator+(p,q)
	cout << s;
}
```

![image-20220812224256428](https://i-blog.csdnimg.cn/blog_migrate/100e8a03ff3ad9658099d5cd5644bf2f.png)

------

------

## P11 类模板

- 类似于函数模板，类模板不是类，而是产生类的模板，可以让类代码复用

- ```cpp
  template<typename T> //创建类模板
  class Vector {
  	T *data;
  	int capacity;
  	int n;
  public:
  	Vector(int cap=3) {
  		data = new T[cap];//开辟的是3倍类型空间
  		if (data == 0) {
  			cap = 0; n = 0;
  			return;
  		}
  		capacity = cap;
  		n = 0;
  	}
  	void push_back(T e) {
  		if (n == capacity) {//空间已经满
  			cout << "增加容量！\n";
  			T *p = new T[2 * capacity];
  			if (p) {
  				for (int i = 0; i < n; i++)
  					p[i] = data[i];
  				delete[] data;
  				data = p;
  				capacity = 2*capacity;
  			}
  			else {
  				return;
  			}
  		}
  		data[n] = e;
  		n++;
  	}
  	T operator[](int i) const{
  		if (i < 0 || i >= n) throw "下标非法!";
  		return data[i];		
  	}	
  	int size() {
  		return n;
  	}
  };
  
  int main() {	
  	Vector<int> v; //可以定义任意类型变量
  	v.push_back(3);
  	v.push_back(4);
  	v.push_back(5);
  	v.push_back(6);
  	v.push_back(7);
  	for (int i = 0; i < v.size(); i++)
  		cout << v[i] << '\t';
  	cout << endl;
  }
  ```

- 也可以使用系统自带的vector生成模板

  ```cpp
  #include <iostream>
  #include <string>
  #include <vector>
  
  using namespace std;
  
  class student
  {
      string name;
      float score;
  public:
      student(string n = "no", float s = 0)
      {
          name = n;
          score = s;
      }
  
      friend ostream &operator<<(ostream &o, student s);
  };
  
  ostream &operator<<(ostream &o, student s)
  {
      cout << s.name << "," << s.score << endl;
      return o;
  }
  
  
  int main()
  {
      vector<student> v;//生成student类型的对象（向量形式、可自由生长）
      v.push_back(student("li", 60));
      v.push_back(student("wang", 70));
      v.push_back(student("zhao", 80));
      v.push_back(student("cen", 90));
  
      for (int i = 0; i < v.size(); i++)
          cout << v[i];
      cout << endl;
  
      return 0;
  }
  ```

  ![image-20220814154941638](https://i-blog.csdnimg.cn/blog_migrate/5cf3d779c046098617c27baf4946515f.png)

------

------

## P12 类的继承

### 1.C++ 继承

面向对象程序设计中最重要的一个概念是继承。继承允许我们依据另一个类来定义一个类，这使得创建和维护一个应用程序变得更容易。这样做，也达到了重用代码功能和提高执行效率的效果。

当创建一个类时，您不需要重新编写新的数据成员和成员函数，只需指定新建的类继承了一个已有的类的成员即可。

这个已有的类称为**基类**，新建的类称为**派生类**。

继承代表了 **is a** 关系。例如，哺乳动物是动物，狗是哺乳动物，因此，狗是动物，等等。

![img](https://i-blog.csdnimg.cn/blog_migrate/346bf49f2c3c8d7fb8068097165f871c.png)

当一个类派生自基类，该基类可以被继承为 **public、protected** 或 **private** 几种类型。继承类型是通过上面讲解的访问修饰符 access-specifier 来指定的。

我们几乎不使用 **protected** 或 **private** 继承，通常使用 **public** 继承。当使用不同类型的继承时，遵循以下几个规则：

- **公有继承（public）：\**当一个类派生自\**公有**基类时，基类的**公有**成员也是派生类的**公有**成员，基类的**保护**成员也是派生类的**保护**成员，基类的**私有**成员不能直接被派生类访问，但是可以通过调用基类的**公有**和**保护**成员来访问。

- **保护继承（protected）：** 当一个类派生自**保护**基类时，基类的**公有**和**保护**成员将成为派生类的**保护**成员。

- **私有继承（private）：\**当一个类派生自\**私有**基类时，基类的**公有**和**保护**成员将成为派生类的**私有**成员。

  | 访问     | public | protected | private |
  | -------- | ------ | --------- | ------- |
  | 同一个类 | yes    | yes       | yes     |
  | 派生类   | yes    | yes       | no      |
  | 外部的类 | yes    | no        | no      |

  一个派生类继承了所有的基类方法，但下列情况除外：

  - 基类的构造函数、析构函数和拷贝构造函数。
  - 基类的重载运算符。
  - 基类的友元函数。

### 2.单继承

```bnf
class <派生类名>:<继承方式1><基类名1>
{
	<派生类类体>
};
```

例子：

```arduino
#include <iostream>
 
using namespace std;
 
// 基类
class Shape 
{
   public:
      void setWidth(int w)
      {
         width = w;
      }
      void setHeight(int h)
      {
         height = h;
      }
   protected:
      int width;
      int height;
};
 
// 派生类
class Rectangle: public Shape
{
   public:
      int getArea()
      { 
         return (width * height); 
      }
};
 
int main(void)
{
   Rectangle Rect;
 
   Rect.setWidth(5);//通过成员函数访问受保护变量
   Rect.setHeight(7);
 
   // 输出对象的面积
   cout << "Total area: " << Rect.getArea() << endl;

   return 0;
}
```

结果：Total area: 35

### 3.多继承

多继承即一个子类可以有多个父类，它继承了多个父类的特性。

C++ 类可以从多个类继承成员，语法如下：

```bnf
class <派生类名>:<继承方式1><基类名1>,<继承方式2><基类名2>,…
{
<派生类类体>
};
```

其中，访问修饰符继承方式是 **public、protected** 或 **private** 其中的一个，用来修饰每个基类，各个基类之间用逗号分隔，如上所示。现在让我们一起看看下面的实例：

```arduino
#include <iostream>
 
using namespace std;
 
// 基类 Shape
class Shape 
{
   public:
      void setWidth(int w)
      {
         width = w;
      }
      void setHeight(int h)
      {
         height = h;
      }
   protected:
      int width;
      int height;
};
 
// 基类 PaintCost
class PaintCost 
{
   public:
      int getCost(int area)
      {
         return area * 70;
      }
};
 
// 派生类
class Rectangle: public Shape, public PaintCost
{
   public:
      int getArea()
      { 
         return (width * height); 
      }
};
 
int main(void)
{
   Rectangle Rect;
   int area;
 
   Rect.setWidth(5);
   Rect.setHeight(7);
 
   area = Rect.getArea();
   
   // 输出对象的面积
   cout << "Total area: " << Rect.getArea() << endl;
 
   // 输出总花费
   cout << "Total paint cost: $" << Rect.getCost(area) << endl;
 
   return 0;
}
```

结果：

```stata
Total area: 35
Total paint cost: $2450
```

------

------

## P13 类的多态

- 如果说，继承是子类使用父类的代码，那么多态就是父类使用子类的代码。

### 1.虚函数

**虚函数** 是在基类中使用关键字 **virtual** 声明的函数。在派生类中重新定义基类中定义的虚函数时，会告诉编译器不要静态链接到该函数。

我们想要的是在程序中任意点可以根据所调用的对象类型来选择调用的函数，这种操作被称为**动态链接**，或**后期绑定**。

```arduino
class Shape {
   protected:
      int width, height;
   public:
      Shape( int a=0, int b=0)
      {
         width = a;
         height = b;
      }
      virtual int area()//虚函数
      {
         cout << "Parent class area :" <<endl;
         return 0;
      }
};
```

### 2.纯虚函数

您可能想要在基类中定义虚函数，以便在派生类中重新定义该函数更好地适用于对象，但是您在基类中又不能对虚函数给出有意义的实现，这个时候就会用到纯虚函数。

我们可以把基类中的虚函数 area() 改写如下：

```arduino
class Shape {
   protected:
      int width, height;
   public:
      Shape( int a=0, int b=0)
      {
         width = a;
         height = b;
      }
      // pure virtual function
      virtual int area() = 0;
};
```

= 0 告诉编译器，函数没有主体，上面的虚函数是**纯虚函数**。

### 3.多态

**多态**按字面的意思就是多种形态。当类之间存在层次结构，并且类之间是通过继承关联时，就会用到多态。

C++ 多态意味着调用成员函数时，会根据调用函数的对象的类型来执行不同的函数。

例子：

```arduino
#include <iostream> 
using namespace std;
 
class Shape {
   protected://受保护的，继承的类，只有在成员函数中才能访问
      int width, height;
   public:
      Shape( int a=0, int b=0)
      {
         width = a;
         height = b;
      }
      virtual int area() //虚函数，父类指针访问链接之类的接口
      {
         cout << "Parent class area :" <<endl;
         return 0;
      }
};
class Rectangle: public Shape{//继承父类
   public:
      Rectangle( int a=0, int b=0):Shape(a, b) { }//使用父类的构造函数
      int area () //重载父类成员函数，注意此时父类是虚函数，后面父类对象指针可调用该函数
      { 
         cout << "Rectangle class area :" << width * height << endl;
         return (width * height); 
      }
};
class Triangle: public Shape{
   public:
      Triangle( int a=0, int b=0):Shape(a, b) { }
      int area ()
      { 
         cout << "Triangle class area :" << width * height / 2 << endl;
         return (width * height / 2); 
      }
};
// 程序的主函数
int main( )
{
   Shape *shape;
   Rectangle rec(10,7);
   Triangle  tri(10,5);
 
   // 存储矩形的地址
   shape = &rec;
   // 调用矩形的求面积函数 area
   shape->area();
 
   // 存储三角形的地址
   shape = &tri;
   // 调用三角形的求面积函数 area
   shape->area();
   
   return 0;
}
```

![image-20220815213132913](https://i-blog.csdnimg.cn/blog_migrate/9e021c88bdd1f2c2b34cfb46bd7088be.png)

## 后记

本文主要参考了：

hw-dong老师的博客：https://hwdong.net/

菜鸟C++教程：https://m.runoob.com/cplusplus/

cppreference: https://zh.cppreference.com/w/cpp

谢谢，如果对你有帮助，记得点个赞噢

 

- [官方主页](https://ranhe.xyz/circle-reader)
- [下载新版](https://ranhe.xyz/circle-install)
- [问题反馈](https://support.qq.com/product/377908)
- [鼓励支持❤️](https://ranhe.xyz/donate)

浏览器扩展 Circle 阅读助手排版，版权归 blog.csdn.net 所有