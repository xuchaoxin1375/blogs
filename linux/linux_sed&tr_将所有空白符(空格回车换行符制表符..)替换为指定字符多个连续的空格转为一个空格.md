# linux_sed&tr_

## 讨论的内容

- tr的基本使用
- 替换所有空白符片段
  - 空白符包括:
    - 空格
    - 回车换行符
    - 制表符
    - ...
- 将多个连续的空格(空白符序列片段)转为一个空格
  - 联合使用sed和tr,返回各自的有点,完成任务

## references

- [linux - Can tr work with regex? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/86929/can-tr-work-with-regex)

## 比较tr和sed

- 简单替换可以用tr快速处理

  - 用法比sed简单,但是sed通常会更加通用,更加灵活
  - 不过简单替换可以完成的任务也是相当多的

  

## tr的用途

- tr - translate or delete characters
- DESCRIPTION
         Translate,  squeeze,  and/or  delete  characters  from standard input, writing to
         standard output.

### 将文本转换为大写

- One popular use of `tr` is change the case of strings:

```
$ echo 'this is a test' | tr a-z A-Z
THIS IS A TEST
```

### 测试用的文本/文件

- 将下面的文本写入到文件`file`中

  ​		

  - ```bash
     > file<<eof
     getpid() returns the process ID (PID) of the calling process.
           (This is often used by routines that generate unique temporary
           filenames.)
      
           getppid() returns the process ID of the parent of the calling
           process.  This will be either the ID of the process that created
           this process using fork(), or, if that process has already
           terminated, the ID of the process to which this process has been
           reparented (either init(1) or a "subreaper" process defined via
           the prctl(2) PR_SET_CHILD_SUBREAPER operation).
    eof
           
    ```

- ​	使用`cat -A`检查空白字符的分布($,^)

  - ```bash
    cat file -A
     getpid() returns the process ID (PID) of the calling process.$
           (This is often used by routines that generate unique temporary$
           filenames.)$
    $
           getppid() returns the process ID of the parent of the calling$
           process.  This will be either the ID of the process that created$
           this process using fork(), or, if that process has already$
           terminated, the ID of the process to which this process has been$
           reparented (either init(1) or a "subreaper" process defined via$
           the prctl(2) PR_SET_CHILD_SUBREAPER operation).$
    ```

  - 

- 文件2:写入到`ff`中

  - ```bash
    > ff<<eof
    line1 end
    line2   end
    123
    456
    eof
    
    ```

- 空白符分部情况

  - ```
    ┌─[cxxu@CxxuWin11] - [~] - [2022-04-24 02:17:01]
    └─[0] <> cat ff -A
    line1 end$
    line2^Iend$
    123$
    456$
    ```

  - 

### 🎈将所有空白字符串(长度>0)的地方替换为一个空格

> 这种情况经常在复制pdf中的文本/man手册中的文本时需做的处理

### sed配合tr进行处理

> 本方案综合利用了sed按行处理的专业性(正则表达式的完整支持)和tr(对于多行文本间的字符操作的简单易行的优势)

- `sed -e 's/\s\+/ /g' file|tr  "\n" ' '`(此处没有使用扩展的正则`-E`选项,将`+`视为数量匹配符时需要`\`转义之)
- 或者	`cat file|sed -E 's/\s+/ /g'|tr '\n' ' '`(使用扩展的正则表达式)

```bash
 cat file|sed -E 's/\s+/ /g'|tr '\n' ' '

 getpid() returns the process ID (PID) of the calling process.  (This is often used by routines that generate unique temporary  filenames.)   getppid() returns the process ID of the parent of the calling  process. This will be either the ID of the process that created  this process using fork(), or, if that process has already  terminated, the ID of the process to which this process has been  reparented (either init(1) or a "subreaper" process defined via  the prctl(2) PR_SET_CHILD_SUBREAPER operation). 
```

