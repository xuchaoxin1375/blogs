---
theme: gaia
class: lead
marp: true
paginate: true
style: |
  section{
    padding:1rem;
  }
  
  li,ul{
    list-style-type:none ;
    margin:0 auto;

  }
  ul,section{
    overflow:auto;
  }
---

<!-- size: 4:3 -->
<!-- metadata中不允许注释,否者将破坏规则 -->
<!-- <style>
</style> -->
<!-- <link rel="stylesheet" href="../styles/style.css"> -->

<!-- 利用元素审查来了解marp的页面到底对应了html中的那种元素以及样式 -->

# 个性化 词汇学习

---

> 大学生英语学习工具型小程序
> 集四级/六级/考研/语法/学习规划/`拼写检查`/查词翻译等功能为一体的小程序

## 原型链接

[modaoDesign](https://modao.cc/app/CMLTThqNr8ojxs36dKaQQk) 《EnglishLearningAsistant》

---

## 主页@main1

---

### 主页功能

---

#### 还未查单词时的首页

- 每日一图(轮播图)
- 每日一句(英文/中文)
- 单词收藏

---

#### 单词查询/翻译

- 查询单词
- 查词记录
- 近义词对比
- 句子翻译

---

#### 未搜到单词

- 纠正猜测&长句推荐

---

### 简要交互逻辑

- 在用户查询单词之前显示 bing 的图片和图片内容介绍
- 用户按下 search 后,切换为翻译解释界面

---

### 对应的原型

---

#### 主界面

- ![1647516184561.png  bg right contain 80%](https://s2.loli.net/2022/03/18/sIGrixtCMNgQeUP.png)

---

#### 大纲分类

- ![1647516250871.png  bg right contain 80%](https://s2.loli.net/2022/03/18/W7xdLjQhGsNO4Dv.png)

---

#### 单词详情

- ![1647533937137.png  bg right contain 80%](https://s2.loli.net/2022/03/18/R1piFjWEHsbNMhI.png)

---

#### 纠正猜测&长难句推荐

- ![1647532171222.png  bg right contain 80%](https://s2.loli.net/2022/03/18/wAN8K3kmtxEQTiv.png)

---

### 实现

#### 每日一图来源

> Bing:`https://cn.bing.com/HPImageArchive.aspx?format=js&n=2&mkt=en-us`

---

#### 单词详情:

- 查询服务由后台数据库提供(poweredByOpenSourceDictionary),获取更多解释
- 近义词(匹配原理)
  - 可以将考纲中的单词的每个单词作一个排序,然后在整体做一个排序,得到一个用于比较相似单词的表格
    - 可以计算好后通过硬编码的形式存放在容器中.
  - 将被排序单词也做个词内字母排序
  - 通过上述的预处理可以大幅减少使用过程中匹配形近词的计算量;
  - 匹配出至少在字母组成以及长度两方面上相似的单词

---

## 大纲背诵@main2

---

### 功能

- 查看大纲词汇列表(来自新东方资料)
  - 查看列表中单词的收藏情况
- 学习进度
  - 跳转到上一次离开的地方
- 卡片式背诵单词
  - 简洁卡片模式
  - 正常卡片模式
    - 单词详情页可以查看别人的批注(记忆技巧等)

---

- 发表自己的批注
- 查看其他用户评价的平均值
- 自己为单词难度打分
- 收藏单词

---

### 原型

#### 学习进度

- ![1647533179552.png bg right contain 70%](https://s2.loli.net/2022/03/18/rvTB7bD4O6MLUJN.png)

---

#### 简洁模式卡片

- ![1647532685281.png bg right contain 80%](https://s2.loli.net/2022/03/18/lutUq27ZicIXOvb.png)

---

#### 卡片:正常模式

- ![1647532961778.png  bg right contain 80%](https://s2.loli.net/2022/03/18/dSEe8QmxMjl3oUa.png)

---

#### 给单词添加批注

- ![1647563564238.png  bg right contain 80%](https://s2.loli.net/2022/03/18/WJVpYSlijnGwQ3C.png)

---

#### 词汇列表

- ![1647533051662.png  bg right contain 80%](https://s2.loli.net/2022/03/18/6wqazJgBe4DkhTl.png)

---

### 设计说明

- 大学高频词汇以考研高频词为主
- 批注
  - 可以是记忆技巧
  - 相关短语/俚语等
- 背诵模式卡片选择
  - 简单模式下没有批注功能
- 背诵进度显示支持云同步
- 难度打分的依据包括
  - 单词的长短
  - 词形变化和用法的多少
  - 意思的多寡

---

#### 每个单词详情页面中设置元素

- 基本中文释义
- 收藏按钮收藏之后可以到`我的`页面查看
- 通过左右滑动来切换卡片

---

#### 实现:

> - 分析一个实体的信息应该怎么被保存,可以分析
>   - 一条 Annotation 具从属于那些实体(外键),包括:
>     - user
>     - word
>   - 自身属性:内容 content
> - 完整一些
>   - 还可以包括评论的
>     - 时间(time)
>     - 点赞数(like)
>     - 其他可能的附加属性(比如评论修改等)

---

> - 需要考虑到的一些问题
>   - 一个用户针对同一个单词可能发送多条批注
>     - 主键就可以设置为:
>       - 主属性集(user+word+time)
>       - 或者简单的新增一个实体本身不具有的属性(批注 ID)来做为主键

---

> - 批注是否可删除
>   - 如果支持删除,可以为某条评论设立后继评论字段(用于删除该评论下的回复,而前驱评论可以没有(不渲染空内容出来))

---

## 考试提分助手@main3

### 功能

- 考试大纲查阅
  - 四级
  - 六级
  - 研究生
- 语法纲要速查
  - 基础语法
  - 进阶语法
- 长难句学习
- 学习规划助手
- 单词随机抽查

---

### 原型

- 选取考试大纲类别
  - ![1647533384115.png  bg right contain 80%](https://s2.loli.net/2022/03/18/ZFPmER1yObkBCfN.png)

---

- 语法纲要速查
- 语法大纲
  - ![1647533750320.png  bg right contain 80%](https://s2.loli.net/2022/03/18/1ldD3ZQXHIzTMrm.png)

---

- 精选长难句学习
  - ![1647533659934.png  bg right contain 80%](https://s2.loli.net/2022/03/18/qh3QRzkBPYuUIDX.png)

---

- 学习规划
  - ![1647533308121.png   bg right contain 80%](https://s2.loli.net/2022/03/18/LMVA34SP7cgkBs8.png)

---

- 随机抽查单词
  - ![1647533628731.png  bg right contain 80%](https://s2.loli.net/2022/03/18/o5dLQEuaC17PImp.png)

---

### 设计说明

#### 规划助手

- 用来帮助用户规划每天学习/每周的学习量,督促用户学习,增强用户的时间观念

#### 长难句练翻译

- 根据精选的长难句练习语法能力,翻译能力和阅读能力和写作能力

---

## 用户中心@main4

### 功能

- _我的成就_
  - 显示用户号龄
  - 每日打卡签到
  - 排名坚持天数
- 考试倒计时
- 我的记录
  - 我的收藏列表
  - 我的查词记录
  - 跳转到单词详情回顾
- 问题反馈

---

### 原型

- 授权登录
  - ![1647533542201.png  bg right contain 80%](https://s2.loli.net/2022/03/18/gprVRKzYU7F29vP.png)

---

- 主要布局
  - ![1647533767010.png  bg right:70% contain ](https://s2.loli.net/2022/03/18/AOIafyZuohE6mSL.png)

---

- 考试倒计时
  - ![1647565322305.png  bg right contain 80%](https://s2.loli.net/2022/03/18/mvfsoGTieM7LcX1.png)

---

- 查词记录
  - ![1647534118228.png  bg right contain 80%](https://s2.loli.net/2022/03/18/JlCdSK9UOHQIkc7.png)

---

- 反馈与改进
  - ![1647533803658.png  bg right contain 80%](https://s2.loli.net/2022/03/18/dGMQgeLWcpau83U.png)

---

### 实现

#### 每日打卡

- 累计用户学习天数
- 不同用户打卡天数排行榜(待定)
  - 本周排行
  - 累计(全部)排行

---

#### 考试倒计时

- 下拉框(可选择四六级/考研英语)
- 表单设定考试日期
  - 提供往年考试日期参考来估算倒计时

---

<!-- <style>
  h4{
    color:hotpink;
  }
  </style> -->

#### 查词记录

- 将用户查询过的单词用专门的数据库表记录起来
- 以列表(可以美化卡片列表)的形式渲染出来

---

#### 问题反馈/改进

- 提供异常反馈接口给用户
- 可以建议新功能

---

## 技术选型

- 微信小程序+mysql+node.js(express)
- 数据库
  - 用户
    - 存储用户基本信息(昵称/密码)
    - 学习记录/进度
    - 收藏
  - 单词
    - 保存组织词典库以提供查词服务
    - 用户对单词的批注以及难度评分
- 后端框架提供 api 给前端操作数据库等服务

---
