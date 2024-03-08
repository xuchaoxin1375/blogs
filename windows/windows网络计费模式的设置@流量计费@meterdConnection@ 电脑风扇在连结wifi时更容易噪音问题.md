[toc]





## 按流量计费网络设置

- windows metered connection:[Metered connections in Windows - Microsoft Support](https://support.microsoft.com/en-us/windows/metered-connections-in-windows-7b33928f-a144-b265-97b6-f2e95a87c408)

- 打开所连接的网络进行设置,开启`metered connection`开关
  - 或者在浏览器中点击[Open Wi-Fi settings](ms-settings:network-wifi?activationSource=SMC-IA-4028458)跳转到系统设置wi-fi
  - 或者浏览器中输入`ms-settings:network-wifi?activationSource=SMC-IA-4028458`跳转

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/b02721054e7048b78bcee724db441bdd.png)

## 流量计费模式下的好处

- 即便流量无限或者免费使用wifi,仍然建议开启流量计费模式

### 电脑风扇在连结wifi时更容易噪音问题

- 软件更新进程容易占用大量计算资源的进程,造成电脑风扇尝试时间高速旋转(安装大型软件不仅读写磁盘而且消耗算力)
- 可以尝试打开计费开关,假装当前流量要计费,这样可以减少一些不必要的进程占用资源,自然减少计算机的风扇噪音

### 限制软件和系统自动更新行为

- 在有wifi(不计流量费时),windows计算机可能更容易启动**更新检查**,包括
  - office套件
  - edge浏览器
  - windows系统更新

- 这不是一个一劳永逸的可靠的限制更新方法,因为当你的计算机切换到其他网络环境,计费模式会自动关闭,导致自动更新的进程会运行,即便我们可以再次设置计费模式
- 通常需要配置windows策略组来关闭或阻止自动更新

### 例:edge不再自动更新

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/79908ac544164f4ba1dce6af66786b5d.png)

