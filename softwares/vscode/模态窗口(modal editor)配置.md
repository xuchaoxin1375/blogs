[toc]



## VS Code 的 Modal Editors（模态编辑器）

VS Code 在 **2026 年 2 月版 1.110** 中首次引入这个功能：某些原本会占一个普通 tab 的页面，现在会浮在编辑区中央，按 `Esc` 就关闭，不改变原来的 tab 布局。最初它还是实验功能。([Visual Studio Code](https://code.visualstudio.com/updates/v1_110?utm_source=chatgpt.com))

现在这个行为已经变成默认体验。VS Code 当前文档明确写着：

- `workbench.editor.useModal = "some"`：**当前默认值**，部分编辑器使用模态窗口
- `"off"`：**全部恢复为以前的普通 tab**
- `"all"`：所有编辑器都尽可能使用模态窗口 ([Visual Studio Code](https://code.visualstudio.com/docs/editing/userinterface?utm_source=chatgpt.com))

所以你想要的基本就是：

```json
"workbench.editor.useModal": "off"
```

### 最直接的修改方法

按：

```text
Ctrl + Shift + P
```

输入：

```text
Preferences: Open User Settings (JSON)
```

然后在 `settings.json` 里加入：

```json
{
    "workbench.editor.useModal": "off"
}
```

如果你已经有其他设置，只加这一行即可，注意逗号。

例如：

```json
{
    "editor.fontSize": 15,
    "workbench.editor.useModal": "off"
}
```

也可以打开 Settings，搜索：

```text
workbench.editor.useModal
```

把 **Workbench › Editor: Use Modal** 改成 **Off**。官方文档也确认这个设置就是控制模态编辑器行为的开关。([GitHub](https://github.com/microsoft/vscode-docs/blob/main/docs/configure/settings.md?utm_source=chatgpt.com))

也就是一个浮在当前编辑器上面的 overlay。官方给出的设计理由是：这些页面通常只是“短暂打开，看完之后继续当前工作”，因此不希望它们打乱已有的 tab 布局。([Visual Studio Code](https://code.visualstudio.com/updates/v1_110?utm_source=chatgpt.com))

但你的感觉并不是个例。2026 年 4 月已经有人在 VS Code 官方 issue 里反馈，升级到 **1.114** 后 Settings 默认变成 modal，觉得屏幕空间浪费，而且每次手动点“移回普通 tab”很烦；官方给出的解决方向同样是 `workbench.editor.useModal`。([GitHub](https://github.com/microsoft/vscode/issues/309220?utm_source=chatgpt.com))

### 有一个细节值得确认

官方文档说明 `"some"` 默认只针对特定配置/管理编辑器；普通文件全部 modal 对应的是：

```json
"workbench.editor.useModal": "all"
```

([Visual Studio Code](https://code.visualstudio.com/docs/editing/userinterface?utm_source=chatgpt.com))

这种情况下，很可能是你的 Settings Sync、Profile 或之前某次实验设置把它改成了 `"all"`。直接设成：

```json
"workbench.editor.useModal": "off"
```

就可以彻底回到老式 tab 工作流。

另外，早期 2026 版本确实出现过 `"off"` 仍然挡不住某些页面弹 modal 的 bug；VS Code 团队后来处理到了 **1.124 milestone**。所以如果你发现设成 `"off"` 后仍然有 Profiles / Language Models / Agent Settings 之类弹出来，先确认 VS Code 已经更新到较新的版本。([GitHub](https://github.com/microsoft/vscode/issues/319684?utm_source=chatgpt.com))

所以如果你的目标就是“我不要这套新 modal 设计，全部像以前一样用 tab 打开”，我建议直接永久写：

```json
"workbench.editor.useModal": "off"
```

