[toc]

## abstract

习惯了 Bash 的用户在切换到 Zsh 时，往往会下意识地输入 `help <command>`，结果却收到 `command not found` 的冷遇。

------

## 1. 核心原因：实现方式的差异

在 Bash 中，`help` 是一个**内置命令**，专门用于查看 Shell **内建命令（Builtins）**的简易文档。

- **Bash：** 将文档直接嵌入到了二进制文件中。当你输入 `help cd` 时，Bash 直接从自己的“身体”里读出那段预存的说明文字。
- **Zsh：** 追求的是极致的可定制化和模块化。它不倾向于把大量的文本说明硬编码在 Shell 程序本身，以此来保持核心程序的精简。

------

## 2. Zsh 的替代方案

虽然没有 `help` 命令，但 Zsh 提供了更强大（但也更复杂）的工具来实现类似甚至更高级的功能：

### `run-help`：功能最接近的替代品

Zsh 实际上自带了一个强大的辅助工具叫 `run-help`。它不仅能看内建命令，还能看外部命令的 Manual。

```zsh
#( 04/21/26@ 9:16AM )( root@s3 ):~
   run-help run-help
run-help is a shell function from /usr/share/zsh/functions/Misc/run-help
```

**如何开启？**

默认情况下,`run-help`是zsh提供的一个函数:

```zsh
#( 04/21/26@ 9:22AM )( root@s3 ):~
   type run-help
run-help is a shell function from /usr/share/zsh/functions/Misc/run-help
```

你需要在 `.zshrc` 中添加额外的配置:

```zsh
alias help=run-help 
# 或者
alias help=\run-help
```



或者使用`\`修饰:`\run-help <command>`,例如`\run-help read`

> 在 Zsh 或 Bash 中，在命令前面加上反斜杠（例如 `\ls` 或 `\cd`）是一个非常实用且“硬核”的小技巧。
>
> 它的核心作用是：**禁用别名（Alias），强制执行原始命令。**
>
> **如果你在命令前面加上反斜杠 `\ls`：** Shell 会跳过别名检查，直接去环境变量 `$PATH` 中寻找名为 `ls` 的二进制可执行文件。
>
> 这在你怀疑别名有 Bug，或者想临时避开别名自带的参数（比如不想让 `rm` 弹出确认提示）时非常有用。

```zsh
 
   read [ -rszpqAclneE ] [ -t [ num ] ] [ -k [ num ] ] [ -d delim ]
     [ -u n ] [ [name][?prompt] ] [ name ...  ]
       Read  one  line and break it into fields using the characters in
       $IFS as separators, except as noted below.  The first  field  is
       assigned to the first name, the second field to the second name,
       etc.,  with  leftover fields assigned to the last name.  If name
       is omitted then REPLY is used for scalars and reply for arrays.
...
```



但是和 Bash 不同,使用 `help <命令>` 并不是查找内置命令的帮助,而是外部命令的帮助。

例如`pwd`命令

```zsh
   type -a pwd
pwd is a shell builtin
pwd is /usr/sbin/pwd
pwd is /usr/bin/pwd
pwd is /sbin/pwd
pwd is /bin/pwd
```

这里pwd既是shell内置命令,又有外部单独的实现,`run-help`查询结果实际上是外部帮助;

### 快捷键：`Alt + h` (Esc + h)

这是 Zsh 的一个“神技”。当你输入了一个命令（例如 `rsync`）但突然忘了参数，不需要删除整行去查手册。只需按下 **`Alt + h`**，Zsh 会自动为你调出该命令的帮助文档，看完后按 `q` 退出，你刚才输入的命令依然静静地待在命令行里。

------

## 3. 为什么 Zsh 推荐使用 `man`？

Zsh 的开发者认为，与其维护一套 Shell 特有的简易文档（像 Bash 的 help），不如直接让用户去读标准的 **Man Page**。

Zsh 的内建命令文档通常都集成在 `man zshbuiltins` 中。

如果你觉得这个文档太长，难以定位，可以安装更加现代化的工具，这也是现在很多 Zsh 用户的首选：

- **tldr(tlrc) / cheat.sh：** 提供命令的最常用示例，比 Bash 的 `help` 更直观。
  - *用法：* `tldr tar`
- **zsh-help：** 一些插件管理器（如 Oh My Zsh）提供的增强脚本。

------

## 总结对比

| **特性**     | **Bash help**                   | **Zsh run-help**           |
| ------------ | ------------------------------- | -------------------------- |
| **查询范围** | 仅限 Shell 内建命令             | 内建命令 + 外部命令 + 别名 |
| **内容来源** | 硬编码在 Shell 内部             | 关联 Man pages 及外部文件  |
| **实时性**   | 较差（更新 Shell 才能更新内容） | 较好（随系统 Manual 更新） |



