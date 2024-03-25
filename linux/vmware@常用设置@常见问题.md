

[toc]

## VMware tools安装

- 虚拟机里面默认有一个移动盘,点击它进行安装
- 也可以在虚拟机运行时,右键虚拟机选项卡,设置选项中的安装vmwaretools

## windows

### 窗口大小设置

- 个性话,屏幕的缩放大小和分辨率设置进行调整

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/d49c8c4b3e3548e4804efcf72f7eaf3c.png)

### 设为按流量计费限制不必要的安装和更新行为

- 点击已经链接的网络,以太网也可以,设置为按流量计费

### vmware  网络/ip 问题

### 启用连接

![image-20220413084413046](https://s2.loli.net/2022/04/13/uBZnJWaOR89N5X2.png)

### 虚拟机关机

- 请从系统内部关机,比如虚拟机中的windows系统,就开始菜单里面去点关机,而不应该依赖于虚拟机外部的关机按钮,这是强制关机,容易造成虚拟机异常!

### 虚拟机性能

- [Configuring Virtual Machine Processor Settings (vmware.com)](https://docs.vmware.com/en/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-3140DF1F-A105-4EED-B9E8-D99B3D3F0447.html)
- [配置虚拟机处理器设置 (vmware.com)](https://docs.vmware.com/cn/VMware-Workstation-Pro/17/com.vmware.ws.using.doc/GUID-3140DF1F-A105-4EED-B9E8-D99B3D3F0447.html)

- 现在的计算机价格相比以往已经大大降低了,以移动笔记本为例,如果不需要配备独立显卡,购买具有10个核心的cpu的机器甚至只要3千多,无论时Intel,AMD平台,cpu的核心数量大大增加;比如intel,从12代开始,大小核异构以来,处理器核心数量大大增加,例如12700H,核心组成为6p+8e,达到14个核心,20个线程;高端型号可以达到8p+16e,其中p是大核心,可以分出2个线程,e核小核心一个核心一个线程,足足有32个线程

- 因此如果虚拟机数量不多的话,可以分别4个核心或更多核心给虚拟机


#### 分配示例

- 分配包括处理器数量以及每个处理器的核心数量
- 经过简单的试验,从虚拟机的任务管理器中查看的核心

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/0a95baec01634945b8a5a86f1f48d88a.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/2039e41dde7648edbcc80af9ca17e4a1.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | 分配4个处理器,每个处理器2个核心                              | 分配4个处理器,每个处理器4个核心                              |      |

- 对应关系比较复杂,参考文档了解详情



