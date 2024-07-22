[toc]



## abstract

习惯使用命令行的小伙伴应该知道桌面上如果东西很多的话,找到一个软件并打开并不快捷,尤其是软件安装了很多的情况下

这种情况下我们可能会打开开始菜单,然后搜索软件的名字希望能够找到软件启动入口

但这种方法不总是那么可靠,有时候搜不到它,或者软件的安装名字和我们称呼的名字有较大不同

我们可以考虑用everything这类工具查找到目标软件,然后固定到开始菜单上

然而开始菜单中的软件可能会随着时间的推移越来越多,便捷性也越来越低

幸运的是,固定到开始菜单后,我们结合利用开始菜单的搜索功能搜索软件的名字也挺方便的,成功率比不固定到开始菜单直接搜软件名字要好使

此外,还可以配置命令行启动,可以更加通用的快启动特定的软件

## 命令行直接按名字启动开始菜单中固定的应用程序

这里通过修改两个环境变量来实现:`Path`和`PathExt`

打开powershell,执行以下命令行

```powershell
$Start_Menu_Programs_User  =  "$home\AppData\Roaming\Microsoft\windows\Start Menu\programs"

write-host $Start_Menu_Programs_User  

```

复制得到的路径,例如`C:\Users\cxxu\AppData\Roaming\Microsoft\windows\Start Menu\programs`

再打开环境变量编辑窗口(开始菜单中搜索`Path`或者命令行中输入`systempropertiesadvanced.exe`打开)

找到其中的`Path`变量编辑,追加刚才复制的路径

再找到`PATHEXT`变量编辑,追加`.Lnk`

保存修改后关闭窗口,关闭所有命令行窗口

现在可以尝试在命令行中输入开始菜单中有的

### 查看修改后的变量

- 可以打开环境变量窗口对比一下(下面的命令行是我自定义的,powershell不自带这些命令)

```powershell
PS [C:\Users\cxxu\Desktop]> Get-EnvVar path -Scope U -Count
1     C:\Users\cxxu\AppData\Roaming\Microsoft\windows\Start Menu\programs
2     C:\repos\configs\Shortcuts\
3     C:\exes\PCMaster
4     C:\exes\platform-tools
...

PS [C:\Users\cxxu\Desktop]> Get-EnvVar pathext

Number Scope  Name    Value
------ -----  ----    -----
     1 Combin PATHEXT .COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.PY;.PYW;.Lnk;.CPL
```

### FAQ

- 有些类型的应用即使固定到开始菜单(比如uwp应用,系统自带的应用(如照片),名字含有空格的应用,如TO DO),无法通过此方法直接在命令行打开
- 这时考虑直接用开始菜单的搜索功能
- 或者利用命令行创建可执行程序的别名,并加入的`$profile`中(对于powershell)
- 或者创建快捷方式,然后对快捷方式编辑合适的名字使其适合于快速启动,然后固定快捷方式到开始菜单,从兼容本方法实现快速启动

### 用例



```powershell
PS [C:\Users\cxxu\Desktop]> Word.lnk
```

- 这会打开office word软件
- 此外,通过`win+r`打开的运行窗口中输入`word`也会直接打开word软件
- 这个体验就像是可以直接利用`notepad`打开记事本一样简单