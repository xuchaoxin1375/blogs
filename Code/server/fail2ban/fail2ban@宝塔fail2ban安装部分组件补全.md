[toc]

## abstract

宝塔安装的fail2ban可能仅仅把必要的`fail2ban-client`和`fail2ban-server`添加到`/usr/bin`中,如果我们要自定义高级规则,可能需要用到另外的组件,比如`fail2ban-regex`来做过滤器正则有效性检查

观察宝塔的fail2ban插件安装目录可以发现安装脚本,里面关键代码类似于(注释的两行仿写前两行即可)

```bash
    if [ ${py_v} != "/usr/bin/python" ]; then
        ln -s /www/server/panel/pyenv/bin/fail2ban-server /usr/bin/fail2ban-server
        ln -s /www/server/panel/pyenv/bin/fail2ban-client /usr/bin/fail2ban-client
#        ln -s /www/server/panel/pyenv/bin/fail2ban-regex /usr/bin/fail2ban-regex
#        ln -s /www/server/panel/pyenv/bin/fail2ban-testcases /usr/bin/fail2ban-testcases
    else
        ln -s /usr/local/bin/fail2ban-server /usr/bin/fail2ban-server
        ln -s /usr/local/bin/fail2ban-client /usr/bin/fail2ban-client
    fi
```

### 手动补全辅助组件

即创建两个符号链接

```bash
ln -s /www/server/panel/pyenv/bin/fail2ban-regex /usr/bin/fail2ban-regex -v
ln -s /www/server/panel/pyenv/bin/fail2ban-testcases /usr/bin/fail2ban-testcases -v
```

### 相关目录

```bash
#( 11/25/25@ 8:20PM )( root@s1 ):/www/server/panel/pyenv/bin
   ll fail2ban*
-rwx------ 1 root root 1.5K Nov 20 15:05 fail2ban-client
lrwxrwxrwx 1 root root   34 May 22  2025 fail2ban-python -> /www/server/panel/pyenv/bin/python
-rwx------ 1 root root 1.3K Nov 20 15:05 fail2ban-regex
-rwx------ 1 root root 1.5K Nov 20 15:05 fail2ban-server
-rwx------ 1 root root 2.3K Nov 20 15:05 fail2ban-testcases
```

fail2ban相关可执行程序所在目录`/usr/bin`

```bash
#( 11/25/25@ 8:21PM )( root@s1 ):/usr/bin
   ll /usr/bin/fail2ban*
lrwxrwxrwx 1 root root 43 Nov 20 15:05 /usr/bin/fail2ban-client -> /www/server/panel/pyenv/bin/fail2ban-client
lrwxrwxrwx 1 root root 42 Nov 25 20:15 /usr/bin/fail2ban-regex -> /www/server/panel/pyenv/bin/fail2ban-regex
lrwxrwxrwx 1 root root 43 Nov 20 15:05 /usr/bin/fail2ban-server -> /www/server/panel/pyenv/bin/fail2ban-server
lrwxrwxrwx 1 root root 46 Nov 25 20:15 /usr/bin/fail2ban-testcases -> /www/server/panel/pyenv/bin/fail2ban-testcas
```

## 验证生效

重新启动一个shell窗口(或者更新shell环境),然后尝试在shell中输入`fail2ban-regex -h`看是否有正确的用法帮助响应
