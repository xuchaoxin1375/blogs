[toc]

## Nvidia显卡

- NVIDIA（英伟达）是一家知名的图形处理单元（GPU）制造商，其显卡产品被广泛应用于个人计算机、工作站、数据中心、游戏机以及移动设备等多个领域。
- 随着技术的不断进步，NVIDIA显卡还在AI、深度学习、自动驾驶等领域展现出越来越重要的作用。
- 以下是关于NVIDIA显卡的一些基本常识

### 产品类型

- **独立显卡**：NVIDIA生产多种类型的独立显卡，如
  - **GeForce**系列面向游戏玩家和内容创作者，
  - Quadro系列针对专业图形设计和工程应用，
  - TITAN系列则定位于高端计算和专业图形处理市场。
- **集成显卡**：虽然NVIDIA主要以独立显卡著称，但它也曾与其他厂商合作提供集成显卡解决方案，即GPU与CPU封装在一起或者主板上的集成图形处理器。

#### GeForce系列

- 最常见的Nvidia显卡系列[GeForce - Wikipedia](https://en.wikipedia.org/wiki/GeForce) 网站不好打开
- GeForce系列显卡主要面向游戏市场，但也适用于专业图形设计、视频编辑和其他需要高性能图形处理的领域。
  GeForce系列自1999年推出以来，已经发展了多个世代，每个世代都引入了新的架构和技术。这些架构通常以代号命名，如"Tesla"、“Fermi”、“Kepler”、“Maxwell”、“Pascal”、“Turing”、“Ampere"和最新的"Ada Lovelace”。每个新架构都会带来更高的性能、更好的能源效率和新的功能。
- GeForce显卡的一些关键特性包括：
  - CUDA核心：用于执行并行计算的处理器核心。
  - RT核心：用于实时光线追踪技术的专用核心。
  - Tensor核心：用于AI计算的专用核心，尤其是在深度学习超采样（DLSS）技术中。
  - 光线追踪：模拟真实世界光线的物理行为，为游戏和渲染提供更真实的光影效果。
  - 深度学习超采样（DLSS）：利用AI技术提高游戏帧率，同时保持图像质量。
- GeForce系列显卡按照性能和定位分为多个子系列，如GeForce RTX、GeForce GTX等。RTX系列显卡通常包含上述的光线追踪和Tensor核心，而GTX系列则通常不包含这些高级特性。
- GeForce显卡在游戏玩家和专业人士中非常受欢迎，因为它们提供了高性能和丰富的功能，同时支持多种游戏和技术应用。

#### 架构历史NVIDIA GPU Architecture History

- ....

- 2023 [Hopper](https://www.techpowerup.com/gpu-specs/?architecture=Hopper&sort=generation)
- 2022-2024 Ada Lovelace
- 2020-2024 [Ampere](https://www.techpowerup.com/gpu-specs/?architecture=Ampere&sort=generation)
- 2018-2022 [Turing](https://www.techpowerup.com/gpu-specs/?architecture=Turing&sort=generation)
- 2017-2020 [Volta](https://www.techpowerup.com/gpu-specs/?architecture=Volta&sort=generation)
- 2016-2021 [Pascal](https://www.techpowerup.com/gpu-specs/?architecture=Pascal&sort=generation)
- 2014-2019 [Maxwell 2.0](https://www.techpowerup.com/gpu-specs/?architecture=Maxwell+2.0&sort=generation)
- 2014-2017 [Maxwell](https://www.techpowerup.com/gpu-specs/?architecture=Maxwell&sort=generation)
- 2013-2015 [Kepler 2.0](https://www.techpowerup.com/gpu-specs/?architecture=Kepler+2.0&sort=generation)
- 2012-2018 [Kepler](https://www.techpowerup.com/gpu-specs/?architecture=Kepler&sort=generation)
- 2010-2016 [Fermi 2.0](https://www.techpowerup.com/gpu-specs/?architecture=Fermi+2.0&sort=generation)
- 2010-2013 [VLIW Vec4](https://www.techpowerup.com/gpu-specs/?architecture=VLIW+Vec4&sort=generation)
- 2010-2016 [Fermi](https://www.techpowerup.com/gpu-specs/?architecture=Fermi&sort=generation)
- 2007-2013 [Tesla 2.0](https://www.techpowerup.com/gpu-specs/?architecture=Tesla+2.0&sort=generation)
- 2006-2010 [Tesla](https://www.techpowerup.com/gpu-specs/?architecture=Tesla&sort=generation)
- 2003-2013 [Curie](https://www.techpowerup.com/gpu-specs/?architecture=Curie&sort=generation)
- 2003-2005 [Rankine](https://www.techpowerup.com/gpu-specs/?architecture=Rankine&sort=generation)
- 2001-2003 [Kelvin](https://www.techpowerup.com/gpu-specs/?architecture=Kelvin&sort=generation)
- 1999-2005 [Celsius](https://www.techpowerup.com/gpu-specs/?architecture=Celsius&sort=generation)
- 1998-2000 [Fahrenheit](https://www.techpowerup.com/gpu-specs/?architecture=Fahrenheit&sort=generation)

### 命名规则

- NVIDIA显卡的命名系统包含前缀（如RTX、GTX、GTS、GT等，性能通常RTX>GTX>GTS>GT）、代数（如RTX 30系列、RTX 40系列，数字越大表示越新且通常性能更强）、定位（如60、70、80分别对应不同的性能等级，数字越大性能越高）以及后缀（如Ti表示增强型，SUPER表示同一代中的强化版本，LE可能表示较低规格或简化版）。
- 性能大致排行:
  - 在NVIDIA的GPU产品线中，NVIDIA 30系列显卡（按照大致性能降序排列）：
    1. GeForce RTX 3090 Ti (顶级消费级显卡)
    2. GeForce RTX 3090
    3. GeForce RTX 3080 Ti
    4. GeForce RTX 3080 (12GB/10GB)
    5. GeForce RTX 3070 Ti
    6. GeForce RTX 3070
    7. GeForce RTX 3060 Ti
    8. GeForce RTX 3060
    9. GeForce RTX 3050 Ti
    10. GeForce RTX 3050
  - 如果是跨代产品比较,则主要考虑后两位数字以及尾缀字母

### 前缀和后缀



- NVIDIA显卡的后缀通常用来表示显卡的性能级别、市场定位或者是特定的功能。以下是一些常见的后缀及其含义：
  1. **Ti (Titanium)**：通常表示该显卡是某个系列中的高性能版本，例如RTX 3080 Ti。
  2. **Super**：表示该显卡是某个系列中的升级版，相比同系列的非Super版本会有更高的时钟速度和更多的CUDA核心，例如RTX 2070 Super。
  3. **MX**：用于NVIDIA针对笔记本电脑的显卡，表示该显卡是为了轻薄设计而优化，可能在性能上有所妥协以换取更低的功耗和散热需求。
  4. **FE (Founders Edition)**：表示这是NVIDIA官方的创始版显卡，通常具有较为简洁的设计和高品质的制造。
  5. **SE (Special Edition)**：表示特别版，可能指的是针对特定市场或事件的限量版显卡。
  6. **LE (Lite Edition)**：通常表示该显卡是某个系列中的简化版，性能较低，价格也更为亲民。
  7. **GS (Game Ready)**：在某些旧型号显卡中，GS后缀表示该显卡针对游戏进行了优化。
  8. **OC (Overclocked)**：表示该显卡出厂时已经进行了超频，提供比标准版更高的性能。
  需要注意的是，这些后缀并不是固定不变的，NVIDIA会根据市场需求和技术发展调整后缀的使用。购买显卡时，建议详细查看显卡的规格和性能指标，以确定是否符合您的需求。
- 需要注意的是，NVIDIA的显卡命名规则会随时间和产品周期的变化而有所调整，上述信息并不一定涵盖所有历史时期和未来可能出现的所有后缀变化。购买时请参考最新发布的显卡型号及官方介绍以获取准确信息。

### 技术特点

- CUDA：NVIDIA的CUDA是一种并行计算架构，允许开发者利用GPU进行大规模并行计算任务，极大地提升了科学计算、深度学习和大数据分析等领域的效率。
- RTX实时光线追踪：RTX系列显卡支持硬件级别的光线追踪技术，用于实时渲染更为逼真的光影效果。
- DLSS（深度学习超级采样）：这是一种基于AI的抗锯齿技术，能够提高游戏帧率同时保持高画质。

### 性能指标👺

- **显存容量**：如12GB GDDR6X，表示显卡配备的高速显存大小。
- **显存位宽**：如192bit，决定了显卡一次性传输数据的能力。
- **核心频率**：包括基础频率和加速频率，表示GPU的工作速度。
- **显存频率**：显存运行的速度，影响数据读取速度。

#### 显存(VRAM)

- VRAM全称为Video Random Access Memory，中文译为“视频随机访问存储器”，也常被称为显存或帧缓冲存储器。它是显卡上专门用于存储图形数据的一种高速缓存，是显卡的重要组成部分之一。

  在图形渲染过程中，GPU（图形处理器）需要大量的临时存储空间来存放即将渲染的画面信息，包括但不限于像素数据、纹理贴图、顶点数据、深度信息等等。VRAM的作用就是为GPU提供这样的存储空间，使得GPU能够快速访问和处理这些图形数据。

- 显存的容量大小和速度对显卡性能有直接的影响。容量越大，显卡能同时处理的图形数据越多，尤其在高分辨率、高画质的游戏或专业图形应用中尤为关键。而显存速度（即带宽）决定了数据在GPU和VRAM之间交换的速率，高带宽能有效减少数据延迟，提升整体图形处理效率。

- 此外，显存类型（如GDDR5、GDDR6等）和位宽也会影响VRAM的性能表现。随着图形技术的发展，VRAM的容量和速度也在不断提升，以满足日益增长的图形处理需求。

#### 显存和位宽

- **显存容量**： 显存容量是指显卡上安装的显存总共有多少字节数，通常以MB或GB为单位。显存容量的大小直接影响显卡能够临时存储的数据总量，尤其是在处理大型3D模型、高分辨率图像、复杂的视觉特效和开启大量抗锯齿、阴影等特效时，较大的显存容量可以确保有足够的空间来存储待渲染的数据，避免频繁读取主内存带来的延迟问题。
- **显存位宽**： 显存位宽则是指显卡在一个时钟周期内通过显存总线能够同时传输的数据宽度，单位是比特（bit）。位宽越大，显卡在每个时钟周期内从显存中读取或写入的数据量就越多，从而理论上提高了显卡的数据处理速度和带宽。显存位宽直接影响到显卡的显存带宽，计算公式为：显存带宽 = 显存频率 × 显存位宽 ÷ 8（因为每8位组成一个字节，所以要除以8）。

两者关系分析：

- **性能平衡**：显存容量和位宽必须与GPU核心性能相匹配才能达到最佳性能。如果显存位宽足够大，但容量小，则可能导致显存很快填满而被迫频繁与主内存交换数据，造成性能瓶颈；反之，如果显存容量很大，但位宽过小，则在大量数据需要快速传输时受到带宽限制，同样不能充分发挥显卡潜力。

#### 位宽和现存容量的设计

- 尽管理论上可以显存可以设计的规格非常多,实际上显存芯片的规格类型是有限的
- 假设Nvidia要设计一款192bit位宽的显卡(产品定位和刀法,不给大位宽),并且现在的显存颗粒为32bit
- 每颗显存颗粒的总线位宽是 32bit，因此位宽为192bit 3060 最多只能连接 6 颗显存颗粒(6个显存芯片)。而256bit的 3060Ti 则最多能连接 8 颗显存颗粒。
- 现在的每颗显存颗粒的容量通常为 1GB 或者 2GB,往后可能更高,比如4GB甚至更大。一般要么全用1GB的,要么全用2GB
- 因此 3060 的显存容量只能是 6GB 或者是 12GB。
- 如果是设计128bit的4060laptop显卡,可以链接4个显存芯片(每个芯片用2GB的规格),可以恰好做出8GB的显卡
- 现在已经有128bit的16GB显存了(4060Ti 16gb版本):
  - 据说出来了4G大小的GDDR6显存颗粒，所以可以用四个坑位放四个4G的显存。

### 核心规格

- 以AD107核心为例(甜品卡核心)

- AD107核心是英伟达(NVIDIA)基于Ada Lovelace架构设计的一款GPU（图形处理器）核心，主要用于RTX 40系列显卡中的中低端产品，比如RTX 4050和RTX 4060系列，无论是笔记本版本还是桌面版本都有采用这一核心。

- AD107核心具备以下特点：
  1. **CUDA核心数量**：配备3072个CUDA核心，这代表了其并行计算能力，用于执行图形和通用计算任务。
  2. **制程工艺**：基于台积电（TSMC）的4nm制程工艺制造，有助于提高性能和降低功耗。
  3. **显存配置**：搭载8GB GDDR6显存，显存位宽为128位。
  4. **物理尺寸**：核心面积较小，约为146至150平方毫米，相较于上一代更紧凑。
  5. **接口与缓存**：采用PCIe 4.0 x8接口，并拥有24MB的L2缓存。
  6. **性能**：由于架构优化和更高的工作频率，即使核心规模相对较小，但性能表现相较于上一代同级别产品有所提升。
- 总体来说，AD107核心的目标是提供给用户一个性价比更高、能耗比更好的中端显卡解决方案，适合主流游戏及部分轻度专业应用需求。

### 其他

1. **散热设计**：
   - 不同的NVIDIA显卡采用不同散热方案，例如双风扇、三风扇或水冷散热器等，以保证高性能下的稳定运行。

2. **市场地位**：
   - NVIDIA因其卓越的技术创新、快速的产品迭代和广泛的市场需求，一直在全球显卡市场上占据领先地位。

- 综上所述，了解NVIDIA显卡的关键在于熟悉其命名规则、核心技术以及性能指标，以便根据自身需求选购适合的显卡产品。

  

## Nvidia显卡信息查看

### Nvidia官网查看

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/298971cfad6841f79c58f9db3cec369c.png)

### 其他数据库TechPowerUP👺

- [GPU Database | TechPowerUp](https://www.techpowerup.com/gpu-specs/)
  - 这个网站查看GPU参数很方便,可以查看AMD,NVIDIA的显卡
  - 可以查看核心规格以及其他参数,也可以比较不同显卡的差异

### GeForce系列产品参数在线查看👺

#### 汇总显卡规格比较👺

- [比较 GeForce 系列显卡 | NVIDIA](https://www.nvidia.cn/geforce/graphics-cards/compare/)

#### 其他显卡规格比较

- 最新系列
  - [比较 GeForce 系列最新一代显卡和前代显卡 | NVIDIA](https://www.nvidia.cn/geforce/graphics-cards/compare/?section=compare-20)
- 30系列
  - [GeForce RTX 30 系列笔记本移动端 | NVIDIA](https://www.nvidia.cn/geforce/laptops/30-series/#specs)

- 20系列
  - [GeForce RTX 20 系列显卡和 RTX 20 系列笔记本电脑 | NVIDIA](https://www.nvidia.cn/geforce/20-series/)

#### 移动端(Laptop)比较

- 最新一代产品比较:[Compare GeForce Gaming RTX 40 Series Laptops | NVIDIA](https://www.nvidia.com/en-us/geforce/laptops/compare/)
- 30系列:
  - [GeForce RTX 30-Series Laptops | NVIDIA](https://www.nvidia.com/en-us/geforce/laptops/30-series/#specs)
  - [Compare GeForce Gaming RTX 30 Series Laptops | NVIDIA](https://www.nvidia.com/en-us/geforce/laptops/compare/30-series/)

### 性能天梯图

- 搜索最新的排行榜[IT之家显卡性能天梯图 (ithome.com)](https://m.ithome.com/html/projects/graphics/index.html?hidemenu=1&isrmmp=1)
- 图吧工具箱内的图

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/4cfb11477a0241ffa18de84890b4c189.png)

## 本地显卡信息查看

### 命令行查看

- 如果你的显卡驱动正常,在终端中输入`nvidia-smi`

- [System Management Interface SMI | NVIDIA Developer](https://developer.nvidia.com/nvidia-system-management-interface)介绍页面提供了文档下载

  - ```bash
    🚀  nvidia-smi.exe
    Sun Jan 01 09:34:31 2023
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 419.71       Driver Version: 419.71       CUDA Version: 10.0     |
    |-------------------------------+----------------------+----------------------+
    | GPU  Name            TCC/WDDM | Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |===============================+======================+======================|
    |   0  GeForce MX250      WDDM  | 00000000:02:00.0 Off |                  N/A |
    | N/A   38C    P8    N/A /  N/A |     64MiB /  2048MiB |      0%      Default |
    +-------------------------------+----------------------+----------------------+
    
    +-----------------------------------------------------------------------------+
    | Processes:                                                       GPU Memory |
    |  GPU       PID   Type   Process name                             Usage      |
    |=============================================================================|
    |  No running processes found                                                 |
    +-----------------------------------------------------------------------------+
    ```

- 专业卡(由SageMaker studio Lab)提供的计算平台

  - Tesla T4 的示例

    - 在notebook中执行`!nvidia-smi`

  - ```bash
    Thu Apr 13 11:40:53 2023       
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 470.57.02    Driver Version: 470.57.02    CUDA Version: 11.4     |
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |                               |                      |               MIG M. |
    |===============================+======================+======================|
    |   0  Tesla T4            Off  | 00000000:00:1E.0 Off |                    0 |
    | N/A   28C    P8     9W /  70W |      3MiB / 15109MiB |      0%      Default |
    |                               |                      |                  N/A |
    +-------------------------------+----------------------+----------------------+
                                                                                   
    +-----------------------------------------------------------------------------+
    | Processes:                                                                  |
    |  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
    |        ID   ID                                                   Usage      |
    |=============================================================================|
    |  No running processes found                                                 |
    +-----------------------------------------------------------------------------+
    ```

    

#### nvidia-smi

- `nvidia-smi` 是 NVIDIA 提供的一个命令行实用程序，用于监视和管理系统上的 NVIDIA GPU。

- `nvidia-smi` 的缩写是 NVIDIA System Management Interface。

- 这个工具提供了一种命令行方式来管理 NVIDIA GPU 系统，它可以提供有关 GPU 的各种信息，如使用率、温度、功耗、内存使用情况等,包括监测 GPU 状态和性能、管理 GPU 电源、重置 GPU 等。它可以帮助用户诊断和解决 GPU 相关的问题，以及优化 GPU 的使用和性能。

- 此外，它还可以对GPU进行管理，例如更改功率限制、启用或禁用 ECC 内存、重置 GPU 等。

  下面是 `nvidia-smi` 常用的一些选项和输出信息：

  - `nvidia-smi -a`：显示所有可用的 GPU 信息，包括 GPU 型号、PCIe 位置、驱动程序版本、GPU 的各种状态和硬件规范等。
  - `nvidia-smi -l`：以循环方式显示 GPU 的状态，即每秒更新一次的信息。这个选项通常用于监视 GPU 的实时使用情况。
  - `nvidia-smi -i <GPU ID>`：显示指定 GPU 的状态和信息。可以使用 `-i` 选项指定GPU的ID号，如果系统上有多个GPU，可以通过这个选项来查看每个GPU的状态。
  - `nvidia-smi -q`：显示详细的 GPU 查询信息，包括 GPU 的硬件规范、驱动程序版本、显存使用情况、电源使用情况等。
  - `nvidia-smi -pm 1`：启用 GPU 的独立电源管理模式，这个选项可以让用户更改 GPU 的功率限制。默认情况下，GPU 的功率限制受到驱动程序的控制，但通过启用独立电源管理模式，用户可以更改 GPU 的功率限制并控制其功耗。
  - `nvidia-smi --help`：显示所有可用的选项和命令行参数。

  请注意，`nvidia-smi` 需要在系统上安装 NVIDIA GPU 驱动程序，并且它仅适用于 NVIDIA GPU。

### GUI方式查看

- 开始菜单中搜索Nvidia Control Panel,点击系统信息进行查看

### 第三方工具查看

#### GPU-Z

- GPU-Z:[GPU-Z Graphics Card GPU Information Utility (techpowerup.com)](https://www.techpowerup.com/gpuz/)
  - 下载:[TechPowerUp GPU-Z Download | TechPowerUp](https://www.techpowerup.com/download/techpowerup-gpu-z/)
- 能够查看GPU(包括集显与独显)的更多信息和温度等信息

### Nvidia **Profile** Inspector

- [Releases · Orbmu2k/nvidiaProfileInspector (github.com)](https://github.com/Orbmu2k/nvidiaProfileInspector/releases)
  - 显卡信息查看,也是超频工具,悠着点儿

### 其他工具集合

- 图吧工具[图吧工具箱 - 最纯净的硬件工具箱 (tbtool.cn)](https://www.tbtool.cn/)



## 驱动类别

**Game Ready 驱动程序和 Studio 驱动程序** 

- 同一张显卡,有多种驱动,主要有两类,GameReady驱动和Studio驱动

- 无论您是玩热门新游戏还是使用全新的创意应用程序，NVIDIA 驱动程序都为其定制以提供更佳体验。
- 如果您是游戏玩家，希望在新游戏、新补丁和游戏追加下载内容 (DLC) 的发布日第一时间获得支持，请选择 Game Ready 驱动程序。
- 如果您是内容创作者，优先考虑创意工作流程的稳定性和质量，例如视频编辑、动画、摄影、图形设计和直播等，请选择 Studio 驱动程序。
- 对此还有困惑？不用担心，两种驱动程序**均可支持优秀的游戏和创意应用程序**。
- 总之studio版本的驱动求稳,更新的会慢频率会比Game版低

## 显卡驱动下载@更新👺

- [官方驱动 | NVIDIA](https://www.nvidia.cn/Download/index.aspx?lang=cn)

- [NVIDIA GeForce 驱动程序 - N 卡驱动 | NVIDIA](https://www.nvidia.cn/geforce/drivers/)

- 例如MX系列显卡中的MX250:(GRD版本)

  - [Download NVIDIA, GeForce, Quadro, and Tesla Drivers](https://www.nvidia.cn/content/DriverDownloads/confirmation.php?url=/Windows/532.03/532.03-notebook-win10-win11-64bit-international-dch-whql.exe&lang=us&type=geforcem)

