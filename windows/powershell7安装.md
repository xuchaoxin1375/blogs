[toc]



# powershell7

##  安装

### windows 应用商店安装

- 可以通过windows应用商店安装
  - 但是我不推荐
  - 会安装在个人用户目录中
  - 不利于多用户共享！
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210630070820601.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

#### 安装后所在目录(样式)

- `C:\Users\<your userame>\AppData\Local\Microsoft\WindowsApps\Microsoft.PowerShell_8wekyb3d8bbwe\pwsh.exe`

##  通过msi安装包安装😊

- 目前我采用此方式,比较符合我的管理习惯
- 推荐使用安装版:

- [Installing PowerShell on Windows - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2#msi)

##  配置样式默认值

- <img src="https://img-blog.csdnimg.cn/20210630071030496.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70" alt="在这里插入图片描述" style="zoom:50%;" />



## 乱码问题😊

- [vscode/windows terminal_oh my posh(基于pwsh字体乱码问题修复)](https://blog.csdn.net/xuchaoxin1375/article/details/118269272)

- 具体可以通过命令help posh 查看详情
  - （列举出可用地相关命令）![](https://img-blog.csdnimg.cn/20210102234637381.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  查看当前pwsh安装路径

- `$psHome`

- ```powershell
  PS C:\Users\cxxu> $PSHOME
  C:\Program Files\PowerShell\7
  ```

  

## terminal推荐

- powershell自带的窗口太过于简陋
- 在windwos端，推荐使用windows terminal
  - [Windows Terminal installation | Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/install)

