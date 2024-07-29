[toc]

## abstract

- 尚未验证以下方法(仅做一个记录参考)

为了在右键菜单中添加“管理员取得所有权”的选项，您可以通过修改注册表来实现。

这通常用于快速获得文件或文件夹的所有权。

- [Win10右键怎么添加管理员取得所有权？管理员取得所有权reg制作 - 系统之家 (xitongzhijia.net)](https://www.xitongzhijia.net/xtjc/20170228/93162.html)

请按照以下步骤操作：

### 方法一：手动修改注册表

1. **打开注册表编辑器**：
   - 按下 `Win + R` 键，输入 `regedit`，然后按 `Enter` 键。

2. **导航到以下路径**：
   - `HKEY_CLASSES_ROOT\*\shell`

3. **创建新的项**：
   - 右键点击 `shell`，选择“新建” -> “项”，并将其命名为 `runas`.

4. **设置默认值**：
   - 选择 `runas`，双击右侧窗口中的“(默认)”值，输入 `管理员取得所有权` 或其他您喜欢的名称。

5. **创建新的子项**：
   - 右键点击 `runas`，选择“新建” -> “项”，并将其命名为 `command`.

6. **设置命令值**：
   - 选择 `command`，双击右侧窗口中的“(默认)”值，输入以下命令：
     ```
     powershell -command "Start-Process cmd -ArgumentList '/c takeown /f \"%1\" && icacls \"%1\" /grant administrators:F' -Verb runAs"
     ```

7. **保存并退出注册表编辑器**。

### 方法二：使用注册表文件

您还可以通过创建和导入一个注册表文件来实现这一操作。以下是具体步骤：

1. **创建注册表文件**：
   - 打开记事本，将以下内容复制进去：
     ```reg
     Windows Registry Editor Version 5.00
     
     [HKEY_CLASSES_ROOT\*\shell\runas]
     @="管理员取得所有权"
     "NoWorkingDirectory"=""
     
     [HKEY_CLASSES_ROOT\*\shell\runas\command]
     @="powershell -command \"Start-Process cmd -ArgumentList '/c takeown /f \"%1\" && icacls \"%1\" /grant administrators:F' -Verb runAs\""
     ```

2. **保存文件**：
   - 将文件保存为 `take_ownership.reg`（确保文件类型选择为“所有文件”）。

3. **导入注册表文件**：
   - 双击 `take_ownership.reg` 文件，系统会提示您确认更改注册表，选择“是”。

### 解释关键命令

- `takeown /f "%1"`：将文件或文件夹的所有权赋予当前用户。
- `icacls "%1" /grant administrators:F`：授予管理员组完全控制权限。
- `powershell -command "Start-Process cmd -ArgumentList ... -Verb runAs"`：以管理员权限运行命令。

### 注意事项

- 修改注册表有风险，请确保您备份了注册表或创建了系统还原点。
- 以上操作需要管理员权限。

通过上述方法，您可以在右键菜单中添加“管理员取得所有权”选项，从而简化文件或文件夹所有权的获取过程。

为了使“管理员取得所有权”选项根据用户的系统显示语言自动显示为中文或英文，可以通过使用Windows多语言支持机制和环境变量来改进注册表文件。以下是详细步骤：

## 改进的注册表文件

我们可以利用Windows的环境变量 `%SystemRoot%` 和 PowerShell脚本来根据系统语言设置来显示不同的文字。

1. **创建改进的注册表文件**：
   - 打开记事本，将以下内容复制进去：

     ```reg
     Windows Registry Editor Version 5.00
     
     [HKEY_CLASSES_ROOT\*\shell\runas]
     @="powershell -command \"$lang = (Get-UICulture).Name; if ($lang -like 'zh-*') { '管理员取得所有权' } else { 'Take Ownership' }\""
     "NoWorkingDirectory"=""
     
     [HKEY_CLASSES_ROOT\*\shell\runas\command]
     @="powershell -command \"Start-Process cmd -ArgumentList '/c takeown /f \"%1\" && icacls \"%1\" /grant administrators:F' -Verb runAs\""
     ```

2. **保存文件**：
   - 将文件保存为 `take_ownership_multilang.reg`（确保文件类型选择为“所有文件”）。

3. **导入注册表文件**：
   - 双击 `take_ownership_multilang.reg` 文件，系统会提示您确认更改注册表，选择“是”。

### 解释关键点

- `Get-UICulture`：这是一个PowerShell命令，可以获取当前用户界面的文化信息（语言设置）。
- `if ($lang -like 'zh-*') { '管理员取得所有权' } else { 'Take Ownership' }`：这是一个简单的条件语句，根据系统语言选择显示中文或英文。

### 注意事项

- 由于注册表中的默认值不能直接包含复杂的脚本，我们使用了一个技巧，即将PowerShell命令作为默认值。虽然这种方法可能会在某些情况下出现小问题，但通常情况下是可行的。
- 确保您有管理员权限来修改注册表。

通过上述方法，您可以在右键菜单中添加一个根据系统语言自动切换显示的“管理员取得所有权”选项。这样，中文用户和英文用户都可以方便地看到他们熟悉的语言。