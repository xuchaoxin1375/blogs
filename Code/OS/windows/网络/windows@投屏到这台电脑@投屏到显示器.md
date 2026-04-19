[toc]



## 当前windows电脑投屏到其他屏幕

- [连接到投影仪或电脑 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/连接到投影仪或电脑-7e170c39-58dc-c866-7d55-be2372632892#ID0EBD=Windows_10)

## 其他屏幕投影到当前windows电脑上

[屏幕镜像和投影到电脑或无线显示器 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/屏幕镜像和投影到电脑或无线显示器-5af9f371-c704-1c7f-8f0d-fa607551d09c)

- 早期的windows11 或者win10是内置了`wireless display`模块,不需要下载安装
- 新版的win11需要安装可选功能模块`wireless display`才能够使用,安装时间可能要比较久
- 现在的大部分手机都支持投屏到电脑上,在控制中心的磁贴按钮或者设置找到投屏功能就可以扫描同一网络中的处于待被投屏的windows设备

## 相关技术

Miracast 和 WiGig 是两种无线传输技术，分别用于不同的应用场景。

### Miracast

[Miracast | Wi-Fi Alliance](https://www.wi-fi.org/zh-hans/discover-wi-fi/miracast)

**Miracast** 是一种无线显示技术，允许设备之间进行屏幕镜像或扩展。它的主要特点如下：

1. **无线屏幕镜像**（Wireless Screen Mirroring）：Miracast 允许你将设备（如智能手机、平板电脑或电脑）的屏幕内容无线传输到另一个支持 Miracast 的设备（如电视或投影仪）上。
2. **点对点连接**（Peer-to-Peer Connection）：Miracast 使用 Wi-Fi Direct 技术，不需要依赖无线网络路由器，因此在没有 Wi-Fi 网络的情况下也可以使用。
3. **高分辨率支持**（High-Resolution Support）：Miracast 支持 1080p 的高清内容传输，有些设备还支持 4K 分辨率。
4. **音频传输**（Audio Transmission）：除了视频内容外，Miracast 也支持音频传输，可以实现同步的音视频体验。

### WiGig

**WiGig**（Wireless Gigabit）是一种更高带宽的无线传输技术，主要特点如下：

1. **高速度传输**（High-Speed Transmission）：WiGig 工作在 60 GHz 频段，提供高达 7 Gbps 的数据传输速率，比传统 Wi-Fi 速度更快。
2. **短距离传输**（Short-Range Transmission）：由于高频段信号传播特性，WiGig 适用于短距离（几米范围内）的高速数据传输，比如在同一个房间内的设备之间传输数据。
3. **低延迟**（Low Latency）：WiGig 的高带宽和短距离特性使其非常适合需要低延迟的应用场景，如虚拟现实（VR）和增强现实（AR）设备的无线连接。
4. **高带宽应用**（High Bandwidth Applications）：WiGig 适用于需要高带宽的应用，如无线扩展坞（wireless docking）、视频流传输以及大文件的快速传输。

### 总结

- **Miracast** 主要用于无线屏幕镜像和扩展，适用于将设备的屏幕内容传输到另一个显示设备上，支持高清分辨率和音频传输。
- **WiGig** 主要用于短距离的高速数据传输，适用于需要高带宽和低延迟的应用场景，如无线扩展坞和 VR/AR 设备连接。

这两种技术在各自的应用场景中都具有独特的优势，选择使用哪种技术主要取决于具体的需求。