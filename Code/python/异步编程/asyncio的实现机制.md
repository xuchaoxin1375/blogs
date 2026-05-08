[toc]

## asyncio的工作机制

`asyncio` 用于**管理控制流的机制**。这正是魔法发生的地方。读完本节后，您将了解 `await` 在幕后做了什么，以及如何创建您自己的异步运算符。

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

这段代码是一个非常硬核且精彩的示例，它展示了 Python `asyncio` 的底层原理。

它没有使用任何库，而是通过手动驱动**协程（Coroutine）**，揭示了 `await` 关键字背后是如何通过生成器（Generator）机制工作的。

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

---



[yield](https://docs.python.org/zh-cn/3.14/reference/expressions.html#yieldexpr) 像往常一样**暂停执行**并将**控制权返回给调用者**。

在上面的例子中，第 3 行的 `yield` 被第 11 行的 `... = await rock` 调用。

- 更宽泛地说，`await` 会调用给定对象的 [`__await__()`](https://docs.python.org/zh-cn/3.14/reference/datamodel.html#object.__await__) 方法。
- `await` 还会做一件非常特别的事情：它会将接收到的任何 `yield` 沿着**调用链**向上传播（或称“传递”）。

在本例中，这将回到第 16 行的 `... = coroutine.send(None)`。

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

从协程中“yield”（或有效地放弃控制权）的唯一方法是 `await` 一个在其 `__await__` 方法中 `yield` 的对象。这听起来可能有点奇怪。你可能会想：

> 1. What about a `yield` directly within the coroutine function? The coroutine function becomes an [async generator function](https://docs.python.org/zh-cn/3.14/reference/expressions.html#asynchronous-generator-functions), a different beast entirely.
> 2. What about a [yield from](https://docs.python.org/zh-cn/3.14/reference/expressions.html#yieldexpr) within the coroutine function to a (plain) generator? That causes the error: `SyntaxError: yield from not allowed in a coroutine.` This was intentionally designed for the sake of simplicity -- mandating only one way of using coroutines. Initially `yield` was barred as well, but was re-accepted to allow for async generators. Despite that, `yield from` and `await` effectively do the same thing.

### Future

[Future](https://docs.python.org/zh-cn/3.14/library/asyncio-future.html#asyncio-future-obj) 是一个用来表示计算状态和结果的对象。该术语指的是尚未发生的事情，而 Future 对象则是一种用来关注这些事情的方式。

Future 对象有几个重要的属性。其一是它的状态，可以是“待处理”、“已取消”或“已完成”。其二是它的结果，当状态转换为已完成时它就会被设定。 与协程不同，Future 并不代表要执行的实际计算；相反，它代表该计算的状态和结果，有点像一个状态灯（红色、黄色或绿色）或指示器。

为了获得这些功能，[`asyncio.Task`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.Task) 继承了 [`asyncio.Future`](https://docs.python.org/zh-cn/3.14/library/asyncio-future.html#asyncio.Future) 类。上一节提到任务存储了一个回调函数列表，这并不完全准确。实际上，实现这些逻辑的是 `Future` 类，而 `Task` 继承了它。

Future 也可以被直接使用（无需通过任务）。任务会在协程完成后将自身标记为已完成。而 Future 的功能更加多样，由你来指定它何时标记为已完成。因此，Future 是一个灵活的接口，你可以自定义等待和恢复的条件。

### 自制 asyncio.sleep

我们将通过一个例子来说明如何利用 Future 来创建自己的异步睡眠变体 (`async_sleep`)，模仿了 [`asyncio.sleep()`](https://docs.python.org/zh-cn/3.14/library/asyncio-task.html#asyncio.sleep)。

这个代码段为事件循环注册了一些任务，然后等待由 `asyncio.create_task` 创建的任务，该任务包装了 `async_sleep(3)` 协程。我们希望该任务在三秒之后才结束，但不会阻止其他任务的运行。

```python
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
    await asyncio.create_task(async_sleep(3))
    print(
        "Done asynchronous sleep at time: "
        f"{datetime.datetime.now().strftime("%H:%M:%S")}."
    )
    # asyncio.gather 有效地等待集合中的每个任务。
    await asyncio.gather(*work_tasks)
```

下面，我们使用 Future 来自定义控制何时将任务标记为已完成。 如果 [`future.set_result()`](https://docs.python.org/zh-cn/3.14/library/asyncio-future.html#asyncio.Future.set_result) (负责将该 Future 标记为已完成的方法) 从未被调用，那么该任务将永远不会结束。 我们还借助了另一个任务，稍后将会介绍，它将监视已过去的时间，并相应地调用 `future.set_result()`。

```
async def async_sleep(seconds: float):
    future = asyncio.Future()
    time_to_wake = time.time() + seconds
    # 将监视任务添加到事件循环。
    watcher_task = asyncio.create_task(_sleep_watcher(future, time_to_wake))
    # 阻塞直到 future 被标记为已完成。
    await future
```

下面，我们将使用一个相当简单的 `YieldToEventLoop()` 对象从其 `__await__` 方法中 `yield`，将控制权交还给事件循环。这实际上与调用 `asyncio.sleep(0)` 相同，但这种方式更为明晰，更不用说在展示如何实现 `asyncio.sleep` 时直接使用它有点作弊！

与往常一样，事件循环会轮番处理其任务，给予它们控制权并在它们暂停或完成时收回控制权。运行 `_sleep_watcher(...)` 协程的 `watcher_task` 将在事件循环的每个完整周期中被唤起一次。 在每次恢复时，它将检查时间，如果经过的时间不够，则会再次暂停并将控制权交还给事件循环。 一旦经过了足够的时间，`_sleep_watcher(...)` 会将该 Future 标记为已完成并通过退出无限的 `while` 循环来结束执行。鉴于这个辅助任务在事件循环的每个周期中只会被唤起一次，因此你应该注意到这个异步休眠将 *至少* 休眠三秒，而不是恰好三秒。请注意 `asyncio.sleep` 也同样如此。

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

以下是程序的完整输出：

```bash
$ python custom-async-sleep.py
Beginning asynchronous sleep at time: 14:52:22.
I like work. Work work.
I like work. Work work.
I like work. Work work.
Done asynchronous sleep at time: 14:52:25.
```

你可能会觉得这种异步睡眠的实现过于复杂。确实如此。这个例子旨在通过一个简单的示例来展示 Future 的多功能性，以便可以模仿更复杂的需求。作为参考，你可以不使用 Future 来实现它，如下所示:

```python
async def simpler_async_sleep(seconds):
    time_to_wake = time.time() + seconds
    while True:
        if time.time() >= time_to_wake:
            return
        else:
            await YieldToEventLoop()
```