[toc]

# JavaScript 系统性介绍

JavaScript 是当今世界上使用最广泛的编程语言之一，从最初仅用于网页交互的脚本语言，发展成为可以构建前端、后端、移动应用、桌面应用甚至机器学习应用的通用编程语言。本文将系统性地介绍 JavaScript 的核心概念与高级特性。

------

## javascript和html

JavaScript是通过<script>元素插入到HTML页面中的。这个元素可用于把JavaScript代码嵌入到HTML页面中，跟其他标记混合在一起，也可用于引入保存在外部文件中的JavaScript。

- 要包含外部JavaScript文件，必须将src属性设置为要包含文件的URL。文件可以跟网页在同一台服务器上，也可以位于完全不同的域。
- 所有<script>元素会依照它们在网页中出现的次序被解释。在不使用defer和async属性的情况下，包含在<script>元素中的代码必须严格按次序解释。
- 对不推迟执行的脚本，浏览器必须解释完位于<script>元素中的代码，然后才能继续渲染页面的剩余部分。为此，通常应该把<script>元素放到页面末尾，介于主内容之后及</body>标签之前。
- 可以使用defer属性把脚本推迟到文档渲染完毕后再执行。推迟的脚本原则上按照它们被列出的次序执行。
- 可以使用async属性表示脚本不需要等待其他脚本，同时也不阻塞文档渲染，即异步加载。异步脚本不能保证按照它们在页面中出现的次序执行。
- 通过使用<noscript>元素，可以指定在浏览器不支持脚本时显示的内容。如果浏览器支持并启用脚本，则<noscript>元素中的任何内容都不会被渲染。

## 第一部分：语言基础

JavaScript的核心语言特性在ECMA-262中以伪语言ECMAScript的形式来定义。ECMAScript包含所有基本语法、操作符、数据类型和对象，能完成基本的计算任务，但**没有提供获得输入和产生输出的机制**。

理解ECMAScript及其复杂的细节是完全理解浏览器中JavaScript的关键。下面总结一下ECMAScript中的基本元素。

- 由于历史原因,js有严格模式,严格模式下`eval`,`arguments`不可作为变量名;语句末尾建议总是带上`;`,尽管大多数情况下省略掉`;`也能正常工作,与python不同,python建议省略`;`

- 因为 ECMAScript 是松散类型的，所以使用不同数据类型初始化的变量可以用一条语句来声明.如果需要定义多个变量，可以在一条语句中**用逗号分隔每个变量**（及可选的初始化）：
- ECMAScript中的**基本数据类型**包括**Undefined、Null、Boolean、Number、String和Symbol**。
- 与其他语言不同，ECMAScript**不区分整数和浮点值，只有Number一种数值数据类型**。
- Object是一种**复杂数据类型**(非基础数据类型)，它是这门语言中**所有对象的基类**。
- **严格模式**为这门语言中某些容易出错的部分施加了限制。
- ECMAScript提供了C语言和类C语言中常见的很多**基本操作符**，包括数学操作符、布尔操作符、关系操作符、相等操作符和赋值操作符等。
- 这门语言中的流控制语句大多是从其他语言中借鉴而来的，比如if语句、for语句和switch语句等。
- **ECMAScript中的函数与其他语言中的函数不一样**。不需要指定函数的返回值，因为**任何函数可以在任何时候返回任何值**。不指定**返回值**的函数实际上会**返回特殊值undefined**。此外还有声明**提升(hoist)**等特性,是大多数其他语言没有的机制.

#### js和python变量对比

ECMAScript 变量是松散类型的，意思是**变量可以用于保存任何类型的数据**。每个变量只不过是一 个用于保存任意值的命名占位符。**有 3 个关键字可以声明变量：var、const 和 let。**其中，var 在 ECMAScript 的所有版本中都可以使用，而 const 和 let只能在 ECMAScript 6 及更晚的版本中使用。

> 虽然可以通过省略 var操作符**定义全局变量**，但不推荐这么做。隐式全局变量 (Implicit Globals)
>
> 省略 `let`、`const` 或 `var` 直接给变量赋值（例如 `x = 10`），会触发一种特殊（且通常被认为是危险）的机制,即使你在函数内部这样做，该变量也会被挂载到全局对象
>
> 在**局部作用域中定义的全局变量很难维护，也会造成困惑**。这是因为不能一下子断定省略 var是不是有意而为之。
>
> 在严格模式下，如果像这样给未声明的变量赋值，则会导致抛出 ReferenceError。
>
> 此外,js还允许其他一些看似不合理的操作,尤其是学习过其他语言的用户(例如在函数中,在定义变量之前就使用变量的提升机制,反复多次使用 `var` 声明同一个变量也不会报错,也就是冗余声明(`let` 声明则不允许同一个块作用域中出现冗余声明)),尽管如此,这类代码不是很符合直觉,也不利于维护,应该尽量采用符合直觉的方式编码.



| **特性**             | **Bash**                     | **JavaScript**  | **Python**       |
| -------------------- | ---------------------------- | --------------- | ---------------- |
| **函数内默认作用域** | **全局** (Global)            | 取决于声明方式  | **局部** (Local) |
| **局部变量声明**     | `local x=1`                  | `let x = 1`     | `x = 1`          |
| **嵌套函数访问**     | 动态访问 (可以读父函数)      | 词法访问 (闭包) | 词法访问         |
| **报错机制**         | 极其宽松，引用未定义变量为空 | 严格模式下报错  | 严格报错         |

| **维度**         | **JavaScript (ES6+)**                                    | **Python (3.x)**                                    |
| ---------------- | -------------------------------------------------------- | --------------------------------------------------- |
| **声明语法**     | 通常需要显式使用 `let`, `const` 或 `var`                 | 隐式声明，直接通过 `x = 1` 赋值                     |
| **常量支持**     | 原生支持 `const`，具有运行时强制性                       | 无原生常量，仅通过大写约定（如 `PI`）               |
| **块级作用域**   | **支持**。由 `{}` 定义（使用 `let/const`）               | **不支持**。`if/for` 块内变量在外部可见             |
| **变量提升**     | **存在**。`var` 会提升，`let/const` 有死区               | **不存在**。必须先定义后使用                        |
| **全局污染**     | 若不用关键字声明，默认为全局（非严格模式）               | 函数内赋值默认为局部变量，除非声明 `global`         |
| **闭包修改权**   | 直接支持修改外层函数变量                                 | 需使用 `nonlocal` 关键字才能修改外层变量            |
| **类型系统**     | 动态类型，弱类型（存在频繁的隐式转换）                   | 动态类型，强类型（很少隐式转换，如 `'1'+1` 会报错） |
| **基本数据类型** | Number, String, Boolean, Symbol, BigInt, null, undefined | int, float, str, bool, bytes, None                  |
| **内存管理**     | 标记-清除（Mark-and-Sweep）算法                          | 引用计数（为主）+ 循环垃圾回收（辅助）              |
| **解构赋值**     | 极强：`const [a, b] = arr` 或 `{name} = obj`             | 支持序列拆封：`a, b = [1, 2]`，字典拆封较弱         |

### 1.1 JavaScript 的诞生与演进

JavaScript 由 Brendan Eich 在 1995 年用仅仅 10 天时间创造出来，最初名为 Mocha，后改名为 LiveScript，最终为了借助 Java 的热度而命名为 JavaScript。尽管名字相似，JavaScript 与 Java 是完全不同的语言。

ECMAScript 是 JavaScript 的标准化规范。

重要的版本演进包括 ES5（2009）引入严格模式、ES6/ES2015 带来革命性更新（let/const、箭头函数、类、模块等），此后每年都有新版本发布，持续为语言添加新特性。

任何语言的核心所描述的都是这门语言在最基本的层面上如何工作，涉及语法、操作符、数据类型以及内置功能，在此基础之上才可以构建复杂的解决方案。如前所述，ECMA-262以一个名为 ECMAScript 的伪语言的形式，定义了 JavaScript 的所有这些方面。ECMAScript 的语法很大程度上借鉴了 C 语言和其他类 C 语言，如 Java 和 Perl。熟悉这些语言的开发者，应该很容易理解 ECMAScript 宽松的语法。

### 1.2 变量与数据类型

JavaScript 是动态类型语言，变量的类型在运行时确定，且可以改变。

**变量声明的三种方式：**

```javascript
var name = "张三";      // 函数作用域，存在变量提升，可重复声明
let age = 25;           // 块级作用域，不可重复声明
const PI = 3.14159;     // 块级作用域，不可重新赋值（但对象属性可修改）
```

`var` 的变量提升（Hoisting）是一个需要理解的重要概念：

```javascript
console.log(x);  // 输出 undefined，而非报错
var x = 5;

// 上面的代码等同于：
var x;
console.log(x);
x = 5;
```

#### 声明变量类型选择

现代 JavaScript 开发中，推荐使用 `const` 作为默认选择，只有在确实需要重新赋值时才使用 `let`，避免使用 `var`(历史遗留关键字)。

实际应用中,`let`可能用的更多,因为修改变量是很常见的需求.

> `let` 跟 `var` 的作用差不多，但有着非常重要的区别。
>
> 最明显的区别是，let 声明的范围是**块作用域**,而 var声明的范围是**函数作用域**。
>
> 例如`if(){...}`中`{...}`是非函数块,而`function func(){...}`中的`{...}`是函数块
>
> **块作用域是函数作用域的子集**，因此适用于 var 的作用域限制同样也适用于 let。 
>
> let 也不允许同一个块作用域中出现**冗余声明**

这是一个非常经典且重要的 JavaScript 基础概念。理解这两者的核心区别在于：**“块”到底能不能困住变量。**

下面使用带有`if`语句的`function`代码说明问题.

------

1. `var`：函数作用域 (Function Scope)

`var` 声明的变量只会被函数包围。如果你在 `if` 语句或 `for` 循环中使用 `var`，它在外部依然是可以访问的。

```JavaScript
function varTest() {
  if (true) {
    var x = "我是 var"; 
  }
  console.log(x); // 输出: "我是 var" —— 尽管它在 if 块里定义，但外部仍能访问
}

varTest();
```

2. `let`：块作用域 (Block Scope)

`let` 声明的变量被限制在最近的一对大括号 `{}` 之间（即一个“块”）。一旦出了这个括号，变量就失效了。

```JavaScript
function letTest() {
  if (true) {
    let y = "我是 let";
    console.log(y); // 输出: "我是 let"
  }
  console.log(y); // 报错: ReferenceError: y is not defined
}

letTest();
```

------

3. 最典型的案例：`for` 循环中的表现

使用 `var` 的情况：

```JavaScript
for (var i = 0; i < 3; i++) {
  // 这里的 i 是全局或函数顶层的
}
console.log("循环结束后的 i:", i); // 输出: 3 (变量“泄露”到了循环外部)
```

使用 `let` 的情况：

```JavaScript
for (let j = 0; j < 3; j++) {
  // 这里的 j 只属于这个循环块
}
console.log("循环结束后的 j:", j); // 报错: ReferenceError: j is not defined
```

------

核心区别对比表

| **特性**     | **var**                    | **let**                             |
| ------------ | -------------------------- | ----------------------------------- |
| **作用域**   | **函数作用域**             | **块作用域** (`if, for, while, {}`) |
| **变量提升** | 会提升（值为 `undefined`） | 不允许在声明前使用（暂时性死区）    |
| **重复声明** | 允许                       | 不允许                              |
| **全局对象** | 会挂载到 `window`          | 不会挂载到 `window`                 |

------

为什么现在推荐只用 `let`？

使用 `var` 容易导致**全局污染**和**逻辑混乱**。比如在循环中定义的计数器，如果不小心在外部被修改，可能会引发难以排查的 Bug。而 `let` 的块作用域让代码的逻辑更加严密，变量的生命周期更可控。

跨语言对比:Python 的变量作用域规则主要遵循 **LEGB 规则**（Local, Enclosing, Global, Built-in），其行为更接近于 JavaScript 的 `var`。在 JavaScript 中，`if` 或 `for` 的 `{}` 会配合 `let` 锁定作用域。但在 Python 中，`if`、`for`、`while` 都没有自己的作用域。

对声明冗余报错不会因混用 let 和 var 而受影响。这两个关键字声明的并不是不同类型的变量， 它们只是指出变量在相关作用域如何存在。 

#### 暂时性死区 

let 与 var 的另一个重要的区别，就是 let声明的变量不会在作用域中被提升。 

```javascript
// name 会被提升 
console.log(name); // undefined 
var name = 'Matt'; 

// age 不会被提升 
console.log(age); // ReferenceError：age 没有定义 
let age = 26; 
```

在 let 声明之前的执行瞬间被称为“**暂时性死区**”（temporal dead zone），在此阶段引用任何后面才声明的变量都会抛出 `ReferenceError`。

#### 八种数据类型：

JavaScript 有七种原始类型和一种引用类型：

```javascript
// 原始类型（Primitive Types）
let str = "hello";           // String - 字符串
let num = 42;                // Number - 数字（整数和浮点数共用）
let bigInt = 9007199254740991n;  // BigInt - 大整数
let bool = true;             // Boolean - 布尔值
let undef = undefined;       // Undefined - 未定义
let empty = null;            // Null - 空值
let sym = Symbol("id");      // Symbol - 唯一标识符

// 引用类型（Reference Type）
let obj = { name: "李四" };  // Object - 对象（包括数组、函数等）
```

原始类型与引用类型的核心区别在于存储方式。原始类型直接存储值，赋值时复制值本身；引用类型存储的是内存地址，赋值时复制的是地址引用：

```javascript
// 原始类型：值复制
let a = 10;
let b = a;
b = 20;
console.log(a);  // 10，a 不受影响

// 引用类型：引用复制
let obj1 = { value: 10 };
let obj2 = obj1;
obj2.value = 20;
console.log(obj1.value);  // 20，obj1 也被修改了
```

### 1.3 运算符与类型转换

**类型转换与相等性判断：**

JavaScript 的隐式类型转换常常令初学者困惑。`==` 会进行类型转换后比较，`===` 则严格比较类型和值：

```javascript
console.log(5 == "5");       // true，字符串转为数字后相等
console.log(5 === "5");      // false，类型不同
console.log(null == undefined);   // true
console.log(null === undefined);  // false

// 一些令人困惑的隐式转换
console.log([] == false);    // true
console.log([] == ![]);      // true（这是经典的"WTF JavaScript"）
console.log("" == 0);        // true
```

建议始终使用 `===` 进行比较，避免隐式类型转换带来的意外。

**逻辑运算符的短路特性：**

```javascript
// || 返回第一个真值，或最后一个值
let name = inputName || "默认用户";

// && 返回第一个假值，或最后一个值
let result = user && user.profile && user.profile.name;

// ?? 空值合并运算符（ES2020），仅在 null 或 undefined 时使用默认值
let count = 0;
console.log(count || 10);   // 10（0 是假值）
console.log(count ?? 10);   // 0（0 不是 null 或 undefined）

// ?. 可选链运算符（ES2020）
let userName = user?.profile?.name;  // 安全访问深层属性
```

------

## 第二部分：函数与作用域

### 2.1 函数的多种定义方式

函数是 JavaScript 中的一等公民（First-class Citizens），可以像普通值一样被赋值、传递和返回。

```javascript
// 1. 函数声明（Function Declaration）
function greet(name) {
    return `你好，${name}！`;
}

// 2. 函数表达式（Function Expression）
const greet = function(name) {
    return `你好，${name}！`;
};

// 3. 箭头函数（Arrow Function，ES6）
const greet = (name) => `你好，${name}！`;

// 4. 立即执行函数表达式（IIFE）
(function() {
    console.log("我会立即执行");
})();
```

函数声明会被提升到作用域顶部，而函数表达式不会：

```javascript
sayHello();  // 正常工作
function sayHello() { console.log("Hello"); }

sayBye();    // TypeError: sayBye is not a function
var sayBye = function() { console.log("Bye"); };
```

### 2.2 箭头函数的特殊性

箭头函数不仅仅是更简洁的语法，它与普通函数有本质区别：

```javascript
// 1. 没有自己的 this，继承外层作用域的 this
const obj = {
    name: "对象",
    regularFunc: function() {
        console.log(this.name);  // "对象"
    },
    arrowFunc: () => {
        console.log(this.name);  // undefined（this 指向全局）
    }
};

// 2. 不能用作构造函数
const Person = (name) => { this.name = name; };
new Person("张三");  // TypeError

// 3. 没有 arguments 对象
function regular() { console.log(arguments); }  // 正常
const arrow = () => { console.log(arguments); };  // ReferenceError
```

### 2.3 作用域与闭包

**作用域链（Scope Chain）：**

JavaScript 采用词法作用域（静态作用域），函数的作用域在定义时就确定了：

```javascript
let global = "全局变量";

function outer() {
    let outerVar = "外层变量";
    
    function inner() {
        let innerVar = "内层变量";
        console.log(innerVar);   // 访问自身作用域
        console.log(outerVar);   // 访问外层作用域
        console.log(global);     // 访问全局作用域
    }
    
    inner();
}
```

**闭包（Closure）：**

闭包是 JavaScript 最强大也最容易误解的特性之一。当函数能够记住并访问其所在的词法作用域时，就产生了闭包，即使函数在其词法作用域之外执行：

```javascript
function createCounter() {
    let count = 0;  // 这个变量被"封闭"在返回的函数中
    
    return function() {
        count++;
        return count;
    };
}

const counter = createCounter();
console.log(counter());  // 1
console.log(counter());  // 2
console.log(counter());  // 3

// 每次调用 createCounter 都创建新的闭包
const anotherCounter = createCounter();
console.log(anotherCounter());  // 1（独立的计数器）
```

闭包的经典应用场景包括数据私有化、函数工厂和记忆化：

```javascript
// 数据私有化
function createWallet(initialBalance) {
    let balance = initialBalance;  // 私有变量，外部无法直接访问
    
    return {
        deposit(amount) {
            balance += amount;
            return balance;
        },
        withdraw(amount) {
            if (amount <= balance) {
                balance -= amount;
                return balance;
            }
            return "余额不足";
        },
        getBalance() {
            return balance;
        }
    };
}

const wallet = createWallet(100);
console.log(wallet.getBalance());  // 100
wallet.deposit(50);
console.log(wallet.balance);       // undefined，无法直接访问

// 函数工厂
function multiply(factor) {
    return function(number) {
        return number * factor;
    };
}

const double = multiply(2);
const triple = multiply(3);
console.log(double(5));  // 10
console.log(triple(5));  // 15
```

**经典闭包陷阱：**

```javascript
// 问题代码
for (var i = 0; i < 3; i++) {
    setTimeout(function() {
        console.log(i);
    }, 1000);
}
// 输出：3, 3, 3（而非期望的 0, 1, 2）

// 解决方案1：使用 let（块级作用域）
for (let i = 0; i < 3; i++) {
    setTimeout(function() {
        console.log(i);
    }, 1000);
}

// 解决方案2：使用闭包捕获当前值
for (var i = 0; i < 3; i++) {
    (function(j) {
        setTimeout(function() {
            console.log(j);
        }, 1000);
    })(i);
}
```

------

## 第三部分：对象与原型

### 3.1 对象的创建与操作

对象是 JavaScript 的核心，几乎所有复杂数据都以对象形式存在：

```javascript
// 对象字面量
const person = {
    name: "王五",
    age: 30,
    greet() {
        return `我是${this.name}`;
    }
};

// 属性访问
console.log(person.name);     // 点号访问
console.log(person["name"]);  // 方括号访问（可用于动态属性名）

// 属性操作
person.email = "wangwu@example.com";  // 添加属性
delete person.age;                      // 删除属性
"name" in person;                       // 检查属性是否存在

// 对象解构（ES6）
const { name, email = "未知" } = person;

// 扩展运算符（ES2018）
const extendedPerson = { ...person, city: "北京" };
```

### 3.2 原型与原型链

JavaScript 是基于原型的语言，对象可以从其他对象继承属性和方法。每个对象都有一个内部链接指向另一个对象，称为它的原型（prototype）：

```javascript
// 构造函数
function Animal(name) {
    this.name = name;
}

// 在原型上定义方法（所有实例共享）
Animal.prototype.speak = function() {
    return `${this.name} 发出声音`;
};

const dog = new Animal("小狗");
console.log(dog.speak());  // "小狗 发出声音"

// 原型链查找过程
console.log(dog.name);           // 在实例自身找到
console.log(dog.speak);          // 在 Animal.prototype 上找到
console.log(dog.toString);       // 在 Object.prototype 上找到
console.log(dog.nonexistent);    // 沿原型链查找到 null，返回 undefined
```

原型链的可视化理解：

```
dog --> Animal.prototype --> Object.prototype --> null

dog = {
    name: "小狗",
    __proto__: Animal.prototype
}

Animal.prototype = {
    speak: function() {...},
    constructor: Animal,
    __proto__: Object.prototype
}

Object.prototype = {
    toString: function() {...},
    hasOwnProperty: function() {...},
    __proto__: null
}
```

### 3.3 ES6 类语法

ES6 引入了 `class` 语法，这是原型继承的语法糖，使代码更清晰：

```javascript
class Animal {
    // 构造函数
    constructor(name) {
        this.name = name;
    }
    
    // 实例方法
    speak() {
        return `${this.name} 发出声音`;
    }
    
    // 静态方法
    static isAnimal(obj) {
        return obj instanceof Animal;
    }
    
    // Getter
    get info() {
        return `这是一只名叫${this.name}的动物`;
    }
    
    // Setter
    set nickname(value) {
        this.name = value;
    }
}

// 继承
class Dog extends Animal {
    constructor(name, breed) {
        super(name);  // 调用父类构造函数
        this.breed = breed;
    }
    
    speak() {
        return `${this.name} 汪汪叫`;
    }
    
    fetch() {
        return `${this.name} 去捡球`;
    }
}

const myDog = new Dog("旺财", "金毛");
console.log(myDog.speak());        // "旺财 汪汪叫"
console.log(myDog.fetch());        // "旺财 去捡球"
console.log(myDog.info);           // "这是一只名叫旺财的动物"
console.log(Animal.isAnimal(myDog)); // true
```

**私有字段（ES2022）：**

```javascript
class BankAccount {
    #balance = 0;  // 私有字段，以 # 开头
    
    constructor(initialBalance) {
        this.#balance = initialBalance;
    }
    
    deposit(amount) {
        this.#balance += amount;
    }
    
    getBalance() {
        return this.#balance;
    }
}

const account = new BankAccount(1000);
console.log(account.getBalance());  // 1000
console.log(account.#balance);      // SyntaxError，无法访问私有字段
```

------

## 第四部分：数组与迭代

### 4.1 数组方法详解

数组是最常用的数据结构，JavaScript 提供了丰富的数组方法：

```javascript
const numbers = [1, 2, 3, 4, 5];

// map - 映射转换，返回新数组
const doubled = numbers.map(n => n * 2);
// [2, 4, 6, 8, 10]

// filter - 过滤，返回满足条件的元素组成的新数组
const evens = numbers.filter(n => n % 2 === 0);
// [2, 4]

// reduce - 归约，将数组归约为单个值
const sum = numbers.reduce((acc, cur) => acc + cur, 0);
// 15

// find / findIndex - 查找元素或索引
const found = numbers.find(n => n > 3);      // 4
const index = numbers.findIndex(n => n > 3); // 3

// some / every - 测试条件
const hasEven = numbers.some(n => n % 2 === 0);   // true
const allPositive = numbers.every(n => n > 0);    // true

// forEach - 遍历（无返回值）
numbers.forEach((n, i) => console.log(`索引${i}: ${n}`));
```

**reduce 的强大应用：**

```javascript
const data = [
    { category: "水果", name: "苹果", price: 5 },
    { category: "蔬菜", name: "白菜", price: 3 },
    { category: "水果", name: "香蕉", price: 4 },
    { category: "蔬菜", name: "萝卜", price: 2 }
];

// 分组
const grouped = data.reduce((acc, item) => {
    const key = item.category;
    if (!acc[key]) acc[key] = [];
    acc[key].push(item);
    return acc;
}, {});
// { 水果: [...], 蔬菜: [...] }

// 统计
const totalPrice = data.reduce((sum, item) => sum + item.price, 0);
// 14

// 扁平化嵌套数组
const nested = [[1, 2], [3, 4], [5]];
const flat = nested.reduce((acc, arr) => acc.concat(arr), []);
// [1, 2, 3, 4, 5]
// 现代写法：nested.flat()
```

### 4.2 迭代器与生成器

**迭代器协议（Iterator Protocol）：**

```javascript
// 可迭代对象需要实现 Symbol.iterator 方法
const range = {
    from: 1,
    to: 5,
    
    [Symbol.iterator]() {
        let current = this.from;
        const last = this.to;
        
        return {
            next() {
                if (current <= last) {
                    return { value: current++, done: false };
                }
                return { done: true };
            }
        };
    }
};

for (const num of range) {
    console.log(num);  // 1, 2, 3, 4, 5
}

console.log([...range]);  // [1, 2, 3, 4, 5]
```

**生成器函数（Generator）：**

生成器是可以暂停和恢复执行的特殊函数：

```javascript
function* numberGenerator() {
    yield 1;
    yield 2;
    yield 3;
}

const gen = numberGenerator();
console.log(gen.next());  // { value: 1, done: false }
console.log(gen.next());  // { value: 2, done: false }
console.log(gen.next());  // { value: 3, done: false }
console.log(gen.next());  // { value: undefined, done: true }

// 无限序列
function* fibonacci() {
    let [prev, curr] = [0, 1];
    while (true) {
        yield curr;
        [prev, curr] = [curr, prev + curr];
    }
}

const fib = fibonacci();
console.log(fib.next().value);  // 1
console.log(fib.next().value);  // 1
console.log(fib.next().value);  // 2
console.log(fib.next().value);  // 3
console.log(fib.next().value);  // 5
```

------

## 第五部分：异步编程

### 5.1 事件循环与异步模型

JavaScript 是单线程语言，但通过事件循环（Event Loop）机制实现异步非阻塞：

```javascript
console.log("1. 同步代码开始");

setTimeout(() => {
    console.log("4. 宏任务执行");
}, 0);

Promise.resolve().then(() => {
    console.log("3. 微任务执行");
});

console.log("2. 同步代码结束");

// 输出顺序：1, 2, 3, 4
```

事件循环的执行顺序是：同步代码执行完毕后，先清空微任务队列（Promise回调等），再执行一个宏任务（setTimeout回调等），如此循环。

### 5.2 Promise

Promise 是异步编程的基础，代表一个异步操作的最终完成或失败：

```javascript
// 创建 Promise
function fetchData(url) {
    return new Promise((resolve, reject) => {
        // 模拟异步操作
        setTimeout(() => {
            if (url) {
                resolve({ data: "这是获取的数据" });
            } else {
                reject(new Error("URL 不能为空"));
            }
        }, 1000);
    });
}

// 使用 Promise
fetchData("/api/users")
    .then(response => {
        console.log(response.data);
        return fetchData("/api/posts");  // 链式调用
    })
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.error("错误:", error.message);
    })
    .finally(() => {
        console.log("无论成功失败都执行");
    });
```

**Promise 的静态方法：**

```javascript
const promise1 = Promise.resolve(1);
const promise2 = new Promise(resolve => setTimeout(() => resolve(2), 100));
const promise3 = Promise.resolve(3);

// Promise.all - 所有都成功才成功，一个失败就失败
Promise.all([promise1, promise2, promise3])
    .then(values => console.log(values));  // [1, 2, 3]

// Promise.allSettled - 等待所有完成，无论成功失败
Promise.allSettled([promise1, Promise.reject("错误"), promise3])
    .then(results => console.log(results));
// [{ status: 'fulfilled', value: 1 }, 
//  { status: 'rejected', reason: '错误' }, 
//  { status: 'fulfilled', value: 3 }]

// Promise.race - 返回最先完成的（无论成功失败）
Promise.race([promise1, promise2])
    .then(value => console.log(value));  // 1

// Promise.any - 返回最先成功的，全失败才失败
Promise.any([Promise.reject(1), promise2, promise3])
    .then(value => console.log(value));  // 3（比promise2快）
```

### 5.3 async/await

async/await 是 Promise 的语法糖，让异步代码看起来像同步代码：

```javascript
// async 函数总是返回 Promise
async function fetchUserData(userId) {
    try {
        // await 暂停执行，等待 Promise 完成
        const userResponse = await fetch(`/api/users/${userId}`);
        const user = await userResponse.json();
        
        const postsResponse = await fetch(`/api/users/${userId}/posts`);
        const posts = await postsResponse.json();
        
        return { user, posts };
    } catch (error) {
        console.error("获取数据失败:", error);
        throw error;
    }
}

// 并行执行多个异步操作
async function fetchAllData() {
    const [users, products, orders] = await Promise.all([
        fetch("/api/users").then(r => r.json()),
        fetch("/api/products").then(r => r.json()),
        fetch("/api/orders").then(r => r.json())
    ]);
    
    return { users, products, orders };
}

// 顶层 await（ES2022，在模块中可用）
const config = await fetch("/config.json").then(r => r.json());
```

**错误处理的最佳实践：**

```javascript
// 方式1：try/catch
async function method1() {
    try {
        const result = await riskyOperation();
        return result;
    } catch (error) {
        handleError(error);
    }
}

// 方式2：包装函数
function to(promise) {
    return promise
        .then(data => [null, data])
        .catch(err => [err, null]);
}

async function method2() {
    const [error, result] = await to(riskyOperation());
    if (error) {
        handleError(error);
        return;
    }
    return result;
}
```

------

## 第六部分：模块化

### 6.1 ES6 模块

模块化使代码组织更清晰，便于维护和复用：

```javascript
// math.js - 导出
export const PI = 3.14159;

export function square(x) {
    return x * x;
}

export function cube(x) {
    return x * x * x;
}

// 默认导出（每个模块只能有一个）
export default class Calculator {
    add(a, b) { return a + b; }
    subtract(a, b) { return a - b; }
}

// main.js - 导入
import Calculator, { PI, square, cube } from "./math.js";

// 重命名导入
import { square as sq } from "./math.js";

// 导入所有
import * as MathModule from "./math.js";
console.log(MathModule.PI);

// 动态导入（返回 Promise）
async function loadModule() {
    const module = await import("./math.js");
    console.log(module.PI);
}
```

### 6.2 模块模式

在模块系统出现之前，通过闭包实现模块化：

```javascript
// 揭示模块模式（Revealing Module Pattern）
const CounterModule = (function() {
    // 私有变量和方法
    let count = 0;
    
    function increment() {
        count++;
    }
    
    function decrement() {
        count--;
    }
    
    function getCount() {
        return count;
    }
    
    // 暴露公共 API
    return {
        increment,
        decrement,
        getCount
    };
})();

CounterModule.increment();
console.log(CounterModule.getCount());  // 1
console.log(CounterModule.count);       // undefined，私有变量不可访问
```

------

## 第七部分：高级特性

### 7.1 this 的绑定规则

`this` 是 JavaScript 中最令人困惑的概念之一。`this` 的值取决于函数的调用方式：

```javascript
const person = {
    name: "小明",
    greet() {
        console.log(`你好，我是${this.name}`);
    }
};

// 规则1：方法调用 - this 指向调用对象
person.greet();  // "你好，我是小明"

// 规则2：函数调用 - this 指向全局对象（严格模式下为 undefined）
const greetFunc = person.greet;
greetFunc();  // "你好，我是undefined"

// 规则3：构造函数调用 - this 指向新创建的对象
function Person(name) {
    this.name = name;
}
const p = new Person("小红");

// 规则4：显式绑定
function introduce(greeting) {
    console.log(`${greeting}，我是${this.name}`);
}

introduce.call(person, "你好");    // 立即调用
introduce.apply(person, ["你好"]); // 参数为数组
const boundIntroduce = introduce.bind(person);  // 返回新函数
boundIntroduce("嗨");
```

### 7.2 Proxy 与 Reflect

Proxy 可以拦截和自定义对象的基本操作：

```javascript
const target = {
    name: "张三",
    age: 25
};

const handler = {
    get(target, property, receiver) {
        console.log(`读取属性: ${property}`);
        return Reflect.get(target, property, receiver);
    },
    
    set(target, property, value, receiver) {
        console.log(`设置属性: ${property} = ${value}`);
        if (property === "age" && typeof value !== "number") {
            throw new TypeError("age 必须是数字");
        }
        return Reflect.set(target, property, value, receiver);
    }
};

const proxy = new Proxy(target, handler);
console.log(proxy.name);  // 读取属性: name，输出 "张三"
proxy.age = 30;           // 设置属性: age = 30
proxy.age = "三十";       // TypeError: age 必须是数字
```

**响应式数据的实现（Vue 3 的核心原理）：**

```javascript
function reactive(obj) {
    return new Proxy(obj, {
        get(target, key, receiver) {
            track(target, key);  // 收集依赖
            const result = Reflect.get(target, key, receiver);
            if (typeof result === "object" && result !== null) {
                return reactive(result);  // 递归代理
            }
            return result;
        },
        set(target, key, value, receiver) {
            const result = Reflect.set(target, key, value, receiver);
            trigger(target, key);  // 触发更新
            return result;
        }
    });
}
```

### 7.3 Symbol

Symbol 是唯一且不可变的原始值，常用于创建对象的唯一属性键：

```javascript
// 创建唯一 Symbol
const id1 = Symbol("id");
const id2 = Symbol("id");
console.log(id1 === id2);  // false，即使描述相同

// 作为对象属性键
const user = {
    name: "李四",
    [id1]: 12345
};

// Symbol 属性不会出现在常规遍历中
console.log(Object.keys(user));  // ["name"]
console.log(Object.getOwnPropertySymbols(user));  // [Symbol(id)]

// 内置 Symbol（Well-known Symbols）
class Collection {
    constructor(items) {
        this.items = items;
    }
    
    // 自定义迭代行为
    [Symbol.iterator]() {
        return this.items[Symbol.iterator]();
    }
    
    // 自定义 instanceof 行为
    static [Symbol.hasInstance](obj) {
        return Array.isArray(obj.items);
    }
}

// 全局 Symbol 注册表
const globalSym = Symbol.for("app.globalId");
const sameGlobalSym = Symbol.for("app.globalId");
console.log(globalSym === sameGlobalSym);  // true
```

### 7.4 WeakMap 与 WeakSet

WeakMap 和 WeakSet 持有对象的弱引用，不阻止垃圾回收：

```javascript
// WeakMap - 键必须是对象，不阻止键被垃圾回收
const cache = new WeakMap();

function process(obj) {
    if (!cache.has(obj)) {
        const result = /* 复杂计算 */ obj.value * 2;
        cache.set(obj, result);
    }
    return cache.get(obj);
}

let data = { value: 42 };
console.log(process(data));  // 84
data = null;  // 原对象可被垃圾回收，WeakMap 中的条目也会被清除

// 私有数据存储
const privateData = new WeakMap();

class Person {
    constructor(name, secret) {
        privateData.set(this, { secret });
        this.name = name;
    }
    
    getSecret() {
        return privateData.get(this).secret;
    }
}

const person = new Person("王五", "密码123");
console.log(person.name);        // "王五"
console.log(person.secret);      // undefined
console.log(person.getSecret()); // "密码123"
```

------

## 第八部分：错误处理与调试

### 8.1 错误处理

```javascript
// 自定义错误类型
class ValidationError extends Error {
    constructor(message, field) {
        super(message);
        this.name = "ValidationError";
        this.field = field;
    }
}

class DatabaseError extends Error {
    constructor(message, query) {
        super(message);
        this.name = "DatabaseError";
        this.query = query;
    }
}

// 错误处理
function validateUser(user) {
    if (!user.name) {
        throw new ValidationError("姓名不能为空", "name");
    }
    if (!user.email) {
        throw new ValidationError("邮箱不能为空", "email");
    }
}

try {
    validateUser({ name: "" });
} catch (error) {
    if (error instanceof ValidationError) {
        console.log(`验证错误 - 字段: ${error.field}, 信息: ${error.message}`);
    } else if (error instanceof DatabaseError) {
        console.log(`数据库错误 - 查询: ${error.query}`);
    } else {
        throw error;  // 重新抛出未知错误
    }
} finally {
    console.log("清理工作");
}
```

### 8.2 调试技巧

```javascript
// console 的多种用法
console.log("普通日志");
console.warn("警告信息");
console.error("错误信息");

// 表格展示
console.table([
    { name: "张三", age: 25 },
    { name: "李四", age: 30 }
]);

// 分组
console.group("用户信息");
console.log("姓名: 张三");
console.log("年龄: 25");
console.groupEnd();

// 计时
console.time("操作耗时");
// ... 执行操作
console.timeEnd("操作耗时");

// 条件断言
console.assert(1 === 2, "1 不等于 2");

// 堆栈追踪
console.trace("追踪调用栈");

// debugger 语句
function complexFunction() {
    let result = 0;
    debugger;  // 在此处暂停执行（开发者工具打开时）
    for (let i = 0; i < 100; i++) {
        result += i;
    }
    return result;
}
```

------

## 第九部分：性能优化

### 9.1 内存管理

```javascript
// 避免内存泄漏

// 1. 清除定时器
const timerId = setInterval(() => {
    // ...
}, 1000);
clearInterval(timerId);  // 组件卸载时清除

// 2. 移除事件监听
function handler() { /* ... */ }
element.addEventListener("click", handler);
element.removeEventListener("click", handler);  // 不再需要时移除

// 3. 解除引用
let largeData = new Array(1000000).fill("数据");
// 使用完毕后
largeData = null;  // 允许垃圾回收

// 4. 使用 WeakMap/WeakSet 存储对象引用
const cache = new WeakMap();  // 不阻止垃圾回收
```

### 9.2 性能优化技巧

```javascript
// 防抖（Debounce）- 多次触发只执行最后一次
function debounce(func, wait) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}

const handleSearch = debounce((query) => {
    console.log("搜索:", query);
}, 300);

// 节流（Throttle）- 限制执行频率
function throttle(func, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

const handleScroll = throttle(() => {
    console.log("滚动位置:", window.scrollY);
}, 100);

// 记忆化（Memoization）
function memoize(fn) {
    const cache = new Map();
    return function(...args) {
        const key = JSON.stringify(args);
        if (cache.has(key)) {
            return cache.get(key);
        }
        const result = fn.apply(this, args);
        cache.set(key, result);
        return result;
    };
}

const fibonacci = memoize(function(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
});

console.log(fibonacci(40));  // 快速计算，因为有缓存
```

------

## 第十部分：现代 JavaScript 新特性

### 10.1 ES2020+ 新特性

```javascript
// 可选链操作符（Optional Chaining）
const user = { profile: { name: "张三" } };
console.log(user?.profile?.name);      // "张三"
console.log(user?.settings?.theme);    // undefined，不会报错

// 空值合并操作符（Nullish Coalescing）
const count = 0;
console.log(count ?? 10);  // 0（只有 null/undefined 才用默认值）

// 逻辑赋值操作符（ES2021）
let a = null;
a ??= "默认值";  // 等同于 a = a ?? "默认值"
console.log(a);   // "默认值"

let b = "";
b ||= "默认值";  // 等同于 b = b || "默认值"
console.log(b);   // "默认值"

// Promise.allSettled（ES2020）
const promises = [
    Promise.resolve(1),
    Promise.reject("错误"),
    Promise.resolve(3)
];
const results = await Promise.allSettled(promises);

// 数字分隔符（ES2021）
const billion = 1_000_000_000;
const bytes = 0xFF_FF_FF_FF;

// String.replaceAll（ES2021）
const text = "香蕉 苹果 香蕉 橙子 香蕉";
console.log(text.replaceAll("香蕉", "梨"));  // "梨 苹果 梨 橙子 梨"

// Array.at()（ES2022）
const arr = [1, 2, 3, 4, 5];
console.log(arr.at(-1));  // 5，负索引从末尾开始

// Object.hasOwn()（ES2022）
const obj = { name: "张三" };
console.log(Object.hasOwn(obj, "name"));  // true

// Top-level await（ES2022）
const config = await fetch("/config.json").then(r => r.json());

// 类的私有字段和方法（ES2022）
class MyClass {
    #privateField = 42;
    
    #privateMethod() {
        return this.#privateField;
    }
    
    publicMethod() {
        return this.#privateMethod();
    }
}
```

### 10.2 实用的数组和对象方法

```javascript
// Array.from() - 从可迭代对象创建数组
const set = new Set([1, 2, 3]);
const arr = Array.from(set);

// 带映射函数
const doubled = Array.from([1, 2, 3], x => x * 2);  // [2, 4, 6]

// Object.entries() / Object.fromEntries()
const obj = { a: 1, b: 2, c: 3 };
const entries = Object.entries(obj);  // [["a", 1], ["b", 2], ["c", 3]]
const newObj = Object.fromEntries(entries);

// 对象属性转换
const prices = { apple: 1, banana: 2, orange: 3 };
const doublePrices = Object.fromEntries(
    Object.entries(prices).map(([key, value]) => [key, value * 2])
);
// { apple: 2, banana: 4, orange: 6 }

// Array.prototype.flat() / flatMap()
const nested = [[1, 2], [3, [4, 5]]];
console.log(nested.flat());     // [1, 2, 3, [4, 5]]
console.log(nested.flat(2));    // [1, 2, 3, 4, 5]

const sentences = ["Hello world", "Goodbye moon"];
const words = sentences.flatMap(s => s.split(" "));
// ["Hello", "world", "Goodbye", "moon"]
```

------

## 总结

JavaScript 从一门简单的脚本语言发展成为功能完备的编程语言，其核心概念包括：动态类型系统使语言灵活但需要注意类型转换陷阱；闭包和作用域是理解代码行为的关键；基于原型的继承与 ES6 类语法提供了灵活的面向对象编程方式；事件循环和 Promise/async-await 使异步编程变得优雅；Proxy 和 Symbol 提供了强大的元编程能力。

