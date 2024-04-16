[toc]

## Graph Element@图形元素@sg.Graph

- All you math fans will enjoy this Element... and all you non-math fans will enjoy it even more.
- I've found nothing to be less fun than dealing with a graphic's coordinate system from a GUI Framework. It's always upside down from what I want. (0,0) is in the upper left hand corner.... sometimes... or was it in the lower left? In short, it's a **pain in the ass**.
- How about the ability to get your own location of (0,0) and then using those coordinates instead of what tkinter provides? This results in a very powerful capability - working in your own units, and then displaying them in an area defined in pixels.
- If you've ever been frustrated with where (0,0) is located on some surface you draw on, then fear not, your frustration ends right here. You get to draw using whatever coordinate system you want. Place (0,0) anywhere you want, including not anywhere on your Graph. You could define a Graph that's all negative numbers between -2.1 and -3.5 in the X axis and -3 to -8.2 in the Y axis

There are 3 values you'll need to supply the Graph Element. They are:

- Size of the canvas in pixels
- The lower left (x,y) coordinate of your coordinate system
- The upper right (x,y) coordinate of your coordinate system

After you supply those values you can scribble all of over your graph by creating Graph Figures. Graph Figures are created, and a Figure ID is obtained by calling:

- DrawCircle
- DrawLine
- DrawPoint
- DrawRectangle
- DrawOval
- DrawImage

You can move your figures around on the canvas by supplying the Figure ID the **x,y delta** to move. It does not move to an absolute position, but rather an offset from where the figure is now. (Use Relocate to move to a specific location)

```python
graph.MoveFigure(my_circle, 10, 10)
```

You'll also use this ID to delete individual figures you've drawn:

```python
graph.DeleteFigure(my_circle)
```

所有的数学爱好者都会喜欢这个元素……而所有不喜欢数学的人会更喜欢它。

- 我发现从GUI框架中处理图形坐标系是最不有趣的事情。它总是与我想要的相反。(0,0)在左上角……有时候……或者它是在左下角吗？简而言之，这是一个烦人的问题。
- 如果你能够获取自己的(0,0)位置，然后使用这些坐标代替tkinter提供的坐标，那会怎样呢？这将产生一种非常强大的能力——以自己的单位工作，然后在像素中定义的区域中显示它们。
- 如果你曾经对你绘制的某个表面上的(0,0)位置感到失望，那么不要担心，你的挫败感会在这里结束。你可以使用任何你想要的坐标系进行绘制。将(0,0)放在任何你想要的地方，甚至不在你的图形上。
- 你可以定义一个在X轴上的所有负数(-2.1到-3.5)，在Y轴上的所有负数(-3到-8.2)的图形。

有三个值你需要提供给Graph Element。它们是：

1. 画布的像素大小
2. 你的坐标系的左下角(x,y)坐标
3. 你的坐标系的右上角(x,y)坐标

提供了这些值之后，你可以通过创建Graph Figures在你的图形上涂鸦。通过调用以下方法，可以创建Graph Figures并获得Figure ID：

- DrawCircle
- DrawLine
- DrawPoint
- DrawRectangle
- DrawOval
- DrawImage

你可以通过提供Figure ID和x,y偏移量在画布上移动你的图形。它不会移动到绝对位置，而是从图形现在的位置移动到一个偏移量。(使用Relocate将其移动到特定位置)

- `graph.MoveFigure(my_circle, 10, 10)`
- 你还将使用这个ID来删除你绘制的单个图形：

- `graph.DeleteFigure(my_circle)`

### demos

- 在pysimplegui的demo文件下,执行:`ls -Filter *graph*.py -Recurse`查看相关实例

## Matplotlib Window With GUI Window

- [Matplotlib Window With GUI Window](https://www.pysimplegui.org/en/latest/cookbook/#matplotlib-window-with-gui-window)

### demos

- ```python
  from matplotlib import use
  import PySimpleGUI as sg
  # import PySimpleGUIQt as sg; use('qt5agg')
  import matplotlib.pyplot as plt
  
  """
      Simultaneous PySimpleGUI Window AND a Matplotlib Interactive Window
      A number of people have requested the ability to run a normal PySimpleGUI window that
      launches a MatplotLib window that is interactive with the usual Matplotlib controls.
      It turns out to be a rather simple thing to do.  The secret is to add parameter block=False to plt.show()
  """
  
  def draw_plot():
      plt.plot([0.1, 0.2, 0.5, 0.7])
      plt.show(block=False)
  
  layout = [[sg.Button('Plot'), sg.Cancel(), sg.Button('Popup')]]
  
  window = sg.Window('Have some Matplotlib....', layout)
  
  while True:
      event, values = window.read()
      if event in (sg.WIN_CLOSED, 'Cancel'):
          break
      elif event == 'Plot':
          draw_plot()
      elif event == 'Popup':
          sg.popup('Yes, your application is still running')
  window.close()
  
  ```

- 这是个最简单的例子,点击`plot`弹出一个`matplotlib`窗口,同时旧窗口还是可以操作(点击`popup`可以证明这一点,点击`cancel`将关闭所有窗口)

- 这种用法和pysimplegui本身关系不大,绘图的窗口和pysimplegui关联性不强,也没有什么技巧

- 们一般对将绘制的图嵌入到pysimplegui中比较感兴趣

## Canvas Element@`sg.Canvas`

- In my opinion, the tkinter Canvas Widget is the most powerful of the tkinter widget.
-  While I try my best to completely isolate the user from anything that is tkinter related, the Canvas Element is the one exception. 
- It enables integration with a number of other packages, often with spectacular results.
- However, there's another way to get that power and that's through the **Graph Element**, an even MORE powerful Element as it uses a Canvas that you can directly access if needed. 
- The Graph Element has a large number of drawing methods that the Canvas Element does not have. 
- Plus, if you need to, you can access the Graph Element's "Canvas" through a member variable.

To get a <u>`tkinter Canvas Widget`</u> from PySimpleGUI, follow these steps:

- Add Canvas Element to your window
- Layout your window 
- Call `window.Finalize()` - this is a critical step you must not forget 
- Find the Canvas Element by looking up using key
- Your Canvas Widget Object will be the found_element.TKCanvas

-  Draw on your canvas to your heart's content 

* Call `window.read()` - Nothing will appear on your canvas until you call Read

See `Demo_Matplotlib.py` for a Recipe you can copy.

## 动态添加组件@extend_layout🎈

### extend_layout

- Adds new rows to an existing container element inside of this window If the container is a scrollable Column, you need to also call the `contents_changed()` method

- 下面是一个示例代码，演示如何使用 `extend_layout` 方法向一个容器元素添加新行：

```python
import PySimpleGUI as sg

# 创建一个包含一个按钮的列
col = [[sg.Button('Button 1')]]

# 创建 PySimpleGUI 窗口
layout = [[sg.Column(col, scrollable=True, size=(200, 200))]]
window = sg.Window('Extend Layout Example', layout)

# 在列中添加两个新的按钮
new_buttons = [[sg.Button(f'Button {i+2}')] for i in range(2)]
window.extend_layout(window['-COLUMN-'], new_buttons)

# 更新窗口内容
window['-COLUMN-'].contents_changed()

# 处理事件循环
while True:
    event, values = window.read()
    if event == sg.WINDOW_CLOSED:
        break

# 关闭窗口
window.close()
```

- 在这个示例代码中，我们首先创建了一个包含一个按钮的列，并将其添加到一个具有滚动条的容器中。
- 然后，我们使用 `extend_layout` 方法向该列中添加两个新按钮，并调用 `contents_changed` 方法来更新窗口内容。最后，我们进入 PySimpleGUI 的事件循环，等待用户关闭窗口。
- 当用户关闭窗口时，我们调用 `close` 方法来关闭窗口。需要注意的是，如果你向一个具有滚动条的容器中添加新行，则必须调用 `contents_changed` 方法来告诉 PySimpleGUI 更新滚动条的位置。



