[toc]

##  abstract

vscode有丰富的插件资源,但是如果安装过多的插件,会导致启动加载变慢,占用内存和cpu等资源,影响使用体验

另一方面,大多数情况下,不需要开启所有的插件,就比如当前在用vscode做前端开发,就没有必要把`嵌入式开发的插件`(platformIO/arduino/vhdl...)一起打开

本文提到的定制配置主要针对拓展(插件)的组合而言

## 理想的解决思路

如果能够按需自动启用当前工作流(环境)需要的插件和禁用当前换环境不需要的插件,是最好的

那么有什么要的方法既能够减少不必要的插件的加载,又能够满足开发过程中需要的插件?

[Visual Studio Code User and Workspace Settings](https://code.visualstudio.com/docs/getstarted/settings#_profile-settings)

- [Profiles in Visual Studio Code](https://code.visualstudio.com/docs/editor/profiles)
- [Workspaces in Visual Studio Code](https://code.visualstudio.com/docs/editor/workspaces)

vscode有一个workspace的概念,这就为不同的工作目录设置不同的插件加载等配置提供了方便

还有更强大的profile功能,和workspace各有优点,共同点是都可以对特定项目的插件加载进行优化,对项目/工作目录工作空间加载插件是避免不必要的开销

## 检查正在运行的插件|插件启动耗时

- `command palette`中搜索`>extensions:show running extensions`查看

## 默认配置下禁用所有非通用插件

- 通过`disable all installed Extensions`选项,您可以**将所有的插件禁用(默认禁用disable)**
  - 对于不同项目通用的插件,可以在禁用全部后重新启用回来(这部分插件一般不会很多,比如AI助手插件,语言包插件)
- 禁用方式:在`command palette`中输入`extensions:disable all installed extensions`点击相应选项

## 工作区定制配置workspace

- 插件的启用和禁用选项都提供了workspace级别的操作,在工作区中按需启用插件即可
- 其他配置也可以是workspace作用域
- 缺点插件启用和禁用配置记录在工作目录以外的,不便于迁移和同步,在其他机器上使用需要手动配置一遍

## 使用profile

- profile是较后期引入的功能,是支持跨设备同步的
- 同一个profile可以为不同项目所使用,例如两个关于C++的不同项目,都可以将profile切换到关于C++的配置插件组合的profile;其他语言也是类似的
- 还可以导出环境配置以及导入配置,详情查看文档
- 缺点是不同环境要用的插件需要重新安装,而无法从默认配置的插件共用,但是支持将某个插件设置为所有profile都使用`apply extension to all profile`

### 全局配置Profile公共属性

这部分可能包含你想要在所有profile中都启用的插件,或者所有profile都使用相同的图标主题时很有用

- ### [Apply a setting to all profiles](https://code.visualstudio.com/docs/editor/profiles#_apply-a-setting-to-all-profiles)

- ### [Apply an extension to all profiles](https://code.visualstudio.com/docs/editor/profiles#_apply-an-extension-to-all-profiles)

配置为`apply to all profiles`后,设置中会有相关标记,settings.json中会出现字段

```json
"workbench.settings.applyToAllProfiles": [
    "workbench.iconTheme"
],
```

其中的例子是我设置了文件图标为全局(全部profile)生效

## 小结

自定义环境配置可以配合使用workspace,profile,互补有无

##  编辑过程中的卡慢问题
- 如果重启及其后依旧很卡很慢,那么可能是您编辑的项目使用了**git管理**,并且存在大量的修改没有提交,某些情况下,发生变动的文件可达到数千个(譬如删除了某个目录),那么vscode会变得非常慢
- 可以用vscode打开其他项目看看,如果其他项目是正常的,那么更有可能是git跟踪造成的开销,导致软件很慢
- 如果确实如此,那么先提交修改,在查看状况