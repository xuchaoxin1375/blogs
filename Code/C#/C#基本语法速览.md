[toc]



C#是一种强类型、面向对象的编程语言，广泛应用于Windows应用程序、Web开发、游戏开发等多个领域。这个教程将帮助你掌握C#编程的核心知识，理解其基础概念，并能够开始写出有用的程序。

### C#基本概念

#### 1. 数据类型

C#中有几种基本的数据类型，分为值类型和引用类型。

- 值类型

  （Value Types）：存储数据的实际值，如整数（int）、浮点数（float）、布尔值（bool）等。它们通常存储在栈（Stack）上。

  - `int`：整数类型，通常为32位。
  - `double`：双精度浮点数。
  - `bool`：布尔类型，`true`或`false`。
  - `char`：单个字符。
  
- 引用类型

  （Reference Types）：存储对数据的引用或地址，数据本身存储在堆（Heap）上。常见的引用类型有

  string
  
  和数组（

  array

  ）。
  
  - `string`：表示一串字符（文本数据）。
- `array`：一组相同类型的数据集合。

#### 2. 变量和常量

在C#中，所有的数据都必须通过变量来存储。变量在使用之前需要声明。

```csharp
int age = 25;
string name = "Alice";
```

常量是指在程序运行过程中其值不发生改变的量，常量的声明使用`const`关键字。

```csharp
const double PI = 3.14159;
```

### C#控制结构

#### 1. 条件语句

C#提供了多种方式来进行条件判断，最常用的是`if`语句。

```csharp
int number = 10;
if (number > 0)
{
    Console.WriteLine("The number is positive.");
}
else
{
    Console.WriteLine("The number is non-positive.");
}
```

另外，还可以使用`switch`语句来简化多个条件判断：

```csharp
int day = 3;
switch (day)
{
    case 1:
        Console.WriteLine("Monday");
        break;
    case 2:
        Console.WriteLine("Tuesday");
        break;
    case 3:
        Console.WriteLine("Wednesday");
        break;
    default:
        Console.WriteLine("Invalid day");
        break;
}
```

#### 2. 循环语句

C#有三种常用的循环：`for`、`while`和`foreach`。

- **`for`循环**：当你知道循环次数时，使用`for`循环。

```csharp
for (int i = 0; i < 5; i++)
{
    Console.WriteLine(i);
}
```

- **`while`循环**：当你不确定循环次数时，使用`while`循环。

```csharp
int i = 0;
while (i < 5)
{
    Console.WriteLine(i);
    i++;
}
```

- **`foreach`循环**：用于遍历集合，如数组或列表。

```csharp
string[] fruits = { "Apple", "Banana", "Orange" };
foreach (var fruit in fruits)
{
    Console.WriteLine(fruit);
}
```

### 函数和方法

C#中的函数被称为“方法”（Method）。方法可以返回一个值，或者没有返回值（即`void`）。

#### 1. 方法声明

方法声明包括返回类型、方法名和参数列表。

```csharp
int Add(int a, int b)
{
    return a + b;
}
```

#### 2. 方法调用

调用一个方法非常简单，只需写上方法名和所需的参数。

```csharp
int result = Add(3, 4);  // 结果是 7
```

#### 3. 参数传递

方法的参数可以通过值传递或引用传递。

- **值传递**：将变量的值传递给方法，方法内部修改不会影响外部变量。
- **引用传递**：传递变量的引用，方法内的修改会影响外部变量。

```csharp
void UpdateValue(ref int x)
{
    x = 20;
}

int num = 10;
UpdateValue(ref num);  // num 变为 20
```

### 面向对象编程（OOP）

C#是一种面向对象的编程语言，支持四个基本特性：封装、继承、多态和抽象。

#### 1. 类和对象

类是对象的蓝图，对象是类的实例。

```csharp
class Car
{
    public string Model;
    public int Year;

    public void Drive()
    {
        Console.WriteLine("The car is driving");
    }
}

// 创建对象
Car myCar = new Car();
myCar.Model = "Toyota";
myCar.Year = 2020;
myCar.Drive();
```

#### 2. 继承

通过继承，一个类可以获得另一个类的属性和方法。

```csharp
class ElectricCar : Car
{
    public int BatteryLife;

    public void Charge()
    {
        Console.WriteLine("Charging the car");
    }
}

ElectricCar myElectricCar = new ElectricCar();
myElectricCar.Model = "Tesla";
myElectricCar.BatteryLife = 100;
myElectricCar.Drive();
myElectricCar.Charge();
```

#### 3. 多态

多态是指可以通过父类引用调用子类的方法。

```csharp
class Animal
{
    public virtual void MakeSound()
    {
        Console.WriteLine("Animal sound");
    }
}

class Dog : Animal
{
    public override void MakeSound()
    {
        Console.WriteLine("Woof");
    }
}

Animal myAnimal = new Dog();
myAnimal.MakeSound();  // 输出 "Woof"
```

#### 4. 抽象

抽象类不能实例化，只能作为其他类的基类。它允许我们在子类中实现方法的具体细节。

```csharp
abstract class Animal
{
    public abstract void MakeSound();
}

class Dog : Animal
{
    public override void MakeSound()
    {
        Console.WriteLine("Woof");
    }
}
```

### 异常处理

异常是指程序运行时出现的错误，C#提供了`try-catch`语句来捕获并处理异常。

```csharp
try
{
    int[] numbers = new int[5];
    numbers[10] = 100;  // 会抛出异常
}
catch (IndexOutOfRangeException ex)
{
    Console.WriteLine("Error: " + ex.Message);
}
finally
{
    Console.WriteLine("Finally block executed");
}
```

### LINQ（语言集成查询）

LINQ允许你以声明性方式查询数据，支持数组、集合、XML等多种数据源。

```csharp
int[] numbers = { 1, 2, 3, 4, 5 };
var evenNumbers = from n in numbers
                  where n % 2 == 0
                  select n;

foreach (var number in evenNumbers)
{
    Console.WriteLine(number);  // 输出 2 和 4
}
```

### 总结

C#是一种功能强大的编程语言，掌握了基本的语法和面向对象的概念后，你就能开始编写各种应用程序。这个教程介绍了C#中的基础知识，从数据类型到面向对象的编程，再到异常处理和LINQ，涵盖了编程中的许多核心概念。

接下来的步骤是多加练习，试着写些小程序，逐步掌握更多的语言特性和编程技巧。