

- [公开的语音文本情感数据集 ](https://blog.csdn.net/zsp123psz/article/details/107583653)
- [EmoDB Dataset | Kaggle](https://www.kaggle.com/datasets/piyushagni5/berlin-database-of-emotional-speech-emodb?resource=download)
- [Iemocap-full-release | Kaggle](https://www.kaggle.com/datasets/dejolilandry/iemocapfullrelease)



## savee

- [SAVEE Database | Kaggle](https://www.kaggle.com/datasets/barelydedicated/savee-database)
- [Surrey Audio-Visual Expressed Emotion (SAVEE) Database](http://kahlan.eps.surrey.ac.uk/savee/)

### 摘要

- 萨里视听情感数据库( SAVEE )已经被记录为开发自动情感识别系统的先决条件。
- 该数据库由4名男性演员在7种不同情绪下的录音组成，共480段英国英语话语。
- 句子从标准的TIMIT语料库中选取，并对每种情感进行语音平衡。
- 数据记录在具有高质量视听设备的可视媒体实验室中，并进行处理和标记。
- 为了检查录音的质量，由10名受试者在音频、视频和视听条件下对录音进行评估。
- 使用标准特征和分类器分别对音频、视频和视听模态建立分类系统，非特定人识别率分别达到61 %、65 %和84 %

### 结论

- 我们记录了一个具有六种基本情绪和中性的表达情绪的视听数据库。
- 该数据库由4位英语演员所说的语音平衡的TIMIT语句组成，总共480句。
- 该数据库由10名受试者对每个音频、视觉和视听数据的可识别性进行评估。主观评价结果显示，相对于音频，视觉数据具有更高的分类精度，结合两种模态后整体性能得到提升。
- 在数据库上的说话人依赖和非说话人实验中取得了相当高的分类准确率，这遵循了与人类评价者相似的情感分类结果模式，即视觉数据的表现优于音频，而视听结合的整体性能得到了提高。
- 人类评价和机器学习实验结果表明了该数据库对情感识别领域研究的有用性。

## RAVDESS

- [RAVDESS Emotional speech audio | Kaggle](https://www.kaggle.com/datasets/uwrfkaggler/ravdess-emotional-speech-audio?resource=download)

  - **File naming convention**

    Each of the 1440 files has a unique filename. The filename consists of a 7-part numerical identifier (e.g., 03-01-06-01-02-01-12.wav). These identifiers define the stimulus characteristics:

    *Filename identifiers*

    - Modality (01 = full-AV, 02 = video-only, 03 = audio-only).
    - Vocal channel (01 = speech, 02 = song).
    - Emotion (01 = neutral, 02 = calm, 03 = happy, 04 = sad, 05 = angry, 06 = fearful, 07 = disgust, 08 = surprised).
    - Emotional intensity (01 = normal, 02 = strong). NOTE: There is no strong intensity for the 'neutral' emotion.
    - Statement (01 = "Kids are talking by the door", 02 = "Dogs are sitting by the door").
    - Repetition (01 = 1st repetition, 02 = 2nd repetition).
    - Actor (01 to 24. Odd numbered actors are male, even numbered actors are female).

    *Filename example: 03-01-06-01-02-01-12.wav*

    1. Audio-only (03)
    2. Speech (01)
    3. Fearful (06)
    4. Normal intensity (01)
    5. Statement "dogs" (02)
    6. 1st Repetition (01)
    7. 12th Actor (12)
       Female, as the actor ID number is even.

    **How to cite the RAVDESS**

    *Academic citation*

    If you use the RAVDESS in an academic publication, please use the following citation: Livingstone SR, Russo FA (2018) The Ryerson Audio-Visual Database of Emotional Speech and Song (RAVDESS): A dynamic, multimodal set of facial and vocal expressions in North American English. PLoS ONE 13(5): e0196391. https://doi.org/10.1371/journal.pone.0196391.

    *All other attributions*

    If you use the RAVDESS in a form other than an academic publication, such as in a blog post, school project, or non-commercial product, please use the following attribution: "The Ryerson Audio-Visual Database of Emotional Speech and Song (RAVDESS)" by Livingstone & Russo is licensed under CC BY-NA-SC 4.0.







