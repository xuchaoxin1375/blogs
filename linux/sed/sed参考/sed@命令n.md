[toc]





## sed n command(optional/old-fashioned)

> * 该sed中附属命令n(next),表示跳过上一行,直接处理下一行
> * sed处理文笔是一行行读入(input);默认情况下,是每读取一行就处理(执行sed 处理脚本)一行
>   * 但是被跳过的行仍然默认原样打印出来
> * 但是如果使用了 `n;`,就可以跳行处理,每使用一个 `n;`,效果相当于执行跳跃步长+1;默认步长为1
>   * 即,(冒号 `;`是sed script中表示一条指令的结束)
>   * 当使用了 `n;`每间隔0行处理一次(即,每行都处理(默认行为));
>   * 当使用了 `n;`每间隔1行处理一次;
>   * 当使用了 `n;n;`每间隔2行处理一次;

* If auto-print is not disabled, print the pattern space, then, regardless, replace the pattern space with the next line of input. If there is no more input then `sed` exits without processing any more commands.

This command is useful to skip lines (e.g. process every Nth line).

Example: perform substitution on every 3rd line (i.e. two `n` commands skip two lines):

```
$ seq 6 | sed 'n;n;s/./x/'
1
2
x
4
5
x
```

GNU `sed` provides an extension address syntax of first~step to achieve the same result:

```
$ seq 6 | sed '0~3s/./x/'
1
2
x
4
5
x
```

