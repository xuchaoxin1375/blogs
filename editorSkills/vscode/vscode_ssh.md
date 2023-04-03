# vscode_ssh/远程开发/直接打开远程主机的某个工作目录/vscode命令行中打开某个远程工作目录/How to attach a remote container using vscode command line

## references

- [Visual Studio Code Remote Development Troubleshooting Tips and Tricks](https://code.visualstudio.com/docs/remote/troubleshooting)
- [Connect to a remote server via `code --folder-uri` · Issue #190 · microsoft/vscode-remote-release (github.com)](https://github.com/microsoft/vscode-remote-release/issues/190)
- [How to attach a remote container using vscode command line](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiFi6zZwLD3AhUXwAIHHfz_B4kQFnoECA8QAQ&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F60379221%2Fhow-to-attach-a-remote-container-using-vscode-command-line&usg=AOvVaw1zS6CHeF17oV0O4QvVyO7z)

## 命令

- `code --folder-uri "vscode-remote://ssh-remote+12.23.45.67/home/myuser/dev/"`
  - 其中,从`+`之前的内容都需要逐字保留,`+`之后的主机ip/域名以及后面的用户家目录等具体目录由自身清空而定

