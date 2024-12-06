[toc]



`shutdown /r /fw` 是一个在 Windows 操作系统中用于重新启动计算机并打开固件（通常是 BIOS/UEFI 界面）选项的命令。以下是它的详细解释：

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

```bash

#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][21:49:21][UP:0.03Days]
PS> cmd /c bcdedit /bootsequence '{b794f931-144f-11ef-bbb1-dcfb484e80bc}'
操作成功完成。

#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][21:49:23][UP:0.03Days]
PS> cmd /c bcdedit /bootsequence '{current}'
操作成功完成。
```

注意,需要用`{}`来包为`identifier`

```bash
#⚡️[cxxu@CXXUREDMIBOOK][~\Desktop][21:49:15][UP:0.03Days]
PS> cmd /c bcdedit /bootsequence 'b794f931-144f-11ef-bbb1-dcfb484e80bc'
按规定项列表数据无效。
运行 "bcdedit /?" 获得命令行帮助。
参数错误。
```

