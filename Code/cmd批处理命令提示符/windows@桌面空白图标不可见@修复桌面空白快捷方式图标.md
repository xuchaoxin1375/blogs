[toc]

## abstract

- [How can I execute a Windows command line in background? - Super User](https://superuser.com/questions/198525/how-can-i-execute-a-windows-command-line-in-background)
- [stbrenner/SilentCMD: SilentCMD executes a batch file without opening the command prompt window. (github.com)](https://github.com/stbrenner/SilentCMD)

## 桌面图标不可见

windows桌面提供了图标隐藏功能,如果不小心在桌面右键并且不巧点击到显示桌面图标(默认是勾选的,点击后取消勾选,桌面将是一片空白)

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/f113d38b56a94d1289ebcf41282e221d.png)

这种不是系统故障,而是无意间触发不需要的开关,比如擦拭鼠标的时候就可能发生



## 修复快捷方式图标空白问题

- [How to Fix Blank White Desktop Shortcut Icons in Windows 10 , 11 (thegeekpage.com)](https://thegeekpage.com/how-to-fix-the-white-blank-shortcut-icons-from-the-desktop-in-windows-10-easily/#Fix_1_Delete_the_Icon_Cache)


### 逐个修复

- 右键有问题的图标,找到图标绑定的软件(及其所在位置),打开对应位置,`右键->新建快捷方式`
- 局限性:
  - 只能逐个修复
  - 如果快捷方式绑定的时指令而不是单纯的路径,修复起来会更加繁琐

### 批量修复

- 逐步操作不够方便,这里我提供一下命令行操作:powershell快速修复的脚本:


#### 一次性操作:

- ```powershell
  function fix_shortcuts_icon
  {
      
      $icon_cache_db = "$env:USERPROFILE\appdata\local\IconCache.db"
      if (Test-Path $icon_cache_db)
      {
          # Set-Location $env:USERPROFILE\appdata\local
          Remove-Item $icon_cache_db -Force
          # restartExplorer
          Stop-Process -Name explorer
          Write-Output "operation done!"
  
      }
      else
      {
          Write-Output "fix operation passed!`n there is no file@{$icon_cache_db}!"
      }
  }
  ```

- 为了方便小白用户可以一键操作,提供以下脚本

  ```powershell
  
  @'
  function fix_shortcuts_icon
  {
      
      $icon_cache_db = "$env:USERPROFILE\appdata\local\IconCache.db"
      if (Test-Path $icon_cache_db)
      {
          # Set-Location $env:USERPROFILE\appdata\local
          Remove-Item $icon_cache_db -Force
          # restartExplorer
          Stop-Process -Name explorer
          Write-Output "operation done!"
  
      }
      else
      {
          Write-Output "fix operation passed!`n there is no file@{$icon_cache_db}!"
      }
  }
  fix_shortcuts_icon
  
  '@>fix_shortcuts_icon.ps1;
  ./fix_shortcuts_icon.ps1
  
  
  ```

  - 请完整复制这段述代码,打开powershell,粘贴到命令行窗口粘贴回车执行
    - 打开powershell的方式很多,可以打开windows开始菜单,搜索`powershell`
    - 或者在任意界面按下`win+R`输入`pwsh`回车启动窗口

#### 逐步操作

- ```powershell
  #进入到指定目录
  PS C:\Users\cxxu\AppData\Roaming> cd $env:USERPROFILE\appdata\local
  # 删除
  PS C:\Users\cxxu\AppData\Local> rm .\IconCache.db -Force
  PS C:\Users\cxxu\AppData\Local> restartExplorer
  ```

### 执行效果

- 由于操作包含重启资源管理器的操作,您的桌面可能会闪一下(耗时几秒钟完成)

### 第三方工具修复

- 软媒魔方
- ...

