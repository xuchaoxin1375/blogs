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

> 注意,许多zsh功能和插件较新版本的zsh上才能达到最佳的使用体验;
>
> 例如zsh5.9版本或更新的版本;并且尽量避免和系统包管理器安装的zsh版本共存,否则有些行为可能出乎意料;
>
> 例如`run-help`的默认行为可能和下面所说的不一样,有的补全插件给出的补全菜单也可能不同(尤其是对变量的预览,zsh-autocomplete影响较大)

### `run-help`：功能最接近的替代品

Zsh 实际上自带了一个强大的辅助工具叫 `run-help`。它不仅能看内建命令，还能看外部命令的 Manual。

```zsh
#( 04/21/26@ 9:16AM )( root@s3 ):~
   run-help run-help
run-help is a shell function from /usr/share/zsh/functions/Misc/run-help

# 根据系统的差异,还有可能显示为:
$ type -a run-help
run-help is an alias for man
```

可以看到`run-help`可能是一个zsh函数,也可能是`man`的别名;

> `/usr/share/zsh/functions/Misc/run-help` 是 zsh 自带的一个**高级脚本函数**。它比 `man` 聪明得多：
>
> - **识别内建命令**：如果你查 `cd`，它会自动跳转到 `zshbuiltins` 手册的对应章节。
> - **处理复杂命令**：它能识别 zsh 特有的语法和模块。
> - 识别外部命令: 例如获取git的man帮助.

下面到片段可以强制将`run-help`定义为zsh的帮助函数而不是`man`的别名;

> 最后将`run-help`定义一个别名`help`,甚至是代替`man`,从而同时实现查询zsh内部和外部命令(自动判断并查询命令.)

```zsh
# 为设置zsh设置help命令(对于bash,zsh混用用户友好)
unalias run-help 2> /dev/null
# 如果系统路径里找不到，可以手动把函数路径加入 fpath 数组（可选）
# [[ -d /usr/share/zsh/functions/Misc ]] && fpath=(/usr/share/zsh/functions/Misc $fpath) 
autoload -Uz run-help
alias help=run-help
```

之后，你就可以像在 Bash 中一样使用 `help <命令>` 了。

甚至在相关插件的帮助在,可以执行如下风格的命令帮助

```bash
 run-help git checkout
 # 或(设置run-help的别名的情况下)
 help git checkout
```



### 快捷键：`Alt + h` (Esc + h)

这是 Zsh 的一个“神技”。当你输入了一个命令（例如 `rsync`）但突然忘了参数，不需要删除整行去查手册。只需按下 **`Alt + h`**，Zsh 会自动为你调出该命令的帮助文档，看完后按 `q` 退出，你刚才输入的命令依然静静地待在命令行里。

------

## 3. 为什么 Zsh 推荐使用 `man`

Zsh 的开发者认为，与其维护一套 Shell 特有的简易文档（像 Bash 的 help），不如直接让用户去读标准的 **Man Page**。

Zsh 的内建命令文档通常都集成在 `man zshbuiltins` 中。



------

## 总结对比

| **特性**     | **Bash help**                   | **Zsh run-help**           |
| ------------ | ------------------------------- | -------------------------- |
| **查询范围** | 仅限 Shell 内建命令             | 内建命令 + 外部命令 + 别名 |
| **内容来源** | 硬编码在 Shell 内部             | 关联 Man pages 及外部文件  |
| **实时性**   | 较差（更新 Shell 才能更新内容） | 较好（随系统 Manual 更新） |



