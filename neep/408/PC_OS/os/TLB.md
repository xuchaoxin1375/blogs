# Translation lookaside buffer(块表/转译后备缓冲器)

**转译后备缓冲器**（英语：Translation Lookaside Buffer，[首字母缩略字](https://zh.wikipedia.org/wiki/首字母縮略字)：TLB），

- 在被翻译为**页表缓存**、**转址旁路缓存**

- [CPU](https://zh.wikipedia.org/wiki/中央處理器)的一种缓存，由[内存管理单元](https://zh.wikipedia.org/wiki/内存管理单元)用于**<u>改进[虚拟地址](https://zh.wikipedia.org/wiki/虛擬位址)到物理地址的转译速度</u>**。

- 目前所有的桌面型及服务器型处理器（如 [x86](https://zh.wikipedia.org/wiki/X86)）皆使用TLB。

- TLB具有**固定数目的空间槽**，用于存放将虚拟地址映射至[物理地址](https://zh.wikipedia.org/wiki/物理地址)的[标签页表](https://zh.wikipedia.org/wiki/分頁表)条目。

- 为典型的[结合存储](https://zh.wikipedia.org/w/index.php?title=結合存儲&action=edit&redlink=1)（content-addressable memory，[首字母缩略字](https://zh.wikipedia.org/wiki/首字母縮略字)：CAM）。

- 其搜索**关键字为虚拟内存地址**，其**搜索结果为物理地址**。

- 如果请求的虚拟地址在TLB中存在，CAM 将给出一个非常快速的匹配结果，之后就可以使用得到的物理地址访问存储器。

- 如果请求的虚拟地址不在 TLB 中，就会使用[标签页表](https://zh.wikipedia.org/wiki/分頁表)进行虚实地址转换，而[标签页表](https://zh.wikipedia.org/wiki/分頁表)的访问速度比TLB慢很多。

  - 有些系统允许[标签页表](https://zh.wikipedia.org/wiki/分頁表)被交换到次级存储器，那么虚实地址转换可能要花非常长的时间。

  

- A **translation lookaside buffer** (**TLB**) is a memory [cache](https://en.wikipedia.org/wiki/CPU_cache) that stores the recent translations of [virtual memory](https://en.wikipedia.org/wiki/Virtual_memory) to [physical memory](https://en.wikipedia.org/wiki/Physical_memory). 
- It is used to reduce the time taken to access a user memory location.[[1\]](https://en.wikipedia.org/wiki/Translation_lookaside_buffer#cite_note-ostep-1-1) 
- It can be called an address-translation cache. 
- It is a part of the chip's [memory-management unit](https://en.wikipedia.org/wiki/Memory_management_unit) (MMU). 
- A **TLB** may reside between the [CPU](https://en.wikipedia.org/wiki/Central_processing_unit) and the [CPU cache](https://en.wikipedia.org/wiki/CPU_cache), between CPU cache and the main memory or between the different levels of **the multi-level cache.** 
- The majority of desktop, laptop, and server processors include **one or more TLBs in the memory-management** hardware, and it is **nearly always present** in any **processor** that utilizes [paged](https://en.wikipedia.org/wiki/Paging) or [segmented](https://en.wikipedia.org/wiki/Memory_segmentation) [virtual memory](https://en.wikipedia.org/wiki/Virtual_memory).

- The TLB is sometimes implemented as [content-addressable memory](https://en.wikipedia.org/wiki/Content-addressable_memory) (CAM). 
  - The CAM search key is **the virtual address,** and the search result is a [physical address](https://en.wikipedia.org/wiki/Physical_address). 
  - If **the requested address** is present in the TLB, the CAM search **yields** a match **quickly** and the retrieved physical address can be used to access memory. 
  - This is called a TLB hit. 
  - If the requested address is **not in the TLB**, **it is a miss**, and the translation **proceeds** by looking up the [page table](https://en.wikipedia.org/wiki/Page_table) in a **process** called **a *page walk*.** 
    - The page walk is time-consuming when compared to the processor speed, as <u>it involves reading the contents of multiple memory locations</u> and **using them to compute the physical address**. 
    - After the physical address is **determined by the page walk,** the virtual address to physical address mapping **is entered into the TLB.** 
    - The [PowerPC 604](https://en.wikipedia.org/wiki/PowerPC_604), for example, has a two-way [set-associative](https://en.wikipedia.org/wiki/Set-associative) TLB for data loads and stores.[[2\]](https://en.wikipedia.org/wiki/Translation_lookaside_buffer#cite_note-2) 
    - some processors have different instruction and **data address** TLBs.
- TLB 用于缓存一部分[标签页表](https://zh.wikipedia.org/wiki/分頁表)条目。
- TLB可介于CPU和 [CPU缓存](https://zh.wikipedia.org/wiki/CPU缓存)之间，或在CPU、缓存和[主存](https://zh.wikipedia.org/wiki/主記憶體)之间，这取决于缓存使用的**是物理寻址或是虚拟寻址**。
  - 如果缓存是虚拟寻址，**寻址请求**将会**直接从 CPU 发送给缓存**，然后从缓存**访问所需的 TLB 条目**。
  - 如果缓存使用物理寻址，CPU 会先**对每一个存储器操作进行TLB查寻**，并且将获取的**物理地址发送给缓存**。两种方法各有优缺点。
    - 采用物理寻址的缓存的一种常见优化，是**并行的进行 TLB 查寻和缓存的访问**。
    - 所有虚拟地址**的较低比特**（例如，在[虚拟内存](https://zh.wikipedia.org/wiki/虚拟内存)系统中具有 4KB 标签页时，虚拟地址中较低的那 12 比特）代表的是**所请求的地址**在**分页内部的地址偏移量（页内地址**），
    - 且这些比特**不会在虚拟地址转换到物理地址的过程中发生改变**。
    - 访问CPU缓存的过程包含**两步：**
      - 使用一条**索引**去寻找CPU缓存的**资料存储区中的相应条目**，然后比较找到的CPU缓存条目的相应标记。
      - 如果**缓存**是用**虚实地址转译过程中不变的页内地址**来索引组织起来的，则可并行地执行TLB上虚实地址的较高比特(即分页的页间地址／页号）的转换与CPU缓存的“索引”操作。
      - 然后，从 TLB 获得的的物理地址的页号会发送给CPU缓存。
      - CPU缓存会对页号标记进行比较，以决定此次访问是寻中或是缺失。
      - 它也有可能并行的进行 TLB 查寻和CPU缓存访问，即使CPU缓存必须使用某些可能会在地址转译后发生改变的比特；
  - 参阅缓存条目的[地址翻译](https://zh.wikipedia.org/wiki/CPU缓存#地址翻译)一节，以获取关于**虚拟寻址下缓存和 TLB** 的进一步细节。

## 具有块表的地址变换机构

- 快表,又称相联存储器,用来存放当前访问的<u>*若干*</u>**页表项**目,可以加速地址变换的过程
- 慢表:主寸中的页表

### 具有块表的分页机制

- cpu给出逻辑地址后,有硬件进行地址转换,将页号送入高速缓存寄存器再将此页号与TLB中的所有页号进行比较(并行)
- 如果找到匹配的页号,good luck:说明要访问的页表项就在块表中,直接从中去除该页对应的页框号(frame number),与页内偏移量拼接形成物理地址,这个内存物理地址知道了以后,存取数据仅需要一次访存就可以实现

- 如果没有再块表中匹配到页号,则需要访问主存中的页表,读出页表项后,同时将该页表项存入块表中.
  - 如果块表已满,则按特定算法淘汰掉一个旧的页表项,来接纳新的页表项





