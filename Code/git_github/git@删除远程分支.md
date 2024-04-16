[toc]



# 删除远程分支

```cpp
$ git push <originRepositoryName> --delete <originBranchName>
```
`such as:
$ git push origin --delete serverfixed`
#  解释:
- 假设你已经通过远程分支做完所有的工作了——也就是说你和你的协作者已经完成了一个特性， 并且将其合并到了远程仓库的 master 分支（或任何其他稳定代码分支）。 

- 可以运行带有 --delete 选项的 git push 命令


- 来删除一个远程分支。 如果想要从服务器上删除 serverfix 分支，运行下面的命令：

```cpp
$ git push origin --delete serverfix
To https://github.com/schacon/simplegit
 - [deleted]         serverfix
```

- 基本上这个命令做的只是从服务器上移除这个指针。 Git 服务器通常会保留数据一段时间直到垃圾回收运行，所以如果不小心删除掉了，通常是很容易恢复的。