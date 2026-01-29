[toc]



## abstract

PHP简介

PHP是一个拥有众多开发者的开源软件项目，最开始是**Personal Home Page**的缩写，已经正式更名为 "PHP: Hypertext Preprocessor"。(递归缩写:**递归缩写（Recursive acronym）**即**递归首字缩写**，是一种在全称中递归引用它自己的缩写。)

PHP（PHP: Hypertext Preprocessor，超文本预处理器）是一种**专为 Web 开发设计**的**服务器端脚本语言**（server-side scripting language）。**它能够嵌入 HTML 代码中运行，适合快速构建动态网站和 Web 应用**。

由于上述php的设计初衷和用途(主要用途),这让php的语法(尤其是php代码需要包含(写)在特殊的[开始和结束处理指令 ](https://www.php.net/manual/zh/language.basic-syntax.phpmode.php) 中(即`<?php...?>`,一组尖括号和问号(`<? ?>`),且第一个问号后跟上php,来表明这个**区间**内的代码是php代码)

区间以外的内容不是php代码,会被**php解析器**忽略,这使得 PHP 文件可以具备混合内容。 可以使 PHP 嵌入到 HTML 文档中(不过这里的html文档指的不是.html文件,而是.php文件中的html代码片段)

php用这种标记的方式,在同一个php文件中跳入和退出 **PHP 模式**,这和一般的语言有很大的不同,无论是脚本语言还是非脚本语言)

### 官方资料

[PHP: 入门指引 - Manual](https://www.php.net/manual/zh/getting-started.php)

[PHP: 简明教程 - Manual](https://www.php.net/manual/zh/tutorial.php)

[PHP: 基本语法 - Manual](https://www.php.net/manual/zh/language.basic-syntax.php)

### 语言参考

1. [基本语法](https://www.php.net/manual/zh/language.basic-syntax.php)
2. [类型](https://www.php.net/manual/zh/language.types.php)
3. [变量](https://www.php.net/manual/zh/language.variables.php)
4. [常量](https://www.php.net/manual/zh/language.constants.php)
5. [表达式](https://www.php.net/manual/zh/language.expressions.php)
6. [运算符](https://www.php.net/manual/zh/language.operators.php)
7. [流程控制](https://www.php.net/manual/zh/language.control-structures.php)
8. [函数](https://www.php.net/manual/zh/language.functions.php)
9. [类与对象](https://www.php.net/manual/zh/language.oop5.php)
10. [概述](https://www.php.net/manual/zh/language.namespaces.php)
11. [枚举](https://www.php.net/manual/zh/language.enumerations.php)
12. [错误](https://www.php.net/manual/zh/language.errors.php)
13. [异常](https://www.php.net/manual/zh/language.exceptions.php)
14. [纤程](https://www.php.net/manual/zh/language.fibers.php)
15. [生成器](https://www.php.net/manual/zh/language.generators.php)
16. [注解](https://www.php.net/manual/zh/language.attributes.php)
17. [引用的解释](https://www.php.net/manual/zh/language.references.php)
18. [预定义变量](https://www.php.net/manual/zh/reserved.variables.php)
19. [预定义异常](https://www.php.net/manual/zh/reserved.exceptions.php)
20. [预定义接口和类](https://www.php.net/manual/zh/reserved.interfaces.php)
21. [预定义注解](https://www.php.net/manual/zh/reserved.attributes.php)
22. [上下文（Context）选项和参数](https://www.php.net/manual/zh/context.php)
23. [支持的协议和封装协议](https://www.php.net/manual/zh/wrappers.php)

--------------------------------------------------

## php编程环境

另见它文详解

## PHP基础语法

1. 文件扩展名  
   - PHP 文件以 `.php` 结尾

2. PHP 脚本基本格式  
   - PHP 代码通常嵌入到 `<?php ... ?>` 标签内，可以与 HTML 混写。例如：  

   ```php
   <?php
   echo "Hello, PHP!";
   ?>
   ```

3. 注释  
   - 单行注释：`// 注释内容`  
   - 多行注释：  
     ```php
     /*
      这是多行注释
     */
     ```

--------------------------------------------------

### 语法🎈

- [PHP 标记](https://www.php.net/manual/zh/language.basic-syntax.phptags.php)
- [从 HTML 中分离](https://www.php.net/manual/zh/language.basic-syntax.phpmode.php)
- [指令分隔符](https://www.php.net/manual/zh/language.basic-syntax.instruction-separation.php)🎈
- [注释](https://www.php.net/manual/zh/language.basic-syntax.comments.php)

### 指令分隔符🎈

在 PHP 代码中，**通常**每个语句后面都需要使用分号 (`;`) 作为结束符，类似于 C 或 Perl 语言,而与bash和python等脚本语言不同。

有一种情况不用加分号:**一段 PHP 代码**中的**结束标记**`?>`隐含表示了一个分号`;`,即`?>`可以理解为是`;?>`的缩写,因此在**一个 PHP 代码段**中的**最后一行可以不用分号结束**。

不过为了养成良好的习惯,**通常总是建议加上分号**,确保不会因为代码的增加和减少而发生分号确实的断句错误!

这里提到不加分号的情况只是告诉你**遇到结束标记时自带隐含的分号**,是合法的代码

#### 例子 1：标准用法（必须加分号）

```php
<?php
echo "Hello, World!"; // 分号必须加
echo "PHP is great!";  // <?php ?> 区间最后一个语句分号可选,但是推荐加
?>
```

#### 例子 2：最后一行可以省略分号

```php
<?php
echo "Hello, World!"; 
echo "PHP is great"
?>
```

上面的代码不会报错，因为 `?>` 结束标记已经隐含了语句结束的作用。

#### 例子 3：如果 `?>` 之后有新行

```php
<?php
echo "Hello, World!";
?>
Some HTML content...
```

在这个例子中，`?>` 后面跟着 HTML 内容，所以 `echo "Hello, World!";` 这一行即使没有分号，也不会导致语法错误。

#### 例子 4：省略 `?>` 时，最后一行仍然需要分号

```php
<?php
echo "Hello, World!"
```

如果 PHP 文件纯粹是 PHP 代码，通常不推荐使用 `?>` 结束标记，而如果省略 `?>`，则 `echo "Hello, World!"` 这行必须加上分号，否则会报语法错误：

```php
<?php
echo "Hello, World!"; // 省略 `?>` 时，必须有分号
```

### 结论

- 一般情况下，每条 PHP 语句必须以分号 `;` 结束。
- 在 PHP 代码块的最后一行，如果后面有 `?>` 结束标记，分号可以省略。
- 如果 PHP 代码块最后没有 `?>`（推荐省略），则分号仍然必须加上。

## 变量与数据类型

1. 变量（variable）  
   - 在 PHP 中，变量以美元符号 `$` 开头，变量名区分大小写。  
   - 变量不需要事先声明类型，数据类型会根据赋值自动转换（**弱类型语言**，weakly typed language）。

   示例：  
   ```php
   <?php
   $name = "Alice";   // 字符串 (string)
   $age = 25;         // 整数 (integer)
   $height = 1.68;    // 浮点数 (float)
   $isStudent = true; // 布尔值 (boolean)
   ?>
   ```

2. 数据类型  
   PHP 的基本数据类型包括：  
   - 字符串 (string)  
   - 整数 (integer)  
   - 浮点数 (float/double)  
   - 布尔值 (boolean)  
   - 数组 (array)  
   - 空值 (null)

--------------------------------------------------

### 运算符  

1. 算术运算符  
   用于数值计算。  

   | 运算符 | 描述 (Description)        | 示例 (Example)        |
   |--------|---------------------------|-----------------------|
   | +      | 加法 (Addition)           | `3 + 5 = 8`           |
   | -      | 减法 (Subtraction)        | `10 - 4 = 6`          |
   | *      | 乘法 (Multiplication)     | `4 * 5 = 20`          |
   | /      | 除法 (Division)           | `10 / 2 = 5`          |
   | %      | 取余 (Modulus)            | `10 % 3 = 1`          |

2. 赋值运算符  
   用于给变量赋值。  
   - `=` 将右边的值赋给左边的变量  
   - 组合赋值符号（如 `+=`, `-=`, `*=`, `/=`）  
   - 自增/自减运算符:`++`/`--`
   
   示例：  
   ```php
   <?php
   $a = 10;
   $a += 5;  // 相当于 $a = $a + 5
   ?>
   ```
   
3. 比较运算符  
   - `==` 判断值是否相等  
   - `===` 判断值和类型是否相等  
   - `!=` 或 `<>` 判断值是否不相等  
   - `>`、`<`、`>=`、`<=` 用于大小比较  

4. 逻辑运算符  
   - `&&` （与，AND）  
   - `||` （或，OR）  
   - `!`  （非，NOT）  

   示例：  
   ```php
   <?php
   $a = true;
   $b = false;
   if ($a && !$b) {
       echo "条件成立";
   }
   ?>
   ```

--------------------------------------------------

### 控制结构

- if...else 语句  
- switch 语句  

1. 条件判断  
   示例（if...elseif...else）：  
   ```php
   <?php
   $score = 75;
   if ($score >= 90) {
       echo "优秀";
   } elseif ($score >= 60) {
       echo "及格";
   } else {
       echo "不及格";
   }
   ?>
   ```
   
2. switch 示例：  
   ```php
   <?php
   $day = 3;
   switch ($day) {
       case 1:
           echo "星期一";
           break;
       case 2:
           echo "星期二";
           break;
       case 3:
           echo "星期三";
           break;
       default:
           echo "未知";
   }
   ?>
   ```

--------------------------------------------------

### 循环结构  

1. while 循环  
   ```php
   <?php
   $i = 1;
   while ($i <= 5) {
       echo "当前数字：$i <br>";
       $i++;
   }
   ?>
   ```

2. do...while 循环  
   ```php
   <?php
   $i = 1;
   do {
       echo "当前数字：$i <br>";
       $i++;
   } while ($i <= 5);
   ?>
   ```

3. for 循环  
   ```php
   <?php
   for ($i = 1; $i <= 5; $i++) {
       echo "当前数字：$i <br>";
   }
   ?>
   ```

4. foreach 循环（主要用于数组遍历）  
   ```php
   <?php
   $fruits = array("apple", "banana", "cherry");
   foreach ($fruits as $fruit) {
       echo "水果：$fruit <br>";
   }
   ?>
   ```

--------------------------------------------------

### 数组  

数组（array）是存储多个数据的容器。  

1. 索引数组（indexed array）  
   示例：  
   ```php
   <?php
   $colors = array("red", "green", "blue");
   echo $colors[0]; // 输出 red
   ?>
   ```

2. 关联数组（associative array)

   在其他语言中,类似于python的字典,java的哈希表

   示例：  

   ```php
   <?php
   $ages = array("Alice" => 25, "Bob" => 30);
   echo $ages["Alice"]; // 输出 25
   ?>
   ```

3. 多维数组（multidimensional array）  
   示例：  
   ```php
   <?php
   $matrix = array(
       array(1, 2, 3),
       array(4, 5, 6),
       array(7, 8, 9)
   );
   echo $matrix[1][2]; // 输出 6
   ?>
   ```

--------------------------------------------------

### 函数  

函数（function）是可重复使用的代码块，用于执行特定任务。  

1. 自定义函数  
   示例：  
   ```php
   <?php
   // 定义函数：add（求和）
   function add($a, $b) {
       return $a + $b;
   }
   echo add(3, 5); // 输出 8
   ?>
   ```

2. 内置函数  
   PHP 提供了大量内置函数，如 `strlen()`（计算字符串长度）、`array_push()`（向数组中添加元素）等。

--------------------------------------------------

### 表单处理  

PHP 可用于处理 HTML 表单数据，通过 GET 和 POST 方法获取用户输入。  

1. HTML 表单示例（保存为 form.html）：  
   ```html
   <form action="process.php" method="post">
       用户名: <input type="text" name="username">
       <input type="submit" value="提交">
   </form>
   ```

2. 表单数据处理（process.php）：  
   ```php
   <?php
   // 获取 POST 提交的数据
   $username = $_POST['username'];
   // 为防止 XSS 攻击，使用 htmlspecialchars() 过滤
   echo "欢迎, " . htmlspecialchars($username);
   ?>
   ```

--------------------------------------------------

### 文件操作  

PHP 提供了对文件的基本操作，如读取、写入、追加等。  

1. 写入文件  
   示例：  
   ```php
   <?php
   $file = fopen("example.txt", "w"); // 打开或创建文件，模式为写入 (write)
   fwrite($file, "Hello, PHP!");
   fclose($file);
   ?>
   ```

2. 读取文件  
   示例：  
   ```php
   <?php
   $file = fopen("example.txt", "r"); // 模式为读取 (read)
   $content = fread($file, filesize("example.txt"));
   fclose($file);
   echo $content;
   ?>
   ```

--------------------------------------------------

## php的命令行用法

- [PHP: 交互式 shell - Manual](https://www.php.net/manual/zh/features.commandline.interactive.php)

## 总结

本教程覆盖了 PHP 的基本语法、变量与数据类型、运算符、控制结构、循环、数组、函数、表单处理和文件操作等初级内容。通过这些基础知识，你可以开始构建简单的动态网站、处理用户数据、操作文件等。后续可以进一步学习面向对象编程（OOP，Object-Oriented Programming）、数据库操作（如使用 PDO 连接 MySQL）以及更多高级主题。

建议读者通过不断编写代码和实践案例来巩固所学知识，同时参考 PHP 官方文档（[PHP Manual](https://www.php.net/manual/zh/)）获取更详细的信息。  

