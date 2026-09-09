# Windows 无线网卡消失故障排查指南

- 整理日期:2026-08-30
- 依据:COLORFUL P15 23(i7-12700H,Intel AX211 组合卡)实际故障全过程
- 适用:WiFi 网卡从设备管理器消失、代码 45、"没有连接到计算机"类问题

---

## 1. 故障特征与快速判断

### 典型现象
- WiFi 图标消失/不可用,设备管理器**正常视图看不到无线网卡**;
- "查看 → 显示隐藏的设备"后可见**灰色条目**,属性提示:
  `当前,这个硬件设备没有连接到计算机。(代码 45)`;
- 重启无效;
- 常见诱因:更新并关机、纯电池运行、拔插电源后开机。

### 代码 45 的含义
设备在**注册表有记录但硬件不在总线上**(未枚举)。→ 问题在**硬件/BIOS/EC 供电层**,不在驱动与 Windows 设置层。
(对比:驱动问题表现为设备可见但带感叹号,代码 10/28/56。)

---

## 2. 诊断流程(每步:命令 + 目的 + 判读)

### 步骤 1:网卡状态总览

```powershell
Get-NetAdapter -IncludeHidden | Format-Table Name, InterfaceDescription, Status
Get-PnpDevice -Class Net | Format-Table Status, FriendlyName, InstanceId
```

**判读**:无线网卡完全不在列表 → 进入步骤 2。若在列表但 Disabled → 启用即可(`Enable-NetAdapter`)。

### 步骤 2:全设备树排查(找"隐身"的卡)

```powershell
Get-PnpDevice -PresentOnly | Where-Object { $_.Status -ne 'OK' } | Format-Table Status, Class, FriendlyName
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'Wireless|WLAN|Wi-?Fi|802\.11' }
```

**判读**:
- 找到名为 **WLAN** 的软件设备(`SWD\RADIO\{...}`,射频管理设备)属正常,不是网卡;
- 无线网卡既不出现、也没有任何"未知设备"报错 → 硬件层未枚举,继续。

### 步骤 3:查幽灵设备(证明"以前枚举过")

```powershell
pnputil /enum-devices /disconnected
Get-CimInstance Win32_PnPEntity | Where-Object { $_.Name -match 'AX2|Wi-Fi|Tile|8087' }
```

**判读**:
- `Intel Tile Device`、`Intel(R) Bluetooth`(USB\VID_8087&PID_0033)等条目显示**已断开连接** → 网卡以前被枚举过,现在整卡掉线(含蓝牙)→ 供电/EC 层问题坐实;
- 组合卡(如 AX211)蓝牙与 WiFi 分属 USB/CNVi 两条总线,二者同时消失 = 整卡电源轨被关断。

### 步骤 4:确认软件手段无效(排除法)

```powershell
whoami /groups                      # 看是否有管理员权限(Administrators 是否被 deny)
pnputil /scan-devices               # 需要管理员:重新扫描总线
```

**判读**:
- 非管理员时 `pnputil /scan-devices` 会报"拒绝访问",用 `Start-Process pnputil -Verb RunAs` 提权(UAC);
- 提权扫描后仍无设备 → **BIOS/EC 层不呈现硬件,软件无法修复**,进入硬件/电源处置。

### 步骤 5:时间线还原(定位诱因)

```powershell
Get-WinEvent -LogName System -MaxEvents 30000 |
  Where-Object { $_.ProviderName -eq 'Microsoft-Windows-Kernel-Power' -and $_.Id -in 41,42,107,109 } |
  Select-Object TimeCreated, Id
```

事件对照表:

| ID | 含义 | 本案用法 |
|---|---|---|
| 41 | 未正常关机的重启(断电/强关) | 标记 EC 放电时刻 |
| 42 / 107 | 睡眠 / 唤醒 | 排除误判为关机 |
| 109 | 电源转换(Reboot / Shutdown) | 还原"更新并关机"双段序列 |

```powershell
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 8
Get-WinEvent -LogName 'Microsoft-Windows-WindowsUpdateClient/Operational' | Where-Object { $_.Id -in 19,20,25 }
```

**判读**:更新并关机在日志里表现为 `Reboot`(装更新)+ `Shutdown`(关)两次 109;更新检查失败(0x80240438)则证明"再查更新"环节没有安装任何东西。

### 步骤 6:环境基线(排除驱动/固件因素)

```powershell
Get-CimInstance Win32_BIOS | Format-List SMBIOSBIOSVersion, ReleaseDate
Get-CimInstance Win32_PnPSignedDriver | Where-Object { $_.DeviceName -match 'Wi-Fi|WLAN' } |
  Format-List DeviceName, DriverVersion, DriverDate
Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name HiberbootEnabled
netsh wlan show interfaces
```

**判读**:
- 驱动版本为安装系统时的旧版本且未变 → 排除"更新装了坏驱动";
- BIOS 版本旧且未变 → 排除固件更新导致;
- 恢复后 `netsh wlan show interfaces` 有接口 → 修复生效。

---

## 3. 判定逻辑速查

| 观察 | 结论 |
|---|---|
| 设备可见但 Disabled | Windows 层禁用 → 启用即可 |
| 设备可见带感叹号(代码 10/28/56) | 驱动问题 → 更新/回滚驱动 |
| 设备不可见,仅灰色残留(代码 45) | **硬件/EC/BIOS 层未枚举** → EC 放电 → BIOS → 重插卡 |
| 组合卡蓝牙也同时消失 | 整卡掉电,EC 电源门控问题,与驱动无关 |
| 重启无效、完全断电有效 | 状态存在 EC 内(重启不重置 EC,断电才重置) |

---

## 4. 修复方案与有效性

| 方案 | 操作 | 有效性 |
|---|---|---|
| 重启 | 常规重启 | ❌ 无效(EC 状态跨重启保持) |
| 重查系统更新 | 设置 → Windows 更新 | ⭕ 与故障无关 |
| **EC 放电重置** | 关机 → 拔电源 → 长按电源键 30 秒 → 插电 → 开机 | ✅ **本次唯一有效** |
| BIOS 检查 | 开机 F2 → Load Optimized Defaults → Wireless LAN = Enabled | 次选(EC 无效时) |
| 重插网卡 | 拆后盖,拔下 M.2 网卡重插 | 接触不良时的根治手段 |
| 更换网卡 | 换同型卡(AX201/AX211) | 卡硬件损坏时 |

---

## 5. 命令速查表(按场景)

### 设备与驱动
```powershell
Get-NetAdapter -IncludeHidden
Get-PnpDevice -Class Net
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'WLAN|802\.11' }
pnputil /enum-devices /disconnected   # 幽灵设备
pnputil /scan-devices                 # 管理员:重扫总线
Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
```

### 电源与日志
```powershell
Get-WinEvent -LogName System | Where-Object { $_.ProviderName -eq 'Microsoft-Windows-Kernel-Power' -and $_.Id -in 41,42,107,109 }
Get-WinEvent -LogName System | Where-Object { $_.TimeCreated -ge (Get-Date).AddDays(-3) -and $_.ProviderName -match 'Kernel-PnP|DeviceSetupManager' }
Get-CimInstance Win32_Battery | Select-Object BatteryStatus, EstimatedChargeRemaining
```

### 更新与系统
```powershell
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 8
Get-WinEvent -LogName 'Microsoft-Windows-WindowsUpdateClient/Operational' | Where-Object { $_.Id -in 19,20,25 }
Get-CimInstance Win32_BIOS
Get-CimInstance Win32_OperatingSystem | Select-Object InstallDate, LastBootUpTime
```

### 网络验证
```powershell
netsh wlan show interfaces
netsh wlan show drivers
Test-NetConnection 8.8.8.8
```

---

## 6. 常见坑

| 坑 | 说明 |
|---|---|
| 权限不足 | 设备管理类命令(pnputil)需管理员;用 `Start-Process ... -Verb RunAs` 提权 |
| 中文乱码 | pwsh 输出按 GBK(936),agent 按 UTF-8 解码 → 用 utf8-output 插件或命令前缀注入 `[Console]::OutputEncoding=[Text.Encoding]::UTF8` |
| 隐藏设备误判 | 勾选"显示隐藏设备"看到的灰色条目是注册表残留,不代表硬件存在 |
| 关机≠休眠 | 事件日志用 42(睡眠)/109(关机)区分,别把睡眠唤醒当关机重启 |
| 更新检查失败≠已安装 | WindowsUpdateClient 事件 25(失败)与 19/20(成功安装)要区分;Get-HotFix 的 InstalledOn 可能不精确 |

---

## 7. 本次案例复盘(完整链路)

1. 现象:8/30 插电开机后 WiFi 消失,设备管理器仅见灰色代码 45 条目;
2. `Get-NetAdapter`/`Get-PnpDevice -Class Net`:无无线设备 → 排除 Windows 层;
3. `Get-PnpDevice` 全量 + `pnputil /enum-devices /disconnected`:发现 Intel Tile、蓝牙射频、WLAN 全部"已断开" → 整卡掉电;
4. `Get-HotFix` + Kernel-Power 109 日志:还原出 8/29 纯电池"更新并关机"序列(Reboot→Shutdown)为诱因;
5. 驱动 23.40.0.4 未变、BIOS 2024/4 未变 → 排除驱动/固件;
6. 四次重启无效 → 判断 EC 状态问题;EC 放电重置后冷启动,WiFi+蓝牙同时恢复;
7. 结论:EC 电源门控状态卡死,唯一有效修复 = EC 放电重置;预防 = 更新时保持插电。