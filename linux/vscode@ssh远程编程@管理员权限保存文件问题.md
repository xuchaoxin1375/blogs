[toc]



## vscode_ssh@远程开发@vscode命令行中打开某个远程工作目录

- How to attach a remote container using vscode command line

### refs

- [Visual Studio Code Remote Development Troubleshooting Tips and Tricks](https://code.visualstudio.com/docs/remote/troubleshooting)
- [Connect to a remote server via `code --folder-uri` · Issue #190 · microsoft/vscode-remote-release (github.com)](https://github.com/microsoft/vscode-remote-release/issues/190)
- [How to attach a remote container using vscode command line](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiFi6zZwLD3AhUXwAIHHfz_B4kQFnoECA8QAQ&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F60379221%2Fhow-to-attach-a-remote-container-using-vscode-command-line&usg=AOvVaw1zS6CHeF17oV0O4QvVyO7z)

### 命令

- `code --folder-uri "vscode-remote://ssh-remote+12.23.45.67/home/myuser/dev/"`
  - 其中,从`+`之前的内容都需要逐字保留,`+`之后的主机ip/域名以及后面的用户家目录等具体目录由自身清空而定

## vscode编辑wsl_linux中的某些文件无法保存

- vscode+remote-ssh 无法保存需要root权限的文件

### 考虑将该文件改为777权限

- chmod 777 文件名:
- 以文件/etc/apt/sources.list为例:

	sudo chmod 777 /etc/apt/sources.list

- 重新尝试:
- code /etc/apt/sources.list

- 更粗暴点,对指定目录批量更改:
- chmod 777 -R  <directory即要改变存取模式的目录>

###  使用插件

- 通用语ssh方式连接的linux主机(wsl)(wsl也可以通过配置用ssh连接)

- [Save as Root in Remote - SSH - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=yy0931.save-as-root)

  - 这个插件允许你直接保存需要root权限的文件(当然,如果你的ssh连接的用户可以使用sudo的话(保存时,可能需要输入您的用户密码(如果没有配置免密码的话,这一点和你原生使用sudo过程时一样的)
  - 该插件需要在远程的主机(或者本地wsl上安装)来形成呼应

  - 在未来,这个问题可能会被原生解决
    
    

###  自动保存与弹窗

- 建议关闭ssh连接下自动保存,以免反复弹窗😂(提示保存失败),我们等到最后手动通过command palette 保存(或者配置快捷键)
  - 首先SSH已经链接到某个远程主机
  - 再注意选择设置作用域:`Remote[SSH:xxxx]`
  - 搜索`auto save`设置项,改为`off`



###  ref

- [How to save a file in vscode-remote SSH with a non-root user privileges - Stack Overflow](https://stackoverflow.com/questions/56291492/how-to-save-a-file-in-vscode-remote-ssh-with-a-non-root-user-privileges)

