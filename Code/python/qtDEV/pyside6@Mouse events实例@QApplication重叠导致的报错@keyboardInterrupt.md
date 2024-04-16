[toc]

# pyside6@Mouse events实例@QApplication重叠导致的报错@keyboardInterrupt

## 报错内容

- 在pyside图形界面应用程序开发过程中,通常只允许运行一个实例
  - 假设您重复执行程序A,那么可能会导致一些意向不到的错误
  - 并且,从python反馈的信息不容易判断错误的真正来源

## 鼠标事件演示

- 下面是一段演示pyside6的鼠标事件`mouseEvent`对象的相关api

  - ```python
    import sys
    
    from PySide6.QtCore import Qt
    from PySide6.QtWidgets import QMainWindow, QApplication, QLabel
    
    
    class MainWindow(QMainWindow):
    
        def __init__(self):
            super().__init__()
            self.label = QLabel("Click in this window")
            self.setCentralWidget(self.label)
        def mousePressEvent(self, e):
            if e.button() == Qt.LeftButton:
                # handle the left-button press in here
                self.label.setText("mousePressEvent LEFT")
    
            elif e.button() == Qt.MiddleButton:
                # handle the middle-button press in here.
                self.label.setText("mousePressEvent MIDDLE")
    
            elif e.button() == Qt.RightButton:
                # handle the right-button press in here.
                self.label.setText("mousePressEvent RIGHT")
    
        def mouseReleaseEvent(self, e):
            if e.button() == Qt.LeftButton:
                self.label.setText("mouseReleaseEvent LEFT")
    
            elif e.button() == Qt.MiddleButton:
                self.label.setText("mouseReleaseEvent MIDDLE")
    
            elif e.button() == Qt.RightButton:
                self.label.setText("mouseReleaseEvent RIGHT")
    
        def mouseDoubleClickEvent(self, e):
            if e.button() == Qt.LeftButton:
                self.label.setText("mouseDoubleClickEvent LEFT")
    
            elif e.button() == Qt.MiddleButton:
                self.label.setText("mouseDoubleClickEvent MIDDLE")
    
            elif e.button() == Qt.RightButton:
                self.label.setText("mouseDoubleClickEvent RIGHT")
    
    
    if __name__ == '__main__':
        # Create the Qt Application
        app = QApplication(sys.argv)
        # Create and show the form|
        mainwindow = MainWindow()
        mainwindow.resize(400, 400)
        mainwindow.show()
        # Run the main Qt loop
        sys.exit(app.exec())
    
    ```

- 上面的代码时可以正常工作的

  - 当我初次运行的时候没有看到弹出窗口(实际上根据电源策略,需要一点时间来启动窗口)
  - 然后我急忙有运行了一遍程序,python并没有立即给我报错
  - 此时窗口已经弹出来了,我点击了以下窗口想试试鼠标事件的处理过程,于是就给我弹出错误`KeyboardInterrupt`的提示
  - 然而我只是点击一下鼠标,并没有敲击键盘
  - 我关闭掉当前的`pyside`创建的窗口,控制台的内容被情况,同时又弹出了一个一样的到窗口
  - 我在这个窗口上试验就没有类似的报错

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/b1beb2d884bc42bab3127e556deaaabd.png)



