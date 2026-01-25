[toc]

# Lua 系统学习指南

Lua 是一门轻量级、高效、可嵌入的脚本语言，诞生于 1993 年的巴西里约热内卢天主教大学。它的名字在葡萄牙语中意为"月亮"，这个优雅的名字恰如其分地反映了这门语言的设计哲学：简洁、优雅、照亮其他系统。

------

## 第一章：Lua 的世界观

### 1.1 为什么选择 Lua

Lua 的设计遵循"简单即美"的原则。整个语言的解释器编译后只有约 200KB，却提供了强大的表达能力。这种极简主义使得 Lua 成为游戏开发、嵌入式系统、配置文件和快速原型开发的首选语言。

在实际应用中，你会在这些地方发现 Lua 的身影：魔兽世界的插件系统、Nginx 的 OpenResty 扩展、Redis 的脚本功能、Neovim 的配置系统，以及无数游戏引擎如 Corona SDK、Defold 和 LÖVE。

### 1.2 安装与环境配置

在不同操作系统上安装 Lua 的方式各有不同。

- 对于 macOS 用户，可以通过 Homebrew 执行 `brew install lua` 完成安装。
- Linux 用户则可以使用各自发行版的包管理器，例如 Ubuntu 上的 `sudo apt install lua5.4`。
- Windows 用户推荐从 LuaBinaries 项目下载预编译版本，或者使用 LuaRocks 生态系统。

安装完成后，在终端输入 `lua -v` 应该能看到版本信息。本指南基于 Lua 5.4 版本。

### 1.3 第一个程序

```lua
-- 这是 Lua 的单行注释
--[[
    这是多行注释
    可以跨越多行
]]

print("你好，Lua 世界！")
```

将上述代码保存为 `hello.lua`，然后在终端执行 `lua hello.lua`，你将看到问候语输出。这个简单的程序展示了 Lua 的几个特点：注释语法简洁，`print` 函数是内置的全局函数，字符串可以用双引号或单引号包裹。

------

## 第二章：数据类型与变量

### 2.1 八种基本类型

Lua 是动态类型语言，变量本身没有类型，值才有类型。整个语言只有八种基本类型，这种极简设计是 Lua 轻量级的重要原因。

```lua
-- nil：表示"无"或"不存在"
local nothing = nil
print(type(nothing))  --> nil

-- boolean：只有 true 和 false 两个值
local is_active = true
local is_finished = false
-- 重要：在 Lua 中，只有 nil 和 false 为假，其他所有值都为真
-- 这意味着 0、空字符串 "" 都是真值！
if 0 then print("0 在 Lua 中是真值") end
if "" then print("空字符串在 Lua 中也是真值") end

-- number：Lua 5.3 之前只有双精度浮点数
-- 从 Lua 5.3 开始，区分整数和浮点数
local integer_num = 42           -- 整数
local float_num = 3.14159        -- 浮点数
local scientific = 6.02e23       -- 科学计数法
local hex_num = 0xff             -- 十六进制，值为 255

-- string：不可变的字节序列
local greeting = "Hello"
local name = 'World'
local long_text = [[
    这是长字符串语法
    可以包含换行符
    不需要转义引号 "like this"
]]

-- function：函数是第一类值
local add = function(a, b) return a + b end
print(type(add))  --> function

-- table：Lua 唯一的数据结构，极其强大
local person = {name = "张三", age = 25}
print(type(person))  --> table

-- userdata：用于存储 C 数据，通常由宿主程序创建
-- thread：协程类型
```

### 2.2 变量与作用域

Lua 的作用域规则简单而重要。变量默认是全局的，使用 `local` 关键字声明局部变量。

```lua
-- 全局变量（不推荐使用，除非确实需要）
global_var = "我是全局的"

-- 局部变量（最佳实践：始终使用 local）
local local_var = "我是局部的"

-- 作用域演示
local x = 10
do
    local x = 20  -- 这是新的局部变量，遮蔽了外层的 x
    print(x)      --> 20
end
print(x)          --> 10

-- 变量遮蔽的实际应用
local function process_data(data)
    local data = data or {}  -- 创建局部副本，避免修改原始参数
    -- 处理 data...
    return data
end
```

**最佳实践**：始终使用 `local` 声明变量。全局变量查找需要遍历环境表，而局部变量存储在寄存器中，访问速度更快。此外，局部变量的作用域明确，有助于避免命名冲突和意外修改。

### 2.3 字符串操作

字符串在 Lua 中是不可变的，任何修改操作都会创建新字符串。

```lua
local str = "Hello, Lua!"

-- 字符串长度（返回字节数，非字符数）
print(#str)  --> 11

-- 字符串连接使用 .. 运算符
local full_name = "张" .. "三"
print(full_name)  --> 张三

-- 注意：大量字符串连接应使用 table.concat
local parts = {}
for i = 1, 1000 do
    parts[i] = tostring(i)
end
local result = table.concat(parts, ", ")  -- 高效

-- string 库常用函数
local text = "  Hello, World!  "

print(string.upper(text))           --> "  HELLO, WORLD!  "
print(string.lower(text))           --> "  hello, world!  "
print(string.len(text))             --> 17
print(string.sub(text, 3, 7))       --> "Hello"
print(string.find(text, "World"))   --> 10 14（起始和结束位置）
print(string.gsub(text, "World", "Lua"))  --> "  Hello, Lua!  " 1

-- 格式化字符串
local name = "Alice"
local age = 30
local formatted = string.format("姓名: %s, 年龄: %d", name, age)
print(formatted)  --> 姓名: Alice, 年龄: 30

-- 格式化说明符
-- %s: 字符串
-- %d: 整数
-- %f: 浮点数（%.2f 表示保留两位小数）
-- %x: 十六进制
-- %q: 带引号的字符串（适合生成 Lua 代码）
print(string.format("价格: %.2f 元", 19.9))  --> 价格: 19.90 元
```

### 2.4 数值运算

```lua
-- 基本算术运算
local a, b = 17, 5
print(a + b)   --> 22
print(a - b)   --> 12
print(a * b)   --> 85
print(a / b)   --> 3.4（始终返回浮点数）
print(a // b)  --> 3（整除，Lua 5.3+）
print(a % b)   --> 2（取模）
print(a ^ 2)   --> 289（幂运算）
print(-a)      --> -17

-- 位运算（Lua 5.3+）
local x, y = 12, 10
print(x & y)   --> 8（按位与）
print(x | y)   --> 14（按位或）
print(x ~ y)   --> 6（按位异或）
print(~x)      --> -13（按位取反）
print(x << 2)  --> 48（左移）
print(x >> 1)  --> 6（右移）

-- math 库
print(math.abs(-5))       --> 5
print(math.ceil(4.2))     --> 5
print(math.floor(4.8))    --> 4
print(math.max(1, 5, 3))  --> 5
print(math.min(1, 5, 3))  --> 1
print(math.sqrt(16))      --> 4.0
print(math.random())      --> 0 到 1 之间的随机数
print(math.random(1, 100))  --> 1 到 100 之间的随机整数

-- 设置随机种子（通常在程序开始时执行一次）
math.randomseed(os.time())
```

------

## 第三章：表（Table）—— Lua 的灵魂

Table 是 Lua 中唯一的数据结构，但它足以表达数组、字典、集合、对象、模块、命名空间等几乎所有数据结构。理解 table 是掌握 Lua 的关键。

### 3.1 Table 基础

```lua
-- 创建空表
local empty = {}

-- 数组风格（索引从 1 开始，这是 Lua 的重要约定！）
local fruits = {"apple", "banana", "cherry"}
print(fruits[1])  --> apple（不是 fruits[0]！）
print(#fruits)    --> 3（# 运算符返回数组长度）

-- 字典风格
local person = {
    name = "李四",
    age = 28,
    ["favorite color"] = "blue"  -- 键包含空格时必须用方括号
}
print(person.name)              --> 李四
print(person["name"])           --> 李四（两种访问方式等价）
print(person["favorite color"]) --> blue

-- 混合风格
local mixed = {
    "first",                    -- 索引 1
    "second",                   -- 索引 2
    name = "mixed table",       -- 字符串键
    [10] = "tenth",             -- 数字键 10
    [function() end] = "func"   -- 函数也可以作为键！
}

-- 嵌套表
local company = {
    name = "Tech Corp",
    employees = {
        {name = "Alice", role = "Engineer"},
        {name = "Bob", role = "Designer"}
    },
    address = {
        city = "北京",
        street = "科技路 123 号"
    }
}
print(company.employees[1].name)  --> Alice
```

### 3.2 Table 作为数组

```lua
local arr = {10, 20, 30, 40, 50}

-- 遍历数组的标准方式
for i, v in ipairs(arr) do
    print(i, v)
end
-- 输出:
-- 1    10
-- 2    20
-- 3    30
-- 4    40
-- 5    50

-- 添加元素
arr[#arr + 1] = 60        -- 在末尾添加
table.insert(arr, 70)      -- 同上
table.insert(arr, 3, 25)   -- 在位置 3 插入

-- 删除元素
local removed = table.remove(arr)     -- 删除并返回最后一个
local removed3 = table.remove(arr, 3) -- 删除并返回位置 3 的元素

-- 排序
local nums = {3, 1, 4, 1, 5, 9, 2, 6}
table.sort(nums)  -- 原地升序排序
-- nums 现在是 {1, 1, 2, 3, 4, 5, 6, 9}

-- 自定义排序
local people = {
    {name = "Charlie", age = 25},
    {name = "Alice", age = 30},
    {name = "Bob", age = 20}
}
table.sort(people, function(a, b)
    return a.age < b.age  -- 按年龄升序
end)

-- 数组合并为字符串
local words = {"Lua", "is", "awesome"}
print(table.concat(words, " "))  --> Lua is awesome
```

### 3.3 Table 作为字典

```lua
local dict = {
    apple = "苹果",
    banana = "香蕉",
    cherry = "樱桃"
}

-- 遍历字典（顺序不保证）
for key, value in pairs(dict) do
    print(key .. " -> " .. value)
end

-- 检查键是否存在
if dict.apple then
    print("找到了 apple")
end

-- 删除键值对
dict.banana = nil

-- 获取表中的键数量（没有内置函数，需要手动计数）
local function table_length(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- 安全访问嵌套表
local data = {
    user = {
        profile = {
            name = "Test"
        }
    }
}

-- 危险：如果 user 或 profile 不存在会报错
-- print(data.user.profile.name)

-- 安全的访问方式
local function safe_get(t, ...)
    local value = t
    for _, key in ipairs({...}) do
        if type(value) ~= "table" then
            return nil
        end
        value = value[key]
    end
    return value
end

print(safe_get(data, "user", "profile", "name"))  --> Test
print(safe_get(data, "user", "missing", "name"))  --> nil
```

### 3.4 Table 作为集合

```lua
-- 使用表实现集合
local function Set(list)
    local set = {}
    for _, v in ipairs(list) do
        set[v] = true
    end
    return set
end

local fruits = Set{"apple", "banana", "cherry"}

-- 检查成员
print(fruits["apple"])   --> true
print(fruits["orange"])  --> nil（视为 false）

-- 集合运算
local function union(a, b)
    local result = {}
    for k in pairs(a) do result[k] = true end
    for k in pairs(b) do result[k] = true end
    return result
end

local function intersection(a, b)
    local result = {}
    for k in pairs(a) do
        if b[k] then result[k] = true end
    end
    return result
end

local function difference(a, b)
    local result = {}
    for k in pairs(a) do
        if not b[k] then result[k] = true end
    end
    return result
end
```

### 3.5 Table 的引用语义

理解表的引用语义对于正确使用 Lua 至关重要。

```lua
-- 表是引用类型
local a = {x = 10}
local b = a       -- b 和 a 指向同一个表
b.x = 20
print(a.x)        --> 20（a 也被修改了！）

-- 浅拷贝
local function shallow_copy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

local c = shallow_copy(a)
c.x = 30
print(a.x)  --> 20（a 不受影响）

-- 深拷贝（处理嵌套表）
local function deep_copy(t, seen)
    if type(t) ~= "table" then
        return t
    end
    seen = seen or {}
    if seen[t] then
        return seen[t]  -- 处理循环引用
    end
    local copy = {}
    seen[t] = copy
    for k, v in pairs(t) do
        copy[deep_copy(k, seen)] = deep_copy(v, seen)
    end
    return setmetatable(copy, getmetatable(t))
end
```

------

## 第四章：控制结构

### 4.1 条件语句

```lua
local score = 85

-- 基本 if-else
if score >= 90 then
    print("优秀")
elseif score >= 80 then
    print("良好")
elseif score >= 60 then
    print("及格")
else
    print("不及格")
end

-- Lua 没有 switch 语句，可以用表模拟
local actions = {
    start = function() print("开始") end,
    stop = function() print("停止") end,
    pause = function() print("暂停") end
}

local command = "start"
local action = actions[command]
if action then
    action()
else
    print("未知命令")
end

-- 三元运算符模拟（注意陷阱！）
local x = 10
local result = x > 5 and "大于5" or "不大于5"
print(result)  --> 大于5

-- 陷阱：当真值分支返回 false 或 nil 时会出错
local value = false
local bad = true and value or "default"  -- 结果是 "default"，而非 false！

-- 正确的条件选择函数
local function ternary(cond, t, f)
    if cond then return t else return f end
end
```

### 4.2 循环语句

```lua
-- while 循环
local i = 1
while i <= 5 do
    print(i)
    i = i + 1
end

-- repeat-until 循环（至少执行一次）
local j = 1
repeat
    print(j)
    j = j + 1
until j > 5

-- 数值 for 循环
for k = 1, 10 do          -- 从 1 到 10，步长为 1
    print(k)
end

for k = 10, 1, -1 do      -- 从 10 到 1，步长为 -1
    print(k)
end

for k = 0, 1, 0.1 do      -- 浮点数步长
    print(k)
end

-- 泛型 for 循环（使用迭代器）
local colors = {"red", "green", "blue"}

-- ipairs：按顺序遍历数组部分
for index, color in ipairs(colors) do
    print(index, color)
end

-- pairs：遍历所有键值对
local config = {host = "localhost", port = 8080, debug = true}
for key, value in pairs(config) do
    print(key, value)
end

-- break：跳出循环
for i = 1, 100 do
    if i > 10 then
        break
    end
    print(i)
end

-- Lua 没有 continue，但可以用其他方式模拟
for i = 1, 10 do
    repeat  -- 模拟 continue 的技巧
        if i % 2 == 0 then
            break  -- 跳过偶数，相当于 continue
        end
        print(i)
    until true
end

-- 更现代的方式：使用 goto（Lua 5.2+）
for i = 1, 10 do
    if i % 2 == 0 then
        goto continue
    end
    print(i)
    ::continue::
end
```

------

## 第五章：函数

函数是 Lua 中的第一类值，这意味着函数可以存储在变量中、作为参数传递、作为返回值返回。

### 5.1 函数基础

```lua
-- 函数定义的两种方式
function greet(name)
    return "Hello, " .. name .. "!"
end

local greet2 = function(name)
    return "Hi, " .. name .. "!"
end

-- 多返回值（Lua 的独特特性）
local function get_user_info()
    return "Alice", 25, "alice@example.com"
end

local name, age, email = get_user_info()
print(name, age, email)  --> Alice  25  alice@example.com

-- 忽略某些返回值
local name_only = get_user_info()  -- 只取第一个
local _, age_only = get_user_info()  -- 忽略第一个，取第二个

-- 可变参数
local function sum(...)
    local args = {...}  -- 将可变参数收集到表中
    local total = 0
    for _, v in ipairs(args) do
        total = total + v
    end
    return total
end

print(sum(1, 2, 3, 4, 5))  --> 15

-- select 函数处理可变参数
local function demo_select(...)
    print(select("#", ...))      -- 参数数量
    print(select(2, ...))        -- 从第 2 个开始的所有参数
end

demo_select("a", "b", "c", "d")
--> 4
--> b  c  d

-- 默认参数（使用 or 实现）
local function create_user(name, age, role)
    name = name or "Anonymous"
    age = age or 0
    role = role or "guest"
    return {name = name, age = age, role = role}
end
```

### 5.2 闭包

闭包是函数和其引用环境的组合，是 Lua 中最强大的特性之一。

```lua
-- 简单闭包：计数器
local function create_counter()
    local count = 0  -- 这个变量被闭包"捕获"
    return function()
        count = count + 1
        return count
    end
end

local counter1 = create_counter()
local counter2 = create_counter()

print(counter1())  --> 1
print(counter1())  --> 2
print(counter2())  --> 1（独立的计数器）

-- 闭包实现私有状态
local function create_bank_account(initial_balance)
    local balance = initial_balance  -- 私有变量
    
    return {
        deposit = function(amount)
            balance = balance + amount
            return balance
        end,
        withdraw = function(amount)
            if amount > balance then
                return nil, "余额不足"
            end
            balance = balance - amount
            return balance
        end,
        get_balance = function()
            return balance
        end
    }
end

local account = create_bank_account(1000)
print(account.get_balance())    --> 1000
print(account.deposit(500))     --> 1500
print(account.withdraw(200))    --> 1300
-- balance 变量无法从外部直接访问

-- 闭包实现记忆化（缓存）
local function memoize(fn)
    local cache = {}
    return function(x)
        if cache[x] == nil then
            cache[x] = fn(x)
        end
        return cache[x]
    end
end

local slow_fib
slow_fib = function(n)
    if n < 2 then return n end
    return slow_fib(n - 1) + slow_fib(n - 2)
end

local fast_fib = memoize(function(n)
    if n < 2 then return n end
    return fast_fib(n - 1) + fast_fib(n - 2)
end)
```

### 5.3 高阶函数

```lua
-- 函数作为参数
local function map(t, fn)
    local result = {}
    for i, v in ipairs(t) do
        result[i] = fn(v)
    end
    return result
end

local numbers = {1, 2, 3, 4, 5}
local squares = map(numbers, function(x) return x * x end)
-- squares = {1, 4, 9, 16, 25}

-- filter
local function filter(t, predicate)
    local result = {}
    for _, v in ipairs(t) do
        if predicate(v) then
            result[#result + 1] = v
        end
    end
    return result
end

local evens = filter(numbers, function(x) return x % 2 == 0 end)
-- evens = {2, 4}

-- reduce
local function reduce(t, fn, initial)
    local acc = initial
    for _, v in ipairs(t) do
        acc = fn(acc, v)
    end
    return acc
end

local sum = reduce(numbers, function(a, b) return a + b end, 0)
-- sum = 15

-- 函数组合
local function compose(f, g)
    return function(x)
        return f(g(x))
    end
end

local add_one = function(x) return x + 1 end
local double = function(x) return x * 2 end
local add_one_then_double = compose(double, add_one)

print(add_one_then_double(5))  --> 12（先加 1 得 6，再乘 2 得 12）

-- 柯里化
local function curry(fn, n)
    n = n or 2
    return function(a)
        if n == 1 then
            return fn(a)
        else
            return curry(function(...) return fn(a, ...) end, n - 1)
        end
    end
end

local add = function(a, b, c) return a + b + c end
local curried_add = curry(add, 3)
print(curried_add(1)(2)(3))  --> 6
```

### 5.4 尾调用优化

Lua 支持尾调用优化，正确使用尾调用可以避免栈溢出。

```lua
-- 普通递归（会栈溢出）
local function factorial_bad(n)
    if n <= 1 then return 1 end
    return n * factorial_bad(n - 1)  -- 不是尾调用！
end

-- 尾递归优化（不会栈溢出）
local function factorial_good(n, acc)
    acc = acc or 1
    if n <= 1 then return acc end
    return factorial_good(n - 1, n * acc)  -- 尾调用
end

-- 什么是尾调用？
-- return func(...)  -- 是尾调用
-- return func(...) + 1  -- 不是（还有加法操作）
-- local x = func(...); return x  -- 不是（有赋值）
-- return (func(...))  -- 不是（有额外的括号调整返回值数量）

print(factorial_good(10000))  -- 可以计算，不会栈溢出
```

------

## 第六章：元表与元方法

元表是 Lua 实现面向对象、运算符重载和自定义行为的核心机制。

### 6.1 元表基础

```lua
-- 每个表可以关联一个元表
local t = {1, 2, 3}
print(getmetatable(t))  --> nil（默认没有元表）

local mt = {}
setmetatable(t, mt)
print(getmetatable(t) == mt)  --> true

-- 元表可以控制表的行为
-- 当对表执行某些操作时，Lua 会查找元表中对应的元方法

-- __index：访问不存在的键时调用
local defaults = {x = 0, y = 0, z = 0}
local point = {x = 10}
setmetatable(point, {__index = defaults})

print(point.x)  --> 10（自己有）
print(point.y)  --> 0（从 defaults 获取）
print(point.z)  --> 0（从 defaults 获取）

-- __index 可以是函数
local smart_table = {}
setmetatable(smart_table, {
    __index = function(t, key)
        return "键 '" .. key .. "' 不存在"
    end
})
print(smart_table.anything)  --> 键 'anything' 不存在

-- __newindex：给不存在的键赋值时调用
local protected = {x = 10}
setmetatable(protected, {
    __newindex = function(t, key, value)
        error("不允许添加新键: " .. key)
    end
})
-- protected.y = 20  -- 会报错
protected.x = 20  -- 正常，因为 x 已存在
```

### 6.2 常用元方法

```lua
-- 创建一个可以像数字一样使用的向量类
local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local self = setmetatable({}, Vector)
    self.x = x or 0
    self.y = y or 0
    return self
end

-- 算术元方法
function Vector:__add(other)
    return Vector.new(self.x + other.x, self.y + other.y)
end

function Vector:__sub(other)
    return Vector.new(self.x - other.x, self.y - other.y)
end

function Vector:__mul(scalar)
    if type(scalar) == "number" then
        return Vector.new(self.x * scalar, self.y * scalar)
    end
    -- 点积
    return self.x * scalar.x + self.y * scalar.y
end

function Vector:__unm()  -- 一元负号
    return Vector.new(-self.x, -self.y)
end

function Vector:__len()  -- # 运算符
    return math.sqrt(self.x^2 + self.y^2)
end

-- 比较元方法
function Vector:__eq(other)
    return self.x == other.x and self.y == other.y
end

function Vector:__lt(other)  -- <
    return #self < #other
end

function Vector:__le(other)  -- <=
    return #self <= #other
end

-- 字符串转换
function Vector:__tostring()
    return string.format("Vector(%.2f, %.2f)", self.x, self.y)
end

-- 函数调用
function Vector:__call(scale)
    return Vector.new(self.x * scale, self.y * scale)
end

-- 使用
local v1 = Vector.new(3, 4)
local v2 = Vector.new(1, 2)

print(v1)           --> Vector(3.00, 4.00)
print(v1 + v2)      --> Vector(4.00, 6.00)
print(v1 - v2)      --> Vector(2.00, 2.00)
print(v1 * 2)       --> Vector(6.00, 8.00)
print(v1 * v2)      --> 11（点积）
print(-v1)          --> Vector(-3.00, -4.00)
print(#v1)          --> 5.0（长度）
print(v1(0.5))      --> Vector(1.50, 2.00)（调用）
```

### 6.3 __index 链与原型继承

```lua
-- Lua 的原型继承通过 __index 链实现
local Animal = {
    name = "unknown",
    sound = "..."
}

function Animal:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Animal:speak()
    print(self.name .. " says: " .. self.sound)
end

-- Dog 继承 Animal
local Dog = Animal:new({sound = "Woof!"})

function Dog:fetch()
    print(self.name .. " is fetching!")
end

-- 创建实例
local myDog = Dog:new({name = "Buddy"})
myDog:speak()   --> Buddy says: Woof!
myDog:fetch()   --> Buddy is fetching!

-- 查找过程：
-- 1. 在 myDog 表中查找 speak
-- 2. 没找到，查看 myDog 的元表（Dog）的 __index（也是 Dog）
-- 3. 在 Dog 中查找 speak
-- 4. 没找到，查看 Dog 的元表（Animal）的 __index（也是 Animal）
-- 5. 在 Animal 中找到 speak
```

### 6.4 完整的元方法列表

```lua
--[[
算术运算：
  __add(a, b)      +
  __sub(a, b)      -
  __mul(a, b)      *
  __div(a, b)      /
  __mod(a, b)      %
  __pow(a, b)      ^
  __unm(a)         一元 -
  __idiv(a, b)     //（整除，Lua 5.3+）

位运算（Lua 5.3+）：
  __band(a, b)     &
  __bor(a, b)      |
  __bxor(a, b)     ~（二元）
  __bnot(a)        ~（一元）
  __shl(a, b)      <<
  __shr(a, b)      >>

比较运算：
  __eq(a, b)       ==
  __lt(a, b)       <
  __le(a, b)       <=

其他：
  __concat(a, b)   ..
  __len(a)         #
  __index          读取不存在的键
  __newindex       写入不存在的键
  __call(a, ...)   函数调用
  __tostring(a)    tostring()
  __pairs(a)       pairs()
  __ipairs(a)      ipairs()（Lua 5.2+，5.4 已移除）
  __gc(a)          垃圾回收（仅 userdata 和 Lua 5.2+ 的表）
  __mode           弱引用模式（"k"、"v" 或 "kv"）
  __metatable      控制 getmetatable 返回值和禁止 setmetatable
  __name           类型名称（用于错误信息，Lua 5.3+）
  __close          to-be-closed 变量（Lua 5.4+）
]]
```

------

## 第七章：面向对象编程

虽然 Lua 没有内置的类系统，但通过表和元表可以实现各种面向对象范式。

### 7.1 基本类实现

```lua
-- 经典的类实现模式
local class = function(base)
    local cls = {}
    cls.__index = cls
    
    if base then
        setmetatable(cls, {__index = base})
    end
    
    cls.new = function(self, ...)
        local instance = setmetatable({}, cls)
        if cls.init then
            cls.init(instance, ...)
        end
        return instance
    end
    
    cls.is_instance_of = function(self, klass)
        local mt = getmetatable(self)
        while mt do
            if mt == klass then return true end
            mt = getmetatable(mt)
            if mt then mt = mt.__index end
        end
        return false
    end
    
    return cls
end

-- 使用
local Animal = class()

function Animal:init(name)
    self.name = name
    self.health = 100
end

function Animal:speak()
    print(self.name .. " makes a sound")
end

function Animal:take_damage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        print(self.name .. " has died")
    end
end

-- 继承
local Dog = class(Animal)

function Dog:init(name, breed)
    Animal.init(self, name)  -- 调用父类构造函数
    self.breed = breed
end

function Dog:speak()  -- 方法重写
    print(self.name .. " barks: Woof!")
end

function Dog:fetch()
    print(self.name .. " the " .. self.breed .. " is fetching!")
end

-- 使用
local buddy = Dog:new("Buddy", "Golden Retriever")
buddy:speak()       --> Buddy barks: Woof!
buddy:fetch()       --> Buddy the Golden Retriever is fetching!
buddy:take_damage(30)  -- 继承的方法
print(buddy.health) --> 70
```

### 7.2 私有成员与封装

```lua
-- 使用闭包实现真正的私有成员
local function create_person(name, age)
    -- 私有变量
    local private = {
        name = name,
        age = age,
        secret = "这是秘密"
    }
    
    -- 公共接口
    local public = {}
    
    function public:get_name()
        return private.name
    end
    
    function public:get_age()
        return private.age
    end
    
    function public:set_age(new_age)
        if type(new_age) == "number" and new_age > 0 then
            private.age = new_age
        else
            error("无效的年龄")
        end
    end
    
    function public:birthday()
        private.age = private.age + 1
        print(private.name .. " is now " .. private.age .. " years old!")
    end
    
    return public
end

local person = create_person("Alice", 25)
print(person:get_name())  --> Alice
print(person:get_age())   --> 25
person:birthday()         --> Alice is now 26 years old!
-- person.secret          -- nil，无法访问
-- person.private         -- nil，无法访问
```

### 7.3 Mixin 模式

```lua
-- Mixin 允许组合多个行为
local Movable = {
    x = 0,
    y = 0,
    move = function(self, dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end,
    get_position = function(self)
        return self.x, self.y
    end
}

local Drawable = {
    visible = true,
    color = "white",
    draw = function(self)
        if self.visible then
            print("Drawing at " .. self.x .. ", " .. self.y .. " in " .. self.color)
        end
    end,
    hide = function(self)
        self.visible = false
    end,
    show = function(self)
        self.visible = true
    end
}

local Collidable = {
    width = 10,
    height = 10,
    check_collision = function(self, other)
        return self.x < other.x + other.width and
               self.x + self.width > other.x and
               self.y < other.y + other.height and
               self.y + self.height > other.y
    end
}

-- 混入函数
local function mixin(target, ...)
    for _, source in ipairs({...}) do
        for key, value in pairs(source) do
            if target[key] == nil then  -- 不覆盖已有成员
                target[key] = value
            end
        end
    end
    return target
end

-- 创建游戏对象
local GameObject = {}
GameObject.__index = GameObject

function GameObject:new(x, y)
    local obj = {x = x, y = y}
    mixin(obj, Movable, Drawable, Collidable)
    setmetatable(obj, self)
    return obj
end

local player = GameObject:new(100, 100)
player:move(10, 20)
player:draw()  --> Drawing at 110, 120 in white
```

------

## 第八章：模块与包

### 8.1 模块基础

```lua
-- mymodule.lua
local M = {}  -- 模块表

-- 私有函数
local function private_helper()
    return "私有帮助函数"
end

-- 公共函数
function M.public_function()
    return "公共函数调用: " .. private_helper()
end

-- 模块常量
M.VERSION = "1.0.0"
M.AUTHOR = "Your Name"

-- 类定义
M.MyClass = {}
M.MyClass.__index = M.MyClass

function M.MyClass:new(value)
    return setmetatable({value = value}, self)
end

function M.MyClass:get_value()
    return self.value
end

return M  -- 返回模块表

-- main.lua
local mymodule = require("mymodule")

print(mymodule.VERSION)  --> 1.0.0
print(mymodule.public_function())

local obj = mymodule.MyClass:new(42)
print(obj:get_value())  --> 42
```

### 8.2 require 的工作原理

```lua
-- require 的查找路径
print(package.path)   -- Lua 模块路径
print(package.cpath)  -- C 模块路径

-- 典型的 package.path 格式：
-- ./?.lua;./?/init.lua;/usr/local/share/lua/5.4/?.lua

-- require 的缓存机制
local mod1 = require("mymodule")
local mod2 = require("mymodule")
print(mod1 == mod2)  --> true（同一个表，不会重复加载）

-- 查看已加载的模块
for name, module in pairs(package.loaded) do
    print(name)
end

-- 强制重新加载模块
package.loaded["mymodule"] = nil
local fresh_mod = require("mymodule")

-- 自定义模块加载器
table.insert(package.searchers, function(modname)
    -- 自定义查找逻辑
    if modname:match("^virtual%.") then
        return function()
            return {name = modname, virtual = true}
        end
    end
    return nil  -- 未找到
end)
```

### 8.3 现代模块组织

```lua
-- 项目结构示例：
-- project/
-- ├── main.lua
-- ├── lib/
-- │   ├── init.lua
-- │   ├── utils.lua
-- │   └── database/
-- │       ├── init.lua
-- │       ├── connection.lua
-- │       └── query.lua

-- lib/init.lua
local lib = {
    utils = require("lib.utils"),
    database = require("lib.database")
}
return lib

-- lib/database/init.lua
local database = {
    connection = require("lib.database.connection"),
    query = require("lib.database.query")
}

function database.connect(config)
    return database.connection.new(config)
end

return database

-- main.lua
package.path = package.path .. ";./lib/?.lua;./lib/?/init.lua"

local lib = require("lib")
local conn = lib.database.connect({host = "localhost"})
```

### 8.4 包管理：LuaRocks

```bash
# 安装 LuaRocks
brew install luarocks  # macOS
apt install luarocks   # Ubuntu

# 安装包
luarocks install luasocket
luarocks install penlight
luarocks install lua-cjson

# 查看已安装的包
luarocks list

# 搜索包
luarocks search json
-- 使用安装的包
local socket = require("socket")
local json = require("cjson")
local pl = require("pl.import_into")()

-- LuaSocket 示例
local tcp = socket.tcp()
tcp:connect("httpbin.org", 80)
tcp:send("GET /get HTTP/1.1\r\nHost: httpbin.org\r\n\r\n")
local response = tcp:receive("*a")

-- cJSON 示例
local data = {name = "Lua", version = 5.4}
local json_str = json.encode(data)
local decoded = json.decode(json_str)
```

------

## 第九章：协程

协程是 Lua 提供的协作式多任务机制，它允许多个任务在单线程中交替执行。

### 9.1 协程基础

```lua
-- 创建协程
local function task(name)
    for i = 1, 3 do
        print(name .. ": step " .. i)
        coroutine.yield()  -- 暂停执行，让出控制权
    end
    return name .. " completed"
end

local co = coroutine.create(task)

-- 协程状态
print(coroutine.status(co))  --> suspended

-- 运行协程
coroutine.resume(co, "Task A")  --> Task A: step 1
print(coroutine.status(co))     --> suspended

coroutine.resume(co)            --> Task A: step 2
coroutine.resume(co)            --> Task A: step 3
local ok, result = coroutine.resume(co)
print(ok, result)               --> true  Task A completed
print(coroutine.status(co))     --> dead

-- 协程的返回值
local function producer()
    local values = {10, 20, 30}
    for _, v in ipairs(values) do
        coroutine.yield(v)  -- yield 可以返回值
    end
end

local co2 = coroutine.create(producer)
print(coroutine.resume(co2))  --> true  10
print(coroutine.resume(co2))  --> true  20
print(coroutine.resume(co2))  --> true  30
print(coroutine.resume(co2))  --> true（函数结束，无返回值）

-- resume 也可以向协程传递值
local function echo()
    while true do
        local value = coroutine.yield()
        print("Received: " .. tostring(value))
    end
end

local co3 = coroutine.create(echo)
coroutine.resume(co3)         -- 启动，运行到第一个 yield
coroutine.resume(co3, "Hello")  --> Received: Hello
coroutine.resume(co3, "World")  --> Received: World
```

### 9.2 协程包装器

```lua
-- coroutine.wrap 返回一个函数，调用更简洁
local function counter(max)
    for i = 1, max do
        coroutine.yield(i)
    end
end

local next_count = coroutine.wrap(counter)
print(next_count(5))  --> 1
print(next_count())   --> 2
print(next_count())   --> 3

-- 用协程实现迭代器
local function range(from, to, step)
    step = step or 1
    return coroutine.wrap(function()
        for i = from, to, step do
            coroutine.yield(i)
        end
    end)
end

for n in range(1, 10, 2) do
    print(n)  --> 1, 3, 5, 7, 9
end

-- 生成器模式
local function fibonacci(max)
    return coroutine.wrap(function()
        local a, b = 0, 1
        while a <= max do
            coroutine.yield(a)
            a, b = b, a + b
        end
    end)
end

for fib in fibonacci(100) do
    print(fib)  --> 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89
end
```

### 9.3 协程实现任务调度

```lua
-- 简单的任务调度器
local Scheduler = {}
Scheduler.__index = Scheduler

function Scheduler.new()
    return setmetatable({
        tasks = {},
        current_task = nil
    }, Scheduler)
end

function Scheduler:add_task(fn, ...)
    local co = coroutine.create(fn)
    table.insert(self.tasks, {
        coroutine = co,
        args = {...}
    })
end

function Scheduler:run()
    while #self.tasks > 0 do
        local task = table.remove(self.tasks, 1)
        self.current_task = task
        
        local ok, result
        if task.args then
            ok, result = coroutine.resume(task.coroutine, table.unpack(task.args))
            task.args = nil
        else
            ok, result = coroutine.resume(task.coroutine)
        end
        
        if not ok then
            print("Task error: " .. result)
        elseif coroutine.status(task.coroutine) ~= "dead" then
            table.insert(self.tasks, task)
        end
    end
end

-- 使用调度器
local scheduler = Scheduler.new()

scheduler:add_task(function(name)
    for i = 1, 3 do
        print(name .. " working: " .. i)
        coroutine.yield()
    end
    print(name .. " done")
end, "Task A")

scheduler:add_task(function(name)
    for i = 1, 2 do
        print(name .. " processing: " .. i)
        coroutine.yield()
    end
    print(name .. " done")
end, "Task B")

scheduler:run()
-- 输出：
-- Task A working: 1
-- Task B processing: 1
-- Task A working: 2
-- Task B processing: 2
-- Task A working: 3
-- Task B done
-- Task A done
```

### 9.4 协程实现生产者-消费者

```lua
local function producer(queue)
    for i = 1, 5 do
        print("Producing: " .. i)
        queue[#queue + 1] = i
        coroutine.yield()
    end
end

local function consumer(queue)
    while true do
        if #queue > 0 then
            local item = table.remove(queue, 1)
            print("Consuming: " .. item)
        end
        coroutine.yield()
    end
end

local queue = {}
local p = coroutine.create(function() producer(queue) end)
local c = coroutine.create(function() consumer(queue) end)

for _ = 1, 15 do
    if coroutine.status(p) ~= "dead" then
        coroutine.resume(p)
    end
    coroutine.resume(c)
end
```

------

## 第十章：错误处理与调试

### 10.1 错误处理

```lua
-- 抛出错误
local function divide(a, b)
    if b == 0 then
        error("除数不能为零", 2)  -- 2 表示错误级别，指向调用者
    end
    return a / b
end

-- 捕获错误：pcall（protected call）
local ok, result = pcall(divide, 10, 0)
if ok then
    print("结果: " .. result)
else
    print("错误: " .. result)  --> 错误: 除数不能为零
end

-- xpcall：可以自定义错误处理函数
local function error_handler(err)
    print("发生错误: " .. err)
    print("调用栈: " .. debug.traceback())
    return err
end

local ok, result = xpcall(function()
    divide(10, 0)
end, error_handler)

-- assert：条件检查
local function load_config(filename)
    local file = io.open(filename, "r")
    assert(file, "无法打开配置文件: " .. filename)
    local content = file:read("*a")
    file:close()
    return content
end

-- 自定义错误类型
local function create_error(type, message, details)
    return {
        type = type,
        message = message,
        details = details or {},
        traceback = debug.traceback()
    }
end

local function safe_operation()
    local ok, err = pcall(function()
        -- 可能出错的操作
        error(create_error("ValidationError", "无效的输入", {field = "email"}))
    end)
    
    if not ok then
        if type(err) == "table" and err.type then
            print("错误类型: " .. err.type)
            print("错误信息: " .. err.message)
        else
            print("未知错误: " .. tostring(err))
        end
    end
end
```

### 10.2 调试技术

```lua
-- debug 库基本用法
local function problematic_function()
    local x = 10
    local y = 20
    
    -- 获取当前函数信息
    local info = debug.getinfo(1, "Sln")
    print("函数名: " .. (info.name or "匿名"))
    print("定义位置: " .. info.source .. ":" .. info.linedefined)
    print("当前行: " .. info.currentline)
    
    -- 获取局部变量
    local i = 1
    while true do
        local name, value = debug.getlocal(1, i)
        if not name then break end
        print(string.format("局部变量 %s = %s", name, tostring(value)))
        i = i + 1
    end
    
    return x + y
end

problematic_function()

-- 调用栈追踪
local function level3()
    print(debug.traceback("追踪信息", 1))
end

local function level2()
    level3()
end

local function level1()
    level2()
end

level1()

-- 简单的断点调试器
local function breakpoint(condition, message)
    if condition then
        return
    end
    print("=== 断点触发 ===")
    print(message or "")
    print(debug.traceback())
    print("局部变量:")
    
    local level = 2
    local i = 1
    while true do
        local name, value = debug.getlocal(level, i)
        if not name then break end
        if not name:match("^%(") then  -- 跳过内部变量
            print(string.format("  %s = %s", name, tostring(value)))
        end
        i = i + 1
    end
    print("================")
end

-- 性能分析
local function profile(fn, ...)
    local start_time = os.clock()
    local start_mem = collectgarbage("count")
    
    local results = {fn(...)}
    
    local end_time = os.clock()
    local end_mem = collectgarbage("count")
    
    print(string.format("执行时间: %.4f 秒", end_time - start_time))
    print(string.format("内存变化: %.2f KB", end_mem - start_mem))
    
    return table.unpack(results)
end
```

### 10.3 日志系统

```lua
local Logger = {}
Logger.__index = Logger

Logger.LEVELS = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
    FATAL = 5
}

function Logger.new(name, level)
    return setmetatable({
        name = name or "default",
        level = level or Logger.LEVELS.DEBUG,
        handlers = {}
    }, Logger)
end

function Logger:add_handler(handler)
    table.insert(self.handlers, handler)
end

function Logger:log(level, message, ...)
    if level < self.level then
        return
    end
    
    local level_names = {"DEBUG", "INFO", "WARN", "ERROR", "FATAL"}
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local formatted = string.format(message, ...)
    local log_entry = string.format(
        "[%s] [%s] [%s] %s",
        timestamp,
        level_names[level],
        self.name,
        formatted
    )
    
    for _, handler in ipairs(self.handlers) do
        handler(log_entry, level)
    end
    
    if #self.handlers == 0 then
        print(log_entry)
    end
end

function Logger:debug(message, ...)
    self:log(Logger.LEVELS.DEBUG, message, ...)
end

function Logger:info(message, ...)
    self:log(Logger.LEVELS.INFO, message, ...)
end

function Logger:warn(message, ...)
    self:log(Logger.LEVELS.WARN, message, ...)
end

function Logger:error(message, ...)
    self:log(Logger.LEVELS.ERROR, message, ...)
end

-- 使用
local log = Logger.new("MyApp", Logger.LEVELS.INFO)
log:info("应用启动")
log:debug("这条不会显示")  -- 级别低于 INFO
log:warn("资源使用率: %d%%", 85)
```

------

## 第十一章：标准库

### 11.1 字符串库

```lua
-- 模式匹配（Lua 的正则表达式）
local text = "Hello, my email is test@example.com and phone is 123-456-7890"

-- 字符类
-- . : 任意字符
-- %a : 字母
-- %d : 数字
-- %s : 空白字符
-- %w : 字母数字
-- %p : 标点符号
-- %c : 控制字符
-- %x : 十六进制数字
-- 大写表示对应集合的补集，如 %A 表示非字母

-- 查找模式
local start, finish = string.find(text, "%d+-%d+-%d+")
print(string.sub(text, start, finish))  --> 123-456-7890

-- 捕获
local email = string.match(text, "(%w+)@(%w+)%.(%w+)")
print(email)  --> test（只返回第一个捕获）

-- 多个捕获
local user, domain, tld = string.match(text, "(%w+)@(%w+)%.(%w+)")
print(user, domain, tld)  --> test  example  com

-- 全局匹配迭代器
for word in string.gmatch(text, "%a+") do
    print(word)
end

-- 替换
local censored = string.gsub(text, "%d", "*")
print(censored)  --> Hello, my email is test@example.com and phone is ***-***-****

-- 使用捕获进行替换
local swapped = string.gsub("hello world", "(%w+) (%w+)", "%2 %1")
print(swapped)  --> world hello

-- 使用函数进行替换
local shouted = string.gsub("hello world", "%w+", function(w)
    return string.upper(w)
end)
print(shouted)  --> HELLO WORLD

-- 常用模式示例
local patterns = {
    email = "[%w%.]+@[%w]+%.[%w]+",
    url = "https?://[%w%.%-]+[%w/]*",
    ip = "%d+%.%d+%.%d+%.%d+",
    date = "%d%d%d%d%-%d%d%-%d%d"
}

-- 转义特殊字符
local function escape_pattern(s)
    return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

local literal = escape_pattern("test.com")
print(literal)  --> test%.com
```

### 11.2 表库

```lua
local t = {30, 10, 50, 20, 40}

-- 插入和删除
table.insert(t, 60)       -- 末尾插入
table.insert(t, 3, 15)    -- 在位置 3 插入
local removed = table.remove(t, 2)  -- 删除位置 2 的元素

-- 排序
table.sort(t)  -- 原地升序排序
table.sort(t, function(a, b) return a > b end)  -- 降序

-- 连接
local words = {"Lua", "is", "great"}
print(table.concat(words, " "))  --> Lua is great
print(table.concat(words, ", ", 1, 2))  --> Lua, is

-- 移动元素（Lua 5.3+）
local src = {1, 2, 3, 4, 5}
local dst = {}
table.move(src, 2, 4, 1, dst)  -- 将 src[2..4] 移动到 dst[1..]
-- dst = {2, 3, 4}

-- 打包和解包
local packed = table.pack(1, 2, 3, nil, 5)
print(packed.n)  --> 5（包含 nil 的真实长度）

local a, b, c = table.unpack({10, 20, 30})
print(a, b, c)  --> 10  20  30

-- 部分解包
local x, y = table.unpack({10, 20, 30, 40}, 2, 3)
print(x, y)  --> 20  30
```

### 11.3 数学库

```lua
-- 常量
print(math.pi)         --> 3.1415926535898
print(math.huge)       --> inf
print(math.maxinteger) --> 9223372036854775807（Lua 5.3+）
print(math.mininteger) --> -9223372036854775808（Lua 5.3+）

-- 基本函数
print(math.abs(-5))      --> 5
print(math.ceil(3.2))    --> 4
print(math.floor(3.8))   --> 3
print(math.modf(3.7))    --> 3  0.7（整数部分和小数部分）

-- 幂和对数
print(math.sqrt(16))     --> 4.0
print(math.exp(1))       --> 2.718281828...
print(math.log(math.exp(1)))  --> 1.0
print(math.log(100, 10)) --> 2.0（以 10 为底）

-- 三角函数（弧度）
print(math.sin(math.pi / 2))  --> 1.0
print(math.cos(0))            --> 1.0
print(math.tan(math.pi / 4))  --> 1.0

-- 角度转换
print(math.deg(math.pi))  --> 180（弧度转角度）
print(math.rad(180))      --> 3.14...（角度转弧度）

-- 随机数
math.randomseed(os.time())  -- 设置种子
print(math.random())        --> 0.0 到 1.0 之间
print(math.random(100))     --> 1 到 100 之间
print(math.random(50, 100)) --> 50 到 100 之间

-- 类型检查（Lua 5.3+）
print(math.type(3))    --> integer
print(math.type(3.0))  --> float
print(math.type("3"))  --> nil

-- 整数运算（Lua 5.3+）
print(math.tointeger(3.0))   --> 3
print(math.tointeger(3.5))   --> nil
print(math.ult(-1, 1))       --> false（无符号比较）
```

### 11.4 I/O 库

```lua
-- 简单 I/O 模式
io.write("请输入你的名字: ")
local name = io.read()  -- 读取一行
print("你好, " .. name)

-- io.read 的格式
-- "*a" 或 "a": 读取全部
-- "*l" 或 "l": 读取一行（默认）
-- "*L" 或 "L": 读取一行，保留换行符
-- "*n" 或 "n": 读取数字
-- 数字: 读取指定字节数

-- 完整 I/O 模式
local file = io.open("test.txt", "w")
if file then
    file:write("Line 1\n")
    file:write("Line 2\n")
    file:write("Line 3\n")
    file:close()
end

-- 读取文件
file = io.open("test.txt", "r")
if file then
    -- 逐行读取
    for line in file:lines() do
        print(line)
    end
    file:close()
end

-- 读取全部内容
file = io.open("test.txt", "r")
if file then
    local content = file:read("*a")
    print(content)
    file:close()
end

-- 二进制文件
file = io.open("binary.dat", "wb")
if file then
    file:write(string.char(0x48, 0x65, 0x6C, 0x6C, 0x6F))  -- "Hello"
    file:close()
end

-- 文件定位
file = io.open("test.txt", "r")
if file then
    print(file:seek())           -- 当前位置
    print(file:seek("end"))      -- 移动到末尾，返回文件大小
    print(file:seek("set", 0))   -- 移动到开头
    file:close()
end

-- 临时文件
local tmpfile = io.tmpfile()
tmpfile:write("临时数据")
tmpfile:seek("set")
print(tmpfile:read("*a"))
tmpfile:close()

-- 安全的文件操作模式
local function with_file(filename, mode, fn)
    local file, err = io.open(filename, mode)
    if not file then
        return nil, err
    end
    
    local ok, result = pcall(fn, file)
    file:close()
    
    if not ok then
        error(result)
    end
    return result
end

local content = with_file("test.txt", "r", function(f)
    return f:read("*a")
end)
```

### 11.5 OS 库

```lua
-- 时间函数
print(os.time())  -- 当前 Unix 时间戳
print(os.time({year = 2025, month = 1, day = 25}))  -- 指定时间

-- 时间格式化
print(os.date())                    -- 当前日期时间
print(os.date("%Y-%m-%d %H:%M:%S")) -- 2025-01-25 14:30:00
print(os.date("%A, %B %d, %Y"))     -- Saturday, January 25, 2025

-- date 格式说明符
-- %Y: 四位年份
-- %m: 月份（01-12）
-- %d: 日期（01-31）
-- %H: 小时（00-23）
-- %M: 分钟（00-59）
-- %S: 秒（00-59）
-- %w: 星期（0-6，0 是周日）
-- %j: 年中的第几天
-- %x: 日期表示
-- %X: 时间表示

-- 时间表
local t = os.date("*t")
print(t.year, t.month, t.day)
print(t.hour, t.min, t.sec)
print(t.wday, t.yday)  -- 星期，年中第几天
print(t.isdst)         -- 是否夏令时

-- 时间计算
local function days_between(date1, date2)
    local t1 = os.time(date1)
    local t2 = os.time(date2)
    return math.abs(os.difftime(t2, t1)) / (24 * 60 * 60)
end

-- 系统命令
os.execute("echo Hello")  -- 执行命令
local handle = io.popen("ls -la")  -- 执行并捕获输出
local output = handle:read("*a")
handle:close()

-- 环境变量
print(os.getenv("HOME"))
print(os.getenv("PATH"))

-- 其他
os.rename("old.txt", "new.txt")
os.remove("temp.txt")
print(os.clock())  -- CPU 时间
os.setlocale("zh_CN.UTF-8")  -- 设置区域
```

------

## 第十二章：Lua 5.4 新特性

### 12.1 常量与 to-be-closed 变量

```lua
-- 常量声明（Lua 5.4+）
local MAX_SIZE <const> = 100
-- MAX_SIZE = 200  -- 错误！不能修改常量

-- to-be-closed 变量（类似其他语言的 defer 或 RAII）
local function process_file(filename)
    local file <close> = io.open(filename, "r")
    if not file then
        error("无法打开文件")
    end
    
    -- file 会在作用域结束时自动关闭
    -- 即使发生错误也会关闭
    local content = file:read("*a")
    return content
end  -- file:close() 在这里自动调用

-- 自定义 __close 元方法
local function create_resource()
    local resource = {
        data = "some data",
        closed = false
    }
    
    setmetatable(resource, {
        __close = function(self, err)
            if err then
                print("关闭时发生错误: " .. tostring(err))
            end
            self.closed = true
            print("资源已清理")
        end
    })
    
    return resource
end

local function use_resource()
    local res <close> = create_resource()
    print(res.data)
    -- error("模拟错误")  -- 即使出错也会调用 __close
end  --> 输出: 资源已清理
```

### 12.2 泛型 for 的改进

```lua
-- Lua 5.4 允许 for 循环生成多个控制变量
for i, v in ipairs({"a", "b", "c"}) do
    print(i, v)
end

-- 新的 warn 函数
warn("@on")  -- 启用警告
warn("这是一个警告")
warn("@off")  -- 禁用警告

-- 新的 coroutine.close
local co = coroutine.create(function()
    local x <close> = create_resource()
    coroutine.yield()
    -- 如果协程被 close，x 也会被正确清理
end)

coroutine.resume(co)
coroutine.close(co)  -- 关闭协程并清理资源
```

------

## 第十三章：最佳实践与设计模式

### 13.1 编码规范

```lua
--[[
    Lua 编码规范建议
]]

-- 1. 命名约定
local my_variable = 10          -- 变量：小写下划线
local MAX_BUFFER_SIZE = 1024    -- 常量：大写下划线
local function calculate_sum()  -- 函数：小写下划线
end
local MyClass = {}              -- 类/模块：大驼峰

-- 2. 始终使用 local
local x = 10  -- 好
-- y = 20     -- 避免全局变量

-- 3. 检查全局变量泄漏
local function strict_mode()
    setmetatable(_G, {
        __newindex = function(t, k, v)
            error("不允许创建全局变量: " .. k, 2)
        end,
        __index = function(t, k)
            error("尝试访问未定义的全局变量: " .. k, 2)
        end
    })
end

-- 4. 使用局部函数引用提升性能
local insert = table.insert
local format = string.format
for i = 1, 10000 do
    insert(t, format("item %d", i))  -- 比 table.insert 更快
end

-- 5. 避免在循环中创建闭包
-- 不好
for i = 1, 1000 do
    buttons[i].callback = function() print(i) end  -- 每次创建新函数
end

-- 好
local function make_callback(index)
    return function() print(index) end
end
for i = 1, 1000 do
    buttons[i].callback = make_callback(i)
end

-- 6. 使用 table.concat 拼接字符串
local parts = {}
for i = 1, 1000 do
    parts[i] = tostring(i)
end
local result = table.concat(parts, ", ")  -- 高效

-- 7. 预分配表大小（当知道大小时）
local t = {}
for i = 1, 10000 do
    t[i] = i  -- 表会多次重新分配
end

-- 8. 模块返回表而不是设置全局变量
-- mymodule.lua
local M = {}
-- ... 定义模块内容
return M  -- 好

-- 不要这样做
-- mymodule = {}  -- 设置全局变量
```

### 13.2 常用设计模式

```lua
-- 单例模式
local Singleton = {}
local instance = nil

function Singleton.getInstance()
    if not instance then
        instance = {
            data = {},
            init = function(self)
                print("单例初始化")
            end
        }
        instance:init()
    end
    return instance
end

-- 工厂模式
local ShapeFactory = {}

local shapes = {
    circle = function(radius)
        return {
            type = "circle",
            radius = radius,
            area = function(self) return math.pi * self.radius^2 end
        }
    end,
    rectangle = function(width, height)
        return {
            type = "rectangle",
            width = width,
            height = height,
            area = function(self) return self.width * self.height end
        }
    end
}

function ShapeFactory.create(shape_type, ...)
    local creator = shapes[shape_type]
    if creator then
        return creator(...)
    end
    error("未知形状类型: " .. shape_type)
end

local circle = ShapeFactory.create("circle", 5)
print(circle:area())  --> 78.54...

-- 观察者模式
local EventEmitter = {}
EventEmitter.__index = EventEmitter

function EventEmitter.new()
    return setmetatable({
        listeners = {}
    }, EventEmitter)
end

function EventEmitter:on(event, callback)
    self.listeners[event] = self.listeners[event] or {}
    table.insert(self.listeners[event], callback)
    return self
end

function EventEmitter:off(event, callback)
    local listeners = self.listeners[event]
    if listeners then
        for i, cb in ipairs(listeners) do
            if cb == callback then
                table.remove(listeners, i)
                break
            end
        end
    end
    return self
end

function EventEmitter:emit(event, ...)
    local listeners = self.listeners[event]
    if listeners then
        for _, callback in ipairs(listeners) do
            callback(...)
        end
    end
    return self
end

-- 使用
local emitter = EventEmitter.new()
emitter:on("data", function(data)
    print("收到数据: " .. data)
end)
emitter:emit("data", "Hello")

-- 状态机模式
local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(initial_state)
    return setmetatable({
        current = initial_state,
        states = {},
        transitions = {}
    }, StateMachine)
end

function StateMachine:add_state(name, callbacks)
    self.states[name] = callbacks or {}
    return self
end

function StateMachine:add_transition(from, event, to)
    self.transitions[from] = self.transitions[from] or {}
    self.transitions[from][event] = to
    return self
end

function StateMachine:trigger(event, ...)
    local transition = self.transitions[self.current]
    local next_state = transition and transition[event]
    
    if next_state then
        local current_state = self.states[self.current]
        if current_state and current_state.exit then
            current_state.exit(self, ...)
        end
        
        self.current = next_state
        
        local new_state = self.states[self.current]
        if new_state and new_state.enter then
            new_state.enter(self, ...)
        end
        
        return true
    end
    return false
end

-- 使用
local traffic_light = StateMachine.new("red")
traffic_light
    :add_state("red", {
        enter = function() print("红灯亮") end
    })
    :add_state("green", {
        enter = function() print("绿灯亮") end
    })
    :add_state("yellow", {
        enter = function() print("黄灯亮") end
    })
    :add_transition("red", "next", "green")
    :add_transition("green", "next", "yellow")
    :add_transition("yellow", "next", "red")

traffic_light:trigger("next")  --> 绿灯亮
traffic_light:trigger("next")  --> 黄灯亮
traffic_light:trigger("next")  --> 红灯亮
```

### 13.3 性能优化技巧

```lua
-- 1. 局部化全局函数
local pairs = pairs
local ipairs = ipairs
local type = type
local tostring = tostring

-- 2. 避免创建不必要的表
-- 不好：每次调用都创建新表
local function get_default_config()
    return {timeout = 30, retries = 3}
end

-- 好：复用表
local DEFAULT_CONFIG = {timeout = 30, retries = 3}
local function get_default_config()
    return DEFAULT_CONFIG  -- 注意：调用者不应修改返回值
end

-- 3. 字符串连接优化
-- 不好
local result = ""
for i = 1, 10000 do
    result = result .. i  -- O(n²) 复杂度
end

-- 好
local parts = {}
for i = 1, 10000 do
    parts[i] = i
end
local result = table.concat(parts)  -- O(n) 复杂度

-- 4. 表复用
local function process_items(items)
    local temp = {}  -- 在函数内创建
    for _, item in ipairs(items) do
        temp[item.id] = item
    end
    return temp
end

-- 更好：使用对象池
local pool = {}
local function get_table()
    local t = table.remove(pool) or {}
    return t
end

local function release_table(t)
    for k in pairs(t) do
        t[k] = nil
    end
    table.insert(pool, t)
end

-- 5. 尾调用优化
local function sum_tail(n, acc)
    if n == 0 then return acc end
    return sum_tail(n - 1, acc + n)  -- 尾调用
end

-- 6. 使用整数而非字符串作为键
-- 不好
local data = {}
data["1"] = "a"
data["2"] = "b"

-- 好
local data = {}
data[1] = "a"
data[2] = "b"

-- 7. 预编译模式
local pattern = "(%d+)"  -- 存储模式
for i = 1, 10000 do
    string.match(text, pattern)  -- 复用模式
end

-- 8. 减少函数调用开销
-- 对于热点代码，考虑内联
local function is_empty(t)
    return next(t) == nil
end

-- 热点循环中
for i = 1, 1000000 do
    if next(t) == nil then  -- 内联，避免函数调用开销
        -- ...
    end
end
```

------

## 第十四章：实战项目

### 14.1 配置文件解析器

```lua
-- config_parser.lua
-- 支持 INI 风格配置文件

local ConfigParser = {}
ConfigParser.__index = ConfigParser

function ConfigParser.new()
    return setmetatable({
        data = {},
        current_section = "default"
    }, ConfigParser)
end

function ConfigParser:parse_file(filename)
    local file = io.open(filename, "r")
    if not file then
        return nil, "无法打开文件: " .. filename
    end
    
    local line_number = 0
    
    for line in file:lines() do
        line_number = line_number + 1
        
        -- 跳过空行和注释
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed ~= "" and not trimmed:match("^[#;]") then
            
            -- 检查是否是节名
            local section = trimmed:match("^%[([^%]]+)%]$")
            if section then
                self.current_section = section
                self.data[section] = self.data[section] or {}
            else
                -- 解析键值对
                local key, value = trimmed:match("^([%w_]+)%s*=%s*(.+)$")
                if key and value then
                    -- 处理值类型
                    value = self:parse_value(value)
                    self.data[self.current_section] = self.data[self.current_section] or {}
                    self.data[self.current_section][key] = value
                else
                    file:close()
                    return nil, string.format("语法错误，第 %d 行: %s", line_number, line)
                end
            end
        end
    end
    
    file:close()
    return true
end

function ConfigParser:parse_value(value)
    -- 布尔值
    if value == "true" then return true end
    if value == "false" then return false end
    
    -- 数字
    local num = tonumber(value)
    if num then return num end
    
    -- 字符串（去除引号）
    local str = value:match('^"(.-)"$') or value:match("^'(.-)'$")
    if str then return str end
    
    -- 数组
    local arr = value:match("^%[(.-)%]$")
    if arr then
        local result = {}
        for item in arr:gmatch("[^,]+") do
            item = item:match("^%s*(.-)%s*$")
            table.insert(result, self:parse_value(item))
        end
        return result
    end
    
    return value
end

function ConfigParser:get(section, key, default)
    local sect = self.data[section]
    if sect then
        local value = sect[key]
        if value ~= nil then
            return value
        end
    end
    return default
end

function ConfigParser:set(section, key, value)
    self.data[section] = self.data[section] or {}
    self.data[section][key] = value
end

function ConfigParser:save(filename)
    local file = io.open(filename, "w")
    if not file then
        return nil, "无法写入文件: " .. filename
    end
    
    for section, values in pairs(self.data) do
        file:write(string.format("[%s]\n", section))
        for key, value in pairs(values) do
            file:write(string.format("%s = %s\n", key, self:value_to_string(value)))
        end
        file:write("\n")
    end
    
    file:close()
    return true
end

function ConfigParser:value_to_string(value)
    local t = type(value)
    if t == "boolean" then
        return value and "true" or "false"
    elseif t == "number" then
        return tostring(value)
    elseif t == "table" then
        local parts = {}
        for _, v in ipairs(value) do
            table.insert(parts, self:value_to_string(v))
        end
        return "[" .. table.concat(parts, ", ") .. "]"
    else
        return string.format('"%s"', tostring(value))
    end
end

return ConfigParser

-- 使用示例
--[[
-- config.ini 内容:
[database]
host = localhost
port = 5432
enabled = true

[logging]
level = "debug"
outputs = [file, console]

-- 使用:
local ConfigParser = require("config_parser")
local config = ConfigParser.new()
config:parse_file("config.ini")

print(config:get("database", "host"))  --> localhost
print(config:get("database", "port"))  --> 5432
print(config:get("logging", "level"))  --> debug
]]
```

### 14.2 简单的 HTTP 请求库

```lua
-- simple_http.lua
-- 基于 LuaSocket 的简单 HTTP 客户端

local socket = require("socket")

local HTTP = {}

function HTTP.request(method, url, options)
    options = options or {}
    
    -- 解析 URL
    local protocol, host, port, path = url:match("^(https?)://([^:/]+):?(%d*)(.*)$")
    if not protocol then
        return nil, "无效的 URL"
    end
    
    port = tonumber(port) or (protocol == "https" and 443 or 80)
    path = path ~= "" and path or "/"
    
    -- 创建连接
    local tcp = socket.tcp()
    tcp:settimeout(options.timeout or 10)
    
    local ok, err = tcp:connect(host, port)
    if not ok then
        return nil, "连接失败: " .. err
    end
    
    -- 构建请求
    local headers = options.headers or {}
    headers["Host"] = host
    headers["Connection"] = "close"
    headers["User-Agent"] = headers["User-Agent"] or "LuaHTTP/1.0"
    
    local body = options.body or ""
    if body ~= "" then
        headers["Content-Length"] = #body
        headers["Content-Type"] = headers["Content-Type"] or "application/x-www-form-urlencoded"
    end
    
    local request_lines = {
        string.format("%s %s HTTP/1.1", method:upper(), path)
    }
    
    for name, value in pairs(headers) do
        table.insert(request_lines, string.format("%s: %s", name, value))
    end
    
    table.insert(request_lines, "")
    table.insert(request_lines, body)
    
    local request = table.concat(request_lines, "\r\n")
    
    -- 发送请求
    tcp:send(request)
    
    -- 读取响应
    local response = {}
    local status_line = tcp:receive("*l")
    if not status_line then
        tcp:close()
        return nil, "无法读取响应"
    end
    
    local _, status_code, status_text = status_line:match("^HTTP/(%d%.%d) (%d+) (.+)$")
    response.status = tonumber(status_code)
    response.status_text = status_text
    response.headers = {}
    
    -- 读取响应头
    while true do
        local line = tcp:receive("*l")
        if not line or line == "" then break end
        
        local name, value = line:match("^([^:]+):%s*(.+)$")
        if name then
            response.headers[name:lower()] = value
        end
    end
    
    -- 读取响应体
    local content_length = tonumber(response.headers["content-length"])
    if content_length then
        response.body = tcp:receive(content_length)
    else
        response.body = tcp:receive("*a")
    end
    
    tcp:close()
    
    return response
end

function HTTP.get(url, options)
    return HTTP.request("GET", url, options)
end

function HTTP.post(url, body, options)
    options = options or {}
    options.body = body
    return HTTP.request("POST", url, options)
end

-- JSON 辅助函数（简化版）
function HTTP.json_encode(data)
    if type(data) == "table" then
        local is_array = data[1] ~= nil
        local parts = {}
        
        if is_array then
            for _, v in ipairs(data) do
                table.insert(parts, HTTP.json_encode(v))
            end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            for k, v in pairs(data) do
                table.insert(parts, string.format('"%s":%s', k, HTTP.json_encode(v)))
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    elseif type(data) == "string" then
        return string.format('"%s"', data:gsub('"', '\\"'))
    elseif type(data) == "number" or type(data) == "boolean" then
        return tostring(data)
    elseif data == nil then
        return "null"
    end
end

return HTTP

--[[
使用示例:

local HTTP = require("simple_http")

-- GET 请求
local response = HTTP.get("http://httpbin.org/get")
print(response.status)
print(response.body)

-- POST 请求
local response = HTTP.post("http://httpbin.org/post", "name=lua&version=5.4", {
    headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
})
]]
```

### 14.3 命令行参数解析器

```lua
-- argparse.lua
local ArgParser = {}
ArgParser.__index = ArgParser

function ArgParser.new(name, description)
    return setmetatable({
        name = name or arg[0] or "program",
        description = description or "",
        options = {},
        positional = {},
        parsed = {}
    }, ArgParser)
end

function ArgParser:option(name, config)
    config = config or {}
    local option = {
        name = name,
        short = config.short,
        long = config.long or "--" .. name,
        type = config.type or "string",
        default = config.default,
        required = config.required or false,
        help = config.help or ""
    }
    
    if config.short then
        option.short = "-" .. config.short
    end
    
    table.insert(self.options, option)
    return self
end

function ArgParser:flag(name, config)
    config = config or {}
    config.type = "flag"
    config.default = config.default or false
    return self:option(name, config)
end

function ArgParser:positional(name, config)
    config = config or {}
    local pos = {
        name = name,
        type = config.type or "string",
        required = config.required ~= false,
        help = config.help or ""
    }
    table.insert(self.positional, pos)
    return self
end

function ArgParser:parse(args)
    args = args or arg
    local result = {}
    local positional_index = 1
    local i = 1
    
    -- 设置默认值
    for _, opt in ipairs(self.options) do
        if opt.default ~= nil then
            result[opt.name] = opt.default
        end
    end
    
    while i <= #args do
        local current = args[i]
        local matched = false
        
        -- 检查是否匹配选项
        for _, opt in ipairs(self.options) do
            if current == opt.short or current == opt.long then
                matched = true
                
                if opt.type == "flag" then
                    result[opt.name] = true
                else
                    i = i + 1
                    if i > #args then
                        error("选项 " .. current .. " 需要一个值")
                    end
                    local value = args[i]
                    
                    if opt.type == "number" then
                        value = tonumber(value)
                        if not value then
                            error("选项 " .. current .. " 需要一个数字")
                        end
                    end
                    
                    result[opt.name] = value
                end
                break
            end
        end
        
        -- 位置参数
        if not matched then
            if current:sub(1, 1) == "-" then
                error("未知选项: " .. current)
            end
            
            if positional_index <= #self.positional then
                local pos = self.positional[positional_index]
                local value = current
                
                if pos.type == "number" then
                    value = tonumber(value)
                end
                
                result[pos.name] = value
                positional_index = positional_index + 1
            else
                result._extra = result._extra or {}
                table.insert(result._extra, current)
            end
        end
        
        i = i + 1
    end
    
    -- 检查必需选项
    for _, opt in ipairs(self.options) do
        if opt.required and result[opt.name] == nil then
            error("缺少必需选项: " .. opt.long)
        end
    end
    
    for j, pos in ipairs(self.positional) do
        if pos.required and result[pos.name] == nil then
            error("缺少必需参数: " .. pos.name)
        end
    end
    
    self.parsed = result
    return result
end

function ArgParser:help()
    local lines = {
        self.description,
        "",
        "用法: " .. self.name .. " [选项]",
        "",
        "选项:"
    }
    
    for _, opt in ipairs(self.options) do
        local flags = {}
        if opt.short then table.insert(flags, opt.short) end
        if opt.long then table.insert(flags, opt.long) end
        
        local line = string.format("  %-20s %s", table.concat(flags, ", "), opt.help)
        table.insert(lines, line)
    end
    
    if #self.positional > 0 then
        table.insert(lines, "")
        table.insert(lines, "参数:")
        for _, pos in ipairs(self.positional) do
            local line = string.format("  %-20s %s", pos.name, pos.help)
            table.insert(lines, line)
        end
    end
    
    return table.concat(lines, "\n")
end

return ArgParser

--[[
使用示例:

local ArgParser = require("argparse")

local parser = ArgParser.new("myapp", "一个示例应用程序")
    :option("output", {short = "o", help = "输出文件"})
    :option("count", {short = "n", type = "number", default = 1, help = "重复次数"})
    :flag("verbose", {short = "v", help = "详细输出"})
    :positional("input", {help = "输入文件"})

local args = parser:parse()
print("输入:", args.input)
print("输出:", args.output)
print("次数:", args.count)
print("详细:", args.verbose)
]]
```

------

## 第十五章：与其他语言的交互

### 15.1 C API 基础

```c
/* 示例：创建一个 C 模块 */
/* mylib.c */

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

/* 一个简单的 C 函数 */
static int l_add(lua_State *L) {
    double a = luaL_checknumber(L, 1);
    double b = luaL_checknumber(L, 2);
    lua_pushnumber(L, a + b);
    return 1;  /* 返回值数量 */
}

static int l_greet(lua_State *L) {
    const char *name = luaL_checkstring(L, 1);
    lua_pushfstring(L, "Hello, %s!", name);
    return 1;
}

/* 模块函数表 */
static const struct luaL_Reg mylib[] = {
    {"add", l_add},
    {"greet", l_greet},
    {NULL, NULL}
};

/* 模块入口点 */
int luaopen_mylib(lua_State *L) {
    luaL_newlib(L, mylib);
    return 1;
}
# 编译为共享库
gcc -shared -fPIC -o mylib.so mylib.c -I/usr/include/lua5.4
-- 使用 C 模块
local mylib = require("mylib")
print(mylib.add(10, 20))    --> 30
print(mylib.greet("Lua"))   --> Hello, Lua!
```

### 15.2 嵌入 Lua 到 C 程序

```c
/* embed.c */
#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

int main(int argc, char *argv[]) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    
    /* 执行 Lua 代码 */
    if (luaL_dostring(L, "print('Hello from Lua!')") != LUA_OK) {
        fprintf(stderr, "Error: %s\n", lua_tostring(L, -1));
    }
    
    /* 执行 Lua 文件 */
    if (luaL_dofile(L, "script.lua") != LUA_OK) {
        fprintf(stderr, "Error: %s\n", lua_tostring(L, -1));
    }
    
    /* 调用 Lua 函数 */
    lua_getglobal(L, "calculate");
    lua_pushnumber(L, 10);
    lua_pushnumber(L, 20);
    
    if (lua_pcall(L, 2, 1, 0) != LUA_OK) {
        fprintf(stderr, "Error: %s\n", lua_tostring(L, -1));
    } else {
        double result = lua_tonumber(L, -1);
        printf("Result: %f\n", result);
    }
    
    lua_close(L);
    return 0;
}
```

### 15.3 FFI（使用 LuaJIT）

```lua
-- LuaJIT FFI 示例
local ffi = require("ffi")

-- 声明 C 函数
ffi.cdef[[
    int printf(const char *fmt, ...);
    double sqrt(double x);
    void *malloc(size_t size);
    void free(void *ptr);
    
    typedef struct {
        double x, y;
    } Point;
]]

-- 调用 C 函数
ffi.C.printf("Hello from C: %d\n", 42)
print(ffi.C.sqrt(2))  --> 1.4142135623731

-- 使用 C 结构体
local Point = ffi.typeof("Point")
local p = Point(3, 4)
print(p.x, p.y)

-- 计算距离
local function distance(p)
    return ffi.C.sqrt(p.x * p.x + p.y * p.y)
end
print(distance(p))  --> 5

-- 数组
local arr = ffi.new("int[10]")
for i = 0, 9 do
    arr[i] = i * 2
end
```

------

## 结语

本指南系统地介绍了 Lua 语言从基础到进阶的各个方面。Lua 的设计哲学强调简单、高效和可嵌入性，这使得它在游戏开发、嵌入式系统、Web 开发等领域都有广泛应用。

学习 Lua 的关键在于理解几个核心概念：表是唯一的数据结构但足以表达一切；函数是第一类值，闭包是强大的工具；元表和元方法提供了扩展语言的能力；协程实现了优雅的协作式多任务。

继续深入学习的建议路径包括：阅读《Programming in Lua》这本官方推荐书籍；研究开源项目中的 Lua 代码，如 OpenResty、Neovim 配置等；实践将 Lua 嵌入到自己的 C/C++ 项目中；探索 LuaJIT 的高性能特性。

