[toc]



## 入门基本使用GitHub

[GitHub Docs|ZH](https://docs.github.com/zh)@[GitHub Docs|EN](https://docs.github.com/en)

- [GitHub 入门文档 - GitHub 文档](https://docs.github.com/zh/get-started)
- [使用Git | GitHub 文档](https://docs.github.com/zh/get-started/getting-started-with-git/setting-your-username-in-git)
- [关于 Git - GitHub 文档](https://docs.github.com/zh/get-started/using-git/about-git)

## 本地的repository 首次推到github上

- [推送提交到远程仓库 - GitHub 文档](https://docs.github.com/zh/get-started/using-git/pushing-commits-to-a-remote-repository)

### 初始化本地目录为可管理仓库

1. 首先需要一个能够被github管理的本地文件夹(用git bash进入到一个普通的文件夹,使用git init命令即可(特征是会生成.git(用
   ls -ah 可以看到)

2. (根据自己本地的情况,仓库中(待被推到github上的目录里)运行:

   - ```bash
     git add .
     git commit -m "your comments (if you need) "
     ```

### 本地仓库和github仓库关联

- 在Github上手动创建好一个与本地Git仓库对应的仓库之后,我们就可以和本地仓库进行关联了
- 根据创建好的Git仓库页面的提示，可以在本地输入
- **push an existing repository from the command line:**
  - `git remote add origin https://github.com/xuchaoxin1375/learnGit.git`
  - `git branch -M main`(main一般默认为master,该部操作之前应当add,并且commit成功才行否则报错refname的错误)

- 另外链接的形式:形如
  - `git@github.com:xuchaoxin1375/linerAlgebra.git)`
  - `git push -u origin main(main根据自身情况,可能要改为master)`
  - 如果之前操作失误导致origin再次建立报错也没事,后面两条命令继续执行


- 推送完成后,刷新github界面



###  关于重复验证的问题:

- [git_避免重复验证/反复输入密码)](https://blog.csdn.net/xuchaoxin1375/article/details/115600374)关于获取某个github仓库的https链接

##  可能遇到的问题@首次推送冲突

- 值得注意的是，如果我们在github端中新建repository时用默认分支（现在默认为main分支），如果从本地push 到云端时也指定为main分支（git push origin main),那么可能冲突
- 这主要是由于在创建新的github仓库是添加了`readme.md`等文件所造成



### 解决办法

- 可以用--allow-unrelated-histories选型进行pull
  - `git pull origin main --allow-unrelated-histories`
- 可以考虑在push的时候换一个分支名
- 也可以在github端将默认分支删除，然后再push
- 也可以将github端的分支内容fetch到本地，手动整合后重新push



## 使用wsl linux的Notice

- 如果ssh key 是windows 端上生成的, 那么子系统linux是无法直接利用这个身份
- 就是说,无法直接push ,需要在子系统中再操作一遍

