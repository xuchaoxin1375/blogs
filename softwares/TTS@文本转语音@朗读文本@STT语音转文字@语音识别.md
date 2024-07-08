[toc]



## abstract

文本转语音（TTS）技术的发展可简化为以下几个关键阶段：

1. **早期规则基础合成（1960s-1980s）**：使用基本音素拼接，声音机械不自然。
2. **波形合成（1980s-1990s）**：转向更小的语音单元，如音节，提升自然度；引入共振峰合成器。
3. **参数化合成（1990s-2000s）**：应用统计方法如HMMs，使用大数据集训练复杂模型。
4. **深度学习时代（2010s-至今）**：
   - 利用DNN改进声学模型。
   - 端到端模型（如Tacotron、WaveNet）直接从文本生成语音，提升质量。
   - 神经声码器提高效率。
   - 支持个性化与情感表达。

当前，TTS正向实时性、多语言支持、云端部署及关注伦理隐私方向发展。

## 文本转语音技术(TTS)

如果将TTS技术的发展分为两个大阶段，可以根据技术的本质和发展特点来命名：

### 1. 传统合成阶段（Traditional Synthesis Era）
这个阶段涵盖了从20世纪50年代到2000年代初期的语音合成技术，主要包括以下两种方法：
- **形式规则系统（Formant Synthesis）**：模拟人类声道的形态，通过规则生成语音。
- **拼接合成（Concatenative Synthesis）**：通过拼接预先录制的语音片段生成语音。

这个阶段的特点是语音生成方法相对简单，依赖于人工设计的规则和大量的录音数据，生成的语音自然度有限。

### 2. 智能合成阶段（Intelligent Synthesis Era）
这个阶段涵盖了从2000年代到现在的语音合成技术，主要包括以下两种方法：
- **统计建模合成（Statistical Parametric Synthesis）**：使用隐马尔可夫模型等统计方法对语音进行建模。
- **深度学习合成（Deep Learning Synthesis）**：利用深度神经网络等先进的机器学习技术生成高质量的语音。

这个阶段的特点是技术逐渐变得智能化，生成的语音自然度显著提高，尤其是深度学习方法使得合成语音几乎难以与真人语音区分。

### 总结
通过将TTS技术的发展分为“传统合成阶段”和“智能合成阶段”，我们可以清晰地看到技术从简单到复杂、从机械到智能的发展历程。这种划分方式能够帮助理解TTS技术的演进过程和未来的发展方向。

可以简单对TTS技术分类(阶段):传统TTS和现代化TTS(不妨称为逼真TTS或AI TTS)

现在的短视频制作基本上都采用AI加持的文本转语音,听起来很自然,接近专业播音员的水准;而早期的文本转语音也没有被彻底淘汰,特别是一些简单设备,比如一些仪器,采用老技术节约资源和成本

## windows上的文本转语音的官方方案

- [Download languages and voices for Immersive Reader, Read Mode, and Read Aloud - Microsoft Support](https://support.microsoft.com/en-us/topic/download-languages-and-voices-for-immersive-reader-read-mode-and-read-aloud-4c83a8d8-7486-42f7-8e46-2b0fdf753130?wt.mc_id=edgeui-readaloud-voices&ui=en-us&rs=en-us&ad=us)

  - [Install text-to-speech languages in Windows 10 and Windows 11](https://support.microsoft.com/en-us/topic/download-languages-and-voices-for-immersive-reader-read-mode-and-read-aloud-4c83a8d8-7486-42f7-8e46-2b0fdf753130?wt.mc\_id=edgeui-readaloud-voices&ui=en-us&rs=en-us&ad=us#ID0EDN)

  - [Speech settings and voices](https://support.microsoft.com/en-us/topic/download-languages-and-voices-for-immersive-reader-read-mode-and-read-aloud-4c83a8d8-7486-42f7-8e46-2b0fdf753130?wt.mc\_id=edgeui-readaloud-voices&ui=en-us&rs=en-us&ad=us#ID0EDL)

  - [Install a new Text-to-Speech language in Windows 8.1](https://support.microsoft.com/en-us/topic/download-languages-and-voices-for-immersive-reader-read-mode-and-read-aloud-4c83a8d8-7486-42f7-8e46-2b0fdf753130?wt.mc\_id=edgeui-readaloud-voices&ui=en-us&rs=en-us&ad=us#ID0EDJ)

  - [Text-to-Speech languages and voices available in Windows](https://support.microsoft.com/en-us/topic/download-languages-and-voices-for-immersive-reader-read-mode-and-read-aloud-4c83a8d8-7486-42f7-8e46-2b0fdf753130?wt.mc\_id=edgeui-readaloud-voices&ui=en-us&rs=en-us&ad=us#ID0EDH)

  - [Open Source Text-to-Speech languages](https://support.microsoft.com/en-us/topic/download-languages-and-voices-for-immersive-reader-read-mode-and-read-aloud-4c83a8d8-7486-42f7-8e46-2b0fdf753130?wt.mc\_id=edgeui-readaloud-voices&ui=en-us&rs=en-us&ad=us#ID0EDF)

  

## 使用办公软件的朗读功能

- [使用“朗读”文本到语音转换功能大声朗读文本 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/使用-朗读-文本到语音转换功能大声朗读文本-459e7704-a76d-4fe2-ab48-189d6b83333c)
- [Use the Speak text-to-speech feature to read text aloud - Microsoft Support](https://support.microsoft.com/en-us/office/use-the-speak-text-to-speech-feature-to-read-text-aloud-459e7704-a76d-4fe2-ab48-189d6b83333c)

### 利用命令行执行基础的TTS

语言设置里下载相应语言的语音包,比如英文

```powershell
function Out-Speech{
[CmdletBinding()]
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline)]
        [string]$Phrase
    )

    Add-Type -AssemblyName System.Speech

    $voice = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer

    $voice.Speak($Phrase)
}
```

调用:

```
PS> Out-Speech -Phrase "hello,world"
```

计算机就会朗读`hello,world`

## 使用浏览器朗读文本(推荐)

- edge浏览器的朗读功:[Read aloud (microsoft.com)](https://www.microsoft.com/en-us/edge/features/read-aloud?form=MA13FJ)
- 您可以将需要朗读的文本放到一个文本文件中(比如`txt`文件),然后用浏览器打开,比如edge
- 然后右键该页面,点击朗读(有多个语言和风格的朗读选项,还可以调节朗读速度,语音自然流畅比较像播音员,因此十分推荐)
- 手机上很多浏览器可以朗读网页或文本文件(可以将txt后缀改为html后打开阅读),例如qq浏览器(开屏广告太多,但其他页面是还算美观流畅)

### 沉浸式阅读

- [在Microsoft Edge中使用沉浸式阅读器 - Microsoft 支持](https://support.microsoft.com/zh-cn/topic/在microsoft-edge中使用沉浸式阅读器-78a7a17d-52e1-47ee-b0ac-eff8539015e1?form=MA13FJ)

## 风格迁移的文本转语音

- 有些软件提供专门训练过的能够模仿某个人的说话风格的TTS引擎
- 例如国内的剪映等软件,可以将文本转成模仿知名角色说话的效果,比如经典影视里的著名人物的配音声音
- 这类文本转语音趣味性强,部分风格功能可能要收费

## 在线TTS服务

- 许多网站提供文本转语音服务,一般都提供试听,生成,和下载功能
- 做得比较好的支持调整声音风格和语速,音量,停顿等细节
- 有些是免费的,有些是超额收费

## 相关开源项目或软件

- [ChatTTS: Text-to-Speech For Chat](https://chattts.com/)

- [2noise/ChatTTS: A generative speech model for daily dialogue. (github.com)](https://github.com/2noise/ChatTTS)
  - 支持笑声等副语言现象,十分逼真

## AI TTS的重要意义

- 现代化AI加持的TTS能够结合大语言模型,能够让人机交互变得更加自然
- 大语言模型可以生成接近人类的语言风格,再配合自然的TTS,使得人机交流向前迈进了一大步

AI驱动的文本转语音（TTS）技术在多个领域具有深远的意义和影响，主要体现在以下几个方面：

1. **无障碍沟通**：对于视障人士或阅读障碍者而言，TTS系统能够将书面文字转化为语音，帮助他们获取信息，提高了信息的可访问性。

2. **教育与培训**：TTS可以用于制作有声读物、电子教材以及语言学习材料，为学生提供多样化的学习方式，特别是对听力学习者更为友好。

3. **娱乐与媒体**：在播客、有声书、游戏和电影等娱乐产业中，高质量的TTS可以创造出更加真实的声音体验，增强用户沉浸感。

4. **客户服务与自动化**：企业通过TTS实现电话客服自动化，提供24/7的服务，同时降低人力成本，提升客户满意度。

5. **智能设备与物联网**：智能家居、车载导航系统、虚拟助手等智能设备依赖TTS技术与用户进行语音交互，使得操作更加便捷和人性化。

6. **语言普及与全球化**：多语言TTS支持促进了跨语言沟通，有助于文化的交流和全球信息的传播。

7. **个性化与定制化**：随着技术的进步，TTS能够模仿特定的声音特征，为用户提供更加个性化的语音服务，如创建虚拟发言人或恢复失去的嗓音。

## 语音转文字技术(STT)

语音转文字（Speech-to-Text, STT）技术将语音转换为文字，常用于语音助手、字幕生成和语音输入。其基本步骤如下：

### 基本步骤

语音转文字技术通过声音采集、预处理、特征提取、声学建模、语言建模和解码步骤，将语音转换为文字。

### 应用实例

- **语音助手**: 如Siri、谷歌助手。
- **实时字幕**: 会议、视频字幕。
- **语音输入**: 用语音代替打字。

### 相关服务和软件产品

#### 基础免费

- 很多输入法和手机系统自带的无障碍功能里,有STT功能(语音识别)
- windows也自带了语音识别功能,例如win11上通过`win+H`可以打开识别窗口
  - [Use voice typing to talk instead of type on your PC - Microsoft Support](https://support.microsoft.com/en-us/windows/use-voice-typing-to-talk-instead-of-type-on-your-pc-fec94565-c4bd-329d-e59a-af033fa5689f)


#### 专业收费

- AI 服务平台提供的服务,比如录音转写,有些是部分免费,超额收费;这类服务往往比较强大,可以分辩会议里的发言人
  - [首页 - 通义听悟 (aliyun.com)](https://tingwu.aliyun.com/home)
  - [语音听写_语音识别-讯飞开放平台 (xfyun.cn)](https://www.xfyun.cn/services/voicedictation)
  - [讯飞听见-免费在线录音转文字-语音转文字-录音整理-语音翻译软件 (iflyrec.com)](https://www.iflyrec.com/)
  - 类似的产品有很多


## 相关技术小结

### TTS (Text-to-Speech)
- **功能**：将文本转换成语音。
- **用途**：电子书朗读、智能助手、教育辅助、屏幕阅读器。
- **流程**：文本分析 → 语音合成 → 音频输出。

### STT (Speech-to-Text)
- **功能**：将语音转换成文本。
- **用途**：实时字幕、语音命令、会议记录、即时通讯。
- **流程**：语音捕获 → 信号处理 → 语音识别 → 文本输出。

### 主要区别
- **方向**：TTS由文到音，STT由音到文。
- **挑战**：TTS在于语音自然度，STT在于识别准确性。
- **应用**：互补作用，共同实现人机语音交互。