[toc]



错误内容

```
The SSL connection could not be established, see inner exception.
```

例如安装calibre遇到错误

```powershell

Installing 'calibre' (8.9.0) [64bit] from 'extras' bucket
proxy: https://github.com/kovidgoyal/calibre/releases/download/v8.9.0/calibre-portable-installer-8.9.0.exe
The SSL connection could not be established, see inner exception.
URL https://github.com/kovidgoyal/calibre/releases/download/v8.9.0/calibre-portable-installer-8.9.0.exe is not valid
```

使用`-s`参数重试

```powershell
PS> scoop install calibre -g -s
```

