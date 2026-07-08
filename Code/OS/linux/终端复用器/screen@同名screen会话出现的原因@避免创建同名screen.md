[toc]

## 案例分析

这是 **两个不同的 GNU screen session，但它们被起了同一个名字 `img-compress`**。

`screen -ls` 里的格式大概是：

```bash
2911575.img-compress
1775912.img-compress
```

其中：

```text
2911575 / 1775912  是 screen session 的 PID
img-compress       是你指定的 session 名字
Detached           表示当前没人 attach，但 session 还在后台跑
```

所以现象不是“同一个 screen 显示了两次”，而是 **你先后创建了两个叫 `img-compress` 的 screen**。`screen` 允许同名 session，因为它内部真正区分的是 `PID.name`。

最常见的触发操作是：

```bash
screen -S img-compress
```

或者：

```bash
screen -dmS img-compress command...
```

执行了不止一次。比如第一次在 07/06 创建后没有退出，只是 detach 了；第二天 07/07 又执行了一遍同样的启动命令，于是又创建了一个新的 `img-compress`。

也可能是脚本、crontab、systemd、部署脚本、SSH 登录脚本里反复执行了类似：

```bash
screen -dmS img-compress ...
```

但没有先检查是否已存在。

------

要避免创建同名 screen，最简单的交互式方式是用：

```bash
screen -R img-compress
```

它的含义是：如果已有 `img-compress`，就尝试恢复；如果没有，才创建新的。比直接 `screen -S img-compress` 安全一些。

脚本里建议先检查再创建：

```bash
name="img-compress"

if screen -ls | grep -q "[.]${name}[[:space:]]"; then
    echo "screen '$name' already exists"
    screen -ls | grep "[.]${name}[[:space:]]"
    exit 1
fi

screen -dmS "$name" bash -lc 'your_command_here'
```

如果担心两个脚本几乎同时启动，最好加锁：

```bash
name="img-compress"
lock="/tmp/${name}.screen.lock"

{
    flock -n 9 || {
        echo "$name is already being started"
        exit 1
    }

    if screen -ls | grep -q "[.]${name}[[:space:]]"; then
        echo "screen '$name' already exists"
        screen -ls | grep "[.]${name}[[:space:]]"
        exit 1
    fi

    screen -dmS "$name" bash -lc 'your_command_here'
} 9>"$lock"
```

如果你只是想清掉其中一个，先确认里面跑的是什么：

```bash
screen -r 2911575.img-compress
```

退出查看后按：

```text
Ctrl-a d
```

重新 detach。确认不要了再杀：

```bash
screen -S 1775912.img-compress -X quit
```

核心记住一句：**`screen -S name` 永远是“新建”，不是“如果存在就复用”。想复用用 `screen -R name`，脚本里要先查重或加锁。**

### 仅使用screen -R "screen_name"不能完全避免同名screen创建

上述结果是否可能在仅使用screen -R img-compress 的情况下发生的?

> 仍然有可能发生，尽管这种情况不是正常顺序使用时最常见的情况。

> `-R` 的逻辑不是“如果名字存在就一定复用”，而是“如果能恢复就恢复，否则创建”。(如果`-R`指定的名字screen已存在,但是(都)处于Attached,则认为不能恢复,会导致创建新的同名screen,除非配合`-d`或`-D`)

如果你是这样操作的：

```bash
screen -R img-compress
# detach (使用ctrl+a d分离img-compress会话),使其处于detached状态

# 重新reattach到img-compress会话
screen -R img-compress
# detach
```

通常 **不会** 产生两个同名 session。第二次应该会重新 attach 到已有的 `img-compress`。

> 也就是说,在同一个时间,仅使用一个ssh链接,且每次执行`screen -R img-compress`前都确保`img-compress`这个screen已经分离(处于`detached`状态)的情况下.使用`screen -R img-compress`不会引起新的同名`img-compress`screen创建.
>
> 

但仅使用：

```bash
screen -R img-compress
```

有几种情况可能产生你看到的结果：

> 例如,在`img-compress`中直接

### 1. 第一次的 session 当时还是 Attached

`screen -R img-compress` 主要是“恢复一个 detached session；如果没有可恢复的 detached session，就新建”。

所以如果当时已有：

```text
2911575.img-compress    (Attached)
```

然后你**在另一个 SSH/终端**里执行：

```bash
screen -R img-compress
```

它可能不会抢占 attached session，而是新建一个同名 session。之后你把两个都 detach，就会看到：

```text
2911575.img-compress    (Detached)
1775912.img-compress    (Detached)
```

这种情况很常见，比如一个 SSH 没退出、网络断了、VS Code Remote 还挂着、tmux/终端里还有旧 attach。

------

### 2. 两个进程几乎同时执行 `screen -R img-compress`

比如脚本、cron、systemd、手动连续触发，两个命令同时发现“没有 detached 的 img-compress”，于是都创建了新 session。

这属于竞态条件。`screen -R` 本身不是一个严格的“单例锁”。

------

### 3. 已经存在多个同名 session 后，再用 `-R` 会变得不可靠

一旦已经有多个：

```text
2911575.img-compress
1775912.img-compress
```

再执行：

```bash
screen -R img-compress
```

可能会提示有多个匹配项，要求你指定完整名字，比如：

```bash
screen -r 2911575.img-compress
```

------

## 使用`-D -R`或`-d -R`组合

如果你想确保“无论 attached/detached 都复用同一个”，更推荐：

```bash
# 或温和夺权原来的终端窗口不会被关闭，只是退到了宿主 shell 里。
screen -d -R img-compress 

# 彻底夺权,其他终端直接下线断开(ssh)链接.
screen -D -R img-compress
```

含义是：如果已有 session，就把别处的 attach 踢掉并重新 attach；如果没有，才创建。

> `-D`相比于`-d`更彻底,增强版强制分离。不仅把其他终端踢下线，还会**直接关闭**占用该会话的其他终端窗口。
>
> `-d -r`:如果会话不存在，**会报错**，不会新建。
>
> `-d -R`则更加智能.



如果是脚本里启动后台任务，别只靠 `screen -R`，用查重加锁更稳：

```bash
name="img-compress"
lock="/tmp/${name}.screen.lock"

{
    flock -n 9 || exit 1

    if screen -ls | grep -q "[.]${name}[[:space:]]"; then
        echo "screen '$name' already exists"
        exit 1
    fi

    screen -dmS "$name" bash -lc 'your_command_here'
} 9>"$lock"
```

## 结论

- **如果你每次都是手动、串行、且上一个 `img-compress` 已经 Detached，那么仅用 `screen -R img-compress` 通常不会造成两个同名 screen。**
- 但如果旧 session 当时是 Attached，或者有并发启动，**即使只用 `screen -R img-compress`，也可能出现这个结果。**
- 考虑使用`-D -R `组合,如果已有 session，就把别处的 attach 踢掉并重新 attach；如果没有，才创建。

## 其他

### 对比`-RR`和`-R`的不同.

```shell
# ✔ (base) [Ubuntu 24.04][bash 5.2.21]root@s8 in ~ [09:54:44]
$ screen -ls
There are screens on:
        342146.img-compress     (07/08/2026 09:54:37 AM)        (Detached)
        341778.img-compress     (07/08/2026 09:54:18 AM)        (Attached)
        321659.img-compress     (07/08/2026 09:34:57 AM)        (Detached)
        1775912.img-compress    (07/06/2026 11:39:45 AM)        (Attached)
        557045.pts-0.104-250-138-2      (05/29/2026 10:18:08 AM)        (Attached)
5 Sockets in /run/screen/S-root.

```

在已经存在多个同名的screen,并且处于`Detached`状态的screen数量不止一个,此时使用`-R`就会报错,需要你指定id.而`-RR`则可以直接进入第一个可用的screen.

```shell
# ✔ (base) [Ubuntu 24.04][bash 5.2.21]root@s8 in ~ [09:54:48]
$ screen -R img-compress
There are several suitable screens on:
        342146.img-compress     (07/08/2026 09:54:37 AM)        (Detached)
        341778.img-compress     (07/08/2026 09:54:18 AM)        (Attached)
        321659.img-compress     (07/08/2026 09:34:57 AM)        (Detached)
        1775912.img-compress    (07/06/2026 11:39:45 AM)        (Attached)
Type "screen [-d] -r [pid.]tty.host" to resume one of them.
[ble: exit 1]
```

> 使用`-RR`的情况下,可以进入screen(本例中进入`342146`)

```shell
# ✔ (base) [Ubuntu 24.04][bash 5.2.21]root@s8 in ~ [09:54:42]
$ screen -ls
There are screens on:
        342146.img-compress     (07/08/2026 09:54:37 AM)        (Attached)
        341778.img-compress     (07/08/2026 09:54:18 AM)        (Attached)
        321659.img-compress     (07/08/2026 09:34:57 AM)        (Detached)
        1775912.img-compress    (07/06/2026 11:39:45 AM)        (Attached)
```

单如果指定的名字的screen都处于`Attached`状态或者不存在指定名字的screen,那么`-R,-RR`的表现效果相同.

## 补充说明

可以这样理解：`screen` 的这些选项不是互斥的，很多是**组合语义**。

你贴的几行里，最关键的是这几组：

```bash
screen -r
screen -R
screen -d -r
screen -D -r
screen -D -RR
```

### 1. `-r`：只恢复已有 detached session

```bash
screen -r img-compress
```

含义是：找一个已经存在、并且处于 `Detached` 状态的 session，然后 attach 上去。

如果它是 `Attached`，通常会失败并提示类似：

```text
There is no screen to be resumed matching img-compress.
```

或者告诉你它已经 attached。

所以：

```bash
screen -r
```

是偏保守的：**只恢复，不创建新的。**

------

### 2. `-R`：能恢复就恢复，不能恢复就新建

```bash
screen -R img-compress
```

含义接近：

```text
如果能 reattach，就 reattach；
如果不能 reattach，就创建一个新的 screen。
```

这里的坑就在 “if possible / 如果可能” 这几个字。

如果已有的是：

```text
2911575.img-compress    (Detached)
```

那么：

```bash
screen -R img-compress
```

通常会 attach 到它。

但如果已有的是：

```text
2911575.img-compress    (Attached)
```

那么单独的 `-R` **不会强制把别处的连接踢掉**。它可能认为“没有可恢复的 detached session”，于是创建新的 session。

这就是为什么“仅使用 `screen -R img-compress`”也可能产生两个同名 session。

------

### 3. `-d (-r)`：先 detach 别处，再 reattach 到这里

help 里的：

```text
-d (-r)       Detach the elsewhere running screen (and reattach here).
```

意思不是说 `-d` 自动等于 `-r`，而是说它常和 `-r` 搭配。

例如：

```bash
screen -d -r img-compress
```

含义是：

```text
如果 img-compress 正在别的终端 Attached，
先把那个终端 detach 掉，
然后在当前终端 attach。
```

这比单独的 `-r` 更强。

典型场景：你 SSH 断线了，但服务器还认为旧终端 attached。此时：

```bash
screen -r img-compress
```

可能不让你进；而：

```bash
screen -d -r img-compress
```

可以把旧连接踢掉后接管。

------

### 4. `-D (-r)`：更强的 detach，并尝试 logout remote

```bash
screen -D -r img-compress
```

比 `-d -r` 更狠一点。

`-d` 是 detach 那个 screen display；
`-D` 是 detach 并让远端登录会话 logout。

简单说：

```bash
screen -d -r img-compress
```

是“把别人从 screen 里踢出去”。

```bash
screen -D -r img-compress
```

是“把别人从 screen 里踢出去，并尽量让那个远端登录会话也退出”。

平时多数情况下用 `-d -r` 就够了；`-D -r` 更适合旧 SSH 卡死、远端残留很乱的时候。

------

### 5. `-D -RR`：无脑拿到一个 screen session

help 里的：

```text
-D -RR        Do whatever is needed to get a screen session.
```

这句话可以理解为：

```text
无论当前有没有 session、session 是 detached 还是 attached，
screen 都尽量让我最终进入一个可用的 screen。
```

大致行为是：

| 当前状态            | `screen -D -RR` 大致行为                  |
| ------------------- | ----------------------------------------- |
| 没有 screen session | 新建一个                                  |
| 有 detached session | attach 上去                               |
| 有 attached session | 踢掉原来的 attach，然后 attach 到当前终端 |
| 状态混乱            | 尽量处理并进入一个 session                |

所以它是“最省心但也最强硬”的选项。

------

## 更推荐的用法

如果你想**只恢复，不要新建**：

```bash
screen -r img-compress
```

如果你想**接管已有 session，即使它在别处 attached**：

```bash
screen -d -r img-compress
```

或者更强一点：

```bash
screen -D -r img-compress
```

如果你想**有就接管，没有就创建**，可以用：

```bash
screen -D -RR img-compress
```

不过我更建议写完整一点，避免 `img-compress` 在不同版本/用法里被理解成命令参数：

```bash
screen -S img-compress -D -RR
```

对于你这种“避免创建同名 screen”的需求，最稳妥的策略反而是：

```bash
screen -r img-compress
```

它不会自动创建新的；失败就让你看清楚当前状态。要接管时再明确执行：

```bash
screen -d -r img-compress
```

核心区别一句话：

```text
-r      只恢复，不创建
-R      恢复不了就创建
-d -r   踢掉别处 attached 的连接再恢复
-D -r   更强地踢掉别处连接并 logout
-D -RR  尽一切办法让我进 screen：可恢复则恢复，不行则创建
```

可以，`-RR` **可以单独用**。

比如：

```bash
screen -RR
```

或者更明确地配合名字：

```bash
screen -S img-compress -RR
```

它的意思大致是：

```text
优先恢复一个 detached screen；
如果没有 detached screen，就创建新的。
```

但注意：**单独 `-RR` 不会主动踢掉 Attached 的 session**。GNU screen 手册说，`-R` 只在“要 attach 哪一个很明确”时恢复，否则列出可用 sessions；`-RR` 会尝试恢复它找到的第一个 detached session；如果没有 detached session，就新建。([man7.org](https://man7.org/linux/man-pages/man1/screen.1.html))

所以如果现在只有：

```text
2911575.img-compress    (Attached)
```

你执行：

```bash
screen -S img-compress -RR
```

仍然有可能创建新的：

```text
1775912.img-compress    (Attached)
```

也就是说：**`-RR` 单独用，不是“单例保证”。**

------

## `-D -R` 和 `-D -RR` 的区别

可以把它们理解成：

```text
-D     必要时踢掉别处的 attach，并 logout 远端
-R     恢复；没有则创建；但遇到多个时比较保守
-RR    恢复；没有则创建；遇到多个时直接选第一个
```

手册里对组合的解释是：

```text
-D -R   Attach here and now.
-D -RR  Attach here and now. Whatever that means, just do it.
```

更完整地说，`-D -R` 的行为是：如果 session 在运行，就重新 attach；必要时先 detach 并 logout 远端；如果没有运行，就创建并通知用户。([man7.org](https://man7.org/linux/man-pages/man1/screen.1.html))

而 `-d -RR` 的描述里明确提到：如果有多个 session 可用，就使用第一个 session；`-D -RR` 则是这个思路的更强硬版本。([man7.org](https://man7.org/linux/man-pages/man1/screen.1.html))

------

## 对比表

| 命令            | 有 Detached            | 有 Attached          | 没有 session | 多个匹配           |
| --------------- | ---------------------- | -------------------- | ------------ | ------------------ |
| `screen -R`     | attach                 | 可能不接管           | 创建         | 可能提示选择       |
| `screen -RR`    | attach 第一个 detached | 可能创建新的         | 创建         | 选第一个 detached  |
| `screen -D -R`  | attach                 | 踢掉旧 attach 后接管 | 创建         | 可能仍较保守       |
| `screen -D -RR` | attach                 | 踢掉旧 attach 后接管 | 创建         | 直接选一个，最强硬 |

------

## 对你的场景，建议这样用

如果你想“有 `img-compress` 就接管，没有才创建”，用：

```bash
screen -S img-compress -D -R
```

如果你想“别废话，哪怕有旧 attached，也直接让我进去”，用：

```bash
screen -S img-compress -D -RR
```

但如果你的目标是**严格避免同名 screen 被创建多个**，不要依赖 `-R/-RR` 做单例锁。更稳的是：

```bash
screen -ls | grep -q '[.]img-compress[[:space:]]' && {
    echo "img-compress already exists"
    exit 1
}

screen -dmS img-compress your_command
```

一句话总结：

```text
-RR 可以单独用；
-D -R 是“接管或创建”；
-D -RR 是“更强硬地接管或创建，多个也直接选一个”；
但它们都不是严格防止同名 screen 的锁。
```