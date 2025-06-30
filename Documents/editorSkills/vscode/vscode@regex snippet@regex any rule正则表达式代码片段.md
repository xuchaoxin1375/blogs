[toc]



## abstract

列举两个常用的regex snippet(rule)插件,能够给出常用的正则片段,比如邮箱,手机号码

- [Regex Snippets - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=Monish.regexsnippets) 
  - 此插件依赖于vscode代码片段配置,而vscode代码片段会根据当前编辑的文件的类型(属于哪种语言的源代码文件后缀,比如`.py`,`.css`,如果是txt文件则无法触发代码片段补全,因此依赖于代码补全的此插件将会在这种情况失效)
- [any-rule - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=russell.any-rule)
  - 这是有全局可以激活获取regex 规则插件
  - `command palette`中输入`zz`获取规则

## 常见regex规则:

- [any86/any-rule: 🦕 常用正则大全, 支持web / vscode / idea / Alfred Workflow多平台](https://github.com/any86/any-rule)
- [vscode-regex-snippets/regexsnippets.code-snippets at a8fc796faaffa5fd90d9b617d50f199d51f029d7 · monizb/vscode-regex-snippets](https://github.com/monizb/vscode-regex-snippets/blob/a8fc796faaffa5fd90d9b617d50f199d51f029d7/regexsnippets.code-snippets#L124)