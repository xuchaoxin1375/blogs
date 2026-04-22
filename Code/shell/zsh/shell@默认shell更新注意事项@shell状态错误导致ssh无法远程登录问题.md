[toc]



## 更新默认shell到最新版

在类unix系统中,最流行的shell包括`bash`,`zsh`

`bash`通常比较稳定;而zsh更新频繁,有时候为了新特性,用户可能会更新zsh;

> zsh的交互体验较好，并且有庞大的插件生态，许多用户将其设置为默认shell;
>
> 但是在卸载默认shell前要十分小心，务必将默认shell更改到其他shell,例如`/bin/bash`

以linux上的zsh为例;

zsh的组件目录(例如补全相关的函数库目录,通常位于`/usr/share/zsh/functions/Completion/Base`),在使用非官方包管理器更新(比如使用linuxbrew或者自己编译安装zsh最新版本),可能主程序升级了,但是一些目录的指向还是老版本;

一个简单粗暴的方法是卸载掉原来包管理器的安装版本,然后干净地安装更新的版本;

### 卸载前忘记更改默认shell

如果用户将zsh设置为当前shell,并且在卸载前没有更改默认shell为其他shell,那么可能遇到一下问题:

- 由于默认用于登录的shell被卸载,ssh无法直接登录,密码验证和ssh 公钥也无法验证;

如果是宝塔这类使用面板的用户,可以尝试打开面板终端:

- 如果尝试直接修改默认shell,可能不会成功

  ```bash
  $ chsh -s /bin/bash 
  Password: 
  
  chsh: PAM: Authentication failure
  
  ```

由于 Zsh 已被卸载，系统可能在验证身份（PAM 流程）时因为找不到当前有效的 Shell 环境而直接拒绝了你的 `chsh` 请求。

这种 **"Authentication failure"** 通常是因为 PAM (Pluggable Authentication Modules) 在切换 Shell 前会检查用户当前的合法性，而你的合法 Shell 已经丢失了。

如果你的用户有 sudo 权限，直接用 root 身份去改，通常可以绕过对当前 Shell 的检查：

```bash
sudo usermod -s /bin/bash 你的用户名
```

> 将 `你的用户名` 替换为你实际的登录名（比如 root 或其他名字）。

- 如果用户卸载了默认的zsh,但是尚未退出ssh链接,可以尝试内存中的zsh尚未清除,及时尝试切换默认shell

如果你已经退出了，正在尝试重新 SSH 登录,如果你现在是被挡在服务器外面登录不进去，请在**你的本地电脑**终端执行：

```bash
ssh -t 用户名@服务器IP "/bin/bash --noprofile --norc"
```

这个命令的作用是：强制服务器在登录后立即启动 Bash，并跳过加载可能出错的配置文件。一旦进入，立刻执行上面的 `sudo usermod` 命令。
