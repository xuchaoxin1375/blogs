- Nowadays emotion recognition from speech(SER)is a demanding research area for researchers because of its wide real-life applications.There are many challenges for SER systems such as the availability of suitable emotional databases,identification of the relevant feature vector,and suitable classifiers.
- This paper critically analysed the literature on SER in terms of (依据)speech databases,speech features,traditional machine learning (ML)classifiers and DL approaches along with the areas for future directions.
- In recent years,there is a growing interest of researchers to use deep learning (DL)approaches for SER and get improvement in recognition rate.
- The focus of this review is on DL approaches for SER.A total of 152 papers have been reviewed from years 2000-2021.We have identified frequently used speech databases and related accuracies achieved using DL approaches.
- The motivations and limitations of DL approaches for SER are also summarized.

Introduction

- In real-life communication,emotions are an important factor of human beings.Human emotion can be recognized from various forms like gestures,facial expressions,body postures and speech communication.Many physical attributes are also used for human emotion recognition such as temperature,heart rate,blood pres- sure,muscle activity,and skin resistance [1].
- Human emotion can also be well identified from speech communication.In human emotion recognition from speech,a fundamental research question is,to identify the emotional state of the speaker from a given speech signal.
- There are three important factors for [emotion recognition from speech] are "what is said",i.e.contents,"how it said", i.e.way/style of speaking,and "who is saying it"(i.e.whether male or female).
- Since the last decades,recognizing emotions from speech has been a growing research area for researchers because of its applications in many real-life problems like call centre conversation,automatic response system,online tutoring,spoken dialogue system,pain recognition,diagnosis of depression,and many more.
- A typical SER system identifies the emotional states from the speech signal,without having linguistic knowledge [2].The first challenge faced by researchers is to determine the relevant information(speech features)which could be extracted from the speech signals to identify the emotional states [3,4].The second challenge is to identify the suitable classifiers [5].
- DL has come as a new attractive algorithm of ML in the last decade[6]
- DL algorithms are usually the extension of neural networks with multiple layers of linear and nonlinear operations.
- To enhance the capacity of computers mostly DL approaches are used so that computers can understand what humans can do,which includes emotional recognition from speech.
- In the critical analysis of SER,there are three main factors such as speech emotional data bases,speech features,and classifiers.This paper includes the detailed literature of speech emotional databases,speech features, and traditional ML and DLbased approaches from 2000 to 2021. 
- Although many papers are presenting a review of existing research in SER,it seeks to provide analytical information of the existing literature and outcome of SER over the said period.
- For SER,hand crafted features of speech can be used as input to ML approaches like SVM,GMM,HMM,KNN,Decision Tree etc.DL approaches like CNN,RNN,LSTM,DBN,RBM,Auto encoder etc.can automatically learn features from speech.
- DL approaches can also extract features from spectrograms of speech.All processes used in SER are given in Fig.1. 
  - 
- Fig.1 shows the processes used in SER.It is divided into three categories of SER.In the first category handcrafted features are extracted from the speech signals before applying the ML algorithms.
- In the second category DL approaches either use hand crafted features or automatically learn features from speech signals at different layers of computations.
- In the third category speech signals are converted into spectrograms and DL approaches are applied.
- The main contributions of the research investigation of this study are documented below:

- A comprehensive analysis of the literature review on SER in terms of speech databases, speech features, traditional ML approaches and DL approaches.

  - Identification of the important research questions for the systematic literature review for SER.

  - Summarisation of the findings based on the answers for the research questions from the literature review.

  - Summarisation of the motivation and limitations of the DL approaches for recognizing emotions from speech.

- The rest of the paper is organized as follows. 

- Section 2 briefly describes the research objective and methodology used for this literature. 

- The detailed analysis of the systematic literature review on SER is discussed in terms of three main sections i.e. speech emotional databases, speech features and classifiers in section 3. 

- <u>The findings of the systematic literature review are discussed based on the answers for research questions in section 4.</u> 

  - 缩句:the findings are discussed based on the answers in section4)
  - 再缩句:the findings are discussed.)

- Finally, the conclusion and future directions are discussed in section 5.

Research questions

The objective of this literature review paper is to examine the research papers related to SER in terms of emotional speech databases, speech features and classifiers especially DL approaches. 

The identified research questions are documented as given below:

- RQ 1: What are various sources used for searching the research papers included in this literature review?
- RQ 2: What type of speech databases are used for SER?
- RQ 3: In which languages the emotional speech databases are available?
- RQ 4: Which speech databases are frequently used by the researchers for SER?
- RQ 5: What are frequently used speech features in SER?
- RQ 6: What are the accuracies of frequently used speech databases using DL approaches?
- RQ 7: What are the motivations and limitations of the DL approaches for SER?

### 2.2. Search idea

The search idea used for the literature review is explained in this phase in terms of search strings and resources. 

Search strings aim to capture all relevant research papers in the field of SER. 

Search strings were identified using the population, intervention, comparison and outcome-based criteria. The selected search strings are documented below:

- Emotional speech database or Emotional speech corpus
- [Speech emotion recognition](https://www.sciencedirect.com/topics/computer-science/speech-emotion-recognition) or Emotion recognition from speech
- Speech features for emotion recognition from speech
- Emotion recognition from speech using deep learning approaches

The research papers are selected from different libraries such as Science Direct, Springer, IEEE, Google Scholar and others. The distribution of the selected research papers according to the resources is given in [Table 1](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0005).

- In this study total of 139 papers are included from 160 papers. 
- The literature review presented here is inspired by the SLR presented by Kitchenham and Charters [[7\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0035). All other remaining 138 papers are related to the SER system. To be included in the study all article was examined using the criteria specified in inclusion, exclusion, and quality evaluation.

#### 2.2.1. Inclusion criteria

The inclusion criteria were created to systematically examine selected papers and only those papers have been selected that met the criteria given below:

IC 1: The article is well-researched.

IC 2: The article is scientifically sound.

IC 3: The article is focused on SER and speech emotional database.

#### 2.2.2. Exclusion criteria

We define some exclusion criteria to eliminate unrelated articles from the list. The article that met at least one of the following criteria was disqualified:

EC 1: The article written in a language other than English.

EC 2: The article evaluates the speech processing but not including the emotion recognition.

EC 3: The article already has been listed in another database.

#### 2.2.3. Quality assessment

The quality of all the chosen articles was evaluated. The article was assessed using a checklist designed to assess the research reliability and soundness as given below:

QA 1: Are the research objectives well defined?

QA 2: Has the study been cited by other authors?

QA 3: Is the study conclusion believed and backed up by evidence?

The article was included for the study which met the inclusion criteria, exclusion criteria, and quality assessment.

##  Related literature review

In this section, a detailed analysis of the systematic literature review on SER is **presented**. The literature is divided into three sections namely speech emotional databases, speech features and classifiers. 

Different types of emotional speech databases like actor-based, induced/semi-natural, and natural emotional databases are analysed and reviewed. 

Review of existing speech features such as local and global features are presented briefly. 

Finally, SER classifiers are critically reviewed such as traditional ML approaches and DL approaches. DL approaches used for SER are reviewed in detail from years 2000 to 2021.

### 3.1. Emotional speech databases

A good quality emotional database is a prerequisite for SER [[8\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0040). To evaluate the correctness of an emotional database there are many factors to be considered while designing an emotional speech database such as the scope of the database, annotation of the emotions, size of the database, type of speakers in terms of age and gender.

 The emotional speech database can be categorized into three types namely actor-based databases, induced or elicited database and natural emotional speech database.

#### 3.1.1. Actor based

Actor-based emotional speech databases are also called simulated emotional speech databases. These types of databases are created by trained professional actors such as radio artists, theatre artists, or from a person who can speak in different emotions. A recording is done from the speaker who is speaking the same text in different emotions. Recording may have been done in the different sessions like in the morning, afternoon, evening, and at night to consider the variation of the physical speech and expressiveness of the human being. This is one of the reliable ways of recording the emotional speech database in the complete range of emotions. More than 60% of the emotional speech database is a simulated database. Generally, the simulated emotional database is more expressive than the real one [[9\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0045).

#### 3.1.2. Induced/elicited

The induced emotional speech database is also called a semi-natural emotional database because it is nearer to the natural database. These types of databases are recorded in the artificial emotional situation without the knowledge of the actor(行为者/演员,这里应该译为行为者,临时参与或配合表演的人/演员). After creating the artificial emotional situation actor was involved in emotional conversion with the speaker. This type of database is more natural than the simulated database. But the recording may not be expressive if the speaker knows that, then this is an artificial emotional situation. Sometimes these types of databases may be recorded in verbal interaction with the computer which may be controlled by any person without the knowledge of the subject [[10\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0050).

#### 3.1.3. Natural

Natural emotional databases are the real data and sometimes it is difficult to recognize the emotions. This type of database may be recorded from the conversation between customer care and customer, television broadcasting, a dialog between doctor and patient, courtroom, cockpit recording in the abnormal situation, and many more. In these situations, it is difficult to find a complete range of emotions. There are some copyright and security problems also [[5\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0025), [[10\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0050). The details of all types of emotional databases are summarised in [Table 2](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0010).

In the literature review, the critical analysis of the emotional database is presented based on language, type of database, number of emotions, type of data (Video/Audio), number of the speakers, number of samples, and number of utterances 言辞<u>and brief description</u>. A summary of the literature review of the emotional speech databases is given in [Table 3](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0015).

在文献综述中，基于语言、数据库类型、情感数量、数据类型(视频/音频)、说话人数量、样本数量和话语数量对情感数据库进行了批判性分析，并进行了简要描述。表3给出了情感语音数据库的文献综述。



In the literature, databases are collected in the following three categories i) Actor/simulated emotional speech databases, ii) Elicited/Induced/semi-natural emotional speech databases, and iii) Natural emotional speech databases. The properties of these databases are briefly discussed in Table 2. There are many differences among the databases such as the number of emotions, language, method, and purpose of the database. 

Among all databases, 66% of the databases are actor-based emotional databases. The number of emotional speech databases collected are highest in English language databases followed by Chinese and German language databases. Very few databases are collected in Indian languages such as Hindi and Telugu. Majority of the databases contain emotions like happy, anger, sad and neutral.
在文献中，数据库分为以下三类：i )演员/模拟情感语音数据库，ii )诱发/诱导/半自然情感语音数据库，iii )自然情感语音数据库。表2简要讨论了这些数据库的性质。各数据库在情感数量、语言、方法、数据库的目的等方面存在诸多差异。

在所有数据库中，66 %的数据库是基于演员的情感数据库。收集到的情感语音数据库数量最多的是英语语言数据库，其次是汉语和德语语言数据库。以印地语和泰卢固语等印度语言收集的数据库很少。大多数数据库包含喜悦、愤怒、悲伤和中性等情绪。
In contrast most of the databases rarely contain uncommon emotions such as approval, attention, antipathy, prohibition, etc. Some databases have collected emotional speech signals from TV shows, movies and then annotated the emotions by experts. The database commonly containing 7–8 emotions. Databases have sufficient variation such as gender of the speaker, generation of speech, session of recordings many more.
相比之下，大多数数据库很少包含诸如赞同、注意、反感、禁止等不常见的情绪。一些数据库从电视节目、电影中收集情感语音信号，然后由专家对情感进行标注。该数据库一般包含7 - 8种情绪。数据库有足够的变化，如说话人的性别，语音的生成，记录的会话等等。

### 3 . 2 .语音特征

3.2. Speech features
The most important part of the SER is speech features. A lot of features have been examined and utilized by the researchers for SER. To date, there is no common procedure for the extraction of speech features and particular classifiers. In [33], discriminant判别的 information was introduced to protect local information to achieve the better results. The speech features extracted for SER depend upon our demand. Local features or global features or both features can be extracted from the speech signal. A novel feature set HHTC has been proposed for video emotion recognition by [34]. In [35] a new Feature selection method has been proposed based on fisher and correlation analysis and the results have been improved.



The local features are represented by the temporal dynamics. It is also called short-term features of segmental features. On the other hand, global features are represented by exhaustive statistics like minimum and maximum value, mean, and standard deviation. It is also known as long-term features or supra-segmental features. For SER, these local and global features are investigated in the four categories [spectral features](https://www.sciencedirect.com/topics/computer-science/spectral-feature), prosodic feature, Teager Energy operator, and vice quality features [[36\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0180). The categories of the local and global features are shown below in [Fig. 2](https://www.sciencedirect.com/science/article/pii/S0925231222003964#f0010).

#### 3.2.1. Spectral features

When a speech signal is produced by any of the individual speakers, it filters and controls the vocal tract. The vocal tract features are utilized for obtaining the spectral features, it is worthily represented into the frequency domain [[37\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0185). Spectral features can be obtained by [Fourier transform](https://www.sciencedirect.com/topics/neuroscience/fourier-transform). Fourier transform is transforming the frequency domain into the time domain. The state-of-the-art spectral feature is the Mel frequency [cepstral coefficient](https://www.sciencedirect.com/topics/computer-science/cepstral-coefficient) (MFCC). Frequency is converted to the Mel frequency according to the given equation [(1)](https://www.sciencedirect.com/science/article/pii/S0925231222003964#e0005).



The speech signals are divided into different frames before converting into the frequency domain. MFCC features are extracted from speech signals by inverse Fourier transform [[38\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0190). The second important spectral feature is linear prediction cepstral coefficients (LPCC). It contains important emotional information represented by the vocal tract [[39\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0195). Similar to the MFCC, Gammatone frequency cepstral coefficient (GFCC) spectral features were computed [[40\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0200). A combination of LPCCs, MFCCs, PLP, LFPCs feature vectors was proposed for SER in mandarin [[41\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0205), [[42\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0210). LFPCs performed slightly better than the LPCC conventional features [[43\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0215).

语音信号在转换到频域之前被分成不同的帧。通过傅里叶逆变换从语音信号中提取MFCC特征[ 38 ]。第二个重要的光谱特征是线性预测倒谱系数( LPCC )。它包含以声道为代表的重要情感信息[ 39 ]。与MFCC类似,Gammatone频率倒谱系数( GFCC )谱特征[ 40 ]可以被类似地计算。针对普通话的语音情感识别 [ 41 ]，[ 42 ]，提出了一种LPCCs，MFCCs，PLP，LFPCs的组合特征向量。LFPCs性能略优于LPCC常规特征[ 43 ]。

#### Prosodic features

Prosodic features like pitch, duration, energy are considered as good correlates of emotion [[44\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0220), [[45\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0225), [[46\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0230). Features like maximum, minimum, similar features of pitch, variance, range, mean and standard deviation are utilized as a good prosodic information source for the identification of the emotions extracted at segment level [[47\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0235). 

Koolagudi and Rao [[48\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0240) categorized prosodic features mainly in three categories i) pitch, ii) intensity and iii) intonation. Prosodic features depend on the air pressure of the vocal fold. The statistical value of the prosodic features carries emotional-specific information, which is useful for the identification of the emotion [[49\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0245). The statistical values of pitch include meaning, minimum, maximum, range, standard deviation, skewness, median, slope, [kurtosis](https://www.sciencedirect.com/topics/neuroscience/kurtosis), and many more.

#### 韵律特征

音高、时长、能量等韵律特征被认为和情绪具有良好的相关[ 44 ] [ 45 ] [ 46 ]。最大值、最小值、音高相似特征、方差、极差、平均值和标准差等作为良好的韵律信息源，用于识别在片段级别提取的情绪[ 47 ]。Koolagudi和Rao [ 48 ]将韵律特征主要分为三类：i )音高，ii )音强和iii )语调。韵律特征取决于声带的气压。韵律特征的统计值携带了情感特有的信息，对于情感的识别是有用的[ 49 ]。音高的统计值包括意义、最小值、最大值、极差、标准差、偏度、中位数、斜率、峰度等。

Prosodic features like energy, pitch, and duration are important features for the recognition of emotions [[50\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0250). Several features such as intonation and rhythm which humans can recognize are known as prosodic features, these features can be recognized in words, sentences, syllables, and expressions [[51\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0255). Prosodic features extracted from the speech are long-term features. Fundamental frequency, duration, energy features on which prosodic features are broadly utilized [[36\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0180).

能量、音高、时长等韵律特征是情绪识别的重要特征[ 50 ]。人类能够识别的语调和节奏等特征被称为韵律特征，这些特征可以在单词、句子、音节和表达中被识别[ 51 ]。从语音中提取的韵律特征是长时特征。基频、时长、能量特征等韵律特征被广泛使用的[ 36 ]。

#### 3.2.3. Teager energy operator (TEO) features

Teager and Kaiser [[45\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0225), [[46\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0230) introduce the TEO feature. TEO has enclosed on the [authentication](https://www.sciencedirect.com/topics/computer-science/authentication) that the energy detection is responsible by the hearing process. It has been distinguished that in a stressful situation, due to the distribution of harmonics there is a change in critical band and frequency. Without stressful situations modifying the airflow during the speech generation. TEO is created from the speech signal through the non-linear equation given in Eq. [(2)](https://www.sciencedirect.com/science/article/pii/S0925231222003964#e0010).

### 3.2.3 Teager能量算子( TEO )特征

-  Teager和Kaiser [ 45 ] [ 46 ]引入了TEO特征。TEO在认证中附上了能量检测由听觉过程负责的认证。人们已经区分，在有压力的情况下，由于谐波的分布会产生临界频带和频率的变化。无压力情境下，在言语产生过程中对气流进行改变。TEO由语音信号通过式( 1 )给出的非线性方程组产生。( 2 ) .

- $$
  \varphi[f(n)]=f^2(n)-f(n-1)f(n+1)
  $$

  

#### 3.2.4. Voice quality features

The voice quality features have been defined as the individual voice characteristic. Voice quality features are the centre of many speech processing life speaker identification, emotion recognition and many more. Apart from spectral features, the quality of the glottal source defined by the vice quality features. Several features like format frequency, bandwidth, glottal parameter, harmonic to noise ratio, jitter, and shimmer are known as voice quality features. The voice quality speech and emotional content have contrasting interrelationships [[52\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0260).

#### 3 . 2 . 4 .音质特征

音质特征被定义为个体的语音特征。音质特征是许多语音处理、说话人识别、情感识别等的中心。除谱特征外，声门源的质量由副质量特征定义。格式频率、带宽、声门参数、谐波噪声比、抖动和微光等特征被称为音质特征。音质与情感内容之间存在着截然不同的相互关系[ 52 ]。

### 3.3. SER classifiers

Classifiers are equally important as speech features for SER. These can be categorized into two types: (i) traditional [machine learning](https://www.sciencedirect.com/topics/computer-science/machine-learning) classifiers, and (ii) deep learning classifiers. Hybrid approaches, a combination of traditional and deep learning classifiers also has been used by some researchers. A large number of classifiers have been examined for SER, but to date, it is difficult to determine which classifiers perform best. 

In this section, the literature of the classifiers is discussed in two ways: traditional ML approaches and DL approaches. In the literature, the critical analysis of the traditional/deep learning classifiers is presented based on type of database used, recognised emotions, features used, type of classifiers, and average accuracy.

3 . 3 . SER分类器

对于SER来说，分类器与语音特征同等重要。可分为两类：( i )传统机器学习分类器；( ii )深度学习分类器。混合方法，即传统分类器和深度学习分类器的结合也被一些研究者使用。大量的分类器已经被用于SER的研究，但是到目前为止，很难确定哪个分类器表现最好。

在本节中，对分类器的文献从两个方面进行了讨论：传统的机器学习方法和深度学习方法。在文献中，基于使用的数据库类型、识别的情感、使用的特征、分类器类型和平均准确率对传统/深度学习分类器进行了批判性分析。

#### 3.3.1. Traditional machine learning approaches

Traditional ML approaches for SER are applied after the extraction of the desired features from the speech signals. Many classifiers have been evaluated by the researchers for SER to achieve better accuracy. Commonly used traditional classifiers are SVM, GMM, HMM, [ANN](https://www.sciencedirect.com/topics/computer-science/artificial-neural-networks), and k-NN [[5\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0025). In [[35\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0175) a novel feature selection method was proposed based on fisher and correlation analysis using ELM [Extreme Learning Machine](https://www.sciencedirect.com/topics/computer-science/extreme-learning-machine), SVM, BPNN, and KNN classifiers and evaluated on the CASIA datasets. The average accuracy of 89.9%, 87.20%, 82.30%, 80.70% respectively was achieved. SVM and HMM have been used for SER and evaluated on the SUSAS database [[53\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0265). The author used a KNN classifier for emotion recognition and got 66.4 % average accuracy with four emotions [[54\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0270).

3.3 . 1。传统的机器学习方法
传统的用于SER的ML方法是在从语音信号中提取所需特征后应用的。许多分类器已经被研究人员对SER进行了评估，以达到更好的精度。常用的传统分类器有支持向量机、高斯混合模型、隐马尔可夫模型、人工神经网络、k紧邻等[ 5 ]。在文献[ 35 ]中，基于fisher和相关性分析提出了一种新的特征选择方法，使用极限学习机、支持向量机、反向传播神经网络和K近邻分类器，并在CASIA数据集上进行评估。平均准确率分别为89.9 %、87.20 %、82.30 %、80.70 %。支持向量机和隐马尔可夫模型已经用于语音情感识别并在SUSAS数据库上进行评估[ 53 ]。作者使用K近邻分类器进行情感识别，4种情感的平均准确率为66.4 % [ 54 ]。

LPA and MFCC have been used to extract the features in [[56\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0280), [[57\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0285) and the GFNN and SVM classifiers have been used for the SER system and evaluated on the EMODB database and got an accuracy of 98% and 82% respectively. A hybrid approach has been used by the author and evaluated on the three databases [[58\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0290). Anger, Neutral, Sad, and Happy four emotions have been recognized by using SVM classifiers and average accuracy of 73% is achieved [[59\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0295). [Neural Network](https://www.sciencedirect.com/topics/neuroscience/neural-networks) and SVM have been used in [[60\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0300) and evaluated on eNTERFACE, and FAU databases. The author proposed SER using Fourier parameters and evaluated on three databases and got the best accuracy of 71% [[61\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0305).

LPA和梅尔倒频谱系数已被用于[ 56 ]，[ 57 ]中的特征提取，高斯模糊网络和支持向量机分类器被用于语音情感识别系统，并在EMODB数据库上进行评估，准确率分别为98 %和82 %。作者使用了一种混合方法，并在三个数据库上进行了评估[ 58 ]。利用SVM分类器对愤怒、中性、悲伤和高兴4种情绪进行识别，平均准确率达到73 % [ 59 ]。文献[ 60 ]使用了神经网络和支持向量机，并在eNTERFACE和FAU数据库上进行了评估。作者提出利用傅里叶参数进行语音情感识别，并在3个数据库上进行了评估，得到了71 %的最佳准确率[ 61 ]。

In [[62\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0310), [[63\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0315) MFCC features extraction technique has been used for SER and evaluated on EMODB using SVM and ANFIS MLP classifiers respectively. The literature of the traditional approaches is analysed such as databases used, the number of emotions recognized, what kind of feature set was used, which type of classifiers used, and what average accuracy was achieved. Literature of the traditional approaches for SER is summarized below in [Table 4](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0020).

在文献[ 62 ] [ 63 ]中，梅尔倒频谱系数特征提取技术被用于语音情感识别，并分别使用支持向量机和自适应神经模糊推理系统和多层感知机分类器在EMODB上进行评估。本文在例如使用的数据库，识别的情感数量，使用什么样的特征集，使用哪种类型的分类器，以及达到什么平均精度方面对使用传统方法的文献进行分析。传统的SER方法的文献总结在表4中。

From the summarised literature given in [Table 4](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0020), it can be concluded that 54.45% of the papers have used SVM as a classifier and the best accuracy of 98% is achieved using MFCC features on the EMODB database. Majority of the papers are using either MFCC or MFCC with the combination of other features as speech features for emotion recognition. Majority of the SER model were evaluated on the EMODB followed by eNTERFACE.

从表4给出的文献总结可以得出，54.45 %的论文使用SVM作为分类器，在EMODB数据库上使用梅尔倒频谱系数特征取得了98 %的最佳准确率。大多数论文都是采用梅尔倒频谱系数或梅尔倒频谱系数与其他特征的组合作为语音特征进行情感识别。在EMODB和eNTERFACE数据库上评估了大多数语音情感识别模型。

#### 3.3.2. Deep learning approaches

Deep learning concepts are described as a subset of ML, which learns from multiple levels. DL came strongly around 2015 for SER. In the recent, DL approaches has been giving encouraging result for SER. DL approaches are considered as the best suitable classifiers for emotion recognition as compared to traditional ML approaches because of flexible function, a wide range of features automatically learn, scalability, recognition rate. On the other hand, traditional ML approaches required less data for training. A variety of DL approaches have been used by researchers for emotion recognition. Brief descriptions of the DL approaches used for SER are described in terms of their key features, limitations in [Table 5](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0025).

3 . 2 .2深度学习方法
深度学习概念被描述为机器学习的子集，它从多个层面进行学习。深度学习在2015年前后对语音情感识别影响较大。近年来，深度学习方法为语音情感识别提供了令人鼓舞的结果。与传统的机器学习方法相比，深度学习方法具有功能灵活、特征自动学习范围广、可扩展性强、识别率高等优点，被认为是最适合情感识别的分类器。另一方面，传统的ML方法需要较少的数据进行训练。研究者们使用了多种深度学习方法进行情感识别。表5简要介绍了用于语音情感识别的深度学习方法的主要特点和局限性。

The current researchers are using DL approaches for emotion recognition and improving accuracy. Major categories of SER model using DL approaches are using approaches which automatically learn relevant features, using hand-crafted features, and using spectrograms. The author proposed CNN based novel spatiotemporal and frequential cascaded network for emotion recognition and evaluated the IEMOCAP, EMODB, eNTERFACE, and SAVEE and got average accuracy of 71.98%, 82.10, 75.60%, 54.75% respectively [[69\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0345). DECN SER model proposed to correct errors made by emotion recognition approaches and improved the result [[70\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0350). 

目前的研究者正在使用深度学习方法进行情绪识别并提高准确率。使用深度学习方法的语音情感识别模型的主要类别是使用自动学习相关特征的方法、使用手工特征和使用语谱图。作者提出了基于卷积神经网络的新的时空和频繁级联网络用于情感识别，并评估了IEMOCAP，EMODB，eNTERFACE和SAVEE数据库，平均准确率分别为71.98 %，82.10，75.60 %，54.75 % [ 69 ]。对话情感修正网络语音情感识别(DECN SER)模型是为了纠正情感识别方法的错误而提出的，并改进了结果[ 70 ]。

The authors proposed an SER system using an LSTM classifier and evaluated it on the RAVDESS database and got improvement in recognition [[71\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0355), [[76\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0380). One dimensional CNN has been proposed to recognize emotions [[72\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0360), [[73\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0365). Speech signals were converted to spectrogram in [[74\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0370), [[75\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0375), [[78\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0390), [[79\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0395), [[80\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0400), [[81\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0405), [[86\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0430) and the emotions were recognized using CNN. MFCC and prosodic features were extracted and [deep neural network](https://www.sciencedirect.com/topics/computer-science/deep-neural-network) was applied, proposed model was evaluated on multiple databases and best accuracy for SAVEE database achieved is 81.70% [[77\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0385). CNN with other classifiers have been used in [[84\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0420), [[85\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0425), [[86\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0430) and improve the results in terms of average accuracy. The Authors in [[88\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0440) chose GoogLeNet for emotion recognition and evaluated on multiple databases [[88\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0440). The authors in [[89\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0445), [[90\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0450), [[91\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0455), [[92\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0460), [[94\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0470), [[103\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0515), [[106\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0530) developed SER approaches using CNN with LSTM classifiers and evaluated on different databases. 

作者提出了一个使用长短时记忆分类器的语音情感识别系统，并在RAVDESS数据库上进行评估，在识别方面得到了改进[ 71 ]，[ 76 ]。一维卷积神经网络被提出来识别情感[ 72 ]，[ 73 ]。在文献[ 74 ]，[ 75 ]，[ 78 ]，[ 79 ]，[ 80 ]，[ 81 ]，[ 86 ]中，语音信号被转换为语谱图，并使用卷积神经网络进行情感识别。提取梅尔倒频谱系数和韵律特征并应用深度神经网络，在多个数据库上对提出的模型进行评估，对SAVEE数据库的识别取得的最佳准确率为81.70 % [ 77 ]。卷积神经网络与其他分类器已经在文献[ 84 ]，[ 85 ]，[ 86 ]中使用并在平均准确率方面提高了结果。文献[ 88 ]的作者选择GoogleNet进行情感识别，并在多个数据库上进行评估[ 88 ]。文献[ 89 ]，[ 90 ]，[ 91 ]，[ 92 ]，[ 94 ]，[ 103 ]，[ 106 ]的作者使用卷积神经网络和长短时记忆分类器开发了SER方法，并在不同的数据库上进行了评估。

The authors in [[95\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0475), [[103\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0515) used 3D CNN-based SER models to identify the speech emotions. The authors in [[97\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0485) used hybrid approach GMM + DNN to recognise the emotions. RBM-based DBN classifiers have been proposed in [[104\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0520) with eGEMAPS features and got better accuracy. RNN classifier with LSTM and CNN classifiers used for emotion recognition and improve the results [[107\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0535), [[109\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0545). In [[110\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0550), [[114\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0570), [[116\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0580), [[118\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0590) CNN classifier used by authors with different architectures for SER system and evaluated on multiple databases. In [[111\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0555) authors chose Bi-LSTM classifiers and got better average accuracy of 93.97%. The authors in [[112\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0560), [[117\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0585) chose auto-encoder classifier for emotion recognition. Hand-crafted features are considered to recognize the emotion using DBN classifier and improve the recognition accuracy [[113\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0565). 

文献[ 95 ]，[ 103 ]中作者使用基于3D 卷积神经网络的语音情感识别模型来识别语音情感。文献[ 97 ]中作者使用混合方法高斯混合模型(GMM) + 深度神经网络(DBN)来识别情感。文献[ 104 ]利用eGEMAPS特征提出了基于受限波尔茨曼机(RBM)的动态贝叶斯网络(DBN)分类器，取得了较好的准确率。递归神经网络(RNN)分类器结合长短时记忆(LSTM)和卷积神经网络(CNN)分类器用于情感识别并改善结果[ 107 ]，[ 109 ]。在文献[ 110 ]、[ 114 ]、[ 116 ]、[ 118 ]中，作者将不同架构的卷积神经网络分类器用于SER系统，并在多个数据库上进行了评估。在文献[ 111 ]中，作者选择了Bi - LSTM分类器，获得了93.97 %的平均准确率。作者在[ 112 ]，[ 117 ]中选择自编码器分类器进行情感识别。手工特征被认为可以使用DBN分类器识别情感，并提高识别精度[ 113 ]。

 Features extracted using openSMILE in [[119\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0595) and RNN with LSTM classifiers were used to improve the recognition rate. Automatically features have been learned by the CNN layers to recognize emotions [[121\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0605). MFCC features have been extracted in [[122\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0610) and chose RNN classifiers to identify the emotions, the proposed model has been evaluated on EMODB [[122\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0610). The authors in [[123\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0615), [[125\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0625) proposed SER model using DBN classifiers and evaluated on the EMODB and IEMOCAP databases. RNN model has been used by the authors and improves the recognition rate [[127\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0635). In [[128\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0640), the authors proposed SER model using DNN classifiers and features extracted from the spectrograms to improve the accuracy. CNN classifier has been used for emotion recognition in [[129\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0645), [[130\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0650) and evaluated on IEMOCAP and CAM3D databases. Speech signals are converted into spectrograms and then apply the CNN model to recognize the emotion [[132\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0660), [[133\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0665). The authors proposed the SER model using DNN classifiers in [[131\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0655), [[134\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0670).

文献[ 119 ]中使用openSMILE提取的特征和使用LSTM分类器的RNN来提高识别率。自动特征已经被CNN层学习来识别情感[ 121 ]。文献[ 122 ]提取MFCC特征并选择RNN分类器进行情感识别，提出的模型在EMODB上进行了评估[ 122 ]。文献[ 123 ]，[ 125 ]的作者提出了使用DBN分类器的SER模型，并在EMODB和IEMOCAP数据库上进行了评估。RNN模型已经被作者使用并提高了识别率[ 127 ]。在文献[ 128 ]中，作者提出了使用DNN分类器和从语谱图中提取特征的SER模型来提高准确率。CNN分类器已经在[ 129 ]，[ 130 ]中用于情感识别，并在IEMOCAP和CAM3D数据库上进行了评估。将语音信号转换为语谱图，然后应用CNN模型进行情感识别[ 132 ]、[ 133 ]。作者在[ 131 ]，[ 134 ]中提出了使用DNN分类器的SER模型。

In [[135\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0675), [[137\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0685) DBN classifiers are used for emotion recognition with hand-crafted features. MFCC features extracted in [[136\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0680), [[138\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0690) for SER and LSTM and DNN classifiers are used to achieve better accuracy. ANN classifier has been used for emotion recognition in [[139\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0695) and evaluated on EMODB and Mandarin databases. The detailed literature of the DL approaches is analysed such as databases used, the number of emotions recognized, kind of feature set used, type of DL classifiers used and the average accuracy achieved. The critical analysis of the literature review of DL approaches for emotion recognition is discussed in [Table 6](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0030).

在文献[ 135 ] [ 137 ]中，DBN分类器被用于手工特征的情感识别。在[ 136 ]，[ 138 ]中提取的MFCC特征用于SER和LSTM和DNN分类器以达到更好的精度。ANN分类器已在文献[ 139 ]中用于情感识别，并在EMODB和中文数据库上进行了评估。本文对深度学习方法的详细文献进行了分析，如使用的数据库、识别的情感数量、使用的特征集种类、使用的深度学习分类器类型和达到的平均准确率。对情感识别深度学习方法的文献综述的批判性分析在表6中讨论。

It is clear from [Table 6](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0030) that very few researchers have used DL approaches for SER till 2013, and the majority have used DBN classifier [[135\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0675), [[137\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0685). In 2014 majority of researchers have used CNN using spectrograms [[132\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0660), [[133\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0665). Best recognition accuracy of 81% was achieved using RNN classifier evaluated on RECOLA database [[127\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0635), in 2015. In the year 2016 RNN, DBN, CNN, DNN classifiers were used by the researchers. In 2017, the best accuracy 94.60% achieved using the DBN classifier evaluated on the CASEC database [[113\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0565). Using DCNN better accuracy of 92.71% was achieved on the EMOBD datasets [[100\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0500), in the year 2018. In 2019, very diverse and hybrid approaches have been used among all 2d CNN + LSTM approaches had achieved the best accuracy that is 95.89% on the EMODB dataset and 89.16% on IEMOCAP datasets [[92\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0460). In the year 2020 best accuracy achieved using CNN on EMODB datasets is 95% [[86\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0430). In the year 2021 researchers going on and majority of the research is using CNN and hybrid approaches.

从表6中可以看出，到2013年为止，很少有研究人员使用深度学习方法进行SER，大多数使用DBN分类器[ 135 ]，[ 137 ]。2014年，大多数研究人员已经使用CNN和语谱图[ 132 ]，[ 133 ]。在2015年RECOLA数据库[ 127 ]上使用RNN分类器取得了81 %的最佳识别准确率。2016年RNN、DBN、CNN、DNN分类器被研究者使用。2017年，在CASEC数据库上评估的DBN分类器取得了94.60 %的最佳准确率[ 113 ]。2018年,深度卷积神经网络(DCNN)被运用在EMOBD数据集上[ 100 ]，取得了92.71 %的较好准确率。2019年，在所有2d CNN + LSTM方法中，使用非常多样化和混合的方法取得了最好的准确率，在EMODB数据集上为95.89 %，在IEMOCAP数据集上为89.16 % [ 92 ]。在2020年，CNN在EMODB数据集上取得的最佳准确率为95 % [ 86 ]。

In the year 2021 researchers going on and majority of the research is using CNN and hybrid approaches. From [Table 5](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0025), it is also found that majority of the researchers had evaluated their proposed SER model on the IEMOCAP (48%), followed by the EMODB (38%), RAVDESS (17%), and SAVEE (10%) database. It is also clear that majority of the paper has been used CNN, followed by LSTM, and RNN DL approaches. Researchers have used DL approaches for SER in three-way i) first way in which researchers have extracted speech features and then apply the DL approach, ii) in second-way researchers first convert speech signal into spectrogram then apply the DL approach, and iii) third way in which DL approaches automatically learn the relevant speech features to identify the emotions.

在2021年，研究人员正在进行研究，其中大部分研究是使用CNN和混合方法。从表5中还可以发现，大多数研究者在IEMOCAP ( 48 % )上评估了他们提出的SER模型，其次是EMODB ( 38 % )、RAVDESS ( 17 % )和SAVEE ( 10 % )数据库。同样明显的是，大多数论文使用了CNN，其次是LSTM和RNN 深度学习方法。研究人员通过三种方式使用深度学习方法进行情感识别：i )第一种方式，研究人员提取语音特征然后应用深度学习方法；ii )第二种方式，研究人员首先将语音信号转换为语谱图然后应用深度学习方法；iii )第三种方式，研究人员用深度学习方法自动学习的相关的语音特征来识别情感。

Author [[92\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0460) have achieved the best accuracy 89.16% for IEMOCAP and 95.89% for the EMODB database using the CNN + LSTM approach which extracted features from spectrograms. For the RAVDESS database best accuracy achieved 84.30% using the LSTM approach which automatically learns the speech features [[76\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0380). And for the SAVEE database 81.05% best accuracy was reported using the CNN approach which extracted features from spectrograms [[95\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0475). Very few researchers have been used auto-encoder, DBN, and DBM DL approaches. The distribution of all selected papers in terms of year and sources used in the literature are shown in [Fig. 3](https://www.sciencedirect.com/science/article/pii/S0925231222003964#f0015).

文献[ 92 ]中作者使用从语谱图中提取特征的CNN + LSTM方法，在IEMOCAP和EMODB数据库取得了最好的准确率89.16 %和95.89 %。对于RAVDESS数据库，使用自动学习语音特征的LSTM方法取得了84.30 %的最佳准确率[ 76 ]。对于SAVEE数据库，使用从语谱图中提取特征的CNN方法报告了81.05 %的最佳准确率[ 95 ]。很少有研究者使用自编码器、DBN和深度玻尔兹曼机(DBM) 深度学习方法。所有入选文献在年代和文献来源方面的分布情况如图3所示。

Results in [Fig. 3](https://www.sciencedirect.com/science/article/pii/S0925231222003964#f0015) indicates that use of DL approaches for emotion recognition has gradually increased after 2013. Nowadays, majority of the SER models proposed by the researchers are using DL approaches and have reported better results in terms of average accuracy and computation cost.

图3的结果表明，在2013年之后，使用深度学方法进行情绪识别的研究逐渐增多。目前，研究者们提出的SER模型大多采用深度学习方法，并在平均精度和计算成本方面取得了较好的结果。

## 4. Findings of the review

The objective of this section is to discuss the findings about specific research issues and the recent studies for SER. These are discussed here in terms of defined research questions, which are mentioned in section 2. In this work, a total of 139 papers are selected from different resources according to the details given in [Table 1](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0005). Among all papers, 25 papers are related to speech emotional databases, 20 papers are related to speech features, 93 papers are related to the classifiers, and 1 paper related to the background of this SLR paper. The objective of this work is defined in terms of research questions and presented in section 3. All defined research questions and finding of the RQ are discussed below.

## 4 .调查结果

本部分的目的是讨论SER的具体研究问题和近期研究结果。这些都是在第二节提到的研究问题中讨论的。本文根据表1给出的详细信息，从不同的资源中共选取了139篇论文。在所有论文中，与语音情感数据库相关的论文有25篇，与语音特征相关的论文有20篇，与分类器相关的论文有93篇，与本SLR论文背景相关的论文有1篇。这项工作的目标是根据研究问题来确定的，并在第3节中提出。下面讨论定义的所有研究问题和调查结果。

RQ1: What are various sources used for searching the research papers included in this literature review.

In this study we have included 139 research papers, in which more than 65% of papers are related to SER classifiers, 18% papers are for emotional speech databases, more than 14% papers are collected for speech features, and the rest of the papers are related to the background of the SER system. Papers are collected from different resources like Elsevier, Springer, IEEE, Research Gate, and other resources (refer to [Table 1](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0005)). The distribution of the number of papers and the percentage according to the resources is shown in [Fig. 4](https://www.sciencedirect.com/science/article/pii/S0925231222003964#f0020).

RQ1：用于检索本文献综述所包含的研究论文的各种来源。

本研究共纳入139篇研究论文，其中超过65 %的论文与SER分类器相关，18 %的论文针对情感语音数据库，超过14 %的论文针对语音特征，其余的论文与SER系统的背景相关。论文分别从爱思维尔、施普林格、IEEE、Research Gate和其他资源(见表1)收集。论文数量及所占百分比按资源分布见图4。

Fig. 4, indicates that majority of the papers are collected from other resources, followed by the IEEE, Springer, Elsevier, and Google Scholar.

RQ2: What type of speech databases are used for SER.

From the literature of speech databases, the databases are collected under three categories: actor based, semi-natural, and natural emotional based. Among all databases, more than 66% of databases are actor-based emotional databases, 19.05% are semi-natural emotional databases and 14.29% are natural databases. The distribution of the papers and the percentage of all three types of databases are given in [Table 7](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0035).

从图4可以看出，大部分论文都是从其他资源中收集的，其次是IEEE、施普林格、爱思维尔和Google Scholar。

 RQ2：什么类型的语音数据库用于SER。

从语音数据库的文献来看，该数据库分为三类：基于演员、基于半自然、基于自然情感。在所有数据库中，超过66 %的数据库为基于行为体的情感数据库，19.05 %为半自然情感数据库，14.29 %为自然数据库。表7给出了3类数据库的论文分布及所占比例。

RQ3: In which languages the emotional speech databases are available.

The objective of this research question is to analyse the databases available in different languages. The emotional speech databases collected in [Table 2](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0010), are English [language databases](https://www.sciencedirect.com/topics/computer-science/database-languages) followed by Chinese and German language databases. Very few databases are available in Japanese language, Korean language, Indian language, and multilingual. From Indian language databases are available only in Hindi and Telugu language. The distribution of the databases according to the languages is given in [Table 8](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0040).

RQ3：情感语音数据库可用的语言。

本研究问题的目的是分析不同语言的数据库。表2中收集的情感语音数据库，是英语语言数据库，其次是汉语和德语语言数据库。日语、韩语、印度语和多语种的数据库很少。来自印度的语言数据库只有印地语和泰卢固语。各数据库的语种分布见表8。

RQ 4: Which speech databases are frequently used by the researchers for SER.

There are many databases that have been used by the researchers. In this study, we have considered 93 papers in which 12 papers are using traditional ML approaches, and 69 papers are using DL approaches. Majority of the SER, models were evaluated on the IEMOCAP database followed by EMODB, and RAVDESS (more than 15% of the SER models presented in [Table 4](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0020) and [Table 6](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0030)). Details about frequently used databases are given in [Table 9](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0045).

RQ 4：研究者常用哪些语音数据库进行SER。

已经被研究者使用的数据库有很多。在本研究中，我们考虑了93篇文献，其中12篇文献使用传统的机器学习方法，69篇文献使用深度学习方法。在IEMOCAP数据库、EMODB数据库和RAVDESS (表4和表6中的SER模型超过15 %)数据库上评估了大部分语音情感识别模型。表9给出了常用数据库的详细信息。

RQ 5: What are frequently used speech features in SER.

From the literature, it is found that there are a lot of features that have been utilized and examined by the researchers. The speech features extracted from speech for SER are categorized in local features or global features or both features. These are investigated in four types namely [spectral features](https://www.sciencedirect.com/topics/computer-science/spectral-feature), prosodic feature, Teager Energy operator and vice quality features. The speech features, their purpose and approaches are given in [Table 10](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0050).

RQ 5：SER中常用的语音特征有哪些。

从文献中发现，有很多特征被研究者利用和检验。从用于SER的语音中提取的语音特征分为局部特征或全局特征或两者都有的特征。分别从频谱特征、韵律特征、Teager能量算子和副质量特征四个方面进行研究。语音特征、目的和方法在表10中给出。

RQ 6: What are the accuracies of frequently used speech databases using DL approaches.

In this study, we have considered 68 SER papers which are using DL approaches. From [Table 6](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0030), it is clear that frequently used databases are IEMOCAP, followed by EMODB, and RAVDESS. DL approaches used by the authors for SER are CNN, RNN, LSTM, Auto-encoder, [RBN](https://www.sciencedirect.com/topics/computer-science/boltzmann-machine), RMB, and a combination of these approaches. Best accuracy achieved on IEMOCAP database is 89.16% and 95.89% on EMODB database by CNN + LSTM model with spectrograms as features [[92\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0460). For the RAVDESS database highest accuracy of 89.16% is achieved using the LSTM model which automatically learned features [[76\]](https://www.sciencedirect.com/science/article/pii/S0925231222003964#b0380). The analysis of the best accuracy achieved on these frequently used databases by different DL approaches and according to the user features are summarised in [Table 11](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0055).

RQ 6：使用DL方法的常用语音数据库的准确率。

在这项研究中，我们考虑了68篇使用DL方法的SER论文。从表6可以看出，使用较多的数据库是IEMOCAP，其次是EMODB和RAVDESS。作者用于SER的DL方法有CNN、RNN、LSTM、Auto -encoder、RBN、RMB以及这些方法的组合。以谱图为特征的CNN + LSTM模型在IEMOCAP数据库上取得的最佳准确率为89.16 %，在EMODB数据库上取得的最佳准确率为95.89 % [ 92 ]。对于RAVDESS数据库，使用自动学习特征的LSTM模型取得了89.16 %的最高准确率[ 76 ]。表11总结了不同DL方法和根据用户特征在这些常用数据库上取得的最佳准确率的分析。

RQ 7: What are the motivations and limitations of the DL approaches for SER.

DL approaches are more effective in terms of time and cost in recognizing emotions from speech. But still, there are many challenges which DL approaches have to overcome. The list of motivations and limitations are given in [Table 12](https://www.sciencedirect.com/science/article/pii/S0925231222003964#t0060).

RQ 7：深度学习方法用于语音情感识别的动机和限制是什么。

 DL方法在从语音中识别情感的时间和成本方面更有效。尽管如此，深度学习方法仍有许多挑战需要克服。表12列出了动机和限制。















