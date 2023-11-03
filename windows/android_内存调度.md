@[toc]
## android 内存管理

- [进程间的内存分配  | Android 开发者  | Android Developers](https://developer.android.com/topic/performance/memory-management)


### 其他参考

- [内存管理概览](https://developer.android.com/topic/performance/memory-overview)
- [进程和应用生命周期](https://developer.android.com/guide/components/activities/process-lifecycle)
- [了解 Android 内存使用情况 - Google I/O 大会演讲](https://www.youtube.com/watch?v=w7K0jio8afM)
- [Android 内存和游戏 - Google I/O 大会演讲](https://www.youtube.com/watch?v=Do7oYWwOXTk&t=314s)

- [低内存终止守护程序  | Android 开源项目  | Android Open Source Project (google.cn)](https://source.android.google.cn/docs/core/perf/lmkd?hl=zh-cn)

## 内存相关测评参考

- [How much RAM do I need in my phone in 2022? We have the answer. (androidauthority.com)](https://www.androidauthority.com/how-much-ram-do-i-need-phone-3086661/)          
  - 内容:                                                                                
    - How much RAM does your Android phone really need in 2022?
      - RAM vs swap space: Memory management explained
      - Testing to find the ideal amount of RAM
      - Galaxy S21 Ultra and Pixel 3XL tests
      - OnePlus 9 Pro test
      - So, how much RAM do you need on your Android phone?

# 进程间的内存分配

Android 平台在运行时不会浪费可用的内存。它会一直尝试利用所有可用内存。例如，系统会在应用关闭后将其保留在内存中，以便用户快速切回到这些应用。因此，通常情况下，Android 设备在运行时几乎没有可用的内存。若要在重要系统进程和许多用户应用之间正确分配内存，内存管理至关重要。

本页讨论了 Android 如何为系统和用户应用分配内存的基础知识，另外还说明了操作系统如何应对低内存情况。

## 内存类型

Android 设备包含三种不同类型的内存：RAM、zRAM 和存储器。请注意，CPU 和 GPU 访问同一个 RAM。

![在这里插入图片描述](https://img-blog.csdnimg.cn/6d0de8fa641c4098a844d5494751fc1c.png)


**图 1.** 内存类型 - RAM、zRAM 和存储器

- RAM 是最快的内存类型，但其大小通常有限。高端设备通常具有最大的 RAM 容量。
- zRAM 是用于交换空间的 RAM 分区。所有数据在放入 zRAM 时都会进行压缩，然后在从 zRAM 向外复制时进行解压缩。这部分 RAM 会随着页面进出 zRAM 而增大或缩小。设备制造商可以设置 zRAM 大小上限。
- 存储器中包含所有持久性数据（例如文件系统等），以及为所有应用、库和平台添加的对象代码。存储器比另外两种内存的容量大得多。在 Android 上，存储器不像在其他 Linux 实现上那样用于交换空间，因为频繁写入会导致这种内存出现损坏，并缩短存储媒介的使用寿命。

## 内存页面

- RAM 分为多个“页面”。通常，每个页面为 4KB 的内存。

- 系统会将**RAM页面**视为“可用”或“已使用”。

  - 可用页面是未使用的 RAM。

  - 已使用的页面是系统目前<u>正在使用的 RAM</u>，并分为以下类别：

    - 缓存页：有存储器中的文件（例如**代码**或**内存映射文件**）支持的内存。
      - 缓存内存有两种类型：
        - 私有页：由**一个进程**拥有且未共享
          - 干净页：存储器中未经修改的文件副本，可由 [`kswapd`](https://developer.android.com/topic/performance/memory-management#kswapd) 删除以增加可用内存
          - 脏页：存储器中经过修改的文件副本；可由 `kswapd` 移动到 zRAM 或在 zRAM 中进行压缩以增加可用内存
        - 共享页：由**多个进程**使用
          - 干净页：存储器中未经修改的文件副本，可由 `kswapd` 删除以增加可用内存
          - 脏页：存储器中经过修改的文件副本；允许通过 `kswapd` 或者通过明确使用 [`msync()`](https://developer.android.com/reference/android/system/Os#msync(long,%20long,%20int)) 或 [`munmap()`](https://developer.android.com/reference/android/system/Os#munmap(long,%20long)) 将更改**写回存储器**中的文件，以增加可用空间

    - 匿名页：**没有**存储器中的文件支持的内存（例如，由设置了 MAP_ANONYMOUS 标志的 [mmap()](https://developer.android.com/reference/android/system/Os#mmap(long,%20long,%20int,%20int,%20java.io.FileDescriptor,%20long)) 进行分配）
      - 脏页：可由 kswapd 移动到 zRAM/在 zRAM 中进行压缩以增加可用内存



### Attention!

- 干净页包含存在于存储器中的文件（或文件一部分）的精确副本。
  - 如果干净页不再包含文件的精确副本（例如，因应用操作所致），则会变成脏页。
- 干净页可以删除，因为始终可以使用存储器中的数据重新生成它们；
- 脏页不能删除，否则数据将会丢失。

- 随着系统积极管理 RAM，可用和已使用页面的比例会不断变化。
- 本部分介绍的概念对于管理内存不足的情况至关重要。
- 本文档的下一部分将对这些概念进行更详细的说明。

## 内存不足管理

- Android 有两种处理**内存不足**情况的**主要机制**：
  - 内核交换守护进程
  - 低内存终止守护进程。

### 内核交换守护进程(Kswapd)



- 内核交换守护进程 (`kswapd`:The Kernel Swap Daemon (*kswapd*)) 是 Linux 内核的一部分，用于将已使用内存转换为可用内存。
- 当设备上的可用内存不足时，该守护进程将变为活动状态。
- Linux 内核**设有**可用内存上下限**阈值**(yùzhí)。
  - 当可用内存降至下限阈值以下时，`kswapd` 开始回收内存。
  - 当可用内存达到上限阈值时，`kswapd` 停止回收内存。

- `kswapd` 可以删除干净页来回收它们，因为这些页受到存储器的支持且未经修改。

### 请求分页(Kswapd)

- 如果某个进程尝试处理已删除的干净页，系统会将该页面**从存储器复制到 RAM**。

  - 此操作称为“请求分页”。

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/c9d2a245e7fa459dbd3ccc023db0e1e0.png)

    - **图 2.** 由存储器支持的干净页已删除

- `kswapd` 可以将缓存的私有脏页和匿名脏页移动到 zRAM 进行压缩。
  - 这样可以释放 RAM 中的可用内存（可用页面）。
  - 如果某个进程尝试处理 zRAM 中的脏页，该页将被**解压缩并移回到 RAM**。
  - 如果**与压缩页面关联的进程被终止，该页面将从 zRAM 中删除**。

- 如果可用内存量低于特定阈值，系统会开始终止进程。

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/19668fe73993448fb4e972aa52c1342b.png)


  - **图 3.** 脏页被移至 zRAM 并进行压缩

#### 更多kswap的参考

- [The Kernel Swap Daemon (kswapd) (unitn.it)](https://www.science.unitn.it/~fiorella/guidelinux/tlk/node39.html)
  - The Kernel Swap Daemon (*kswapd*)
  - The name *swap daemon* is a bit of a misnomer用词不当 as the daemon does more than just swap modified pages out to the swap file.
  - Its task is to keep the memory management system operating efficiently. 
  - The Kernel swap daemon (*kswapd* kernel init process at startup time and sits waiting for the kernel swap timer to periodically expire. ) is started by the Every time the timer expires, 
  - the swap daemon looks to see if the number of free pages in the system is getting too low. 

### 低内存终止守护进程(LMK)

- 很多时候，`kswapd` 不能为系统释放足够的内存。
  - 在这种情况下，系统会使用 [`onTrimMemory()`](https://developer.android.com/reference/android/content/ComponentCallbacks2#onTrimMemory(int)) 通知应用内存不足，应该减少其分配量。
  - 如果这还不够，内核会开始**终止进程以释放内存**。
- 它会使用<u>**低内存终止守护进程 (LMK)**</u> 来执行此操作。

#### oom分值&进程的优先级

- LMK 使用一个名为 [`oom_adj_score`](https://android.googlesource.com/platform/system/core/+/master/lmkd/README.md) 的“内存不足”**分值**来确定正在运行的进程的优先级，以此决定要终止的进程。
  - 最高得分的进程最先被终止。
  - 后台应用最先被终止，系统进程最后被终止。
  - 下表列出了从高到低的 LMK 评分类别。评分最高的类别，即第一行中的项目将最先被终止：

![在这里插入图片描述](https://img-blog.csdnimg.cn/fbfcba39d6b843a1bda30f43c57e0431.png)


- **图 4.** Android 进程，高分在上，低分在下

##### 进程分类

以下是上表中各种类别的说明：

- 后台应用：之前运行过且当前不处于活动状态的应用。LMK 将首先从具有最高 `oom_adj_score` 的应用开始终止后台应用。
- 上一个应用：最近用过的后台应用。上一个应用比后台应用具有更高的优先级（得分更低），因为相比某个后台应用，用户更有可能切换到上一个应用。
- 主屏幕应用：这是启动器应用。终止该应用会使壁纸消失。
- 服务：服务由应用启动，可能包括同步或上传到云端。
- **可觉察的应用**：用户可通过某种方式察觉到的非前台应用，例如运行一个显示小界面的搜索进程或听音乐。
- 前台应用：当前正在使用的应用。
  - **终止前台应用看起来就像是应用崩溃了，可能会向用户提示设备出了问题**。
- 持久性（服务）：这些是设备**的核心服务，例如电话和 Wi-Fi。**
- 系统：系统进程。
  - 这些进程被终止后，手机可能看起来即将重新启动。
- 原生：系统使用的极低级别的进程（例如，`kswapd`）。

#### 非默认的LMK行为

设备制造商可以更改 LMK 的行为。

## 计算内存占用量

- 内核会跟踪系统中的所有内存页面。

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/a93ba3f5ca6a4446910035ca2700f512.png)


  - **图 5.** 不同进程使用的页面

### 共享的内存页面

- 在确定应用使用的内存量时，系统必须考虑**共享的页面**。
  - 访问相同服务或库的应用将**共享内存页面**。
  - 例如，Google Play 服务和某个游戏应用可能会<u>共享位置信息服务</u>。
  - 这样便很难确定属于整个服务和每个应用的内存量分别是多少。
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/9276351531004e55b65da67a56aded52.png)

      - **图 6.** 由两个应用共享的页面（中间）

- 如需确定应用的内存占用量，可以使用以下任一指标：

  - 常驻内存大小 (RSS)：应用使用的**共享和非共享页面的数量**

  - 按比例分摊的内存大小 (PSS)：应用使用的非共享页面的数量加上共享页面的均匀分摊数量
    - （例如，如果三个进程共享 3 MB，每个进程的 PSS 为 1 MB）

  - 独占内存大小 (USS)：应用使用的非共享页面数量（不包括共享页面）

- 如果操作系统想要知道所有进程使用了多少内存，那么 PSS 非常有用，因为页面只会统计一次。
  - 计算 PSS 需要花很长时间，因为系统需要确定**共享的页面**以及**共享页面的进程数量**。
  - RSS 不区分共享和非共享页面（因此计算起来更快），更适合跟踪内存分配量的变化

# Cgroup 抽象层



- Android 10 及更高版本将对照组 (cgroup(ControlGroup)) 抽象层和任务配置文件搭配使用，让开发者能够使用它们来描述应用于某个线程或进程的一组（或多组）限制。
- 然后，系统按照任务配置文件的规定操作来选择一个或多个适当的 cgroup；通过这种方式，系统可以应用各种限制，并对底层 cgroup 功能集进行更改，而不会影响较高的软件层。

## cgroup 简介

cgroup 提供一种机制，可将任务集（包括进程、线程及其所有未来的子级）聚合并分区到具有专门行为的层级组中。Android 使用 cgroup 控制及考量 CPU 和内存等系统资源的使用和分配情况，并支持 Linux 内核 [cgroup v1](https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v1/#control-groups-version-1) 和 [cgroup v2](https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html)。

# 目前的低内存终止守护程序lmkd



- Android 低内存终止守护程序 (`lmkd`) 进程可监控运行中的 Android 系统的内存状态，并通过终止最不必要的进程来应对内存压力大的问题，使系统以可接受的性能水平运行。

## 内存压力简介

- 并行运行多个进程的 Android 系统可能会遇到系统内存耗尽，需要更多内存的进程出现明显延迟的情况。
  - 内存压力是**系统内存不足**的一种状态，它需要 Android 通过限制或终止不必要的进程、请求进程释放非关键缓存资源等方式来释放内存（以缓解这种压力）。
  - 过去，Android 使用内核中的<u>*低内存终止守护程序 (LMK) 驱动程序*</u>来监控系统内存压力，该驱动程序是一种依赖于**硬编码值的严格机制**。
  - 从内核 4.12 开始，<u>LMK 驱动程序已从上游内核中移除</u>，改由用户空间 `lmkd` 来执行<u>内存监控和进程终止任务。</u>

## 压力失速信息PSI(Pressure Speed Information)

- Android 10 及更高版本支持新的 `lmkd` 模式，它使用<u>内核压力失速信息 (PSI)</u> 监视器来检测内存压力。
  - 上游内核中的 <u>PSI 补丁程序集</u>（已向后移植到 4.9 和 4.14 内核）可测量**由于内存不足导致任务延迟的时间**。
  - 由于这些延迟会直接影响用户体验，因此它们代表了确定内存压力严重性的便捷指标。
  - 上游内核还包括 PSI 监视器，这类监视器允许特权用户空间进程（例如 `lmkd`）**指定这些延迟的阈值**，并在突破阈值时从内核订阅事件。

### PSI 监视器与 vmpressure 信号

- 由于 `vmpressure` 信号（由内核生成，用于**检测内存压力**并由 `lmkd` 使用）通常包含大量误报，
  - 因此 `lmkd` 必须<u>执行过滤以确定是否真的存在内存压力</u>。
  - 这会导致不必要的 `lmkd` 唤醒并<u>使用额外的计算资源</u>。
- 使用 `PSI 监视器`可以实现更精确的内存压力检测，并**最大限度地减少过滤开销**。

### 使用 PSI 监视器

- 如需使用 PSI 监视器（而不是 `vmpressure` 事件），请配置 `ro.lmk.use_psi` 属性。
  - 默认值为 `true`，这会以 PSI 监视器作为 `lmkd` 内存压力检测的默认机制。
  - 由于 PSI 监视器需要内核支持，因此内核必须包含 PSI 向后移植补丁程序，并在启用 PSI 支持 (`CONFIG_PSI=y`) 的情况下进行编译。

## 内核中 LMK 驱动程序的缺点

由于存在大量问题，Android 弃用了 LMK 驱动程序，问题包括：

- 对于低内存设备，必须<u>主动进行调整</u>，即便如此，在处理涉及<u>支持大文件的活跃页面缓存的工作负载时，其性能也较差</u>。性能不良会<u>导致出现抖动</u>，但不会终止。
- LMK 内核驱动程序<u>依赖于可用内存限制，不会根据内存压力进行扩缩。</u>
- 由于设计的严格性，合作伙伴通常会自定义该驱动程序，使其可以在自己的设备上使用。
- LMK 驱动程序已挂接到 Slab Shrinker API，该 API 并非为了执行繁重操作（例如搜索并终止目标）而设计，这类操作会导致 `vmscan` 进程变慢。

## 用户空间 lmkd

- 用户空间 `lmkd` 可实现与内核中的驱动程序相同的功能，但它**使用现有的内核机制检测和评估内存压力**。
- 这些机制包括使用内核生成的 `vmpressure` 事件或压力失速信息 (PSI) 监视器来获取关于内存压力水平的通知，以及使用内存 cgroup 功能限制根据进程的重要性分配给每个进程的内存资源。

## AOSP文档中的其他细节

### 在 Android 10 中使用用户空间 lmkd

- 在 Android 9 及更高版本中，用户空间 `lmkd` 会在未检测到内核中的 LMK 驱动程序时激活。
- 由于用户空间 `lmkd` 要求<u>内核支持内存 cgroup</u>，因此必须使用以下配置设置编译内核：

```
CONFIG_ANDROID_LOW_MEMORY_KILLER=n
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
```

#### 终止策略

- 用户空间 `lmkd` 支持基于以下各项的终止策略：

  - `vmpressure` 事件或 PSI 监视器、其严重性以及交换利用率等其他提示。

- 低内存设备和高性能设备的终止策略有所不同：

  - 对于内存不足的设备，一般情况下，系统会选择承受较大的内存压力。

  - 对于高性能设备，如果出现内存压力，则会视为异常情况，应及时修复，以免影响整体性能。

- 您可以使用 `ro.config.low_ram` 属性配置终止策略。如需了解详情，请参阅[低 RAM 配置](https://source.android.google.cn/devices/architecture/kernel/config?hl=zh-cn#low-ram)。

- 用户空间 `lmkd` 还支持一种旧模式，在该模式下，它使用与内核中的 LMK 驱动程序相同的策略（即可用内存和文件缓存阈值）做出终止决策。要启用旧模式，请将 `ro.lmk.use_minfree_levels` 属性设置为 `true`。

#### 配置 lmkd

使用以下属性为特定设备配置 `lmkd`。

| 属性                        | 使用                                                         | 默认                         |
| :-------------------------- | :----------------------------------------------------------- | :--------------------------- |
| `ro.config.low_ram`         | 指定设备是低内存设备还是高性能设备。                         | `false`                      |
| `ro.lmk.use_psi`            | 使用 PSI 监视器（而不是 `vmpressure` 事件）。                | `true`                       |
| `ro.lmk.use_minfree_levels` | 使用可用内存和文件缓存阈值来做出进程终止决策（即与内核中的 LMK 驱动程序的功能一致）。 | `false`                      |
| `ro.lmk.low`                | 在低 `vmpressure` 水平下可被终止的进程的最低 `oom_adj` 得分。 | `1001` （停用）              |
| `ro.lmk.medium`             | 在中等 `vmpressure` 水平下可被终止的进程的最低 `oom_adj` 得分。 | `800` （已缓存或非必要服务） |
| `ro.lmk.critical`           | 在临界 `vmpressure` 水平下可被终止的进程的最低 `oom_adj` 得分。 | `0` （任何进程）             |
| `ro.lmk.critical_upgrade`   | 支持升级到临界水平。                                         | `false`                      |
| `ro.lmk.upgrade_pressure`   | 由于系统交换次数过多，将在该水平执行水平升级的 `mem_pressure` 上限。 | `100` （停用）               |
| `ro.lmk.downgrade_pressure` | 由于仍有足够的可用内存，将在该水平忽略 `vmpressure` 事件的 `mem_pressure` 下限。 | `100` （停用）               |
| `ro.lmk.kill_heaviest_task` | 终止符合条件的最繁重任务（最佳决策）与终止符合条件的任何任务（快速决策）。 | `true`                       |
| `ro.lmk.kill_timeout_ms`    | 从某次终止后到其他终止完成之前的持续时间（以毫秒为单位）。   | `0` （停用）                 |
| `ro.lmk.debug`              | 启用 `lmkd` 调试日志。                                       | `false`                      |

**注意**：`mem_pressure` = 内存使用量/RAM_and_swap 使用量（以百分比的形式表示）。

设备配置示例：

```
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.low=1001 \
    ro.lmk.medium=800 \
    ro.lmk.critical=0 \
    ro.lmk.critical_upgrade=false \
    ro.lmk.upgrade_pressure=100 \
    ro.lmk.downgrade_pressure=100 \
    ro.lmk.kill_heaviest_task=true
```

### Android 11 中的用户空间 lmkd

- Android 11 通过引入新的终止策略改进了 `lmkd`。
- 该终止策略使用 PSI 机制来执行 Android 10 中引入的内存压力检测。
- Android 11 中的 `lmkd` 会根据内存资源使用情况和抖动来防止出现内存不足和性能下降。
- 这一终止策略取代了以前的策略，可同时用于高性能设备和低内存 (Android Go) 设备。

#### 内核要求

对于 Android 11 设备，`lmkd` 需要以下内核功能：

- 添加 PSI 补丁程序并启用 PSI（Android 通用内核 4.9、4.14 和 4.19 中提供向后移植）。
- 添加 PIDFD 支持补丁程序（Android 通用内核 4.9、4.14 和 4.19 中提供向后移植）。
- 对于低内存设备，添加内存 cgroup。

必须使用以下配置设置编译内核：

```
CONFIG_PSI=y
```

#### 在 Android 11 中配置 lmkd

Android 11 中的内存终止策略支持下面列出的调节旋钮和默认值。这些功能在高性能设备和低内存设备上都可使用。

| 属性                           | 使用                                                         | 默认  |       |
| :----------------------------- | :----------------------------------------------------------- | :---: | ----- |
| 高性能                         | 低内存                                                       |       |       |
| `ro.lmk.psi_partial_stall_ms`  | 部分 PSI 失速阈值（以毫秒为单位），用于触发内存不足通知。如果设备收到内存压力通知的时间太晚，可以降低此值以在较早的时间触发通知。如果在不必要的情况下触发了内存压力通知，请提高此值以降低设备对噪声的敏感度。 | `70`  | `200` |
| `ro.lmk.psi_complete_stall_ms` | 完全 PSI 失速阈值（以毫秒为单位），用于触发关键内存通知。如果设备收到关键内存压力通知的时间太晚，可以降低该值以在较早的时间触发通知。如果在不必要的情况下触发了关键内存压力通知，可以提高该值以降低设备对噪声的敏感度。 | `700` |       |
| `ro.lmk.thrashing_limit`       | 工作集 refault 数量的上限，以占具有文件支持的页面缓存总大小的百分比表示。如果工作集 refault 的数量超过该值，则视为系统对其页面缓存造成抖动。如果设备性能在内存压力期间受到影响，请降低该值以限制抖动。如果因抖动原因而导致设备性能不必要地降低，请提高该值以允许更多抖动。 | `100` | `30`  |
| `ro.lmk.thrashing_limit_decay` | 抖动阈值衰减，以占在系统无法恢复时（甚至是终止后）用于降低阈值的原始阈值的百分比表示。如果持续抖动导致不必要的终止，请降低该值。如果终止后对持续抖动的响应速度过慢，请提高该值。 | `10`  | `50`  |
| `ro.lmk.swap_util_max`         | 最大交换内存量，以占可交换内存总量的百分比表示。如果交换的内存量超过此上限，则表示系统在交换了其大部分可交换内存后仍然存在压力。 当内存压力是由不可交换内存的分配导致时，就可能会发生这种情况，原因在于大部分可交换内存已经交换，所以无法通过交换来缓解这一压力。默认值为 100，这实际上会停用此检查。如果设备的性能在交换利用率较高且可用交换水平未降至 `ro.lmk.swap_free_low_percentage` 的内存压力期间受到影响，请降低该值以限制交换利用率。 | `100` | `100` |

以下旧的调节旋钮也可用于新的终止策略。

| 属性                              | 使用                                                         |  默认   |      |
| :-------------------------------- | :----------------------------------------------------------- | :-----: | ---- |
| 高性能                            | 低内存                                                       |         |      |
| `ro.lmk.swap_free_low_percentage` | 可用交换水平，以占总交换空间的百分比表示。“lmkd”使用该值作为阈值来判断何时将系统视为交换空间不足。如果“lmkd”因交换空间过多而终止，请降低该百分比。如果“lmkd”终止得太晚，从而导致 OOM 终止，请提高该百分比。 |  `20`   | `10` |
| `ro.lmk.debug`                    | 这会启用“lmkd”调试日志。在调节时启用调试。                   | `false` |      |
