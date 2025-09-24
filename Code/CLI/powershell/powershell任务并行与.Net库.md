[toc]



## [ref]类型

`$counter = [ref]0`

这行创建了一个**引用类型**的变量，而不是普通的值类型。

> 对于简单的基础类型,对于已有变量`$a`,执行`$b=$a`通常效果是两个变量执行不同的内存区域(地址),只不过两个内存区域存放的内容相同

```powershell
# 普通变量（值类型）
$normalVar = 0
# 引用变量
$refVar = [ref]0

# 区别演示
$a = 5
$b = $a
$b = 10
Write-Host "a=$a, b=$b"  # 输出: a=5, b=10 (互不影响)

$x = [ref]5
$y = $x
$y.Value = 10 #注意不是$y=10,否则变量y会执行另一个区域
Write-Host "x=$($x.Value), y=$($y.Value)"  # 输出: x=10, y=10 (共享同一内存)
```

**为什么需要 `[ref]`？**

- 在多线程环境中，我们需要所有线程访问**同一个**计数器
- `[ref]` 创建的是一个引用对象，所有线程都指向同一块内存
- 通过 `.Value` 属性访问和修改实际的值

### 线程安全自增操作

`[System.Threading.Interlocked]::Increment($using:counter)`

这是一个**线程安全**的自增操作。

### 分解说明：

**`System.Threading.Interlocked`**
- .NET 提供的线程安全操作类
- 保证原子操作（不会被其他线程中断）

**`::Increment()`**
- 静态方法，执行原子性的 +1 操作
- 返回增加后的新值

**`$using:counter`**
- `$using:` 是 PowerShell 并行块的特殊语法
- 用于访问父作用域的变量
- 在 `-Parallel` 块内部，必须用 `$using:` 才能访问外部变量

### 为什么不能用普通的 `++`？

```
$counter = 0
1..100 | ForEach-Object -Parallel {
    ($using:counter)++  # 这会报错( The '++' operator works only on variables or on properties.)，且即使能执行也不安全
}
```



```powershell
# ❌ 错误示例 - 线程不安全
$counter = 0
1..100 | ForEach-Object -Parallel {
    $using:counter++  # 这会报错( The '++' operator works only on variables or on properties.)，且即使能执行也不安全
}

# ❌ 即使这样也不安全
$counter = [ref]0
1..100 | ForEach-Object -Parallel {
    ($using:counter).Value++  # 可能导致竞态条件
} #结果$counter=100

# ✅ 正确方式 - 线程安全
$counter = [ref]0
1..100 | ForEach-Object -Parallel {
    [System.Threading.Interlocked]::Increment($using:counter)
}
```

### 完整示例对比：

```powershell
# 演示线程安全的重要性
Write-Host "=== 非线程安全示例 ===" -ForegroundColor Red
$unsafeCounter = [ref]0
1..1000 | ForEach-Object -Parallel {
    $current = ($using:unsafeCounter).Value
    Start-Sleep -Milliseconds 1  # 模拟一些处理时间
    ($using:unsafeCounter).Value = $current + 1
} -ThrottleLimit 10
Write-Host "期望: 1000, 实际: $($unsafeCounter.Value)"  # 通常小于1000

Write-Host "`n=== 线程安全示例 ===" -ForegroundColor Green
$safeCounter = [ref]0
1..1000 | ForEach-Object -Parallel {
    Start-Sleep -Milliseconds 1
    [System.Threading.Interlocked]::Increment($using:safeCounter)
} -ThrottleLimit 10
Write-Host "期望: 1000, 实际: $($safeCounter.Value)"  # 总是1000
```

### 其他 Interlocked 方法：

```powershell
$counter = [ref]10

# 增加指定值
[System.Threading.Interlocked]::Add($counter, 5)  # 返回15

# 减少
[System.Threading.Interlocked]::Decrement($counter)  # 返回14

# 交换值
[System.Threading.Interlocked]::Exchange($counter, 100)  # 设为100，返回旧值14

# 比较并交换
[System.Threading.Interlocked]::CompareExchange($counter, 200, 100)  # 如果是100则设为200
```