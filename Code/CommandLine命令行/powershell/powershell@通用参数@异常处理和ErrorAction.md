[toc]

- [关于 CommonParameters - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7.4#-erroraction)
- **ErrorAction** 参数对终止错误（例如缺少数据、无效的参数或权限不足）无效，这些错误会阻止命令成功完成。
  - `Break` 在发生错误或引发异常时进入调试器。
  - `Continue` 显示错误消息并继续执行命令。 `Continue` 是默认值。
  - `Ignore` 禁止显示错误消息并继续执行命令。 与 **SilentlyContinue** 不同，**Ignore** 不会将错误消息添加到 `$Error` 自动变量。 PowerShell 3.0 中引入了 **Ignore** 值。
  - `Inquire` 显示错误消息，并在继续执行之前提示你确认。 此值很少使用。
  - `SilentlyContinue` 禁止显示错误消息并继续执行命令。
  - `Stop` 显示错误消息并停止执行命令。
  - `Suspend` 仅适用于 PowerShell 6 及更高版本不支持的工作流。