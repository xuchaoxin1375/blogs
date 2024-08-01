[toc]



## windows凭据管理器

- [Accessing Credential Manager - Microsoft Support](https://support.microsoft.com/en-us/windows/accessing-credential-manager-1b5c916a-6a16-889f-8581-fc16e8165ac0)
- [访问凭据管理器 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/访问凭据管理器-1b5c916a-6a16-889f-8581-fc16e8165ac0)

- 也可以用命令行打开

  ```bash
  control /name Microsoft.CredentialManager
  
  ```

  



### 命令行中查看

可以使用cmdkey来查看凭证

```bash
PS> cmdkey -h

The command line parameters are incorrect.

The syntax of this command is:

CMDKEY [{/add | /generic}:targetname {/smartcard | /user:username {/pass{:password}}} | /delete{:targetname | /ras} | /list{:targetname}]

Examples:

  To list available credentials:
     cmdkey /list
     cmdkey /list:targetname

  To create domain credentials:
     cmdkey /add:targetname /user:username /pass:password
     cmdkey /add:targetname /user:username /pass
     cmdkey /add:targetname /user:username
     cmdkey /add:targetname /smartcard

  To create generic credentials:
     The /add switch may be replaced by /generic to create generic credentials

  To delete existing credentials:
     cmdkey /delete:targetname

  To delete RAS credentials:
     cmdkey /delete /ras

```



### 取消记住@凭据查看和管理

- 在开始菜单中搜索`credential manager`可以看到各类被windows记住的凭证
  - 例如远程桌面记住的登录密码
  - 网络磁盘映射的凭证
- 个别情况下我们需要删除凭证，例如映射webdav到本地磁盘，并且webdav服务器为不同的登录角色分配了不同权限，现在假设原来用来登录的用户权限是只读，现在我向管理员申请提高权限，追加可以上传的权限，管理员分配了一个uploader账户给用户使用，这时候我们就要修改或删除原来记住的凭证重新创建

