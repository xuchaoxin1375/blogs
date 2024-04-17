[toc]

# 手动下载安装nodejs和npm

##  下载并抽取二进制文件A

- 小脚本:

  - ```bash
    sudo mkdir /usr/node/;
    sudo tar xvf node*.tar.xz  -C   /usr/node/;
    ls /usr/node/
    ```

    

### 脚本解释

- 路径重命名需要考虑是否要用多个版本的node
- 建议还是保留版本号

![在这里插入图片描述](https://img-blog.csdnimg.cn/806882807a544d209bf633078e049e7c.png)

- 创建目录`sudo mkdir /usr/node/`

- 通过`sudo tar xvf node*.tar.xz  -C   /usr/node/`

  - 其中`node*.tar.xz`是修改过包名的文件,某些shell按下tab会自动替换成完整名的

  - 如果不支持`sudo`,则可以尝试先切换到root用户后再安装

  - 如果运行成功,则以将文件抽取到`/usr/node-xxxlinux`目录下

    

- 检查结果:

  - `ls /usr/node/

##  创建软连接B

- 当前面步骤都执行顺利的时候,可以运行:
  - 权限不足是,可以尝试`sudo`

- 小脚本

  - ```bash
    ln -s /usr/node/node*linux*/bin/node /usr/local/bin
    ln -s /usr/node/node*linux*/bin/npm /usr/local/bin
    echo '🎆the version of node:'
    node -v
    echo 'the version of npm:'
    npm -v
    ```

    

### 脚本解释

- 分别为node 和 npm 创建在`/usr/local/bin` 下的软连接

  - 现在进入到对应的`bin`目录下:(shell提示符中间的灰色路径)

    

  - ![](https://img-blog.csdnimg.cn/img_convert/0360b7988ca76bb22930033d912867ae.png)
    ![](https://img-blog.csdnimg.cn/img_convert/60ed701da4ba1f06f26bc382e049eda4.png)
    到此就装好了

###  安装yarn

- ` npm install -g yarn`

###  配置环境变量PATH

- 此时,npm [-g]所下载的文件将放置在`/usr/node/node*linux*/bin`目录下

- 如果要能够使用npm install安装的包,需要将其配置到`PATH`变量中
  - 格式:譬如` export PATH=/usr/node/node-v16.14.2-linux-x64/bin/:$PATH`

- 为了避免每次启动都需要配置,建议将其写入配置文件中(`.bashrc`或者其他配置文件(/etc/profile中)

####  clone egg.js 测试demo

`git clone https://gitee.com/xuchaoxin1375/demo_egg.git`

####  进入指定的egg项目执行install

`yarn install`
![](https://img-blog.csdnimg.cn/img_convert/63eefa81c55cfb09e26462dece2324b4.png)

####  启动

![](https://img-blog.csdnimg.cn/img_convert/9a2042b18660e5372e5a8e9c7280859c.png)



#  指定仓库一键安装



##  更新npm

> 需要root 权限`sudo npm install -g npm@x.x.x`

- 譬如更新到8.6.0版本

```
┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-14 09:09:08]
└─[243] <> sudo npm install -g npm@8.6.0

removed 20 packages, changed 63 packages, and audited 201 packages in 6s

10 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

