[toc]



## 界面布局介绍和自定义UI

官方中文文档:[在 Office 中自定义功能区 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/在-office-中自定义功能区-00f24ca7-6021-48d3-9514-a31a460ecb31)

也可以查看原汁原味的英文文档:[Customize the ribbon in Office - Microsoft Support](https://support.microsoft.com/en-us/office/customize-the-ribbon-in-office-00f24ca7-6021-48d3-9514-a31a460ecb31#OfficeVersion=Windows)

也可以参考其他经典软件的布局和功能区域称呼:[Visual Studio Code User Interface](https://code.visualstudio.com/docs/getstarted/userinterface)



### 主界面布局解释

- **Tabs (标签页)**：在图中顶部显示，如“File, Home, Insert”等。
- **Commands (命令)**：在标签页内显示的具体操作按钮，如“Paste, Font Size, Bold”等。
- **Groups (组)**：在标签页内将命令分类的区域，如“Clipboard, Font, Paragraph”等。

这种组织方式使得复杂的办公软件功能能够以一种逻辑且易于访问的方式呈现给用户，提高了工作效率和用户体验。

### 软件的用户界面基本概念介绍

在 Office 中自定义**功能区**:Customize the **ribbon** in Office

**可以自定义的内容**：可以个性化功能区，按照所需的顺序排列**选项卡**和**命令**，隐藏或取消隐藏**功能区**，并隐藏不太常用的命令。 此外，还可以导出或导入自定义功能区。

**What you can customize**: You can personalize your ribbon to arrange **tabs** and **commands** in the order you want them, hide or unhide your **ribbon**, and hide those commands you use less often. Also, you can export or import a customized ribbon.

| 中     | 英      | Notes                                                        |
| ------ | ------- | ------------------------------------------------------------ |
| 选项卡 | Tabs    | 有些地方也称之为标签页,在浏览器中尤为常见和经典,但是非浏览器软件中的Tab一般称为选项卡,每个选项卡下有许多组构成 |
| 功能区 | Ribbon  | 功能区是由各个功能组(Group)构成的一块UI区域                  |
| 组     | Group   | 组是划分功能区的单位,一个组内通常包含许多相关或类似的命令(按钮等控件),称为功能组或者命令组 |
| 命令   | Command | 基本功能单位,比如设置某个字的字号                            |
| 工具栏 | Toolbar | 工具栏用来放置用户最最常用的功能,默认一般有保存按钮,撤销/恢复按钮,(称为Quick Access Toolbar)当然同一层还可以显示当前编辑的文件的名称 |

## 功能和命令分级

点击不同的Tab,呈现不同的功能区内容,也就是不同的命令组(Gruop)

也可以理解为点击不同的Tab，功能区内会填充不同的命令组

此外,功能组内的控件有的是简单命令,有的则是多级命令,也就是点开还有更精细的操作

## 自定义MS Office 软件UI

主要分为两个部分:功能区(包括Tab和Group)和快速访问工具栏(Toolbar)

### 自定义功能区

office自定义功能区不仅可以更改已有的选项卡下的功能组的功能布局,还可以添加和修改选项卡,设计自己的功能组和功能区

### 自定义快速访问👺

[自定义快速访问工具栏 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/自定义快速访问工具栏-43fff1c9-ebc4-4963-bdbd-c2b6b0739e52)

您可以讲快速访问工具栏调整到功能区(Ribbon)下方,这样可以设置显示快速访问工具栏上的功能按钮的标签

### 降低命令级数

通常您可以右键某个命令控件,然后弹出的菜单里有一个添加到快速访问按钮

但是有时需要添加的命令是一个二级以上的命令,则可能无法直接添加到快速访问工具栏(当然,您可以直接通过自定快速访问的功能来调整)

这时您可以通过自动定义创建一个自己的Tab,然后创建一个自己的Group,并将目标命令添加到这个Group中,此时二级命令就被提升为一级命令,从而可以右键添加到快速访问中;

并且,即便您不添加到快速访问中,这个自定义选项卡中的命令已经集合了您想要快速访问的按钮(按钮数量不多时,按钮较大,而且有文字说明)



## 快捷键

### 快捷键大全

- [Microsoft 365 中的键盘快捷方式 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/microsoft-365-中的键盘快捷方式-e765366f-24fc-4054-870d-39b214f223fd)
  - [Excel 中的键盘快捷方式 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/excel-中的键盘快捷方式-1798d9d5-842a-42b8-9c99-9b7213f0040f#PickTab=Windows)
    - 这个文档里的空格键是中文而不是`Space`或`Spacebar`,如果要搜索空格相关的快捷键,请输入汉字,或者使用英文文档
  - [Keyboard shortcuts in Excel - Microsoft Support](https://support.microsoft.com/en-us/office/keyboard-shortcuts-in-excel-1798d9d5-842a-42b8-9c99-9b7213f0040f)



### 快捷键自定义

- office word 支持快捷键自定义 [自定义键盘快捷键 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/自定义键盘快捷键-9a92343e-a781-4d5a-92f1-0f32e3ba5b4d#:~:text=使用鼠标指定或删除键盘快捷键 1 转到 “文件 > 选项” > “自定义功能区,或功能键开始键盘快捷键。 在“ 请按新快捷键 ”框中，按要指定的键击组合。 例如，同时按 Ctrl 和要使用的键。 )

- 而powerpoint,excel不支持自定义快捷键
- 此外,您可能发现有些快捷键不可用(比如关于空格的快捷键,经常会和输入法的切换有关,这会导致快捷键别输入法捕获,是的快捷键无法在office软件中生效)
  - 例如,excel中有一个选中表格的列的快捷键`Ctrl+Space`,或者`Shift+Space`两个组合经常会和书法中英文切换造成冲突,您可以设法关闭或者更改输入法的引起冲突的快捷键,可能是系统输入法设置或者是第三方输入法里设置
  - 例如微软拼音输入法,就默认启用了`Ctrl+Space`作为中英文切换键(Mode Switch),切换输入法的方法是按住`windows`键不放,然后按下空格键,会弹出一个输入法列表,每按下一次空格键,就会选则下一个输入法
