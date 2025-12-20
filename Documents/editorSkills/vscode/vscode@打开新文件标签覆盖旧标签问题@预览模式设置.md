[toc]



这是 VS Code 里一个**非常常见但容易让人困惑的行为**，根源在于它的**预览模式 preview mode**。

简单结论
Ctrl+P 打开的文件之所以会“覆盖”当前标签，是因为它默认以**预览标签（Preview Tab）\**方式打开。
关闭或调整预览机制，就可以让文件\**始终新开一个标签**。



------

## 关闭预览模式

这是**最干净、最符合直觉**的方案。

操作步骤

1. 打开 Settings（Ctrl+,）
2. 搜索：preview
3. 关闭以下选项：
   - Enable Preview
   - Enable Preview From Quick Open

```url
vscode://settings/workbench.editor.enablePreview
```

```url
workbench.editor.enablePreview
```

等价的 settings.json 配置：

```json
{
  "workbench.editor.enablePreview": false,
  "workbench.editor.enablePreviewFromQuickOpen": false
}
```

效果

- Ctrl+P 打开的文件永远是**新标签**
- 不再出现斜体标签
- 行为接近传统 IDE（如 IntelliJ）

适合人群

- 经常多文件对照
- 写代码、读源码、调试
- 不想被“智能行为”打断思路

------

