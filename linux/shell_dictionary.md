@[toc]

# shell_命令行查单词/shell英文词典工具包(dict/trans/wd)

> - 由于平时阅读英文文献/文档的时候经常需要查词
>
> - 而自己的工作环境又恰好是命令行,因此希望能够有一种命令行词典共学习使用

## references

- [software recommendation - Is there an offline command-line dictionary? - Ask Ubuntu](https://askubuntu.com/questions/191125/is-there-an-offline-command-line-dictionary)
- [command line - Is it possible to translate words via terminal? - Ask Ubuntu](https://askubuntu.com/questions/380847/is-it-possible-to-translate-words-via-terminal)
- [Shell/Terminal: 命令行词典, 命令行字典, 命令行英汉字典, translate shell, 命令行查词工具, 终端字典 (ikeepstudying.com)](https://justcode.ikeepstudying.com/2018/05/shell-terminal-命令行词典-命令行字典-命令行英汉字典-translate-shell/)
- [Linux终端下查单词(极简)](https://blog.csdn.net/xiangxianghehe/article/details/79157738)

## 离线方案:

### sdcv

> - 性能好,支持牛津/朗文等词典
> - 国内可能下载不下来词典

```
# cxxu @ CxxuWin11 in /usr/share/stardict/dic [16:42:51]
譬如搜索单词"contribute"
$ sdcv contribute
Found 2 items, similar to contribute.
###朗文结果
-->Longman Dictionary of Contemporary English
-->contribute

v   [Date: 1500-1600; Language: Latin; Origin: , past participle of  contribuere, from  com- (  COM-) +  tribuere (  TRIBUTE)]//
  1 [I and T] to give money, help, ideas etc to something that a lot of other people are also involved in:  contribute to/towards//  --City employees cannot contribute to political campaigns.//  contribute sth to/towards sth//  --The volunteers contribute their own time to the project.//
  2 [I] to help to make something happen:  --Stress is a contributing factor in many illnesses.//  contribute to//  --Alcohol contributes to 100,000 deaths a year in the US.//  contribute substantially/significantly/greatly etc to sth //  --Enya's success has contributed substantially to the current interest in Celtic music.//
  3 [I and T] to write articles, stories, poems etc for a newspaper or magazine:    contributor//  contribute to//  --one of several authors contributing to the book//
###牛津结果
-->Oxford Advanced Learner's Dictionary
-->contribute

verb
  1  ~ (sth) (to / towards sth) to give sth, especially money or goods, to help sb/sth:
[VN] The writer personally contributed ｣5 000 to the earthquake fund. * [V] Would you like to contribute to our collection? * Do you wish to contribute?
  2  [V] ~ (to sth) to be one of the causes of sth:
Medical negligence was said to have contributed to her death. * Human error may have been a contributing factor.
  3  ~ (sth) to sth to increase, improve or add to sth:
[V] Immigrants have contributed to British culture in many ways. * [VN] This book contributes little to our understanding of the subject.
  4  ~ (sth) (to sth) to write things for a newspaper, magazine, or a radio or television programme; to speak during a meeting or conversation, especially to give your opinion:
[VN] She contributed a number of articles to the magazine. * [V] He contributes regularly to the magazine 'New Scientist'. * We hope everyone will contribute to the discussion.

```



### dict

#### 官方网站

- [dict.org](http://dict.org/bin/Dict)官方网站,在线版本

##### 词典数据来源

> 支持多语言,但是不支持中文
>
> - 默认英英词典

- [How to look up dictionary via command line on Linux - Xmodulo (archive.org)](https://web.archive.org/web/20180816203245/http://xmodulo.com/how-to-look-up-dictionary-via-command-line-on-linux.html)

- `sudo apt install dict dictd dict-gcide`

  - 较新版本中,仅安装`dict `似乎也可以用(但是内置词典较多,性能不佳)

  - ```
    ┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-13 03:54:35]
    └─[0] <> dpkg -l dict*|grep ii
    ii  dict             1.13.0+dfsg-1 amd64        dictionary client
    ii  dict-devil       1.0-13.1      all          "The Devil's Dictionary" by Ambrose Bierce
    ii  dict-gcide       0.48.5+nmu2   all          Comprehensive English Dictionary
    ii  dict-wn          1:3.0-37      all          electronic lexical database of English language for dict
    ii  dictd            1.13.0+dfsg-1 amd64        dictionary server
    ii  dictzip          1.13.0+dfsg-1 amd64        compression utility for dictionary databases
    ```

  - 可见上述安装将安装词典客户端`dict`词典服务`dictd(daemon)`

  - 词典数据库`dict-gcide`

    - 不同数据库可以对应有不同的语言(英->法)

    - 有些词典可能默认安装`dict-wn`(wordNet)

    - 查看可安装的词典(数据库)`apt-cache policy dict*|less`


#### 查看已安装的可用数据库

> 如果dictd服务没有启动,且尚未显示安装某个词典,那么会列出所有词典名称(联网查询)

- `dict -D|less`

- ```bash
  ┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-13 03:58:51]
  └─[130] <> dict -D|less
  Databases available:
   gcide          The Collaborative International Dictionary of English v.0.48
   wn             WordNet (r) 3.0 (2006)
   moby-thesaurus Moby Thesaurus II by Grady Ward, 1.0
   elements       The Elements (07Nov00)
   vera           V.E.R.A. -- Virtual Entity of Relevant Acronyms (February 2016)
   jargon         The Jargon File (version 4.4.7, 29 Dec 2003)
   foldoc         The Free On-line Dictionary of Computing (30 December 2018)
   easton         Easton's 1897 Bible Dictionary
   hitchcock      Hitchcock's Bible Names Dictionary (late 1800's)
   bouvier        Bouvier's Law Dictionary, Revised 6th Ed (1856)
   devil          The Devil's Dictionary (1881-1906)
   world02        CIA World Factbook 2002
   gaz2k-counties U.S. Gazetteer Counties (2000)
   gaz2k-places   U.S. Gazetteer Places (2000)
   gaz2k-zips     U.S. Gazetteer Zip Code Tabulation Areas (2000)
   fd-hrv-eng     Croatian-English FreeDict Dictionary ver. 0.1.2
   fd-fin-por     suomi-português FreeDict+WikDict dictionary ver. 2018.09.13
   fd-fin-bul     suomi-български език FreeDict+WikDict dictionary ver. 2018.09.13
   fd-fra-bul     français-български език FreeDict+WikDict dictionary ver. 2018.09.13
   fd-deu-swe     Deutsch-Svenska FreeDict+WikDict dictionary ver. 2018.09.13
   fd-fin-swe     suomi-Svenska FreeDict+WikDict dictionary ver. 2018.09.13
   .....
  ```

- 或者

  - `dict -I|less`

  - ```
    ┌─[cxxu@cxxuAli] - [~] - [2022-04-13 04:06:07]
    └─[0] <> dict -I
      dictd 1.12.1/rf on Linux 4.15.0-175-generic
      On cxxuAli: up 133.000, 3 forks (81.2/hour)
    
      Database      Headwords         Index          Data  Uncompressed
      gcide              203645       3859 kB         12 MB         38 MB
      moby-thesaurus      30263        528 kB         10 MB         28 MB
      
      
      #另一台主机 
      
      ┌─[cxxu@CxxuWin11] - [/mnt/c/Users/cxxu] - [2022-04-13 04:02:07]
    └─[20] <> dict -I
      dictd 1.12.1/rf on Linux 4.19.0-10-amd64
      On dict.dict.org: up 485+15:43:20, 109918515 forks (9430.4/hour)
    
      Database      Headwords         Index          Data  Uncompressed
      gcide              203645       3859 kB         12 MB         38 MB
      wn                 147311       3002 kB       9247 kB         29 MB
      moby-thesaurus      30263        528 kB         10 MB         28 MB
      elements              142          2 kB         17 kB         53 kB
      vera                12016        136 kB        213 kB        709 kB
      jargon               2314         40 kB        565 kB       1346 kB
      foldoc              15170        301 kB       2215 kB       5423 kB
      easton               3968         64 kB       1077 kB       2648 kB
      hitchcock            2619         34 kB         33 kB         85 kB
      bouvier              6797        128 kB       2338 kB       6185 kB
      devil                1008         15 kB        161 kB        374 kB
      world02               280          5 kB       1543 kB       7172 kB
      gaz2k-counties      12875        269 kB        280 kB       1502 kB
      gaz2k-places        51361       1006 kB       1711 kB         13 MB
      gaz2k-zips          33249        454 kB       2123 kB         15 MB
      --exit--                0          0 kB          0 kB          0 kB
      fd-hrv-eng          79814       1816 kB       1633 kB       4819 kB
      fd-fin-por          10755        190 kB        512 kB       1306 kB
      fd-fin-bul          10789        185 kB        525 kB       1348 kB
      fd-fra-bul          11009        182 kB        290 kB        793 kB
      fd-deu-swe          38957        730 kB       2348 kB       6102 kB
      fd-fin-swe          12309        221 kB        599 kB       1525 kB
    ```

  - 

####  短语匹配
>tab 补全单词
```bash
┌─[cxxu@ubuntu] - [~] - [2022-04-13 03:44:53]
└─[0] <> dict make
make               make-believe       Make-peace         make-up
Make               Make-believe       Maker              makeup
Make\ and\ break   Maked              makeready          make\ water
Makebate           Make-game          make\ reparation   Makeweight
make-belief        make\ known        make\ reparations  make-work
make\ believe      Makeless           makeshift

```

#### 词典性能

```bash
┌─[cxxu@cxxuAli] - [~] - [2022-04-13 04:00:00]
└─[0] <> dict -D
Databases available:
 gcide      The Collaborative International Dictionary of English v.0.48
```

> - 如果安装的词典很多,那么性能肯定是下降的
> - 建议仅安装需要的

#### 搜索可用词典

- `sudo apt-cache search "dict-"|grep ^dict-|less`
  - 空格翻页

#### 安装某个词典

- 譬如,安装WordNet(包名:`dict-*`,对应wn则为`dict-wn`)
- ` sudo apt install dict-wn`

#### dictd服务启动

- 确保dictd服务启动着,否则dict性能低下(貌似会联网请求)

  - ```bash
    ┌─[cxxu@ubuntu] - [~] - [2022-04-13 03:36:41]
    └─[0] <> ps aux|grep dictd
    dictd      12565  0.0  0.3  20604  6376 ?        Ss   03:34   0:00 dictd 1.12.1: 1/1
    cxxu       12596  0.0  0.0  17768   844 pts/0    S+   03:36   0:00 grep --color=auto --exclude-dir=.bzr --exclude-dir=CVS --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=.idea --exclude-dir=.tox dictd
    ```

    > 手动启动:`sudo dictd`

- 如果使用dictd提供服务,那么,仅显式安装的词典数据库会被本地的快速检索

#### dictd 获取帮助

- `man dictd`

##### dictd 配置文件

```bash
┌─[cxxu@ubuntu] - [~] - [2022-04-13 03:40:57]
└─[0] <> sudo vim /etc/dictd/                                                              

colorit.conf        dictd.conf          dictd.order
dict.conf           dictdconfig.alias*
```



#### 检查本地安装的词库

 - ```bash
   dict -I
   dict -D
   ```

 - 

- ```bash
  ┌─[cxxu@ubuntu] - [~] - [2022-04-13 03:36:48]
  └─[0] <> dict -I
    dictd 1.12.1/rf on Linux 5.11.0-27-generic
    On ubuntu: up 193.000, 2 forks (37.3/hour)
  
    Database      Headwords         Index          Data  Uncompressed
    gcide     203645       3859 kB         12 MB         38 MB
    
    ┌─[cxxu@ubuntu] - [~] - [2022-04-13 03:37:42]
  └─[0] <> dict -D
  Databases available:
   gcide      The Collaborative International Dictionary of English v.0.48
  ```

- 

## translate-shell(在线翻译)

- [soimort/translate-shell: Command-line translator using Google Translate, Bing Translator, Yandex.Translate, etc. (github.com)](https://github.com/soimort/translate-shell)

- > - 由于是在线的,在支持的内容较为完善:
  >
  > - 可定制性强,支持各种模式

### 基本特性

- 语种

- 汉语拼音

- 英文音标

- 词性

- > 不加目标语言,则默认是英英词典

国内gitee 源优化安装

- ```bash
  git clone https://gitee.com/mirrors/Translate-Shell.git
  cd Translate-Shell
  sudo apt install gawk
  make
  sudo make install
  
  ```

### 使用示例

#### 翻译单词

- `trans :<target language code> <source:word to be translate>`

```bash
# cxxu_kali @ CxxuWin11 in ~/Translate-Shell on git:develop o [16:14:31]
$  trans :zh apple
apple
/ˈapəl/

苹果
(Píngguǒ)

Definitions of apple
[ English -> 简体中文 ]

noun
    苹果
        apple
    苹
        apple

apple
    苹果, Apple
```

#### 翻译句子

```bash
# cxxu_kali @ CxxuWin11 in ~/Translate-Shell on git:develop o [16:16:08]
$  trans :zh "I want to test the tool"
I want to test the tool

我想测试这个工具
(Wǒ xiǎng cèshì zhège gōngjù)

Translations of I want to test the tool
[ English -> 简体中文 ]

I want to test the tool
    我想测试这个工具, 我想测试该工具


```

### 文档提纲

1. Getting Started by Examples
   1. Translate a Word
      1. [From any language to your language](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-24)
      2. [From any language to one or more specific languages](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-25)
      3. [From a specific language](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-26)
   2. [Translate Multiple Words or a Phrase](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-27)
   3. [Translate a Sentence](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-28)
   4. [Brief Mode](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-29)
   5. [Dictionary Mode](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-30)
   6. [Language Identification](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-31)
   7. [Text-to-Speech](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-32)
   8. [Terminal Paging](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-33)
   9. [Right-to-Left (RTL) Languages](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-34)
   10. [Pipeline, Input and Output](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-35)
   11. [Translate a File](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-36)
   12. [Translate a Web Page](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-37)
   13. [Language Details](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-38)
   14. [Interactive Translate Shell (REPL)](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-39)
2. [Usage](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-40)
3. [Code List](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-41)



## 排版优化版本(在线翻译/双语例句)

- 项目连接(gitee 加速)https://gitee.com/mirrors/wudao-dict.git

### 安装使用(python3 based)

- [for linux/mac wudao-dict](https://gitee.com/mirrors/wudao-dict?_from=gitee_search#linux-环境)

  - 分为两步

    - python依赖安装

      - 例如,对ubuntu

      - ```bash
        sudo apt-get install python3
        sudo apt-get install python3-pip
        sudo pip3 install bs4
        sudo pip3 install lxml
        ```

      - 

    - 项目clone

      - ```bash
        git clone https://gitee.com/mirrors/wudao-dict.git
        cd ./wudao-dict/wudao-dict
        sudo bash setup.sh #或者sudo ./setup.sh
        ```

      - 

> - 重新连接shell 以生效(zsh也生效)
> - 命令关键字/用法:`wd <word to be translate> `
