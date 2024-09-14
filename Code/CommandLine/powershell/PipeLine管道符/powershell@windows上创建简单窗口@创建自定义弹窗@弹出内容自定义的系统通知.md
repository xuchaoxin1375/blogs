[toc]

## abstract

- 利用powershell创建GUI弹窗或者发送系统通知



### 利用WinForms创建弹窗

- [How to Create a GUI for PowerShell Scripts – TheITBros](https://theitbros.com/powershell-gui-for-scripts/)

- [使用 PowerShell 添加面板、标签、编辑框、组合框、列表框、CheckBox 等的 GUI 窗体!! | Microsoft Learn](https://learn.microsoft.com/zh-cn/shows/gurupowershell/gui-form-using-powershell-add-panel-label-edit-box-combo-box-list-box-checkbox-more)

### 利用WPF创建一个简单弹窗

在 PowerShell 中创建一个外观较好的弹窗，并使其在显示1秒钟后自动关闭，可以使用 Windows Presentation Foundation (WPF) 来实现。

然而,以下这种简单实现问题很多,比如难以手动关闭弹窗,关闭前会阻塞当前shell会话,而且如果用`Start-job`切换到后台运行容易出现内容显示空白问题

```powershell
Add-Type -AssemblyName PresentationFramework

# 创建窗口
$window = New-Object System.Windows.Window
$window.Title = "Prompt"
$window.Width = 300
$window.Height = 200
$window.WindowStartupLocation = "CenterScreen"

# 创建文本块
$textBlock = New-Object System.Windows.Controls.TextBlock
$textBlock.Text = "这是一个弹窗提示"
$textBlock.VerticalAlignment = "Center"
$textBlock.HorizontalAlignment = "Center"
$textBlock.FontSize = 16

# 将文本块添加到窗口
$window.Content = $textBlock

# 显示窗口
$window.Show()

# 等待1秒钟
Start-Sleep -Seconds 1

# 关闭窗口
$window.Close()
```

脚本说明：

1. **加载必要的程序集**：`Add-Type -AssemblyName PresentationFramework` 加载 WPF 所需的程序集。
2. **创建窗口**：使用 `System.Windows.Window` 创建一个新窗口，并设置其标题、宽度、高度和启动位置。
3. **创建文本块**：使用 `System.Windows.Controls.TextBlock` 创建一个文本块，设置其文本内容和对齐方式。
4. **将文本块添加到窗口**：将创建的文本块添加到窗口的内容中。
5. **显示窗口**：使用 `$window.Show()` 显示窗口。
6. **等待1秒钟**：使用 `Start-Sleep -Seconds 1` 等待1秒钟。
7. **关闭窗口**：使用 `$window.Close()` 关闭窗口。

这个脚本创建了一个简单但外观较好的弹窗，并在显示1秒钟后自动关闭。你可以根据需要调整窗口和文本块的属性，例如字体大小、颜色等。

## 利用系统通知弹出通知👺



在 Windows 上，可以使用 PowerShell 脚本来弹出自定义的系统通知。

### 使用第三方模块

 `New-BurntToastNotification` Cmdlet

[GitHub - Windos/BurntToast: Module for creating and displaying Toast Notifications on Microsoft Windows 10.](https://github.com/Windos/BurntToast)

`BurntToast` 是一个 PowerShell 模块，可以用来创建和显示自定义的 Windows 通知。首先需要安装并导入这个模块。

#### 安装 BurntToast 模块

1. 打开 PowerShell，以管理员身份运行。
2. 运行以下命令安装 `BurntToast` 模块：

```powershell
Install-Module -Name BurntToast -Force -Scope CurrentUser
```

3. 导入模块：

```powershell
Import-Module BurntToast
```

#### 创建和显示通知

使用 `New-BurntToastNotification` cmdlet 创建和显示自定义通知。例如：

```powershell
# 创建并显示一个简单的通知
New-BurntToastNotification -Text "这是标题", "这是内容"
```

### 示例代码

以下是一些更复杂的示例，展示如何使用不同参数自定义通知。

#### 示例 1：简单通知

```powershell
New-BurntToastNotification -Text "提醒", "这是一个简单的通知"
```

#### 示例 2：带有时间戳的通知

```powershell
$time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
New-BurntToastNotification -Text "时间提醒", "这是一个带有时间戳的通知", $time
```

#### 示例 3：带有图片和动作按钮的通知

```powershell
$imagePath = "C:\Path\To\Image.png"
$action = New-BTButton -Content "确认" -Arguments "confirm"
New-BurntToastNotification -Text "提醒", "这是一个带有图片和动作按钮的通知" -AppLogo $imagePath -Button $action
```

