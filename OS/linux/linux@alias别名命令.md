[toc]



## alias

`alias` 是 **Unix/Linux shell（如 Bash、Zsh）中的内建命令**，用于为**已有命令创建简短、易记的别名（nickname）**，从而提高命令行操作效率。

```bash
  which alias
alias: shell built-in command
```

用法手册:由于alias是各个shell内建的命令,不同shell提供的alias或者类似的命令可能有些差别,文档手册的查看方式也有所不同,例如bash和zsh的alias就存在不同,包括帮助的查看和可用的选项

## bash

### 创建别名

bash中内置的alias功能比较简单,仅有一个可选参数`-p`

```bash
[cxxu@CxxuDesk sh]$ help alias
alias: alias [-p] [name[=value] ... ]
    Define or display aliases.

    Without arguments, `alias' prints the list of aliases in the reusable
    form `alias NAME=VALUE' on standard output.

    Otherwise, an alias is defined for each NAME whose VALUE is given.
    A trailing space in VALUE causes the next word to be checked for
    alias substitution when the alias is expanded.

    Options:
      -p        print all defined aliases in a reusable format

    Exit Status:
    alias returns true unless a NAME is supplied for which no alias has been
    defined.
```

以可重用的方式查看已经定义的别名

```bash
root@s3:~# alias -p
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias php74='php74 -c /www/server/php/74/etc/php-cli.ini'
alias pscpu='psm -%cpu'
alias psmem='psm -%mem'
alias pstop='psm -%cpu 10'
```

根据上述文档,`alias`是否携带`-p`的输出结果可能是一样的(命令`alias`和`alias -p`等价)

要可移植地列出所有别名，建议使用 `alias -p`。 

### 移除别名

```bash
unalias: unalias [-a] name [name ...]
    Remove each NAME from the list of defined aliases.

    Options:
      -a        remove all alias definitions

    Return success unless a NAME is not an existing alias.
```



### 别名相关命令速查表

以下是 Bash 别名（alias）相关命令的总结表，方便快速查阅和使用：

| **用途**             | **命令 / 语法**        | **说明**                                      |
| -------------------- | ---------------------- | --------------------------------------------- |
| **定义临时别名**     | `alias name='command'` | 在当前 shell 会话中定义别名，重启终端后失效。 |
| **查看所有别名**     | `alias`                | 列出当前会话中所有已定义的别名。              |
| **查看特定别名**     | `alias name`           | 显示名为 `name` 的别名定义。                  |
| **取消别名**         | `unalias name`         | 删除名为 `name` 的别名。                      |
| **批量取消所有别名** | `unalias -a`           | 删除当前会话中所有别名。                      |



| **用途**             | **命令 / 语法**                                              | **说明**                                                     |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **使别名永久生效**   | 将 `alias name='command'` 添加到 `~/.bashrc` 或 `~/.bash_aliases` | 修改配置文件后需运行 `source ~/.bashrc` 使其立即生效。       |
| **启用别名扩展**     | （默认启用）                                                 | 在交互式 Bash 中默认启用别名；在脚本中默认**不启用**。       |
| **在脚本中使用别名** | `shopt -s expand_aliases`<br>`alias ...`                     | 在脚本开头启用别名扩展（不推荐，建议用函数替代）。           |
| **别名中使用参数**   | **不支持**                                                   | 别名本身不支持参数；若需参数功能，请使用**函数**替代。       |
| **查看别名是否生效** | `type name`                                                  | 显示 `name` 是别名、函数、内置命令还是外部命令。             |
| **避免别名干扰**     | `\command` 或 `'command'` 或 `command`（带路径）             | 临时绕过别名，直接调用原始命令。例如：`\ls`、`'ls'`、`/bin/ls`。 |

---

### 示例：

```bash
# 定义别名
alias ll='ls -l'
alias gs='git status'

# 查看别名
alias ll        # 输出：alias ll='ls -l'

# 删除别名
unalias ll

# 永久保存（加入 ~/.bashrc）
echo "alias ll='ls -l'" >> ~/.bashrc
source ~/.bashrc
```

---

### 注意事项：

- 别名仅在**当前 shell 会话**中有效（除非写入配置文件）。
- **别名不能嵌套参数**，例如 `alias mke='mkdir $1 && cd $1'` 无效（应使用函数）。
- 推荐将别名集中管理在 `~/.bash_aliases` 文件中，并在 `~/.bashrc` 中通过以下方式加载：

  ```bash
  if [ -f ~/.bash_aliases ]; then
      source ~/.bash_aliases
  fi
  ```

---



## zsh

[zsh:  Shell Builtin Commands](https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html#index-alias)

Zsh 将所有内建命令的文档统一放在 `zshbuiltins` 手册中：在命令`man zshbuiltins`的输出中可以找到

### 设置别名

```zsh
  alias [ {+|-}gmrsL ] [ name[=value] ... ]
              For each name with a corresponding value, define an alias with that value.   A  trailing  space  in
              value  causes the next word to be checked for alias expansion.  If the -g flag is present, define a
              global alias; global aliases are expanded even if they do not occur in command position:

                     % perldoc --help 2>&1 | grep 'built-in functions'
                         -f   Search Perl built-in functions
                     % alias -g HG='--help 2>&1 | grep'
                     % perldoc HG 'built-in functions'
                         -f   Search Perl built-in functions

              If the -s flag is present, define a suffix alias: if the command word on a command line is  in  the
              form ‘text.name', where text is any non-empty string, it is replaced by the text ‘value text.name'.
              Note  that  name  is  treated as a literal string, not a pattern.  A trailing space in value is not
              special in this case.  For example,

                     alias -s ps='gv --'

              will cause the command ‘*.ps' to be expanded to ‘gv -- *.ps'.  As alias expansion  is  carried  out
              earlier  than  globbing,  the  ‘*.ps' will then be expanded.  Suffix aliases constitute a different
              name space from other aliases (so in the above example it is still possible to create an alias  for
              the command ps) and the two sets are never listed together.

              For  each  name  with no value, print the value of name, if any.  With no arguments, print all cur‐
              rently defined aliases other than suffix aliases.  If the -m flag is given the arguments are  taken
              as  patterns  (they should be quoted to preserve them from being interpreted as glob patterns), and
              the aliases matching these patterns are printed.  When printing aliases and one of the -g, -r or -s
              flags is present, restrict the printing to global, regular or suffix aliases, respectively; a regu‐
              lar alias is one which is neither a global nor a suffix alias.   Using ‘+' instead of ‘-', or  end‐
              ing the option list with a single ‘+', prevents the values of the aliases from being printed.

              If  the  -L  flag  is  present, then print each alias in a manner suitable for putting in a startup
              script.  The exit status is nonzero if a name (with no value) is given for which no alias has  been
              defined.

              For more on aliases, include common problems, see the section ALIASING in zshmisc(1).
```



### zsh别名类型

Zsh 扩展了传统别名，支持：

| 别名类型                      | 定义方式             | 效果                                 |
| ----------------------------- | -------------------- | ------------------------------------ |
| **普通别名（regular alias）** | `alias ll='ls -l'`   | 类似 Bash，命令开头替换              |
| **全局别名（global alias）**  | `alias -g L='|less'` | 任意位置展开别名                     |
| **后缀别名（suffix alias）**  | `alias -s txt=less`  | 文件名以`.txt`结尾时自动用`less`打开 |

正因为有这三种类型，`alias`,`unalias` 在 Zsh 中需要额外选项来区分创建或删除哪一类。 

### zsh alias基本语法

```zsh
  alias [ {+|-}gmrsL ] [ name[=value] ... ]
```

这里的`name`,`value`是占位符,后续会引用便于说明

对于每个具有对应值的名称 ，定义一个具有该值的别名。 值末尾的空格会导致检查下一个单词是否具有别名扩展。

### 全局别名

如果存在 `-g` 标志，则定义一个**全局别名**；即使全局别名不出现在命令位置，也会进行扩展。

```zsh
# 全局别名：任何地方输入 L 都变成 | less
alias -g L='| less'
# 使用：ps aux L 相当于ps aux | less

```



```zsh
# 不使用别名直接查阅'built-in functions'手册
% perldoc --help 2>&1 | grep 'built-in functions'
    -f   Search Perl built-in functions

#使用alias简化此类命令(定义全局别名)
% alias -g HG='--help 2>&1 | grep' #定义别名HG
% perldoc HG 'built-in functions' #使用别名HG,输出结果和第一个方案相同
    -f   Search Perl built-in functions
```

### 后缀别名

如果存在 `-s` 标志，则定义一个**后缀别名**：如果**命令行上的命令词**采用“ `text.name` ”的形式，其中 `text` 可以是**任何非空字符串**，它会被替换为文本“ `value text.name` ”。

```zsh
alias -s name=value #使得text.name被解释为value text.name
```

例如

```zsh

# 后缀别名：输入 foo.txt 自动用 less 打开,相当于执行less foo.txt,相当于定义指定后缀的文件默认使用指定程序打开
alias -s txt=less
```

这里的`txt`充当语法中的`name`,而`less`充当`value`,在后缀别名用法中,`txt`充当`text`

类似的

```zsh
alias -s log=tail
```

自定义会把`access.log`命令解释为`tail access.log`

请注意， `name` 被视为字面字符串，而不是模式。value 中的尾随空格在这种情况下没有特殊含义。例如，

```zsh
alias -s ps='gv --'
```

这将导致命令“ `*.ps` ”扩展为“ `gv – *.ps` ”。由于别名扩展早于通配符扩展，因此“ `*.ps` ”随后也会被扩展。后缀别名与其他别名构成不同的命名空间（因此在上面的示例中，仍然可以为命令“ `ps` ”创建别名），并且这两组别名永远不会同时列出。

对于每个没有值的名称 ，打印该名称的值（如果有）。如果没有参数，则打印所有当前已定义的别名（后缀别名除外）。如果指定了 `-m` 标志，则参数被视为模式（应使用引号括起来，以防止被解释为 glob 模式），并打印与这些模式匹配的别名。打印别名时，如果指定了 `-g` 、 `-r` 或 `-s` 标志，则分别将打印限制为全局别名、常规别名或后缀别名；常规别名是指既不是全局别名也不是后缀别名的别名。使用 ' `+` ' 代替 ' `-` '，或者以单个 ' `+` ' 结束选项列表，将阻止打印别名的值。

如果存在 `-L` 标志，则以适合放入启动脚本的方式打印每个别名。如果给定一个未定义别名的名称 （没有值 ），则退出状态为非零值。

有关别名的更多信息，包括常见问题，请参阅 [别名 ](https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html#Aliasing)。

### 取消别名|移除别名

```zsh
   unalias [ -ams ] name ...
          Removes  aliases.   This command works the same as unhash -a, except that the -a option removes all
          regular or global aliases, or with -s all suffix aliases: in this case no name  arguments  may  ap‐
          pear.   The  options -m (remove by pattern) and -s without -a (remove listed suffix aliases) behave
          as for unhash -a.  Note that the meaning of -a is different between unalias and unhash.
```

`unalias [ -ams ] name ...`

> 移除别名。此命令与 unhash -a 的功能相同，区别在于 **-a 选项会移除所有常规或全局别名**(不包括后缀别名)，或者使用 **-s 选项移除所有后缀别名**：在这种情况下，可能不会出现 name 参数。
>
> 选项 -m（按模式移除）和 -s（移除列出的后缀别名）的行为与 unhash -a 相同。

请注意，unalias 和 unhash 中 -a 的含义不同。

> 和bash中的unalias不同的是,zsh中的alias支持更细分类的别名移除

`unalias` 命令支持三个选项：`-a`、`-m`、`-s`，后面可跟一个或多个别名名称。

1. **`unalias` 与 `unhash -a` 类似**：
   Zsh 中 `unhash` 用于删除哈希表中的命令路径，而 `unalias` 专用于别名，但某些行为相似。
2. **`-a` 的作用**：
   - **默认**：`unalias -a` 删除 **所有普通别名 + 全局别名**（regular + global）。
   - **配合 `-s`**：`unalias -a -s` 删除 **所有后缀别名（suffix aliases）**。
3. **重要限制**：
   当使用 `-a`（无论是否带 `-s`）时，**不能指定具体别名**！

### Zsh 的 `unalias` 用法速查表

| 命令                    | 作用                                      |
| ----------------------- | ----------------------------------------- |
| `unalias name`          | 删除名为 `name` 的**普通或全局别名**      |
| `unalias -s name`       | 删除名为 `name` 的**后缀别名**            |
| `unalias -a`            | 删除**所有普通 + 全局别名**（不能跟名字） |
| `unalias -a -s`         | 删除**所有后缀别名**（不能跟名字）        |
| `unalias -m 'pattern*'` | 按通配符模式删除普通/全局别名             |
| `unalias -m -s '*.log'` | 按模式删除后缀别名（需同时用 `-m -s`）    |

