[toc]

## asyncio的工作机制

本文主要内容来自:[asyncio 的概念概述 — Python 文档](https://docs.python.org/zh-cn/3.14/howto/a-conceptual-overview-of-asyncio.html),并对其中的示例做了试验和记录,以及额外的补充.

> 阅读本文要求读者具有生成器相关知识,对`yield`表达式有所了解.

`asyncio` 用于**管理控制流的机制**。这正是魔法发生的地方。

读完本节后，您将了解 `await` 在幕后做了什么，以及如何创建您自己的异步运算符。

### 核心机制：事件循环 (The Event Loop)

`asyncio` 的心脏是**事件循环**。它是一个连续运行的循环，负责监听、调度并执行任务。

- **任务调度**：循环会检查当前有哪些任务已准备好运行，并依次执行它们。
- **单线程执行**：默认情况下，`asyncio` 在单线程中运行。这意味着在任何给定时刻，只有一个任务在实际运行。
- **协作式多任务**：它依赖于“协作式”切换，即任务必须显式地将控制权交还给循环（通常通过 `await`），循环才能切换到另一个任务。

### 协程的内部工作原理

`asyncio` 利用四个组件来传递控制权。

1. **协程 (Coroutines)**
   - 由 `async def` 定义的特殊函数。
   - 它们不是立即执行的，而是返回一个协程对象。只有被放入事件循环中（例如通过 `await` 或 `asyncio.run()`），它们才会开始执行。
2. **可等待对象 (Awaitables)**
   - 任何可以出现在 `await` 表达式之后的项。
   - 主要包括：**协程、任务（Tasks）和 Future 对象**。
3. **任务 (Tasks)**
   - 任务是对协程的进一步封装。
   - 当你使用 `asyncio.create_task()` 时，你是在**请求事件循环“尽快”安排该协程运行**。这允许任务在后台并发运行，而无需立即等待其结果。
4. **结果占位符对象Future**
   - 代表一个“在未来”才会完成的操作结果。
   - 它是底层架构的一部分，通常开发者直接处理任务（Task）而不是 Future。
   - 当一个异步操作（如网络 IO）启动时，会创建一个 Future，当**操作完成时，循环会为该 Future 设置结果**。

### 运行流程详解

- **遇到 `await` 时**：当前协程会暂停执行。它告诉事件循环：“我现在需要等待这个结果，你可以先去处理别的事情了”。
- **控制权归还**：事件循环重新获得控制权，查找下一个处于“准备就绪”状态的任务并开始执行。
- **恢复执行**：一旦 `await` 后面的异步操作完成，之前暂停的协程会被标记为“就绪”，并在循环的下一轮迭代中从暂停的地方继续运行。

#### 手动驱动协程

[`coroutine.send(arg)`](https://docs.python.org/zh-cn/3.14/reference/expressions.html#generator.send) 是用于**启动或恢复协程的方法**。

 如果协程已暂停并正在被恢复，则参数 `arg` 将作为原先暂停它的 `yield` 语句的**返回值**被发送。 如果协程是首次被使用（而不是被恢复），则 `arg` 必须为 `None`。

下面这段代码是一个非常硬核且精彩的示例，它展示了 Python `asyncio` 的底层原理。

它没有使用任何库，而是通过手动驱动**协程（Coroutine）**，揭示了 `await` 关键字背后是如何通过生成器（Generator）机制工作的。

##### 示例代码(带日志)版本

> 这个版本是原版的带日志打印的版本.适合初学者阅读.

```python
# demo_coroutine_send.py
import logging

datefmt1 = "%H:%M:%S"  # 仅打印时分秒
logging.basicConfig(
    level=logging.INFO,
    format="%(funcName)s - %(message)s",
    datefmt=datefmt1,
)
logger = logging.getLogger(__name__)
print = logger.info


# 定义一个简单的可等待对象(awaitable)
class Rock:
    def __await__(self):  # 一个普通的生成器
        value_sent_in = yield 7 # 本函数被调用后,向调用者返回7(但不是将value_sent_in赋值为7),然后暂停(如果协程恢复,则继续下面到代码,返回value_sent_in)
        # 通过send(None)启动生成器
        print(f"Rock.__await__ resuming with value: {value_sent_in}.")
        return value_sent_in  # 可以配合await 表达式来接收返回值.


# 主协程
async def main():
    print("Beginning coroutine main().")
    # 实例化可等待对象,得到rock
    rock = Rock()
    print("Awaiting rock...")
    value_from_rock = await rock  # 触发rock.__await__()方法的调用,执行到内部的field后暂停,main协程也会暂停(等待send来恢复协程.)
    # 注意这里接收到的只是return的值,而不是yield的返回值(yield表达式返回的值是返回给协程启动(恢复)调用者的,同时也意味着协程的执行又被暂停了,例如后面的语句coroutine.send(42)返回值就是yield的返回值7).
    print(f"Coroutine received value: {value_from_rock} from rock.")

    # 设置主协程的返回值,外部检测coroutine.send()抛出的StopIteration异常中获取main协程的返回值
    # 当一个 generator 或 coroutine 函数返回时，将引发一个新的 StopIteration 实例，函数返回的值将被用作异常构造器的 value 形参。
    return 23


if __name__ == "__main__":
    # 创建主协程(对象)
    coroutine = main()

    # 通过协程的send()方法手动启动协程,而非asyncio.run
    print("Starting main coroutine by send(None)...")
    intermediate_result = coroutine.send(None) # main协程运行到await rock(内部的yield后暂停执行,并获得yield返回值7),直到下面到send(value)调用恢复被挂起的协程(内的其余代码的执行).
    # 虽然协程被挂起,但这不会阻塞主线程其他代码的执行.下面到语句会继续执行.

    print(f"[I]:Coroutine paused and returned intermediate value: {intermediate_result}.")

    print("[I]:Resuming coroutine and sending in value: 42.")

    try:
        coroutine.send(42) # 恢复主协程的执行.
    except StopIteration as e:
        returned_value = e.value
    print(f"[I]:Coroutine main() finished and provided value: {returned_value}.")

```

```bash
 python .\demo_coroutine_send.py 
<module> - Starting main coroutine by send(None)...
main - Beginning coroutine main().
main - Awaiting rock...
<module> - [I]:Coroutine paused and returned intermediate value: 7.
<module> - [I]:Resuming coroutine and sending in value: 42.
__await__ - Rock.__await__ resuming with value: 42.
main - Coroutine received value: 42 from rock.
<module> - [I]:Coroutine main() finished and provided value: 23.
```

await表达式:

> Suspend the execution of coroutine on an awaitable object.

程序执行流程图解(仅重要结点)

| **步骤** | **执行操作**           | **控制权 / 状态**                           | **输出内容**                              |
| -------- | ---------------------- | ------------------------------------------- | ----------------------------------------- |
| **1**    | `coroutine = main()`   | 创建协程对象，但不执行                      | (无输出)                                  |
| **2**    | `coroutine.send(None)` | 进入 `main`，执行到 `await rock`            | `Beginning coroutine main()...`           |
| **3**    | `Rock.__await__` 执行  | 遇到 `yield 7`，协程**挂起**并向外返回 `7`  | `Coroutine paused... value: 7`            |
| **4**    | `coroutine.send(42)`   | 将 `42` 送入 `yield` 处，`Rock` 继续执行    | `Rock.__await__ resuming with value: 42.` |
| **5**    | `Rock` 返回值          | `await rock` 拿到 `42`                      | `Coroutine received value: 42 from rock.` |
| **6**    | `main` 结束            | `main` 返回 `23`，抛出 `StopIteration` 异常 | `Coroutine main() finished... value: 23.` |



#### 核心机制解析

1. 魔法方法 `__await__`

在 Python 中，一个对象如果要能被 `await`，它必须实现 `__await__` 方法，且该方法必须返回一个**迭代器**。(awaitable对象)

> 生成器是迭代器的一种,并且在`__await__`方法的定义中使用`yield`让这个方法被调用后得到一个生成器(迭代器)

- `yield 7`: 这是程序的第一个暂停点。当 `await rock` 执行时，它会沿着调用栈向上抛出 `7` 这个值。
- `value_sent_in = yield`: 当外部通过 `.send(value)` 恢复它时，这个 `value` 会被赋值给 `value_sent_in`。
- `return value_sent_in`: 在 `__await__` 中 `return` 的值，会成为 `await rock` 表达式的最终结果。

2. 手动驱动协程

通常我们用 `asyncio.run()` 来运行协程，但这个程序展示了“手动挡”操作：

- **激活协程**: `coroutine.send(None)` 是**启动协程的标准方式**，程序运行到 `yield 7` 处暂停。
- **传递数据**: `coroutine.send(42)` 将 `42` 送回暂停的地方。

------

关键结论：`await` 的本质是什么？

通过这段代码，你可以发现 `await` 实际上是一个“中继器”：

1. **向上传递暂停信号**：它把底层 `yield` 出来的东西一直往上传，直到传给最外层的“事件循环（Event Loop）”。
2. **向下传递数据**：当事件循环拿到数据（如网络响应）并执行 `.send(data)` 时，`await` 负责把数据准确地送回当初暂停的那一行代码。
3. **处理终止信号**：当底层的迭代器 `return` 时，它会触发 `StopIteration` 异常，`await` 捕获这个异常并拿到 `return` 的值。

> **小知识**： 为什么最后要用 `try...except StopIteration`？ 因为在 Python 中，当一个异步函数（协程）运行结束时，它会像生成器一样抛出一个 `StopIteration` 异常，而它的返回值（这里是 `23`）就被封装在异常对象的 `.value` 属性中。

await 表达式是否阻塞,区分**局部**和**全局**两个视角。

------

1. 局部视角：它是“阻塞”的（顺序执行）

从编写代码的角度看，`await` 的行为就像是同步代码。 当程序执行到 `value = await rock` 时，`main()` 协程会**停在这一行**。在 `rock` 返回结果之前，`main()` 协程内部的其余代码不会执行。

- **对开发者而言**：它维持了逻辑的连贯性，让你不用写复杂的各种回调函数（Callback）。

2. 全局视角：它是“非阻塞”的（并发执行）

这就是异步编程的魔力所在。当 `main()` 停在 `await` 时，它会通过 `yield` 将 CPU 的**控制权交还**给调用者（通常是事件循环 Event Loop）。

- **事件循环**：在 `main()` 挂起期间，事件循环可以去处理其他任务。
- **资源利用**：单线程下，CPU 不会在那里空转等待，而是去忙别的事情。



##### 原版

> 请勿调整这部分内容,放置说明中的引用代码片段对应不上

```python
class Rock:
    def __await__(self):
        value_sent_in = yield 7
        print(f"Rock.__await__ resuming with value: {value_sent_in}.")
        return value_sent_in

async def main():
    print("Beginning coroutine main().")
    rock = Rock()
    print("Awaiting rock...")
    value_from_rock = await rock
    print(f"Coroutine received value: {value_from_rock} from rock.")
    return 23

coroutine = main()
intermediate_result = coroutine.send(None)
print(f"Coroutine paused and returned intermediate value: {intermediate_result}.")

print(f"Resuming coroutine and sending in value: 42.")
try:
    coroutine.send(42)
except StopIteration as e:
    returned_value = e.value
print(f"Coroutine main() finished and provided value: {returned_value}.")
```



[yield](https://docs.python.org/zh-cn/3.14/reference/expressions.html#yieldexpr) 像往常一样**暂停执行**并将**控制权返回给调用者**。

在上面的例子中，第 3 行的 `yield` 被第 11 行的 `... = await rock` 调用。

- 更宽泛地说，`await` 会调用给定对象的 [`__await__()`](https://docs.python.org/zh-cn/3.14/reference/datamodel.html#object.__await__) 方法。
- `await` 还会做一件非常特别的事情：它会将接收到的任何 `yield` 沿着**调用链**向上传播（或称“传递”）。在本例中，这将回到第 16 行的 `... = coroutine.send(None)`。

- 协程通过第 21 行的 `coroutine.send(42)` 调用恢复。
- 协程从第 3 行 `yield` (或暂停) 的位置继续执行，并执行其主体中的剩余语句。
- **协程完成后，它会引发一个 [`StopIteration`](https://docs.python.org/zh-cn/3.14/library/exceptions.html#StopIteration) 异常**，并将**返回值附加在 `value` 属性**中。

> 由内置函数 [`next()`](https://docs.python.org/zh-cn/3.14/library/functions.html#next) 和 [iterator](https://docs.python.org/zh-cn/3.14/glossary.html#term-iterator) 的 [`__next__()`](https://docs.python.org/zh-cn/3.14/library/stdtypes.html#iterator.__next__) 方法所引发，用来表示该迭代器不能产生下一项。
>
> **value** (StopIteration.value)
>
> 该异常对象只有一个属性 `value`，它在**构造该异常时作为参数给出**，默认值为 [`None`](https://docs.python.org/zh-cn/3.14/library/constants.html#None)。
>
> - 当一个 [generator](https://docs.python.org/zh-cn/3.14/glossary.html#term-generator) 或 [coroutine](https://docs.python.org/zh-cn/3.14/glossary.html#term-coroutine) (协程)函数返回时，将引发一个新的 [`StopIteration`](https://docs.python.org/zh-cn/3.14/library/exceptions.html#StopIteration) 实例，**函数返回的值将被用作异常构造器的 `value` 形参。**
> - 如果某个生成器代码直接或间接地引发了 [`StopIteration`](https://docs.python.org/zh-cn/3.14/library/exceptions.html#StopIteration)，它会被转换为 [`RuntimeError`](https://docs.python.org/zh-cn/3.14/library/exceptions.html#RuntimeError) (并将 `StopIteration` 保留为导致新异常的原因)。

这里值得暂停一下，确保您已经理解了控制流和值传递的各种方式。我们涵盖了很多重要的概念，确保您理解得足够牢固。

---

### 从协程中放弃控制权

为了理解为什么“只有 `await` 那些在 `__await__` 中 `yield` 的对象”才能放弃控制权，我们需要拆解协程的本质。

> 这里还可能会涉及到生成器中特殊的形态:**异步生成器函数**(在`async def`协程函数中使用`yield`就构成异步生成器函数.)
>
> [yield from|delegating-to-a-subgenerator|Python  Python 文档](https://docs.python.org/zh-cn/3.14/whatsnew/3.3.html#pep-380-syntax-for-delegating-to-a-subgenerator)
>
> 异步生成器函数中,`yield from`不可用,仅在普通的生成器函数中可用.
>
> `yield from` 是 Python 3.3 引入的语法，用于将生成器的**控制权委托给另一个可迭代对象**：

**从协程中**“yield”（或有效地**放弃控制权**）的**唯一方法**是 `await` 一个(在其 `__await__` 方法中 `yield` 的)对象。

> **The only way** to **yield (or effectively cede control)** from a **coroutine** is to `await` **an object (that `yield`s in its `__await__` method)**. 
>
> 这句话有点绕口,简单讲就是,从协程中放弃控制权只能用**`await <awaitable_obj>`**表达式,并且这里的`awaitable_obj`(可等待对象)中的`__await__`的实现中要求包含`yield`.

这听起来可能有点奇怪。你可能会想：

如果直接在协程函数（`async def`）中使用 `yield` 会怎样？那么该协程函数就会演变成一个“**异步生成器函数**（Async Generator Function）”，这完全是另一种截然不同的东西了。

如果在协程函数内部通过 `yield from` 调用一个（普通的）**生成器**又会怎样？这会导致报错：`SyntaxError: yield from not allowed in a coroutine`。这种设计是**出于简化目的而有意为之的**——即**强制要求协程只能有一种使用方式**。

最初 `yield` 也是被禁止在协程中使用的，但后来为了实现**异步生成器**又重新接受了它。

尽管如此，`yield from` 和 `await` 在本质上其实起到了**相同的作用**。

> 1. What about a `yield` directly within the coroutine function? The coroutine function becomes an [async generator function](https://docs.python.org/zh-cn/3.14/reference/expressions.html#asynchronous-generator-functions), a different beast entirely.
> 2. What about a [yield from](https://docs.python.org/zh-cn/3.14/reference/expressions.html#yieldexpr) within the coroutine function to a (plain) generator? That causes the error: `SyntaxError: yield from not allowed in a coroutine.` This was intentionally designed for the sake of simplicity -- mandating only one way of using coroutines. Initially `yield` was barred as well, but was re-accepted to allow for async generators. Despite that, `yield from` and `await` effectively do the same thing.

1. 为什么必须是 `await`？

在 Python 底层，协程其实是一个**被包装过的生成器**。

当你在一个异步函数中使用 `await obj` 时，Python 解释器内部发生的事情大致如下：

1. 调用 `obj.__await__()` 获取一个**迭代器**(生成器)。
2. 通过这个迭代器执行 `yield`。
3. **关键点**：这个 `yield` 会产生一个信号（通常是文件描述符或倒计时），顺着调用栈一路向上传递，直到到达最外层的**事件循环（Event Loop）**。
4. 事件循环看到这个信号，就知道：“哦，这个协程要等 IO，我先去干别的。”

**如果不通过 `await`，协程就没有办法把这个“暂停并让出”的信号发给事件循环。**

------

2. 为什么不能直接在协程里 `yield`？

A. 协程内部直接 `yield` $\rightarrow$ 异步生成器

如果你在 `async def` 内部写了 `yield`，这个函数就不再是普通的“协程”了，它变成了**异步生成器（Async Generator）**。

- **区别**：协程是为了**得到一个结果**（调用一次，返回一个值）；异步生成器是为了**产生一系列结果**（像流水线一样）。
- 如果你想通过 `yield` 来让出控制权，你会发现你只是往外吐出了一个数据，而不是在执行异步等待逻辑。

B. 为什么禁止 `yield from`？

Python 3.5 引入 `async/await` 时，决定明确划清界限：

- **简化模型**：强制要求协程只能 `await` 可等待对象（Awaitable）。
- **防止混淆**：如果允许 `yield from` 一个普通生成器，解释器很难区分你是在尝试进行**“异步任务调度”还是仅仅在“迭代一个列表”**。

------

3. `await` 与 `yield from` 的双胞胎关系

在实现层面，`await` 几乎就是 `yield from` 的镜像。

- `yield from`：建立了一个透明的管道，把内层生成器的每一个值直接传给**最外层的调用者**。
- `await`：建立了一个透明的管道，把内层 `__await__` 产生的每一个暂停信号直接传给事件循环。

> **比喻**：
>
> 事件循环（CEO）给协程（经理）派活。
>
> 经理发现需要买咖啡，但他不能自己去，他得叫秘书（`__await__` 对象）。
>
> 经理使用 `await` 告诉 CEO：“我现在得等秘书买咖啡回来。”
>
> 秘书通过 `yield` 把“等待中”的状态直接汇报给 CEO。
>
> **经理（协程）放弃控制权的唯一合法手段，就是通过秘书（awaitable）发信号。**

总结

这种设计是为了**职责分离**：

1. **协程（`async def`）**：负责业务逻辑的调度顺序。
2. **可等待对象（需要按协议正确实现 `__await__`）**：负责与底层**事件循环沟通**，定义真正的“暂停”动作。

### Future

[Future](https://docs.python.org/zh-cn/3.14/library/asyncio-future.html#asyncio-future-obj) 是一个用来表示计算**状态和结果**的**对象**。该术语指的是**尚未发生的事情**，而 Future 对象则是一种用来关注这些事情的方式。

Future 对象有几个重要的属性。

- 其一是它的状态，可以是**“待处理”、“已取消”或“已完成”**。

- 其二是它的结果，当**状态转换为已完成时它(结果)就会被设定**。 

与协程不同，Future 并**不代表要执行的实际计算**；相反，它代表该计算的状态和结果，有点像一个状态灯（红色、黄色或绿色）或指示器。

为了获得这些功能，[`asyncio.Task`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.Task) 继承了 [`asyncio.Future`](https://docs.python.org/zh-cn/3.14/library/asyncio-future.html#asyncio.Future) 类。

> 任务(Task对象)存储了一个回调函数列表，但这并不完全准确。实际上，实现这些逻辑的是 `Future` 类，而 `Task` 继承了它。

Future 也可以被直接使用（无需通过任务）。

任务会在协程完成后将自身标记为已完成。而 Future 的功能更加多样，由你来指定它何时标记为已完成。因此，Future 是一个灵活的接口，你可以**自定义等待和恢复的条件**。

### 自制 asyncio.sleep

我们将通过一个例子来说明如何利用 Future 来创建自己的异步睡眠变体 (`async_sleep`)，模仿了 [`asyncio.sleep()`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.sleep)。

> 这里依然会使用到`asyncio`提供的一些接口,例如`create_task()`来创建任务.

这个代码段为事件循环注册了一些任务(task)，然后**等待**由 `asyncio.create_task` 创建的任务，该任务包装了上述的异步睡眠变体 `async_sleep(3)` 协程。

我们希望该任务在三秒之后才结束，但不会阻止其他任务(睡眠任务之外的任务)的运行。

```python
# 定义演示用的协程和任务.(这里不是完整的可运行脚本。)
import asyncio
import datetime
import time

async def other_work():
    print("I like work. Work work.")

async def main():
    # 向事件循环添加一些其他任务，这样在异步休眠时就可以做一些事情。
    work_tasks = [
        asyncio.create_task(other_work()),
        asyncio.create_task(other_work()),
        asyncio.create_task(other_work())
    ]
    print(
        "Beginning asynchronous sleep at time: "
        f"{datetime.datetime.now().strftime("%H:%M:%S")}."
    )
    # async_sleep 是我们要自定义的异步睡眠变体

    await asyncio.create_task(async_sleep(3))
    print(
        "Done asynchronous sleep at time: "
        f"{datetime.datetime.now().strftime("%H:%M:%S")}."
    )
    # asyncio.gather 有效地等待集合中的每个任务。
    await asyncio.gather(*work_tasks)
```

> 线程执行到这里的`await`语句会等待直到`async_sleep`结束(本main协程函数的后续的代码得等待);
>
> 通过`asyncio.create_task`包装`async_sleep(3)`协程,这会通知事件循环尽快运行`async_sleep`任务(这不需要await启动task);
>
> `await task`表达式还会让控制权交还给事件循环,这意味着前面的添加的异步任务(work_tasks中添加的task可以在async_sleep期间得到执行机会.)

下面，我们使用 Future 来**自定义控制何时将任务标记为已完成**。 

如果 [`future.set_result()`](https://docs.python.org/zh-cn/3.14/library/asyncio-future.html#asyncio.Future.set_result) (负责将该 Future **标记为已完成**的方法) 从未被调用，那么该任务将**永远不会结束**。

我们还借助了另一个任务(`_sleep_watcher`,接收`future`参数.)，稍后将会介绍，它将**监视已过去的时间**，并相应地调用 `future.set_result()`。

```python
async def async_sleep(seconds: float):
    future = asyncio.Future()
    # 计算要唤醒的时刻
    time_to_wake = time.time() + seconds
    # 将监视任务添加到事件循环。
    watcher_task = asyncio.create_task(_sleep_watcher(future, time_to_wake))
    # 阻塞直到 future 被标记为已完成。
    await future
```

下面，我们将使用一个相当简单的 `YieldToEventLoop()` 对象从其 `__await__` 方法中 `yield`，将**控制权交还给事件循环**。

> 正如前面所说的,这种方式(`await YieldToEventLoop()`)是唯一交还控制权的方法.

> 这实际上与调用 `asyncio.sleep(0)` 效果相同，但这种方式更为明晰，而且在展示如何实现 `asyncio.sleep` 时直接使用`asyncio.sleep`有点作弊！

与往常一样，**事件循环**会**轮番处理其任务**，给予它们控制权并在它们**暂停或完成**时收回控制权。

#### _sleep_watcher 辅助协程

运行 `_sleep_watcher(...)` 协程的 `watcher_task` 将**在事件循环的每个完整周期中被唤起一次**。 

> 在每次恢复时，它将检查时间，如果经过的时间不够，则会**再次暂停并将控制权交还给事件循环**。 
>
> 一旦经过了足够的时间，`_sleep_watcher(...)` 会**将该 Future 标记为已完成**并通过**退出无限的 `while` 循环来结束执行**。

#### 误差说明:

> 鉴于这个**辅助任务**在事件循环的每个周期中只会被唤起一次，因此你应该注意到这个异步休眠将 ***至少*** 休眠三秒，而不是恰好三秒。
>
> 请注意 `asyncio.sleep` 也同样如此。

```python
class YieldToEventLoop:
    def __await__(self):
        yield

async def _sleep_watcher(future, time_to_wake):
    while True:
        if time.time() >= time_to_wake:
            # 这标记 future 为已完成。
            future.set_result(None)
            break
        else:
            await YieldToEventLoop()
```

### 完整程序

```python
# 定义演示用的协程和任务.
import asyncio
import datetime
import time
import random


# import math
async def other_work(id=None,task_time=None):
    # 添加一些随机延迟模拟不同耗时任务
    task_time = task_time or round(random.random(),3)
    await asyncio.sleep(task_time)
    print(f"[{id}]:I like work. Work work.({task_time})s")


async def main():
    # 向事件循环添加一些其他任务，这样在异步休眠时就可以做一些事情。
    print("Create some other tasks , add them to the event loop...")
    work_tasks = [
        asyncio.create_task(other_work(1)),
        asyncio.create_task(other_work(2)),
        asyncio.create_task(other_work(3)),
    ]
    print(
        "Beginning asynchronous sleep at time: "
        f"{datetime.datetime.now().strftime('%H:%M:%S')}."
    )
    # 通过恰当的实现async_sleep,使得下面的语句和await asyncio.create_task(asyncio.sleep(3))效果相同
    await asyncio.create_task(async_sleep(1))
    print(
        "Done asynchronous sleep at time: "
        f"{datetime.datetime.now().strftime('%H:%M:%S')}."
    )
    # asyncio.gather 有效地等待集合中的每个任务。
    await asyncio.gather(*work_tasks)

# 此协程函数依赖于辅助协程函数_sleep_watcher
async def async_sleep(seconds: float):
    future = asyncio.Future()
    # 计算要唤醒的时刻
    time_to_wake = time.time() + seconds
    # 将监视任务添加到事件循环。
    _watcher_task = asyncio.create_task(_sleep_watcher(future, time_to_wake))
    # 阻塞直到 future 被标记为已完成。
    await future

# 简单的awaitable类,用于可以用于在协程中通过await 该awaitable对象从而让出控制权.
class YieldToEventLoop:
    def __await__(self):
        yield

# 辅助协程函数async_sleep()实现功能
async def _sleep_watcher(future, time_to_wake):
    # 每个事件循环周期内执行1次检查,直到到达要唤醒的时刻
    # cnt=0
    while True:
        if time.time() >= time_to_wake:
            # 这标记 future 为已完成。
            future.set_result(None)
            break
        else:
            # 暂停当前任务(交还控制权给事件循环)，并等待下一次事件循环周期。
            await YieldToEventLoop()
        # 这里可以打印日志感受循环周期(1秒内可以执行数万次循环周期)
        # cnt+=1
        # print(f"[{cnt}]gap probe:{ datetime.datetime.now().strftime('%H:%M:%S.%f')}.")


if __name__ == "__main__":
    asyncio.run(main())

```



以下是程序的完整输出：

```bash
 python .\async_sleep.py 
Create some other tasks , add them to the event loop...
Beginning asynchronous sleep at time: 17:27:15.
[1]:I like work. Work work.(0.238)s
[3]:I like work. Work work.(0.55)s
[2]:I like work. Work work.(0.946)s
Done asynchronous sleep at time: 17:27:18.
```

### 简化版实现(simpler_async_sleep)

你可能会觉得这种异步睡眠的实现过于复杂。确实如此。

这个例子旨在通过一个简单的示例来展示 Future 的多功能性，以便可以模仿更复杂的需求。

作为参考，你可以不使用 Future 来实现它，如下所示:

```python
# 简单的async_sleep实现(不使用Future),直接用循环实现.(依然用到简单awaitable类的实现YieldToEventLoop)
async def simpler_async_sleep(seconds):
    time_to_wake = time.time() + seconds
    while True:
        if time.time() >= time_to_wake:
            return
        else:
            await YieldToEventLoop() # 参考先前的实现.
```