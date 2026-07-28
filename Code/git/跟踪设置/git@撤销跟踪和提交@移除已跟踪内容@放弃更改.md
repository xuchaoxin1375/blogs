[toc]

## abstract

git 的新版本发生些许变化,这使得git help reset上的内容可能发生了变化
在了解相关命令和做法前,建议您先了解git管理下的文件的三种状态:
![在这里插入图片描述](https://img-blog.csdnimg.cn/99b001ef902741cd935d2271f465eb94.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

Working tree directory, staging area, and Git directory

![在这里插入图片描述](https://img-blog.csdnimg.cn/3c52d929712b4f8d820f0cf481fed2a3.png)

target for undo operations

做撤销的行为一般是由于不小心将当前文件改乱了,进而想让工作区中的文件恢复到被修改之前.

undo modified (undo woking directory modification)(level1)

当工作区workspace中的内容尚未add 到index时,您可以将index区中的内容调出来覆盖掉当前工作区的文件内容
如果是这样,用check命令即可(撤销workspace中的修改)
`git checkout  fileName`
一般来说,这个命令很够用了,一般我们没有完成一定程度的修改,是不会add到staging area中的.(而且,在把文件改乱了又返回的时候都还处在这个阶段)

undo add(level2)

##  git reset
- 但如果您不小心将working space 中尚未完善的修改add到了`staging area`,那么可以针对某个文件利用`git reset [HEAD] fileName/directory`来撤销add 操作(该操作并不影响到工作空间中的文件,单纯地回到add之前的状态)

- 换句话说,对于被改乱的文件似乎还是无能为力.(单纯undo add 还改变不到工作区,您需要使用(checkout/git reset --hard选项)来恢复工作空间中的文件(目录)到之前的某个版本
##  文件版本(工作空间)内容回退
###  git reset --hard
- (如果使用`git reset --hard <commitID>`那么是从已归档的repository区中读取文件并覆盖工作目录 )
###  git checkout
- 如果是使用`checkout <file/dir> ` 可以从暂存区`staging area`回退到之前的上次执行add操作时所保留的版本

> 注意,`git reset`& `git reset --soft` &`git reset --hard`三者功能并不相同,查看help 手册!
> 回退操作完成之后,使用`git status` 以及 `git log --graph`(或者显示的紧凑版本:` git log --all --decorate --oneline --graph`)可以检查操作结果

- 撤销被提交到staging area 中的修改:

![在这里插入图片描述](https://img-blog.csdnimg.cn/b782a593af12421d99135e9b60681c2f.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
###  git reset 示例
先检查当前环境
![在这里插入图片描述](https://img-blog.csdnimg.cn/0ffda4fc4033452086b546fcaf62ec52.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
执行`git reset --soft 5920`,观察HEAD指针的变化
![在这里插入图片描述](https://img-blog.csdnimg.cn/7c7c7f3ab5e0466dafe5a21cdb77baa6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  git rm --cached👺
`git rm --cached <itemName>`或许也能解决undo add 的需求

### 撤销对以跟踪目录的跟踪

- 指定撤销跟踪的路径要准确指定(可以是相对路径),否则会提示找不到

```powershell
PS🌙[BAT:79%][MEM:47.3% (15/31.71)GB][22:51:32]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts]{Git:main}
PS> git rm -r --cached  .\pythonScripts\MKTrain\__pycache__
rm 'pythonScripts/MKTrain/__pycache__/turtle.cpython-311.pyc'
```

错误示例(指定的路径不够具体)

```powershell

PS🌙[BAT:79%][MEM:50.93% (16.15/31.71)GB][22:48:48]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts]{Git:main}
PS> git rm -r --cached  __pycache__/
fatal: pathspec '__pycache__/' did not match any files
```

## 批量地移除git中的提交文件文件🎈

从 Git 存储库中删除所有 `.exe` 文件的缓存记录为例做介绍.

### powershell方案

我们可以利用powershell处理这个任务

```powershell
 ls *.exe -Recurse |%{git rm --cached $_.FullName -r}
```

它首先使用 `ls` 命令列出所有 `.exe` 文件，并通过 `-Recurse` 参数递归地搜索子目录。然后，使用管道 (`|`) 将结果传递给一个脚本块 `{}`，该脚本块遍历 (`%{...%}`) 每一个文件路径，并执行 `git rm --cached` 命令来从 Git 缓存中删除这些文件，但不删除实际文件系统中的文件。

### bash方案

在 Linux 或 macOS 的 Bash shell 中，可以这样做：

```bash
 find . -name "*.exe" -type f -exec git rm --cached {} \;
```

这个命令的工作方式如下：

- `find .` 命令从当前目录开始递归地查找文件。
- `-name "*.exe"` 指定只查找扩展名为 `.exe` 的文件。
- `-type f` 确保只找到文件而不是目录。
- `-exec` 允许执行外部命令，这里的命令是 `git rm --cached {} \;`，其中 `{}` 是 find 命令找到的每个文件的占位符。
- `\;` 表示结束 `-exec` 后面的命令。

请注意，在执行上述命令之前，请确保你是在一个 Git 工作树中，并且你有权限执行 `git rm` 命令。如果你不确定这些 `.exe` 文件是否应该被移除出 Git 跟踪，最好先检查一下它们是什么以及为何存在于你的项目中。另外，如果你不想立即提交这些更改，你可以稍后再手动添加并提交这些文件。

### 演示示例

```powershell
 PS> ls *.exe -Recurse |%{git rm --cached $_.FullName -r}
 rm 'Cpp/stars_printer/2.exe'
 rm 'Cpp/stars_printer/a.exe'
 rm 'Cpp/a.exe'
 rm 'Cpp/StarsPrinter.exe'
  
```

### 步骤总结👺

- 在 `.gitignore`文件中写好规则(如果之前疏忽了,将不需要或不适合的东西提交上去了,就添加对应的排除规则)

- 扫描出需要移除提交的文件,然后传递给 `git rm --cached` 进行撤销提交

- 最后根据需要是否要删除这些仓库中不需要提交的文件(通常可以不删除,否则运行起来重新生成,而且新的规则下它们不会再被提交,就可以了)

- 如果确实要删除,那么仍然可以用类似的方法

  - ```powershell
     
     PS🌙[BAT:94%][MEM:51.14% (4.01/7.85)GB][2:53:09]
     # [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][Win 11 专业版@10.0.26100.1297][C:\repos\scripts]{Git:main}
     PS> ls *.exe -Recurse |%{rm $_}  
    ```

##  undo commit

`git reset --soft <commit_id>`

(通过移动HEAD指针实现),`--soft` 比`--hard`安全(温和)
但是这样依然作用不到working area
即,被改乱的文件还是得不到恢复

##  示例
###  撤销最近一次commit
- 检查环境
![在这里插入图片描述](https://img-blog.csdnimg.cn/b716a9023d844d5292a93ad1b36d5679.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
- 执行git reset --soft
![在这里插入图片描述](https://img-blog.csdnimg.cn/b08f636cf0d54d9f90bea6d79b780eec.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
- 用reflag 检查
![在这里插入图片描述](https://img-blog.csdnimg.cn/448bb4bbdff14414a961e21f8b2eeab7.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)


### git reset --mixed 
一样不变动working area

- `git reset --hard <commit_id>`能够恢复工作区的文件
但是没指定文件的话会误伤其他文件的
- 对于`git reset`
- ## 我这里有个例子
	- ### 查看提交情况:
	- 操作之前的:![在这里插入图片描述](https://img-blog.csdnimg.cn/868f7dcf5dd348f89f31e087b9592f58.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_19,color_FFFFFF,t_70,g_se,x_16)
###  撤销commit
-
	- 撤销`指定对象(文件/目录下所有文件)`的`指定commit节点`到指定版本(commit id)
	- 例如,我们将commit 节点回滚到`1843...`;并使用`git log`查看
	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/0019b36d2aab43cb8d71c8d83950309d.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
###  恢复到暂存区(可指定恢复的对象)
- 
	- 将此时commit中的内容恢复到暂存区(将暂存区的未提交修改丢弃,接受repository 中commit恢复出来的代码)(这个时候不指定commit id,但可以指定(dir/file))
	- 可以恢复指定的目录/文件

	- ![在这里插入图片描述](https://img-blog.csdnimg.cn/9dbc6598d3864bf48f49d3143a8c573b.png)
###  恢复到工作空间

- 将指定目录(文件)从暂存区中恢复到工作空间(原有内容(修改)将被丢弃)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/b683141957b449179b07f56b60430dee.png)

### 检测(revision)分支流
![在这里插入图片描述](https://img-blog.csdnimg.cn/13dfc0e846e14e3b9eac1e2650bd65e0.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

- (情况说明,此时有两个分支(main&fzh)
	- 由于发生了冲突,我通过reset --soft 撤销了本地的落后的修改的commit,打算直接采用远程分支的修改,来简单处理冲突 	
	- 在合并分支的时候:`git merge origin/otherBranchName`&`git merge otherBranchName`未必一致,所以有时您需要都执行变(特别是在本地也创建了对应的otherBranchName分支)
	- 	> 目录->文件:变通方法:即给目录后面加`*`(通配符),也可以达到一定的批量`reset`效果![在这里插入图片描述](https://img-blog.csdnimg.cn/9c7d07e8ffe843e0b884bdcb13d291bb.png)
	- 再从暂存区中重设工作区中的内容(`git checkout <file/directory>`)) ;
		- 至此,工作区中的(指定文件/目录)内容就会被重置,修改就会被丢弃
	- 如果,直接使用`reset --hard`可以直接修改工作区中的内容,但是`reset --hard`,比`reset --soft` 来的危险;
	- 我们可以分步,手动操作(中途可以检测分支流的走势)
	- >我认为,git merge branchName 这一操作应该只关注于commit的节点上的代码,如果您本地的修改还未commit,那么在合并你当前的节点分叉出去的分支因该是不会有冲突提示的,但是当你想要在合并之后提交的时候,就是冲突可能来临的时候


- (可学上网)(但是参考`git help reset`文档也不错)
[参考链接](https://devconnected.com/how-to-undo-last-git-commit/#:~:text=Undo%20Last%20Git%20Commit%20with%20reset%20The%20easiest,commit%20will%20be%20removed%20from%20your%20Git%20history.)

## 指定文件版本回滚

实用性强的`checkout`
您可以像这样回滚某个文件到早些版本
`git checkout <commit_id> fileName`
可以先利用git log fileName来查询某个文件的历史版本(提案在commit号),然后将其回滚
![在这里插入图片描述](https://img-blog.csdnimg.cn/2e2f44f066ef4d239ff78172834bee2e.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_16,color_FFFFFF,t_70,g_se,x_16)
可以看到HEAD指针是不变的,但是文件版本回滚了(内容回滚)
当然其他文件不会受到影响
[参考链接](https://stackoverflow.com/questions/215718/how-can-i-reset-or-revert-a-file-to-a-specific-revision)

## 使用reset后push 时注意

当您在本地使用git reset 后,如果想要push到远程仓库,那么就需要使用--force参数进行强制push(否则会因为您的分支落后于远程仓库而push 不上去
(当然,如果您使用reset --hard 回到的commit_id 领先于或者持平于远程仓库,这时候您还是可以直接push,而不需要采用--force参数.