[toc]



# PHP 系统学习指南

PHP（Hypertext Preprocessor）是一**门专为 Web 开发**设计的**服务器端脚本语言**。

尽管近年来涌现了许多新技术，PHP 依然驱动着互联网上超过 70% 的网站，包括 WordPress、Facebook、Wikipedia 等知名平台。

现代 PHP（PHP 8.x）已经脱胎换骨，拥有强类型、JIT 编译、属性注解等现代语言特性。

## 和其他语言对比

PHP 被称为“专为 Web 开发设计的服务器端脚本语言”，这句话精确地概括了 PHP 的诞生背景、核心特征以及它在编程语言生态中的定位。

### 基本特点

#### 1. 服务器端
*   **运行位置**：PHP 代码运行在 **Web 服务器**上（如 Apache、Nginx），而不是用户的浏览器（客户端）中。
*   **工作模式**：当用户发送 HTTP 请求时，服务器接收请求，执行对应的 PHP 脚本（如查询数据库、处理业务逻辑），然后将生成的 HTML（或其他格式）作为 HTTP 响应返回给浏览器。用户永远看不到 PHP 源码，只能看到执行结果。
#### 2. 脚本语言
*   **解释执行**：PHP 不需要像 C/C++ 或 Java 那样预先编译成机器码或字节码（虽然有 OPCache 优化，但本质是解释执行的），它由 Zend 引擎在运行时逐行解释执行。
*   **动态类型**：变量类型在运行时确定，编写灵活，适合快速迭代。
*   **生命周期短**：在传统的 Web 模式下，**PHP 脚本的生命周期与一次 HTTP 请求绑定**。请求开始，脚本启动；请求结束，脚本占用的内存和资源全部释放（即“共享无状态”架构）。这种设计天然适合 Web 的高并发短连接场景。
#### 3. 专为 Web 开发设计
*   **HTML 嵌入式语法**：PHP 最具标志性的设计是可以直接将代码嵌入 HTML 中（使用 `<?php ... ?>` 标签），这让早期开发者能极其直观地控制网页的动态内容。(包含php代码的文件扩展名一般选择`.php`,即便是嵌在`html`中,一般也不会选择`.html`作为后缀,而选择`.php`)
*   **内置 Web 原生功能**：PHP 原生自带了**对 HTTP 协议的深度支持**。例如：
    *   Superglobals（超全局数组）：`$_GET`, `$_POST`, `$_SERVER`, `$_SESSION`, `$_COOKIE` 等，直接封装了 **HTTP 请求和会话状态**。
    *   轻松处理 HTTP Header、文件上传、表单验证等 Web 高频操作。
*   **极低的部署门槛**：PHP 几乎是所有共享主机默认支持的语言。将 `.php` 文件通过 FTP 传到服务器上就能跑，不需要复杂的构建、打包或配置应用服务器。
*   **历史基因**：PHP 最初由 Rasmus Lerdorf 在 1994 年用 C 语言编写，目的仅仅是为了维护他的个人主页和跟踪访问量，它从诞生第一天起就是为了解决 Web 问题，而非通用计算问题。
---
### 与其他通用语言的对比总结
通用语言（如 Java, Python, C#, C++, Go, JavaScript 等）设计之初是为了解决更广泛的问题（如桌面软件、操作系统、科学计算、底层驱动等），Web 只是它们的一个应用领域。相比之下，PHP 是 Web 领域的“专科生”。
#### 1. PHP vs. Python
*   **定位**：Python 是通用语言，强项在数据科学、AI、自动化运维和爬虫；PHP 几乎 100% 绑定 Web。
*   **Web 生态**：Python 做 Web 需要依赖框架（如 Django/Flask），并需要额外的 WSGI/ASGI 服务器来处理 **HTTP 协议与 Python 代码的桥接**。PHP 原生就懂 HTTP 协议，通过 PHP-FPM 或 Apache 模块直接**与 Web 服务器对接**。
*   **部署**：Python Web 应用的部署相对复杂（涉及虚拟环境、Gunicorn/uWSGI、Nginx 反向代理），而 PHP 上传即用。
#### 2. PHP vs. Java
*   **定位**：Java 是重度通用、企业级语言，强在跨平台、高并发分布式系统、安卓开发等。
*   **开发范式**：Java 是静态强类型语言，需要编译，严格遵循面向对象设计，代码结构严谨但较为笨重。PHP 是动态弱类型语言（现代 PHP 也引入了严格类型），编写轻快，更适合快速迭代的 Web 项目。
*   **运行机制**：Java Web 需要运行在 Servlet 容器（如 Tomcat）或 Spring Boot 内嵌服务器中，应用常驻内存，状态共享，适合大型复杂架构；PHP 默认每次请求重新加载环境，适合中小型 Web 和快速部署。
#### 3. PHP vs. JavaScript (Node.js)
*   **定位**：JS 原本是客户端语言，Node.js 的出现让它拥有了服务器端能力，实现了“全栈”。
*   **并发模型**：Node.js 是单线程事件循环、非阻塞 I/O，非常擅长处理高并发 I/O 密集型任务（如聊天室、流媒体）。PHP 传统上是同步阻塞的（每次请求一个线程/进程），虽然现在有了 Swoole/Octane 等常驻内存方案，但原生模型依然是传统的同步生命周期。
*   **前后端统一**：Node.js 前后端语言一致，可复用代码和构建工具；PHP 则严格限制在后端。
#### 4. PHP vs. Go
*   **定位**：Go 是现代通用语言，强在高并发、微服务、云原生基础设施（如 Docker/K8s 都是 Go 写的）。
*   **性能**：Go 是编译型静态语言，性能远高于 PHP，内存占用极低。
*   **Web 开发体验**：Go 开发 Web 通常直接编译成一个二进制文件，包含 HTTP 服务器，部署极简（丢到服务器直接跑）。但 Go 的开发速度和动态灵活性不如 PHP，更适合做底层服务和大型高并发后端，而不是快速开发传统动态网站。
#### 5. PHP vs. C# (.NET)
*   **定位**：C# 是全能型语言，涵盖桌面、游戏、Web、云服务。历史上与 Windows 深度绑定（虽然有跨平台的 .NET Core）。
*   **生态**：PHP 天生生长在 Linux/Apache/Nginx 的开源生态中，是 LAMP 架构的核心；C# ASP.NET 历史上更多在 Windows Server + IIS 环境下，面向微软生态的企业客户。
---
###  总结对比表

| 特性               | PHP (Web 专用)             | Python (通用/AI)       | Java (通用/企业)       | Node.js (全栈JS)        | Go (云原生/系统)     |
| :----------------- | :------------------------- | :--------------------- | :--------------------- | :---------------------- | :------------------- |
| **类型系统**       | 动态弱类型 (现代支持严格)  | 动态强类型             | 静态强类型             | 动态弱类型              | 静态强类型           |
| **执行方式**       | 解释执行 (Zend引擎)        | 解释执行 (CPython)     | 编译为字节码 (JVM)     | 解释执行 (V8引擎)       | 编译为机器码         |
| **Web 协议原生度** | 极高 (内置$_GET等超全局)   | 低 (依赖WSGI/框架)     | 低 (依赖Servlet/框架)  | 中 (需引入http模块)     | 中 (内置net/http库)  |
| **部署难度**       | 极低 (传文件即跑)          | 中 (需配环境/WSGI)     | 高 (需JVM/打包WAR)     | 低 (需Node环境)         | 极低 (单二进制文件)  |
| **并发模型**       | 同步阻塞/多进程 (可配异步) | 异步支持较弱 (GIL限制) | 多线程                 | 单线程事件循环 (异步)   | Goroutine (极高并发) |
| **核心优势**       | 快速建站、庞大的CMS生态    | 数据处理、AI生态       | 严谨稳定、大型企业系统 | 前后端统一、I/O密集场景 | 极高性能、微服务架构 |

**结论**：PHP 之所以被称为“专为 Web 设计”，是因为它的语法、内置函数库、生命周期管理以及生态部署方式，无一不是为了解决 **“接收 HTTP 请求 -> 查数据库 -> 返回 HTML”** 这一核心痛点而量身定制的。
其他通用语言虽然也能做 Web 开发，但往往需要通过引入框架、中间件或特定的服务器架构来“适配” Web 场景，而 PHP 则是生在 Web、长在 Web。

---

## 第一部分：基础入门

### 1.1 PHP 的工作原理

PHP 是一门服务器端语言，这意味着代码在服务器上执行，然后将结果（通常是 HTML）发送给用户的浏览器。理解这一点至关重要：用户永远看不到你的 PHP 源代码，他们只能看到执行后的输出。

```php
<?php
// 这段代码在服务器上执行
$currentTime = date('Y-m-d H:i:s');
?>
<!DOCTYPE html>
<html>
<head>
    <title>我的第一个 PHP 页面</title>
</head>
<body>
    <p>服务器当前时间是：<?php echo $currentTime; ?></p>
</body>
</html>
```

当用户访问这个页面时，服务器会执行 PHP 代码，用户的浏览器收到的是纯 HTML，其中时间部分已经被替换为实际的时间值。

### 1.2 变量与数据类型

PHP 是动态类型语言，变量以 `$` 符号开头。现代 PHP 强烈建议使用类型声明来提高代码质量。

```php
<?php
declare(strict_types=1); // 启用严格类型模式，这是现代 PHP 的最佳实践

// 标量类型
$name = "张三";           // string - 字符串
$age = 25;                // int - 整数
$height = 1.75;           // float - 浮点数
$isStudent = true;        // bool - 布尔值

// 复合类型
$hobbies = ['读书', '游泳', '编程'];  // array - 数组
$person = [                            // 关联数组（类似其他语言的字典/映射）
    'name' => '张三',
    'age' => 25,
    'city' => '北京'
];

// 特殊类型
$nothing = null;          // null - 空值

// 类型检查
echo gettype($name);      // 输出: string
var_dump($age);           // 输出: int(25)，包含类型和值信息
```

**核心概念解释：`declare(strict_types=1)`**

这条声明启用严格类型模式。在默认的弱类型模式下，PHP 会自动进行类型转换（比如把字符串 "123" 转成整数 123）。严格模式下，类型不匹配会直接报错，这能帮你在开发阶段就发现潜在的 bug。

### 1.3 字符串处理

字符串操作是 Web 开发中最常见的任务之一。

```php
<?php
$firstName = "张";
$lastName = "三";

// 字符串拼接
$fullName = $firstName . $lastName;  // 使用点号拼接

// 字符串插值（仅双引号支持）
$greeting = "你好，{$fullName}！";    // 花括号可选，但推荐使用以提高可读性
$literal = '你好，{$fullName}！';     // 单引号不解析变量，原样输出

// 常用字符串函数
$text = "  Hello, World!  ";

strlen($text);              // 返回 17（包含空格）
mb_strlen("你好");          // 返回 2（多字节安全，处理中文必须用这个）
trim($text);                // 去除首尾空白，返回 "Hello, World!"
strtolower($text);          // 转小写
strtoupper($text);          // 转大写
str_replace("World", "PHP", $text);  // 替换，返回 "  Hello, PHP!  "
explode(",", "a,b,c");      // 分割成数组 ['a', 'b', 'c']
implode("-", ['a','b','c']); // 数组合并成字符串 "a-b-c"

// Heredoc 语法 - 适合多行字符串
$html = <<<HTML
<div class="card">
    <h2>{$fullName}</h2>
    <p>欢迎来到我们的网站</p>
</div>
HTML;
```

### 1.4 数组详解

数组是 PHP 中最灵活也最常用的数据结构。

```php
<?php
// 索引数组 - 从 0 开始自动编号
$fruits = ['苹果', '香蕉', '橙子'];
echo $fruits[0];  // 输出: 苹果

// 关联数组 - 自定义键名
$user = [
    'id' => 1,
    'name' => '李四',
    'email' => 'lisi@example.com'
];
echo $user['name'];  // 输出: 李四

// 多维数组
$users = [
    ['id' => 1, 'name' => '张三', 'role' => 'admin'],
    ['id' => 2, 'name' => '李四', 'role' => 'editor'],
    ['id' => 3, 'name' => '王五', 'role' => 'user'],
];

// 数组操作
$fruits[] = '葡萄';              // 追加元素
array_push($fruits, '西瓜');     // 同上，追加到末尾
array_pop($fruits);              // 移除并返回最后一个元素
array_shift($fruits);            // 移除并返回第一个元素
count($fruits);                  // 返回数组长度
in_array('香蕉', $fruits);       // 检查元素是否存在
array_key_exists('name', $user); // 检查键是否存在

// 数组遍历
foreach ($users as $user) {
    echo $user['name'] . "\n";
}

// 带键名的遍历
foreach ($user as $key => $value) {
    echo "{$key}: {$value}\n";
}

// 现代数组函数（函数式编程风格）
$numbers = [1, 2, 3, 4, 5];

// array_map - 对每个元素应用函数
$doubled = array_map(fn($n) => $n * 2, $numbers);  // [2, 4, 6, 8, 10]

// array_filter - 过滤元素
$evenNumbers = array_filter($numbers, fn($n) => $n % 2 === 0);  // [2, 4]

// array_reduce - 归约为单个值
$sum = array_reduce($numbers, fn($carry, $n) => $carry + $n, 0);  // 15
```

### 1.5 控制结构

```php
<?php
$score = 85;

// if-elseif-else
if ($score >= 90) {
    $grade = 'A';
} elseif ($score >= 80) {
    $grade = 'B';
} elseif ($score >= 70) {
    $grade = 'C';
} else {
    $grade = 'D';
}

// match 表达式（PHP 8+，比 switch 更现代更安全）
$grade = match (true) {
    $score >= 90 => 'A',
    $score >= 80 => 'B',
    $score >= 70 => 'C',
    default => 'D',
};

// 三元运算符
$status = $score >= 60 ? '及格' : '不及格';

// Null 合并运算符（非常实用）
$username = $_GET['user'] ?? '游客';  // 如果 $_GET['user'] 不存在或为 null，使用默认值

// Null 安全运算符（PHP 8+）
$length = $user?->profile?->bio?->length;  // 链式调用，任何一环为 null 都返回 null

// 循环
for ($i = 0; $i < 5; $i++) {
    echo $i;
}

$i = 0;
while ($i < 5) {
    echo $i++;
}

// do-while 至少执行一次
do {
    echo $i++;
} while ($i < 5);
```

---

## 第二部分：函数与面向对象

### 2.1 函数

```php
<?php
declare(strict_types=1);

// 基本函数定义，带类型声明
function calculateArea(float $width, float $height): float
{
    return $width * $height;
}

// 默认参数值
function greet(string $name, string $greeting = "你好"): string
{
    return "{$greeting}, {$name}!";
}

echo greet("张三");           // 你好, 张三!
echo greet("张三", "早上好");  // 早上好, 张三!

// 可变参数
function sum(int ...$numbers): int
{
    return array_sum($numbers);
}

echo sum(1, 2, 3, 4, 5);  // 15

// 命名参数（PHP 8+）- 提高可读性，允许跳过中间的可选参数
function createUser(
    string $name,
    string $email,
    string $role = 'user',
    bool $active = true
): array {
    return compact('name', 'email', 'role', 'active');
}

$user = createUser(
    name: '王五',
    email: 'wangwu@example.com',
    active: false  // 跳过了 $role 参数
);

// 箭头函数（适合简单的单行表达式）
$multiply = fn(int $a, int $b): int => $a * $b;

// 匿名函数（闭包）
$factor = 10;
$multiplier = function(int $n) use ($factor): int {
    return $n * $factor;
};
echo $multiplier(5);  // 50
```

**核心概念解释：返回类型声明**

`function calculateArea(...): float` 中的 `: float` 声明了函数必须返回浮点数。这不仅是文档，更是契约——如果函数返回了错误类型，PHP 会抛出错误。现代 PHP 开发中，总是应该声明参数类型和返回类型。

### 2.2 面向对象编程基础

```php
<?php
declare(strict_types=1);

class User
{
    // 属性声明（PHP 8+ 支持构造器属性提升，见下方简化版本）
    private int $id;
    private string $name;
    private string $email;
    private DateTime $createdAt;
    
    // 常量
    public const STATUS_ACTIVE = 'active';
    public const STATUS_INACTIVE = 'inactive';
    
    // 静态属性
    private static int $instanceCount = 0;
    
    // 构造函数
    public function __construct(int $id, string $name, string $email)
    {
        $this->id = $id;
        $this->name = $name;
        $this->email = $email;
        $this->createdAt = new DateTime();
        self::$instanceCount++;
    }
    
    // Getter 方法
    public function getName(): string
    {
        return $this->name;
    }
    
    // Setter 方法，返回 $this 实现链式调用
    public function setName(string $name): self
    {
        $this->name = $name;
        return $this;
    }
    
    // 普通方法
    public function getInfo(): string
    {
        return "用户 {$this->name} ({$this->email})";
    }
    
    // 静态方法
    public static function getInstanceCount(): int
    {
        return self::$instanceCount;
    }
}

// 使用
$user = new User(1, '张三', 'zhangsan@example.com');
echo $user->getName();
echo $user->setName('张三丰')->getInfo();  // 链式调用
echo User::getInstanceCount();  // 静态方法调用
echo User::STATUS_ACTIVE;       // 常量访问
```

**PHP 8 构造器属性提升（更简洁的写法）：**

```php
<?php
class User
{
    public function __construct(
        private int $id,
        private string $name,
        private string $email,
        private DateTime $createdAt = new DateTime()
    ) {}
    
    // 其他方法...
}
```

这种写法将属性声明和构造函数参数合二为一，大大减少了样板代码。

### 2.3 继承与多态

```php
<?php
// 抽象类 - 不能直接实例化，必须被继承
abstract class Animal
{
    public function __construct(
        protected string $name
    ) {}
    
    // 抽象方法 - 子类必须实现
    abstract public function makeSound(): string;
    
    // 普通方法 - 子类可以继承或覆盖
    public function introduce(): string
    {
        return "我是 {$this->name}";
    }
}

class Dog extends Animal
{
    public function __construct(
        string $name,
        private string $breed
    ) {
        parent::__construct($name);  // 调用父类构造函数
    }
    
    public function makeSound(): string
    {
        return "汪汪！";
    }
    
    // 覆盖父类方法
    public function introduce(): string
    {
        return parent::introduce() . "，一只{$this->breed}";
    }
}

class Cat extends Animal
{
    public function makeSound(): string
    {
        return "喵喵~";
    }
}

// 多态的体现
function letAnimalSpeak(Animal $animal): void
{
    echo $animal->introduce() . "，我说: " . $animal->makeSound() . "\n";
}

$dog = new Dog("旺财", "金毛");
$cat = new Cat("咪咪");

letAnimalSpeak($dog);  // 我是 旺财，一只金毛，我说: 汪汪！
letAnimalSpeak($cat);  // 我是 咪咪，我说: 喵喵~
```

### 2.4 接口与特性（Trait）

```php
<?php
// 接口定义契约 - 类必须实现接口中声明的所有方法
interface Serializable
{
    public function serialize(): string;
    public function unserialize(string $data): void;
}

interface Printable
{
    public function print(): void;
}

// Trait 提供代码复用 - 解决 PHP 单继承的限制
trait Timestampable
{
    private DateTime $createdAt;
    private DateTime $updatedAt;
    
    public function initTimestamps(): void
    {
        $this->createdAt = new DateTime();
        $this->updatedAt = new DateTime();
    }
    
    public function touch(): void
    {
        $this->updatedAt = new DateTime();
    }
    
    public function getCreatedAt(): DateTime
    {
        return $this->createdAt;
    }
}

trait SoftDelete
{
    private ?DateTime $deletedAt = null;
    
    public function delete(): void
    {
        $this->deletedAt = new DateTime();
    }
    
    public function restore(): void
    {
        $this->deletedAt = null;
    }
    
    public function isDeleted(): bool
    {
        return $this->deletedAt !== null;
    }
}

// 一个类可以实现多个接口，使用多个 Trait
class Article implements Serializable, Printable
{
    use Timestampable, SoftDelete;
    
    public function __construct(
        private string $title,
        private string $content
    ) {
        $this->initTimestamps();
    }
    
    public function serialize(): string
    {
        return json_encode([
            'title' => $this->title,
            'content' => $this->content
        ]);
    }
    
    public function unserialize(string $data): void
    {
        $decoded = json_decode($data, true);
        $this->title = $decoded['title'];
        $this->content = $decoded['content'];
    }
    
    public function print(): void
    {
        echo "<article><h1>{$this->title}</h1><p>{$this->content}</p></article>";
    }
}
```

**核心概念解释：接口 vs 抽象类 vs Trait**

接口（Interface）定义"能做什么"——它是一份契约，规定实现类必须提供哪些方法，但不提供任何实现。一个类可以实现多个接口。

抽象类（Abstract Class）定义"是什么"——它可以包含部分实现，子类继承它并补充完成。一个类只能继承一个抽象类。

Trait 提供"怎么做"——它是代码复用的机制，可以把一组方法"混入"到多个类中，解决了 PHP 单继承的限制。

### 2.5 现代 PHP 特性

```php
<?php
// 枚举（PHP 8.1+）
enum Status: string
{
    case Draft = 'draft';
    case Published = 'published';
    case Archived = 'archived';
    
    public function label(): string
    {
        return match($this) {
            self::Draft => '草稿',
            self::Published => '已发布',
            self::Archived => '已归档',
        };
    }
}

$status = Status::Published;
echo $status->value;   // published
echo $status->label(); // 已发布

// 只读属性（PHP 8.1+）
class Post
{
    public function __construct(
        public readonly int $id,
        public readonly string $title,
        private string $content
    ) {}
}

$post = new Post(1, "Hello World", "内容...");
// $post->id = 2;  // 错误！只读属性初始化后不能修改

// 属性（Attributes，类似注解）（PHP 8+）
#[Attribute]
class Route
{
    public function __construct(
        public string $path,
        public string $method = 'GET'
    ) {}
}

class UserController
{
    #[Route('/users', 'GET')]
    public function index(): array
    {
        return ['users' => []];
    }
    
    #[Route('/users/{id}', 'GET')]
    public function show(int $id): array
    {
        return ['user' => ['id' => $id]];
    }
}

// 通过反射读取属性
$reflection = new ReflectionMethod(UserController::class, 'index');
$attributes = $reflection->getAttributes(Route::class);
foreach ($attributes as $attribute) {
    $route = $attribute->newInstance();
    echo "Path: {$route->path}, Method: {$route->method}\n";
}

// 联合类型和交叉类型（PHP 8+）
function processInput(string|int|array $input): void  // 联合类型：可以是这些类型之一
{
    // ...
}

interface Loggable {}
interface Serializable {}

function handle(Loggable&Serializable $obj): void  // 交叉类型：必须同时实现两个接口
{
    // ...
}
```

---

## 第三部分：Web 开发实战

### 3.1 处理 HTTP 请求

```php
<?php
// 超全局变量 - PHP 自动填充的预定义变量
$_GET       // URL 查询参数 ?name=value
$_POST      // POST 请求体数据
$_REQUEST   // GET + POST + COOKIE 的合集（不推荐使用，来源不明确）
$_FILES     // 上传的文件
$_COOKIE    // Cookie 数据
$_SESSION   // Session 数据
$_SERVER    // 服务器和执行环境信息

// 安全地获取输入数据
function getInput(string $key, mixed $default = null): mixed
{
    return $_POST[$key] ?? $_GET[$key] ?? $default;
}

// 验证和清理输入
$email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
$age = filter_input(INPUT_POST, 'age', FILTER_VALIDATE_INT, [
    'options' => ['min_range' => 1, 'max_range' => 150]
]);

if ($email === false) {
    echo "无效的邮箱地址";
}

// 文件上传处理
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['avatar'])) {
    $file = $_FILES['avatar'];
    
    // 验证
    $allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    $maxSize = 5 * 1024 * 1024;  // 5MB
    
    if ($file['error'] !== UPLOAD_ERR_OK) {
        die('上传失败');
    }
    
    if (!in_array($file['type'], $allowedTypes)) {
        die('不支持的文件类型');
    }
    
    if ($file['size'] > $maxSize) {
        die('文件太大');
    }
    
    // 生成安全的文件名
    $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
    $newName = bin2hex(random_bytes(16)) . '.' . $extension;
    
    // 移动到目标位置
    $destination = __DIR__ . '/uploads/' . $newName;
    if (move_uploaded_file($file['tmp_name'], $destination)) {
        echo "上传成功: {$newName}";
    }
}
```

### 3.2 Session 与 Cookie

```php
<?php
// Session - 服务器端存储，用于跨请求保持用户状态
session_start();  // 必须在任何输出之前调用

// 登录示例
function login(string $username, string $password): bool
{
    // 验证用户（这里简化了，实际应该查数据库）
    if ($username === 'admin' && password_verify($password, $hashedPassword)) {
        // 重新生成 Session ID 防止会话固定攻击
        session_regenerate_id(true);
        
        $_SESSION['user_id'] = 1;
        $_SESSION['username'] = $username;
        $_SESSION['login_time'] = time();
        
        return true;
    }
    return false;
}

// 检查是否登录
function isLoggedIn(): bool
{
    return isset($_SESSION['user_id']);
}

// 登出
function logout(): void
{
    $_SESSION = [];
    
    if (isset($_COOKIE[session_name()])) {
        setcookie(session_name(), '', time() - 3600, '/');
    }
    
    session_destroy();
}

// Cookie - 客户端存储
// 设置 Cookie（注意安全选项）
setcookie(
    name: 'preferences',
    value: json_encode(['theme' => 'dark', 'language' => 'zh']),
    expires_or_options: [
        'expires' => time() + 86400 * 30,  // 30 天后过期
        'path' => '/',
        'domain' => '',
        'secure' => true,      // 仅 HTTPS
        'httponly' => true,    // JavaScript 无法访问
        'samesite' => 'Lax'    // CSRF 防护
    ]
);

// 读取 Cookie
$preferences = isset($_COOKIE['preferences']) 
    ? json_decode($_COOKIE['preferences'], true) 
    : [];
```

### 3.3 数据库操作（PDO）

PDO（PHP Data Objects）是 PHP 访问数据库的现代、安全的方式。

```php
<?php
// 数据库连接类
class Database
{
    private static ?PDO $instance = null;
    
    public static function getInstance(): PDO
    {
        if (self::$instance === null) {
            $dsn = 'mysql:host=localhost;dbname=myapp;charset=utf8mb4';
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,           // 抛出异常
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,      // 返回关联数组
                PDO::ATTR_EMULATE_PREPARES => false,                    // 使用真正的预处理
            ];
            
            self::$instance = new PDO($dsn, 'username', 'password', $options);
        }
        
        return self::$instance;
    }
}

// 用户仓库类 - 封装数据库操作
class UserRepository
{
    private PDO $db;
    
    public function __construct()
    {
        $this->db = Database::getInstance();
    }
    
    // 查询单个用户
    public function findById(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM users WHERE id = :id');
        $stmt->execute(['id' => $id]);
        
        $user = $stmt->fetch();
        return $user ?: null;
    }
    
    // 查询所有用户（带分页）
    public function findAll(int $page = 1, int $perPage = 10): array
    {
        $offset = ($page - 1) * $perPage;
        
        $stmt = $this->db->prepare(
            'SELECT * FROM users ORDER BY created_at DESC LIMIT :limit OFFSET :offset'
        );
        $stmt->bindValue('limit', $perPage, PDO::PARAM_INT);
        $stmt->bindValue('offset', $offset, PDO::PARAM_INT);
        $stmt->execute();
        
        return $stmt->fetchAll();
    }
    
    // 按条件搜索
    public function search(string $keyword, ?string $role = null): array
    {
        $sql = 'SELECT * FROM users WHERE (name LIKE :keyword OR email LIKE :keyword)';
        $params = ['keyword' => "%{$keyword}%"];
        
        if ($role !== null) {
            $sql .= ' AND role = :role';
            $params['role'] = $role;
        }
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        
        return $stmt->fetchAll();
    }
    
    // 创建用户
    public function create(array $data): int
    {
        $stmt = $this->db->prepare('
            INSERT INTO users (name, email, password, role, created_at) 
            VALUES (:name, :email, :password, :role, NOW())
        ');
        
        $stmt->execute([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => password_hash($data['password'], PASSWORD_DEFAULT),
            'role' => $data['role'] ?? 'user'
        ]);
        
        return (int) $this->db->lastInsertId();
    }
    
    // 更新用户
    public function update(int $id, array $data): bool
    {
        $fields = [];
        $params = ['id' => $id];
        
        foreach ($data as $key => $value) {
            $fields[] = "{$key} = :{$key}";
            $params[$key] = $value;
        }
        
        $sql = 'UPDATE users SET ' . implode(', ', $fields) . ' WHERE id = :id';
        $stmt = $this->db->prepare($sql);
        
        return $stmt->execute($params);
    }
    
    // 删除用户
    public function delete(int $id): bool
    {
        $stmt = $this->db->prepare('DELETE FROM users WHERE id = :id');
        return $stmt->execute(['id' => $id]);
    }
    
    // 事务示例
    public function transfer(int $fromId, int $toId, float $amount): bool
    {
        try {
            $this->db->beginTransaction();
            
            // 扣款
            $stmt = $this->db->prepare(
                'UPDATE accounts SET balance = balance - :amount WHERE user_id = :id AND balance >= :amount'
            );
            $stmt->execute(['amount' => $amount, 'id' => $fromId]);
            
            if ($stmt->rowCount() === 0) {
                throw new Exception('余额不足');
            }
            
            // 入账
            $stmt = $this->db->prepare(
                'UPDATE accounts SET balance = balance + :amount WHERE user_id = :id'
            );
            $stmt->execute(['amount' => $amount, 'id' => $toId]);
            
            $this->db->commit();
            return true;
            
        } catch (Exception $e) {
            $this->db->rollBack();
            throw $e;
        }
    }
}
```

**核心概念解释：预处理语句（Prepared Statements）**

永远不要直接把用户输入拼接到 SQL 语句中！这会导致 SQL 注入攻击。预处理语句使用占位符（`:name` 或 `?`），让数据库引擎区分代码和数据，从根本上防止 SQL 注入。

```php
// 危险！！SQL 注入漏洞
$sql = "SELECT * FROM users WHERE name = '$_GET[name]'";  // 绝对不要这样做

// 安全 - 使用预处理语句
$stmt = $pdo->prepare('SELECT * FROM users WHERE name = :name');
$stmt->execute(['name' => $_GET['name']]);
```

---

## 第四部分：现代 PHP 开发实践

### 4.1 Composer 与自动加载

Composer 是 PHP 的依赖管理工具，也是现代 PHP 开发的基石。

```json
{
    "name": "myapp/website",
    "description": "我的网站项目",
    "type": "project",
    "require": {
        "php": "^8.2",
        "monolog/monolog": "^3.0",
        "vlucas/phpdotenv": "^5.5"
    },
    "require-dev": {
        "phpunit/phpunit": "^10.0",
        "phpstan/phpstan": "^1.10"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "Tests\\": "tests/"
        }
    }
}
```

```php
<?php
// 项目入口文件只需要引入 autoload
require __DIR__ . '/vendor/autoload.php';

// 然后就可以使用任何通过 Composer 安装的包和自己的类
use App\Controllers\UserController;
use Monolog\Logger;
use Monolog\Handler\StreamHandler;

$logger = new Logger('app');
$logger->pushHandler(new StreamHandler('logs/app.log', Logger::DEBUG));

$controller = new UserController();
```

**目录结构建议：**

```
project/
├── composer.json
├── composer.lock
├── vendor/           # Composer 管理，不要手动修改
├── public/           # Web 根目录，只有 index.php
│   └── index.php
├── src/              # 应用代码
│   ├── Controllers/
│   ├── Models/
│   ├── Services/
│   └── Views/
├── config/           # 配置文件
├── tests/            # 测试代码
└── logs/             # 日志文件
```

### 4.2 错误处理与异常

```php
<?php
// 自定义异常
class ValidationException extends Exception
{
    private array $errors;
    
    public function __construct(array $errors)
    {
        $this->errors = $errors;
        parent::__construct('验证失败');
    }
    
    public function getErrors(): array
    {
        return $this->errors;
    }
}

class NotFoundException extends Exception
{
    public function __construct(string $resource, int|string $id)
    {
        parent::__construct("{$resource} #{$id} 不存在");
    }
}

// 使用异常
class UserService
{
    public function __construct(
        private UserRepository $repository
    ) {}
    
    public function createUser(array $data): array
    {
        // 验证
        $errors = [];
        
        if (empty($data['name'])) {
            $errors['name'] = '姓名不能为空';
        }
        
        if (empty($data['email']) || !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $errors['email'] = '请提供有效的邮箱地址';
        }
        
        if (!empty($errors)) {
            throw new ValidationException($errors);
        }
        
        $id = $this->repository->create($data);
        return $this->repository->findById($id);
    }
    
    public function getUser(int $id): array
    {
        $user = $this->repository->findById($id);
        
        if ($user === null) {
            throw new NotFoundException('User', $id);
        }
        
        return $user;
    }
}

// 全局异常处理器
set_exception_handler(function (Throwable $e) {
    $code = 500;
    $message = '服务器内部错误';
    $details = null;
    
    if ($e instanceof ValidationException) {
        $code = 422;
        $message = '验证失败';
        $details = $e->getErrors();
    } elseif ($e instanceof NotFoundException) {
        $code = 404;
        $message = $e->getMessage();
    }
    
    http_response_code($code);
    header('Content-Type: application/json');
    
    echo json_encode([
        'error' => true,
        'message' => $message,
        'details' => $details,
    ]);
    
    // 记录日志（生产环境中记录完整错误）
    error_log($e->getMessage() . "\n" . $e->getTraceAsString());
});

// 控制器中使用
try {
    $user = $userService->createUser($_POST);
    echo json_encode(['success' => true, 'user' => $user]);
} catch (ValidationException $e) {
    http_response_code(422);
    echo json_encode(['errors' => $e->getErrors()]);
}
```

### 4.3 简单的 MVC 框架示例

```php
<?php
// 路由器
class Router
{
    private array $routes = [];
    
    public function get(string $path, callable|array $handler): self
    {
        $this->routes['GET'][$path] = $handler;
        return $this;
    }
    
    public function post(string $path, callable|array $handler): self
    {
        $this->routes['POST'][$path] = $handler;
        return $this;
    }
    
    public function dispatch(string $method, string $uri): mixed
    {
        // 移除查询字符串
        $path = parse_url($uri, PHP_URL_PATH);
        
        foreach ($this->routes[$method] ?? [] as $route => $handler) {
            // 转换路由参数 {id} 为正则表达式
            $pattern = preg_replace('/\{(\w+)\}/', '(?P<$1>[^/]+)', $route);
            $pattern = "#^{$pattern}$#";
            
            if (preg_match($pattern, $path, $matches)) {
                // 过滤出命名参数
                $params = array_filter($matches, 'is_string', ARRAY_FILTER_USE_KEY);
                
                if (is_array($handler)) {
                    [$class, $method] = $handler;
                    $controller = new $class();
                    return $controller->$method(...array_values($params));
                }
                
                return $handler(...array_values($params));
            }
        }
        
        throw new NotFoundException('Route', $path);
    }
}

// 基础控制器
abstract class Controller
{
    protected function json(mixed $data, int $status = 200): never
    {
        http_response_code($status);
        header('Content-Type: application/json');
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        exit;
    }
    
    protected function view(string $template, array $data = []): never
    {
        extract($data);
        require __DIR__ . "/views/{$template}.php";
        exit;
    }
}

// 用户控制器
class UserController extends Controller
{
    private UserRepository $users;
    
    public function __construct()
    {
        $this->users = new UserRepository();
    }
    
    public function index(): never
    {
        $users = $this->users->findAll();
        $this->json(['users' => $users]);
    }
    
    public function show(string $id): never
    {
        $user = $this->users->findById((int) $id);
        
        if (!$user) {
            $this->json(['error' => '用户不存在'], 404);
        }
        
        $this->json(['user' => $user]);
    }
    
    public function store(): never
    {
        $data = json_decode(file_get_contents('php://input'), true);
        $id = $this->users->create($data);
        $user = $this->users->findById($id);
        
        $this->json(['user' => $user], 201);
    }
}

// 入口文件 public/index.php
require __DIR__ . '/../vendor/autoload.php';

$router = new Router();

$router->get('/', fn() => ['message' => 'Welcome to my API']);
$router->get('/users', [UserController::class, 'index']);
$router->get('/users/{id}', [UserController::class, 'show']);
$router->post('/users', [UserController::class, 'store']);

try {
    $result = $router->dispatch($_SERVER['REQUEST_METHOD'], $_SERVER['REQUEST_URI']);
    
    header('Content-Type: application/json');
    echo json_encode($result, JSON_UNESCAPED_UNICODE);
    
} catch (NotFoundException $e) {
    http_response_code(404);
    echo json_encode(['error' => $e->getMessage()]);
}
```

### 4.4 安全最佳实践

```php
<?php
class Security
{
    // 密码哈希（使用 PHP 内置函数，自动处理盐值）
    public static function hashPassword(string $password): string
    {
        return password_hash($password, PASSWORD_DEFAULT);
    }
    
    public static function verifyPassword(string $password, string $hash): bool
    {
        return password_verify($password, $hash);
    }
    
    // 检查密码是否需要重新哈希（算法更新时）
    public static function needsRehash(string $hash): bool
    {
        return password_needs_rehash($hash, PASSWORD_DEFAULT);
    }
    
    // XSS 防护 - 输出 HTML 时必须转义
    public static function escape(string $string): string
    {
        return htmlspecialchars($string, ENT_QUOTES | ENT_HTML5, 'UTF-8');
    }
    
    // CSRF 令牌生成
    public static function generateCsrfToken(): string
    {
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }
    
    // CSRF 令牌验证
    public static function verifyCsrfToken(string $token): bool
    {
        return isset($_SESSION['csrf_token']) 
            && hash_equals($_SESSION['csrf_token'], $token);
    }
    
    // 生成安全的随机字符串
    public static function randomString(int $length = 32): string
    {
        return bin2hex(random_bytes($length / 2));
    }
}

// 在表单中使用 CSRF 令牌
?>
<form method="POST" action="/submit">
    <input type="hidden" name="csrf_token" value="<?= Security::generateCsrfToken() ?>">
    <input type="text" name="content">
    <button type="submit">提交</button>
</form>

<?php
// 处理表单时验证
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!Security::verifyCsrfToken($_POST['csrf_token'] ?? '')) {
        die('无效的请求');
    }
    // 处理表单...
}

// 输出用户内容时必须转义
$userComment = $_POST['content'];
?>
<div class="comment">
    <?= Security::escape($userComment) ?>
</div>
```

---

## 第五部分：测试

### 5.1 PHPUnit 单元测试

```php
<?php
// tests/UserServiceTest.php
use PHPUnit\Framework\TestCase;

class UserServiceTest extends TestCase
{
    private UserService $service;
    private UserRepository $repository;
    
    protected function setUp(): void
    {
        // 创建模拟对象
        $this->repository = $this->createMock(UserRepository::class);
        $this->service = new UserService($this->repository);
    }
    
    public function testCreateUserWithValidData(): void
    {
        $userData = [
            'name' => '张三',
            'email' => 'zhangsan@example.com',
            'password' => 'secret123'
        ];
        
        $this->repository
            ->expects($this->once())
            ->method('create')
            ->with($userData)
            ->willReturn(1);
            
        $this->repository
            ->expects($this->once())
            ->method('findById')
            ->with(1)
            ->willReturn(['id' => 1, ...$userData]);
        
        $result = $this->service->createUser($userData);
        
        $this->assertEquals(1, $result['id']);
        $this->assertEquals('张三', $result['name']);
    }
    
    public function testCreateUserWithInvalidEmailThrowsException(): void
    {
        $this->expectException(ValidationException::class);
        
        $this->service->createUser([
            'name' => '张三',
            'email' => 'invalid-email',
            'password' => 'secret123'
        ]);
    }
    
    public function testGetUserReturnsUser(): void
    {
        $expected = ['id' => 1, 'name' => '张三'];
        
        $this->repository
            ->method('findById')
            ->with(1)
            ->willReturn($expected);
        
        $result = $this->service->getUser(1);
        
        $this->assertEquals($expected, $result);
    }
    
    public function testGetUserThrowsNotFoundForMissingUser(): void
    {
        $this->expectException(NotFoundException::class);
        
        $this->repository
            ->method('findById')
            ->willReturn(null);
        
        $this->service->getUser(999);
    }
    
    /**
     * @dataProvider validEmailProvider
     */
    public function testValidEmailFormats(string $email): void
    {
        $this->repository->method('create')->willReturn(1);
        $this->repository->method('findById')->willReturn(['id' => 1]);
        
        $result = $this->service->createUser([
            'name' => 'Test',
            'email' => $email,
            'password' => 'secret'
        ]);
        
        $this->assertNotNull($result);
    }
    
    public static function validEmailProvider(): array
    {
        return [
            ['test@example.com'],
            ['user.name@domain.org'],
            ['user+tag@example.co.uk'],
        ];
    }
}
```

运行测试：`./vendor/bin/phpunit tests/`

---

## 第六部分：实战项目 - 简单的博客 API

下面是一个完整的小项目，整合了前面学到的知识。

```php
<?php
// config/database.php
return [
    'host' => $_ENV['DB_HOST'] ?? 'localhost',
    'name' => $_ENV['DB_NAME'] ?? 'blog',
    'user' => $_ENV['DB_USER'] ?? 'root',
    'pass' => $_ENV['DB_PASS'] ?? '',
];

// src/Models/Post.php
class Post
{
    public function __construct(
        public readonly ?int $id,
        public string $title,
        public string $content,
        public string $slug,
        public Status $status = Status::Draft,
        public ?DateTime $publishedAt = null,
        public readonly ?DateTime $createdAt = null,
    ) {}
    
    public static function fromArray(array $data): self
    {
        return new self(
            id: $data['id'] ?? null,
            title: $data['title'],
            content: $data['content'],
            slug: $data['slug'] ?? self::generateSlug($data['title']),
            status: Status::from($data['status'] ?? 'draft'),
            publishedAt: isset($data['published_at']) ? new DateTime($data['published_at']) : null,
            createdAt: isset($data['created_at']) ? new DateTime($data['created_at']) : null,
        );
    }
    
    public function toArray(): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'content' => $this->content,
            'slug' => $this->slug,
            'status' => $this->status->value,
            'published_at' => $this->publishedAt?->format('Y-m-d H:i:s'),
            'created_at' => $this->createdAt?->format('Y-m-d H:i:s'),
        ];
    }
    
    private static function generateSlug(string $title): string
    {
        $slug = preg_replace('/[^a-z0-9]+/i', '-', $title);
        return strtolower(trim($slug, '-'));
    }
    
    public function publish(): void
    {
        $this->status = Status::Published;
        $this->publishedAt = new DateTime();
    }
}

// src/Repositories/PostRepository.php
class PostRepository
{
    public function __construct(private PDO $db) {}
    
    public function findAll(int $limit = 10, int $offset = 0): array
    {
        $stmt = $this->db->prepare('
            SELECT * FROM posts 
            WHERE status = :status 
            ORDER BY published_at DESC 
            LIMIT :limit OFFSET :offset
        ');
        
        $stmt->bindValue('status', Status::Published->value);
        $stmt->bindValue('limit', $limit, PDO::PARAM_INT);
        $stmt->bindValue('offset', $offset, PDO::PARAM_INT);
        $stmt->execute();
        
        return array_map(
            fn($row) => Post::fromArray($row),
            $stmt->fetchAll()
        );
    }
    
    public function findBySlug(string $slug): ?Post
    {
        $stmt = $this->db->prepare('SELECT * FROM posts WHERE slug = :slug');
        $stmt->execute(['slug' => $slug]);
        
        $row = $stmt->fetch();
        return $row ? Post::fromArray($row) : null;
    }
    
    public function save(Post $post): Post
    {
        if ($post->id === null) {
            return $this->insert($post);
        }
        return $this->update($post);
    }
    
    private function insert(Post $post): Post
    {
        $stmt = $this->db->prepare('
            INSERT INTO posts (title, content, slug, status, published_at, created_at)
            VALUES (:title, :content, :slug, :status, :published_at, NOW())
        ');
        
        $stmt->execute([
            'title' => $post->title,
            'content' => $post->content,
            'slug' => $post->slug,
            'status' => $post->status->value,
            'published_at' => $post->publishedAt?->format('Y-m-d H:i:s'),
        ]);
        
        return $this->findBySlug($post->slug);
    }
    
    private function update(Post $post): Post
    {
        $stmt = $this->db->prepare('
            UPDATE posts 
            SET title = :title, content = :content, slug = :slug, 
                status = :status, published_at = :published_at
            WHERE id = :id
        ');
        
        $stmt->execute([
            'id' => $post->id,
            'title' => $post->title,
            'content' => $post->content,
            'slug' => $post->slug,
            'status' => $post->status->value,
            'published_at' => $post->publishedAt?->format('Y-m-d H:i:s'),
        ]);
        
        return $this->findBySlug($post->slug);
    }
}

// src/Controllers/PostController.php
class PostController extends Controller
{
    public function __construct(
        private PostRepository $posts
    ) {}
    
    public function index(): never
    {
        $page = (int) ($_GET['page'] ?? 1);
        $perPage = 10;
        
        $posts = $this->posts->findAll($perPage, ($page - 1) * $perPage);
        
        $this->json([
            'data' => array_map(fn($p) => $p->toArray(), $posts),
            'meta' => ['page' => $page, 'per_page' => $perPage]
        ]);
    }
    
    public function show(string $slug): never
    {
        $post = $this->posts->findBySlug($slug);
        
        if (!$post) {
            $this->json(['error' => '文章不存在'], 404);
        }
        
        $this->json(['data' => $post->toArray()]);
    }
    
    public function store(): never
    {
        $input = json_decode(file_get_contents('php://input'), true);
        
        $post = new Post(
            id: null,
            title: $input['title'],
            content: $input['content'],
            slug: $input['slug'] ?? null,
        );
        
        if ($input['publish'] ?? false) {
            $post->publish();
        }
        
        $saved = $this->posts->save($post);
        
        $this->json(['data' => $saved->toArray()], 201);
    }
}
```

---

## 学习路线建议

对于 PHP 新手，建议按以下顺序学习：

**第一阶段**应该掌握基础语法，包括变量、数据类型、数组、控制结构和函数。这是一切的基础，需要多写代码练习，直到能够自如地使用这些基本构建块。

**第二阶段**学习面向对象编程，理解类、对象、继承、接口和 Trait。现代 PHP 项目几乎都是面向对象的，这一步至关重要。

**第三阶段**进入 Web 开发实战，学习处理 HTTP 请求、Session、Cookie，以及使用 PDO 操作数据库。特别要注意安全相关的知识。

**第四阶段**学习现代开发工具和实践，包括 Composer 包管理、PSR 规范、单元测试和代码质量工具。

**第五阶段**可以开始学习主流框架，如 Laravel 或 Symfony。有了前面的基础，学习框架会事半功倍。

---

## 推荐资源

官方资源方面，PHP 官方文档（php.net）是最权威的参考，遇到任何函数不确定时都应该查阅。PHP The Right Way（phptherightway.com）是社区整理的最佳实践指南，强烈推荐阅读。

工具方面，PHPStorm 是最强大的 PHP IDE，对初学者也很友好，能够帮助你写出更好的代码。如果需要免费选择，VS Code 配合 PHP Intelephense 插件也是不错的选择。

