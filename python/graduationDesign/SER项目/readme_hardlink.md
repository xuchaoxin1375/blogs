# Speech Emotion Recognition

## Introduction

- This repository handles building and training Speech Emotion Recognition System.
- The basic idea behind this tool is to build and train/test a suited machine learning ( as well as deep learning ) algorithm that could recognize and detects human emotions from speech.
- This is useful for many industry fields such as making product recommendations, affective computing, etc.
- Check this [tutorial](https://www.thepythoncode.com/article/building-a-speech-emotion-recognizer-using-sklearn) for more information.

## Requirements

- **Python 3.6+**

### Python Packages

- **tensorflow**
- **librosa==0.6.3**
- **numpy**
- **pandas**
- **soundfile==0.9.0**
- **wave**
- **scikit-learn==0.24.2**
- **tqdm==4.28.1**
- **matplotlib==2.2.3**
- **pyaudio==0.2.11**
- **[ffmpeg](https://ffmpeg.org/) (optional)**: used if you want to add more sample audio by converting to 16000Hz sample rate and mono channel which is provided in ``convert_wavs.py``

Install these libraries by the following command:

```
pip3 install -r requirements.txt
```

### Dataset

This repository used 4 datasets (including this repo's custom dataset) which are downloaded and formatted already in `data` folder:

- [**RAVDESS**](https://zenodo.org/record/1188976) : The **R**yson **A**udio-**V**isual **D**atabase of **E**motional **S**peech and **S**ong that contains 24 actors (12 male, 12 female), vocalizing two lexically-matched statements in a neutral North American accent.
- [**TESS**](https://tspace.library.utoronto.ca/handle/1807/24487) : **T**oronto **E**motional **S**peech **S**et that was modeled on the Northwestern University Auditory Test No. 6 (NU-6; Tillman & Carhart, 1966). A set of 200 target words were spoken in the carrier phrase "Say the word _____' by two actresses (aged 26 and 64 years).
- [**EMO-DB**](http://emodb.bilderbar.info/docu/) : As a part of the DFG funded research project SE462/3-1 in 1997 and 1999 we recorded a database of emotional utterances spoken by actors. The recordings took place in the anechoic chamber of the Technical University Berlin, department of Technical Acoustics. Director of the project was Prof. Dr. W. Sendlmeier, Technical University of Berlin, Institute of Speech and Communication, department of communication science. Members of the project were mainly Felix Burkhardt, Miriam Kienast, Astrid Paeschke and Benjamin Weiss.
- **Custom** : Some unbalanced noisy dataset that is located in `data/train-custom` for training and `data/test-custom` for testing in which you can add/remove recording samples easily by converting the raw audio to 16000 sample rate, mono channel (this is provided in `create_wavs.py` script in ``convert_audio(audio_path)`` method which requires [ffmpeg](https://ffmpeg.org/) to be installed and in *PATH*) and adding the emotion to the end of audio file name separated with '_' (e.g "20190616_125714_happy.wav" will be parsed automatically as happy)

#### desc_files(csv 元数据文件)🎈

- desc_files (csv)文件存储的是语料库的语音文件的路径(path),情感类别(emotion)

### Emotions available

There are 9 emotions available: "neutral", "calm", "happy" "sad", "angry", "fear", "disgust", "ps" (pleasant surprise) and "boredom".

## Feature Extraction@特征提取

Feature extraction is the main part of the speech emotion recognition system. It is basically accomplished by changing the speech waveform to a form of parametric representation at a relatively lesser data rate.

特征提取是语音情感识别系统的主要部分。它基本上是通过将语音波形转换为参数形式的表示形式，以相对较低的数据速率完成的。

“数据速率("Data rate")”，它是指在特定时间内传输的数据量。在语音情感识别系统中，数据速率是指每秒钟传输的语音数据量，通常以比特率（bits per second）或千位每秒（kilobits per second）为单位进行度量。需要注意的是，数据速率还可以用于描述其他类型的数据传输，例如网络传输或存储介质的读取速度。在这些情况下，它通常指在特定时间内传输或处理的数据量，通常以比特率或字节率（bytes per second）为单位进行度量。

特征提取的过程通过将语音波形转换为参数形式的表示形式，可以减少语音信号的数据速率。这是因为，原始语音信号通常包含大量冗余信息，而通过提取与情感状态相关的声学特征，可以压缩数据并减少传输所需的带宽和存储空间。

因此，特征提取对于高效处理和分析大量语音数据是至关重要的。


In this repository, we have used the most used features that are available in [librosa](https://github.com/librosa/librosa) library including:

- [MFCC](https://en.wikipedia.org/wiki/Mel-frequency_cepstrum)
- Chromagram
- MEL Spectrogram Frequency (mel)
- Contrast
- Tonnetz (tonal centroid features)
- 本项目采用以下特征

* MFCC：MFCC是一种常用的声学特征，它是通过将语音信号转换为梅尔频率倒谱系数来提取的。MFCC具有对于语音信号中的频率变化较为敏感的特点，对于识别不同情感状态具有很好的区分能力。
* Chromagram：Chromagram是一种基于音高的特征，它通过计算语音信号中不同的音高分布来提取。
* MEL频谱：MEL频谱是一种基于人耳听觉模型的特征，它将语音信号转换为梅尔频率分布，并对每个频率分布进行离散余弦变换以提取特征。MEL频谱对于语音信号中的频率变化较为敏感，但与MFCC相比，它在某些情况下可能具有更好的区分能力。
* 对比度：对比度是一种基于语音信号的强度变化的特征，它可以通过计算不同频率分量之间的能量差异来提取。对比度对于识别语音信号中的强度变化具有很好的区分能力，但在某些情况下可能对于情感状态的识别不够敏感。
* Tonnetz：Tonnetz是一种基于音高的特征，它通过计算不同音高之间的距离和组合关系来提取。在律学与和声学中，调性网络，或托内斯（来自于德语“Tonnetz”，“tone-network”的意思）是一种用于表示调性空间的、概念性的音乐格子图，由莱昂哈德·欧拉于1739年提出。调性网络的各种可视化形式可被用于表示欧洲古典音乐的传统和声关系。Tonnetz在音乐信息检索和音乐情感识别中广泛应用.
* 总的来说，这些特征在语音情感识别中都具有一定的应用价值，但具体选用哪些特征需要根据实际应用情况和数据分析结果进行选择。在特征提取的过程中，需要综合考虑不同特征之间的互补性和差异性，并对特征进行合理的组合和调整，以提高语音情感识别的准确率和鲁棒性。

在语音情感识别中，常用的特征包括以下几种：

1. 频谱特征：频谱特征包括共振峰频率、谐波比、频谱能量等。这些特征反映了声音的频域信息，对于识别不同情感状态具有很好的区分能力。
2. 韵律特征：韵律特征包括基频、语速、节奏等。这些特征反映了声音的时间和节奏信息，对于识别语音情感状态也非常重要。
3. 非线性特征：非线性特征包括声调、颤音、嘶哑等。这些特征反映了声音的质量和表现形式，对于识别不同情感状态也有很好的识别能力。
4. 语音质量特征：语音质量特征包括噪声、失真、清晰度等。这些特征反映了语音信号的质量，可能对情感状态的识别产生影响。
5. 情感词汇特征：情感词汇特征是从语音信号中提取出与情感状态相关的词汇，可以通过情感词典等工具来实现。

这些特征在不同情感状态之间具有不同的区分能力，因此在设计语音情感识别系统时需要综合考虑它们的优缺点，并根据具体情况选择合适的特征组合。例如，一些研究表明，基于频谱特征和韵律特征的特征组合可以取得较好的情感识别效果；而其他研究则发现，非线性特征对于识别某些情感状态具有更好的区分能力。因此，在实际应用中，需要根据具体情况选择适合的特征组合，并通过机器学习算法等手段对语音信号进行分类和识别。

## Grid Search@网格搜索



- [3.2. Tuning the hyper-parameters of an estimator — scikit-learn 1.2.2 documentation](https://scikit-learn.org/stable/modules/grid_search.html)
- 网格搜索是一种机器学习中的超参数调优技术，其目的是找到模型超参数的最优值。
- 超参数是在训练过程中不会被学习的参数，但在训练前需要设置，可以对模型性能产生重要影响。
- Grid Search 可以翻译为“网格搜索”或“网格调参”，是一种常用的机器学习超参数调优方法。
- Grid Search 的目的是通过遍历给定的超参数组合，找到最优的超参数组合，以获得最佳的模型性能。它基于一个预定义的超参数网格（grid），对每个超参数组合进行评估和比较，从而选择最佳的超参数组合。网格搜索涉及 `<u>`定义一个超参数值的矩阵 `</u>`，并且系统地搜索矩阵以寻找在验证数据集上表现最佳的超参数组合。
- 具体来说，Grid Search 将每个超参数的取值范围划分成一组离散的值，然后对所有可能的超参数组合进行遍历，对每个组合训练一个模型，并使用交叉验证等方法评估模型性能。
- 最后，选择具有最佳性能的超参数组合作为最终模型的超参数。
- Grid Search 是一种简单而有效的调参方法，但它需要遍历所有可能的超参数组合，因此计算成本较高。为了减少计算成本，可以使用 `<u>`随机搜索（Random Search）`</u>`等其他调参方法。

Grid search results are already provided in `grid` folder, but if you want to tune various grid search parameters in `parameters.py`, you can run the script `grid_search.py` by:

```
python grid_search.py
```

This may take several hours to complete execution, once it is finished, best estimators are stored and pickled in `grid` folder.

## Example 1: Using 3 Emotions

The way to build and train a model for classifying 3 emotions is as shown below:

```python
from emotion_recognition import EmotionRecognizer
from sklearn.svm import SVC
# init a model, let's use SVC
my_model = SVC()
# pass my model to EmotionRecognizer instance
# and balance the dataset
rec = EmotionRecognizer(model=my_model, emotions=['sad', 'neutral', 'happy'], balance=True, verbose=0)
# train the model
rec.train()
# check the test accuracy for that model
print("Test score:", rec.test_score())
# check the train accuracy for that model
print("Train score:", rec.train_score())
```

**Output:**

```
Test score: 0.8148148148148148
Train score: 1.0
```

### Determining the best model

In order to determine the best model, you can by:

```python
# loads the best estimators from `grid` folder that was searched by GridSearchCV in `grid_search.py`,
# and set the model to the best in terms of test score, and then train it
rec.determine_best_model()
# get the determined sklearn model name
print(rec.model.__class__.__name__, "is the best")
# get the test accuracy score for the best estimator
print("Test score:", rec.test_score())
```

**Output:**

```
MLPClassifier is the best
Test Score: 0.8958333333333334
```

### Predicting

Just pass an audio path to the `rec.predict()` method as shown below:

```python
# this is a neutral speech from emo-db from the testing set
print("Prediction:", rec.predict("data/emodb/wav/15a04Nc.wav"))
# this is a sad speech from TESS from the testing set
print("Prediction:", rec.predict("data/validation/Actor_25/25_01_01_01_back_sad.wav"))
```

**Output:**

```
Prediction: neutral
Prediction: sad
```

You can pass any audio file, if it's not in the appropriate format (16000Hz and mono channel), then it'll be automatically converted, make sure you have `ffmpeg` installed in your system and added to *PATH*.

## Example 2: Using RNNs for 5 Emotions

```python
from deep_emotion_recognition import DeepEmotionRecognizer
# initialize instance
# inherited from emotion_recognition.EmotionRecognizer
# default parameters (LSTM: 128x2, Dense:128x2)
deeprec = DeepEmotionRecognizer(emotions=['angry', 'sad', 'neutral', 'ps', 'happy'], n_rnn_layers=2, n_dense_layers=2, rnn_units=128, dense_units=128)
# train the model
deeprec.train()
# get the accuracy
print(deeprec.test_score())
# predict angry audio sample
prediction = deeprec.predict('data/validation/Actor_10/03-02-05-02-02-02-10_angry.wav')
print(f"Prediction: {prediction}")
```

**Output:**

```
0.7717948717948718
Prediction: angry
```

Predicting probabilities is also possible (for classification ofc):

```python
print(deeprec.predict_proba("data/emodb/wav/16a01Wb.wav"))
```

**Output:**

```
{'angry': 0.99878675, 'sad': 0.0009922335, 'neutral': 7.959707e-06, 'ps': 0.00021298956, 'happy': 8.3598025e-08}
```

### Confusion Matrix

```python
print(deeprec.confusion_matrix(percentage=True, labeled=True))
```

**Output:**

```
              predicted_angry  predicted_sad  predicted_neutral  predicted_ps  predicted_happy
true_angry          80.769226       7.692308           3.846154      5.128205         2.564103
true_sad            12.820514      73.076920           3.846154      6.410257         3.846154
true_neutral         1.282051       1.282051          79.487183      1.282051        16.666668
true_ps             10.256411       3.846154           1.282051     79.487183         5.128205
true_happy           5.128205       8.974360           7.692308      8.974360        69.230774
```

## Example 3: Not Passing any Model and Removing the Custom Dataset

Below code initializes `EmotionRecognizer` with 3 chosen emotions while removing Custom dataset, and setting `balance` to `False`:

```python
from emotion_recognition import EmotionRecognizer
# initialize instance, this will take a bit the first time executed
# as it'll extract the features and calls determine_best_model() automatically
# to load the best performing model on the picked dataset
rec = EmotionRecognizer(emotions=["angry", "neutral", "sad"], balance=False, verbose=1, custom_db=False)
# it will be trained, so no need to train this time
# get the accuracy on the test set
print(rec.confusion_matrix())
# predict angry audio sample
prediction = rec.predict('data/validation/Actor_10/03-02-05-02-02-02-10_angry.wav')
print(f"Prediction: {prediction}")
```

**Output:**

```
[+] Best model determined: RandomForestClassifier with 93.454% test accuracy

              predicted_angry  predicted_neutral  predicted_sad
true_angry          98.275864           1.149425       0.574713
true_neutral         0.917431          88.073395      11.009174
true_sad             6.250000           1.875000      91.875000

Prediction: angry
```

You can print the number of samples on each class:

```python
rec.get_samples_by_class()
```

**Output:**

```
         train  test  total
angry      910   174   1084
neutral    650   109    759
sad        862   160   1022
total     2422   443   2865
```

In this case, the dataset is only from TESS and RAVDESS, and not balanced, you can pass `True` to `balance` on the `EmotionRecognizer` instance to balance the data.

## Algorithms Used

This repository can be used to build machine learning classifiers as well as regressors for the case of 3 emotions {'sad': 0, 'neutral': 1, 'happy': 2} and the case of 5 emotions {'angry': 1, 'sad': 2, 'neutral': 3, 'ps': 4, 'happy': 5}

### Classifiers

- SVC
- RandomForestClassifier
- GradientBoostingClassifier
- KNeighborsClassifier
- MLPClassifier
- BaggingClassifier
- Recurrent Neural Networks (Keras)

### Regressors

- SVR
- RandomForestRegressor
- GradientBoostingRegressor
- KNeighborsRegressor
- MLPRegressor
- BaggingRegressor
- Recurrent Neural Networks (Keras)

### Testing

You can test your own voice by executing the following command:

```
python test.py
```

Wait until "Please talk" prompt is appeared, then you can start talking, and the model will automatically detects your emotion when you stop (talking).

You can change emotions to predict, as well as models, type ``--help`` for more information.

```
python test.py --help
```

**Output:**

```
usage: test.py [-h] [-e EMOTIONS] [-m MODEL]

Testing emotion recognition system using your voice, please consider changing
the model and/or parameters as you wish.

optional arguments:
  -h, --help            show this help message and exit
  -e EMOTIONS, --emotions EMOTIONS
                        Emotions to recognize separated by a comma ',',
                        available emotions are "neutral", "calm", "happy"
                        "sad", "angry", "fear", "disgust", "ps" (pleasant
                        surprise) and "boredom", default is
                        "sad,neutral,happy"
  -m MODEL, --model MODEL
                        The model to use, 8 models available are: "SVC","AdaBo
                        ostClassifier","RandomForestClassifier","GradientBoost
                        ingClassifier","DecisionTreeClassifier","KNeighborsCla
                        ssifier","MLPClassifier","BaggingClassifier", default
                        is "BaggingClassifier"

```

## Plotting Histograms

This will only work if grid search is performed.

```python
from emotion_recognition import plot_histograms
# plot histograms on different classifiers
plot_histograms(classifiers=True)
```

**Output:**

<img src="images/Figure.png">
<p align="center">A Histogram shows different algorithms metric results on different data sizes as well as time consumed to train/predict.</p>
