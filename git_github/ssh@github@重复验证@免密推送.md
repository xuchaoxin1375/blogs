[toc]

#  synopses

## 如何避免每次输入密码

- 如果你正在使用 HTTPS URL 来推送，Git 服务器会询问用户名与密码。 默认情况下它会在终端中提示服务器是否允许你进行推送。

- 如果不想在每一次推送时都输入用户名与密码，你可以设置一个 “credential cache”。 
  - 最简单的方式就是将其保存在内存一段时间，可以简单地运行` git config --global credential.helper cache` 来设置它。

  - 想要了解更多关于不同验证缓存的可用选项，查看 `凭证存储` 文档。


##  credential store

-  如果你使用的是 SSH 方式连接远端，并且设置了一个没有口令的密钥，这样就可以在**不输入用户名和密码的情况下安全地传输数据。** 
- 然而，这对 HTTP 协议来说是不可能的 —— 每一个连接都是需要用户名和密码的。 这在使用双重认证的情况下会更麻烦，因为你需要输入一个随机生成并且毫无规律的 token 作为密码。

#  避免重复验证的解决方案

  1. “store” 模式可以接受一个 --file <path> 参数，可以自定义存放密码的文件路径（默认是 ~/.git-credentials ）。
   2. “cache” 模式有 --timeout <seconds> 参数，可以设置后台进程的存活时间（默认是 “900”，也就是 15 分钟）。

##  cache mode:

-  “cache” 模式会将凭证存放在内存中一段时间。 密码永远不会被存储在磁盘中，并且在15分钟后从内存
   中清除。
-  注意 对于较新版本的windows git版本该功能可能被禁用

- for example:(10000 seconds)

```bash
$ git config --global credential.helper 'cache --timeout 10000'
```

##  git 全局配置文件



### 获取帮助

- `git config --help`

```
 --global
           For writing options: write to global ~/.gitconfig file rather than the repository .git/config, write to $XDG_CONFIG_HOME/git/config file if this file exists and the
           ~/.gitconfig file doesn’t.

           For reading options: read only from global ~/.gitconfig and from $XDG_CONFIG_HOME/git/config rather than from all available files.

           See also the section called “FILES”.
```



###  linux的git配置文件目录

- `~/.gitconfig`



### windows

#### 新版CredentialHelperSelector的选择窗口

- windows选择`wincred`
  如果想要避免重复提示,可以勾选下面的`always from now on`
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/7774d68b2a3e4856aee0c1bf8a8b1511.png)
- 如果找不到上述窗口,可以直接编辑配置文件
- 或者查阅文档,用命令行配置

#### 示例

- 以gitee为例

- ```bash
  [user]
  	email = 83xxx30@qq.com
  	name = cxxu
  [credential "helperselector"]
  	selected =wincred
  [credential "https://gitee.com"]
  	provider=generic
  ```

  

##  store mode

-  “store” 模式会将凭证用明文的形式存放在磁盘中，并且永不过期。 这意味着除非你修改了你在 Git 服务器上的密码，否则你永远不需要再次输入你的凭证信息。 
-  这种方式的缺点是你的密码是用明文的方式存放
   在你的 home 目录下。

```bash
$ git config --global credential.helper 'store --file ~/.my-credentials'
```

##  采用非对公钥-私钥验证方法

- 参加github文档







