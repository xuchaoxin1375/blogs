[toc]
# fastgit_加速针对github的操作(clone&push...)
## references

- [# 使用指南](https://doc.fastgit.org/zh-cn/guide.html#使用指南)
  - [# Web 的使用](https://doc.fastgit.org/zh-cn/guide.html#web-的使用)
  - [# Release 和源码存档的下载](https://doc.fastgit.org/zh-cn/guide.html#release-和源码存档的下载)
  - [# SSH 操作](https://doc.fastgit.org/zh-cn/guide.html#ssh-操作)
  - [# 对于 raw 的代理](https://doc.fastgit.org/zh-cn/guide.html#对于-raw-的代理)
  - [# 当遇到 FastGit 存在问题时的处理方法](https://doc.fastgit.org/zh-cn/guide.html#当遇到-fastgit-存在问题时的处理方法)
  - [辅助工具 | FastGit UK Document](https://doc.fastgit.org/zh-cn/tools.html#fgit)

### fastgit

- 依据最新官方文档为主,包括域名变更以及限制和更新的功能
- 更多使用方法,查看官方文档

#### 反代列表

- [#获取最新信息link](https://doc.fastgit.org/zh-cn/node.html#反代列表)反代列表

  | 站源                             | 地址                              | 缓存     |
  | -------------------------------- | --------------------------------- | -------- |
  | github.com                       | hub.fastgit.xyz                   | 无       |
  | raw.githubusercontent.com        | raw.fastgit.org                   | 无       |
  | github.githubassets.com          | assets.fastgit.org                | 无       |
  | customer-stories-feed.github.com | customer-stories-feed.fastgit.org | 480 分钟 |
  | Github Download                  | download.fastgit.org              | 480 分钟 |
  | GitHub Archive                   | archive.fastgit.org               | 无       |

### 检查fastgit的可用性(是否宕机)

#### 本地检查

```bash
PS D:\repos\PythonLearn\experiments> curl hub.fastgit.xyz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0    789      0 --:--:-- --:--:-- --:--:--   793
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
```

#### 在线检查

- [FastGit Status (uptimerobot.com)](https://stats.uptimerobot.com/g7zoWclBN0)

##### 当遇到 FastGit 存在问题时的处理方法

- 请确认你的网络以及 DNS 工作正常
- 请查阅
  -  [https://status.fastgit.org (opens new window)](https://status.fastgit.org/)以及
    - [UptimeBot](https://stats.uptimerobot.com/g7zoWclBN0)
      [UptimeBot (Page)](https://fastgitorg.github.io/status/)
      [Upptime (Repository)](https://github.com/FastGitORG/uptime)
      [Upptime (Page)](https://fastgitorg.github.io/uptime/)
      [Back home](https://fastgit.org/)
  -  [https://github.com/FastGitORG/uptime (opens new window)](https://github.com/FastGitORG/uptime)
  - 以确认 FastGit 是否正面临潜在的服务不可用可能性
- 更换阿里公共 DNS 避免潜在的 DNS 污染问题
- 通过 Tcpping 尝试与 FastGit IP 进行通信

### fastgit使用效果



#### git clone(从github clone项目仓库)

```bash
PS C:\Users\cxxu\Desktop> git clone https://hub.fastgit.xyz/dotnetcore/FastGithub.git
Cloning into 'FastGithub'...
remote: Enumerating objects: 5452, done.
remote: Counting objects: 100% (104/104), done.
remote: Compressing objects: 100% (71/71), done.
```



#### git push(推送到github)

注意,首次使用,会要求你输入

- github用户名
- github用户token(具有足够权限的)
- 输入(粘贴)token的时候,是不可见的

- ```bash
  PS D:\repos\PythonLearn> git push origin_fast main
  
  Username for 'https://hub.fastgit.xyz': xuchaoxin1375
  Password for 'https://xuchaoxin1375@hub.fastgit.xyz':
  Enumerating objects: 12309, done.
  ```

  

- ```bash
  PS D:\repos\zjgsuSharing> git remote -v
  origin  https://github.com/xuchaoxin1375/zjgsuSharing.git (fetch)
  origin  https://github.com/xuchaoxin1375/zjgsuSharing.git (push)
  
  PS D:\repos\zjgsuSharing> git remote add origin_fast  https://hub.fastgit.xyz/xuchaoxin1375/zjgsuSharing.git
  
  PS D:\repos\zjgsuSharing> git push origin_fast main
  Enumerating objects: 5, done.
  Counting objects: 100% (5/5), done.
  Delta compression using up to 8 threads
  Compressing objects: 100% (3/3), done.
  Writing objects: 100% (3/3), 288 bytes | 288.00 KiB/s, done.
  Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
  remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
  To https://hub.fastgit.xyz/xuchaoxin1375/zjgsuSharing.git
     d53c72b..afda81a  main -> main
  PS D:\repos\zjgsuSharing>
  ```

  

  

###  githubusercontent

#### fastgit&githubusercontent

```bash
PS D:\repos\PythonLearn\experiments> ping raw.fastgit.org

Pinging raw.fastgit.org [89.31.125.6] with 32 bytes of data:
Reply from 89.31.125.6: bytes=32 time=94ms TTL=47
Reply from 89.31.125.6: bytes=32 time=102ms TTL=47
```



- [https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220622102951275.png](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/imagesimage-20220622102951275.png)

- [https://raw.fastgit.org/xuchaoxin1375/pictures/main/imagesimage-20220622102951275.png](https://raw.fastgit.org/xuchaoxin1375/pictures/main/imagesimage-20220622102951275.png)

  - 使用浏览器访问,会触发检查,(如果是图片,在markdown中无法显示)

  - 但是可以下载(下载过程中的提速效果)

  - ```bash
    PS D:\repos\PythonLearn\experiments> curl https://raw.fastgit.org/xuchaoxin1375/pictures/main/imagesimage-20220622102951275.png -o png.png
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   157  100   157    0     0    140      0  0:00:01  0:00:01 --:--:--   141
    ```

    

#### cdn&githubusercontent

- 采用cdn加速,可以更好的加速GitHubusercontent资源
- 详情参考其他资料