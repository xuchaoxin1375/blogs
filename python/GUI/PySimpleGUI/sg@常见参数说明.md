[toc]

## 常见参数

PySimpleGUI 中常用的参数说明：

1. `key`：指定 GUI 元素的唯一标识符。
2. `text`：指定 GUI 元素的文本或标签。
3. `size`：指定 GUI 元素的大小。
4. `font`：指定 GUI 元素的字体。
5. `button_color`：指定按钮的颜色。
6. `image_filename`：指定图像文件的文件名。
7. `image_size`：指定图像的大小。
8. `tooltip`：指定一个提示语，通常用于描述 GUI 元素的含义或用途。
9. `disabled`：指定一个 GUI 元素是否禁用。
10. `visible`：指定一个 GUI 元素是否可见。
11. `background_color`：指定 GUI 元素的背景色。
12. `text_color`：指定 GUI 元素的文本颜色。
13. `auto_size_text`：指定文本区域是否自适应大小。
14. `justification`：指定文本在 GUI 元素中的对齐方式。
15. `pad`：指定 GUI 元素的内边距。
16. `default_value`：指定 GUI 元素的默认值。
17. `input_text_color`：指定输入框中文本的颜色。
18. `input_background_color`：指定输入框的背景色。
19. `input_text_size`：指定输入框中文本的大小。
20. `progress_bar_color`：指定进度条的颜色。
21. `progress_bar_border_width`：指定进度条边框的宽度。
22. `slider_range`：指定滑块的取值范围。
23. `slider_orientation`：指定滑块的方向，水平或垂直。
24. `slider_border_width`：指定滑块边框的宽度。
25. `checkbox_text`：指定复选框后面的文本。
26. `checkbox_default`：指定复选框是否默认选中。
27. `radio_text`：指定单选框后面的文本。
28. `radio_default`：指定单选框是否默认选中。
29. `listbox_size`：指定列表框的大小。
30. `listbox_select_mode`：指定列表框的选择模式，单选或多选。

### relief

- "Relief" 可以翻译为 "浮雕效果" 或者 "边框样式"，通常用于指定 GUI 元素周围的边框或者阴影效果。在 PySimpleGUI 中，`relief` 参数用于指定 GUI 元素的边框样式。

- 在 PySimpleGUI 中，参数 `relief` 用于指定文本周围的边框样式。可选的值与进度条的边框样式相同，应该是以 "RELIEF_" 开头的常量，包括以下几种：

  - RELIEF_RAISED：凸起的边框。
  - RELIEF_SUNKEN：凹陷的边框。
  - RELIEF_FLAT：无边框。
  - RELIEF_RIDGE：两侧有凸起的边框。
  - RELIEF_GROOVE：两侧有凹陷的边框。
  - RELIEF_SOLID：实线边框。

  通过设置 `relief` 参数，可以让文本看起来更加突出，方便用户的视觉识别。

- 下面的例子为您展示各种relife效果

  ```python
  import PySimpleGUI as sg
  
  sg.theme('LightGrey1')
  
  def make_text(text, relief):
      return sg.Text(text, relief=relief, size=(10, 2))
  
  layout = [
      [make_text('Raised', sg.RELIEF_RAISED), make_text('Sunken', sg.RELIEF_SUNKEN), make_text('Flat', sg.RELIEF_FLAT)],
      [make_text('Ridge', sg.RELIEF_RIDGE), make_text('Groove', sg.RELIEF_GROOVE), make_text('Solid', sg.RELIEF_SOLID)]
  ]
  
  window = sg.Window('Relief Demo', layout)
  
  while True:
      event, values = window.read()
      if event == sg.WIN_CLOSED:
          break
  
  window.close()
  ```


### font

- [font|PySimpleGUI](https://www.pysimplegui.org/en/latest/#font)

- Specifies the font family, size, and style. Font families on Windows include: * Arial * Courier * Comic, * Fixedsys * Times * Verdana * Helvetica (the default I think)

  The fonts will vary from system to system, however, Tk 8.0 automatically maps Courier, Helvetica and Times to their corresponding native family names on all platforms. Also, font families cannot cause a font specification to fail on Tk 8.0 and greater.

  If you wish to leave the font family set to the default, you can put anything not a font name as the family. The PySimpleGUI Demo programs and documentation use the family 'Any' to demonstrate this fact.. You could use "default" if that's more clear to you.

  There are 2 formats that can be used to specify a font... a string, and a tuple Tuple - (family, size, styles) String - "Family Size Styles"

  To specify an underlined, Helvetica font with a size of 15 the values: ('Helvetica', 15, 'underline italics') 'Helvetica 15 underline italics'

  **Font Style - Valid font styles include:**

  - italic
  - roman
  - bold
  - normal
  - underline
  - overstrike

  An example with many styles is:

  ```python
  font='Courier 12 italic bold underline overstrike'
  ```

  The same styles can be used with the tuple format for fonts.

- 指定字体系列、大小和样式。Windows 上的字体系列包括：* Arial * Courier * Comic * Fixedsys * Times * Verdana * Helvetica（我认为是默认字体）。

- 字体会因系统而异，但 Tk 8.0 会自动将 Courier、Helvetica 和 Times 在所有平台上映射到它们相应的本地系列名称。此外，字体系列不能使字体规范在 Tk 8.0 及更高版本上失败。

  如果您希望将字体系列设置为默认值，则可以将任何非字体名称的内容作为系列。PySimpleGUI 演示程序和文档使用系列“Any”来证明这一事实。如果更清晰，您可以使用“default”。

  有两种格式可用于指定字体……字符串和元组 元组 - （系列，大小，样式）字符串 - “系列 大小 样式”

  要指定带下划线的 Helvetica 字体，大小为 15，可以使用以下值：（'Helvetica'，15，'underline italics'）'Helvetica 15 underline italics'

- 字体样式 - 有效的字体样式包括：

  - 斜体
  - 罗马体
  - 粗体
  - 正常
  - 下划线
  - 删除线

- 一个具有多种样式的示例是：

  - `font='Courier 12 italic bold underline overstrike'`
  - 可见style部分可以叠加,例如使得斜体和粗体效果同时起效
  - 元组格式的字体也可以使用相同的样式。

#### 常用字体介绍

- **Arial** 字体是一种无衬线字体（没有额外的装饰线条），由 Monotype 公司于1982年制作，并在 Windows 操作系统中成为了默认字体之一。它的字母间距相对较窄，具有现代感和简洁感，适合用于大段文字和标题。
- Courier 字体是一种等宽字体，最初由美国 IBM 公司在1956年推出。它的字母形状和排列方式都非常规整，每个字符都有相同的宽度和间距。Courier 字体被广泛用于计算机程序代码、电报、电传等需要等宽字体的场合，因为它使得代码和文本更易于对齐和排版。Courier 字体是一种等宽字体（所有字符宽度相同），最初由美国 IBM 公司在1956年推出。该字体的设计灵感来自于打字机使用的字体，因此它的字母形状和排列方式都非常规整，每个字符都有相同的宽度和间距。Courier 字体被广泛用于计算机程序代码、电报、电传等需要等宽字体的场合，因为它使得代码和文本更易于对齐和排版。Courier 字体还有一种变体叫做 Courier New，它是在1988年由 Monotype 公司重新设计的，添加了一些额外的字符和细节，并在 Windows 操作系统中成为了默认的等宽字体之一。
- Comic 字体是一种手写风格的字体，由 Monotype 公司在1995年推出。它的字母形状看起来像是手写的，带有一些装饰性的线条和弯曲，适合用于漫画、卡通、广告等需要趣味性和轻松感的场合。
- Fixedsys 字体是一种等宽字体，由 Microsoft 公司在1991年推出。它的字母形状和排列方式类似于 Courier 字体，但字母间距略微宽一些。Fixedsys 字体被广泛用于计算机程序代码和系统界面中，因为它使得文本和图形更易于对齐和排版。
- Times 字体是一种衬线字体（具有额外的装饰线条），由 The Times of London 报纸在1931年委托设计师 Stanley Morison 制作。它的字母形状和排列方式相对规整，适合用于书籍、杂志、报纸等需要良好排版和阅读体验的场合。
- Verdana 字体是一种无衬线字体，由 Microsoft 公司在1996年推出。它的字母形状相对圆润，字母间距较宽，适合用于网络页面和数字屏幕上，因为它在小字号下也能保持良好的可读性。
- Helvetica 字体是一种无衬线字体，由瑞士制造商 Haas Type Foundry 在1957年推出。它的字母形状和排列方式相对规整，适合用于海报、标志、广告等需要简洁、现代感的场合。Helvetica 字体被广泛应用于许多品牌和设计作品中，被誉为设计师必备字体之一。

#### demo

- ```python
  ##!/usr/bin/env python
  import PySimpleGUI as sg
  import SG.constants.beauty as bt
  """
      App that shows "how fonts work in PySimpleGUI".
  """
  
  layout = [
      [sg.Text("This is my sample text", size=(20, 1), key="-text-")],
      [
          sg.CB("Bold", key="-bold-", enable_events=True),
          sg.CB("Italics", key="-italics-", enable_events=True),
          sg.CB("Underline", key="-underline-", enable_events=True),
      ],
          [sg.Text("Font size:")],
      [
      
          sg.Slider(
              (6, 50),
              default_value=12,
              # size=(14, 20),
              size=bt.slider_size,
              orientation="h",
              key="-slider-",
              enable_events=True,
          ),
      ],
      [sg.Text("Font string = "), sg.Text("", size=(25, 1), key="-fontstring-")],
      [sg.Button("Exit")],
  ]
  
  
  def main():
      window = sg.Window("Font string builder", layout)
  
      text_elem = window["-text-"]
      while True:  # Event Loop
          event, values = window.read()
          if event in (sg.WIN_CLOSED, "Exit"):
              break
          
          font_string = "Helvitica "
          font_string += str(int(values["-slider-"]))
          if values["-bold-"]:
              font_string += " bold"
          if values["-italics-"]:
              font_string += " italic"
          if values["-underline-"]:
              font_string += " underline"
          text_elem.update(font=font_string)
          window["-fontstring-"].update('"' + font_string + '"')
          print(event, values)
  
      window.close()
  if __name__=="__main__":
      main()
  
  ```

  







