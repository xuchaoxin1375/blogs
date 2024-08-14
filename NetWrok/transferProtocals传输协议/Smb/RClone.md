[toc]





## Rclone

### 启动

Rclone是一个主打命令行的工具,尽管有GUI版本

普通版,也就是命令行版的可执行程序双击会提示你它是一个命令行工具,使用`cmd`打开

经过试验,使用powershell启动`Rclone`可能导致闪退,请运行`cmd`,再执行`Rclone`

```cmd
This is a command line tool.

You need to open cmd.exe and run it from there.

```

```powershell
#这里使用powershell启动cmd,然后再运行rclone
PS☀️[BAT:75%][MEM:36.58% (11.6/31.71)GB][17:32:18]
# [cxxu@CXXUCOLORFUL][C:\exes\Rclone]
#切换到cmd
PS> cmd
Microsoft Windows [Version 10.0.26100.1150]
(c) Microsoft Corporation. All rights reserved.

C:\exes\Rclone>rclone -h

Rclone syncs files to and from cloud storage providers as well as
mounting them, listing them in lots of different ways.

See the home page (https://rclone.org/) for installation, usage,
documentation, changelog and configuration walkthroughs.

Usage:
  rclone [flags]
  rclone [command]

Available Commands:
  about       Get quota information from the remote.
  authorize   Remote authorization.
  backend     Run a backend-specific command.
  bisync      Perform bidirectional synchronization between two paths.
  cat         Concatenates any files and sends them to stdout.
  check       Checks the files in the source
  ....
  copy        Copy files from source to dest, skipping identical files.
  copyto      Copy files from source to dest, skipping identical files.
  ..
```

