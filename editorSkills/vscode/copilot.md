@[toc]

## reference

### Getting Started with GitHub Copilot in Visual Studio Code

- [Installing the Visual Studio Code extension](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#installing)
- [Seeing your first suggestion](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#first-suggestion)
- [Choosing alternate suggestions](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#alternates)
- [Getting more suggestions](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#more-suggestions)
- [Generating code from a comment](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#code-from-comment)
- [Using a framework](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#using-a-framework)
- [More examples](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#more-examples)
- [Keyboard shortcuts](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#shortcuts)
- [Enabling or disabling GitHub Copilot](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#enabling)
- [Learn More](https://github.com/github/copilot-docs/blob/main/docs/visualstudiocode/gettingstarted.md#more)

## 快捷键和指令(default)

- Accept an inline suggestion:
  - `Tab`.
    - `editor.action.inlineSuggest.commit`
- Dismiss an inline suggestion:
  - `Esc`.
    - `editor.action.inlineSuggest.hide`
- Show next inline suggestion:
  - `Alt + ]` or `Option + ]`.
    - `editor.action.inlineSuggest.showNext`
- Show previous inline suggestion:
  - `Alt + [` or `Option + [`.
    - `editor.action.inlineSuggest.showPrevious`
- ==Trigger inline suggestion:==
  - `Alt + \` or `Option + \`.
    - `editor.action.inlineSuggest.trigger`
- ==Open Copilot==
  - > (10 suggestions in separate pane):
  - `Ctrl + Enter`.
    - `github.copilot.generate`
- Copilot toggle on/off:
  - _No default shortcut_ .
    - `github.copilot.toggleCopilot`

### 推荐快捷键

> 比较常用的两个指令

- ==Trigger inline suggestion:==
  - `Alt + \` or `Option + \`.
    - `editor.action.inlineSuggest.trigger`
- ==Open Copilot==
  - > (10 suggestions in separate pane):
  - `Ctrl + Enter`.
    - `github.copilot.generate`

### 修改指令

![在这里插入图片描述](https://img-blog.csdnimg.cn/cd0133f298ca4128b9c2467b7ee8a836.png)
点击右侧齿轮直接配置指令(绑定快捷键)

## 效果

> 不仅可以补全代码,还可以尝试补全函数文档!
>
> - 质量还有待于提升

![在这里插入图片描述](https://img-blog.csdnimg.cn/57f7febc284347b2a94c99ed19321bb6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)

### 打开实时候选窗格

- 实时提示的延迟目前的版本是 `1~2秒`(可能根据网络条件/版本的不同而不同)

![在这里插入图片描述](https://img-blog.csdnimg.cn/b583d6154f4e4be987fd404dad68c07a.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

## 初次使用可能的问题

- 初次安装插件,申请体验资格花费了几十天时间
- 获取资格后插件可以连接到服务,但是提示功能可能未必能够立即生效
  - 补全函数时需要`换行触发`(或者快捷键手动触发)
  - 不总是可以补全一个整个函数
  - 存在一定延迟
- 几种操作可供参考(对于插件不工作的时候)
  - 换行,并用快捷键唤醒补全
  - 重启 vscode
  - 重启机器
  - 使用虚拟网卡代理尝试(应该不是必须的)
