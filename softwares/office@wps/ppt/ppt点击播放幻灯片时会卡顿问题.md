[toc]

## abstract

- 遇到ppt点击播放幻灯片时会卡顿问题的人不止我一个
  - 先说结论:如果修改了开机启动的服务项,可能会导致部分体验异常,打开`msconfig`(system configuration),将启动设置为普通启动
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/a6a94f78aa0d4f6cbdba68e6a9e1fa5c.png)

- 设置完后重启系统

### refs

- [Office2016的PPT放映幻灯片放映卡死解决方法](https://blog.csdn.net/jiangjiang_jian/article/details/102504498)
- [PPT放映时点击放映会卡顿 - Microsoft Community](https://answers.microsoft.com/zh-hans/msoffice/forum/all/ppt放映时点击/31fed3a3-d855-4380-9866-9368527ade28)

### preface

- 不是电脑性能问题,因为这个问题是某一天突然出现的
  - 在这之前我更新了一下Intel核显驱动
  - 用的是Intel官方的[英特尔® 驱动程序和支持助理安装程序 (intel.cn)](https://www.intel.cn/content/www/cn/zh/support/detect.html);英文简称为DSA(Intel® Driver & Support Assistant (Intel® DSA))
  - 这个软件会扫描本地主机的硬件,然后在浏览器中显示出来,包括电脑厂商,cpu,内存和硬盘都有
  - 然后列出intel 处理器相关驱动有哪些可以更新的项目
- 我根据提示更新了核显驱动(提示OEM厂商提供了修改过的驱动,不要轻易更新通用驱动)
  - 但是我还是选择更新,下载下来安装后还给我安装了Arc Iris[Intel® Arc™ & Iris® Xe Graphics - Windows*](https://www.intel.com/content/www/us/en/download/785597/intel-arc-iris-xe-graphics-windows.html)控制面板
- 上面提到的两个软件都是默认开机自启,而且DSA难以关闭自启;Arc可以任务管理器中关闭开机自启
  - 我自然地选择关闭Arc开机自启

- 然而重启后发现我点击ppt播放按钮会卡几秒钟

## solution

- 猜测大概是先看新驱动带来了问题,或者在Arc中做了不当的设置导致的
  - 我启动了Arc面板,ppt播放卡顿问题就没有了
  - 而且我打开设备管理器禁用了核显,虽然分辨率发生了变化,但是播放ppt时也不再卡顿
    - 卸载核显的话还是不建议,除非有独显直连,不然屏幕许多设置都无法修改,刷新率也改不了了
    - 而且加载ppt的会慢了很多(说明核显加速是有用的)
- 然而我卸载了Arc后问题依旧
  - 于是我到OEM下载出厂驱动,(卸载了老驱动)重新安装旧驱动,问题还是没有解决
- 现在我有2种选择,下载会Arc,或者打开系统设置看看哪些选项会造成ppt播放卡顿问题
- 考虑到安装Arc是一个相对漫长的过程,我打开了设置操作了一波
  - 很可能是以下相关选项造成的,尝试将他们都关闭或者都开启试了一番,最后都开启,解决了问题
  - ![请添加图片描述](https://img-blog.csdnimg.cn/direct/91fa4ededd874cd0a23c6bc516edde45.png)
  - 这些设置和显卡加速有关
  
- 最后,打开的每一份ppt都是第一次点击播放会卡顿以下,但是后续推出播放后再播放就不会卡顿
- 如果设置过系统还原定期备份,可以尝试一下还原点还原到之前的状态

## 移除ppt中的声音👺

- 移除ppt中的声音可以缩小ppt,然后找找看有没有嵌入的音频(以一个喇叭的形式出现)
- 另一方面是文件资源管理器中的预览窗口,这个不是所有人都开着的,如果有,请暂时关闭预览窗口,因为预览窗口会缓冲ppt内容,当鼠标点中ppt后,原来ppt中的声音(如果有的话)就会播放,几遍没有完全打开ppt
- 而且由于预览窗口的缓冲,几遍你正确移除了ppt中的自动播放音频,并且保存,您还是会遇到ppt的背景音乐继续播放的情况,这时候就要到资源管理器中刷新一下

## 小结

- 最好不要轻易更新驱动,除非是OEM厂商提供的驱动更新(比如windows update中检测到的,可能会列为可选的更新项目)

  

