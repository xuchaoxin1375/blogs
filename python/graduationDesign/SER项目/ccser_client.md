[toc]

# 基本功能

## GUI框架选择

- PySimpleGUI、tkinter和pyqt都是Python中常用的图形用户界面(GUI)工具包，它们都提供了创建GUI应用程序所需的必要组件，例如按钮、文本框、标签、下拉框、列表框等等。这些工具包都有各自的特点和优缺点，下面我将对它们进行详细介绍和比较。
  - PySimpleGUI
    PySimpleGUI是一个轻量级的Python GUI工具包，它使用Python标准库Tkinter实现，提供了简单易用的API接口，可以快速创建GUI应用程序。PySimpleGUI的优点在于它非常易于学习和使用，API接口简单直观，可以快速实现基本的GUI界面，适合初学者或快速原型开发。缺点是它的功能相对较少，不支持复杂的GUI界面和高级特性。
  - Tkinter
    - "Tkinter" 的全称是 "Tk Interface"，它是 Python 标准库之一，提供了创建 GUI 应用程序的工具。
    - 它的缩写是 "Tk" 或 "Tkinter"，在 Python 中可以使用 `import tkinter` 或 `import Tkinter` 来导入 Tkinter 模块。
    - Tkinter 和 PyQt 都是用于创建 GUI 应用程序的 Python 库，它们都提供了创建窗口、按钮、文本框等 GUI 元素的工具，但它们在使用和功能上有一些不同。在 Python 的 GUI 编程库 Tkinter 中，TK 代表 "Toolkit"（工具包），因为 Tkinter 是基于 Tk 工具包开发的。Tk 是一个跨平台的图形用户界面工具包，它提供了一组用于构建 GUI 应用程序的库和工具。"inter" 是 "Interface" 的缩写，表示 Tkinter 是一个用于创建用户界面的库。
    - Tkinter作为Python标准库中自带的一个GUI工具包，它使用Tk GUI工具包实现，能够跨平台运行。Tkinter的优点在于它是Python标准库中的一部分，不需要额外安装，可以直接使用，同时也提供了各种组件和布局管理器，支持简单的GUI界面和高级特性。缺点是它的界面风格较为陈旧，不够美观，也比较难以实现复杂的GUI界面和高级特性。
  - PyQt
    PyQt是一个基于Qt图形库的Python GUI工具包，它提供了丰富的组件和布局管理器，支持多种操作系统和平台，可以实现复杂的GUI界面和高级特性。PyQt的优点在于它的功能非常强大，可以实现复杂的界面和高级特性，同时也提供了丰富的文档和示例代码，学习起来相对较为容易。缺点是它的学习曲线比较陡峭，需要掌握Qt图形库的相关知识，同时也需要安装PyQt库和Qt图形库。
- 语法不同：Tkinter 是 Python 的标准库，语法较为简单，易于上手，而 PyQt 则需要安装额外的 PyQT 库，并且语法较为复杂，需要一定的学习成本。
- 平台支持不同：Tkinter 是跨平台的，可以在 Windows、Linux、Mac OS 等系统上使用，而 PyQt 在某些平台上可能存在兼容性问题。
- GUI 设计工具不同：PyQt 提供了 Qt Designer 工具，可以可视化地设计 GUI 界面，而 Tkinter 没有提供类似的工具，需要手动编写代码设计界面。
- 功能差异：PyQt 提供了更多的功能和小部件，例如支持多线程、数据库连接、图形绘制等，而 Tkinter 的功能相对较为简单，适合开发简单的 GUI 应用程序。
- 综上所述，如果初学者或需要快速原型开发，可以选择PySimpleGUI；如果你需要实现简单的GUI界面和高级特性，可以选择Tkinter；如果你需要实现复杂的GUI界面和高级特性，可以选择PyQt。同时，不同的工具包也可以结合使用，例如可以使用PySimpleGUI快速实现简单的界面，然后再使用PyQt实现复杂的特性。



## 波形图

- 基本波形图

```python
import librosa
import librosa.display
import matplotlib.pyplot as plt

# 加载音频文件
audio_file = 'audio.wav'
y, sr = librosa.load(audio_file, sr=None)

# 绘制波形图
plt.figure(figsize=(14, 5))
librosa.display.waveplot(y, sr=sr)
plt.title('Waveform')
plt.xlabel('Time (seconds)')
plt.ylabel('Amplitude')
plt.show()
```

## 频谱图

- 你可以使用librosa库中的`specshow()`函数来绘制频谱图。下面是一个示例代码：

  ```python
  import librosa
  import librosa.display
  import matplotlib.pyplot as plt
  
  # 加载音频文件
  audio_path = librosa.util.example_audio_file()
  y, sr = librosa.load(audio_path)
  
  # 计算短时傅里叶变换
  D = librosa.stft(y)
  
  # 绘制频谱图
  plt.figure(figsize=(10, 4))
  librosa.display.specshow(librosa.amplitude_to_db(abs(D), ref=np.max), y_axis='linear', x_axis='time')
  plt.colorbar(format='%+2.0f dB')
  plt.title('线性频谱图')
  plt.xlabel('时间')
  plt.ylabel('频率')
  plt.show()
  ```

  在这个示例中，我们首先使用`librosa.load()`函数加载一个音频文件，并将音频信号存储在`y`变量中，采样率存储在`sr`变量中。然后，我们使用`librosa.stft()`函数计算音频信号的短时傅里叶变换，并将结果存储在`D`变量中。

  最后，我们使用`librosa.display.specshow()`函数来绘制频谱图。该函数的第一个参数是幅度谱，我们使用`librosa.amplitude_to_db()`函数将其转换为分贝表示。`y_axis`参数指定频率轴的标尺类型，`x_axis`参数指定时间轴的标尺类型。我们还使用`plt.colorbar()`函数添加一个色条来显示幅度值。最后，我们使用`plt.title()`、`plt.xlabel()`和`plt.ylabel()`函数添加图标题和轴标签，并使用`plt.show()`函数显示图形。

  请注意，如果你想绘制对数频谱图，可以将`y_axis`参数设置为`'log'`。如果你想绘制Mel频谱图，则需要使用`librosa.feature.melspectrogram()`函数计算Mel频谱，然后使用`librosa.display.specshow()`函数绘制图形。

## Mel频谱图

下面是一个使用librosa绘制Mel频谱图的示例代码：

```python
import librosa
import librosa.display
import matplotlib.pyplot as plt

# 加载音频文件
audio_path = librosa.util.example_audio_file()
y, sr = librosa.load(audio_path)

# 计算Mel频谱
S = librosa.feature.melspectrogram(y, sr=sr, n_mels=128)

# 将Mel频谱转换为分贝表示
S_db = librosa.power_to_db(S, ref=np.max)

# 绘制Mel频谱图
plt.figure(figsize=(10, 4))
librosa.display.specshow(S_db, x_axis='time', y_axis='mel', sr=sr, fmax=8000)
plt.colorbar(format='%+2.0f dB')
plt.title('Mel频谱图')
plt.xlabel('时间')
plt.ylabel('频率（Mel刻度）')
plt.show()
```

在这个示例中，我们首先使用`librosa.load()`函数加载一个音频文件，并将音频信号存储在`y`变量中，采样率存储在`sr`变量中。然后，我们使用`librosa.feature.melspectrogram()`函数计算音频信号的Mel频谱，并将结果存储在`S`变量中。

接下来，我们使用`librosa.power_to_db()`函数将Mel频谱转换为分贝表示，并将其存储在`S_db`变量中。最后，我们使用`librosa.display.specshow()`函数来绘制Mel频谱图。该函数的第一个参数是Mel频谱，`x_axis`参数指定时间轴的标尺类型，`y_axis`参数指定频率轴的标尺类型。我们还使用`sr`参数指定采样率，`fmax`参数指定最大频率。我们使用`plt.colorbar()`函数添加一个色条来显示幅度值。最后，我们使用`plt.title()`、`plt.xlabel()`和`plt.ylabel()`函数添加图标题和轴标签，并使用`plt.show()`函数显示图形。

请注意，`librosa.feature.melspectrogram()`函数有许多参数，可以用于控制Mel频谱的计算方式。例如，`n_mels`参数指定Mel滤波器的数量，`hop_length`参数指定帧移量等。你可以根据需要调整这些参数，以获得最佳的Mel频谱。

## 选择文件

- 你可以使用PySimpleGUI的`FileBrowse`控件来让用户选择一个文件。下面是一个示例代码：

  ```python
  import PySimpleGUI as sg
  
  sg.theme('DarkBlue')
  
  # 定义GUI布局
  layout = [
      [sg.Text('请选择一个文件：')],
      [sg.Input(), sg.FileBrowse()],
      [sg.Button('确定'), sg.Button('取消')]
  ]
  
  # 创建窗口
  window = sg.Window('文件选择示例', layout)
  
  # 事件循环
  while True:
      event, values = window.read()
      if event in (None, '取消'):
          break
      elif event == '确定':
          selected_file = values[0]
          sg.popup('您选择的文件是：{}'.format(selected_file))
  
  # 关闭窗口
  window.close()
  ```

  在这个示例中，我们使用`Input`控件创建一个文本框，用于显示用户选择的文件路径。然后，我们使用`FileBrowse`控件创建一个按钮，当用户单击它时，将显示一个文件选择对话框，用户可以在其中选择一个文件。

  在事件循环中，当用户单击确定按钮时，我们使用`values`字典获取文本框中的文件路径，并使用`sg.popup()`函数创建一个消息框，显示选中的文件。请注意，`values`字典的值是一个列表，因为我们使用了`Input`控件，所以我们使用[0]索引来获取用户选择的文件路径。

  最后，我们使用`window.close()`函数关闭窗口。

## 选择特征

如果是我希望让用户从我给定的5中特征:mfcc,mel,contrast,Chromagram,tonnez中选择若干种改怎么做

你可以使用PySimpleGUI的`Multichoie`控件来让用户从给定的5种特征中选择若干种。下面是一个示例代码：

```python
import PySimpleGUI as sg

sg.theme('DarkBlue')

# 定义GUI布局
layout = [
    [sg.Text('请选择一个或多个特征：')],
    [sg.Checkbox('MFCC', key='mfcc'), sg.Checkbox('Mel', key='mel'),
     sg.Checkbox('Contrast', key='contrast')],
    [sg.Checkbox('Chromagram', key='chroma'), sg.Checkbox('Tonnez', key='tonnez')],
    [sg.Button('确定'), sg.Button('取消')]
]

# 创建窗口
window = sg.Window('特征选择示例', layout)

# 事件循环
while True:
    event, values = window.read()
    if event in (None, '取消'):
        break
    elif event == '确定':
        selected_features = [key for key, value in values.items() if value]
        sg.popup('您选择的特征是：{}'.format(', '.join(selected_features)))

# 关闭窗口
window.close()
```

在这个示例中，我们使用`Checkbox`控件创建了5个复选框，每个复选框代表一个特征。这些复选框使用了不同的键名，以便我们可以在事件循环中区分它们。

在事件循环中，当用户单击确定按钮时，我们使用列表推导式和`values`字典从中提取选中的特征，并使用`sg.popup()`函数创建一个消息框，显示选中的特征。请注意，我们使用了`join()`方法将选中的特征连接成一个字符串，以逗号和空格分隔。

最后，我们使用`window.close()`函数关闭窗口。

## 创建带有多个输入式组件的GUI窗口

使用PySimpleGUI创建带有多个输入式组件的GUI窗口的示例代码：

```python
import PySimpleGUI as sg

# 定义GUI窗口布局
layout = [
    [sg.Text('Name:'), sg.InputText(key='name')],
    [sg.Text('Age:'), sg.InputText(key='age')],
    [sg.Text('Gender:'), sg.Combo(['Male', 'Female'], key='gender')],
    [sg.Text('Hobbies:'), sg.Listbox(['Reading', 'Traveling', 'Sports'], size=(20, 3), key='hobbies')],
    [sg.Button('Submit'), sg.Button('Cancel')]
]

# 创建GUI窗口
window = sg.Window('Input Form', layout, default_element_size=(20, 1), default_button_element_size=(8, 2))

# 事件循环
while True:
    event, values = window.read()
    if event in (None, 'Cancel'):
        break
    elif event == 'Submit':
        # 对输入式组件进行验证和转换
        validated_values = window.validate(values)
        if validated_values:
            # 显示输入的值
            sg.popup(f"Name: {validated_values['name']}\nAge: {validated_values['age']}\nGender: {validated_values['gender']}\nHobbies: {', '.join(validated_values['hobbies'])}")
    else:
        print(f"Unknown event: {event}")

# 关闭GUI窗口
window.close()
```

以上代码创建了一个简单的输入表单窗口，其中包含了一个文本输入框、一个数字输入框、一个单项选择输入式组件和一个多项选择输入式组件。在事件循环中，使用`window.read()`方法获取GUI事件和用户输入，使用`window.validate()`方法对输入进行验证和转换，最后使用`sg.popup()`函数显示输入的值。

## 多选

- 以下是使用PySimpleGUI库中sg.Radio组件的一个简单示例：

  ```python
  import PySimpleGUI as sg
  
  layout = [[sg.Text("Select an option:")],
            [sg.Radio("Option 1", "RADIO1", default=True),
             sg.Radio("Option 2", "RADIO1"), 
             sg.Radio("Option 3", "RADIO1")],
            [sg.Button("OK"), sg.Button("Cancel")]]
  
  window = sg.Window("Radio Example", layout)
  
  while True:
      event, values = window.read()
      if event == sg.WIN_CLOSED or event == "Cancel":
          break
      if values[0]:
          selected_option = "Option 1"
      elif values[1]:
          selected_option = "Option 2"
      elif values[2]:
          selected_option = "Option 3"
      sg.popup("You selected: " + selected_option)
  
  window.close()
  ```

- 这个示例创建了一个由三个选项组成的单选框，用户可以从中选择一个选项。选项由三个单选框(`sg.Radio`)定义，并在布局中使用。`sg.Radio`组件需要指定**标签和组名**，以确保它们在同一组内。

- 在这个示例中，所有单选框都属于同一组(`RADIO1`)，并且第一个选项(`Option 1`)是默认选项。

- 当用户单击“OK”按钮时，程序将读取用户的选择，并将对应的选项文本(`Option 1`, `Option 2`, 或 `Option 3`)存储在变量`selected_option`中。程序随后使用`sg.popup`方法弹出一个消息框，显示用户的选择。

- 注意，这个示例需要安装PySimpleGUI库才能运行。可以使用`pip install PySimpleGUI`命令在您的Python环境中安装该库。

- db:OK0

- e_config:OK1

- f_config:OK2

- algo:OK3

- file:OK4

- draw:OK5

## finalize参数

- 在PySimpleGUI中，`finalize`参数是用于指定是否在创建GUI元素时立即创建它们的关键字参数之一。
- 当`finalize`参数为True时，GUI元素在创建后立即显示在屏幕上；
- 当`finalize`参数为False时，GUI元素将在稍后显式地调用`finalize()`方法时才显示在屏幕上。

以下是一个示例，说明如何使用`finalize`参数创建一个简单的GUI窗口：

```python
import PySimpleGUI as sg

# 创建一个GUI窗口
layout = [[sg.Text("Enter your name:"), sg.Input(key="name")],
          [sg.Button("OK"), sg.Button("Cancel")]]

window = sg.Window("My GUI", layout, finalize=True)

# 进入事件循环
while True:
    event, values = window.read()
    if event == sg.WINDOW_CLOSED or event == "Cancel":
        break
    elif event == "OK":
        name = values["name"]
        sg.popup(f"Hello, {name}!")

# 关闭窗口并退出程序
window.close()
```

- 在这个示例中，`finalize=True`参数被传递给`sg.Window`方法，使得创建的GUI窗口在创建后立即显示在屏幕上。
- 如果将`finalize`参数设置为`False`，则需要在创建GUI元素后显式地调用`finalize()`方法才能将它们显示在屏幕上。

- 需要注意的是，`finalize`参数只对容器类型的GUI元素有效，例如`Window`、`Frame`、`Column`和`Tab`等。对于其他类型的GUI元素，例如`Text`、`Input`和`Button`等，`finalize`参数不起作用。



- 在PySimpleGUI中，`finalize`是一个可选的参数，用于在创建一个图形用户界面(GUI)时，决定是否在调用`.Window()`方法时就对窗口进行“冻结”，即是否立即调用窗口的`finalize()`方法。
- 如果将`finalize`参数设置为`True`，则窗口将被冻结，无法再进行更改；如果设置为`False`，则可以在稍后调用窗口的`finalize()`方法进行冻结。

下面是一些使用`finalize`参数的示例：

```python
# 未使用finalize参数，需要在稍后手动调用finalize()方法
window = sg.Window("My Window", layout)
window.finalize()

# 使用finalize参数，窗口被创建后立即被冻结
window = sg.Window("My Window", layout, finalize=True)
```

- 需要注意的是，如果在窗口冻结之前对窗口进行了修改（如添加、删除或修改元素），则这些更改将被忽略。因此，建议在创建窗口时就决定是否使用`finalize`参数，并在之后避免对窗口进行修改。

## 多语言@python模块变量通信

- 本项目系统通过设置各模块的lang变量来统一控制UI元素语言
  - 通常,如果使用面向对象(OOP)的方法编写,这类做法不太需要额外注意
  - 但是如果不采用(OOP)的方法,直接通过访问定义在模块中的变量,可能会出现不符合预期的情况
    - 这和python导包(模块)的机制有关,例如我们运行某个多模块python程序,从main(入口源代码文件)开始运行
    - 运行过程中执行导包(模块)操作,(假设导入模块中有一个模块`A`,`x`在A中被初始化为`1`)
    - 被导入的模块中的所有语句被执行(包括函数定义(函数内的语句只有出现对应的调用语句才会执行),逻辑判断(if/else只有在满足对应分支的情况下会执行分支内的语句))
    - 主模块试图修改定义在A中的变量`x`(比如更改为2,即`A.x=2`,那么A中引用了`x`的相关语句不会收到这一消息(不被影响),除非相关语句被定义在一个函数中,在调用相应函数时能够知道变量`x`发生了变化.
  - 因此,通过python模块变量通信,需要十分小心,注意将相关语句(引用了用于通信的模块变量)打包到一个函数中,以后期调用的方式来读取更新的模块变量值.





