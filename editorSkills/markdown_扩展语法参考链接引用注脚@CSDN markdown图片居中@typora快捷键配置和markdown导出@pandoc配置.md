[toc]

#  修改快捷键(for windows)

### gui打开配置文件

- [Shortcut Keys - Typora Support](https://support.typora.io/Shortcut-Keys/#change-shortcut-keys)
- file(文件)->preference(偏好设置)->General(通用设置)->advance settings(高级设置)->open advanced settings(打开高级设置)

### powershell直接打开配置文件

```bash
PS C:\Users\cxxu>  cd $env:APPDATA\typora\conf
PS C:\Users\cxxu\AppData\Roaming\Typora\conf> ls

        Directory: C:\Users\cxxu\AppData\Roaming\Typora\conf


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a---         2022/10/7     11:36           1199   conf.default.json
-a---        2022/11/30      9:29           2092   conf.user.json

PS C:\Users\cxxu\AppData\Roaming\Typora\conf>
```



### 部分配置内容

- 

  ```json
   // Custom key binding, which will override the default ones.
    // see https://support.typora.io/Shortcut-Keys/#windows--linux for detail
    "keyBinding": {
      // for example: 
      // "Always on Top": "Ctrl+Shift+P"
      // All other options are the menu items 'text label' displayed from each typora menu
      "heading 1": "ctrl+alt+1",
      "heading 2": "ctrl+alt+2",
      "heading 3": "ctrl+alt+3",
      "heading 4": "ctrl+alt+4",
      "heading 5": "ctrl+alt+5",
      "heading 6": "ctrl+alt+6",
      "Unordered List": "ctrl+l",
      "paragraph": "alt+`",
      "Insert Paragraph After": "ctrl+enter",
      "Insert Paragraph Before": "ctrl+shift+enter",
      "Select Line/Sentence": "ctrl+alt+l",
      "Select Line": "ctrl+alt+l",
      "Select Line / Sentence": "ctrl+alt+l",
      "Select Sentence": "ctrl+alt+l",
      "quote": "ctrl+;",
      "code": "ctrl+`",
      "strike": "ctrl+alt+t",
      "inline math": "ctrl+m",
      "refresh all math expressions": "ctrl+alt+m",
      "rename": "f2",
      "new file": "ctrl+该指令无效",
      "new": "ctrl+shift+n",
      "Delete Column Derecated": "ctrl+alt+Backspace",
      "Delete Column": "ctrl+j",
      "Add Column After": "ctrl+alt+j"
    },
  ```

  



###  使用jsonc模式编辑配置文件

- for vscode+jsonc
  - jsonc:json with doc
- vscode 支持一种带有注释的json配置文件(注释不会引发报错)
## 保存修改,重启typora:
##  查看修改效果:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210331113155108.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
#  markdown转word(docx)
- `typora`正式版已经开始收费
- 但是测试版不用,而且我测试转换的测试版最后一个测试版(beta)能够满足转换功能;

##  方式0(typora复制粘贴到word)：
- 转换过程其实很简单,就是全选typora中打开的markdown,然后(创建)并打开一个空的word文档(.docx)
- 现在将内容粘贴到空`.docx`中即可
- 导航大纲也能得到保留

###  advantage
- 不用安装pandoc等其他软件
###  disadvantage
- 对于表格的转换，可能会溢出页面，需要手动调整表格

##  方式1(纯pandoc CLI方式):🎈
- 批量操作可以借助powershell 或bash/zsh等shell或其他编程语言来批处理

- 用pandoc命令行直接md文件转为docx文件
- `pandoc -s <source.md> -o <output.docx>`

### pandoc结合powershell示例

- 将当前目录下的所有`.docx`转换为`md`(markdown)

- ```powershell
  ls *.docx|foreach{Invoke-Expression "pandoc.exe -s $($_.Name) -o $($_.baseName).md"}
  ```


- 具体的语法可以参照`pandoc`官方文档(打开较慢)

  - [Converting a file](https://pandoc.org/getting-started.html#step-6-converting-a-file)

    - To convert it to HTML, use this command:

      ```bash
      pandoc test1.md -f markdown -t html -s -o test1.html
      ```

      - The filename `test1.md` tells pandoc which file to convert. 
      - The `-s` option says to create a “standalone” file, with a header and footer, not just a fragment. 
      - And the `-o test1.html` says to put the output in the file `test1.html`. 
      - Note that **we could have omitted** `-f markdown` and `-t html`, since the default is to convert from markdown to HTML, but it doesn’t hurt to include them.
  - [Pandoc - Getting started with pandoc](https://pandoc.org/getting-started.html)(完整的入门流程)
###  配置便携版pandoc(免安装)
- 不同于msi安装版,zip版中包含exe程序
- 将其所在目录添加到**环境变量path**中
- 关闭typaro后重新打开typaro即可使用(比如导出功能)
- ```powershell
  PS D:\repos\blogs\blogWriting> $env:pandoc_Home
  D:\exes\windowsTools\pandoc-2.16.2
  ```

### pandoc转换效果
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/f3394682c530421b8cc53bc28574e4d0.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

- 对于复杂大表格中,单格内容过多换行问题,可以适当的手动调整表格中文字字体的大小(特别是一些长公式)
##  方式2(typora调用padoc,GUI方式)：
结合pandoc,typora支持导出为`.docx`格式文件
- 安装并检验pandoc
- 可以用zip包，但是需要配置环境变量！以及（path变量)
- 从github上下载：[Releases · jgm/pandoc (github.com)](https://github.com/jgm/pandoc/releases)
- 从官网下载：[Pandoc - Installing pandoc](https://pandoc.org/installing.html#windows)

- ```bash
  PS D:\repos\scripts> pandoc.exe -v
  pandoc.exe 2.16.2
  Compiled with pandoc-types 1.22.1, texmath 0.12.3.3, skylighting 0.12.1,
  citeproc 0.6, ipynb 0.1.0.2
  User data directory: C:\Users\cxxu\AppData\Roaming\pandoc
  Copyright (C) 2006-2021 John MacFarlane. Web:  https://pandoc.org
  This is free software; see the source for copying conditions. There is no
  warranty, not even for merchantability or fitness for a particular purpose.
  ```

- typora:file->export->word(.docx)

  

##  方式3(IDEA)：
- [Markdown | IntelliJ IDEA (jetbrains.com)](https://www.jetbrains.com/help/idea/markdown.html#tips)
- 使用IDEA+Pandoc
- IDEA似乎只支持安装版的pandoc(zip版似支持的不好）

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/e7a7de75fa774cbbbdf57a2954ea3f20.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_19,color_FFFFFF,t_70,g_se,x_16)


# Shortcut Keys 默认快捷键大全(offical)
- [Shortcut Keys - Typora Support](https://support.typora.io/Shortcut-Keys/)  
	- 可能打不开


- [Summary](https://support.typora.io/Shortcut-Keys/#summary)
- Frequently Used Shortcut Keys
  - [Autocomplete](https://support.typora.io/Shortcut-Keys/#autocomplete)
  - [File](https://support.typora.io/Shortcut-Keys/#file)
  - [Edit](https://support.typora.io/Shortcut-Keys/#edit)
  - [Paragraph](https://support.typora.io/Shortcut-Keys/#paragraph)
  - [Format](https://support.typora.io/Shortcut-Keys/#format)
  - [View](https://support.typora.io/Shortcut-Keys/#view)
- Change Shortcut Keys
  - [macOS](https://support.typora.io/Shortcut-Keys/#macos)
  - Windows / Linux
    - [Q: Shortcut keys does not work on Ubuntu](https://support.typora.io/Shortcut-Keys/#q-shortcut-keys-does-not-work-on-ubuntu)

## Summary

You can use shortcut keys to quickly insert or modify styles or do other operations supported by Typora.

You can find shortcut keys in the right side of each menu items from menu bar.

## Frequently Used Shortcut Keys

### Autocomplete

On macOS, you can press `Esc` key to open inline preview for inline math, auto-complete for emoji, etc.

### File

| Function            | Hotkey (Windows/Linux) | Hotkey (macOS)      |
| :------------------ | :--------------------- | ------------------- |
| New                 | Ctrl + N               | Command + N         |
| New Window          | Ctrl + Shift + N       | Command +Shift + N  |
| New Tab             | *(Not Supported)*      | Command + T         |
| Open                | Ctrl + O               | Command + O         |
| Open Quickly        | Ctrl + P               | Command + Shift + O |
| Reopen Closed File  | Ctrl + Shift + T       | Command + Shift + T |
| Save                | Ctrl + S               | Command + S         |
| Save As / Duplicate | Ctrl + Shift + S       | Command + Shift + S |
| Preference          | Ctrl + ,               | Command + ,         |
| Close               | Ctrl + W               | Command + W         |

### Edit

| Function                                   | Hotkey (Windows/Linux)     | Hotkey (macOS)                      |
| :----------------------------------------- | :------------------------- | ----------------------------------- |
| New Paragraph                              | Enter                      | Enter                               |
| New Line                                   | Shift + Enter              | Shift + Enter                       |
| Cut                                        | Ctrl + X                   | Command + X                         |
| Copy                                       | Ctrl + C                   | Command + C                         |
| Paste                                      | Ctrl + V                   | Command + V                         |
| Copy As Markdown                           | Ctrl + Shift + C           | Command + Shift + C                 |
| Paste As Plain Text                        | Ctrl + Shift + V           | Command + Shift + V                 |
| Select All                                 | Ctrl + A                   | Command + A                         |
| Select Line/Sentence Select Row (in table) | Ctrl + L                   | Command + L                         |
| Delete Row (in table)                      | Ctrl + Shift + Backspace   | Command + Shift + Backspace         |
| Select Style Scope Select Cell (in table)  | Ctrl + E                   | Command + E                         |
| Select Word                                | Ctrl + D                   | Command + D                         |
| Delete Word                                | Ctrl + Shift + D           | Command + Shift + D                 |
| Jump to Top                                | Ctrl + Home                | Command + ↑                         |
| Jump to Selection                          | Ctrl + J                   | Command + J                         |
| Jump to Bottom                             | Ctrl + End                 | Command + ↓                         |
| Find                                       | Ctrl + F                   | Command + F                         |
| Find Next                                  | F3 / Enter                 | Command + G / Enter                 |
| Find Previous                              | Shift + F3 / Shift + Enter | Command + Shift + G / Shift + Enter |
| Replace                                    | Ctrl + H                   | Command + H                         |

### Paragraph

| Function               | Hotkey (Windows/Linux) | Hotkey (macOS)            |
| :--------------------- | :--------------------- | ------------------------- |
| Heading 1 to 6         | Ctrl + 1/2/3/4/5/6     | Command + 1/2/3/4/5/6     |
| Paragraph              | Ctrl + 0               | Command + 0               |
| Increase Heading Level | Ctrl + =               | Command + =               |
| Decrease Heading Level | Ctrl + -               | Command + -               |
| Table                  | Ctrl + T               | Command + Option + T      |
| Code Fences            | Ctrl + Shift + K       | Command + Option + C      |
| Math Block             | Ctrl + Shift + M       | Command + Option + B      |
| Quote                  | Ctrl + Shift + Q       | Command + Option + Q      |
| Ordered List           | Ctrl + Shift + [       | Command + Option + O      |
| Unordered List         | Ctrl + Shift + ]       | Command + Option + U      |
| Indent                 | Ctrl + [ / Tab         | Command + [ / Tab         |
| Outdent                | Ctrl + ] / Shift + Tab | Command + ] / Shift + Tab |

### Format

| Function     | Hotkey (Windows/Linux)                       | Hotkey (macOS)        |
| :----------- | :------------------------------------------- | --------------------- |
| Strong       | Ctrl + B                                     | Command + B           |
| Emphasis     | Ctrl + I                                     | Command + I           |
| Underline    | Ctrl + U                                     | Command + U           |
| Code         | Ctrl + Shift + `       | Command + Shift + ` |                       |
| Strike       | Alt + Shift + 5                              | Control + Shift + `   |
| Hyperlink    | Ctrl + K                                     | Command + K           |
| Image        | Ctrl + Shift + I                             | Command + Control + I |
| Clear Format | Ctrl + \                                     | Command + \           |

### View

| Function                        | Hotkey (Windows/Linux) | Hotkey (macOS)        |
| :------------------------------ | :--------------------- | --------------------- |
| Toggle Sidebar                  | Ctrl + Shift + L       | Command + Shift + L   |
| Outline                         | Ctrl + Shift + 1       | Command + Control + 1 |
| Articles                        | Ctrl + Shift + 2       | Command + Control + 2 |
| File Tree                       | Ctrl + Shift + 3       | Command + Control + 3 |
| Source Code Mode                | Ctrl + /               | Command + /           |
| Focus Mode                      | F8                     | F8                    |
| Typewriter Mode                 | F9                     | F9                    |
| Toggle Fullscreen               | F11                    | Command + Option + F  |
| Actual Size                     | Ctrl + Shift + 0       | *(Not Supported)*     |
| Zoom In                         | Ctrl + Shift + =       | *(Not Supported)*     |
| Zoom Out                        | Ctrl + Shift + -       | *(Not Supported)*     |
| Switch Between Opened Documents | Ctrl + Tab             | Command + `           |
| Toggle DevTools                 | Ctrl + Shift + I       | -                     |

## Change Shortcut Keys

- Users can set or reassign shortcut keys for commands in Typora’s menu bar. This article will shows how to do this.


### macOS

- We use macOS’s system feature to customize Typora’s key binding on macOS.


1. Open `System Preference` → `Keyboard`, select tab `Shortcuts`. Select `App Shortcuts` in its left panel.


2. Click the “+” button, a dialog sheet would pop up. Select “Typora.app” from field `Application`, then enter the exact name of the menu command you want to add, and then type the shortcut key combination you want to assign.

   For example, assume you want to add/change the shortcut key to pin Typora’s window, you can fill the dialog box as follows:
![在这里插入图片描述](https://img-blog.csdnimg.cn/985dcadffd5944f688ef7cf9d407c908.png)


   Then `Command+Shift+P` will be the shortcut key for menu command “always On Top”

### Windows / Linux

> Tip: This requires a version of Typora ≥ v0.9.16.

1. Open `Menu` → `Preference` in Typora, then click “Open Advanced Settings”.



2. Open and edit `conf.user.json` from opened “File Explore”. If there’s no such file, create one.

3. Set or add JSON object which represents a key binding, for example:

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/0e21a83863704c13a6f9766b6d2a5288.png)


4. Restart Typora, and the new key binding will be applied.

You can set or change shortcut keys for menu items in the menu bar in native window style.

#### Q: Shortcut keys does not work on Ubuntu

For solutions to this problem please see:

- https://help.ubuntu.com/community/KeyboardShortcuts and
- https://askubuntu.com/questions/208310/ctrl-a-doesnt-work-in-browsers.