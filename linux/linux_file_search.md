[toc]

# linux_file_search:文件/目录搜索:find/ls/locate/grep使用案例:ls+grep/find -type -maxdepth仅显示文件/仅显示目录

## ls

> - `ls+grep`
>
> - 该方案采用的是从全部列表中筛选的方式

- 例如,搜索当前目录下的名字包含`thre` 文件或者目录

```bash
#( 05/01/22@ 5:54PM )( cxxu@cxxuAli ):~/cppCodes@master✗✗✗
   ls -l |grep pthre
drwxrwxr-x  2 cxxu cxxu   4096 May  1 17:51 pthreads
```

### ls -p 配合grep,仅显示目录

- [How to List only Directories in Linux ls Command? (configserverfirewall.com)](https://www.configserverfirewall.com/linux-tutorials/list-only-directories-linux/#:~:text=The ls command which is used to list,will list directories under the current working directory.)

- https://askubuntu.com/questions/811210/how-can-i-make-ls-only-display-files

- ```bash
  cxxu@cxxuAli:~/cppCodes$ ls -p|grep pthre.*/
  pthreads/
  cxxu@cxxuAli:~/cppCodes$ ls -pl|grep pthre.*
  drwxrwxr-x  2 cxxu cxxu   4096 May  1 17:51 pthrea.*/
  ```

### ls -p 配合多重`grep -v`,仅显示文件

- ```bash
  cxxu@cxxuAli:~/cppCodes$ ls -pl|grep -v '.*/'|grep pthre.*
  -rw-rw-r--  1 cxxu cxxu      0 May  1 20:56 pthreaa
  ```

  

### 可以配置别名

- > - 不需要显示隐藏文件,那么可以去掉`-a`
  >
  > - 反之,则为`ls`添加`-a`
  > - 是否显示详细信息,也可以通过添加/删除`-l`选项调整

- `alias lsdir="ls -lpa | grep '.*/'"`

- ```BASH
  ┌─[cxxu@CxxuWin11] - [/mnt/c/users/cxxu] - [2022-05-01 09:11:04]
  └─[0] <> lsdir
  drwxrwxrwx 1 cxxu cxxu     512 May  1 18:18 ./
  dr-xr-xr-x 1 cxxu cxxu     512 Mar 31 14:45 ../
  drwxrwxrwx 1 cxxu cxxu     512 Feb 20 14:12 AppData/
  drwxrwxrwx 1 cxxu cxxu     512 Mar  4 10:44 aurora/
  drwxrwxrwx 1 cxxu cxxu     512 Apr 25 09:08 .cheat/
  ```

- `alias lsfile="ls -pl|grep -v '.*/'"`

## find

> - 专业的搜索工具
>   - 不仅可以模糊搜索,还可以根据时间/文件大小的属性来过滤搜索

- 例如,搜索当前目录下的名字包含`thre` 文件或者目录

```bash
#( 05/01/22@ 5:55PM )( cxxu@cxxuAli ):~/cppCodes@master✗✗✗
   find . -name *thre* 
./pthreads
```

### find示例

```bash
  find

  Find files or directories under the given directory tree, recursively.
  More information: https://manned.org/find.

  - Find files by extension:
    find root_path -name '*.ext'

  - Find files matching multiple path/name patterns:
    find root_path -path '**/path/**/*.ext' -or -name '*pattern*'

  - Find directories matching a given name, in case-insensitive mode:
    find root_path -type d -iname '*lib*'

  - Find files matching a given pattern, excluding specific paths:
    find root_path -name '*.py' -not -path '*/site-packages/*'

  - Find files matching a given size range:
    find root_path -size +500k -size -10M

  - Run a command for each file (use {} within the command to access the filename):
    find root_path -name '*.ext' -exec wc -l {} \;

  - Find files modified in the last 7 days and delete them:
    find root_path -daystart -mtime -7 -delete

  - Find empty (0 byte) files and delete them:
    find root_path -type f -empty -delete


# To find files by case-insensitive extension (ex: .jpg, .JPG, .jpG):
find . -iname "*.jpg"

# To find directories:
find . -type d

# To find files:
find . -type f

# To find files by octal permission:
find . -type f -perm 777

# To find files with setuid bit set:
find . -xdev \( -perm -4000 \) -type f -print0 | xargs -0 ls -l

# To find files with extension '.txt' and remove them:
find ./path/ -name '*.txt' -exec rm '{}' \;

# To find files with extension '.txt' and look for a string into them:
find ./path/ -name '*.txt' | xargs grep 'string'

# To find files with size bigger than 5 Mebibyte and sort them by size:
find . -size +5M -type f -print0 | xargs -0 ls -Ssh | sort -z

# To find files bigger than 2 Megabyte and list them:
find . -type f -size +200000000c -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'

# To find files modified more than 7 days ago and list file information:
find . -type f -mtime +7d -ls

# To find symlinks owned by a user and list file information:
find . -type l -user <username-or-userid> -ls

# To search for and delete empty directories:
find . -type d -empty -exec rmdir {} \;

# To search for directories named build at a max depth of 2 directories:
find . -maxdepth 2 -name build -type d

# To search all files who are not in .git directory:
find . ! -iwholename '*.git*' -type f

# To find all files that have the same node (hard link) as MY_FILE_HERE:
find . -type f -samefile MY_FILE_HERE 2>/dev/null

# To find all files in the current directory and modify their permissions:
find . -type f -exec chmod 644 {} \;
```

## locate

> - linux界的everthing
> - 全盘搜索(除了特殊目录)
> - 使用前建议手动更新以下数据库,以便能够检索最近变化的文件
>   - `sudo updatedb`
> - 使用注意:
>   - Not all files get included in the database used by `locate`. 
>   - Only those that can be seen by the world (i.e. those files where every parent directory has the
>     world permission set to readable). F
>   - or this reason it is most reliably used to find system files.

### 相关使用案例

```bash
  locate

  Find filenames quickly.
  More information: https://manned.org/locate.

  - Look for pattern in the database. Note: the database is recomputed periodically (usually weekly or daily):
    locate pattern

  - Look for a file by its exact filename (a pattern containing no globbing characters is interpreted as *pattern*):
    locate */filename

  - Recompute the database. You need to do it if you want to find recently added files:
    sudo updatedb


No cheatsheet found for 'locate'.
# locate

find a file where any part of path matches foo

    locate foo


find a file where only the base file name itself, not the path, matches foo

    locate -b foo


ignore case

    locate -i FoO


count the number of files that match foo

    locate -c foo



# Basic Usage

`locate` uses a database to quickly find files matching a pattern:

    locate <pattern>





# Building the Database

`locate` relies on a database. Usually the system builds automatically, but it
may need to be initialized or updated manually.



## OSX 10.9

Update the database:

    $ cd /
    $ sudo /usr/libexec/locate.updatedb



## Linux

Update the database:

    sudo updatedb
```

## 通用过滤工具grep以及其使用案例(by tldr&cheat&eg)

```bash
  grep

  Find patterns in files using regular expressions.
  More information: https://www.gnu.org/software/grep/manual/grep.html.

  - Search for a pattern within a file:
    grep "search_pattern" path/to/file

  - Search for an exact string (disables regular expressions):
    grep --fixed-strings "exact_string" path/to/file

  - Search for a pattern in all files recursively in a directory, showing line numbers of matches, ignoring binary files:
    grep --recursive --line-number --binary-files=without-match "search_pattern" path/to/directory

  - Use extended regular expressions (supports ?, +, {}, () and |), in case-insensitive mode:
    grep --extended-regexp --ignore-case "search_pattern" path/to/file

  - Print 3 lines of context around, before, or after each match:
    grep --context|before-context|after-context=3 "search_pattern" path/to/file

  - Print file name and line number for each match:
    grep --with-filename --line-number "search_pattern" path/to/file

  - Search for lines matching a pattern, printing only the matched text:
    grep --only-matching "search_pattern" path/to/file

  - Search stdin for lines that do not match a pattern:
    cat path/to/file | grep --invert-match "search_pattern"


# To search a file for a pattern:
grep <pattern> <file>

# To perform a case-insensitive search (with line numbers):
grep -in <pattern> <file>

# To recursively grep for string <pattern> in <dir>:
grep -R <pattern> <dir>

# Read search patterns from a file (one per line):
grep -f <pattern-file> <file>

# Find lines NOT containing pattern:
grep -v <pattern> <file>

# Set how many lines to show before (-B) and after (-A) pattern:
grep -B 3 -A 2 <pattern> <file>

# To grep with regular expressions:
grep "^00" <file>                                               # Match lines starting with 00
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" <file> # Find IP add

# To find all files that match <pattern> in <dir>
grep -rnw <dir> -e <pattern>

# To exclude grep from your grepped output of ps:
# (Add [] to the first letter. Ex: sshd -> [s]shd)
ps aux | grep '[h]ttpd'

# Colour in red {bash} and keep all other lines
ps aux | grep -E --color 'bash|$'

# grep

print all lines containing foo in input.txt

    grep "foo" input.txt


print all lines matching the regex "^start" in input.txt

    grep -e "^start" input.txt


print all lines containing bar by recursively searching a directory

    grep -r "bar" directory


print all lines containing bar ignoring case

    grep -i "bAr" input.txt


print 3 lines of context before and after each line matching "foo"

    grep -C 3 "foo" input.txt



# Basic Usage

Search each line in `input_file` for a match against `pattern` and print
matching lines:

    grep "<pattern>" <input_file>



# Find Lines NOT Matching

Print lines that do NOT match a pattern by using the `-v` flag. This will print
all lines that do NOT contain a z (`-v "z"`):

    grep -v "z" input.txt



# Print File Names

Show only the file names containing matches, rather than the matching lines
themselves, by using the `-l` flag:

    grep -r -l "target_pattern" directory


Show only the file names that do NOT contain matches by using the `-L` flag:

    grep -r -L "unwanted_pattern" directory



# Regular Expressions and `egrep`

Regular expressions can be passed to `grep` using the `-e` flag. `egrep` is
equivalent to using the `-e` flag.

The following file is used in the examples:

    $ cat input.txt
    1 2 3
    omega
    alpha foo
    alpha bar
    baz omega
    4 5 6


Match lines beginning (`^`) with `alpha` (`^alpha`):

    $ grep -e "^alpha" input.txt
    alpha foo
    alpha bar


Match lines ending (`$`) with `omega` (`omega$`):

    $ grep -e "omega$" input.txt
    omega
    baz omega


Match any line containing `a` and `o` separated by 0 or more characters (`.*`):

    $ grep -e "a.*o" input.txt
    alpha foo
    baz omega


Match any line containing `z` or `f` (`[zf]`):

    $ grep -e "[zf]" input.txt
    alpha foo
    baz omega


Match any line containing `hello` or `world`:

    $ grep "hello\|world" input.txt
    hello alpha
    omega world


Match all lines with lower case or capital letters a through z (`[a-zA-Z]`):

    $ grep -e "[a-zA-Z]" input.txt
    omega
    alpha foo
    alpha bar
    baz omega


Match all lines containing numbers (`[0-9]`):

    $ grep -e "[0-9]" input.txt
    1 2 3
    4 5 6


Match all lines containing white space (`[[:space:]]`):

    $ grep -e "[[:space:]]" input.txt
    1 2 3
    alpha foo
    alpha bar
    baz omega
    4 5 6


# Fixed Expressions and `fgrep`

`fgrep` is faster than `grep` and `egrep` but only accepts fixed expressions.
This will match lines containing the exact sequence `.*` (`'.*'`). Quoting is
used to prevent shell expansion of the wildcard `*` character:

    fgrep '.*' input.txt



# Searching Compressed Files

`zgrep`, `zegrep`, and `zfgrep` act exactly like `grep`, `egrep`, and `fgrep`,
but they operate on compressed and gzipped files. The same examples shown above
will function with the `z*grep` utilities.
```

### egrep 案例

```bash
┌─[cxxu@CxxuWin11] - [~/.config/cheat] - [2022-05-01 08:52:01]
└─[0] <> egs egrep

  egrep

  Find patterns in files using extended regular expression (supports ?, +, {}, () and |).
  More information: https://manned.org/egrep.

  - Search for a pattern within a file:
    egrep "search_pattern" path/to/file

  - Search for a pattern within multiple files:
    egrep "search_pattern" path/to/file1 path/to/file2 path/to/file3

  - Search stdin for a pattern:
    cat path/to/file | egrep search_pattern

  - Print file name and line number for each match:
    egrep --with-filename --line-number "search_pattern" path/to/file

  - Search for a pattern in all files recursively in a directory, ignoring binary files:
    egrep --recursive --binary-files=without-match "search_pattern" path/to/directory

  - Search for lines that do not match a pattern:
    egrep --invert-match "search_pattern" path/to/file
```

