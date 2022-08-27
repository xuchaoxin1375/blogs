

# 资源占用排查

> 进程资源占用信息包括
>
> - cpu 
> - memory
> - ...

## ps -C 根据给定的进程名称来搜索进程

- 支持以指定的格式显示进程信息

```bash
#( 04/11/22@11:14AM )( cxxu@cxxuAli ):~
   ps u f -C mysqld,sshd
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
mysql     1537  0.0 17.6 1136456 360240 ?      Sl   09:54   0:03 /www/server/mysql/bin/mysq
root       708  0.0  0.3  72308  6344 ?        Ss   09:54   0:00 /usr/sbin/sshd -D
root      1724  0.0  0.3 107992  7208 ?        Ss   09:55   0:00  \_ sshd: cxxu [priv]
cxxu      1757  0.0  0.1 107992  3508 ?        S    09:55   0:00  |   \_ sshd: cxxu@pts/0
root      2879  0.0  0.3 107992  7264 ?        Ss   10:12   0:00  \_ sshd: cxxu [priv]
cxxu      2900  0.0  0.1 107992  3576 ?        S    10:12   0:00  |   \_ sshd: cxxu@pts/1
root      3091  0.0  0.3 107992  7176 ?        Ss   10:14   0:00  \_ sshd: cxxu [priv]
cxxu      3112  0.0  0.1 107992  3444 ?        S    10:14   0:00  |   \_ sshd: cxxu@pts/2
root      3497  0.0  0.3 107992  7264 ?        Ss   10:21   0:00  \_ sshd: cxxu [priv]
cxxu      3517  0.0  0.2 108148  4636 ?        S    10:21   0:00  |   \_ sshd: cxxu@pts/3
root      5697  0.0  0.3 107992  7204 ?        Ss   11:03   0:00  \_ sshd: cxxu [priv]
cxxu      5717  0.0  0.1 107992  3540 ?        S    11:03   0:00      \_ sshd: cxxu@pts/4
```

## top:实时显示资源占用情况

### cpu占用排序

## references

> 文档比较长,建议使用在线版查看(方便全局把握查看)

### ps文档目录



[ps(1) - Linux manual page (man7.org)](https://www.man7.org/linux/man-pages/man1/ps.1.html)

1. [NAME     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-2)
2. [SYNOPSIS     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-3)
3. [DESCRIPTION     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-4)
4. [EXAMPLES     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-5)

### ps 信息筛选

1. [SIMPLE PROCESS SELECTION     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-6)
2. [PROCESS SELECTION BY LIST     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-7)

### ps 输出格式处理

1. [OUTPUT FORMAT CONTROL     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-8)
2. [OUTPUT MODIFIERS     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-9)

### 线程信息查看

1. [THREAD DISPLAY     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-10)
2. [OTHER INFORMATION     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-11)
3. [NOTES     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-12)

### 进程标记/状态码/以及符号说明

1. [PROCESS FLAGS     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-13)
2. [PROCESS STATE CODES     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-14)

#### ps输出排序

1. [OBSOLETE SORT KEYS     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-15)
2. [AIX FORMAT DESCRIPTORS     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-16)
3. [STANDARD FORMAT SPECIFIERS     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-17)
4. [ENVIRONMENT VARIABLES     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-18)

#### 个性化ps命令

1. [PERSONALITY     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-19)
2. [SEE ALSO     top](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-20)