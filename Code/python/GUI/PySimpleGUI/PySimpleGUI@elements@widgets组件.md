[toc]

# 个人使用经验

- 根据我接触了一周多的时间来看,目前(2023年)时这个GUI框架的情况是:
  - 上手容易,相比原生的tkinter在高级组件和布局方面比较容易控制
  - 有些组件的参数没有效果(也即是存在bug)
  - 组件嵌套可能会使得部分效果不起作用,例如将这只了滚条的sg.Column放入到sg.Pane中,滚条就会失效
  - 又比如sg.FileBrowse设置了`enable_event=True`也没有效果
    - [No event on FileBrowse button · Issue #850 · PySimpleGUI/PySimpleGUI (github.com)](https://github.com/PySimpleGUI/PySimpleGUI/issues/850)
  - sg.Table的水平滚动实现起来需要绕弯路(workaround)
- 上述问题可能在将来得到修复,也可能需要很长时间来修复,不过有些问题有变通的方案,可以尝试在github的issue区提问或google找到相关的方案
- 总的来说,做一个简单的gui还是没有太大问题



# 基本组件

- [All Elements (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#all-elements)

以下是常用的 PySimpleGUI 组件、功能说明以及注意事项：

1. Text：用于在 GUI 界面中显示文本。可以通过指定字体、大小、颜色等属性来自定义文本样式。
2. Input：用于接收用户输入的文本。可以设置默认值、输入限制、密码模式等属性。
3. Button：用于触发事件或执行操作。可以自定义按钮文本、颜色、大小等属性。
4. Checkbox：用于选择或取消选中某个选项。可以设置默认状态、文本、颜色等属性。
5. Radio：用于从多个选项中选择一个。可以设置默认选项、文本、颜色等属性。
6. Listbox：用于从多个选项中**选择一个或多个**。可以设置选项列表、默认选项、颜色等属性。
7. Slider：用于从范围内选择一个值。可以设置默认值、范围、步长、颜色等属性。
8. Progress Bar：用于显示任务完成进度。可以设置进度条颜色、大小、样式等属性。
9. Image：用于在 GUI 界面中显示图像。可以设置图像路径、大小、缩放比例等属性。

- 更多请看上一节的[功能特点Features]

## 初学者容易犯的错误

### 创建一个窗口的基本流程

- 导包

- 设计包含若干控件的布局

  - 关于sg.Element的二维列表
  - 设计复杂布局时,这部分容易出错

- <可选>设置主题(`sg.theme()`)

- 创建窗口(`window=sg.Window(title=,layout=)`)

- <二选一>事件循环(event loop)(`while True`)(大多数情况下的选择,还有一种更加简单的一次性窗口,不是太常用)

  - 这部分也是比较容易出错,特别是,通常不应该将`sg.Window()`放到事件循环中,这回引起错误🎈
  - 应该将窗口显示(读取)放到事件循环中`window.read()`

- 关闭窗口(`window.close()`)

- 通常还会打包一个main函数,可以将:窗口创建以及事件循环移入到main()函数中

- ```python
  def main(layout):
      window=sg.Window("Result",layout)
      while True:
          event,values=window.read()
          if event in (sg.WINDOW_CLOSED, "Cancel"):
              break
          elif event=="OK":
              window['text'].update(value='new text')
              rf=window['res_frame_key'].update
              print(inspect.getfullargspec(rf))
      window.close()
  if __name__=="__main__":
      main(layout)
      
  ```


### 根据key访问元素@值

- `window[key]`

  - 当您需要修改某个元素时,使用`window[key]`来获取`sg`的元素对象
  - `<PySimpleGUI.PySimpleGUI.Checkbox object at 0x0000021F9F18C430> @{short}🎈`

- `values[key]`

  - 当你需要获取某个事件对应的值,使用`values[key]`

  - 例如,获取用户在输入框内输入的值或复选框(checkbox)上是否做了勾选

## eg@演示event和values的使用

例如，以下是一个使用`event`和`values`变量的示例代码，演示了如何在PySimpleGUI中处理按钮事件和文本输入事件：

```python
import PySimpleGUI as sg
def demo_event_value():

    # 定义GUI布局
    layout = [
        [sg.Text('请输入您的姓名：')],
        [sg.InputText()],
        [sg.Checkbox("check item:show the use of key",key="-checkbox-")],
        [sg.Button('确定')],
    ]

    # 创建GUI窗口
    window = sg.Window('示例:event和value变量的使用', layout)

    # 处理GUI事件和用户输入
    while True:
        event, values = window.read()
        print("@{event}:")
        print(event)
        print("@{values}:")
        print(values)

        if event == sg.WIN_CLOSED:
            break

        if event == '确定':
            name = values[0]
            index_value=values[0]
            key_checked_value=values['-checkbox-']
            sg.popup(f'您好，{name}！欢迎使用PySimpleGUI。\n\
                     {event=},{index_value=},{key_checked_value=}')

    # 关闭GUI窗口
    window.close()

if __name__ == "__main__":
    demo_event_value()
```

- ​	

  ```bash
  @{event}:
  确定
  @{values}:
  {0: 'gg', '-checkbox-': False}
  @{event}:
  确定
  @{values}:
  {0: 'hh', '-checkbox-': True}
  @{event}:
  确定
  @{values}:
  {0: 'hh', '-checkbox-': True}
  @{event}:
  None
  @{values}:
  None
  ```

  

- 在这个示例代码中，我们首先定义了一个包含一个文本框和一个按钮的GUI布局。在GUI窗口读取循环中，我们使用`event`和`values`变量来处理GUI事件和用户输入。如果用户点击了窗口的关闭按钮，我们使用`sg.WIN_CLOSED`事件来退出循环，并关闭GUI窗口。

- 如果用户点击了`确定`按钮，我们使用`values[0]`来获取用户输入的姓名，然后使用`sg.popup()`函数弹出一个欢迎消息。

- 需要注意的是，`values`变量是一个字典，键和值分别对应**输入式元素**的`名称和值`。

  - 如果你在定义元素时指定了`key`参数，则可以在`values`字典中使用该键来获取相应的元素值。
  - 如果你没有指定`key`参数，则可以使用自动编号的键来获取相应的元素值。



## CheckBox

- Checkbox是PySimpleGUI支持的一种控件，它允许用户从一组选项中选择一个或多个选项。

- 下面是一个可以完整运行的PySimpleGUI checkbox的例子：

  ```python
  import PySimpleGUI as sg
  
  sg.theme('DarkBlue')
  
  layout = [
      [sg.Text('请选择您喜欢的水果：')],
      [sg.Checkbox('苹果', key='apple'), sg.Checkbox('香蕉', key='banana'), sg.Checkbox('橙子', key='orange')],
      [sg.Button('确定'), sg.Button('取消')]
  ]
  
  window = sg.Window('Checkbox示例', layout)
  
  while True:
      event, values = window.read()
      if event in (None, '取消'):
          break
      elif event == '确定':
          selected_fruits = [fruit for fruit, selected in values.items() if selected]
          if selected_fruits:
              sg.popup('您选择了：{}'.format(', '.join(selected_fruits)))
          else:
              sg.popup('您没有选择任何水果！')
  
  window.close()
  ```

  在这个例子中，我们首先使用`sg.theme()`函数设置了PySimpleGUI的主题样式。然后，我们定义了一个包含三个复选框和两个按钮的GUI布局。每个复选框都有一个唯一的关键字(key)，以便我们在`values`字典中检索选中状态时使用。

- 在事件循环中，我们使用`window.read()`函数等待用户的交互。如果用户单击关闭按钮或取消按钮，我们将使用`break`语句退出事件循环。否则，如果用户单击确定按钮，我们将获取所有复选框的选中状态，并使用列表推导式从中提取选中的水果。如果有水果被选中，我们将使用`sg.popup()`函数创建一个消息框，显示用户选择的水果；否则，我们将显示一个消息框，指示用户没有选择任何水果。

  最后，我们使用`window.close()`函数关闭窗口。

## 更新元素🎈

- [update|Cookbook - PySimpleGUI](https://www.pysimplegui.org/en/latest/cookbook/#recipe-pattern-2b-persistent-window-multiple-reads-using-an-event-loop-updates-data-in-window)

- There are two important concepts when updating elements!

  If you need to interact with elements prior to calling window.read() you will need to "finalize" your window first using the finalize parameter when you create your Window.
  "Interacting" means calling that element's methods such as update, expand, draw_line, etc.
  Your change *will not be visible in the window until* you either:
  A. Call window.read() again
  B. Call window.refresh()

- 在更新元素时有两个重要的概念！

  如果您需要在调用 window.read() 之前与元素进行交互，则需要首先使用 finalize 参数在创建窗口时“完成”您的窗口。 “交互”指的是调用该元素的方法，例如 update、expand、draw_line 等。
  在窗口中您的更改将不会立即可见，直到您执行以下操作之一：
  A. 再次调用 window.read()
  B. 调用 window.refresh()

- 
  1. If you need to interact with elements prior to calling `window.read()` you will need to "finalize" your window first using the `finalize` parameter when you create your `Window`. 
  2. "Interacting" means calling that element's methods such as `update`, `expand`, `draw_line`, etc.
  3. Your change ***will not be visible in the window until\*** you either:
     A. Call `window.read()` again
     B. Call `window.refresh()`

- 在 PySimpleGUI 中，元素更新(`update`)方法的局限性主要有以下几点：

   1. 元素类型限制：不是所有的 PySimpleGUI 元素都支持 `update` 方法，只有特定类型的元素才能使用该方法进行更新。例如，`Text`、`Input`、`Button`、`Checkbox` 等元素可以使用 `update` 方法，但是布局元素（如 `Column`、`Tab` 等）不支持该方法。
   2. 属性限制：`update` 方法只能更新元素的部分属性，例如文本内容、颜色、背景色等，但是不能修改元素的布局、大小等属性。如果需要修改元素的布局或大小，需要重新创建该元素。
   3. 线程限制：在 PySimpleGUI 中，所有的 GUI 操作都需要在主线程中进行，因此如果在其他线程中使用 `update` 方法进行操作，可能会导致程序崩溃或出现不可预期的行为。如果需要在其他线程中更新 GUI，可以使用 `Window.write_event_value` 方法发送事件，然后在主线程中使用 `Window.read` 方法来读取事件并更新 GUI。
   4. 性能限制：如果更新的元素数量较多或更新频率较高，可能会导致程序的性能下降或出现卡顿现象。为了提高程序的性能和响应速度，可以考虑使用其他方法，如 `Window.refresh`、`Window.finalize`、`Window.FindElement` 等。

   总之，在使用 `update` 方法时需要注意以上限制，以避免出现不必要的问题和错误。

### read()@refresh()

在PySimpleGUI中，window.read()和window.refresh()都是用于窗口交互的方法，但它们的作用和使用方式略有不同。

window.read()是用于读取用户在窗口中进行的操作的方法，它会阻塞程序的执行，直到用户进行了某种操作，例如点击按钮、输入文本等。当用户进行操作后，read()方法会返回一个元组，元组中包含了用户输入的数据。需要注意的是，如果窗口被关闭，read()方法会返回一个空的元组，因此在使用read()方法之前，通常需要添加一个while循环，以确保窗口一直保持打开状态。

以下是一个示例代码，演示了如何使用read()方法从PySimpleGUI窗口中读取用户的输入：

```python
import PySimpleGUI as sg

layout = [[sg.Text('请输入姓名:'), sg.InputText(key='name')],
          [sg.Button('确定'), sg.Button('取消')]]

window = sg.Window('窗口标题', layout)

while True:
    event, values = window.read()
    if event in (None, '取消'):
        break
    elif event == '确定':
        name = values['name']
        sg.popup('您输入的姓名是：{}'.format(name))

window.close()
```

在以上代码中，我们创建了一个包含文本输入框和两个按钮的PySimpleGUI窗口。然后，我们使用read()方法来读取用户输入的数据，并根据用户点击的按钮来执行相应的操作。

相比之下，window.refresh()是用于刷新窗口的方法，它可以在窗口中进行的任何操作之前或之后被调用。当调用refresh()方法时，PySimpleGUI会重新绘制整个窗口，以便在窗口中显示最新的内容。

需要注意的是，refresh()方法通常只在特殊情况下使用，例如在长时间运行的循环中，需要周期性地更新窗口内容时。在一般情况下，PySimpleGUI会自动在用户进行操作后更新窗口内容，因此通常不需要手动调用refresh()方法。

### 常量🎈sg.Constant

- 在PySimpleGUI中，LISTBOX_SELECT_MODE_是一个常量，用于表示Listbox控件的选择模式。Listbox控件可以有三种选择模式：(对他们的引用要加上前缀`sg.`)
  - LISTBOX_SELECT_MODE_SINGLE：单选模式，只能选择一个选项。
  - LISTBOX_SELECT_MODE_MULTIPLE：多选模式，可以同时选择多个选项。(对应于字符串`extended`)
  - LISTBOX_SELECT_MODE_EXTENDED：扩展多选模式，可以通过Shift和Ctrl键进行选项的批量选择。
- LISTBOX_SELECT_MODE_SINGLE、LISTBOX_SELECT_MODE_MULTIPLE和LISTBOX_SELECT_MODE_EXTENDED都是PySimpleGUI中的常量，可以通过在控件创建时设置'select_mode'参数来指定选择模式。
- 例如，要将Listbox控件的选择模式设置为扩展多选模式，可以使用以下代码(在ListBox小结中展示)
- `sg.WINDOW_CLOSED`是最常用的一个了(目前这个值通常代表`None`)

### ListBox控件

- [ListBox](https://www.pysimplegui.org/en/latest/#listbox-element)
- [ListBox|Call reference ](https://www.pysimplegui.org/en/latest/call reference/#listbox-element)

ListBox控件,通过参数(select_mode)可以控制是否允许选中超过1个的情况

而且选中的若干个元素包装为list(即便只选中1个,也会用列表包装)

因此,如果至少选中了一个(就会进入到本循环分支中),由于设置主题只能选择一个生效,ListBox的好处是可以直接展示备选列表中的一部分主题

实际在给用户选择某一个主题时,使用ComboxBox会是更好(准确)的选择!

### eg 通过ListBox实现多选@更换主题

- 下面的代码中

  - main1()展示切换主题(重启窗口)
  - main2()展示了使用预定义的sg常量而不是用直接用字面量来指定取值

  ```python
  import PySimpleGUI as sg
  # sg.theme('Dark Brown')
  def make_window1(theme=None):
      if theme:
          sg.theme(theme)
      layout = [[sg.Text('Theme Browser')],
              [sg.Text('Click a Theme color to see demo window')],
              [sg.Listbox(values=sg.theme_list(), size=(20, 12), key='-LIST-', enable_events=True,select_mode='extended')],
              [sg.Button('set theme')]]
      window = sg.Window('Theme Browser', layout)
      return window
  def main1():
      window=make_window1()
      while True:  # Event Loop
          event, values = window.read()
          if event in (None, 'Exit'):
              break
          elif event=='-LIST-':
              print(event,"[I],theme item clicked",values['-LIST-'])
  
          elif(event=='set theme'):
              theme=values['-LIST-'][0]
              window.close()
              window=make_window1(theme)
              #使用refresh无法更新主题,需要close原来的window后重建
              # sg.theme(theme)
              # window.refresh()
      window.close()
  
  def main2():
  
      options = ['Option 1', 'Option 2', 'Option 3']
  
      layout = [[sg.Text('Select options:')],
              [sg.Listbox(values=options, size=(30, 5), select_mode=sg.LISTBOX_SELECT_MODE_EXTENDED)],
              [sg.Button('Ok'), sg.Button('Cancel')]]
  
      window = sg.Window('Window Title', layout)
  
      while True:
          event, values = window.read()
          if event in (sg.WIN_CLOSED, 'Cancel'):
              break
          elif event == 'Ok':
              selected_options = values[0]
              sg.popup('Selected options:', selected_options)
  
      window.close()
  
  if __name__=="__main__":
      # main1()
      main2()
  ```

## Themes

- 使用官方文档的搜索功能查看更多相关主题配色的内容

[Themes](https://www.pysimplegui.org/en/latest/readme/#themes)

Tired of the default grey GUIs? PySimpleGUI makes it trivial for your window to look nice by making a single call to the theme function. There are over 150 different color themes available for you to

[Themes](https://www.pysimplegui.org/en/latest/#themes)

The first line of code after the import is a call to theme . Until Dec 2019 the way a "theme" was specific in PySimpleGUI was to call change_look_and_feel . That call has been replaced by the more sim

[Themes](https://www.pysimplegui.org/en/latest/call reference/#themes)

The way to get Windows that have elements that have matching colors. Sets / Gets the current Theme. If none is specified then returns the current theme. This call replaces the ChangeLookAndFeel / chan

[TTK Themes](https://www.pysimplegui.org/en/latest/#ttk-themes)

tkinter has a number of "Themes" that can be used with ttk widgets. In PySimpleGUI these widgets include - Table, Tree, Combobox, Button, ProgressBar, Tabs & TabGroups. Some elements have a 'theme' pa

[Theme Functions](https://www.pysimplegui.org/en/latest/#theme-functions)

The basic theme function call is theme(theme_name) . This sets the theme. Calling without a parameter, theme() will return the name of the current theme. If you want to get or modify any of the theme

..

## color

- A string representing color. Anytime colors are involved, you can specify the tkinter color name such as 'lightblue' or an RGB hex value '#RRGGBB'. For buttons, the color parameter is a tuple (text color, background color)

  Anytime colors are written as a tuple in PySimpleGUI, the way to figure out which color is the background is to replace the "," with the word "on". ('white', 'red') specifies a button that is "white on red". Works anywhere there's a color tuple.

  - 对于 PySimpleGUI 中的颜色，可以使用字符串来表示。
    - 在使用颜色时，可以指定 tkinter 颜色名称，例如 'lightblue'，或者 RGB 十六进制值，例如 '#RRGGBB'。
  - 对于按钮等**控件**，颜色参数是一个元组 (文本颜色, 背景颜色)。

  - 在 PySimpleGUI 中，如果颜色被表示为元组，要确定哪一个是背景颜色，可以将 "," 替换为 "on"。例如，('white', 'red') 表示一个 "白色 on 红色" 的按钮。这种写法适用于任何需要使用颜色元组的地方。

- PySimpleGUI中的颜色可以通过RGB元组或十六进制字符串来指定。您可以使用以下方法之一来设置颜色：

  1. RGB元组：使用三个整数值来指定红、绿、蓝三个通道的强度。例如，`(255, 0, 0)`表示红色，`(0, 255, 0)`表示绿色，`(0, 0, 255)`表示蓝色。

  

  ```python
  import PySimpleGUI as sg
  
  # 使用RGB元组设置背景颜色
  layout = [[sg.Text('Hello, World!', background_color=(255, 0, 0))]]
  window = sg.Window('My Window', layout)
  ```

  1. 十六进制字符串：使用一个六位十六进制数来指定红、绿、蓝三个通道的强度。例如，`'#FF0000'`表示红色，`'#00FF00'`表示绿色，`'#0000FF'`表示蓝色。

  

  ```python
  import PySimpleGUI as sg
  
  # 使用十六进制字符串设置背景颜色
  layout = [[sg.Text('Hello, World!', background_color='#FF0000')]]
  window = sg.Window('My Window', layout)
  ```

- 您还可以使用`sg.theme`方法来设置整个应用程序的颜色主题。PySimpleGUI支持多个内置的颜色主题，例如`'DarkAmber'`、`'DarkBlue'`、`'DarkBrown'`、`'DarkGrey'`等等。您可以使用以下代码来设置颜色主题：

  

  ```python
  import PySimpleGUI as sg
  
  # 设置颜色主题
  sg.theme('DarkAmber')
  
  # 创建窗口并显示
  layout = [[sg.Text('Hello, World!')]]
  window = sg.Window('My Window', layout)
  ```

- 除了内置的颜色主题，您还可以使用自定义的颜色主题。例如，以下代码定义了一个名为`'MyTheme'`的自定义颜色主题：

  

  ```python
  import PySimpleGUI as sg
  
  # 自定义颜色主题
  my_theme = {
      'BACKGROUND': '#1E1E1E',
      'TEXT': '#FFFFFF',
      'INPUT': '#000000',
      'TEXT_INPUT': '#FFFFFF',
      'SCROLL': '#C7E78B',
      'BUTTON': ('#FFFFFF', '#1E1E1E'),
      'PROGRESS': ('#01826B', '#D0D0D0'),
      'BORDER': 1,
      'SLIDER_DEPTH': 0,
      'PROGRESS_DEPTH': 0
  }
  
  # 设置颜色主题
  sg.theme_add_new('MyTheme', my_theme)
  sg.theme('MyTheme')
  
  # 创建窗口并显示
  layout = [[sg.Text('Hello, World!')]]
  window = sg.Window('My Window', layout)
  ```

  在上面的示例中，我们定义了一个包含多个颜色设置的字典`my_theme`，然后使用`sg.theme_add_new`方法将其添加为名为`'MyTheme'`的自定义颜色主题。最后，我们使用`sg.theme`方法设置颜色主题为`'MyTheme'`。

## popup

- [popup](https://www.pysimplegui.org/en/latest/#popup-output)

- popup和Text可能是最简单的组件了

- 注意popup会生成自己的窗口(window),不应该将`sg.popup`相关元素放入到`sg.Window`的布局参数中,会导致错误

- 一个最简单的popup的例子:

  - ```python
    import PySimpleGUI as sg
    
    res=sg.popup("hello")
    
    #print(res)
    
    ```

    - 通过打印res,可以看到,如果点击了默认生成的OK按钮,`sg.popup`返回一个`OK`字符串

- If this popup doesn't have the features you want, then you can easily make your own. 

- Popups can be accomplished in 1 line of code:

  -  `choice, _ = sg.Window('Continue?', [[sg.T('Do you want to continue?')], [sg.Yes(s=10), sg.No(s=10)]], disable_close=True).read(close=True)`

- 也就是说,当PySimpleGUI提供的popup不足以满足需要,我们可以通过自己设计一个window来模拟相关功能,还可以定制功能,例如

  - ```python
    import PySimpleGUI as sg
    
    choice, _ = sg.Window(
        "Continue?",
        [[sg.T("Do you want to continue?")], [sg.Yes(s=10), sg.No(s=10)]],
        disable_close=True,
    ).read(close=True)
    
    ```

### Popup Input

- [Popup input|PySimpleGUI](https://www.pysimplegui.org/en/latest/#popup-input)

## Button

- botton家族相关控件是使用的最多的一类控件之一
- 处理最基本的button,下面主要提一下高级的button,Chooser button

### "Chooser" Buttons

- ["Chooser" Buttons (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#chooser-buttons)
- These buttons are used to show dialog boxes that choose something like a filename, date, color, etc.. that are <u>filled into an `InputText` Element</u> (or some other "target".... see below regarding targets)
  - CalendarButton
  - ColorChooserButton
  - FileBrowse
  - FilesBrowse
  - FileSaveAs
  - FolderBrowse

#### FolderBrowse

- ```python
  import PySimpleGUI as sg
  layout = [
      [sg.T("Source Folder")],
      [sg.In(key="input")],
      [
          sg.FolderBrowse(
              target="input",#这里显式的将选取结果通过key的方式绑定到上面的文本框(`input`)
          ),
          sg.OK(),
      ],
  ]
  while True:
      window = sg.Window("My App", layout, resizable=True)
      event, values = window.read()
      # 当文件选择完成后,依然会处于阻塞状态,需要借助其他键来继续(比如这里的OK)
      # IMPORT NOTE ABOUT SHORTCUT BUTTONS Prior to release 3.11.0, these buttons closed the window.
      # Starting with 3.11 they will not close the window. They act like RButtons (return the button text and do not close the window)
      if event:
          print(event, values)
      if event in (sg.WIN_CLOSED, "OK"):
          break
  
  window.close()
  
  ```

  - ```python
    (d:\condaPythonEnvs\tf2.10) PS D:\repos\CCSER\SER\SG>  py demo5.py
    OK {'input': 'D:/repos/CCSER/SER/data/savee', 'Browse': 'D:/repos/CCSER/SER/data/savee'}
    ```

  - 上面的例子中,是否使用`enable_events=True`效果一样


### 关于Chooser Button的enable_event问题

- 以下提供两种变通方案,以sg.FileBrowse为例

- 将sg.FileBrowse利用target参数关联到另一个组件(默认是其左侧的一个可输入组件,比如input 或listbox)

- 对这个辅助关联的组件启用enable_events=True参数

- 这样,通过`sg.FileBrowse`选择一个文件后,事件循环就可以捕获到辅助组件的event

  ```python
  import PySimpleGUI as sg
  
  layout = [
      [sg.Input(key='-FILE-', enable_events=True), sg.FileBrowse()],
      [sg.Button('OK'), sg.Button('Cancel')]
  ]
  
  window = sg.Window('File Browse', layout)
  
  while True:
      event, values = window.read()
      print(event,values)
      if event in (sg.WIN_CLOSED, 'Cancel'):
          break
      elif event == '-FILE-':
          print(f'File selected: {values["-FILE-"]}')
  
  window.close()
  ```

- 以下是另一种相似的变通方法,可以在用户选择完文件的瞬间捕获事件

  - 这里`sg.Browse`默认的key是`Browse`,可以借助key参数修改,下面会给出代码
  - 由于没有将target关联到自身之外的辅助对象,如果要像上例一样选中后通过辅助对象显示路径,那么考虑在事件循环中利用获取到的event进行控件视图刷新

  ```python
  import PySimpleGUI as sg
  
  layout = [
      [sg.Input(key='-FILE-'), sg.FileBrowse(enable_events=True,target="Browse")],
      [sg.Button('OK'), sg.Button('Cancel')]
  ]
  
  window = sg.Window('File Browse', layout)
  
  while True:
      event, values = window.read()
      # print(event)
      if event in (sg.WIN_CLOSED, 'Cancel'):
          break
      elif event == 'Browse':
          print(event,values[event])
          # print(f'File selected: {values["-FILE-"]}')
          window['-FILE-'].update(values['Browse'])
  
  window.close()
  ```

- 修改`sg.FileBrowse`的key

  ```python
  import PySimpleGUI as sg
  
  layout = [
      [sg.Input(key='-FILE-'), sg.FileBrowse(enable_events=True,target="wk",key="wk")],
      [sg.Button('OK'), sg.Button('Cancel')]
  ]
  
  window = sg.Window('File Browse', layout)
  
  while True:
      event, values = window.read()
      # print(event)
      if event in (sg.WIN_CLOSED, 'Cancel'):
          break
      elif event == 'wk':
          print(event,values[event])
          # print(f'File selected: {values["-FILE-"]}')
          window['-FILE-'].update(values[event])
  
  window.close()
  ```

- 另一种策略是使用虚拟对象元素(dummy object)

  - ```python
    import PySimpleGUI as sg
    
    layout =    [[sg.Input(key='_FILEBROWSE_', enable_events=True, visible=False)],
                [sg.FileBrowse(target='_FILEBROWSE_')],
                [sg.OK()],]
    
    window = sg.Window('My new window').Layout(layout)
    
    while True:             # Event Loop
        event, values = window.Read()
        if event is None:
            break
        print(event, values)
    ```

    

## menu

- [menu](https://www.pysimplegui.org/en/latest/cookbook/#menus)
- [menu definition@PySimpleGUI](https://www.pysimplegui.org/en/latest/#menu-definition)

### Menus

- Menus are nothing more than buttons that live in a menu-bar. When you click on a menu item, you get back a "button" with that menu item's text, just as you would had that text been on a button.

- Menu's are defined **separately** from the GUI window. To add one to your window, simply insert `sg.Menu(menu_layout)`. 

- The menu definition is a list of menu choices and submenus. They are a list of lists. Copy the Recipe and play with it. You'll eventually get when you're looking for.

- If you double click the dashed line at the top of the list of choices, that menu will tear off and become **<u>a floating toolbar</u>**. How cool! To enable this feature, set the parameter `tearoff=True` in your call to `sg.Menu()`

- 菜单就是存在于菜单栏中的按钮。当你点击菜单项时，你会得到一个带有该菜单项文本的“按钮”，就像该文本本来就是一个按钮一样。

  菜单是与 GUI 窗口分开定义的。要将菜单添加到窗口中，只需插入 sg.Menu(menu_layout)。菜单定义是菜单选项和子菜单的列表。它们是一个列表的列表。复制这个示例并进行尝试。你最终会得到你想要的结果。

  如果你双击选择列表顶部的虚线，该菜单将会被拆分出来并成为一个浮动工具栏。多么酷啊！要启用此功能，请在调用 sg.Menu() 时将 tearoff=True 参数设置为 true。

### Menu Definition

```python
menu_def = ['BLANK', ['&Open', '&Save', ['1', '2', ['a', 'b']], '!&Properties', 'E&xit']]
```

- 以下的快捷键说明借助上述例子说明

#### 定义菜单上的快捷键`&`

- A menu is defined using a list. A "Menu entry" is a string that specifies: * text shown * keyboard shortcut * key
- See section on Menu Keys for more information on using keys with menus.
- An entry without a key and keyboard shortcut is a simple string `'Menu Item'`

- If you want to make the "M" be a keyboard shortcut, place an `&` in front of the letter that is the shortcut. `'&Menu Item'`
- 例如,上面定义的菜单中,将`&Open`,使得字母`O`变为快捷键
  - 而`E&xit`使得`x`变为该选项的快捷键
- 定义好快捷键后,我们怎么使用呢?以windows系统为例:
  - 先按下键盘上的`alt`键,您可以看到和大多数windows应用一样,菜单上的菜单按钮上被设置为快捷键的字母(被`&`修饰的字母)会有一条下滑线装饰
  - 在按下对应的字母,效果就如同您用鼠标点击了对应的菜单选项

#### 定义菜单按钮的键(key)`::`

- 这里的key是指独一无二的名字,而不是说键盘上的快捷键`😂`

- You can add "keys" to make menu items `unique` or as <u>another way of identifying a menu item</u> than **the text shown**.

  - 例如,某些菜单按钮的子菜单按钮可能重名!这时候用`::`可以放便的定义不重名按钮
  - 不过这种情况不常见就是了

-  The key is added to the text portion by placing `::` after the text.

  - ```python
    'Menu Item::key'
    ```

  - 这时候,如果点击相应按钮,返回的事件名为`Menu Item::key`,例如某个菜单被定义为:`Normal::q`,那么返回的键就是`Normal::q`

  - 那么为什么使用`::`而不是随便用一种符号连接一个独一无二的key(关键字)?

    - 因为,这样渲染出来的菜单会将`::key`这部分隐去,而不改变外观,同时又可以为某个菜单上的按钮设定一个独一无二的键

- The first entry can be ignored.

- `'BLANK`' was chosen for this example.

-  It's this way because normally you would specify these menus under some heading on a menu-bar. But here there is no heading so it's filled in with any value you want.

#### 子菜单分组`---`

- `sg.Menu`定义主菜单
  - 如果您定义了子菜单,那么可以对子菜单进行分组

- **Separators** If you want a separator between 2 items, add the entry `'---'` and it will add a separator item at that place in your menu.

#### 综合例子:

- 这个例子可以在pySimpleGUI自带的例子中找到,也可以在官网的demo中获取

- 下面是其中菜单定义的部分

  ```python
      menu_def = [
          ["&File", ["&Open", "&Save", "&Properties", "E&xit"]],
          [
              "&Edit",
              [
                  "&Paste",
                  [
                      "Special",
                      "Normal::q",
                  ],
                  "Undo",
              ],
          ],
          [
              "&Toolbar",
              ["---", "Command &1", "Command &2", "---", "Command &3", "Command &4"],
          ],
          ["&Help", "&About..."],
      ]
  ```

- 上述的`menu_def`定义了一个菜单栏(menubar),而且每个主菜单按钮又包含子菜单按钮

  - 主菜单按钮包括:
    - File
    - Edit
    - Toolbar
    - Help

- 如果主菜单中有2个(或者更多)连续的字符串(例如A,B,..),那么第一个作为主菜单按钮显示,第2个作为主菜单的一个子菜单按钮,其余的将被忽略

- 如果希望子菜单可以包含多个,那么要用`[]`将子表示子菜单的按钮包裹起来

- 其余用法和普通按钮一样,当你点击菜单上的某个按钮(无论是那一级菜单),就会返回一个对应的key
- 用这个`if event==key`来判断并在其中编写xiang'ying就可以

#### eg:Windows-like program demo

- ```python
  import PySimpleGUI as sg
  
  
  # sg.popup_scrolled(long_text)
  # window.close()
  ##
  import PySimpleGUI as sg
  
  sg.theme("LightGreen")
  sg.set_options(element_padding=(0, 0))
  
  # ------ Menu Definition ------ #
  menu_def = [
      ["File", ["Open", "Save", "Exit"]],
      [
          "Edit",
          [
              "Paste",
              [
                  "Special",
                  "Normal",
              ],
              "Undo",
          ],
      ],
      ["Help", "About..."],
  ]
  
  # ------ GUI Defintion ------ #
  layout = [
      [
          sg.Menu(
              menu_def,
          )
      ],
      [sg.Output(size=(60, 20))],
  ]
  
  window = sg.Window(
      "Windows-like program",
      layout,
      default_element_size=(12, 1),
      auto_size_text=False,
      auto_size_buttons=False,
      default_button_element_size=(12, 1),
  )
  
  # ------ Loop & Process button menu choices ------ #
  while True:
      event, values = window.read()
      if event == sg.WIN_CLOSED or event == "Exit":
          break
      print("Button = ", event)
      # ------ Process menu choices ------ #
      if event == "About...":
          sg.popup("About this program", "Version 1.0", "PySimpleGUI rocks...")
      elif event == "Open":
          filename = sg.popup_get_file("file to open", no_window=True)
          print(filename)
  
  ```

#### 将Menu应用到右键菜单

- 在诸如listbox这类控件中,有`right_click_menu`这类参数,接收一个合法的`menu_def`,这样,当点击listbox中的内容时,可以弹出右键菜单

## 列布局(column)

### collections

- tips:[python - How can I create a column that is scrollable in PySimpleGUI - Stack Overflow](https://stackoverflow.com/questions/69321890/how-can-i-create-a-column-that-is-scrollable-in-pysimplegui)

### abstract

- [recipe-multiple-columns|Cookbook - PySimpleGUI](https://www.pysimplegui.org/en/latest/cookbook/#recipe-multiple-columns)

- [Column element](https://www.pysimplegui.org/en/latest/call%20reference/#column-element)

- PySimpleGUI中的sg.Column是一种用于布局的特殊窗口元素，它可以让用户将多个其他元素组合在一起，以便更好地控制它们在窗口中的位置和大小。sg.Column可以在窗口中创建垂直或水平的布局，并且可以嵌套在其他sg.Column中以创建更复杂的布局。使用sg.Column的主要优点是它提供了更灵活的布局选项，以及更精细的控制窗口中各元素的位置和大小。

- 另一方面，使用二维数组模拟双列布局也是一种常见的布局方法。这种方法适用于需要创建一个简单的双列布局，例如在显示一组相关控件时。使用二维数组模拟双列布局的优点是它非常简单直观，没有太多的学习曲线。同时，对于简单的布局来说，使用二维数组可能比使用sg.Column更快。

- justify the `Column` element's row by setting the `Column`'s `justification` parameter.

  You can also justify the entire contents within a `Column` by using the Column's `element_justification` parameter.

  With these parameter's it is possible to create windows that have their contents centered. Previously this was very difficult to do.

  This is currently only available in the primary PySimpleGUI port.

  They can also be used to justify a group of elements in a particular way.

  Placing `Column` elements inside `Columns` elements make it possible to create a multitude of

  可以通过设置Column的justification参数来将Column元素的行进行对齐。

  还可以使用Column的element_justification参数来对整个Column内的所有元素进行对齐。

  使用这些参数，可以创建内容居中的窗口布局。以前这样做非常困难。

  目前这个功能只在PySimpleGUI的主要版本中可用。

  它们还可用于以特定方式对一组元素进行对齐。

  将Column元素放置在Column元素内部可以创建各种各样的布局。

- 有时,用户可能希望将界面布局划分为多列(通常是2列),那么可以考虑使用sg.Column

  - 在设计布局的时候,sg.Column更加符合语义,而且更加符合直觉
  - sg.Column支持一些特殊的设置,例如可以设置可滚动,这样即使一列中包含了较多内容,也不用担心内容太长而导致后面的内容不可见
  - 此外,相较于用一个layout二维列表来模拟列布局,有更好的独立性,可以单独的调整其中的一列而不影响另一列,例如元素的添加和删除,以及对齐等方面的设置

- A Column is required when you have a tall element to <u>the left(some times right) of smaller elements.</u>

  - 在PySimpleGUI中，通常使用Column来创建垂直布局，其中左侧有一个高的元素，例如图像或列表框，右侧有较小的元素，例如按钮、复选框或输入字段。

    如果不使用Column，右侧的较小元素将被放置在左侧的高元素下方，创建一个不美观或不高效的布局。通过使用Column，可以将较小的元素放置在左侧的高元素旁边，创建一个更紧凑和有组织的布局。

- 总的来说，sg.Column提供了更灵活和精细的布局控制，但对于简单的双列布局，使用二维数组模拟也是一种有效的选择。

## Pane

- [Pane element](https://www.pysimplegui.org/en/latest/call%20reference/#pane-element)

- [reading tab|pane element@PySimpleGUI github](https://github.com/PySimpleGUI/PySimpleGUI/blob/master/docs/index.md#reading-tab-groups)

- `PySimpleGUI`是一个用于创建图形用户界面（GUI）的Python库。它使得创建各种窗口和输入框变得非常简单，同时支持多种GUI库（Tkinter, Qt, WxPython, Remi）。

- `Pane`元素是一个容器组件，用于组合多个其他元素，提供更复杂的布局和组织方式。

- 在`PySimpleGUI`中，`Pane`元素用于创建一个可以包含其他GUI元素的容器。

- Pane Element

  - New in version 3.20 is the Pane Element, a super-cool tkinter feature. You won't find this one in PySimpleGUIQt, only PySimpleGUI.

  -  It's difficult to describe one of these things. Think of them as **"Tabs without labels" that you can slide**.

  - ![slide it](https://user-images.githubusercontent.com/13696193/50035040-fcd50e80-ffcd-11e8-939c-df8ab8d64712.gif)

    

- `Pane`元素的主要特点如下：

  1. **容器性质**：`Pane`可以包含任意数量和类型的其他GUI元素，如文本、输入框、按钮等。
  2. **布局特性**：`Pane`元素可用于在窗口中创建更复杂的布局，方便地组合和管理其他元素。
  3. **滚动条支持**：`Pane`元素可以具有垂直和/或水平滚动条，允许用户在有限空间内查看和操作更多内容。
  4. **可调整大小**：`Pane`元素可以根据窗口大小变化而自动调整大小，以适应不同屏幕和显示需求。

- 要在`PySimpleGUI`中使用`Pane`元素，可以按照以下步骤操作：

  - 导入`PySimpleGUI`库。

  - 创建一个包含其他元素的`Pane`元素。例如，创建一个包含两个按钮和一个输入框的`Pane`：

  - 将`Pane`元素添加到窗口布局中：

  - 创建并显示窗口


## Table

- [Table Element](https://www.pysimplegui.org/en/latest/#table-element)
- [Call reference - PySimpleGUI](https://www.pysimplegui.org/en/latest/call reference/#table-element)

- 由于sg.Table在PySimpleGUI中算是最复杂的元素了,目前只适合做一些简单的表格展示,许多参数存在bug,而且有些效果不容易实现

### 常用参数

#### auto_size_columns

- 在 PySimpleGUI 中，`auto_size_columns` 是一个用于自动调整列宽的参数。

- 它可以应用于 `sg.Table`、`sg.Listbox` 和 `sg.Multilistbox` 等控件中。

- 当 `auto_size_columns` 设置为 `True` 时，PySimpleGUI 将根据**每列**中**最长的字符串来调整列宽**。

- 这样可以确保<u>所有的数据都能够在表格中完全显示，不会被截断或省略</u>。

- 如果您的内容相对于窗口来说比较短,那么是否使用`auto_size_columns`几乎不会产生影响

- 以下是一个使用 `auto_size_columns` 的示例代码：

  - ```python
    import PySimpleGUI as sg
    
    # 定义数据
    data = [
        [1, 'John Smith', 'john@example.com'],
        [2, 'Jane Doe', 'jane@example.com'],
        [3, 'Bob Johnson', 'bob@example.com'],
        [4, 'Jane Smith', 'janes@example.com']
    ]
    
    # 定义列名
    header = ['ID', 'Name', 'Email']
    
    # 定义布局
    layout = [
        [sg.Table(values=data, headings=header, auto_size_columns=True)],
        [sg.Table(values=data,headings=header,auto_size_columns=False)]
    ]
    
    # 创建窗口并运行事件循环
    window = sg.Window('Table Demo', layout)
    while True:
        event, values = window.read()
        if event == sg.WINDOW_CLOSED:
            break
    window.close()
    ```

- 默认情况下,sg.Table尝试等分各个列的宽度

  - 在这个示例中，`auto_size_columns` 被设置为 `True`，因此表格的列宽将根据每列中最长的字符串来自动调整。

    需要注意的是，当表格中的数据非常多或者单元格中的内容非常复杂时，自动调整列宽可能会导致表格变得非常宽，甚至超出屏幕范围。在这种情况下，可以考虑手动设置表格的列宽，或者使用滚动条来浏览表格中的数据。

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/0509fe37aa9747588021f43417929c10.png)



### 关于水平滚动

- [[Help/Question\] How to make a table left/right scrollable? · Issue #3521 · PySimpleGUI/PySimpleGUI (github.com)](https://github.com/PySimpleGUI/PySimpleGUI/issues/3521)

```python
""" 
这个demo假设要根据一系列函数名作为侧边大纲(目录),在内容相对窗口过长的时候支持垂直滚动
而主体是一个支持双向滚动的表格(当内容相对于窗口过大过多的时候)
"""
import PySimpleGUI as sg

header_list = [
    "Function",#第一列用来显式函数名字字符串
    "Starting Address",
    "Basic Blocks",
    "Instructions",
    "Cyclomatic Complexity",
    "Jilb's Metric",
   
]

import random

def create_data_quick(header_list):
    """ 
    Create 20 rows of randomly generated data for a given header list.
      Each row will have the same length as the header list. 
      The data will be rounded to 3 decimal places. The table_data parameter is a list that will be modified to include the generated data.
    """
    n_cols=len(header_list)
    table_data=[
        [
           "abc"*(random.randint(3,20)) for c_ in range(n_cols)
        #    字符串长度在9~57之间
        ]
        for r_ in range(10)
    ]
    return table_data

def make_layouts(header_list, table_data):
    """
    Generate a layout for a PySimpleGUI window based on header_list, table_data,
    and function_names.

    Args:
    - header_list (list of str): List of column names for the table.
    - table_data (list of list of str): List of rows of data for the table.
    - function_names (list of str): List of function names to display in the first
        column.

    Returns:
    - layout (list of list of PySimpleGUI elements): Layout for the PySimpleGUI window.
    """

    tabe_layout = [
        [
            sg.Table(
                values=table_data,
                headings=header_list[1:],
                # max_col_width=3,#不起作用?

                auto_size_columns=True,

                justification="center",
                vertical_scroll_only=False,
                expand_x=True,
                num_rows=5,
            )
        ]
    ]

    return tabe_layout


def main():
    """ This function generates a GUI window to display a table of data. It takes in a headerlist and tabledata as arguments to create the data, and a function_names list to make the layouts. The function uses PySimpleGUI to create a window with a "Close" button to terminate the program. The function returns when the window is closed via the "x" button or selecting the "Close" button. :return: None """

    table_data=[]
    table_data=create_data_quick(header_list)
    
    layout = make_layouts(header_list, table_data)
    # Generated the gui window to display the table
    window = sg.Window(
        "Function Metrics",
        layout,
        resizable=True,
        size=(600, 300),
        font="AndaleMono 16",
    )

    # Event Loop to process "events" and get the "values" of the inputs
    while True:
        event, values = window.read()
        # 	del values
        # End the function if the windows is closed via the "x" button or selecting the "Close" button
        if event == sg.WIN_CLOSED or event == "Close":
            break

    # Terminate the window, which will cause the function to return and the program to end
    window.close()
if __name__=="__main__":
    import numpy as np
    data=create_data_quick(header_list)
    a=np.array(data)
    print(a.shape)
    print(a)
    main()

```

## UserSettings API - Class Interface

- [UserSettings API - Class Interface|Call reference - PySimpleGUI](https://www.pysimplegui.org/en/latest/call reference/#application-wide-configuration-settings-set_options-etc)

- 

