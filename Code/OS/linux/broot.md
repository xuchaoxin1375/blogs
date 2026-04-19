[toc]

### broot:CLI file explorer

> - 在终端中使用鼠标访问文件的工具
> - 甚至可以预览图片(像素化)

## references&doc

- [Broot (dystroy.org)](https://dystroy.org/broot/)

## 配置文件

### linux

- 进入`broot`,输入`?`滚动导末尾页,可以看到配置文件的路径
  - 一般,位于`~/.config/broot/`目录下

![image-20220630181000648](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220630181000648.png)

### windows

- > [Windows compatibility · Issue #50 · Canop/broot (github.com)](https://github.com/Canop/broot/issues/50)

- windows版本中的帮助命令(`?`)可能和linux版本不同

  - 可以通过键入`:? <enter>`的方式打开帮助(`<enter>`是敲击回车键的意思)

- ![image-20220630192120981](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220630192120981.png)

- 通过键入`esc`退出帮助,返回`broot`浏览系统

- 大概的配置文件目录:

- `%AppData%\dystroy\broot\config`
  - 例如:`C:\Users\userName\AppData\Roaming\dystroy\broot\config`

### 创建新窗格&预览panel

- 使用`ctrl + ->箭头`可以打开一个预览窗格,
  - 如果是从一个目录打开该窗格,那么在新格中输入`enter`就可以打开相应目录
  - 如果是从一个文件出发,打开新窗格,会是一个预览该文件的窗格
  - 通过`ctrl+ <-箭头`在两个窗格内跳转
- 使用`ctrl+ ↑向上箭头`,可以跳转导父目录(也可以用鼠标双击面包屑导航)
  - `ctrl+↓箭头`,可进入当前光标行所指的目录

- ![image-20220630190925710](image/image-20220630190925710.png)

#### 复制光标行所在文件

![image-20220630192009001](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220630192009001.png)

## 皮肤(主题设置)

- [Skins - Broot (dystroy.org)](https://dystroy.org/broot/skins/#white-background-skin)

### 浅色主题皮肤

将一下内容插入导

```json
skin: {
    default: gray(1) None
    tree: gray(7) None / gray(18) None
    parent: gray(5) None / gray(10) None
    file: gray(3) None / gray(8) None
    directory: ansi(25) None Bold / ansi(25) None
    exe: ansi(130) None
    link: Magenta None
    pruning: gray(12) None Italic
    perm__: gray(5) None
    perm_r: ansi(94) None
    perm_w: ansi(132) None
    perm_x: ansi(65) None
    owner: ansi(138) None
    group: ansi(131) None
    dates: ansi(66) None
    sparse: ansi(214) None
    git_branch: ansi(229) None
    git_insertions: ansi(28) None
    git_deletions: ansi(160) None
    git_status_current: gray(5) None
    git_status_modified: ansi(28) None
    git_status_new: ansi(94) None Bold
    git_status_ignored: gray(17) None
    git_status_conflicted: ansi(88) None
    git_status_other: ansi(88) None
    selected_line: None gray(19) / None gray(21)
    char_match: ansi(22) None
    file_error: Red None
    flag_label: gray(9) None
    flag_value: ansi(166) None Bold
    input: gray(1) None / gray(4) gray(20)
    status_error: gray(22) ansi(124)
    status_normal: gray(2) gray(20)
    status_job: ansi(220) gray(5)
    status_italic: ansi(166) gray(20)
    status_bold: ansi(166) gray(20)
    status_code: ansi(17) gray(20)
    status_ellipsis: gray(19) gray(15)
    purpose_normal: gray(20) gray(2)
    purpose_italic: ansi(178) gray(2)
    purpose_bold: ansi(178) gray(2) Bold
    purpose_ellipsis: gray(20) gray(2)
    scrollbar_track: gray(20) none
    scrollbar_thumb: ansi(238) none
    help_paragraph: gray(2) none
    help_bold: ansi(202) none bold
    help_italic: ansi(202) none italic
    help_code: gray(5) gray(22)
    help_headers: ansi(202) none
    help_table_border: ansi(239) None
    preview_title: gray(3) None / gray(5) None
    preview: gray(5) gray(23) / gray(7) gray(23)
    preview_line_number: gray(6) gray(20)
    preview_match: None ansi(29) Underlined
    hex_null: gray(15) None
    hex_ascii_graphic: gray(2) None
    hex_ascii_whitespace: ansi(143) None
    hex_ascii_other: ansi(215) None
    hex_non_ascii: ansi(167) None
    staging_area_title: gray(8) None / gray(13) None
    mode_command_mark: gray(15) ansi(204) Bold
}
```



