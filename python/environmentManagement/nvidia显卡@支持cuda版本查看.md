[toc]

## 显卡信息查看

- 如果你的显卡驱动正常,在终端中输入`nvidia-smi`

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

    

### nvidia-smi

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

## Geforce RTX @Geforce MX

- https://askanydifference.com/difference-between-nvidia-geforce-gtx-and-mx/

## 显卡驱动下载@更新

- [官方驱动 | NVIDIA](https://www.nvidia.cn/Download/index.aspx?lang=cn)