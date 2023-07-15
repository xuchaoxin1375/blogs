[toc]

## refs

- [Insert or add tab stops - Microsoft Support](https://support.microsoft.com/en-us/office/insert-or-add-tab-stops-06969e0f-2c81-4fe0-8df5-88f18087a8e0)
- [Using the ruler in Word - Microsoft Support](https://support.microsoft.com/en-us/office/using-the-ruler-in-word-775014ca-7bb9-4b75-ba19-4478c4a836d1)

## 制表位(tab stop)

- 在Microsoft Word中，制表符（Tab）是一种用于控制文本对齐和缩进的功能。制表符可以帮助您在文档中创建整齐的布局，如制作目录、制作表格或对齐文本等。
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/f05edb08160140e0999524ef3e3de3fa.png)

### 制表位类型

Word中有四种主要的制表符：

1. **左对齐制表位**（Left-aligned tab）：在这个制表符位置，文本从左侧开始，并向右扩展。这是默认的制表符类型。左对齐制表符的图标类似一个向右的箭头。
2. **居中对齐制表位**（Center-aligned tab）：在这个制表符位置，文本以制表符为中心，向左右两侧扩展。居中对齐制表符的图标类似一个向左右两侧的箭头。
3. **右对齐制表位**（Right-aligned tab）：在这个制表符位置，文本以制表符为右侧边界，向左扩展。右对齐制表符的图标类似一个向左的箭头。
4. **小数对齐制表位**（Decimal-aligned tab）：在这个制表符位置，小数点位于制表符位置，数字根据小数点对齐。这对于对齐数值数据特别有用。小数对齐制表符的图标类似一个上下箭头，中间有一条竖线。

附：

- ![Tab image](https://img-blog.csdnimg.cn/img_convert/55cdef4ef02d00ab978cc6ed3a72e37f.gif) A **Left** tab stop sets the left end of the text line. As you type, the text fills toward the right.
- ![Center Tab button](https://img-blog.csdnimg.cn/img_convert/96a8b838d6e26eb15cc669bd0537e40b.gif) A **Center** tab stop sets the position at the middle of the text line. As you type, the text centers on this position.
- ![Tab image](https://img-blog.csdnimg.cn/img_convert/c1d66f65e561d5377e1d7420448d7d40.gif) A **Right** tab stop sets the right end of the text line. As you type, the text fills toward the left.
- ![Tab image](https://img-blog.csdnimg.cn/img_convert/e60bc8e82975233b251143cf0c26e162.gif) A **Decimal** tab stop aligns numbers around a decimal point. Without regard to the number of digits, the decimal point remains in the same position. See [Use decimal tabs to line up numbers with decimal points](https://support.microsoft.com/en-us/office/use-decimal-tabs-to-line-up-numbers-with-decimal-points-9d0fcf4d-43e8-4eb1-a1af-632b9e7cd538).
- ![Bar Tab button](https://img-blog.csdnimg.cn/img_convert/c68599f58233ac7ec38e98e8cc24e852.gif) A **Bar** tab stop doesn't position text. It inserts **a vertical bar** at the tab position. Unlike other tabs, the bar tab is added to the text as soon as you click the ruler. If you don't clear the bar tab stop before you print your document, the vertical line is printed.

## 制作对其的下划线填空表单👺

- ref:[word对齐神器，制表位应用 bilibili](https://www.bilibili.com/video/BV1Z3411j7a2/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)
- [word文档对齐文字超级高效的两个技巧，快速搞定文档对齐难题bilibili](https://www.bilibili.com/video/BV1iW4y147c2/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

- 测试数据：

  - 带`:`

    - ```text
      字段一:	
      第二个字段:	
      再看字段3的情况:	
      先选中最长的行:	
      
      ```

  - 不带`:`

    - ```text
      字段一
      第二个字段
      再看字段3的情况
      先选中最长的行	
      
      ```

      

- 下划线（填空线）末端对其：

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/63fcd60bbe9c44e482c40cade89fbc4e.png)
  - 首先选中需要制作填空线的内容
  - 点击标尺上的数字附近下位置，得到一个标记（不同类型的制表位标记不同）
  - 双击标记，对标记属性进行设置
  - 将标记的对齐属性设置为居左（left)
  - 将前导符设置为第4个选项`___`（如过是制作目录，可以选择`····`，相似的选项有2,3,5）
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/03aa2b26984442a090546d6b3469639a.png)
  - 回到段落，<u>为每一行的末尾添加一个tab键</u>即可看到效果

- 上面的提到的教程不包含字段对齐，对齐后的效果是

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/4b0b725de5ae46689222b645c664c728.png)
  - 先根据标尺，参考并选定一个合适的字段长度，比如10字符（也可以根据最长的字段的长度来取一个紧凑的值）
  - 然后点击`开始（home)->段落功能区中的文本对齐`
    - ![在这里插入图片描述](https://img-blog.csdnimg.cn/2ab34180ba8e498d97fca30586278ef7.png)
    - 方法1：逐行设置
      - 然后逐行选中需要对齐的文字，按下`F4`，将对齐第一行的操作自动的在第2行执行（注意冒号一般是不选中的）
      - ![在这里插入图片描述](https://img-blog.csdnimg.cn/e7a958958cbe4e88b684d932ffc772f5.png)
    - 方法2：借助`ctrl`键和鼠标划选各行的字段（避开`:`)
      - 然后根据方法1中所示的设置文本对齐，可以同时将选中的字段调整为一样长

### 利用前导符代替下划线制作待填空下划线

## 制表位对其列数据模拟简单表格

- [Word中的样式与制表位 bilibili](https://www.bilibili.com/video/BV1oK4y147AC/?spm_id_from=333.337.search-card.all.click&vd_source=c0a3b17a665cd2d32431213df84cd3ce)

### 测试数据

- ```text
  发票号	销售部门	销售人员	工单号	ERPCO号	所属区域	产品类别
  H00012769	三科	刘辉	A12-086	C014673-004	苏州	宠物用品·
  H00012769	三科	刘辉	A12-087	C014673-005	苏州	宠物用品
  H00012769	三科	刘辉	A12-088	C014673-006	苏州	宠物用品·
  H00012769	三科	刘辉	A12-089	C014673-007	苏州	宠物用品
  H00012769	三科	刘辉	A12-090	C014673-008	苏州	宠物用品·
  
  
  ```

  

### 设置引线

- 通过制表符生成的不可见但起对其左右的参考线（数据列分割线）（或称制表引线，简称**引线**，不可见）

- 可以使用段落设置中的制表（tab)进行设置

- 也可以使用标尺来设置

- 前一种方法对于引线调整精度较高时比较有用，通过各引线对应的输入刻度，可以批量设置

  - 每输入一个引线刻度，在点击一下设置，就可以继续设置下一个引线刻度

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/e61047207a3a481d91cf3305e55b8067.png)

### 使用标尺设置

- 使用制表符可以模拟简单的无边框表格效果，但是对于有3列以上的表格形数据还是直接使用表格排版
- 如果您的数据以固定的分隔符分割每列数据（例如逗号或分号或制表符tab),如果是tab分割最好办
  - 首先决定合适的制表位类型，通常是居左或居中（如果选择不恰当的制表位类型，会达不到预期效果）
  - 打开视图中的标尺
  - <u>鼠标选中需要调整位对齐列的数据（段落相关内容）👺</u>
  - 鼠标单击标尺上刻度数值的**下方**，可以在对应刻度数值留下记号
  - 如果数据包括3列及以上，则需要2个及以上的制表符才能对齐第2，3，... 列
  - 此时要在标尺上根据割裂数据的长度大致的估算各列的引线，列数据的各对齐会依赖于引线刻度），分别位这些分割线在标尺数值下各点击一下以添加引线
  - 如果对预估的引线位置不满意，可以拖动标尺上对应的引线标记来调整对其位置(拖动的时候要水平拖，因为向下拖相当于删除该制表引线)
  - 通过双击也可以修改标尺上引线的属性，比如从居左对齐改为剧中对齐（在调整之前，要先选中相关段落内容，确保各行均能对齐)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/5818850d1bbb484b9eda38e2013f31ba.png)

## FAQ

- 如果使用制表位没有按预期方式达到效果，考虑是多个引线刻度由于太过靠近，相互重叠。此时需要调整引线的刻度位置

  - 如果不确定，建议将数据复制出来，粘贴倒一个新建word中（注意要以无格式粘贴，或者粘贴后用格式清除）
  - 然后进行对齐排版，将排版好的结果复制粘贴回原文档

- 如果表格数据较宽，则考虑使用将文本字体调小，或者使用更具表格而不是简陋的制表符来完成整齐的表格排版任务

  



