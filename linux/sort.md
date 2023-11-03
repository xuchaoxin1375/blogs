@[toc]
## references

- [Linux sort Command | Guide to How does Linux Sort Command Works (educba.com)](https://www.educba.com/linux-sort-command/)
- [SORT command in Linux/Unix with examples](https://www.geeksforgeeks.org/sort-command-linuxunix-examples/)

## conclusion

- 一般sort的 `-n`,`-k`,`-o` ,和  `-r`选项使用的较多
  - 将数字字符串解析为数值排序,
  - 按列排序,
  - 倒序排序
  - 输出排序结果到文件
- sort排序不会直接影响源文件
- 

## Introduction to Linux sort Command

* The Linux Sort command is assuming the input contents in ASCII format accordingly it will sort (`the files` and `the arranging the records` )`in giving specific order.`
* It is a command-line utility to sort the lines from input files. The sort command is also supporting the reverse order sorting, number sorting, month sorting, alphabetical sorting, etc.

NAME
       sort - sort lines of text files

## How does Linux Sort Command work?

The Linux Sort command or utility is getting the input data from FILE and sort the output data as per the sorting rules as well as the flag option in the sort command. The sort command sorting the input data line by line.

There are three rules for sorting:

1. The output line starts with a number that will display first as compare to character or letter.
2. The output line starts with an earlier letter alphabet it will display first.
3. The output line will display lowercase letters will display first.

### sort:output to file

> sort -o

```
#被排序文件:
cxxu_kali➜d/repos/os_codes» nl toBeSortFile                                     [14:43:47]
     1  Hello
     2  Abc
     3  abc
     4  pqrs
     5  ASDqw
     6  123
     7  xyz
# 排序输出到文件
cxxu_kali➜d/repos/os_codes» sort -o sortedFile TobeSortedFile                             [14:42:12]
### 查看输出结果
cxxu_kali➜d/repos/os_codes» nl sortedFile                                       [14:43:19]
     1  123
     2  abc
     3  Abc
     4  ASDqw
     5  Hello
     6  pqrs
     7  xyz
```

### sort:reverse

`sort -r`

```bash

cxxu_kali➜d/repos/os_codes» sort -r toBeSortFile                                [14:43:51]
xyz
pqrs
Hello
ASDqw
Abc
abc
123
```

### Sort with “-k” option

In Sort command, we can sort the data on the column level.

We can use the “-k” option and the column number in the Sort command to sort the column level sorting.

```bash
cxxu_kali➜d/repos/os_codes» nl colToBeSort                                      [14:56:34]
     1  c 88
     2  b 26
     3  d 99
     4  g 56
     5  j 34
     6  h 10
```

排序效果(指定第二列为排序键)

```bash
cxxu_kali➜d/repos/os_codes» sort -k2 colToBeSort                                [14:57:24]
h 10
b 26
j 34
g 56
c 88
d 99
```

## 将数字和时间单词以及文件大小字符串解析为整体进行比较

### sort command with the “-n” option

* **-n Option** : To sort a file **numerically** used –n option.
* -n option is also predefined in Unix as the above options are.
* This option is used to sort the file with numeric data present inside.
* In the Linux Sort command, we can sort the input data `as per按照；根据` the `numeric value`.

We need to use the “-n” option in the Sort command

**Command :**

```
# cxxu_kali @ cxxuWin11 in /mnt/d/repos/os_codes [21:05:35]
$ cat > tobeSortN
15
39
50
89
200

# cxxu_kali @ cxxuWin11 in /mnt/d/repos/os_codes [21:07:11]
$ sort -n tobeSortN
15
39
50
89
200
# 默认情况下是将内容视为以字符串进行排序,使用-n,则将数字字符串(数字字符视为相对独立的字符)视为数量数值(带权)进行比较
# cxxu_kali @ cxxuWin11 in /mnt/d/repos/os_codes [21:07:18]
$ sort  tobeSortN
15
200
39
50
89
#以上排序结果是1<2<3<5<8
```

#### sort with “-nr” option

* In the Linux Sort command, we can sort the input data as per the numeric value but in reverse format.
* We need to use the “-nr” option in the Sort command.

```bash
# cxxu_kali @ cxxuWin11 in /mnt/d/repos/os_codes [21:07:29]
$ sort tobeSortN -nr
200
89
50
39
15
```

#### Sort  with “-M” option

* In Linux Sort command, we are having the functionality to sort the input month name in month ascending order.
* To get the list of the month in ascending order we need to use the “-M” option with the sort command.

```bash
# cxxu_kali @ cxxuWin11 in /mnt/d/repos/os_codes [21:15:28]
$ cat > toBeSortMonthNames
February
January
March
August
September

# cxxu_kali @ cxxuWin11 in /mnt/d/repos/os_codes [21:21:01]
$ sort -M toBeSortMonthNames
January
February
March
August
September


```

- we are having the random month names in it.
-  If we need to sort in a proper month ascending format we can use the “M” option in the sort command.
-  After using this value, we can get the month list in a sorted format.

##  sort with -h option
> 列出当前目录下大小前5的目录
```bash
# cxxu_kali @ cxxuWin11 in /mnt/c/users/cxxu/downloads [22:06:04]
$ du -h  --apparent-size ./ | sort -k1 -hr|head -5
2.3G    ./
1.6G    ./Programs
369M    ./dicts
240M    ./Compressed
64M     ./Compressed/gcide-0.53
```