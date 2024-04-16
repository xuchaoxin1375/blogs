[toc]

## abstract

- typora专业的markdown编辑器,许多体验还是要好于用vscode的插件来打开

### vscode中调用typora打开文件

- typora支持命令行打开文件
- 但是如果在vscode中已经打开了一个markdown文件(设为`X.md`),那么除了命令行还可以如何调用markdown而不需要输入文件名`X.md`
- 插件市场有几个插件可以用

### open in Typora

- [Open in Typora - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=cyberbiont.vscode-open-in-typora)
  - 使用说明:首先要在计算机上安装typora
    - 并且把typora.exe所在目录配置到Path环境变量
    - 总之要在命令行(cmd)中能够输入typora来启动typora软件即可
- 冲突说明
  - 这里的插件做的一个工作是把命令行中输入typora X.md的过程简化为一个按钮点击,而不需要输入文件名,文件名是已经通过鼠标右键选中了来传递这个信息
  - 但是如果安装其他vscode中的某些markdown编辑器插件,并且被设置为默认打开,可能会阻碍Open in Typora插件工作
  - 因此推荐使用Open in typora时,把vscode的markdown默认打开方式设置为build-in,方法是vscode打开一个markdown文件,并且打开command palette(`ctrl+shift+p`)启动,输入`reopen`(选择`reopen editor with...`,设置默认用text editor打开)
    - 如需要详细的具体方法自行查找







