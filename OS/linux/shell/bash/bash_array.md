[toc]

# bash_variables/array/编写shell过程，实现复制一个完整目录的功能

## bash variables& expressions

### references

- [Bash 变量 - Bash 脚本教程 - 网道 (wangdoc.com)](https://wangdoc.com/bash/variable.html)
- 

### 获取帮助

- 许多变量相关的命令是bash内建命令(bash中可以使用help查看相关用法和帮助)
- `help declare`
- `man test`
- `man expr`

### 检查变量类型(属性)

- `declare -p <varName>`

  - 配置命令别名(`alias dtype="declare -p"`)

  - > 其实是利用了declare 来检查属性(有些复杂变量有多个属性)

  - ```bash
    #( 04/28/22@ 9:14AM )( cxxu@CxxuWin11 ):~
       a=(1 2 3)
    #( 04/28/22@ 9:14AM )( cxxu@CxxuWin11 ):~
       dtype a
    typeset -a a=( 1 2 3 )
    ```

  - ```bash
    #( 04/28/22@ 9:21AM )( cxxu@CxxuWin11 ):~
    	dtype EPOCHREALTIME
    typeset -Fr EPOCHREALTIME
    ```

  - 




### 条件判断

- [Conditional Constructs:]https://www.gnu.org/software/bash/manual/bash.html#:~:text=%5D-,3.2.5.2%20Conditional%20Constructs,-if

- [Shell 中test `单中括号[\] 双中括号[[]]`](https://www.cnblogs.com/zeweiwu/p/5485711.html)

- 

### test/[ ]判断

- [Linux test Command Tutorial for Beginners (with Examples) (howtoforge.com)](https://www.howtoforge.com/linux-test-command/)

- [Linux test command information and examples (computerhope.com)](https://www.computerhope.com/unix/test.htm)


#### test/[  ]基本情况

> -  ‘test’: Check file types and compare values

- `man test`(获取帮助)

  - test的判断表达式分为4类
  - string

  - integer

  - expression

  - file

> - **test** exits with the status determined by EXPRESSION. 
> - Placing the EXPRESSION between square brackets (**[** and **]**) is the same as testing the EXPRESSION with **test**. 
> - To see the exit status at the command prompt,
>   -  [echo](https://www.computerhope.com/unix/uecho.htm) the value "**$?**" A value of 0 means the expression evaluated as true, and a value of 1 means the expression evaluated as false.

> - 和变量一样,文件也有各种类型

```bash
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:41:03]
└─[0] <> [ a = b ] && echo "equal\!"
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:41:13]
└─[1] <> [ a = a ] && echo "equal\!"
equal!
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:41:18]
└─[0] <> test a = a  && echo "equal\!"
equal!
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:41:36]
└─[0] <> test a = b  && echo "equal\!"


#echo $?

┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:51:26]
└─[130] <> [ a = a ] ;echo $?
0
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:51:35]
└─[0] <> [ a = b ] ;echo $?
1

┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:43:22]
└─[0] <> test 4 -gt 2
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:43:32]
└─[0] <> echo $?
0
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:43:35]
└─[0] <> test 4 -gt 22
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:43:40]
└─[1] <> echo $?
1

#小综合
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:43:41]
└─[0] <> test 100 -gt 99 && echo "Yes, that's true." || echo "No, that's false."
Yes, that's true.
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:45:35]
└─[0] <> test 100 -gt 999 && echo "Yes, that's true." || echo "No, that's false."
No, that's false.

┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-28 10:45:43]
└─[0] <> (test 100 -gt 999 && echo "Yes, that's true.") || echo "No, that's false."
No, that's false.
```

#### 双中括号[[  ]]

> - `[[`可以让检查的表达式更加灵活多样,`||`,`&`能够在`[[ ]]`直接使用,而不仅仅只能链接不同的`[]`表达式

shell 保留字`[[`的相关用例

```bash
┌─[cxxu@CxxuWin11] - [~] - [2022-04-28 01:48:24]
└─[1] <> examples '[['

  [[

  Check file types and compare values.
  
  Returns 0 if the condition evaluates to true, 1 if it evaluates to false.
  More information: https://www.gnu.org/software/bash/manual/bash.html#index-_005b_005b.

  - Test if a given variable is equal/not equal to the specified string:
    [[ $variable ==|!= "string" ]]

  - Test if a given string conforms the specified glob/regex:
    [[ $variable ==|=~ pattern ]]

  - Test if a given variable is [eq]ual/[n]ot [e]qual/[g]reater [t]han/[l]ess [t]han/[g]reater than or [e]qual/[l]ess than or [e]qual to the specified number:
    [[ $variable -eq|ne|gt|lt|ge|le integer ]]

  - Test if the specified variable has a [n]on-empty value:
    [[ -n $variable ]]

  - Test if the specified variable has an empty value:
    [[ -z $variable ]]

  - Test if the specified [f]ile exists:
    [[ -f path/to/file ]]

  - Test if the specified [d]irectory exists:
    [[ -d path/to/directory ]]

  - Test if the specified file or directory [e]xists:
    [[ -e path/to/file_or_directory ]]
```

##### 参考文档

```
[[…]]
[[ expression ]]
Return a status of 0 or 1 depending on the evaluation of the conditional expression expression. Expressions are composed of the primaries described below in Bash Conditional Expressions. Word splitting and filename expansion are not performed on the words between the [[ and ]]; tilde expansion, parameter and variable expansion, arithmetic expansion, command substitution, process substitution, and quote removal are performed. Conditional operators such as ‘-f’ must be unquoted to be recognized as primaries.

When used with [[, the ‘<’ and ‘>’ operators sort lexicographically using the current locale.

When the ‘==’ and ‘!=’ operators are used, the string to the right of the operator is considered a pattern and matched according to the rules described below in Pattern Matching, as if the extglob shell option were enabled. The ‘=’ operator is identical to ‘==’. If the nocasematch shell option (see the description of shopt in The Shopt Builtin) is enabled, the match is performed without regard to the case of alphabetic characters. The return value is 0 if the string matches (‘==’) or does not match (‘!=’) the pattern, and 1 otherwise. Any part of the pattern may be quoted to force the quoted portion to be matched as a string.

An additional binary operator, ‘=~’, is available, with the same precedence as ‘==’ and ‘!=’. When it is used, the string to the right of the operator is considered a POSIX extended regular expression and matched accordingly (using the POSIX regcomp and regexec interfaces usually described in regex(3)). The return value is 0 if the string matches the pattern, and 1 otherwise. If the regular expression is syntactically incorrect, the conditional expression’s return value is 2. If the nocasematch shell option (see the description of shopt in The Shopt Builtin) is enabled, the match is performed without regard to the case of alphabetic characters. Any part of the pattern may be quoted to force the quoted portion to be matched as a string. Bracket expressions in regular expressions must be treated carefully, since normal quoting characters lose their meanings between brackets. If the pattern is stored in a shell variable, quoting the variable expansion forces the entire pattern to be matched as a string.

The pattern will match if it matches any part of the string. Anchor the pattern using the ‘^’ and ‘$’ regular expression operators to force it to match the entire string. The array variable BASH_REMATCH records which parts of the string matched the pattern. The element of BASH_REMATCH with index 0 contains the portion of the string matching the entire regular expression. Substrings matched by parenthesized subexpressions within the regular expression are saved in the remaining BASH_REMATCH indices. The element of BASH_REMATCH with index n is the portion of the string matching the nth parenthesized subexpression.

For example, the following will match a line (stored in the shell variable line) if there is a sequence of characters anywhere in the value consisting of any number, including zero, of characters in the space character class, zero or one instances of ‘a’, then a ‘b’:

[[ $line =~ [[:space:]]*(a)?b ]]
That means values like ‘aab’ and ‘ aaaaaab’ will match, as will a line containing a ‘b’ anywhere in its value.

Storing the regular expression in a shell variable is often a useful way to avoid problems with quoting characters that are special to the shell. It is sometimes difficult to specify a regular expression literally without using quotes, or to keep track of the quoting used by regular expressions while paying attention to the shell’s quote removal. Using a shell variable to store the pattern decreases these problems. For example, the following is equivalent to the above:

pattern='[[:space:]]*(a)?b'
[[ $line =~ $pattern ]]
If you want to match a character that’s special to the regular expression grammar, it has to be quoted to remove its special meaning. This means that in the pattern ‘xxx.txt’, the ‘.’ matches any character in the string (its usual regular expression meaning), but in the pattern ‘"xxx.txt"’ it can only match a literal ‘.’. Shell programmers should take special care with backslashes, since backslashes are used both by the shell and regular expressions to remove the special meaning from the following character. The following two sets of commands are not equivalent:

pattern='\.'

[[ . =~ $pattern ]]
[[ . =~ \. ]]

[[ . =~ "$pattern" ]]
[[ . =~ '\.' ]]
The first two matches will succeed, but the second two will not, because in the second two the backslash will be part of the pattern to be matched. In the first two examples, the backslash removes the special meaning from ‘.’, so the literal ‘.’ matches. If the string in the first examples were anything other than ‘.’, say ‘a’, the pattern would not match, because the quoted ‘.’ in the pattern loses its special meaning of matching any single character.

Expressions may be combined using the following operators, listed in decreasing order of precedence:

( expression )
Returns the value of expression. This may be used to override the normal precedence of operators.

! expression
True if expression is false.

expression1 && expression2
True if both expression1 and expression2 are true.

expression1 || expression2
True if either expression1 or expression2 is true.

The && and || operators do not evaluate expression2 if the value of expression1 is sufficient to determine the return value of the entire conditional expression.
```



## 变量的基本操作

- 创建
- 访问
- 删除

```bash

┌─[cxxu@cxxuAli] - [~] - [2022-04-27 08:33:59]
└─[0] <> a=1
┌─[cxxu@cxxuAli] - [~] - [2022-04-27 08:34:14]
└─[0] <> echo $a
1
┌─[cxxu@cxxuAli] - [~] - [2022-04-27 08:34:31]
└─[0] <> unset a
┌─[cxxu@cxxuAli] - [~] - [2022-04-27 08:34:38]
└─[0] <> echo $a

```
###  数值运算

> - shell 默认将变量作为字符串处理
> - 可以借助一些命令,来改变变量的属性

#### declare

##### references

- [declare Man Page - Linux - SS64.com](https://ss64.com/bash/declare.html)
- (in bash:run `help declare`)

#### expr

- `man expr`

## bash_array

> - bash 脚本和zsh脚本有所不同,如果使用zsh,请切换到bash下执行.
>   - zsh中,数组是从1开始计数(bash是从0开始计数)
>   - bash的关于数组的许多表达式需要{},但是zsh不是必须

### references

- [How to use bash array in a shell script - Scripting Tutorial (linuxconfig.org)](https://linuxconfig.org/how-to-use-arrays-in-bash-script)
- [bash features/Bash Reference Manual (gnu.org)](https://www.gnu.org/software/bash/manual/bash.html#Bash-Features)
- 
  - [variables/Bash Reference Manual (gnu.org)/](https://www.gnu.org/software/bash/manual/bash.html#Shell-Variables)
  - [Arrays/Bash Reference Manual (gnu.org)](https://www.gnu.org/software/bash/manual/bash.html#Arrays) 
- Any element of an array may be referenced using `${name[subscript]}`. 
- **The braces are required** to avoid **conflicts** with <u>the shell’s filename expansion operators</u>.
  -  If the subscript is ‘@’ or ‘*’, the word **expands to all members of the array name**. *
  - *These subscripts differ <u>only when the word appears within double quotes</u>.
    - * If the word is double-quoted, `${name[*]}` expands to **a single word** with the value of each array member **separated** by the first character of the `IFS` variable, 
      * and `${name[@]}` expands each element of name to a separate word. 
      * When there are no array members, `${name[@]}` expands to nothing. 
      * If the **double-quoted** expansion occurs within a word, the expansion of the first parameter is joined with the beginning part of the original word, and the expansion of the last parameter is joined with the last part of the original word. 
      * This is analogous to the expansion of the special parameters `‘@’ and ‘*’.` 
      * `${#name[subscript]}` expands to the length of `${name[subscript]}`. 
      * If subscript is `‘@’ or ‘*’,` the expansion is the number of elements in the array. 
      * If the subscript used to reference an element of an indexed array evaluates to a number less than zero, it is interpreted as relative to one greater than the maximum index of the array, so negative indices count back from the end of the array, and an index of -1 refers to the last element.

#### 数组元素分割符号

### bash_IFS变量以及修改IFS

```bash
echo $IFS|cat -A
echo "查看IFS的定义语句:"

set|grep ^IFS
# 参考IFS原定义方式,修改IFS变量
# IFS=";"
IFS=$';'
echo "检查修改后的IFS值:"
set|grep ^IFS

# echo $IFS|cat -A
```

- IFS 修改效果:见下方脚本

### bash_array参考脚本

#### 检查当前脚本进程号和shell解释器判断

```bash
#!/bin/bash
# 头一行的shebang会影响执行脚本是的命令!
# 本脚本可以用于验证这一点
## 请使用bash 运行本脚本(或者在其他shell中通过bash ./scriptName 来让bash 执行本文件)
# test
echo $0
echo $SHELL
# pgrep bash
# pgrep zsh
# pgrep sh

echo "current process id :$$"
echo "grep the pid:"
# ps ax|grep -E "^\s*$$";echo $?
echo "---check the current process ,check the shell interpreter"
long_name=$(ps ax|grep -E "^\s*$$";echo $?)
echo $long_name
# 简单处理,指定显示comm(仅显示可执行程序命令名: command name (only the executable name).  Modifications to the command name will not be shown.)
# args 命令全名+参数
id=$(ps -p `echo $$` -o args="" )
echo "----------"
echo $id
# psh ax|grep "$$"

# [[ $0 != *bash && $SHELL != *bash ]]
[[ $id != */bash* ]] && echo "😊😊请使用bash 运行本脚本(或者在其他shell中通过bash ./scriptName 来让bash 执行本文件)"
# 定义indexed array(隐式定义)
a=(1 2 3 4 "test")
# 显示定义associative array(类似于字典dict/hashtable)
declare -A aa
aa=([k0]=v0 [k00]=v00)
# 追加条目到数组
a+=(a1 a2)
aa+=([k1]=v1 [k2]=v2)
# 访问数组元素
## 访问
echo "access a[1]=${a[1]}"
echo "access aa[k1]=${aa[k1]}"
# echo ${aa[k1]}

# cat - concatenate files and print on the standard output
# ========================================================

#       -E, --show-ends
#               display $ at end of each line

#       -T, --show-tabs
#               display TAB characters as ^I

#       -v, --show-nonprinting
#               use ^ and M- notation, except for LFD and TAB
echo $IFS|cat -A
echo "查看IFS的定义语句:"

set|grep ^IFS
# 参考IFS原定义方式,修改IFS变量
# IFS=";"
IFS=$';'
echo "检查修改后的IFS值:"
set|grep ^IFS

# echo $IFS|cat -A


echo ${a[*]}
echo "当使用双引号的时候,*和@的区别就显现出来了"
echo "[*]使得数组中的元素通过IFS指定的分隔符链接起来,成为一个串"
echo "${a[*]}"

echo "a[@]"
echo ${a[@]}
echo "[@]在使用双引号和不用双引号效果一样"
echo "${a[@]}"

echo "查看字典中的所有值(value)"
echo "aa[*]:"
echo ${aa[*]}

echo "aa[@]:"
echo ${aa[@]}

echo "\"aa[*]\":"
echo "${aa[*]}"

echo "\"aa[@]\":"
echo "${aa[@]}"
# echo ${aa[@]}

echo "traverse the items of a[@]:"
for item in ${a[@]};
do
    echo $item;
done
echo "by a[*]"
for item in ${a[*]};
do echo $item;
done

echo "aa[@]"
for item in ${aa[@]}
do echo "$item";
done

echo "${!aa[@]},check key=value pairs!"
for key in ${!aa[@]}
do echo "$key=${aa[$key]}";
done

```



- 和python/c等语言不同,bash默认只用空格作为元素分割符,而不用`,`分割

## scripts arguments & system variables

### references

- [Shell Script Parameters | Examples & Advantages | Rules and Regulations (educba.com)](https://www.educba.com/shell-script-parameters/)



## 小综合案例

### 递归复制目录(不使用-R选项)

```bash
#!/bin/bash

recursive_copy_file()
{
    dirlist=$(ls $1)
    # 如果目标目录不存在,则创建相应目录
    [ ! -d $2 ] && mkdir -p $2;
    for name in ${dirlist[@]}
    do
        # if: if COMMANDS; then COMMANDS; [ elif COMMANDS; then COMMANDS; ]... [ else COMMANDS; ] fi
        # 如果是文件，
        if [ -f $1/$name ]; then
            #并且$2不存在该文件，则直接copy
            if [ ! -f $2/$name ]; then
                cp $1/$name $2/$name
            fi
            # 如果检查$1/path到是目录，并且$2/不存在该目录，则先创建目录$2/..
        elif [ -d $1/$name ];
        then
            # 嵌套if
            # if [ ! -d $2/$name ];
            # then
            #     # 创建对应的目录
            #     mkdir -p $2/$name
            # fi
            # 简化:
            [ ! -d $2/$name ] && mkdir -p $2/$name
            # 递归拷贝
            recursive_copy_file $1/$name $2/$name
        fi
    done
}

# source_dir="/home/cxxu/sedLearn"
# dest_dir="/home/cxxu/sedLearn_bak"
echo $1 $2
tree $1
# recursive_copy_file $source_dir $dest_dir
recursive_copy_file $1 $2
echo "copy completed! check the copyed dir..."
tree $2	

```

![image-20220428123458453](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220428123458453.png)





