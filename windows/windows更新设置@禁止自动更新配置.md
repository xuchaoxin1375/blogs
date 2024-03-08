[toc]

## refs

- [How do you turn off windows 10 updates which are really powerful? - Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/1351413/how-do-you-turn-off-windows-10-updates-which-are-r)

## 方法

- Completely turning off Windows updates is generally not recommended, as updates often include important security patches and bug fixes that help protect your system and keep it running smoothly. However, I understand your concern if you're facing compatibility issues with Windows 11 on your current hardware.

- If you still want to disable Windows updates, keep in mind that doing so can leave your system vulnerable to security threats and might result in a less stable experience over time. If you decide to proceed, here's how you can do it:

### 方法1

**Method 1: Using Group Policy Editor (For Windows 10 Pro, Enterprise, and Education editions)**

1. Press `Win + R` to open the Run dialog.
2. Type `gpedit.msc` and press Enter. This opens the Group Policy Editor.
3. Navigate to `Computer Configuration` > `Administrative Templates` > `Windows Components` > `Windows Update`.
4. Double-click on `Configure Automatic Updates`.
5. Select the `Disabled` option to turn off automatic updates.
6. Click `Apply` and then `OK`.

### 方法2

**Method 2: Using Registry Editor (Use with caution)**

Before proceeding with this method, I must emphasize that editing the Windows Registry can potentially cause serious issues if not done correctly. Make sure to back up your registry before making any changes.

1. Press `Win + R` to open the Run dialog.
2. Type `regedit` and press Enter to open the Registry Editor.
3. Navigate to `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows`.
4. Right-click on the `Windows` key, select `New`, and then choose `Key`. Name it `WindowsUpdate`.
5. Right-click on the newly created `WindowsUpdate` key, select `New`, and then choose `DWORD (32-bit) Value`. Name it `AUOptions`.
6. Double-click on `AUOptions` and set its value to `1` (for "Never check for updates").
7. Click `OK`.

## 暂停更新一段时间

You can also pause updates temporarily:

1. Go to `Settings` (press `Win + I`).
2. Click on `Update & Security`.
3. In the `Windows Update` section, click on `Advanced options`.
4. Under the `Pause updates` section, you can select a date to pause updates until.

Remember that even if you manage to turn off updates, it's important to keep your system secure. You might consider alternative solutions like using a more lightweight operating system or upgrading your hardware to meet the requirements of Windows 11.





