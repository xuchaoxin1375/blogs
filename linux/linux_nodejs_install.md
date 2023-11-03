@[toc]

#  指定仓库一键安装

##  reference

- [How to Install Latest NodeJS and NPM in Linux (tecmint.com)](https://www.tecmint.com/install-nodejs-npm-in-centos-ubuntu/)

  - 本方式将nodejs 和 npm 一同下载

  - 可以先到官网查看最新版本号的前两位(譬如16.xx.x)

    - [ Node.js (nodejs.org)](https://nodejs.org/en/download/)

  - 切换到root用户下:`sudo -i `

  - 再执行以下命令

    - 

    ```
    curl -sL https://deb.nodesource.com/setup_16.x | bash -
    apt-get install -y nodejs
    ```

  - 检查版本:

    - `node -v`
    - `npm -v`

  - 结束


# 手动下载安装
##  下载并抽取二进制文件
![在这里插入图片描述](https://img-blog.csdnimg.cn/806882807a544d209bf633078e049e7c.png)
执行:
`sudo mkdir /usr/node`
通过`tar xvf node-v.....(your package name).tar.xz  -C   /usr/node`
将文件抽取到`/usr/node`目录下
##  创建软连接
- 分别为node 和 npm 创建在`/usr/local/bin` 下的软连接(还是叫符号链接?)
现在进入到对应的`bin`目录下:(shell提示符中间的灰色路径)
![](https://img-blog.csdnimg.cn/img_convert/0360b7988ca76bb22930033d912867ae.png)
![](https://img-blog.csdnimg.cn/img_convert/60ed701da4ba1f06f26bc382e049eda4.png)
到此就装好了

注意,如果有旧版本,建议删除掉残余目录(或者重命名以备份之),否则可能影响新版本的安装

###  安装yarn
` npm install -g yarn`

###  配置环境变量PATH
此时,npm [-g]所下载的文件将放置在`/usr/node/node..version/bin`目录下
如果要能够使用npm install安装的包,需要将其配置到`PATH`变量中

格式:譬如` export PATH=/usr/node/node-v16.14.2-linux-x64/bin/:$PATH`
为了避免每次启动都需要配置,建议将其写入配置文件中(`.bashrc`或者其他配置文件(/etc/profile中)
####  clone egg.js 测试demo
`git clone https://gitee.com/xuchaoxin1375/demo_egg.git`
####  进入指定的egg项目执行install
`yarn install`
![](https://img-blog.csdnimg.cn/img_convert/63eefa81c55cfb09e26462dece2324b4.png)
####  启动
![](https://img-blog.csdnimg.cn/img_convert/9a2042b18660e5372e5a8e9c7280859c.png)