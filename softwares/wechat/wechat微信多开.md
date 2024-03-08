[toc]



## 脚本方法多开微信

- 这里的方法有一定的局限性,并不是完美的方案

### powershell方法

- 适用于带有powershell的windows系统,比如win10以及之后的系统,如果经常用,可以配置为powershell模块函数

- ```powershell
  
  function wechat_multiple
  {
      <# 
      .SYNOPSIS
      模拟短时间内点击多次微信弹出多个登录窗口
      如果报错,则可能是微信安装路径出错,请检查微信安装路径
  
      说明:本程序会判断是否已经有微信进程,如果没有微信进程,则直接打开多个登录窗口
      否则会询问用户是否关闭所有微信进程,以便于多开微信
      (因为这里采用的方法要求在没有微信进程的情况下运行才能生效;在未来,微信可能自带支持多开功能,就像多开qq一样方便)
      但是中所周知,微信团队比qq团队要懒,很多地方没有做好,功能比较受限,可能相当长的时间微信不会主动支持多开
      
      .EXAMPLE
      PS C:\repos\scripts> wechat_multiple -multiple_number 2
          wechat is running,stop all wechat process to start multiple wechat?
          Enter 'y' to continue😎('N' to exit the process!)  : y
  
      PS C:\Program Files\Typora> wechat_multiple
      2 wechat login process were started!😊
      #>
  
      param(
  
          # 配置为自己的微信安装目录即可(注意末尾WeChat是目录)
          $wechat_home = 'C:\Program Files\Tencent\WeChat' ,
          # 可以自行指定多开数量
          $multiple_number = 2
      )
  
      if (Get-Process | Select-String wechat)
      {
          # 读取键盘输入(read input by read-host)
          $Inquery = Read-Host -Prompt "wechat is running,stop all wechat process to start multiple wechat? `n Enter 'y' to continue😎('N' to exit the process!)  "
          if ($Inquery -eq 'y')
          {
              # 关闭微信进程,以便多开微信
              Get-Process wechat | Stop-Process        
          }
          else
          {
              Write-Output 'operation canceled!'
              return
          }
      }
      # 程序的主体部分
      foreach ($i in 1..$multiple_number)
      {
          Start-Process $wechat_home\wechat.exe
      }
  
      Write-Output "$multiple_number wechat login processes were started!😊"
  }
  
  ```

#### 简化版本(核心部分)

- ```powershell
  # 程序的主体部分
  # 配置为自己的微信安装目录即可(注意末尾WeChat是目录)
  $wechat_home = 'C:\Program Files\Tencent\WeChat' 
          
  foreach ($i in 1..$multiple_number)
  {
      Start-Process $wechat_home\wechat.exe
  }
  ```

### bat脚本

- 对于老系统也适用

  - ```powershell
    @echo off
    setlocal enabledelayedexpansion
    
    for /L %%i in (1,1,3) do (
        start "" "C:\Program Files\Tencent\WeChat\WeChat.exe"
    )
    
    exit
    ```

  - 这里的3是多开数量

### 将脚本作为快捷方式启动(暴力多开)

- 直接关闭所有微信进程,然后打开2个微信(将2改为其他更大的整数会多开相应数量的登录窗口( 重叠在一起))

  ```bat
  @echo off
  setlocal enabledelayedexpansion
  
  taskkill /f /im wechat.exe
  for /L %%i in (1,1,2) do (
      start "" "C:\Program Files\Tencent\WeChat\WeChat.exe"
  )
  
  exit
  ```

- 桌面上新建一个文本文件,将上述内容粘贴进去,最后重命名为`multiple_wechat.bat`

  - 如果文件扩展名不可见,在资源管理器设置查看为**显示文件扩展名**(取消隐藏)

- 可以放在桌面,之后可以双击启动

## 效果

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/b383c57eb2d14e0bb78978b3003c91e8.png)

## 使用沙盒

- 这是一个推荐的方法:[利用沙盒多开微信](https://blog.csdn.net/xuchaoxin1375/article/details/136180393)
- 完全掌握沙盒的用法和细节可能比较花时间,但是掌握多开是简单事情

## 其他方法

- 配合键盘和鼠标的方法快速点击微信图标等方法
- 下载uwp版本的微信,可以共存桌面版微信
- 用虚拟机安装微信(比较不方便)
- refs:[电脑版微信如何多开？6个方法轻松实现  (zhihu.com)](https://zhuanlan.zhihu.com/p/615719340)



