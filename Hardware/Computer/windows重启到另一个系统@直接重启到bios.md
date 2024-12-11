[toc]

## abstract

本文介绍从windows系统重启到BIOS和安装在其他盘符的系统的方法(一次性或临时切换系统)

其实重启到其他系统和BIOS有常规办法,前者可以到`msconfig`中设置默认启动系统项,但是不够方便,因为下次可能还要改回来,除非你确实想要替换默认启动项

而重启BIOS不同机器主板可能有不同的进入方法,一般是趁开机时快速连续按下某个(组合)键,如果能从windows直接重启到BIOS,就会方便许多

或者使用功能类似的更完整的第三方软件(EasyBCD家族工具)

- [Download iReboot - NeoSmart Technologies](https://neosmart.net/iReboot/?utm_source=EasyBCD&utm_medium=software&utm_campaign=EasyBCD iReboot)

### 重启到BIOS

windows重启到BIOS命令`shutdown /r /fw /t 0` 是一个在 Windows 操作系统中用于重新启动计算机并打开固件（通常是 BIOS/UEFI 界面）选项的命令。

### 解释

- `shutdown`：这是用于关闭或重新启动计算机的命令。
- `/r`：表示重新启动（reboot）。当执行该命令时，系统会重新启动，而不是仅关闭。
- `/fw`：指示在重新启动时访问固件（通常是 BIOS 或 UEFI 设置界面）。这个选项会在下一次重启时，自动进入固件设置，而无需用户在启动时手动按下特定按键（例如 F2、Delete 或 Esc）。

### 典型使用场景
这个命令通常用于需要调整 BIOS 或 UEFI 设置的情况。通过该命令，用户可以节省在启动过程中手动按键进入设置的时间，尤其在需要反复调整固件选项的情况下，显得更为便利。

### 示例
如果你在命令行中输入以下命令：
```bash
shutdown /r /fw /t 0 #立即重启
```
系统会关闭所有正在运行的应用并保存设置，然后重启，并在重启时自动进入 BIOS/UEFI 界面，用户可以对系统配置进行修改。

## 重启到另一个系统

使用powershell启动到指定系统

有powershell5以上就能运行,win10之后系统测试通过,win7可能要安装最新补丁运行powershell5以上

功能预览

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/dd09076657664028a3186b898aff70a7.png)

### 注意选项

- 第一个选项是Boot Manager,这个选项不一定管用,重启后可能会提示你丢失文件,这时候选择重启到已安装系统中或进入到BIOS
  - Enter键选择进入已安装系统
  - ESC键进入到BIOS

## 获取软件代码

运行此窗口十分简单,打开powershell,复制粘贴以下命令行回车执行即可

### 在线一键启动选择窗口👺

```powershell
 irm https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Tools/Tools.psm1 |iex #代码下载到本地
 rebootToOS #打开重启到另一个系统的选择窗口
 
```

推荐使用这个方式运行,可以将其做成快捷方式,下次就可以双击运行了

### 保存为桌面脚本/快捷方式👺

打开powershell,复制粘贴执行以下内容

```powershell
$p="$home\desktop\rebootToOS.bat" #可以根据需要修该保存目录(或者默认保存到桌面后,再移动到你想要的地方)
@"
powershell -noprofile -nologo -c "Invoke-RestMethod https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Tools/Tools.psm1 | Invoke-Expression ;rebootToOS "
pause

"@ > $p
. $p

```

保存为cmd(.bat)文件到桌面,下次双击会通过cmd调用powershell下载代码(一瞬间)打开重启系统选择窗口

这里之所以保存为`.bat`是powershell脚本文件`.ps1`启动时有安全策略问题,保存为`.bat`更方便



### 离线版本

将以下代码粘贴到powershell中回车执行(老版本,可以离线粘贴运行,代码会更新)

```powershell
function Get-BootEntries
{
    
    chcp 437 >$null; cmd /c bcdedit | Write-Output | Out-String -OutVariable bootEntries *> $null


    # 使用正则表达式提取identifier和description
    $regex = "identifier\s+(\{[^\}]+\})|\bdevice\s+(.+)|description\s+(.+)"
    $matches = [regex]::Matches($bootEntries, $regex)
    # $matches


    $entries = @()
    $ids = @()
    $devices = @()
    $descriptions = @()
    foreach ($match in $matches)
    {
        $identifier = $match.Groups[1].Value
        $device = $match.Groups[2].Value
        $description = $match.Groups[3].Value

        if ($identifier  )
        {
            $ids += $identifier
        }
        if ($device)
        {
            $devices += $device
        }
        if ( $description )
        {
            $descriptions += $description
        }

    }
    foreach ($id in $ids)
    {
        $entries += [PSCustomObject]@{
            Identifier  = $id
            device      = $devices[$ids.IndexOf($id)]
            Description = $descriptions[$ids.IndexOf($id)]
        }
    }

    Write-Output $entries
}
function Get-WindowsVersionInfoOnDrive
{
    <# 
    .SYNOPSIS
    查询安装在指定盘符的Windows版本信息,默认查询D盘上的windows系统版本

    .EXAMPLE
    $driver = "D"
    $versionInfo = Get-WindowsVersionInfo -Driver $driver

    # 输出版本信息
    $versionInfo | Format-List

    #>
    param (
        # [Parameter(Mandatory = $true)]
        [string]$Driver = "D"
    )

    # 确保盘符格式正确
    if (-not $Driver.EndsWith(":"))
    {
        $Driver += ":"
    }

    try
    {
        # 加载指定盘符的注册表
        reg load HKLM\TempHive "$Driver\Windows\System32\config\SOFTWARE" | Out-Null

        # 获取Windows版本信息
        $osInfo = Get-ItemProperty -Path 'HKLM:\TempHive\Microsoft\Windows NT\CurrentVersion'

        # 创建一个对象保存版本信息
        $versionInfo = [PSCustomObject]@{
            WindowsVersion = $osInfo.ProductName
            OSVersion      = $osInfo.DisplayVersion
            BuildNumber    = $osInfo.CurrentBuild
            UBR            = $osInfo.UBR
            LUVersion      = $osInfo.ReleaseId
        }

        # 卸载注册表
        reg unload HKLM\TempHive | Out-Null

        # 返回版本信息
        return $versionInfo
    }
    catch
    {
        Write-Error "无法加载注册表或获取信息，请确保指定的盘符是有效的Windows安装盘符。"
    }
}

function rebootToOS
{
    Add-Type -AssemblyName PresentationFramework
    $bootEntries = Get-BootEntries
    $bootEntries = $bootEntries | ForEach-Object {
        [PSCustomObject]@{
            Identifier  = $_.Identifier
            Description = $_.Description + $_.device + "`n$($_.Identifier)" 
        } }
    # 定义启动项
    # $bootEntries = @(
    #     [PSCustomObject]@{Identifier = '{bootmgr}'; Description = 'Windows Boot Manager' },
    #     [PSCustomObject]@{Identifier = '{current}'; Description = 'Windows 10' },
    #     [PSCustomObject]@{Identifier = '{b794f931-144f-11ef-bbb1-dcfb484e80bc}'; Description = 'Windows 10' }
    # )

    # 创建窗口

    [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Choose Boot Entry" Height="600" Width="450" WindowStartupLocation="CenterScreen"
        Background="White" AllowsTransparency="False" WindowStyle="SingleBorderWindow">
    <Grid>
        <Border Background="White" CornerRadius="10" BorderBrush="Gray" BorderThickness="1" Padding="10">
            <StackPanel>
                <TextBlock Text="Select a system to reboot into:" Margin="10" FontWeight="Bold" FontSize="14"/>
                <ListBox Name="BootEntryList" Margin="10" Background="LightBlue" BorderThickness="0">
                    <ListBox.ItemTemplate>
                        <DataTemplate>
                            <Border Background="LightGray" CornerRadius="10" Padding="5" Margin="5">
                                <TextBlock Text="{Binding Description}" Margin="5,0,0,0"/>
                            </Border>
                        </DataTemplate>
                    </ListBox.ItemTemplate>
                </ListBox>
                <Button Name="RebootButton" Content="Reboot" Margin="10" HorizontalAlignment="Center" Width="100" Background="#FF2A2A" Foreground="White" FontWeight="Bold" Cursor="Hand">
                    <Button.Style>
                        <Style TargetType="Button">
                            <Setter Property="Background" Value="#FF2A2A"/>
                            <Setter Property="Foreground" Value="White"/>
                            <Setter Property="FontWeight" Value="Bold"/>
                            <Setter Property="Cursor" Value="Hand"/>
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#FF5555"/>
                                </Trigger>
                            </Style.Triggers>
                        </Style>
                    </Button.Style>
                </Button>
            </StackPanel>
        </Border>
    </Grid>
</Window>
"@

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)

    # 获取控件
    $listBox = $window.FindName("BootEntryList")
    $button = $window.FindName("RebootButton")

    # 填充ListBox
    $listBox.ItemsSource = $bootEntries

    # 定义按钮点击事件
    $button.Add_Click({
            $selectedEntry = $listBox.SelectedItem
            if ($null -ne $selectedEntry)
            {
                $identifier = $selectedEntry.Identifier
                Write-Output "Rebooting to: $($selectedEntry.Description) with Identifier $identifier"
                # 调用重启命令 (此处只是示例，实际环境中请谨慎操作)
                # shutdown.exe /r /t 0 /fw /f /d p:4:1 /c "Reboot to $identifier"
                cmd /c bcdedit /bootsequence $identifier 
                Write-Host "rebooting to $($selectedEntry.Description) after 3 seconds!(close the shell to stop/cancel it)"
                Start-Sleep 3
                shutdown.exe /r /t 0
            }
            else
            {
                [System.Windows.MessageBox]::Show("Please select an entry to reboot into.", "No Entry Selected", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
            }
        })

    # 显示窗口
    $window.ShowDialog()

}
rebootToOS 
```

### 其他命令

当然,这里还一并提供了查看当前计算机已经安装了哪些系统的函数

```powershell
Get-BootEntries|ft -autosize -wrap
```

以及查看指定盘符上安装的windows的版本信息

```powershell
Get-WindowsVersionInfoOnDrive #默认查案D盘,可以指定盘符为E,F,...(不能也没必要是C,当前系统可以直接通过winver命令查看)
```

```powershell
#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][22:56:51][UP:0.04Days]
PS> Get-WindowsVersionInfoOnDrive D

WindowsVersion : Windows 10 Pro for Workstations
OSVersion      : 22H2
BuildNumber    : 19045
UBR            : 4651
LUVersion      : 2009


#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][22:56:57][UP:0.04Days]
PS> Get-BootEntries |ft -Wrap

Identifier                             device                             Description
----------                             ------                             -----------
{bootmgr}                              partition=\Device\HarddiskVolume1  Windows Boot Manager
{current}                              partition=C:                       Windows 10
{b794f931-144f-11ef-bbb1-dcfb484e80bc} partition=D:                       Windows 10
```



### 手动操作

在powershell执行的话,需要对`{}`外加`' '`单引号对包裹

```bash

#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][21:49:21][UP:0.03Days]
PS> cmd /c bcdedit /bootsequence '{b794f931-144f-11ef-bbb1-dcfb484e80bc}'
操作成功完成。

#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][21:49:23][UP:0.03Days]
PS> cmd /c bcdedit /bootsequence '{current}'
操作成功完成。
```

注意,需要用`{}`来包为`identifier`,否则命令行无法识别

```bash
#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][21:49:15][UP:0.03Days]
PS> cmd /c bcdedit /bootsequence 'b794f931-144f-11ef-bbb1-dcfb484e80bc'
按规定项列表数据无效。
运行 "bcdedit /?" 获得命令行帮助。
参数错误。
```

