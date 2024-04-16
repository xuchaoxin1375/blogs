[toc]

## Label

- anchor是Tkinter中用于控制组件（如标签、按钮、文本框等）在其容器（如窗口或框架）中的位置和对齐方式的一个选项。

以下是一个简单的Tkinter程序，演示了anchor选项的用法。这个程序创建了一个窗口，包含两个标签和两个按钮，其中一个标签和一个按钮使用了anchor选项。

```
import tkinter as tk

root = tk.Tk()
root.geometry("200x200")

# 创建两个标签和两个按钮
label1 = tk.Label(root, text="Label 1")
label2 = tk.Label(root, text="Label 2", anchor="w")
button1 = tk.Button(root, text="Button 1")
button2 = tk.Button(root, text="Button 2", anchor="e")

# 把标签和按钮添加到窗口中
label1.pack()
label2.pack()
button1.pack()
button2.pack()

root.mainloop()
```

在这个程序中，标签1和按钮1没有使用anchor选项，它们默认在其容器中居中对齐。标签2使用了anchor="w"选项，使其左对齐。按钮2使用了anchor="e"选项，使其右对齐。你可以尝试修改这些选项来看看它们的作用。