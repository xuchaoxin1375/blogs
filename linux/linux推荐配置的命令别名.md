#alias `<aliasName>="original alias"`

#这里的 `#`是为了放别复制粘贴到配置文件中,请保留它们
#新建aliases文件,如果需要为指定shell启用改别名配置,那么请将给文件复制一份(新名称为:bash_aliases/zsh_aliases)
#您可以在根目录或者/etc/目录下放置一份aliases文件,将其视为一份脚本文件(普通的脚本文件,然后在/etc/profile中配置运行改文件(aliases),这样一来,您不仅可以将别名单独放置到一个文件中,而且可以更加灵活控制要不要导入这个别名文件,甚至于,您可以在运行时手动的执行别名文件,灵活性大大滴)
#强烈建议您不要再别名文件中执行别名配置的其他行为,这样可能引起难以发现的异常,这是使用aliases文件来管理别名的一个约定🎶(aliases文件不应该插手其他领域)
#直接复制markdown的渲染后的内容到新建文件.aliases(推荐保存在/etc/下)

## #基础命令

* #编写本文件的时候建议使用文本模式来编辑(因为我们会用到#符号,会和markdown的instance render 发生冲突)
* #为了和某些内置命令区分开,您可以考虑将你的缩写以大写(首字母)或者增加某个前(后)置符(可以是未被系统占用的字符(例如 `_`,甚至是英文字母))作为一种区分标志
* #配置文件中不允许等号`=`和后面跟随的字符串值间有多余的格



- #😄basic alias definition:

  - alias a="alias"
  - a s="source"
  - a test="echo 'alias avalible'!"
  - a updateAliasNow="s /etc/aliases;echo 'the /etc/aliases was applied this session just now!'"

  - a wg="wget"
  - a vi="vim"
  - a v="vim"
- #😄with the basic alias definition of `alias` & `source`,these are optional configuration for you to config:

  - #s /etc/profile
    - #一般需要管理员权限(sudo)才可以更改该文件;`spf`
    - a vpf="vim /etc/profile"
    - a spf="s /etc/profile"
  - #s ~/.*rc
    - a  sb="s ~/.bashrc"
    - a sz="s ~/.zshrc"
- #😄zip/unzip/tar

  - a ta="tar xvf"
- #😄editor

  - a v="vim"
  - a vi="vim"
- #😄user management

  - a pd="pd"
  - a Gr="group"
# #for debian_like dist:
- a install="sudo apt install" 