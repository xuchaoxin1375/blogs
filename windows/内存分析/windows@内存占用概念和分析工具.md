[toc]



# Windows 进程内存分析：核心概念体系

---

## 一、虚拟内存与物理内存的关系

```mermaid
graph TB
    subgraph 进程A的视角["进程A 的虚拟地址空间 (64位: 128TB)"]
        VA1["代码段 .text"]
        VA2["堆 Heap"]
        VA3["栈 Stack"]
        VA4["DLL 映射"]
        VA5["内存映射文件"]
    end

    subgraph 进程B的视角["进程B 的虚拟地址空间"]
        VB1["代码段"]
        VB2["堆"]
        VB3["DLL 映射"]
    end

    subgraph 物理内存["物理内存 (RAM)"]
        PA["进程A 私有页面"]
        PB["进程B 私有页面"]
        PS["共享页面<br/>(ntdll.dll 等)"]
        PK["内核/驱动"]
    end

    subgraph 磁盘["磁盘"]
        PF["pagefile.sys<br/>(页面文件)"]
        DF["DLL/EXE 文件<br/>(映射源)"]
    end

    VA1 -->|页表映射| PA
    VA2 -->|页表映射| PA
    VA3 -->|页表映射| PA
    VA4 -->|页表映射| PS
    VB1 -->|页表映射| PB
    VB2 -->|页表映射| PB
    VB3 -->|页表映射| PS

    PA -.->|换出| PF
    PB -.->|换出| PF
    PS -.->|来源| DF

    style PS fill:#2ecc71,color:#000
    style PK fill:#e74c3c,color:#fff
    style PF fill:#95a5a6,color:#000
```

> **核心认知：进程永远不直接接触物理内存。它操作虚拟地址，由 OS 通过页表翻译成物理地址。多个进程可以共享同一块物理页面。**

---

## 二、虚拟页面的三种状态

```mermaid
stateDiagram-v2
    [*] --> Free: 初始状态
    Free --> Reserved: VirtualAlloc(MEM_RESERVE)<br/>占地址，不占资源
    Reserved --> Committed: VirtualAlloc(MEM_COMMIT)<br/>可读写，计入提交量
    Committed --> Reserved: VirtualFree(MEM_DECOMMIT)
    Reserved --> Free: VirtualFree(MEM_RELEASE)
    Committed --> Free: VirtualFree(MEM_RELEASE)
```

|     状态      | 占虚拟地址空间 | 计入提交量(Commit Charge) | 占物理内存 | 说明                                  |
| :-----------: | :------------: | :-----------------------: | :--------: | :------------------------------------ |
|   **Free**    |       ✗        |             ✗             |     ✗      | 未分配，可用于新分配                  |
| **Reserved**  |       ✓        |             ✗             |     ✗      | 仅预留地址范围，不实际分配            |
| **Committed** |       ✓        |             ✓             | **不一定** | 已承诺分配，但可能从未访问过 / 被换出 |

> **关键：Committed ≠ 占物理内存。** 已提交的页面首次被访问时才触发缺页异常(Page Fault)分配物理页面，或可能已被换出到 pagefile。

---

## 三、物理内存页面分类（PFN 数据库）

```mermaid
graph LR
    subgraph RAM["物理内存 (全部页面)"]
        direction TB
        InUse["<b>In Use (正在使用)</b><br/>进程工作集<br/>内核/驱动<br/>非分页池<br/>页表"]
        Modified["<b>Modified (已修改)</b><br/>脏页，需写回磁盘<br/>才可回收"]
        Standby["<b>Standby (备用)</b><br/>文件缓存<br/>内容还在<br/>可立即回收"]
        Free["<b>Free (空闲)</b><br/>未清零"]
        Zero["<b>Zeroed (零化)</b><br/>已清零<br/>可立即分配"]
    end

    InUse -->|页面被修改后释放| Modified
    Modified -->|写回磁盘完成| Standby
    Standby -->|被重新引用| InUse
    Standby -->|需要回收| Free
    Free -->|零化线程清零| Zero
    Zero -->|分配给进程| InUse

    style InUse fill:#e74c3c,color:#fff
    style Modified fill:#e67e22,color:#fff
    style Standby fill:#f1c40f,color:#000
    style Free fill:#bdc3c7,color:#000
    style Zero fill:#2ecc71,color:#000
```

### 与任务管理器的对应关系

| 任务管理器显示 | 等于                    | 说明                       |
| :------------- | :---------------------- | :------------------------- |
| **已使用**     | In Use + Modified       | 不可立即回收的部分         |
| **可用**       | Standby + Free + Zeroed | 可供新分配的部分（含缓存） |
| **已缓存**     | Modified + Standby      | 文件缓存相关               |
| **总计**       | 以上全部（OS 可见部分） | 不含硬件保留               |

---

## 四、进程内存指标（最核心）

### 4.1 指标包含关系

```mermaid
graph TB
    subgraph VS["虚拟大小 (Virtual Size)"]
        subgraph CS["提交大小 / Private Bytes"]
            subgraph WS["工作集 (Working Set)"]
                PWS["<b>专用工作集</b><br/>Private Working Set<br/>★ 任务管理器默认列"]
                SWS["共享工作集<br/>Shared Working Set<br/>(DLL代码等)"]
            end
            PagedOut["已换出到<br/>pagefile 的部分"]
            NeverTouched["已提交但<br/>从未访问的部分"]
        end
        Reserved["仅保留<br/>未提交的部分"]
    end

    style PWS fill:#e74c3c,color:#fff
    style SWS fill:#2ecc71,color:#000
    style WS fill:#2c3e50,color:#fff
    style CS fill:#1a252f,color:#fff
    style VS fill:#0d1317,color:#fff
    style PagedOut fill:#7f8c8d,color:#fff
    style NeverTouched fill:#95a5a6,color:#000
    style Reserved fill:#bdc3c7,color:#000
```

### 4.2 指标详解对照表

| 指标           | 任务管理器列名 | 性能计数器名                       | 含义                                | 典型用途                   |
| :------------- | :------------- | :--------------------------------- | :---------------------------------- | :------------------------- |
| **专用工作集** | 内存（默认）   | `Process(*)\Working Set - Private` | 此刻该进程**独占**的物理内存        | 日常排查"谁占了我的内存"   |
| **工作集**     | 工作集(内存)   | `Process(*)\Working Set`           | 此刻驻留物理内存的总量（私有+共享） | 分析物理内存压力           |
| **共享工作集** | 共享的工作集   | `Process(*)\Working Set - Shared`  | 与其他进程共享的物理内存(DLL等)     | 分析共享效率               |
| **提交大小**   | 提交大小       | `Process(*)\Private Bytes`         | 已提交的私有虚拟内存总量            | **排查内存泄漏（最关键）** |
| **虚拟大小**   | —              | `Process(*)\Virtual Bytes`         | 虚拟地址空间中非Free的总量          | 32位进程地址耗尽排查       |
| **缺页错误**   | 页面错误       | `Process(*)\Page Faults/sec`       | 每秒缺页次数（软+硬）               | 判断是否频繁换页           |

### 4.3 大小关系与典型数值

通常: 虚拟大小 >> 提交大小 ≥ 工作集 ≥ 专用工作集

| 指标           | Chrome 单标签页(举例) | 大型 Java 服务(举例) | 说明                           |
| :------------- | --------------------: | -------------------: | :----------------------------- |
| 虚拟大小       |             ~4,000 MB |           ~20,000 MB | 64位进程通常很大，参考价值最低 |
| 提交大小       |               ~300 MB |            ~8,000 MB | 含已换出和未访问部分           |
| 工作集         |               ~250 MB |            ~6,000 MB | 含共享 DLL                     |
| **专用工作集** |               ~200 MB |            ~5,800 MB | **日常看这个**                 |
| 共享工作集     |                ~50 MB |              ~200 MB | 共享 DLL 代码等                |

---

## 五、分页与缺页异常

```mermaid
flowchart TB
    Access["进程访问虚拟地址"] --> Check{"页表中<br/>有效映射?"}
    Check -->|有| PhyAccess["直接访问物理内存<br/>✓ 无开销"]
    Check -->|无| PF["触发 Page Fault<br/>(缺页异常)"]
    
    PF --> Type{"页面在哪?"}
    
    Type -->|在 Standby/Modified 列表| Soft["<b>软缺页 (Soft)</b><br/>重新映射即可<br/>⚡ 微秒级"]
    Type -->|在 pagefile.sys| Hard1["<b>硬缺页 (Hard)</b><br/>从磁盘读入<br/>🐢 毫秒级"]
    Type -->|在 DLL/EXE 文件| Hard2["<b>硬缺页 (Hard)</b><br/>从文件读入<br/>🐢 毫秒级"]
    Type -->|首次访问<br/>demand-zero| DZ["分配零化页面<br/>⚡ 快速"]

    style Soft fill:#2ecc71,color:#000
    style Hard1 fill:#e74c3c,color:#fff
    style Hard2 fill:#e74c3c,color:#fff
    style DZ fill:#f1c40f,color:#000
```

| 缺页类型 | 性能影响                 | 性能计数器                         | 大量出现意味着         |
| :------- | :----------------------- | :--------------------------------- | :--------------------- |
| 软缺页   | 微秒级，几乎无感         | `Memory\Page Faults/sec` (含软+硬) | 正常现象               |
| 硬缺页   | 毫秒级，**严重影响性能** | `Memory\Pages Input/sec` (仅硬)    | 物理内存不足，频繁换页 |

> **判断内存是否真的不够，看硬缺页率比看使用率百分比更准确。**

---

## 六、工作集修剪与写时复制

### 6.1 工作集修剪 (Working Set Trimming)

```mermaid
sequenceDiagram
    participant MM as 内存管理器
    participant P as 进程工作集
    participant S as Standby 列表

    Note over MM: 检测到内存压力
    MM->>P: 扫描"老化"页面(长期未访问)
    P->>S: 冷门页面移出工作集
    Note over P: 工作集变小<br/>但提交大小不变
    Note over S: 页面内容还在<br/>可被快速召回
    
    Note over P: 进程再次访问该页面
    S->>P: 软缺页 → 页面回到工作集
```

> **工作集减小 ≠ 进程释放了内存。** 只是暂时让出物理内存，数据仍然存在。这就是最小化窗口后进程"内存"看起来变小的原因。

### 6.2 写时复制 (Copy-on-Write)

```mermaid
graph LR
    subgraph 初始状态
        PA1["进程A 页表"] -->|映射| Shared["物理页面<br/>(DLL数据段)<br/>标记: 只读+COW"]
        PB1["进程B 页表"] -->|映射| Shared
    end

    subgraph 进程A写入后
        PA2["进程A 页表"] -->|映射| Copy["新物理页面<br/>(A的私有副本)"]
        PB2["进程B 页表"] -->|映射| Original["原始物理页面"]
    end

    初始状态 -->|"进程A尝试写入"| 进程A写入后

    style Shared fill:#2ecc71,color:#000
    style Copy fill:#e74c3c,color:#fff
    style Original fill:#2ecc71,color:#000
```

---

## 七、内核态内存消费者（不属于任何进程）

```mermaid
graph TB
    subgraph 系统已使用["任务管理器 '已使用'"]
        Proc["所有进程工作集<br/>(含共享)"]
        subgraph 内核消费者["内核/驱动 (不在进程列表中)"]
            NP["非分页池<br/>Nonpaged Pool"]
            PP["分页池<br/>Paged Pool"]
            PT["页表<br/>Page Tables"]
            DRV["驱动代码+数据"]
            MF["Metafile<br/>(NTFS元数据缓存)"]
            SK["系统内核代码"]
            MOD["Modified 列表"]
        end
    end

    style Proc fill:#3498db,color:#fff
    style NP fill:#e74c3c,color:#fff
    style PP fill:#e67e22,color:#fff
    style PT fill:#9b59b6,color:#fff
    style DRV fill:#c0392b,color:#fff
    style MF fill:#d35400,color:#fff
    style MOD fill:#f39c12,color:#000
```

| 内核消费者   | 说明                           | 正常范围           | 异常诊断                                  |
| :----------- | :----------------------------- | :----------------- | :---------------------------------------- |
| **非分页池** | 内核常驻物理内存，绝不换出     | < 300-500 MB       | 过大 → 驱动泄漏，用 `poolmon` 按 Tag 排查 |
| **分页池**   | 内核对象、注册表缓存等，可换出 | < 500-800 MB       | 过大 → 句柄/对象泄漏                      |
| **页表**     | 每个进程的虚拟→物理地址映射表  | 每进程几MB到几十MB | 大量进程 / 大虚拟空间 → 页表总量可达数GB  |
| **Metafile** | NTFS MFT 缓存                  | 依文件数量         | 海量小文件服务器可达数GB                  |
| **驱动代码** | 内核态驱动程序映像             | ~100-300 MB        | 驱动数量异常多                            |
| **Modified** | 脏页待写回磁盘                 | < 几百MB           | 持续偏大 → 磁盘I/O瓶颈                    |

---

## 八、提交量 (Commit Charge) 全局视角

```mermaid
graph TB
    subgraph 提交上限["提交上限 (Commit Limit) = 物理内存 + 所有页面文件大小"]
        subgraph 已提交["已提交 (Committed)"]
            ProcPriv["所有进程 Private Bytes 之和"]
            KernelPaged["内核分页池"]
            KernelNP["内核非分页池"]
            PT2["页表"]
        end
        Available["剩余可提交量"]
    end

    style 已提交 fill:#e74c3c,color:#fff
    style Available fill:#2ecc71,color:#000
```

| 概念                        | 含义                       | 监控要点                 |
| :-------------------------- | :------------------------- | :----------------------- |
| **提交量 (Committed)**      | 系统承诺分配的虚拟内存总量 | 接近上限 → 新分配会失败  |
| **提交上限 (Commit Limit)** | 物理内存 + 页面文件总大小  | 可通过增大 pagefile 提高 |
| **提交比率**                | Committed / Commit Limit   | > 80% 需要关注           |

> **Commit Limit 用完比物理内存用完更致命。** 物理内存满了可以换页（变慢），Commit 满了程序直接分配失败（崩溃）。

---

## 九、内存泄漏判定方法

```mermaid
graph TB
    Start["怀疑内存泄漏"] --> Q1{"提交大小(Private Bytes)<br/>是否持续单调递增?"}
    Q1 -->|是| Q2{"Handle 数量<br/>是否同步增长?"}
    Q1 -->|否，波动后回落| OK["正常行为<br/>可能是缓存/缓冲区"]

    Q2 -->|是| HandleLeak["句柄泄漏<br/>导致内存泄漏<br/>查看哪类句柄在增长"]
    Q2 -->|否| PureMem["纯内存泄漏<br/>堆分配未释放"]

    HandleLeak --> Tool1["Process Explorer<br/>查看句柄明细"]
    PureMem --> Tool2["UMDH<br/>对比两次堆快照<br/>定位泄漏调用栈"]

    style OK fill:#2ecc71,color:#000
    style HandleLeak fill:#e74c3c,color:#fff
    style PureMem fill:#e67e22,color:#fff
```

### 泄漏判定要看的指标

| 观察指标          | 正常表现           | 泄漏表现                   | 工具               |
| :---------------- | :----------------- | :------------------------- | :----------------- |
| **Private Bytes** | 有升有降，趋势平稳 | 持续上升，从不回落         | 性能监视器长期记录 |
| **Working Set**   | 波动（受修剪影响） | 参考价值次于 Private Bytes | 任务管理器         |
| **Handle Count**  | 稳定在某个范围     | 持续增长                   | Process Explorer   |
| **GDI Objects**   | 稳定               | 持续增长                   | 任务管理器(添加列) |
| **Thread Count**  | 稳定               | 持续增长                   | 任务管理器         |
| **Virtual Size**  | 稳定               | 持续增长 → 地址空间碎片化  | VMMap              |

---

## 十、分析场景速查矩阵

| 场景                     | 首先看什么                    | 然后看什么                      | 推荐工具            |
| :----------------------- | :---------------------------- | :------------------------------ | :------------------ |
| 谁在占内存               | 各进程**专用工作集**排序      | 同名进程分组求和                | 任务管理器 / 脚本v2 |
| 系统内存高但找不到大进程 | 非分页池、分页池              | RAMMap 查 Page Table / Metafile | RAMMap              |
| 怀疑内存泄漏             | **Private Bytes** 趋势        | Handle Count 趋势               | 性能监视器 + UMDH   |
| 系统卡顿                 | `Pages Input/sec` (硬缺页)    | Modified 列表大小               | 资源监视器          |
| 进程提交大但工作集小     | 大量被换出到 pagefile         | 是否内存紧张导致                | VMMap               |
| 32位进程崩溃             | Virtual Size 是否接近 2GB/3GB | 地址空间碎片化                  | VMMap               |
| 驱动/内核泄漏            | 非分页池是否异常增长          | `poolmon` 按 Tag 分析           | poolmon / WinDbg    |

---

## 十一、工具体系

```mermaid
graph LR
    subgraph 内置["Windows 内置"]
        TM["任务管理器<br/>快速查看"]
        RM["资源监视器<br/>resmon.exe<br/>物理内存分类"]
        PM["性能监视器<br/>perfmon.exe<br/>长期趋势记录"]
        PS["PowerShell<br/>脚本化分析"]
    end

    subgraph SI["Sysinternals (免费)"]
        PE["Process Explorer<br/>增强版任务管理器"]
        RMAP["RAMMap<br/>★ 物理内存精确分类"]
        VMAP["VMMap<br/>单进程地址空间分析"]
        PMON["procmon<br/>实时行为监控"]
    end

    subgraph DEV["开发者 / 高级"]
        DBG["WinDbg<br/>内核级分析"]
        UMDH2["UMDH<br/>堆泄漏追踪"]
        POOL["poolmon<br/>内核池Tag分析"]
    end

    TM -->|"想看更多细节"| PE
    TM -->|"想知道内存去哪了"| RMAP
    PE -->|"想看单进程地址空间"| VMAP
    PM -->|"发现持续增长"| UMDH2
    RMAP -->|"非分页池异常"| POOL

    style RMAP fill:#e74c3c,color:#fff
    style PE fill:#e67e22,color:#fff
    style VMAP fill:#f1c40f,color:#000
```

### 各工具解决什么问题

| 工具                 | 核心价值                                          | 何时用                 |
| :------------------- | :------------------------------------------------ | :--------------------- |
| **RAMMap**           | 精确解释物理内存每1MB的去向                       | "内存去哪了"的终极答案 |
| **Process Explorer** | 查看任务管理器没有的列（Private Bytes、句柄详情） | 日常替代任务管理器     |
| **VMMap**            | 可视化单进程的虚拟地址空间布局                    | 分析某个进程内存结构   |
| **性能监视器**       | 长期录制计数器数据并画图                          | 确认泄漏趋势           |
| **poolmon**          | 按分配 Tag 显示内核池使用                         | 诊断内核池泄漏         |
| **UMDH**             | 对比两个时间点的堆分配快照，定位泄漏函数          | 精确定位用户态泄漏代码 |

---

## 十二、完整内存构成对账

以 16GB 物理内存为例，将所有概念串联：

| 层级       | 项目                  |        示例值 | 来源               | 是否在进程列表可见 |
| :--------- | :-------------------- | ------------: | :----------------- | :----------------: |
| **硬件层** | 物理内存总计          |     16,384 MB | BIOS               |         —          |
|            | 硬件保留              |       -512 MB | BIOS/集显          |         ✗          |
|            | **OS 可见总量**       | **15,872 MB** |                    |         —          |
| **已使用** | 进程专用工作集之和    |      7,200 MB | 各进程             |         ✓          |
|            | 进程间共享页面(DLL等) |        800 MB | 共享               |        部分        |
|            | 非分页池              |        350 MB | 内核               |         ✗          |
|            | 分页池(驻留)          |        400 MB | 内核               |         ✗          |
|            | 页表                  |        300 MB | 内核               |         ✗          |
|            | 驱动(驻留)            |        150 MB | 内核               |         ✗          |
|            | Metafile              |        200 MB | 内核               |         ✗          |
|            | Modified 列表         |        150 MB | 内核               |         ✗          |
|            | 其他(系统代码等)      |        100 MB | 内核               |         ✗          |
|            | **已使用小计**        | **≈9,650 MB** | 任务管理器"已使用" |         —          |
| **可用**   | Standby 缓存          |      5,500 MB | 文件缓存，可回收   |         ✗          |
|            | Free + Zeroed         |        722 MB | 真空闲             |         ✗          |
|            | **可用小计**          | **≈6,222 MB** | 任务管理器"可用"   |         —          |

差值 = 已使用(9,650) - 进程专用工作集之和(7,200) = 2,450 MB
这 2,450 MB = 非分页池 + 分页池 + 页表 + 驱动 + Metafile + Modified + 共享 + ...
→ 这就是"进程加起来对不上"的原因