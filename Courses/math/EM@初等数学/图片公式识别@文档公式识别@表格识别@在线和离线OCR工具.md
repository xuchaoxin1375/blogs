[toc]



## abstract

- 本文介绍免费图片文本识别(OCR)工具,包括普通文字识别,公式识别,甚至是手写公式和文字
- 重点在于免费和好用,不失选择的多样性
- 虽然公式识别的难度远大于普通文字的识别难度,但是随着技术的发展,公式识别也会像文本识别那样易用,免费
- 其他重要的AI应用(这里不展开)
  - 还有表格识别,尤其是复杂表格的识别
  - 逼真(接近真人播音员朗读效果)的文本朗读语言生成
- 本文内容可能会随着时间的逝去而过时,某些东西将来可能不那么好用,也可能变得好用,也可能出现更好的工具

## 普通文字识别

- 这类软件或平台十分的多,早已普及,比如qq/微信都有文本识别的功能
  - 有人把微信里的ocr功能作为后台设计了一个本地OCR,并且接入语音朗读
- 那么主要比较的是识别速度和精度,以及易用程度,比如能否离线识别,连续识别的体验,跨平台如何,费用等方面
- 当然能够识别公式的平台通常也能识别普通文本(但是个别模型为了提高公式识别精度,仅设计为用来识别公式)

## 本地软件识别公式

- [Umi-OCR: Umi-OCR  (gitee.com)](https://gitee.com/mirrors/Umi-OCR)
  - 是一款免费、开源、可批量的离线 OCR 软件，基于 PaddleOCR，适用于 Windows10/11 平台
  - 该链接同步github链接,源链接访问比较慢:[hiroi-sora/Umi-OCR: OCR software, free and offline.  (github.com)](https://github.com/hiroi-sora/Umi-OCR)
  - 软件主体和软件的插件可以用镜像加速下载



### 扩展插件下载

- [hiroi-sora/Umi-OCR_plugins: Umi-OCR 插件库 (github.com)](https://github.com/hiroi-sora/Umi-OCR_plugins)

- 该软件是多功能OCR软件,可以用于普通图片中文本识别,也可以识别二维码,甚至数学公式
  - 识别数学公式需要下载插件中的体积较大的模型
  - [hiroi-sora/Umi-OCR_plugins: Umi-OCR 插件库 (github.com)](https://github.com/hiroi-sora/Umi-OCR_plugins?tab=readme-ov-file#win7_x64_pix2text)
  - 插件名为win7开头,表示:平台兼容win7 以上(win10,11都可以用)，64 位
- 请仔细阅读仓库介绍和使用说明

### 小结

- 软件有多个模型供下载使用,识别公式的速度不是很快,模型推理时对于磁盘有一定的读写量
- 在有需要说别的时候,我个人会优先使用在线工具识别

## 在线识别

### 网站/API👺



- [Document & Formula OCR Service (simpletex.cn)👺](https://simpletex.cn/ai/latex_ocr)
  - 目前免费,支持手写符号识别,图片公式识别,文档公式识别
  - 并且有灵活的使用方式,包括api方式看起来很不错
  - 在线公式编辑器[Document Editor (simpletex.net)](https://simpletex.net/ai/editor)
- [Doc2X](https://doc2x.com/)
  - 精度也是不错的,有一定量的免费额度,次数蛮多的
  - 可以识别公式,也可以识别**表格**,包含公式的表格也不在话下,能够导出到word文件等
- [Pix2Text (P2T) - Free Mathpix Alternative (breezedeus.com)](https://p2t.breezedeus.com/)
  - 模型在成长期
  - 有免费额度,有开源版的模型

### Quicker整合(推荐)

- 如果经常使用,推荐用Quicker整合,实现截屏识别
- [公式识别3  动作信息 - Quicker (getquicker.net)👺](https://getquicker.net/Sharedaction?code=9666d404-be36-45de-438c-08d7f4f4652e)
  - 使用Quicker软件(需要常驻后台)及其动作插件动作实现截图识别公式,查看该链接教程进行配置
  - 可以选择多种api,教程中给出了推荐,目前用simpletex提供的api来识别很不错
  - 经常使用的话十分推荐此方案,如果只是偶尔用用,那么用在线网站就够了

- [Doc2X - by 蓝莓派 - 动作信息 - Quicker (getquicker.net)](https://getquicker.net/Sharedaction?code=c476b348-c182-47cc-f2b7-08dc63a5522a)

### 可视化编辑和识别公式

- [在线LaTeX公式编辑器-编辑器 (latexlive.com)](https://www.latexlive.com/home)
  - 需要登录,每个账户每天有少量免费次数(可能会调整)
  - 这类普通账户有免费次数的机制有的人会注册几个账号,甚至叫亲朋好友帮忙注册,不太优雅,用得多的话可以用其他免费的代替品

### 其他

- 著名的收费公式识别(具有少量的免费额度
  - [Mathpix OCR User Guide: Examples of Rendered Math and Text](https://mathpix.com/docs/ocr/examples?gclid=Cj0KCQjwlPWgBhDHARIsAH2xdNeG5GT376K1BZ3f1RyF-dlJTPd6k2oaSq5yu555SD9b6eNKlZnhTicaAnf-EALw_wcB)
- [图片转LaTeX公式在线 - LaTeX公式识别 - 照片转换成LaTeX公式 - 白描网页版 (baimiaoapp.com)](https://web.baimiaoapp.com/image-to-latex)

### 多模态大模型识别图片中的公式

- 做以下测试具有时效性,测试时都是免费功能,后续可能会有优化,也可能不再免费

  | 模型     | 示例                                                         | 评价(仅先测试时的版本)                                       |
  | -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | 通义千问 | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/a34457497c14445fb37e3d7464ba87fd.png) | 效果尚可,需要等一会,复杂公式需要久一些<br />点击通义回复的右下角复制按钮获得latex代码;但是默认缺乏排班,需要告诉模型追加源代码输出,而不仅仅是渲染后的公式 |
  | 文心一言 | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/448e9686554e48a6947de627d80e603d.png) | 免费模型(3.5)测的,一般般,复杂公式识别不全,期待优化           |

- 大模型很多,这里就举出两个例子,其他的模型比如智谱清言也可以识别,但是同样的例子出现了错误,将来可能会改进

### 排版

- 注意到通义模型可以较好的识别公式,个别细节可能需要微调

- 我们也可以继续和模型交谈,让他输出源代码,或者排版,甚至给出改进建议,例如我要求输出公式源代码而非展示markdown渲染结果

## 开源模型

- [Pix2Text/README_cn.md at main · breezedeus/Pix2Text (github.com)](https://github.com/breezedeus/Pix2Text/blob/main/README_cn.md)
- 当然还有其他的,一般能用在线免费的,就不需要本地部署了

