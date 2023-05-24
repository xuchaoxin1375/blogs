[toc]

# drawio@绘制带有latex公式的图表@示意图@流程图@白板模式whiteboard

## 使用drawio

- 本地操作:
  - 桌面客户端下载:[Release · jgraph/drawio-desktop (github.com)](https://github.com/jgraph/drawio-desktop/releases/tag/v21.2.8)
  - 插件版:drawio integration for vscode:[Draw.io Integration - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)
    - 可能有些小bug,例如数学公式模式渲染某些语法失败,比如`\boldsymbol{x}`
  - 特点
    - 个人感觉插件版的功能不如线版稳定(在数学公式渲染方面,目前来看)
    - 版本更新及时性:桌面客户端比插件及时
- 在线操作:
  - [demo.drawio - diagrams.net](https://app.diagrams.net/)
    - 可以修改文件保存位置,可以是本地也是云存储
    - 版本更新最为及时

### 小结

- 如果您的使用场景比较简单,那么随便选择一种方式即可
- 如果您希望用上最新的特性,需要编辑一些公式等复杂场景或者遇到某些bug,可以尝试用独立客户端或者在线版

## 公式编辑@Use mathematical typesetting in diagrams

### Use mathematical typesetting in diagrams

- [  Enable mathematical typesetting](https://www.drawio.com/doc/faq/math-typesetting#enable-mathematical-typesetting)
- [  Change the output format](https://www.drawio.com/doc/faq/math-typesetting#change-the-output-format)

###   Troubleshooting

- [    Blank space or extra pages](https://www.drawio.com/doc/faq/math-typesetting#blank-space-or-extra-pages)
- [    Maths is not rendered🎈](https://www.drawio.com/doc/faq/math-typesetting#maths-is-not-rendered)

- 导出问题:

  - See also: [Why text in exported SVG images may not display correctly](https://www.drawio.com/doc/faq/svg-export-text-problems)

  - Note: Math typesetting is available in draw.io for Confluence Server or Data Centre from release 10.1.4 onwards.

### 关于文本框元素

- 文本框是最常用的元素之一,特别是编辑复杂公式的时候,需要很了解文本框

- 双击文本框:在drawio中,您可以通过双击空白地方,来创建元素,其中包括`文本框`
  - 这个文本框的大小是根据您的输入自动调整大小,限制比较多
  - 而且,部分场景下,当您双击这类元素,无法修改文本,而是会类似于浏览器中全选页面内容的效果(这是令人沮丧的情况)
- 独立文本框:从侧边栏拖入的文本框是可以自由调整大小的,推荐使用这种方式创建文本看
- 幸运的是,我们可以通过修改属性来更改一些默认的行为:
  - 比如，我们选择`resizable`使得双击创建的文本框也能可以允许调整框的大小
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/db72f33f7f26429288fc0e12edcfc0f8.png)

### 公式渲染问题🎈

#### Maths is not rendered

If you find your maths equation is not rendered correctly, the text may be hiding some HTML formatting tags.

- Select the text, then click `</>` in the toolbar to expose hidden HTML tags.
- Delete any extra HTML tags, and re-enable *Mathematical Typesetting* in the menu.
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/0d230151e28340eea43f0bd5a4084971.png)

- 也就是说,如果您的公式是对的(语法正确且可渲染的,比如在markdown中可以正常渲染),但在drawio中却无法正确渲染输出,极大可能是因为这段文本在drawio中包含一些被隐藏起来的HTML标签

- 请选中出现渲染问题的公式文本,菜单栏上的按钮将会发生变化,点击`</>`按钮,可能会出现多余的html标签

- 如果确实出现`</>`做类似的标签,请:

  - 确保**公式模式**(数学排版)启用
  - <u>双击(全选)文本框内容(在文本框处于编辑模式的情况下)</u>
  - <u>点击工具栏的HTML按钮</u>
  - <u>粘贴(`ctrl+v`)</u>
  - 关闭HTML模式(或者点击一下空白区域也可以)
  - 检测修复结果

- 例:

  - 源文本:

    - ```html
      $$
      D={(\boldsymbol{z}_i,y_i)}^{m}_{i=1}
      $$
      ```

      

  - 粘贴到drawio中的文本框元素,发现公式没有被渲染(如果正确渲染就跳过),简称html源码发现:

    ```html
    <div>$$</div><div>D={(\boldsymbol{z}_i,y_i)}^{m}_{i=1}</div><div>$$</div>
    ```

  - 可以看到,内容包含了许多多余的东西,说明粘贴的内容是带有格式的,我们需要清楚格式

    - 清楚方式如同上面介绍的,带有下划线的三个步骤

  - $$D'=\set{(\boldsymbol{z}_i,y_i)}^{m}_{i=1}$$

## 模式切换@diagram@whiteboard

### 刷新操作

- 以下的模式切换需要刷新生效
- 对于在线版(网页版),直接刷新页面即可(`F5`)
- 对于客户端,则需要关闭后重新打开(注意保存修改后再重新软件)

### 使用白板模式(草图模式)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/4f83bf4e001a4b25a7daddca644d907b.png)

### 切换回普通模式

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/1ba7eb07a3d445bbbc9ca490e6c74705.png)





