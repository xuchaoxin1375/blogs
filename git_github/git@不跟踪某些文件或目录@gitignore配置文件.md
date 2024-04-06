[toc]

## abstract

- `.gitignore` 文件是 Git 版本控制系统中用于指定一组规则，定义那些不应被 Git 追踪和提交到版本库中的文件和目录的特殊文本文件。
- 文档:
  - 中文[Git - gitignore Documentation (git-scm.com)](https://git-scm.com/docs/gitignore/zh_HANS-CN)
  - 英文[Git - gitignore Documentation (git-scm.com)](https://git-scm.com/docs/gitignore#_name)

## 作用层次

- 是的，当Git决定是否应忽略某个路径时，它会按照特定的优先级顺序检查多个来源的`.gitignore`文件中的模式。优先级从高到低排列如下：

  1. **命令行指定的忽略规则**：如果通过命令行参数为特定操作指定了临时忽略规则，则这些规则具有最高的优先级。

  2. **当前目录的 `.gitignore` 文件**：位于当前目录（工作目录下的子目录）中的`.gitignore`文件中的规则优先级较高。

  3. **父目录的 `.gitignore` 文件**：Git会逐级向上查找，检查每一个父目录中的`.gitignore`文件，直到达到项目的根目录（即包含`.git`目录的地方）。更接近目标文件的父目录中的规则优先于更远离目标文件的父目录中的规则。

  4. **全局 `.gitignore` 文件**：用户级别的全局`.gitignore`文件，可以通过运行 `git config --global core.excludesfile` 来指定。

  5. **`$GIT_DIR/info/exclude` 文件**：存储在 Git 仓库本地 `.git/info/exclude` 文件中的规则，用于本仓库特有的忽略规则，但优先级低于上述的各个层次的`.gitignore`文件。

  在同一优先级范围内，如果有多个规则匹配同一个文件，Git将遵循“最后匹配”的原则，即最末尾出现的匹配规则将生效。这意味着，在一个`.gitignore`文件内部或者不同层级的`.gitignore`文件之间，后定义的规则能够覆盖之前定义的规则。

## 作用与用途

1. **忽略特定文件**：通过在 `.gitignore` 文件中列出文件名或模式，您可以轻松地排除一些文件或目录不参与版本控制。

2. **维护仓库整洁**：避免将编译产生的中间文件、日志文件、缓存、临时文件、IDE 的配置文件等非源码文件提交至版本库，从而保持仓库的简洁和高效。

3. **保护敏感信息**：防止包含敏感数据（如密钥、密码等）的文件被意外提交到公开或共享的代码仓库。

## 文件结构与规则
- **文件位置**：`.gitignore` 文件应位于项目的根目录下，这样 Git 就会在该项目的所有子目录中应用其中的忽略规则。


### 格式与语法：

- 每一行表示一条忽略规则。
- 规则可以是文件名、目录名或模式匹配字符串。
- 绝对路径或相对路径都可以。
- 开头的 `#` 表示注释，该行内容会被 Git 忽略，不作为规则处理。

### 可以使用通配符

- `*` 匹配任意字符序列（除了路径分隔符 `/`）
- `?` 匹配单个任意字符
- `[abc]` 匹配括号内的任何一个字符
- `[0-9]` 匹配数字范围
- `!` 取消忽略，紧跟 `!` 后面的规则将重新包含之前被忽略的文件。
- `**` 在与全路径名匹配的模式中，两个连续的星号（"`**`"）可能有特殊含义：
  - "`**`"在带斜杠目录之前，表示在所有目录中匹配。例如，"`**/foo`"匹配任何文件或目录的"`foo`"，与模式"`foo`"相同。"`**/foo/bar`"匹配任何文件或目录中直接位于目录"`foo`"之下的"`bar`"。
  - 路径后跟有 "`/**`" 表示匹配这个目录里面的所有文件。例如，"`abc/**`" 匹配相对于 `.gitignore` 文件的位置中目录 "`abc`" 内的所有文件，深度无限。
  - 一个斜杠后面是两个连续的星号再接上一个斜杠，匹配零个或多个目录。例如，"`a/**/b`" 匹配 "`a/b`"、"`a/x/b`"、"`a/x/y/b`"，等等，依此类推。
  - 其他连续星号被视为普通星号，将根据前面的规则进行匹配。
- 更多细节查看文档

### 具体规则举例：

- `*.log` 会忽略所有扩展名为 `.log` 的文件。
- `build/` 会忽略名为 `build` 的目录及其下的所有文件和子目录。
- `/temp/*` 只忽略根目录下 `temp` 目录里的内容。
- `!important.log` 即使上面有 `*.log` 规则，也会确保 `important.log` 不被忽略。

### 递归忽略与非递归忽略：

- 如果路径结尾没有斜杠 `/`，那么它会**同时匹配文件和目录**；
  - 目录可以理解为是一种特殊的文件,匹配文件就会匹配目录
- 如果以 `/` 结尾，则**只匹配目录**。
  - 目录可以理解为特殊文件(目录文件),但是文件却不一定是目录
  - 如果以`/`结尾,不会匹配普通文件,只匹配目录(文件夹)

### 前导斜线

- 如果一个匹配模式内部包含了斜线`/`,那么该模式是否前导斜线就无关紧要了(都当成有来处理)
- 因为后面有斜线的话说明前面是一个目录,而不可能是一个文件
- 例如:`doc/frotz` 和 `/doc/frotz` 模式在任何 `.gitignore` 文件中都有同样的效果。

## FAQ

### 已跟踪文件的忽略：

- 对于已经被 Git 跟踪的文件，仅修改 `.gitignore` 文件并不能使其停止被跟踪。
- 在这种情况下，可能需要执行 `git rm --cached <file>` 来从索引中删除文件，然后再添加到 `.gitignore` 中。

### 注意事项
- `.gitignore` 文件只影响尚未加入 Git 索引的文件，对已添加到版本库的历史记录中的文件无效。
- 如果有多个 `.gitignore` 文件在不同目录层级，优先级遵循最近原则，即越接近目标文件的 `.gitignore` 文件中的规则优先生效。



###  匹配符号链接(windows)
- 通常对于一个git仓库,尽量不要在仓库目录里创建符号链接,尤其是链接到仓库之外的目录或文件,容易导致clone时出现错误以及文件管理混乱的结果





##  关于已经被跟踪的文件/目录
-  如果是这样,`.gitignore`无法对已经跟踪的目录(文件)产生作用
	-	但是也不是完全没有作用,例如,某个目录(testDir)在被跟踪提交后,才将他添加到.gitignore以阻止git 对 testDir中新增的文件的跟踪,但是已经被跟踪的那部分文件,git依然跟踪管理着它们
- 您可以撤销跟踪,使得新配置的.gitignore能够生效.
 - ![在这里插入图片描述](https://img-blog.csdnimg.cn/b311b3b81d404b1ead5f3835c3135895.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
 - 注意对目录的撤销跟踪需要追加`-r`参数
 - 撤销还需要`commit`(相当于您对git给出最后的撤销确认)来使得.gitignore真正生效.
 - ![在这里插入图片描述](https://img-blog.csdnimg.cn/227a60f0dfc242558c019ae3e20a73d4.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
 - 上图中的`delete`是repos区中的删除,不影响工作区


##  只跟踪指定目录下的指定文件
从文档中我们可以知道,某个目录如果被排除跟踪,那么其子目录将无法再次被强调跟踪
因此,如果您想要强调跟踪的文件(子目录)所在的目录不能够从目录的角度排除跟踪(以`pathName`的形式写入.gitignore中),而应该使用变通的方式`pathName/*`如此一来,排除的就不是目录,而是该目录下的所有子文件(子目录),这样其中的子项目可以被`include again`
(即,编写关于被完全排除的目录的子项的反排除规则(强调包含)是不起作用的)

其他`pattern`也有类似的限制,所以,使用`pathName/*`这种形式往往会更加灵活.

Example to exclude everything except a specific directory foo/bar (note the /* - without the slash, the wildcard would also exclude everything within foo/bar):
##  2个小例子
涉及的语法以及含义:
- 表达式格式->含义
>`DirName/*->dirListItems(DirName)`
>`!item`->`includeItem(item)`
- 浅层
```bash
   #eclude everything except directory foo
   /*
   !/foo
```
  - 深层
```bash
 # for deeper specific path example:
   # exclude everything except directory foo/bar
    /*
    !/foo
    /foo/*
    !/foo/bar
```
##  另一实例
仅排除指定目录test,但是要保留该目录中的`.json`文件
![在这里插入图片描述](https://img-blog.csdnimg.cn/84866d1d1bc94b6f8a102b4f2c06ed90.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_14,color_FFFFFF,t_70,g_se,x_16)
![在这里插入图片描述](https://img-blog.csdnimg.cn/52cbbcd3466843f9a16612a5cb50d124.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/7197483f23d44d4d880d31780fb14bd2.png)
关于符号链接(symbolic/Junction)引入的目录,在里面设置的`.gitignore`将无法生效,您只可以在git管理的根目录或者非符号链接的子目录下创建有效的`.gitignore`













