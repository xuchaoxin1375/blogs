

[toc]

## references

- [What’s the Difference Between sh and Bash? | Baeldung on Linux](https://www.baeldung.com/linux/sh-vs-bash)
- [Bash Reference Manual (gnu.org)](https://www.gnu.org/software/bash/manual/bash.html)

## conclusion

- sh 是一类命令行编程语言(满足POSIX标准)
- bash 是sh的一种具体的实现程序
  - sh有其他的实现
  - 个人感觉有点想js和ecma之间的关系

## What Is a Shell?

- A shell is ` a computer program` that takes commands, interprets them, and passes them to the operating system to process.
- So, it’s an interface between the user and the operating system, through which a user can interact with the computer.
- To interact with the shell, we need `a terminal emulator` such as gnome-terminal, konsole, or st.
- Most Linux-based operating systems come with at least one ` shell program`. The shell program will probably be Dash, Bash, or both.

> user->terminal->shell->system

## 查看本机的可用shell程序

- `cat /etc/shells`

## sh

- _sh_ also known as Bourne Shell, is a **command programming language for UNIX-like systems, defined by the POSIX standards** .
- _sh_ can take input from either a ` keyboard` or a ` file` (commonly called a script file).
- On most Linux systems, it’s `implemented by programs` like the original _Bourne Shell_ , _dash_ , and [_ksh_](https://linux.die.net/man/1/ksh).

### sh on POSIX Systems

> POSIX is a family of standards defined by IEEE for vendors to make operating systems compatible. Thus, it helps us develop cross-platform software for multiple operating systems by following a set of guidelines. *sh *conforms to these standards.

- On most Linux systems, _sh_ is a symlink to the actual implementation of Bourne Shell .
- We can verify it through the following command:

> 某些发行版可能需要手动安装 file 命令
>
> - file: Determine type of FILEs.
>   `sudo apt install file`

```bash
$ file -h /bin/sh

/bin/sh: symbolic link to dash
```

- As we can see, the /bin/sh is symbolically linked to dash, which is a POSIX compliant shell used by Debian-based distributions. In shell scripts, we can put the #!/bin/sh, as the first line, which in turn will be executed by dash

## Bash

- Like _sh_ , Bash (Bourne Again Shell) is a command language processor and a shell. It’s the default login shell on most Linux distributions.
- Bash is a superset of sh, which means that Bash supports features of _sh_ and provides more extensions on top of that.

  - Though, most of the commands work similarly as in _sh_ .
- Since the release of Bash, it’s been the de facto shell for Linux operating systems.

## Which One to Use?

- Both shells are useful, and we can leverage them in different situations. For instance, we can use _sh_ if we want our script to be compatible across multiple systems. On the other hand, we might choose Bash because it provides a fluid syntax and more compelling features.
- Nonetheless, we can use Bash and run it in pure POSIX mode if we are paranoid about portability and compatibility. Aside from that, if we write a sh script, it will most likely run on Bash without modification because Bash is backward-compatible with _sh_ .

## bash的常用功能

* 使用 `man bash`可以看到较为完整的bash介绍
* [使用在线文档,方便浏览Bash Reference Manual (gnu.org)](https://www.gnu.org/software/bash/manual/bash.html)

### 引号(单引号/双引号/backquote)

- [Quoting (Bash Reference Manual) (gnu.org)](https://www.gnu.org/software/bash/manual/html_node/Quoting.html)

#### 反引号(Command Substitution)

Command substitution allows the output of a command to replace the command itself. Command substitution occurs when a command is enclosed as follows:

```
$(command)
```

or

```
`command`
```

* Bash performs the expansion by executing command in a subshell environment and replacing the command substitution with the standard output of the command, with any trailing newlines deleted. Embedded newlines are not deleted, but they may be removed during word splitting. The command substitution `$(cat<span> </span><var>file</var>)` can be replaced by the equivalent but faster `$(<<span> </span><var>file</var>)`.

### 元字符

- `$`
- `#`
- (space)

#### 转义

- 对元字符转移,可以阻止shell对字符的特殊解释(当成普通字符来看待)

### 通配

```
       Pattern Matching

       Any  character  that appears in a pattern, other than the special pattern charac‐
       ters described below, matches itself.  The NUL character may not occur in a  pat‐
       tern.   A  backslash  escapes  the following character; the escaping backslash is
       discarded when matching.  The special pattern characters must be quoted  if  they
       are to be matched literally.

       The special pattern characters have the following meanings:

              *      Matches  any  string, including the null string.  When the globstar
                     shell option is enabled, and * is used in a pathname expansion con‐
                     text, two adjacent *s used as a single pattern will match all files
                     and zero or more directories and subdirectories.  If followed by  a
                     /, two adjacent *s will match only directories and subdirectories.
              ?      Matches any single character.
              [...]  Matches  any  one of the enclosed characters.  A pair of characters
                     separated by a hyphen denotes a  range  expression;  any  character
                     that  falls between those two characters, inclusive, using the cur‐
                     rent locale's collating sequence and character set, is matched.  If
                     the first character following the [ is a !  or a ^ then any charac‐
                     ter not enclosed is matched.  The sorting order  of  characters  in
                     range  expressions is determined by the current locale and the val‐
                     ues of the LC_COLLATE or LC_ALL shell variables, if set.  To obtain
                     the traditional interpretation of range expressions, where [a-d] is
                     equivalent to [abcd], set value of the LC_ALL shell variable to  C,
                     or  enable the globasciiranges shell option.  A - may be matched by
                     including it as the first or last character in the set.  A ] may be
                     matched by including it as the first character in the set.

                     Within [ and ], character classes can be specified using the syntax
                     [:class:], where class is one of the following classes  defined  in
                     the POSIX standard:
                     alnum  alpha  ascii blank cntrl digit graph lower print punct space
                     upper word xdigit
                     A character class matches any character belonging  to  that  class.
                     The word character class matches letters, digits, and the character
                     _.

                     Within [ and ], an equivalence class can  be  specified  using  the
                     syntax  [=c=], which matches all characters with the same collation
                     weight (as defined by the current locale) as the character c.

                     Within [ and ], the syntax [.symbol.] matches the collating  symbol
                     symbol.

       If  the extglob shell option is enabled using the shopt builtin, several extended
       pattern matching operators are recognized.  In the following description, a  pat‐
       tern-list is a list of one or more patterns separated by a |.  Composite patterns
       may be formed using one or more of the following sub-patterns:

              ?(pattern-list)
                     Matches zero or one occurrence of the given patterns
              *(pattern-list)
                     Matches zero or more occurrences of the given patterns
              +(pattern-list)
                     Matches one or more occurrences of the given patterns
              @(pattern-list)
                     Matches one of the given patterns
              !(pattern-list)
                     Matches anything except one of the given patterns

       Complicated extended pattern matching against long strings  is  slow,  especially
       when  the patterns contain alternations and the strings contain multiple matches.
       Using separate matches against shorter strings, or using arrays  of  strings  in‐
       stead of a single long string, may be faster.
```

## bash参考手册

* [1 Introduction](https://www.gnu.org/software/bash/manual/bash.html#Introduction)
  * [1.1 What is Bash?](https://www.gnu.org/software/bash/manual/bash.html#What-is-Bash_003f)
  * [1.2 What is a shell?](https://www.gnu.org/software/bash/manual/bash.html#What-is-a-shell_003f)
* [2 Definitions](https://www.gnu.org/software/bash/manual/bash.html#Definitions)
* [3 Basic Shell Features](https://www.gnu.org/software/bash/manual/bash.html#Basic-Shell-Features)
  * [3.1 Shell Syntax](https://www.gnu.org/software/bash/manual/bash.html#Shell-Syntax)
    * [3.1.1 Shell Operation](https://www.gnu.org/software/bash/manual/bash.html#Shell-Operation)
    * [3.1.2 Quoting](https://www.gnu.org/software/bash/manual/bash.html#Quoting)
      * [3.1.2.1 Escape Character](https://www.gnu.org/software/bash/manual/bash.html#Escape-Character)
      * [3.1.2.2 Single Quotes](https://www.gnu.org/software/bash/manual/bash.html#Single-Quotes)
      * [3.1.2.3 Double Quotes](https://www.gnu.org/software/bash/manual/bash.html#Double-Quotes)
      * [3.1.2.4 ANSI-C Quoting](https://www.gnu.org/software/bash/manual/bash.html#ANSI_002dC-Quoting)
      * [3.1.2.5 Locale-Specific Translation](https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation)
    * [3.1.3 Comments](https://www.gnu.org/software/bash/manual/bash.html#Comments)
  * [3.2 Shell Commands](https://www.gnu.org/software/bash/manual/bash.html#Shell-Commands)
    * [3.2.1 Reserved Words](https://www.gnu.org/software/bash/manual/bash.html#Reserved-Words)
    * [3.2.2 Simple Commands](https://www.gnu.org/software/bash/manual/bash.html#Simple-Commands)
    * [3.2.3 Pipelines](https://www.gnu.org/software/bash/manual/bash.html#Pipelines)
    * [3.2.4 Lists of Commands](https://www.gnu.org/software/bash/manual/bash.html#Lists)
    * [3.2.5 Compound Commands](https://www.gnu.org/software/bash/manual/bash.html#Compound-Commands)
      * [3.2.5.1 Looping Constructs](https://www.gnu.org/software/bash/manual/bash.html#Looping-Constructs)
      * [3.2.5.2 Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)
      * [3.2.5.3 Grouping Commands](https://www.gnu.org/software/bash/manual/bash.html#Command-Grouping)
    * [3.2.6 Coprocesses](https://www.gnu.org/software/bash/manual/bash.html#Coprocesses)
    * [3.2.7 GNU Parallel](https://www.gnu.org/software/bash/manual/bash.html#GNU-Parallel)
  * [3.3 Shell Functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)
  * [3.4 Shell Parameters](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters)
    * [3.4.1 Positional Parameters](https://www.gnu.org/software/bash/manual/bash.html#Positional-Parameters)
    * [3.4.2 Special Parameters](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)
  * [3.5 Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)
    * [3.5.1 Brace Expansion](https://www.gnu.org/software/bash/manual/bash.html#Brace-Expansion)
    * [3.5.2 Tilde Expansion](https://www.gnu.org/software/bash/manual/bash.html#Tilde-Expansion)
    * [3.5.3 Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)
    * [3.5.4 Command Substitution](https://www.gnu.org/software/bash/manual/bash.html#Command-Substitution)
    * [3.5.5 Arithmetic Expansion](https://www.gnu.org/software/bash/manual/bash.html#Arithmetic-Expansion)
    * [3.5.6 Process Substitution](https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution)
    * [3.5.7 Word Splitting](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)
    * [3.5.8 Filename Expansion](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)
      * [3.5.8.1 Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)
    * [3.5.9 Quote Removal](https://www.gnu.org/software/bash/manual/bash.html#Quote-Removal)
  * [3.6 Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)
    * [3.6.1 Redirecting Input](https://www.gnu.org/software/bash/manual/bash.html#Redirecting-Input)
    * [3.6.2 Redirecting Output](https://www.gnu.org/software/bash/manual/bash.html#Redirecting-Output)
    * [3.6.3 Appending Redirected Output](https://www.gnu.org/software/bash/manual/bash.html#Appending-Redirected-Output)
    * [3.6.4 Redirecting Standard Output and Standard Error](https://www.gnu.org/software/bash/manual/bash.html#Redirecting-Standard-Output-and-Standard-Error)
    * [3.6.5 Appending Standard Output and Standard Error](https://www.gnu.org/software/bash/manual/bash.html#Appending-Standard-Output-and-Standard-Error)
    * [3.6.6 Here Documents](https://www.gnu.org/software/bash/manual/bash.html#Here-Documents)
    * [3.6.7 Here Strings](https://www.gnu.org/software/bash/manual/bash.html#Here-Strings)
    * [3.6.8 Duplicating File Descriptors](https://www.gnu.org/software/bash/manual/bash.html#Duplicating-File-Descriptors)
    * [3.6.9 Moving File Descriptors](https://www.gnu.org/software/bash/manual/bash.html#Moving-File-Descriptors)
    * [3.6.10 Opening File Descriptors for Reading and Writing](https://www.gnu.org/software/bash/manual/bash.html#Opening-File-Descriptors-for-Reading-and-Writing)
  * [3.7 Executing Commands](https://www.gnu.org/software/bash/manual/bash.html#Executing-Commands)
    * [3.7.1 Simple Command Expansion](https://www.gnu.org/software/bash/manual/bash.html#Simple-Command-Expansion)
    * [3.7.2 Command Search and Execution](https://www.gnu.org/software/bash/manual/bash.html#Command-Search-and-Execution)
    * [3.7.3 Command Execution Environment](https://www.gnu.org/software/bash/manual/bash.html#Command-Execution-Environment)
    * [3.7.4 Environment](https://www.gnu.org/software/bash/manual/bash.html#Environment)
    * [3.7.5 Exit Status](https://www.gnu.org/software/bash/manual/bash.html#Exit-Status)
    * [3.7.6 Signals](https://www.gnu.org/software/bash/manual/bash.html#Signals)
  * [3.8 Shell Scripts](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)
* [4 Shell Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Shell-Builtin-Commands)
  * [4.1 Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)
  * [4.2 Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)
  * [4.3 Modifying Shell Behavior](https://www.gnu.org/software/bash/manual/bash.html#Modifying-Shell-Behavior)
    * [4.3.1 The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)
    * [4.3.2 The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)
  * [4.4 Special Builtins](https://www.gnu.org/software/bash/manual/bash.html#Special-Builtins)
* [5 Shell Variables](https://www.gnu.org/software/bash/manual/bash.html#Shell-Variables)
  * [5.1 Bourne Shell Variables](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Variables)
  * [5.2 Bash Variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)
* [6 Bash Features](https://www.gnu.org/software/bash/manual/bash.html#Bash-Features)
  * [6.1 Invoking Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)
  * [6.2 Bash Startup Files](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)
  * [6.3 Interactive Shells](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shells)
    * [6.3.1 What is an Interactive Shell?](https://www.gnu.org/software/bash/manual/bash.html#What-is-an-Interactive-Shell_003f)
    * [6.3.2 Is this Shell Interactive?](https://www.gnu.org/software/bash/manual/bash.html#Is-this-Shell-Interactive_003f)
    * [6.3.3 Interactive Shell Behavior](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shell-Behavior)
  * [6.4 Bash Conditional Expressions](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)
  * [6.5 Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)
  * [6.6 Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases)
  * [6.7 Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)
  * [6.8 The Directory Stack](https://www.gnu.org/software/bash/manual/bash.html#The-Directory-Stack)
    * [6.8.1 Directory Stack Builtins](https://www.gnu.org/software/bash/manual/bash.html#Directory-Stack-Builtins)
  * [6.9 Controlling the Prompt](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)
  * [6.10 The Restricted Shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell)
  * [6.11 Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)
  * [6.12 Shell Compatibility Mode](https://www.gnu.org/software/bash/manual/bash.html#Shell-Compatibility-Mode)
* [7 Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)
  * [7.1 Job Control Basics](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Basics)
  * [7.2 Job Control Builtins](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins)
  * [7.3 Job Control Variables](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Variables)
* [8 Command Line Editing](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)
  * [8.1 Introduction to Line Editing](https://www.gnu.org/software/bash/manual/bash.html#Introduction-and-Notation)
  * [8.2 Readline Interaction](https://www.gnu.org/software/bash/manual/bash.html#Readline-Interaction)
    * [8.2.1 Readline Bare Essentials](https://www.gnu.org/software/bash/manual/bash.html#Readline-Bare-Essentials)
    * [8.2.2 Readline Movement Commands](https://www.gnu.org/software/bash/manual/bash.html#Readline-Movement-Commands)
    * [8.2.3 Readline Killing Commands](https://www.gnu.org/software/bash/manual/bash.html#Readline-Killing-Commands)
    * [8.2.4 Readline Arguments](https://www.gnu.org/software/bash/manual/bash.html#Readline-Arguments)
    * [8.2.5 Searching for Commands in the History](https://www.gnu.org/software/bash/manual/bash.html#Searching)
  * [8.3 Readline Init File](https://www.gnu.org/software/bash/manual/bash.html#Readline-Init-File)
    * [8.3.1 Readline Init File Syntax](https://www.gnu.org/software/bash/manual/bash.html#Readline-Init-File-Syntax)
    * [8.3.2 Conditional Init Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Init-Constructs)
    * [8.3.3 Sample Init File](https://www.gnu.org/software/bash/manual/bash.html#Sample-Init-File)
  * [8.4 Bindable Readline Commands](https://www.gnu.org/software/bash/manual/bash.html#Bindable-Readline-Commands)
    * [8.4.1 Commands For Moving](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-Moving)
    * [8.4.2 Commands For Manipulating The History](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-History)
    * [8.4.3 Commands For Changing Text](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-Text)
    * [8.4.4 Killing And Yanking](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-Killing)
    * [8.4.5 Specifying Numeric Arguments](https://www.gnu.org/software/bash/manual/bash.html#Numeric-Arguments)
    * [8.4.6 Letting Readline Type For You](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-Completion)
    * [8.4.7 Keyboard Macros](https://www.gnu.org/software/bash/manual/bash.html#Keyboard-Macros)
    * [8.4.8 Some Miscellaneous Commands](https://www.gnu.org/software/bash/manual/bash.html#Miscellaneous-Commands)
  * [8.5 Readline vi Mode](https://www.gnu.org/software/bash/manual/bash.html#Readline-vi-Mode)
  * [8.6 Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)
  * [8.7 Programmable Completion Builtins](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion-Builtins)
  * [8.8 A Programmable Completion Example](https://www.gnu.org/software/bash/manual/bash.html#A-Programmable-Completion-Example)
* [9 Using History Interactively](https://www.gnu.org/software/bash/manual/bash.html#Using-History-Interactively)
  * [9.1 Bash History Facilities](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)
  * [9.2 Bash History Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Builtins)
  * [9.3 History Expansion](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)
    * [9.3.1 Event Designators](https://www.gnu.org/software/bash/manual/bash.html#Event-Designators)
    * [9.3.2 Word Designators](https://www.gnu.org/software/bash/manual/bash.html#Word-Designators)
    * [9.3.3 Modifiers](https://www.gnu.org/software/bash/manual/bash.html#Modifiers)
* [10 Installing Bash](https://www.gnu.org/software/bash/manual/bash.html#Installing-Bash)
  * [10.1 Basic Installation](https://www.gnu.org/software/bash/manual/bash.html#Basic-Installation)
  * [10.2 Compilers and Options](https://www.gnu.org/software/bash/manual/bash.html#Compilers-and-Options)
  * [10.3 Compiling For Multiple Architectures](https://www.gnu.org/software/bash/manual/bash.html#Compiling-For-Multiple-Architectures)
  * [10.4 Installation Names](https://www.gnu.org/software/bash/manual/bash.html#Installation-Names)
  * [10.5 Specifying the System Type](https://www.gnu.org/software/bash/manual/bash.html#Specifying-the-System-Type)
  * [10.6 Sharing Defaults](https://www.gnu.org/software/bash/manual/bash.html#Sharing-Defaults)
  * [10.7 Operation Controls](https://www.gnu.org/software/bash/manual/bash.html#Operation-Controls)
  * [10.8 Optional Features](https://www.gnu.org/software/bash/manual/bash.html#Optional-Features)
* [Appendix A Reporting Bugs](https://www.gnu.org/software/bash/manual/bash.html#Reporting-Bugs)
* [Appendix B Major Differences From The Bourne Shell](https://www.gnu.org/software/bash/manual/bash.html#Major-Differences-From-The-Bourne-Shell)
  * [B.1 Implementation Differences From The SVR4.2 Shell](https://www.gnu.org/software/bash/manual/bash.html#Implementation-Differences-From-The-SVR4_002e2-Shell)
* [Appendix C GNU Free Documentation License](https://www.gnu.org/software/bash/manual/bash.html#GNU-Free-Documentation-License)
* [Appendix D Indexes](https://www.gnu.org/software/bash/manual/bash.html#Indexes)
  * [D.1 Index of Shell Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Builtin-Index)
  * [D.2 Index of Shell Reserved Words](https://www.gnu.org/software/bash/manual/bash.html#Reserved-Word-Index)
  * [D.3 Parameter and Variable Index](https://www.gnu.org/software/bash/manual/bash.html#Variable-Index)
  * [D.4 Function Index](https://www.gnu.org/software/bash/manual/bash.html#Function-Index)
  * [D.5 Concept Index](https://www.gnu.org/software/bash/manual/bash.html#Concept-Index)

Next: [Introduction](https://www.gnu.org/software/bash/manual/bash.html#Introduction), Previous: [(dir)](https://www.gnu.org/software/bash/manual/dir.html#Top), Up: [(dir)](https://www.gnu.org/software/bash/manual/dir.html#Top)   [[Contents](https://www.gnu.org/software/bash/manual/bash.html#SEC_Contents "Table of contents")][[Index](https://www.gnu.org/software/bash/manual/bash.html#Indexes "Index")]
