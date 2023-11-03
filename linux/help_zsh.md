[toc]

# 在zsh中使用help获取内建命令的帮助

## references

- [How to configure and use aliases in ZSH (linuxhint.com)](https://linuxhint.com/configure-use-aliases-zsh/#:~:text=Global%20aliases%20are%20very%20similar%20to%20simple%20aliases%2C,syntax%20as%3A%20alias%20-g%20%5Balias%5D%20%3D%E2%80%9D%20command%20%E2%80%9D)

## 创建参数化(函数化)别名

```bash
help_bash(){
    bash -c "help $1"
}
alias help="help_bash"
```

- 现在,您可以在zsh中使用 help或者help_bash来获取内置命令的帮助

```bash
# cxxu_kali @ cxxuWin11 in ~ [12:36:23]
$ help pwd
pwd: pwd [-LP]
    Print the name of the current working directory.

    Options:
      -L        print the value of $PWD if it names the current working
                directory
      -P        print the physical directory, without any symbolic links

    By default, `pwd' behaves as if `-L' were specified.

    Exit Status:
    Returns 0 unless an invalid option is given or the current directory
    cannot be read.

# cxxu_kali @ cxxuWin11 in ~ [12:36:28]
$ help_bash pwd
pwd: pwd [-LP]
    Print the name of the current working directory.

    Options:
      -L        print the value of $PWD if it names the current working
                directory
      -P        print the physical directory, without any symbolic links

    By default, `pwd' behaves as if `-L' were specified.

    Exit Status:
    Returns 0 unless an invalid option is given or the current directory
    cannot be read.

```

### 获取alias的命令帮助

```bash
# cxxu_kali @ cxxuWin11 in ~ [12:39:53] C:16
$ help alias
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
