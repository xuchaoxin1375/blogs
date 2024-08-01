[toc]

## abstract
- windows@安全中心@windows security
- windwos defender误删文件恢复@添加信任免扫描域

## windows defender

- Windows Defender是微软推出的内置防病毒和反恶意软件工具，预装于Windows操作系统中，主要功能包括实时防护、定期扫描、云端威胁情报更新、恶意软件清除以及网络浏览保护等。
- 它专注于安静高效地保护用户的电脑免受病毒、间谍软件及其他形式恶意软件的侵害，尤其在Windows 10中，与防火墙整合并增强了安全功能，同时为企业用户提供更高级别的端点防护服务。
- Windows Defender 最初设计用于对抗间谍软件，随着时间的发展，特别是在Windows 8及后续版本中，其功能逐渐增强成为一个全面的安全解决方案，提供针对各种恶意软件（包括病毒、蠕虫、特洛伊木马等）的防护。
- Windows Defender 简称可以写作 "Defender" 或 "MS Defender"，在正式场合或文档中有时也称为 "Microsoft Defender"。随着其功能扩展到更全面的终端防护解决方案，现在常被提及为 "Microsoft Defender Antivirus" 

### 相关服务👺

- windows antimalware service executable
  - 这个服务大约会吃掉我200M内存
  - 虽然现在电脑普遍是16GB或更大内存,但是我认为该服务不仅仅会占用内存资源,还会影响使用体验,会无意间将某些被怀疑的软件或文件删除,造成困扰
- [How to Fix Antimalware Service Executable High CPU Usage on Windows (makeuseof.com)](https://www.makeuseof.com/fix-antimalware-service-executable-high-cpu-usage-on-windows-10/)

## 停用windows Defender

### 临时关闭实时防护

- 我们可以手动关闭实时防护,但是这只能暂时关闭
- 如果需要长期关闭,需要其他的进一步操作

### 使用软件工具关闭👺

#### windows defender remover

- [GitHub - ionuttbara/windows-defender-remover: A tool which is uses to remove Windows Defender in Windows 8.x, Windows 10 (every version) and Windows 11.](https://github.com/ionuttbara/windows-defender-remover)

#### defender control(慎用)

- !!!我用了这个软件后,发现其他软件启动的速度大幅度下降,安装软件更是一卡一卡的,不建议使用👺
  - 平台是windows11(intel 12700H+RTX4060)
  - 重新启用安全中心后,速度恢复正常

- 使用开源工具:[qtkite/defender-control: An open-source windows defender manager. Now you can disable windows defender permanently. (github.com)](https://github.com/qtkite/defender-control)
  - 这个工具是命令行方式运行
  - 包含了关闭和启用两个独立的程序
- 使用关闭程序(`disable-defender`)前先手动打开安全中心,关闭病毒和威胁防护的实时防护的开关
- 这可能是设置了策略组
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/92ce20637af34695b97ead7b5e2b0569.png)

#### dism++

- [Chuyu-Team/Dism-Multi-language: Dism++ Multi-language Support & BUG Report (github.com)](https://github.com/Chuyu-Team/Dism-Multi-language)

- [Chuyu Team](https://chuyu.me/en-US/index.html)
- dism++提供的系统优化中的安全设置有一个开关,功能为关闭windows defender
- 还提供了用不检查更新的功能,有效性自测

#### dControl

- [Defender Control v2.1 (sordum.org)](https://www.sordum.org/9480/defender-control-v2-1/)
  - 软件可能会报毒,毕竟它试图关闭安全中心
  - 可以从其他论坛下载,但是没必要,名字和第一个软件很像,但是这里是GUI软件

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/44cf342232dd4559bff56a7f9101b2eb.png)

#### Ultimate Windows Tweaker

- [Ultimate Windows Tweaker 5 for Windows 11 (thewindowsclub.com)](https://www.thewindowsclub.com/ultimate-windows-tweaker-5-for-windows-11)

- [Ultimate Windows Tweaker 4 for Windows 10 (thewindowsclub.com)](https://www.thewindowsclub.com/ultimate-windows-tweaker-4-windows-10)
- 软件为英文,没有语言相关设置,有的有汉化版

### 其他方法

#### 使其他杀毒软件

- 安装第三方杀毒软件后,可以关闭windows defender

#### 注册表修改

- 使用注册表的方法容易失效(随着windows的更新而失效)

  - ```bash
    PS>reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender"
    
    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager
    PS>reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1
    The operation completed successfully.
    PS>reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender"
    
    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender
        DisableAntiSpyware    REG_DWORD    0x1
    
    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager
    ```

- 使用策略组对系统版本有要求(专业版或企业版)



## 保护历史
![在这里插入图片描述](https://img-blog.csdnimg.cn/b22eeb367fdc4f7da3089b1bdc87c03a.png)
### 恢复被认为是有病毒的文件
![windows](https://img-blog.csdnimg.cn/f34566f08a4d47ad8d4bc3c8215a6cbc.png)

### 添加信任目录,文件,文件类型或进程
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a56dbfb6a2984d21af38ed5f48d18e70.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/704f946cae224893801f2110e76367a1.png)



