# linux_ubuntu卸载mysql/Django mysqlclient驱动安装/宝塔面吧linux_phpMyAdmin安装和运行

## ubuntu 卸载mysql

> 此处缘由:我是通过宝塔面板来安装的mysql8.0
>
> - 我尝试直接使用`python -m pip install mysqlclient`安装python mysql驱动来接入Django
> - 但是估计宝塔的安装不同于常规安装`sudo apt install mysql-server`,目录结构不同(安装在/www/server/mysql下;
> - 结果执行过程`pip`时报错,还导致`apt install`出现异常,而且在卸载`mysql`的时候提示目录问题(找不到),我尝试用`sudo apt --fix-broken install`也执行失败(apt 命令几乎因此报废)
>
> - 下面时我尝试抢救apt的可用性
>   - 我尝试通过宝塔面板将mysql删除,它提示我要备份数据后再通过`sudo rm -rf /www/server/mysql`进行强制删除
>   - 我照做
>   - 再次尝试`sudo apt --fix-broken install`是否可用(发现可用了)
>   - 最后我重新用宝塔安装(mysql 8.0)
>     - 如果,直接用`sudo apt install mysql-server`还是会再最后一步报错(提示无法启动mysql 服务)
>     - 但总规还是将`mysqlclient`这个python包安装好了

### references

- [How do I uninstall MySQL? - Ask Ubuntu](https://askubuntu.com/questions/172514/how-do-i-uninstall-mysql)

  - 注意,执行apt 的清理操作时,最好用bash执行,如果用zsh容易出现找不到名称的问题!!

  - ```
    sudo apt remove --purge mysql* 
    sudo apt autoremove
    sudo apt autoclean 
    ```

## Django mysql driver:pip install mysqlclient

> - pip安装mysqlclient的时候需要执行一些编译,因此需要安装配套的编译工具
> - 所以先执行下列:`sudo apt ...`安装build等工具
> - 然后才能执行`pip install mysqlclient`(根据别名/符号链接配置情况,执行将`pip`用`python3 -m`或者`python -m`替换(如果直接用pip失败的话))

### references

- [mysqlclient · PyPI](https://pypi.org/project/mysqlclient/)

- [mysql - Error installing mysqlclient for python on Ubuntu 18.04 - Stack Overflow](https://stackoverflow.com/questions/54350881/error-installing-mysqlclient-for-python-on-ubuntu-18-04)

- As mentioned [here](https://pypi.org/project/mysqlclient/) you should do:

  - `sudo apt-get install python3-dev default-libmysqlclient-dev build-essential`
    Debian / Ubuntu
  - `sudo yum install python3-devel mysql-devel`
    Red Hat / CentOS

  After that just do `pip install mysqlclient`



## django+mysql

### references

- [Settings | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/ref/settings/)
- [Databases | Django documentation | Django (djangoproject.com)](https://docs.djangoproject.com/en/4.0/ref/databases/#h5o-28)

## 宝塔linux面版phpmyadmin 数据库管理工具的安装/启动

### 环境检查(软件安装)

- phpMyAdmin依赖于Nginx以及php
- 这几个软件之间可能有版本兼容的要求(为了避免遇到兼容性问题,建议全部安装最新版)
- 先安装Nginx和PhP;然后安装phpMyAdmin
- 最后启动确保启动Mysql,PhP,Nginx;然后才可以顺利使用phpMyAdmin

![image-20220408124946179](https://s2.loli.net/2022/04/08/9yExCUQfcJ2pWkX.png)

![image-20220408125355263](https://s2.loli.net/2022/04/08/sEAwuPle3DMtm6W.png)

### 执行效果

![image-20220408125454535](https://s2.loli.net/2022/04/08/CVEQA6zFbGBt1X8.png)