[toc]



## abstract

“从轻到重”的 Win11 小组件 / `Win + W` 禁用方案，以及尽可能关闭系统广告、推荐、提示的清理项。

## A. 最稳妥：用策略彻底禁用 Widgets，小组件和 Win+W 都会失效

微软官方策略项是 **Allow widgets / 允许小组件**，路径为：

```
计算机配置 > 管理模板 > Windows 组件 > Widgets > Allow widgets
```

微软文档说明该策略用于控制设备上是否允许 Widgets；对应 CSP 是 `NewsAndInterests/AllowNewsAndInterests`。([Microsoft Learn](https://learn.microsoft.com/en-us/windows/configuration/taskbar/policy-settings?utm_source=chatgpt.com))

### Windows 11 Pro / Enterprise / Education

1. `Win + R` → 输入 `gpedit.msc`

2. 进入：

   `计算机配置 → 管理模板 → Windows 组件 → Widgets`

3. 打开 **Allow widgets / 允许小组件**

4. 设为 **Disabled / 已禁用**

5. 管理员 CMD 执行：

```bat
gpupdate /force
```

1. 重启资源管理器或直接重启电脑。

重启资源管理器命令：

```bat
taskkill /f /im explorer.exe
start explorer.exe
```

### Windows 11 Home / 所有版本通用：注册表策略

以**管理员身份**打开 PowerShell 或 Windows Terminal，执行：

```powershell
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
gpupdate /force
taskkill /f /im explorer.exe
start explorer.exe
```

这个注册表项本质上是在 Home 版手动写入同类策略。执行后，任务栏小组件入口会被策略禁用，`Win + W` 通常也不会再打开小组件面板。

恢复方法：

```powershell
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /f
gpupdate /force
```

------

## B. 更狠：移除 Web Experience Pack，小组件组件本体也删掉

Widgets 依赖 **Windows Web Experience Pack**。如果你要尽量“移除而不是仅禁用”，管理员 PowerShell 执行：

```powershell
Get-AppxPackage *WebExperience* | Remove-AppxPackage
```

也可以尝试对所有用户移除：

```powershell
Get-AppxPackage -AllUsers *WebExperience* | Remove-AppxPackage -AllUsers
```

再删除预配包，减少新用户账户自动装回：

```powershell
Get-AppxProvisionedPackage -Online |
Where-Object {$_.DisplayName -like "*WebExperience*"} |
Remove-AppxProvisionedPackage -Online
```

注意：Windows 大版本更新、功能更新、Microsoft Store 更新可能把它装回来。建议 **A 的策略禁用** 仍然保留，因为策略比卸载更稳定。

------

## C. 关闭任务栏小组件入口

即使已经策略禁用，也建议关掉任务栏显示：

```
设置 → 个性化 → 任务栏 → 任务栏项 → 小组件 → 关闭
```

这只是隐藏按钮，不等于彻底禁用；所以它应作为补充，不应替代 A。

------

# 尽可能关闭 Windows 11 广告、推荐、提示

Windows 11 很多“广告”被微软称为 suggestions / recommendations / offers。微软官方文档确认了隐私设置里有“Recommendations & offers / 推荐和优惠”、设置应用建议内容、Start 和搜索启动跟踪等选项。([微软支持](https://support.microsoft.com/en-us/windows/privacy-settings-for-recommendations-offers-in-windows-11-807608ee-3de2-4498-8e7c-eb10d655567f?utm_source=chatgpt.com))

下面这组命令会尽量关闭常见广告 ID、建议内容、欢迎体验、提示通知、设置建议、个性化推荐。

以管理员 PowerShell 执行：

```powershell
# 关闭广告 ID
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f

# 关闭设置 App 中的建议内容
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f

# 关闭 Windows 欢迎体验
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f

# 关闭“使用 Windows 时获取提示和建议”
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f

# 关闭“完成设备设置”类推送
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f

# 关闭开始菜单/搜索的应用启动跟踪
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f

# 关闭开始菜单推荐中的提示、快捷方式、新应用等推送，部分版本有效
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f

# 关闭锁屏聚焦类内容投放，建议配合把锁屏背景改成“图片”
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f

# 关闭各种静默安装/建议 App 推送
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEverEnabled /t REG_DWORD /d 0 /f

# 重启资源管理器
taskkill /f /im explorer.exe
start explorer.exe
```

------

## 还需要手动关的设置

### 1. 锁屏广告 / 聚焦内容

```
设置 → 个性化 → 锁屏界面
```

把 **个性化锁屏界面** 从 **Windows 聚焦** 改成 **图片** 或 **幻灯片放映**，然后取消：

```
在锁屏界面上获取趣闻、提示、技巧等
```

第三方和管理文档也一致建议：要去掉锁屏广告，应避免 Windows Spotlight，并关闭锁屏提示。([PDQ](https://www.pdq.com/blog/how-to-disable-ads-on-windows/?utm_source=chatgpt.com))

### 2. 通知广告 / 提示

```
设置 → 系统 → 通知
```

关闭：

- `使用 Windows 时获取提示和建议`
- `更新后以及登录时显示 Windows 欢迎体验`
- `建议我如何充分利用设备`

微软官方说明通知可在 `设置 → 系统 → 通知` 中按 App 或整体关闭。([微软支持](https://support.microsoft.com/en-us/windows/notifications-and-do-not-disturb-in-windows-feeca47f-0baf-5680-16f0-8801db1a8466?utm_source=chatgpt.com))

### 3. 开始菜单推荐

```
设置 → 个性化 → 开始
```

关闭类似选项：

- `显示最近添加的应用`
- `显示最常用的应用`
- `显示最近打开的项目`
- `显示有关提示、快捷方式、新应用等的建议`
- `显示账户相关通知`

不同 Win11 版本措辞会略有变化。

### 4. 设置 App 推荐

```
设置 → 隐私和安全性 → 常规
```

关闭：

- `允许应用使用我的广告 ID 向我显示个性化广告`
- `让网站通过访问我的语言列表来显示本地相关内容`
- `允许 Windows 跟踪应用启动以改进开始菜单和搜索结果`
- `在设置应用中显示建议内容`

这些项目对应微软官方“Recommendations & offers”隐私设置说明。([微软支持](https://support.microsoft.com/en-us/windows/privacy-settings-for-recommendations-offers-in-windows-11-807608ee-3de2-4498-8e7c-eb10d655567f?utm_source=chatgpt.com))

### 5. 文件资源管理器推广内容

打开文件资源管理器：

```
… → 选项 → 查看
```

取消：

```
显示同步提供程序通知
```

------

## 一键批处理版本

把下面保存为 `disable-win11-widgets-ads.cmd`，右键 **以管理员身份运行**：

```bat
@echo off
echo Disabling Windows 11 Widgets and ads/recommendations...

:: Disable Widgets by policy
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f

:: Disable Advertising ID
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f

:: Disable suggestions, tips, welcome experience, silent app suggestions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEverEnabled /t REG_DWORD /d 0 /f

:: Disable lock screen spotlight overlays
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f

:: Disable SCOOBE / finish setting up prompts
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f

:: Disable Start/search app tracking and recommendations where supported
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f

gpupdate /force

taskkill /f /im explorer.exe
start explorer.exe

echo Done. Please reboot Windows.
pause
```

------

## 验证是否成功

执行后检查：

1. 按 `Win + W`：不应再打开小组件面板。
2. 任务栏：小组件入口应消失或无法使用。
3. `设置 → 个性化 → 任务栏`：小组件可能显示为受组织管理或不可用。
4. 观察几天：开始菜单、锁屏、通知中心、设置页中的推荐内容应明显减少。

最核心的是这一条：

```powershell
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
```

它是禁用 Win11 小组件和 `Win + W` 占用的关键。