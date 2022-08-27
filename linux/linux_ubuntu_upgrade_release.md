[toc]

# ubuntu_升级版本:do-release-upgrade

## 放行升级行为

- [Can't upgrade:In /etc/update-manager/release-upgrades Prompt
is set to never so upgrading is not possible. ](https://askubuntu.com/questions/1315484/cant-upgrade-from-18-04-server-to-20-04)

- [How to Upgrade to Ubuntu 22.04 Right Now [Step by step\] (itsfoss.com)](https://itsfoss.com/upgrade-ubuntu-version/)

## 检查升级情况

```bash
#方法1:
┌─[cxxu@u20] - [~] - [2022-06-05 11:16:51]
└─[0] <> lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 21.10
Release:        21.10
Codename:       impish

#方法2:
┌─[cxxu@u20] - [~] - [2022-06-05 11:18:09]
└─[0] <> cat /etc/issue
Ubuntu 21.10 \n \l
```

