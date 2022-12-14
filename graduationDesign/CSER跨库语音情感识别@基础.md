[toc]

## 语音情感特征提取

- 语音情感识别的主要步骤包括**语音情感特征提取**和**情感分类器设计**.
  -  近年来, 研究人员对语音情感特征提取和情感分类器设计方面的研究做出了巨大的努力[16].

### 语音情感特征

- **语音情感特征**主要有 3 类: 
  - 韵律特征
  - 音质特征
  - 谱特征 

#### 韵律特征

-  韵律特征包括
  - **基音频率** 
  - **短时能量**等,
  - 一般通过与<u>韵母、语调</u>相关的韵律来表达; 

#### 音质特征

- 音质特征包括
  - **共振峰**(resonance peak) 
  - **谐波噪声比** (harmonics-to-noiseratio, HNR) 等
  - <u>与发声声道的物理性质相关</u>的声学特征;

#### 谱特征

- 谱特征包括
  - **梅尔频率倒谱系数** (Mel frequency cepstral coefficient, MFCC)
  - **类级(class-level) 谱特征** 
  - **语谱图**等. 

#### 小结

- 共振峰和MFCC 是语音情感识别中**两种常用的特征**, 
  - 共振峰(音质特征)是**音质的决定因素**, 可以反映声道的物理特征; 
  - MFCC(谱特征) 可以在很大程度上模拟人的听觉感知系统, 从而提高语音情感识别的性能

## 跨库语音情感识别

- 类似于普通的语音情感识别, 跨库语音情感识别一般也包括两个步骤: 

- 跨库语音情感特征提取和跨库情感分类器的设计,
-  即对源数据库和目标数据库的语音样本提取**域不变特征**, 然后训练语音情感分类器.

### 高层次自动化特征提取

#### 传统ML算法

- 传统ML算法严重依赖于音频质量
- DL算法可以从原始语音和声学特征中学习情感表征

- 传统的域不变特征提取方法侧重于手工特征的提取, 然后试图将源数据库和目标数据库映射到同一个特征空间, 并采用不同的方法最小化特征空间中两者的分布差异, 从而使在源数据库上训练得到的模型在目标数据库上有较好的效果.
-  但是, 手工提取的特征往往是低层次的, 与高层次的人类“情感”表达存在较大的“情感鸿沟”问题.
-  因此, 研究高层次的自动化特征提取方法用于跨库语音情感识别, 近年来备受关注.

