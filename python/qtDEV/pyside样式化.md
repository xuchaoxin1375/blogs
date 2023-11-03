[toc]

## ref

- [Styling the Widgets Application - Qt for Python](https://doc.qt.io/qtforpython/tutorials/basictutorial/widgetstyling.html)
- [Qt Style Sheets Reference | Qt Widgets 5.15.12](https://doc.qt.io/qt-5/stylesheet-reference.html)

## Widget类创建

- 创建一个简单界面(菜单+主要内容)它们是水平布局

- 主要内容包括一段文本和一个按钮,它们是垂直布局

- ```python
  import sys
  
  from PySide6.QtWidgets import QWidget, QListWidget, QListWidgetItem, QLabel, QPushButton, QVBoxLayout, QHBoxLayout,QApplication
  from PySide6.QtCore import Qt
  class Widget(QWidget):
      def __init__(self, parent=None):
          super(Widget, self).__init__(parent)
          # Widget分为两部分:菜单menu_widdget和主要内容main_widget
          # 主要内容main_widget包括一段文本和一个按钮,它们以垂直的方式布局
          _placeholder = "Placeholder Text"
  
          menu_widget = QListWidget()
  
          for i in range(10):
              # 设置item内容
              item = QListWidgetItem(f"Item {i}")
              #设置item样式
              item.setTextAlignment(Qt.AlignCenter)
              #将item添加到menu中
              menu_widget.addItem(item)
          # 第二部分为QLable
          text_widget = QLabel(_placeholder)
          # 再设置一个pushButton
          button = QPushButton("Something")
          # 设置第二部分的布局为垂直布局
          #新建垂直骨架
          content_layout = QVBoxLayout()
          # 依次将Lable和button填充进去
          content_layout.addWidget(text_widget)
          content_layout.addWidget(button)
  
          main_widget = QWidget()
          #将布局加载到main_widget中
          main_widget.setLayout(content_layout)
          # 创建水平布局
          layout = QHBoxLayout()
          # 将菜单和主内容添加到水平布局,并且设置比例为1:4
          layout.addWidget(menu_widget, 1)
          layout.addWidget(main_widget, 4)
          # 将最终的总布局绑定到Widget上
          self.setLayout(layout)
  ```

  

### 样式化文件qss

- ```css
  QListWidget {
      color: #FFFFFF;
      background-color: #33373B;
  }
  
  QListWidget::item {
      height: 50px;
  }
  
  QListWidget::item:selected {
      background-color: #2ABf9E;
  }
  
  QLabel {
      background-color: #FFFFFF;
      qproperty-alignment: AlignCenter;
  }
  
  QPushButton {
      background-color: #2ABf9E;
      padding: 20px;
      font-size: 18px;
  }
  ```

- 将上述内容保存到一个名为`style.qss`的文件中

## 引用样式并启动应用

- ```python
  if __name__ == "__main__":
      #创建一个app
      app = QApplication()
  	#实例化上方自定义的Widget类
      w = Widget()
      #将Widget实例w显示出来
      w.show()
  	# 引用编写的样式style.qss
      with open("style.qss", "r") as f:
          _style = f.read()
          # 将读取到的样式通过setStyleSheet应用到app
          app.setStyleSheet(_style)
  	#启动app
      sys.exit(app.exec())
  ```

  