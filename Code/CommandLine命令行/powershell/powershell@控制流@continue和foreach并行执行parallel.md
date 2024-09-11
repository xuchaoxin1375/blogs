[toc]

powershell@foreach@foreach-object@continue的行为

## abstract

- continue和break

  - [about Continue - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_continue?view=powershell-7.3)

  - [powershell - Why does 'continue' behave like 'break' in a Foreach-Object? - Stack Overflow](https://stackoverflow.com/questions/7760013/why-does-continue-behave-like-break-in-a-foreach-object)


- foreache并行执行
  - [ForEach-Object (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-7.4)
  - [PowerShell ForEach-Object Parallel Feature - PowerShell Team (microsoft.com)](https://devblogs.microsoft.com/powershell/powershell-foreach-object-parallel-feature/)

## foreach@foreach-object

- [about Foreach - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_foreach?view=powershell-7.3)
  - powershell/module/microsoft.powershell.core/about/about_foreach
  - 这是一个powershell 遍历可迭代对象的基本语法,属于循环(loop)中的一种
  - 不妨称它为`loop-foreach`
- [ForEach-Object (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-7.3)
  - powershell/module/microsoft.powershell.core/foreach-object
  - 这是一个powershell cmdlet(powershell命令),不是一种循环,可能是基于基本语法编制而成的功能性命令
  - 不妨称它为`cmdlet-foreach`
- 这一点区别将会在使用continue的时候显现出来
  - continue放在在某个Loop中时(比如foreach),那么它的行为就像c语言那样
  - 如果是放在foreach-object(有时候简写为foreach,区分loop-foreach),充当`scriptblock`
  - 这时候,会尝试跳过最近的loop语法层(如果存在的话)

- [What is a PowerShell command? - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/powershell-commands?view=powershell-7.3)

### What is a cmdlet?

- Cmdlets are **native PowerShell commands**, not stand-alone executables. 
- Cmdlets are collected into PowerShell modules that can be loaded on demand. 
- Cmdlets can be written in any compiled .NET language or in the PowerShell scripting language itself.

## break@continue

- [about Break - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_break?source=recommendations&view=powershell-7.3)
- [about Continue - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_continue?view=powershell-7.3)

## foreach@continue👺

#### loop-foreach

- ```powershell
  Write-Output 'foreach-loop'
  $l = 1..5
  foreach ($elem in $l)
  {
      if ($elem -eq 3)
      {
          continue;
          # not return here
      }
      Write-Output $elem
  }
  ```

#### cmdlet-foreach

- ```powershell
  Write-Output 'foreach-object(cmdlet)'
  1..5 | ForEach-Object {
      if ($_ -eq 3 )
      {
          return 
          #not continue here
      }
      Write-Output $_
  
  }
  ```

#### 运行结果

- ```bash
  foreach-loop
  1
  2
  4
  5
  foreach-object(cmdlet)
  1
  2
  4
  5
  ```

### 其他方案

- 加一层`if-else`可以在cmdlet中模拟`continue`的字面行为
  - 但是这增加了不必要的代码
  - 而且不够优雅
- 做过滤的时候`where-object`有时候比`foreach-object`更加合适

## Foreach-Object中使用return

```powershell
function testforeach
{

    1..10 | ForEach-Object {
        if ($_ -eq 5)
        {
            Write-Output 'Found 5, breaking out of the loop'
            # break
            return
        }
        # 打印非5数字(数字5由于前面的判断会被return,在foreach-object中相当于continue在foreach循环中的效果)
        Write-Output $_ 
    }
    Write-Host 'end test!' #无法执行,为什么,如何做
}
```

输出为

```
PS> testforeach
1
2
3
4
Found 5, breaking out of the loop
6
7
8
9
10
end test!
```

可以看到,数字5没有被打印出来,而是被if命中打印了一句提示后继续执行foreach的其他遍历任务),作用有点像`foreach`循环中使用`continue`

PowerShell 中的 `ForEach-Object` 在管道中运行，实际上每个输入项（`$_`）都被作为脚本块的一部分并发执行。因此，`return` 只会结束当前的脚本块，而不会停止整个管道或函数的执行。管道继续处理后续输入，导致剩下的数字仍然被输出，并且函数也继续执行。

### 现象的解释：
- `1..10` 被传递给 `ForEach-Object`，逐个处理。
- 当处理到数字 `5` 时，触发了 `return`，返回退出当前脚本块，但这并不终止整个函数或管道。
- 管道继续执行，处理 `6` 到 `10`。
- 最后，`Write-Host 'end test!'` 正常执行。

### 如何解决：
为了让代码在遇到数字 `5` 后停止整个循环并继续执行函数的后续部分，可以使用 `foreach` 循环替代 `ForEach-Object`。这样可以使用 `break` 来退出循环。

或者使用局部环境变量来共享一个值,来决定每个循环是否执行

### 解决

#### 方案1

```powershell
function testforeach
{
    foreach ($_ in 1..10) {
        if ($_ -eq 5)
        {
            Write-Output 'Found 5, breaking out of the loop'
            break  # 使用 break 正常退出循环
        }
        Write-Output $_
    }
    Write-Host 'end test!'  # 这行代码现在会正常执行
}
```

输出：

当你运行这个函数时，输出将会是：

```
1
2
3
4
Found 5, breaking out of the loop
end test!
```

这次，数字 `6` 到 `10` 不会被输出，因为 `break` 正常退出了循环，且 `Write-Host 'end test!'` 仍然执行。

#### 方案2(共享局部环境变量)

```powershell
function testforeach
{
    $stopLoop = $false  # 用于控制是否提前停止的标志变量(这对于foreach -Parallel是只读变量),因此考虑临时的环境变量
    $EnvBak = $env:StopLoop
    $env:StopLoop = 0
    # 1..10 | ForEach-Object -Parallel {
    1..10 | ForEach-Object -Process {

        # Write-Host $env:StopLoop $_
        # 检查是否需要停止
        if ([int]($env:stopLoop))
        {
            return  # 提前退出当前并行任务
        }
        # 模拟耗时逻辑(放在合适的位置)
        Start-Sleep 0.5
        # Write-Host $_ -ForegroundColor Blue
        if ($_ -eq 5)
        {
            Write-Output 'Found 5, stopping further parallel execution'
            # $using:stopLoop = $true  # 设置标志变量，停止后续任务,这里$using:引用的值无法修改,使用$env方案
            $env:StopLoop = 1 #或者取1
            return  # 退出当前并行任务
        }

        Write-Output $_  # 输出当前处理的数字

    }`
        #  -ThrottleLimit 4  # 设置并行任务的最大线程数
    $env:StopLoop = $EnvBak #还原值
    # 这里执行并行任务结束后的代码
    Write-Host 'end test!'
}

```

## powershell Foreach-Object 和.Net线程安全类型

`System.Collections.Concurrent` 命名空间提供了一组线程安全的集合类，适用于多线程和并发编程。

```powershell
PS> [System.Collections.Concurrent.BlockingCollection
BlockingCollection<>           EnumerablePartitionerOptions
ConcurrentBag<>                IProducerConsumerCollection<>
ConcurrentDictionary<>         OrderablePartitioner<>
ConcurrentQueue<>              Partitioner
ConcurrentStack<>
```

以下是这些类型的简要介绍，并指出最常用的类型：

1. **BlockingCollection<T>**
   - **简介**：`BlockingCollection` 是一个线程安全的集合类，支持添加和移除项的阻塞和限定容量的功能。它常用于生产者-消费者模式，可以控制数据的生产和消费速度，防止生产过快或消费过慢。
   - **常用性**：相对常用，特别是在需要线程间通信和流量控制的场景。
2. **ConcurrentBag<T>**
   - **简介**：`ConcurrentBag` 是一个线程安全的无序集合，适合于需要高效添加和获取元素，但不关心元素顺序的情况。它对于读取多于写入的场景有较好的性能表现。
   - **常用性**：常用，尤其在需要线程安全地存储大量元素且不关心顺序时。
3. **ConcurrentDictionary<TKey, TValue>**
   - **简介**：`ConcurrentDictionary` 是一个线程安全的字典，实现了键值对的存储和检索功能，允许多个线程同时进行读写操作，而无需显式的锁定机制。
   - **常用性**：非常常用，是并发环境中替代传统 `Dictionary` 的首选。
4. **ConcurrentQueue<T>**
   - **简介**：`ConcurrentQueue` 是一个线程安全的先进先出（FIFO）队列，适用于需要按顺序处理任务的多线程场景。
   - **常用性**：常用，尤其在需要线程安全的队列结构时。
5. **ConcurrentStack<T>**
   - **简介**：`ConcurrentStack` 是一个线程安全的后进先出（LIFO）栈，适用于需要逆序处理任务的多线程场景。
   - **常用性**：相对常用，在特定需要栈结构的并发场景下使用。
6. **EnumerablePartitionerOptions**
   - **简介**：这是一个枚举，指定在创建可枚举分区器时的选项，用于控制数据分区的方式和缓冲行为。
   - **常用性**：较少直接使用，主要在高级并行编程中与 `Partitioner` 结合使用。
7. **IProducerConsumerCollection<T>**
   - **简介**：`IProducerConsumerCollection` 接口定义了线程安全的添加和移除操作，是实现生产者-消费者集合的基础接口。
   - **常用性**：通常不直接使用，而是通过使用其实现类（如 `BlockingCollection`）来间接使用。
8. **OrderablePartitioner<TSource>**
   - **简介**：`OrderablePartitioner` 提供了对源数据的有序分区功能，确保并行处理时保留数据的顺序。
   - **常用性**：较少直接使用，适用于需要在并行处理中维护元素顺序的场景。
9. **Partitioner**
   - **简介**：`Partitioner` 类用于创建自定义的数据分区策略，以优化并行循环的性能，特别是在处理大型数据集时。
   - **常用性**：在高级并行编程中使用，直接使用频率较低。

### 最常用的类型：

- **ConcurrentDictionary<TKey, TValue>**：在多线程环境中替代普通字典的首选，因其高效的线程安全特性，应用广泛。
- **ConcurrentQueue<T>** 和 **ConcurrentBag<T>**：用于线程安全的集合操作，根据是否需要维护元素顺序选择合适的类型。
- **BlockingCollection<T>**：在生产者-消费者模式中非常实用，提供了阻塞和限定容量的功能。

这些类型为并发编程提供了方便和安全的集合操作，避免了手动实现线程同步的复杂性，是开发高效、多线程应用程序的有力工具。

## 案例

### 可更改的线程安全变量

```powershell
function Test-Foreach-Parallel-ConcurrentBag
{
    <# 
    .SYNOPSIS
    试验foreach -parallel和ConcurrentBag的并发执行时线程安全的可更改的变量
    #>
    # 创建 ConcurrentBag 实例
    $bag = [System.Collections.Concurrent.ConcurrentBag[int]]::new()

    1..30 | ForEach-Object -Parallel {
        $bag = $using:bag
        $b = $bag -contains 5

        # Write-Host 'bag' $bag
        if ($b)
        {
            return  # 如果 bag 已包含 5，退出
        }
        Write-Host "Start Task $_ " -ForegroundColor Green
        Start-Sleep 0.5
        Write-Host "End $_ " -ForegroundColor Blue
        if ($_ -eq 5)
        {
            Write-Output 'Found 5, adding to external collection and stopping further parallel execution as soon as possible'
            $bag.Add(5)   # 将 5 添加到 ConcurrentBag
            return
        }
        else
        {
            Write-Verbose $_ 
        }

    } 

    Write-Host 'end test!'
}

```

