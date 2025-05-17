[toc]



## DataWrangler

- [数据管理员 - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.datawrangler)
- [Data Wrangler - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.datawrangler)

## DataWrangler文件默认打开方式

vscode DataWrangler可能会弹出一个提醒,让你将csv这类文件的默认打开方式设置为`DataWrangler`

此插件比较特殊,如果你选择同意,那么其他csv查看插件,包括vscode的text editor将难以通过常规方式设置为默认方式,需要修改settings.json配置文件

估计是`"file:/**/*.csv": "jupyter-data-wrangler"`控制的

```json
    "workbench.editorAssociations": {
        "*.copilotmd": "vscode.markdown.preview.editor",
        "git:/**/*.code-snippets": "default",
        "gitlens:/**/*.code-snippets": "default",
        "*.ipynb": "jupyter-notebook",
        "*.zip": "default",
        "*.md": "default",
        "*.svg": "default",
        "*.lnk": "default",
        "*.csv": "default",
        "*.jpg": "gryc.viewer",
        // "file:/**/*.csv": "jupyter-data-wrangler"
    },
```

