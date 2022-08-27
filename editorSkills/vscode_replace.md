# vscode replace content partically



### reference

[Case changing in regex replace#](https://code.visualstudio.com/docs/editor/codebasics#_case-changing-in-regex-replace)

### 正则替换

- 实验文本

```
* abc 12_3_4_ To_uPPer
```

- 实验正则式

  - `(\d_)(\d_)\s(\w+)`(匹配被处理文本)

  - `$2$1 \u\L$3`(指示如何操做被匹配了的文本(此处将第一次和第二组组交换,第三组的首字母大写,其余小写))

  ![image-20220404150444655](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220404150444655.png)

### 局部替换

### 方式1

- 键入`ctrl+h`

- 键入要被替换的内容(模式串)

- 选中要被替换处理的文本区域

- 打开`find in selection`功能开关(默认快捷键为`alt+l`)

  > - (只有在上述操作中选中了某一部分区域后)才可以有效的打开该开关
  > - 如果此前已经将开关置于开启状态,则需要将开关切换为关有在开启才是有效的

- 执行替换



### 方式2

- 选中需要替换的文本
- 键入`ctrl+H`(默认的替换按钮)
- 确保`find in selection `功能开启(默认快捷键为`alt+l`)
- 键入要被替换的内容(模式串)
- 键入用于替换旧内容的新串