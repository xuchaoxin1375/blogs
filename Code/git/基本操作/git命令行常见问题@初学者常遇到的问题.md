[toc]



## git branch没有输出或新建branch不成功

如果是刚创建的仓库(仅`git init`初始化),并且还没过git add ,git commit等操作,那么默认将没有分支可用

(master分支查不到的,尽管用git status 会告诉你 on branch master)
所以,在git init后,要线git add ,git commit ,在执行基于分支的操作(比如push到origin repository)

```powershell
#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:42:26][UP:1.13Days]
PS> git init -b fristbranch
Initialized empty Git repository in C:/repos/gitLearn/.git/

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:42:41][UP:1.13Days]{Git:fristbranch}
PS> git status
On branch fristbranch

No commits yet

nothing to commit (create/copy files and use "git add" to track)

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:42:46][UP:1.13Days]{Git:fristbranch}
PS> git branch

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:42:59][UP:1.13Days]{Git:fristbranch}
PS> git branch secondbranch
fatal: not a valid object name: 'fristbranch'
```

创建第一个文件并提交

```powershell
#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:43:09][UP:1.13Days]{Git:fristbranch}
PS> "Learn git basic usage">Readme.md

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:44:20][UP:1.13Days]{Git:fristbranch}
PS> git status
On branch fristbranch

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        Readme.md

nothing added to commit but untracked files present (use "git add" to track)

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:44:23][UP:1.13Days]{Git:fristbranch}
PS> git add .

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:44:25][UP:1.13Days]{Git:fristbranch}
PS> git status
On branch fristbranch

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   Readme.md


#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:44:32][UP:1.13Days]{Git:fristbranch}
PS> git branch

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:44:41][UP:1.13Days]{Git:fristbranch}
PS> git commit -m "init push"
[fristbranch (root-commit) 862c22e] init push
 1 file changed, 1 insertion(+)
 create mode 100644 Readme.md

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:44:50][UP:1.13Days]{Git:fristbranch}
PS> git branch
* fristbranch

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:45:01][UP:1.13Days]{Git:fristbranch}
PS> git branch secondbranch

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:45:05][UP:1.13Days]{Git:fristbranch}
PS> git branch
* fristbranch
  secondbranch

#⚡️[Administrator@CXXUDESK][C:\repos\gitLearn][18:45:09][UP:1.13Days]{Git:fristbranch}
PS>

```

