[toc]

## 官方下载@office下载安装

- [Download and install or reinstall Microsoft 365 or Office 2021 on a PC or Mac - Microsoft Support](https://support.microsoft.com/en-us/office/download-and-install-or-reinstall-microsoft-365-or-office-2021-on-a-pc-or-mac-4414eaaf-0478-48be-9c42-23adc4716658)
- [在电脑或 Mac 上下载并安装或重新安装 Microsoft 365 或 Office 2021 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/在电脑或-mac-上下载并安装或重新安装-microsoft-365-或-office-2021-4414eaaf-0478-48be-9c42-23adc4716658)

- [https://account.microsoft.com/services/microsoft365/install](https://account.microsoft.com/services/microsoft365/install)
  - 已购买的产品
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/1ad20ab62d3b439b81ca92d07163eb70.png)

- 或者访问官方教程:
  - [link](https://support.microsoft.com/zh-cn/office/%e5%9c%a8%e7%94%b5%e8%84%91%e6%88%96-mac-%e4%b8%8a%e4%b8%8b%e8%bd%bd%e5%b9%b6%e5%ae%89%e8%a3%85%e6%88%96%e9%87%8d%e6%96%b0%e5%ae%89%e8%a3%85-microsoft-365-%e6%88%96-office-2019-4414eaaf-0478-48be-9c42-23adc4716658?ui=zh-CN&rs=zh-CN&ad=CN)

## 第三方安装

- 有些第三方安装office项目可能被废弃了,备份的镜像站也可能会失效
- 但是相关项目不仅限于这里列出的这些
- 为了提高安装(部署)成功率,可以自己先卸载掉不想用的office或office365
  - 可以用geek扫描已安装的office
  - 另外UWP类型office启动器可以在设置里面搜索office,然后卸载相关应用
- 途径1,2,3不表示推荐等级,见仁见智

### 安装途径1(achieved)

- 这些资源来自github,由于网路环境的原因,有时打不开,请自行搜索访问方式(比如镜像站/fast)
- [加速 Microsoft Office 2021 install · GitCode](https://gitcode.net/xuchaoxin1375/microsoft-office-2021-install)
  - 提供简洁安装选项(可以只安装三件套(word,ppt,excel),而不安装Access,OneNote)

  - 得益于简洁安装,安装速度较快

  - 请认真阅读文档(文档中的下载链接可能失效,但是可以把仓库下载下来,解压运行其中的程序)
- [asheroto/Deploy-Office: Easily install the latest version of Microsoft Office 2019 or 2021. (github.com)](https://github.com/asheroto/Deploy-Office)
- [Release HEU_KMS_Activator(github.com)](https://github.com/zbezj/HEU_KMS_Activator/releases/tag/30.2.0)


### 安装途径2

- [LKY_OfficeTools: 一键自动化 下载、安装、激活 Office 的利器。 (gitee.com)](https://gitee.com/OdysseusYuan/LKY_OfficeTools/)国内用户推荐
  - [Mocreak: 基于 LKY_OfficeTools 构建的可视化版本。 (gitee.com)](https://gitee.com/OdysseusYuan/Mocreak)

- github上的仓库[Release LKY OfficeTools v1.2.1 · OdysseusYuan/LKY_OfficeTools · GitHub](https://github.com/OdysseusYuan/LKY_OfficeTools/releases/tag/v1.2.1)

#### 安装建议

- 安装前先检查原来组件是否卸载干净


#### 安装过程(控制台命令行版)

```bash

-----> 正在检查 Office 安装环境 ...
     √ 已通过 Office 安装环境检查。

     ★ 本工具默认安装 Word、PPT、Excel，并可选配更多组件：
                Outlook = 1     OneNote = 2     Access = 3
                Visio = 4       Project = 5     Publisher = 6
                Teams = 7       OneDrive = 8    Lync = 9
        如安装：Outlook、OneNote、Visio，请输入：1,2,4 后回车，如不增加组件，请直接按回车键。

        请输入追加的组件序号（多个组件请用逗号隔开）：
     √ 未附加其他组件，本工具将只安装默认的 Word、PPT、Excel 三件套。
....
....
------> 正在安装 Office v16.0.14332.20624 ...
     √ 已完成 Office v16.0.14332.20624 安装。

.....

------> 正在清理 冗余数据，请勿关闭或重启电脑 ...
      * 已跳过非必要流程 ...
     √ 已完成 冗余数据清理，部署结束。

     √ 您已成功完成 LKY Office Tools 所有流程，感谢您的使用。

请按 任意键 退出 ...

```

#### FAQ

- 中间激活的时候界面可能会卡住,可以适当的按回车刷新一下进度

### 安装途径3

- [Office-Tool: office软件部署 (gitee.com)](https://gitee.com/xuchaoxin1375/Office-Tool#https://gitee.com/link?target=https%3A%2F%2Fgithub.com%2FYerongAI%2FOffice-Tool%2Fwiki)
  - github上的仓库[YerongAI/Office-Tool: Office Tool Plus localization projects. (github.com)](https://github.com/YerongAI/Office-Tool/tree/main)
- 这主要项目主要是可以灵活的选择安装组件组合,可以选择的版本比较丰富,比如我可以下载最新的office 365家庭版,并且仅勾选部署word,ppt,excel
- 现在想要下载合适的版本,而不包含自己用不上的组件,是这类部署工具的主要功能
- 但是激活部分还得自己解决,网络上资源不少,不必多说;

#### 安装文档

- [初次安装 | Office Tool Plus 文档 (landian.vip)](https://otp.landian.vip/docs/zh-cn/deploy/#在线安装)
- 既有在线安装也有离线安装,通常用在线安装就好
- 安装前通常要检查一下是否已经安装了某些office软件,如果是先卸载(通常不能共存)

## office版本补充说明

- Microsoft Office是一款由Microsoft（微软）公司开发的综合性办公软件套装，包含了一系列用于文字处理、电子表格、演示文稿、数据库管理、电子邮件等功能的应用程序。
- 随着时间的推移，Microsoft Office已发展出多个版本，每个版本都有其特定的功能更新和改进.

### Microsoft Office历史主要版本

1. **Microsoft Office 2003**
   - 提供了经典的应用程序，如Word、Excel、PowerPoint、Outlook等，并引入了一些新功能，如InfoPath表单管理和OneNote笔记软件。

2. **Microsoft Office 2007**
   - 引入了全新的Ribbon界面设计，取代了传统的菜单栏，同时增加了Open XML文件格式支持。

3. **Microsoft Office 2010**
   - 支持云集成，允许用户在线保存文档并与他人协作；增强了多媒体支持和视觉效果。

4. **Microsoft Office 2013**
   - 更加强调触控优化和云服务集成，包括SkyDrive（现更名为OneDrive）的深度整合，以及Office应用商店的概念。

5. **Microsoft Office 2016**
   - 深化了对协同工作的支持，新增了实时共同编辑文档的功能，并增强了数据安全性和隐私保护。

6. **Microsoft Office 2019**
   - 面向一次性购买的消费者和商业用户的永久授权版本，包含了Office 365中部分特色功能，例如墨迹书写、设计增强和数据分析工具。

7. **Microsoft Office 2021**
   - 继续提供非订阅版本，增加了更多兼容性改进、性能提升和一些新特性，例如黑暗模式支持和跨应用程序的流畅设计。

### Microsoft 365（原Office 365）

- Microsoft 365是一个基于订阅的服务，除了包含传统Office应用程序外，还提供定期的云端更新、额外的在线服务

### Microsoft Office for Mac

- 同样经历了多次迭代，确保与Windows版本的功能接近，并针对Mac OS进行了优化。例如，Mac版Office 2016、2019和2021都具有与Windows对应版本相似的核心功能，同时也适应了Mac平台的设计语言和特性。

### 其他版本差异

- 不同版本的Office针对不同的用户群体，如家庭和学生版、小型企业版、专业增强版等，分别包含了不同数量的应用程序和服务，价格也有所不同。

- 家庭和学生版通常包含基础的Word、Excel、PowerPoint和OneNote，而更高阶的商业版或专业版可能还会包含Access、Publisher、Outlook等，并且可能具备高级的安全管理、合规性控制以及与企业环境集成的能力。

- Microsoft Office各版本的不同之处还在于它们是否支持长期服务频道（LTSC）或定期接收功能更新，其中Microsoft 365订阅用户可始终获得最新的功能和安全更新。


## 365版本

- [Microsoft 365 和 Office 2021 之间的区别是什么？ - Microsoft 支持](https://support.microsoft.com/zh-cn/office/microsoft-365-和-office-2021-之间的区别是什么-ed447ebf-6060-46f9-9e90-a239bd27eb96)

- [What's the difference between Microsoft 365 and Office 2021? - Microsoft Support](https://support.microsoft.com/en-us/office/what-s-the-difference-between-microsoft-365-and-office-2021-ed447ebf-6060-46f9-9e90-a239bd27eb96)

- Office 365和Office 2021都是微软的办公软件套件，但它们有一些关键的区别。

  1. 许可方式：Office 365是基于订阅的模型，用户需要每月或每年支付订阅费用来使用它。而Office 2021是基于永久许可证的模型，用户只需一次性购买即可永久拥有软件。
  2. 版本更新：Office 365是一款云端软件，它会定期获得新功能和更新，这些更新会自动应用到用户的计算机上。而Office 2021是一款本地软件，它只会在用户手动安装新版本时进行更新。
  3. 功能：Office 365提供了更多的功能和应用程序，例如Microsoft Teams、SharePoint、OneDrive等，这些应用程序可以在云端进行协作和共享。而Office 2021只包含传统的办公应用程序，如Word、Excel、PowerPoint等。
  4. 安全性：Office 365通过云端提供了更高的安全性和可靠性，因为数据存储在微软的服务器上，并受到微软的安全保护。而Office 2021则需要用户自己负责数据的备份和保护。
  5. 价格：Office 365的订阅费用相对较低，但需要每年支付。而Office 2021需要一次性购买，价格相对较高。


### 家庭版和专业版

Microsoft Office有多个版本，其中包括Office专业版和家庭版。这些版本的主要区别在于它们提供的功能和定价。

Office专业版包含更多高级功能，例如Access和Publisher等专业工具，以及更多的协作和安全功能。此外，Office专业版还包括Outlook的完整版本，而家庭版只包含Outlook的基本版。

另一个区别是定价。Office专业版通常比家庭版更昂贵，因为它提供了更多的功能和工具。

因此，如果您需要使用高级功能、专业工具或更强大的安全和协作功能，那么Office专业版可能更适合您。但是，如果您只需要基本的Office应用程序，并且想要更实惠的价格，那么家庭版可能更适合您。

## FAQ

- 以我操作的时候的情况说明:

  - 通过第三方方式安装后,显示的软件版本不一定准确,尤其是自己之前安装过旧版本的office

  - 我在尝试安装2021时,之前已经安装过2019,但是安装完2021后打开软件发现版本还是2019(这个版本时购买电脑时内置的正版)

  - 执行激活后才可以看到启动界面更新为Microsoft365(2021)

    - | ![在这里插入图片描述](https://img-blog.csdnimg.cn/c3b277499dad4ba986b2a24da255a0e2.png) | 启动界面       |
      | ------------------------------------------------------------ | -------------- |
      | ![在这里插入图片描述](https://img-blog.csdnimg.cn/dff1c098bc0b46f99c32957cf5c35e7f.png) | 版本和激活信息 |



## 官方的免费在线office(365)

- [免费的 Microsoft 365 Online | Word、Excel、PowerPoint](https://www.microsoft.com/zh-cn/microsoft-365/free-office-online-for-the-web)

- Office有两种主要形式：网页版和离线版。它们之间的主要区别在于它们的访问方式和功能。

  网页版Office是一种基于云的服务，可以通过网络浏览器访问。它包括Word、Excel、PowerPoint和OneNote等应用程序，并提供了基本的编辑和协作功能。网页版Office不需要在本地计算机上安装任何软件，因此它非常适合那些需要在不同设备之间轻松共享和协作文件的用户。

  离线版Office是一个完整的套件，包括Word、Excel、PowerPoint、Outlook、Access、Publisher等应用程序。它需要在本地计算机上安装，因此它的功能更加强大和丰富。离线版Office还可以在没有网络连接的情况下使用，因此它非常适合那些需要在没有网络连接的环境中工作的用户。

  虽然网页版Office可以在任何设备上使用，但它的功能相对于离线版Office来说还是比较有限的。离线版Office提供了更多高级功能和自定义选项，因此它更适合那些需要更强大工具的用户。

### 优点

- 好处是免费
- 而且不需要安装,有浏览器就可以使用

### 缺点

- 但是依赖于网络环境
- 部分功能缺失

