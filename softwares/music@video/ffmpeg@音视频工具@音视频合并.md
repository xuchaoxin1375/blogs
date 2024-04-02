[toc]

## ffmpeg

- [FFmpeg中文网 (github.net.cn)](https://ffmpeg.github.net.cn/)

- [FFmpeg](https://ffmpeg.org/documentation.html) 是一款强大的开源跨平台音视频处理工具集，它包含了一系列命令行工具以及用于音频和视频编码解码、格式转换、抓取、流化等功能的库。FFmpeg 支持多种视频、音频格式和编解码器，能够进行音视频的压缩、封装、转码、分割、合并、过滤、抓取屏幕、推流到服务器等多种操作。

  它的主要组成部分包括：

  1. **ffmpeg**：命令行工具，用于转换音频、视频文件格式，或者对它们进行各种复杂的处理操作，例如混流、抽取音轨、添加字幕等。
  2. **ffprobe**：用于获取媒体文件的元数据信息，包括容器格式、音视频流的具体参数等。
  4. **ffplay**：轻量级的媒体播放器，主要用于快速测试FFmpeg编码或解码的效果。

- FFmpeg 项目拥有高度可移植性，可以在 Linux、Windows、Mac OS X 及其他多种操作系统环境下编译运行。其内部的 libavcodec 库包含了大量的音频视频编解码器实现，其中许多是从零开始开发的，旨在提供高效、高质量的编解码能力。

- FFmpeg 使用 LGPL 或 GPL 许可证，这意味着它是自由软件，允许用户自由下载、使用、修改和分发代码。由于其广泛的功能和灵活性，FFmpeg 在多媒体开发领域被广泛应用，是许多视频编辑软件、流媒体服务、网络传输工具背后的基石技术之一。

### 特点

- 强大,免费,灵活,无广告
- 命令行操作

### 下载

- [Download FFmpeg](https://ffmpeg.org/download.html#build-windows)

- windows版本:[Builds - CODEX FFMPEG @ gyan.dev](https://www.gyan.dev/ffmpeg/builds/),提供了多个版本,点击文件名直接下载即可(可能没有提供单独的下载按钮)

  - 可执行文件

    ```
    PS>ls
    
            Directory: C:\exes\ffmpeg\bin
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         2/29/2024   6:06 PM       84847616 󰣆  ffmpeg.exe
    -a---         2/29/2024   6:06 PM       84639744 󰣆  ffplay.exe
    -a---         2/29/2024   6:06 PM       84680704 󰣆  ffprobe.exe
    ```

    

- 其他版本下载比较直接

## 使用

- 如果只是偶尔用用简单的功能,可以借助**[大模型](https://tongyi.aliyun.com/qianwen/)**来使用,比如我们要合并一个视频和音频,如果不想查看文档,可以用大模型搜一下,看看例子就行,总体来说还算方便,不需要下载一个软件,也不需要安装就能够运行(顶多配置以下路径,或者把需要处理的文件拖到ffmpeg所在目录下进行操作)
- 事实上,命令行工具的使用,现阶段大模型可以直接给出教程,复制粘贴,稍微修改一下就能用,但是图形界面的软件使用,大模型给出的结果往往有偏差,并且难以给出图文教程
- ffmpeg主要是命令行的形式的,这意味着我们可以编制脚本做批处理,或者嵌入到其他应用中,是比图形界面灵活的
- 其他的软件有的插入广告啊,教程里也有广告烦得很,找到一个好用的还不容易

### 将视频和音频合并

- 相关软件很多,比如VLC等,这里用ffmpeg

- 假设我从某处下载了音视频分离的资源,可以使用ffmpeg合并它们

- 使用FFmpeg合并音频和视频，你可以根据不同的需求和场景采用不同方法。这里提供一种基本的无损合并方法，前提条件是音频和视频流已经同步并且具有兼容的参数（如帧率、分辨率、采样率等）。

- 假设你有一个视频文件 `input_video.mp4` 和一个音频文件 `input_audio.mp3`，你想将音频替换到视频文件中，同时保持视频部分不变，可以这样做：

  ```bash
  ffmpeg -i input_video.mp4 -i input_audio.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output.mp4
  ```

  这个命令的意思是：
  - `-i input_video.mp4` 和 `-i input_audio.mp3` 分别指定输入的视频和音频文件。
  - `-c:v copy` 表示视频流直接复制（无损），不进行转码。
  - `-c:a aac` 指定输出音频流编码为AAC（如果目标容器支持aac，且原mp3音频需要被转码以适应容器要求）。
  - `-map 0:v:0` 选取第一个输入文件的第一个视频流。
  - `-map 1:a:0` 选取第二个输入文件的第一个音频流。
  - `output.mp4` 是合并后输出的文件名。


#### 实操

- 假设我的视频都是下载Downloads目录,并且分别命名为了`k.mp3,k.mp4`

- powershell脚本

  - ```powershell
    cd "$home\Downloads"
    ffmpeg -i k.mp4 -i k.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output.mp4
    ```

    

- ```bash
  PS BAT [11:37:09 AM] [C:\Users\cxxu\Downloads]
  [🔋 102%] MEM:71.01% [5.57/7.85] GB |ls
  
          Directory: C:\Users\cxxu\Downloads
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  d----         2/28/2024   8:58 PM                  Documents
  d----          3/4/2024  11:20 AM                  ffmpeg-2024-02-29-git-4a134eb14a-essentials_build
  -a---          3/4/2024  11:06 AM       32204639   DownKyi-1.6.1.zip
  -a---          3/4/2024  11:19 AM       27260421   ffmpeg-2024-02-29-git-4a134eb14a-essentials_build.7z
  -a---          3/4/2024  11:16 AM        1379060   kk.mp3
  -a---          3/4/2024  10:56 AM        4960232   kk.mp4
  -a---          3/4/2024  11:25 AM        7739933   output.mp4
  
  PS BAT [11:37:21 AM] [C:\Users\cxxu\Downloads]
  [🔋 102%] MEM:72.27% [5.67/7.85] GB |ffmpeg -i k.mp4 -i k.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output2.mp4
  ffmpeg version 2024-02-29-git-4a134eb14a-essentials_build-www.gyan.dev Copyright (c) 2000-2024 the FFmpeg developers
    built with gcc 13.2.0 (Rev5, Built by MSYS2 project)
    configuration: --enable-gpl --enable-version3 --enable-static --pkg-config=pkgconf --disable-
    
    ..........
    
    libavfilter     9. 17.100 /  9. 17.100
    libswscale      7.  6.100 /  7.  6.100
    libswresample   4. 13.100 /  4. 13.100
    libpostproc    57.  4.100 / 57.  4.100
  Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'kk.mp4':
    Metadata:
      major_brand     : iso5
      minor_version   : 1
      compatible_brands: iso5dsmsmsixdash
      encoder         : Lavf58.29.100
      description     : Packed by Bilibili XCoder v2.0.2
    Duration: 00:02:44.03, start: 0.000000, bitrate: 241 kb/s
    Stream #0:0[0x1](und): Video: hevc (Main) (hev1 / 0x31766568), yuv420p(tv, bt709), 640x360 [SAR 1:1 DAR 16:9], 6 kb/s, 29.97 fps, 29.97 tbr, 16k tbn (default)
        Metadata:
          handler_name    : VideoHandler
          vendor_id       : [0][0][0][0]
  Input #1, mov,mp4,m4a,3gp,3g2,mj2, from 'kk.mp3':
    Metadata:
      major_brand     : iso5
      minor_version   : 1
      compatible_brands: avc1iso5dsmsmsixdash
      encoder         : Lavf57.71.100
      description     : Packed by Bilibili XCoder v2.0.2
    Duration: 00:02:44.05, start: 0.000000, bitrate: 67 kb/s
    Stream #1:0[0x2](und): Audio: aac (LC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 2 kb/s (default)
        Metadata:
          handler_name    : SoundHandler
          vendor_id       : [0][0][0][0]
  Stream mapping:
    Stream #0:0 -> #0:0 (copy)
    Stream #1:0 -> #0:1 (aac (native) -> aac (native))
  Press [q] to stop, [?] for help
  Output #0, mp4, to 'output2.mp4':
    Metadata:
      major_brand     : iso5
      minor_version   : 1
      compatible_brands: iso5dsmsmsixdash
      description     : Packed by Bilibili XCoder v2.0.2
      encoder         : Lavf60.22.101
    Stream #0:0(und): Video: hevc (Main) (hev1 / 0x31766568), yuv420p(tv, bt709), 640x360 [SAR 1:1 DAR 16:9], q=2-31, 6 kb/s, 29.97 fps, 29.97 tbr, 16k tbn (default)
        Metadata:
          handler_name    : VideoHandler
          vendor_id       : [0][0][0][0]
    Stream #0:1(und): Audio: aac (LC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 128 kb/s (default)
        Metadata:
          handler_name    : SoundHandler
          vendor_id       : [0][0][0][0]
          encoder         : Lavc60.40.100 aac
  [out#0/mp4 @ 0000024831eaa980] video:4782KiB audio:2573KiB subtitle:0KiB other streams:0KiB global headers:0KiB muxing overhead: 2.767128%
  size=    7559KiB time=00:02:43.89 bitrate= 377.8kbits/s speed=58.8x
  [aac @ 0000024831f7d540] Qavg: 621.202
  ```

  

### 视频倍速处理

- 现在很多播放器都有倍速播放的功能

- 但是如果播放环境受限(播放功能受限,只能原速播放视频,比如嵌入在ppt中的视频)，则可以考虑将视频的倍速处理

  - 假设原来的视频有$x$分钟,我希望将其处理为$0.5x$分钟
  - 比如,在不支持倍速播放的播放器上播放处理后的视频有一个倍速的效果
  - 这种类型的任务计算量比较大,因此往往需要等待一定的时间

- 我们以2倍速为例,利用ffmpeg来处理原视频

- 如果你要在FFmpeg中将视频的播放速度调整为二倍速（即正常速度的两倍），可以通过 `-vf` 或 `-filter_complex` 参数设置视频过滤器来更改视频帧率，并通过 `-af` 或 `-filter_complex` 设置音频过滤器来加快音频播放速度。

- 下面是一个简单命令示例：

  ```sh
  ffmpeg -i input.mp4 -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2.0[a]" -map "[v]" -map "[a]" output.mp4
  ```

- 在这个命令中：
  - `-i input.mp4` 指定输入视频文件。
  - `[0:v]setpts=0.5*PTS[v]` 是对视频流应用过滤器，将每帧的时间戳减半，从而达到两倍播放速度的效果。
  - `[0:a]atempo=2.0[a]` 是对音频流应用过滤器，将音频速度提高到原来的两倍。
  - `-map "[v]" -map "[a]"` 分别指定输出包含经过处理的视频流和音频流。
  - `output.mp4` 是处理后输出的视频文件名。

  执行这个命令后，输出的`output.mp4`视频将是以二倍速播放的。同时需要注意的是，由于提高了播放速度，视频的总时长会被相应地缩短。







