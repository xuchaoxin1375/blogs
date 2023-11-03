

[toc]

# word表格

## ref

- [拆分表格 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/拆分表格-d231a898-6983-4ef8-acb0-797c7f2b0c45)
- [调整表格、列或行的大小 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/调整表格-列或行的大小-9340d478-21be-4392-81cf-488f7bbd6715)
- [word表格美化技巧：如何统一改变表格的样式 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/266351000)

## 常用操作

| pictures                                                     | caption                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/0426cf874f6b48fdb0e5b8fa7247e317.png) | 选中表格                                                     |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/faae78f9b39c4e5b93e688aed40f5c53.png) | 选中表格布局border组的小箭头:`borders and shading`设置表格框线 |
| ![image-20230501212941771](D:\repos\blogs\softwares\office@wps\word\assets\image-20230501212941771.png) | 区分两个`布局`                                               |

## 表格单元格合并vs线条擦除

- [将表格单元格合并为一个单元格 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/将表格单元格合并为一个单元格-689227b5-c73f-43e8-bece-ac564f60b9eb)
- 单元格合并和线条擦除作用不同,通常单元格合并更加常用,鼠标选中(拖选)想要合并的连续(相邻)单元格进行合并(cell merge)
- 两者最明显的差别在于单元格内容居中的时候表现出不同的行为

## 处理跨页表格

- 长表格跨页:
  - [Format a table|Control where a table is divided - Microsoft Support](https://support.microsoft.com/en-us/office/format-a-table-e6e77bc6-1f4e-467e-b818-2e2acc488006#ID0EFDBD)
- 强制跨页:
  - [Format a table|Force a table to break across pages at a particular row - Microsoft Support](https://support.microsoft.com/en-us/office/format-a-table-e6e77bc6-1f4e-467e-b818-2e2acc488006#ID0EFBBD)

## 表格属性设置

- [Set or change table properties - Microsoft Support](https://support.microsoft.com/en-us/office/set-or-change-table-properties-3237de89-b287-4379-8e0c-86d94873b2e0#__toc1)
- [设置或更改表格属性 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/设置或更改表格属性-3237de89-b287-4379-8e0c-86d94873b2e0)

### 表格的对齐

| pictures                                                     | notes                                                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/e211db63ded64bb6b14d259dd59c038d.png) | 表格属性设置窗口(`Table Properties)`<br />`Table`选项卡:<br />1. 这里的对齐是在表格指水平宽度内,整个表格的对齐,而不是单元格内内容对齐;<br /> |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/f9308d7e57a14e529d6cc655f5f693fa.png) | `Cell`选项卡中可以设置表格单元格内容的对齐<br />不幸的是,该选项卡只提供了竖直方向上的对齐,而没有水平方向上对齐的选项 |
| ![在这里插入图片描述](https://img-blog.csdnimg.cn/a4f465286a934491817d4753f672f78d.png) | 想要调整单元格内容在水平方向的对齐,需要到:<br />`table tool`->`layout`->`Align Center`中调节 |

### 表格内文本的样式和对齐

- [Table options - Microsoft Support](https://support.microsoft.com/en-us/office/table-options-be966c8b-6fe7-49c9-927a-ac976f2d1cfa?ns=winword&version=19&syslcid=1033&uilcid=1033&appver=zwd190&helpid=547&ui=en-us&rs=en-us&ad=us)

- | pictures                                                     | notes                                                 |
  | ------------------------------------------------------------ | ----------------------------------------------------- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/88fe718208db4f3da414170ce8d23c4b.png) | 左侧表格显示的是一个单元格内对齐的9中位置             |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/aad003bce6014949bdb6be9e49bc06b1.png) | 取消单元格内的边距设置,以便完全居中单元格内容可以实现 |

- 推荐做法是为表格单元格的文本设置一个专门的样式,通常,这个样式<u>不要有缩进</u>

- 如果想要将表格内容居中(位于单元格中心),表格属性的设置中margin也应该设置0

  

## 表格设计

- [Format a table - Microsoft Support](https://support.microsoft.com/en-us/office/format-a-table-e6e77bc6-1f4e-467e-b818-2e2acc488006)
- [Customize or create new styles - Microsoft Support](https://support.microsoft.com/en-us/office/customize-or-create-new-styles-d38d6e47-f6fc-48eb-a607-1eb120dec563?ns=winword&version=19&syslcid=1033&uilcid=1033&appver=zwd190&helpid=348&ui=en-us&rs=en-us&ad=us)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/014aaebf525d4159bbd14a7e489cfd03.png)

### 三线表设计

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/7dba1adb32a444f7ad26a55682914163.png)

- 名字随意取(可以叫中文三线表(我简写为TLT))
- 主要是Formatting下的`Apply formatting to`
  - Whole table
    - 可以设置三线表的第一条线和第三条线
    - 线条样式可以设置的粗一些
  - Header line
    - 可以设置第二条线
    - 线条样式可以改细一些
- Note:上述设置一遍可能不符合预期,可以再设置一遍
  - 线条粗细可能和第二条线可能都要设置两边才有效,应该是软件的bug
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/66d26098a7924d4fb3874f7e900e2561.png)

## 页面设置（page setup ）

- [更改页边距 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/更改页边距-da21a474-99d8-4e54-b12d-a8a14ea7ce02)

## 批量选中表格🎈

- 使用插件:[Quickly select all tables in a Word document (extendoffice.com)](https://www.extendoffice.com/product/kutools-for-word/word-select-all-tables.html)
  - 该插件是一个付费插件,但有试用期
- 使用宏,下一章介绍
  - [How can I select all tables in a document. (microsoft.com)](https://social.technet.microsoft.com/Forums/ie/en-US/4f0164f7-9379-47c7-ae81-3316d3c6186e/how-can-i-select-all-tables-in-a-document?forum=officeitproprevious)
  - [Microsoft Word: How to edit the properties of multiple tables - Super User](https://superuser.com/questions/1232065/microsoft-word-how-to-edit-the-properties-of-multiple-tables)

### 选中所有表格

- 简洁版本

  ```vb
  Sub selecttables()
   Dim mytable As Table
   Application.ScreenUpdating = False
   For Each mytable In ActiveDocument.Tables
   mytable.Range.Editors.Add wdEditorEveryone
   Next
   ActiveDocument.SelectAllEditableRanges (wdEditorEveryone)
   ActiveDocument.DeleteAllEditableRanges (wdEditorEveryone)
   Application.ScreenUpdating = True
  End Sub
  ```

- 下面是带注释的版本

  ```vb
  
  ' Subroutine to select all tables in the active document and add editing permission to everyone.
  Sub selecttables()
      ' Declare a variable to hold the current table being processed.
      Dim mytable As Table
  
      ' Disable screen updates to improve performance.
      Application.ScreenUpdating = False
  
      ' Loop through all tables in the document.
      For Each mytable In ActiveDocument.Tables
          ' Add editing permission to everyone for the table.
          mytable.Range.Editors.Add wdEditorEveryone
      Next
  
      ' Select all editable ranges for everyone in the document.
      ActiveDocument.SelectAllEditableRanges (wdEditorEveryone)
  
      ' Delete all editable ranges for everyone in the document.
      ActiveDocument.DeleteAllEditableRanges (wdEditorEveryone)
  
      ' Enable screen updates again.
      Application.ScreenUpdating = True
  End Sub
  ```

#### 临时运行

- 将上述代码片段之一复制
- 在word中打开vb编辑器(快捷键位`alt+F11`)
- 新建文件,粘贴并点击vb编辑器上的运行按钮

#### 编辑已有的宏

- 可以根据指引`alt+F8`创建一个宏,或者编辑已有的宏,注意过滤功能(`Macros in`)

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/e8e355101194411a85b53df454a810bb.png)

    

## 录制操作宏🎈

- [Create or run a macro - Microsoft Support](https://support.microsoft.com/en-us/office/create-or-run-a-macro-c6b99036-905c-49a6-818a-dfb98b7c3c9c)

- [创建或运行宏 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/创建或运行宏-c6b99036-905c-49a6-818a-dfb98b7c3c9c)



#  关于VBA宏

- [Word | Microsoft Learn](https://learn.microsoft.com/en-us/office/client-developer/word/word-home?redirectedfrom=MSDN)

- [Office Visual Basic for Applications (VBA) 参考 | Microsoft Learn](https://learn.microsoft.com/zh-cn/office/vba/api/overview/)

- [Office VBA 入门 | Microsoft Docs](https://docs.microsoft.com/zh-cn/office/vba/library-reference/concepts/getting-started-with-vba-in-office)

## VBA 和 VB

Visual Basic (VB) 和 Visual Basic for Applications (VBA) 都是由 Microsoft 开发的编程语言。它们之间的区别如下：

1. 目标应用程序：VB 是一种独立的编程语言，可以用于开发 Windows 应用程序，包括桌面应用程序、Web 应用程序和移动应用程序。VBA 是一种宏语言，专门用于自动化 Microsoft Office 应用程序，例如 Excel、Word、PowerPoint 等。
2. 开发平台：VB 可以使用 Microsoft Visual Studio 和其他集成开发环境 (IDE) 进行开发。VBA 只能在 Microsoft Office 应用程序内部使用。
3. 语言特性：VB 具有更复杂的语法和更多的编程特性，例如多线程支持、面向对象编程等。VBA 的语法更为简单，主要用于处理 Office 文档和自动化任务。
4. 应用场景：VB 适用于需要开发独立的应用程序的情况，例如开发桌面软件、Web 应用程序或移动应用程序。VBA 适用于自动化处理 Microsoft Office 应用程序的情况，例如自动执行重复性任务、自定义 Office 应用程序的功能等。

总的来说，VB 和 VBA 都是由 Microsoft 开发的编程语言，它们的应用场景和目标应用程序不同。VB 适用于独立应用程序的开发，而 VBA 适用于自动化处理 Microsoft Office 应用程序的场景。

## VBA

### 使用代码让应用程序完成任务

### Using code to make applications do things

You might think that writing code is mysterious or difficult, but the basic principles use every-day reasoning and are quite accessible. Microsoft Office applications are created in such a way that they expose things called objects that can receive instructions, in much the same way that a phone is designed with buttons that you use to interact with the phone.

 When you press a button, the phone recognizes the instruction and includes the corresponding number in the sequence that you are dialing. 

In programming, you interact with the application by sending instructions to various objects in the application. These objects are expansive, but they have their limits. They can only do what they are designed to do, and they will only do what you instruct them to do.

For example, consider the user who opens a document in Word, makes a few changes, saves the document, and then closes it. In the world of VBA programming, Word exposes a Document object. By using VBA code, you can instruct the Document object to do things such as Open, Save, or Close.

The following section discusses how objects are organized and described.

您可能认为编写代码是神秘或困难的，但基本原理使用日常推理，相当容易理解。Microsoft Office应用程序被创建成一种方式，它们公开了被称为对象的东西，可以接收指令，就像手机设计有按钮，您用它们与手机交互一样。当您按下按钮时，手机会识别指令，并在您拨号序列中包含相应的号码。

在编程中，您通过向应用程序中的各种对象发送指令来与应用程序交互。这些对象很广泛，但它们有其限制。它们只能做它们被设计为做的事情，并且只会做您指示它们做的事情。

例如，考虑用户在Word中打开文档，进行了一些更改，保存了文档，然后关闭了文档。在VBA编程的世界中，Word公开了一个Document对象。通过使用VBA代码，您可以指示Document对象执行诸如打开、保存或关闭等操作。

下面的部分讨论了对象如何组织和描述。

### The Object Model

Developers organize programming objects in a hierarchy, and that hierarchy is called <u>the object model of the application</u>. Word, for example, has <u>a top-level **Application** object</u> that contains <u>a **Document** object</u>. 

The Document object contains **Paragraph** objects and so on. 

Object models roughly mirror what you see in the user interface. They are a conceptual map of the application and its capabilities.

The **definition** of an object is called a **class**, so you might see these two terms used **<u>interchangeably</u>**. 

Technically, a **class** is the description or template that is used to create, or instantiate, an **object**.

Once an object exists, you can <u>manipulate</u> it by setting its properties and calling its methods. 

If you think of the object as a noun, the **properties** are the adjectives that describe the noun and the **methods** are the verbs that animate the noun. 

Changing a **property** changes some **quality** of appearance or behavior of the **object**. Calling one of the object methods causes the object to perform some action.

The VBA code in this article runs against <u>an open Office application</u> where many of the **objects** that the code manipulates are already <u>up and running</u>; 

- for example, the Application itself, the Worksheet in Excel, the Document in Word, the Presentation in PowerPoint, the Explorer and Folder objects in Outlook. 
- Once you know the basic layout of the object model and some key properties of the Application that give access to its current **state**, you can start to extend and manipulate that Office application with VBA in Office.

开发人员将编程对象组织成层次结构，这个层次结构称为应用程序的对象模型。例如，Word有一个顶级的Application对象，其中包含一个Document对象。Document对象包含Paragraph对象等。对象模型大致反映了您在用户界面中看到的内容。它们是应用程序及其功能的概念地图。

对象的定义称为类，因此您可能会看到这两个术语交替使用。从技术上讲，类是用于创建或实例化对象的描述或模板。

一旦一个对象存在，您可以通过设置其属性和调用其方法来操纵它。如果您将对象看作是名词，则属性是描述名词的形容词，方法是使名词活跃的动词。更改属性会更改对象的某些外观或行为质量。调用对象的其中一个方法会导致对象执行某些操作。

本文中的VBA代码针对已打开的Office应用程序运行，代码操纵的许多对象已经启动运行；例如，应用程序本身，在Excel中的Worksheet，在Word中的Document，在PowerPoint中的Presentation，在Outlook中的Explorer和Folder对象。一旦您了解了对象模型的基本布局和访问其当前状态的一些关键属性，您就可以开始使用Office中的VBA扩展和操纵该应用程序。

### Methods

- In Word, for example, you can change the properties and invoke the methods of the current Word document by using the **ActiveDocument** property of the **Application** object. 
- This **ActiveDocument** property returns a reference to the **Document** object that is currently active in the Word application. "Returns a reference to" means "gives you access to."

- The following code does exactly what it says; that is, it saves the active document in the application.



```vb
Application.ActiveDocument.Save
```

- Read the code from left to right, "In this Application, with the Document referenced by ActiveDocument, invoke the **Save** method." Be aware that **Save** is the simplest form of method; it does not require any detailed instructions from you. You instruct a **Document** object to **Save** and it does not require any more input from you.

- If a method requires more **information**, those details are called **parameters**. The following code runs the **SaveAs** method, which requires a new name for the file.

VB

```vb
Application.ActiveDocument.SaveAs ("New Document Name.docx")
```

Values listed in parentheses after a method name are the parameters. Here, the new name for the file is a parameter for the **SaveAs** method.

### Properties

You use the same syntax to set a property that you use to read a property. The following code executes a method to select cell A1 in Excel and then to set a property to put something in that cell.您使用相同的语法来设置属性，就像读取属性一样。以下代码执行一个方法，在Excel中选择单元格A1，然后设置一个属性，将某些内容放入该单元格。

- ```vb
      Application.ActiveSheet.Range("A1").Select
      Application.Selection.Value = "Hello World"
  ```

- The first **challenge** in VBA programming is to **get a feeling** for the object model of each Office application and to read the object, method, and property syntax. 
- The object models are similar in all Office applications, but each is specific to the kind of documents and objects that it manipulates.

- In the first line of the code snippet, there is the **Application** object, Excel this time, and then the **ActiveSheet**, which provides access to the active worksheet.
- After that is a term not as familiar, `Range`, which means "define a range of cells in this way." The code instructs **Range** to create itself with just A1 as its defined set of cells. 
- In other words, the first line of code defines an object, the Range, and runs a method against it to select it.
- The result is automatically stored in another **property** of the **Application** called **Selection**.
  - The second line of code sets the **Value** property of **Selection** to the text "Hello World", and that value appears in cell A1.

The simplest VBA code that you write might simply gain access to objects in the Office application that you are working with and set properties. For example, you could get access to the rows in a table in Word and change their formatting in your VBA script.

That sounds simple, but it can be incredibly useful; once you can write that code, you can **harness** (利用)all of the power of programming to make those same changes in several tables or documents, or make them according to some logic or condition. 

For a computer, making 1000 changes is no different from making 10, so there is an **economy of scale** here with larger documents and problems, and that is where VBA can really shine and save you time.

VBA编程的第一个挑战是熟悉每个Office应用程序的对象模型，并阅读对象、方法和属性语法。对象模型在所有Office应用程序中都很相似，但每个应用程序都针对其操作的文档和对象类型而特定。

在代码片段的第一行中，有一个应用程序对象，这次是Excel，然后是ActiveSheet，它提供对活动工作表的访问。之后是一个不太熟悉的术语Range，它的意思是“以这种方式定义一组单元格”。代码指示Range使用只有A1作为其定义的单元格集的方式来创建自己。换句话说，代码的第一行定义了一个对象，即Range，并对其运行一个方法来选择它。结果自动存储在Application的另一个属性Selection中。

第二行代码将Selection的Value属性设置为文本“Hello World”，并将该值显示在单元格A1中。

您编写的最简单的VBA代码可能仅仅是访问正在使用的Office应用程序中的对象并设置属性。例如，您可以获取Word表格中的行并在VBA脚本中更改它们的格式。

听起来简单，但它非常有用；一旦您能够编写该代码，您就可以利用编程的全部力量，在几个表格或文档中进行相同的更改，或根据某些逻辑或条件进行更改。对于计算机来说，进行1000次更改与进行10次更改没有任何区别，因此对于更大的文档和问题，存在一种规模经济，这就是VBA真正发挥作用并节省您的时间的地方。

## Macros and the Visual Basic Editor

- Now that you know something about how Office applications expose their object models, you are probably eager to try calling object methods, setting object properties, and responding to object events. 
- To do so, you must write your code in a place and in a way that Office can understand; typically, by using the Visual Basic Editor. 
- Although it is installed by default, many users don't know that it is even available until it is enabled on the ribbon.

- All Office applications use the ribbon. One tab on the ribbon is the **Developer** tab, where you access the Visual Basic Editor and other developer tools. Because Office does not display the **Developer** tab by default, you must enable it by using the following procedure:

现在您已经了解Office应用程序如何公开其对象模型，您可能渴望尝试调用对象方法、设置对象属性和响应对象事件。要这样做，您必须以Office可以理解的方式和位置编写您的代码；通常通过使用Visual Basic Editor。虽然它是默认安装的，但许多用户在启用了该功能之前甚至不知道它的存在。

所有Office应用程序都使用功能区。功能区上的一个选项卡是“开发人员”选项卡，在其中可以访问Visual Basic Editor和其他开发人员工具。因为Office默认情况下不显示“开发人员”选项卡，所以您必须通过以下步骤启用它：



### To enable the Developer tab🎈

- On the **File** tab, choose **Options** to open the **Options** dialog box.

  1. Choose **Customize Ribbon** on the left side of the dialog box.
  2. Under **Choose commands from** on the left side of the dialog box, select **Popular Commands**.
  3. Under **Customize the Ribbon** on the right side of the dialog box, select **Main Tabs** in the drop down list box, and then select the **Developer** checkbox.
  4. Choose **OK**.

- |                                                              |                                        |      |
  | ------------------------------------------------------------ | -------------------------------------- | ---- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/2efc4c801bf348eaa83b245a6e06df47.png) | 英文版界面操作示意图，启用开发者选项卡 |      |

  

- 启用“开发人员”选项卡

  - 在“文件”选项卡上，选择“选项”以打开“选项”对话框。
  - 在对话框的左侧，选择“自定义功能区”。
  - 在对话框的左侧，“从选择命令”下拉列表中选择“常用命令”。
  - 在对话框的右侧“自定义功能区”中，选择下拉列表框中的“主选项卡”，然后选择“开发人员”复选框。
  - 选择“确定”。

### Security issues

- To protect Office users against viruses and dangerous macro code, you cannot save macro code in a standard Office document that uses a standard file extension. 

- Instead, you must save the code in a file with **a special extension**.

-  For example you cannot save macros in a standard Word document with a .docx extension;

-  instead, you must use a special Word Macro-Enabled Document with a **.docm** extension.

- 安全问题
  为了保护Office用户免受病毒和危险的宏代码的影响，您不能将宏代码保存在使用标准文件扩展名的标准Office文档中。相反，您必须将代码保存在具有特殊扩展名的文件中。例如，您不能使用 .docx 扩展名在标准Word文档中保存宏；相反，您必须使用具有 .docm 扩展名的特殊的启用宏的Word文档。

  

### docm宏文件

- `document-macro` file

When you open a .docm file, Office security might still prevent the macros in the document from running, with or without telling you. Examine the settings and options in the Trust Center on all Office applications. 

The default setting disables macro from running, but warns you that macros have been disabled and gives you the option to turn them back on for that document.

You can designate specific folders where macros can run by creating Trusted Locations, Trusted Documents, or Trusted Publishers. The most portable option is to use Trusted Publishers, which works with digitally signed documents that you distribute. 

For more information about the security settings in a particular Office application, open the **Options** dialog box, choose **Trust Center**, and then choose **Trust Center Settings**.

 当您打开一个 .docm 文件时，Office安全设置可能仍会阻止文档中的宏运行，并可能不告诉您。检查所有Office应用程序中的信任中心的设置和选项。默认设置禁止运行宏，但会警告您已禁用宏，并为该文档提供重新启用宏的选项。

您可以通过创建受信任的位置、受信任的文档或受信任的发布者来指定可以运行宏的特定文件夹。最便携的选项是使用受信任的发布者，它适用于您分发的数字签名文档。

有关特定Office应用程序中的安全设置的更多信息，请打开“选项”对话框，选择“信任中心”，然后选择“信任中心设置”。

Some Office applications, like Outlook, <u>save macros by default in a master template on your local computer.</u> Although that strategy reduces the local security issues on your own computer when you run your own macros, it requires a deployment strategy if you want to distribute your macro.

一些Office应用程序，如Outlook，默认情况下将宏保存在您本地计算机上的主模板中。虽然这种策略在您运行自己的宏时减少了本地安全问题，但如果您想分发您的宏，则需要部署策略。

### Recording a macro

- When you choose the **Macro** button on the **Developer** tab, it opens the **Macros** dialog box, which gives you access to VBA subroutines or macros that you can access from a particular document or application. The **Visual Basic** button opens the Visual Basic Editor, where you create and edit VBA code.

- Another button on the **Developer** tab in Word and Excel is the **Record Macro** button, which automatically generates VBA code that can reproduce the actions that you perform in the application. **Record Macro** is a <span style="color:red">terrific(极好的）</span> tool that you can use to learn more about VBA. 

- Reading the generated code can give you insight into VBA and provide a stable bridge between your knowledge of Office as a user and your knowledge as a programmer. The only **caveat** is that the generated code can be confusing because the Macro editor must make some assumptions about your intentions, and those assumptions are not necessarily accurate.

- 当您在“开发人员”选项卡上选择“宏”按钮时，它会打开“宏”对话框框，让您访问可以从特定文档或应用程序中访问的VBA子例程或宏。Visual Basic 按钮打开了Visual Basic Editor，您可以在其中创建和编辑VBA代码。

  Word 和 Excel 中“开发人员”选项卡上的另一个按钮是“录制宏”按钮，它会自动生成可以复制您在应用程序中执行的操作的 VBA 代码。录制宏是一个非常好的工具，您可以使用它来了解更多关于VBA的知识。阅读生成的代码可以让您了解VBA，并提供一个稳定的桥梁，将您作为用户对Office的了解和作为程序员的知识联系起来。唯一的注意事项是生成的代码可能会令人困惑，因为宏编辑器必须对您的意图作出一些假设，而这些假设不一定准确。

#### To record a macro

1. Open `Excel` to a new Workbook and choose the **Developer** tab in the ribbon. Choose **Record Macro** and accept all of the default settings in the **Record Macro** dialog box, including **Macro1** as the name of the macro and **This Workbook** as the location.

2. Choose **OK** to begin recording the macro. Note how the button text changes to **Stop Recording**. Choose that button the instant you complete the actions that you want to record.

3. Choose cell B1 and type the programmer's classic first string: `Hello World`. Stop typing and look at the **Stop Recording** button; it is grayed out because Excel is waiting for you to finish typing the value in the cell.

4. Choose cell B2 to complete the action in cell B1, and then choose **Stop Recording**.

5. Choose **Macros** on the **Developer** tab, select **Macro1** if it is not selected, and then choose **Edit** to view the code from Macro1 in the Visual Basic Editor.

   - ```vb
     Sub Macro1()
     '
     ' Macro1 Macro
     '
     
     '
         Range("B1").Select
         ActiveCell.FormulaR1C1 = "hellow world"
         Range("B2").Select
     End Sub
     
     ```

     

1. 打开 Excel 并新建一个工作簿，在功能区中选择“开发人员”选项卡。选择“录制宏”，并在“录制宏”对话框中接受所有默认设置，包括使用“Macro1”作为宏的名称，并将其位置设置为“此工作簿”。
2. 选择“确定”开始录制宏。请注意按钮文本如何更改为“停止录制”。在您完成要记录的操作后立即选择该按钮。
3. 选择单元格 B1 并输入程序员的经典首个字符串：“Hello World”。停止输入并查看“停止录制”按钮；它被禁用，因为Excel正在等待您完成单元格中的值的输入。
4. 选择单元格 B2 完成 B1 中的操作，然后选择“停止录制”。
5. 在“开发人员”选项卡上选择“宏”，如果未选择“Macro1”，则选择它，然后选择“编辑”以在Visual Basic Editor中查看 Macro1 的代码。

Be aware of the similarities to the earlier code snippet that selected text in cell A1, and the differences. In this code, cell B1 is selected, and then the string "Hello World" is applied to the cell that has been made active. The quotes around the text specify a string value as opposed to a numeric value.

Remember how you chose cell B2 to display the **Stop Recording** button again? That action shows up as a line of code as well. The macro recorder records every **keystroke**.

The lines of code that start with an **apostrophe**(单引号) and colored green by the editor are comments that explain the code or remind you and other programmers <u>the purpose of the code注释</u>. VBA ignores any line, or portion of a line, that begins with a **single quote**.

 Writing clear and appropriate comments in your code is an important topic, but that discussion is out of the scope of this article. Subsequent references to this code in the article don't include those four comment lines.

When the macro recorder generates the code, it uses a complex algorithm to determine the methods and the properties that you intended. If you don't recognize a given property, there are many resources available to help you. For example, in the macro that you recorded, the macro recorder generated code that refers to the **FormulaR1C1** property. Not sure what that means?

Be aware that **Application** object is implied in all VBA macros. The code that you recorded works with **Application.** at the beginning of each line.

请注意这段代码与之前选中单元格 A1 中的文本的代码段的相似之处和不同之处。在这段代码中，选择了单元格 B1，然后将字符串“Hello World”应用于已激活的单元格。引号将文本指定为字符串值，而不是数值。

还记得您选择单元格 B2 以再次显示“停止录制”按钮吗？该操作也显示为一行代码。宏录制器记录每个按键。

以单引号开头并由编辑器呈绿色的行是注释，用于解释代码或提醒您和其他程序员代码的目的。VBA 忽略以单引号开头的任何行或行的部分。在您的代码中编写清晰和适当的注释是一个重要的主题，但该讨论不在本文的范围内。本文中对此代码的后续引用不包括这四行注释代码。

当宏录制器生成代码时，它使用复杂的算法来确定您打算使用的方法和属性。如果您不认识特定的属性，有许多可用的资源可以帮助您。例如，在您录制的宏中，宏录制器生成了引用 FormulaR1C1 属性的代码。不确定这是什么意思？（下一节介绍使用帮助系统）

- 请注意，Application 对象在所有的 VBA 宏中都被暗示。您录制的代码在每行开头都使用了 Application.

### Using Developer Help

Select **FormulaR1C1** in the recorded macro and press F1. The Help system runs a quick search, determines that the appropriate subjects are in the Excel Developer section of the Excel Help, and lists the **FormulaR1C1** property. You can choose the link to read more about the property, but before you do, be aware of the **Excel Object Model Reference** link near the bottom of the window. Choose the link to view a long list of objects that Excel uses in its object model to describe the Worksheets and their components.

Choose any one of those to see the properties and methods that apply to that particular object, along with cross references to different related options. Many Help entries also have brief code examples that can help you. For example, you can follow the links in the **Borders** object to see how to set a border in VBA.

```vb
Worksheets(1).Range("A1").Borders.LineStyle = xlDouble
```

选择录制的宏中的 FormulaR1C1 并按 F1。帮助系统会运行快速搜索，确定适当的主题在 Excel 帮助的 Excel 开发人员部分中，并列出 FormulaR1C1 属性。您可以选择该链接以了解更多有关该属性的信息，但在您这样做之前，请注意窗口底部附近的 Excel 对象模型参考链接。选择该链接以查看 Excel 在其对象模型中用于描述工作表及其组件的对象的长列表。

选择其中任何一个，以查看适用于该特定对象的属性和方法，以及不同相关选项的交叉引用。许多帮助条目还具有简短的代码示例，可以帮助您。例如，您可以按照边框对象中的链接，以查看如何在 VBA 中设置边框。

- 为了使用这个特性，您的其他软件不应该绑定为`F1`,例如某些截图快捷键，否则无法达到查询文档的效果
- 这个例子中，会跳转浏览器：[Range.FormulaR1C1 property (Excel) | Microsoft Learn](https://learn.microsoft.com/en-us/office/vba/api/excel.range.formular1c1?f1url=%3FappId%3DDev11IDEF1%26l%3Den-US%26k%3Dk(vbaxl10.chm144137)%3Bk(TargetFrameworkMoniker-Office.Version%3Dv16)%26rd%3Dtrue)

### Editing the code

The Borders code looks different from the recorded macro. One thing that can be confusing with an object model is that there is more than one way to address any given object, cell A1 in this example.

Sometimes the best way to learn programming is to make minor changes to some working code and see what happens as a result. Try it now. Open **Macro1** in the Visual Basic Editor and change the code to the following.

```vb
Sub Macro1()
    Worksheets(1).Range("A1").Value = "Wow!"
    Worksheets(1).Range("A1").Borders.LineStyle = xlDouble
End Sub
```

 Tip：

Use Copy and Paste as much as possible when working with code to avoid typing errors.

You don't need to save the code to try it out, so return to the Excel document, choose **Macros** on the **Developer** tab, choose **Macro1**, and then choose **Run**. Cell A1 now contains the text Wow! and has a double-line border around it.



## Programming tips and tricks



### Start with examples

The VBA community is very large; a search on the Web can almost always yield an example of VBA code that does something similar to what you want to do. If you cannot find a good example, try to break the task down into smaller units and search on each of those, or try to think of a more common, but similar problem. Starting with an example can save you hours of time.

That does not mean that free and well-thought-out code is on the Web waiting for you to come along. In fact, some of the code that you find might have bugs or mistakes. The idea is that the examples you find online or in VBA documentation give you a head start. Remember that learning programming requires time and thought. Before you get in a big rush to use another solution to solve your problem, ask yourself whether VBA is the right choice for this problem.

从示例开始
VBA 社区非常庞大；在网络上搜索几乎总能找到一个类似于您想要的功能的 VBA 代码示例。如果找不到好的示例，请尝试将任务分解为较小的单元，并对每个单元进行搜索，或尝试想出一个更常见但类似的问题。从示例开始可以节省您数小时的时间。

这并不意味着免费且经过深思熟虑的代码就在等着您上网找。实际上，您找到的一些代码可能存在错误或错误。关键是，您在在线或 VBA 文档中找到的示例可以让您事半功倍。请记住，学习编程需要时间和思考。在您匆忙使用另一个解决方案来解决您的问题之前，请问问自己 VBA 是否是解决此问题的正确选择。

### Make a simpler problem

Programming can get complex quickly. It's critical, especially as a beginner, that you break the problem down to the smallest possible logical units, then write and test each piece in isolation. If you have too much code in front of you and you get confused or muddled, stop and set the problem aside. When you come back to the problem, copy out a small piece of the problem into a new module, solve that piece, get the code working, and test it to ensure that it works. Then move on to the next part.
编程可以很快变得复杂。特别是作为一个新手，将问题分解成最小可能的逻辑单元，然后独立编写和测试每个单元非常重要。如果您面前有太多的代码，让您感到困惑或混乱，请停下来并将问题放在一边。当您回到问题时，请将小问题复制到一个新模块中，解决该问题，使代码正常工作，并测试以确保它能正常工作。然后再转移到下一个部分。

### Bugs and debugging

There are two main types of programming errors: 

1. syntax errors, which violate the grammatical rules of the programming language, and
2. run-time errors, which look syntactically correct, but fail when VBA attempts to execute the code.

- Although they can be frustrating to fix, syntax errors are easy to catch; the Visual Basic Editor beeps and flashes at you if you type a syntax error in your code.

  - For example, string values must be surrounded by double quotes in VBA. To find out what happens when you use single quotes instead, return to the Visual Basic Editor and replace the "Wow!" string in the code example with 'Wow!' (that is, the word Wow enclosed in single quotes). 

  - If you choose the next line, the Visual Basic Editor reacts. The error "Compile error: Expected: expression" is not that helpful, but the line that generates the error turns red to tell you that you have a syntax error in that line and as a result, this program will not run.

  - Choose **OK** and change the text back to"Wow!".

- Runtime errors are harder to catch because the programming syntax looks correct, but the code fails when VBA tries to execute it.

  - For example, open the Visual Basic Editor and change the **Value** property name to ValueX in your Macro, **deliberately** introducing a runtime error since the **Range** object does not have a property called ValueX. Go back to the Excel document, open the **Macros** dialog box and run Macro1 again. You should see a Visual Basic message box that explains the run-time error with the text, "Object doesn't support this property of method." Although that text is clear, choose **Debug** to find out more.

  - When you return to the Visual Basic Editor, it is in a special debug mode that uses a yellow highlight to show you the line of code that failed. As expected, the line that includes the ValueX property is highlighted.

  - You can make changes to VBA code that is running, so change ValueX back to **Value** and choose the little green play button underneath the **Debug** menu. The program should run normally again.

- It's a good idea to learn how to use the debugger more deliberately for longer, more complex programs. At a minimum, learn a how to set break-points to stop execution at a point where you want to take a look at the code, how to add watches to see the values of different variables and properties as the code runs, and how to step through the code line by line. These options are all available in the **Debug** menu and serious debugger users typically memorize the accompanying keyboard shortcuts.

错误和调试
编程错误有两种主要类型：语法错误违反了编程语言的语法规则，运行时错误在语法上看起来正确，但在 VBA 尝试执行代码时失败。

虽然它们很难修复，但语法错误很容易捕捉到；如果您在代码中输入语法错误，Visual Basic 编辑器会发出提示音并闪烁。

例如，在 VBA 中，字符串值必须用双引号括起来。要了解当您使用单引号而不是双引号时会发生什么，请返回 Visual Basic 编辑器，并将代码示例中的“Wow！”字符串替换为 'Wow!'（即用单引号括起来的单词“Wow”）。如果您选择下一行，Visual Basic 编辑器会做出反应。错误“编译错误：预期：表达式”并不是很有帮助，但生成错误的行变为红色，告诉您该行中有一个语法错误，并且因此，此程序将无法运行。

选择“确定”并将文本更改回“Wow！”。

运行时错误很难捕捉，因为编程语法看起来是正确的，但代码在 VBA 尝试执行它时失败了。

例如，在您的宏中将 Value 属性名称更改为 ValueX，故意引入运行时错误，因为 Range 对象没有名为 ValueX 的属性。返回 Excel 文档，打开宏对话框，并再次运行 Macro1。您应该会看到一个 Visual Basic 消息框，其中解释了运行时错误，文本为“对象不支持此属性或方法。”虽然该文本很清晰，但选择“调试”以了解更多信息。

当您返回到 Visual Basic 编辑器时，它处于特殊的调试模式中，使用黄色突出显示失败的代码行。正如预期的那样，包括 ValueX 属性的行被突出显示。

您可以更改正在运行的 VBA 代码，因此将 ValueX 改回 Value 并选择调试菜单下面的小绿色播放按钮。程序应该再次正常运行。

最好学习如何更有意识地使用调试器来处理更长、更复杂的程序。至少要学会如何设置断点，在您想查看代码的地方停止执行，如何添加监视器以在代码运行时查看不同变量和属性的值，以及如何逐行执行代码。这些选项都在调试菜单中提供，认真的调试器用户通常会记忆相应的键盘快捷键。

## Using reference materials well@查阅参考

- Time spent browsing the Object Model reference pays off. After you understand the basics of VBA syntax and the object model for the Office application that you are working with, you advance from guesswork to methodical programming.浏览对象模型参考所花费的时间是值得的。在您了解VBA语法的基本知识和正在使用的Office应用程序的对象模型后，您将从猜测过渡到有条不紊的编程

- [Excel Visual Basic for Applications (VBA) 参考 | Microsoft Learn](https://learn.microsoft.com/zh-cn/office/vba/api/overview/excel)

- |                                                              |                                          |      |
  | ------------------------------------------------------------ | ---------------------------------------- | ---- |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/c890c078263148cd8455b60f9720c20c.png) | office中包含的应用的VBA参考，以excel为例 |      |

  

## Going further with programming

Although this article is short and only scratches the surface of VBA and programming, it is hopefully enough to get you started.

This section briefly discusses a few more key topics.



### Variables

In the simple examples in this article you manipulated objects that the application had already created. You might want to create your own objects to store values or references to other objects for temporary use in your application. These are called variables.

To use a variable in VBA, must tell VBA which type of object the variable represents by using the **Dim** statement. You then set its value and use it to set other variables or properties.

```vb
    Dim MyStringVariable As String
    MyStringVariable = "Wow!"
    Worksheets(1).Range("A1").Value = MyStringVariable
```

- 在VBA中，"Dim"是一个关键字，它是"Dimension"的缩写，意思是声明一个变量并指定其数据类型。在中文中，可以将"Dim"翻译为"声明"、"定义"或"维度"。

### Branching and looping

The simple programs in this article execute one line at a time, from the top down. The real power in programming comes from the options that you have to determine which lines of code to execute, based on one or more conditions that you specify. You can extend those capabilities even further when you can repeat an operation many times. For example, the following code extends Macro1.

```vb
Sub Macro1()
    If Worksheets(1).Range("A1").Value = "Yes!" Then
        Dim i As Integer
        For i = 2 To 10
            Worksheets(1).Range("A" & i).Value = "OK! " & i
        Next i
    Else
        MsgBox "Put Yes! in cell A1"
    End If
End Sub
```

Type or paste the code into the Visual Basic Editor and then run it. Follow the directions in the message box that appears and change the text in cell A1 from `Wow!` to `Yes!` and run it again to see the power of looping. （注意感叹号是英文，首字母大写）

This code snippet demonstrates variables, branching and looping. Read it carefully after you see it in action and try to determine what happens as each line executes.

![在这里插入图片描述](https://img-blog.csdnimg.cn/817e53e729ae4bd4bc2d731e770f5312.png)



## example code

Here are a few scripts to try; each solves a real-world Office problem.



### Create an email in Outlook

VB

```vb
Sub MakeMessage()
    Dim OutlookMessage As Outlook.MailItem
    Set OutlookMessage = Application.CreateItem(olMailItem)
    OutlookMessage.Subject = "Hello World!"
    OutlookMessage.Display
    Set OutlookMessage = Nothing
End Sub
```

Be aware that there are situations in which you might want to automate email in Outlook; you can use templates as well.



### Delete empty rows in an Excel worksheet

```vb
Sub DeleteEmptyRows()
    SelectedRange = Selection.Rows.Count
    ActiveCell.Offset(0, 0).Select
    For i = 1 To SelectedRange
        If ActiveCell.Value = "" Then
            Selection.EntireRow.Delete
        Else
            ActiveCell.Offset(1, 0).Select
        End If
    Next i
End Sub
```

Be aware that you can select a column of cells and run this macro to delete all rows in the selected column that have a blank cell.



### Delete empty text boxes in PowerPoint

VB

```vb
Sub RemoveEmptyTextBoxes()
    Dim SlideObj As Slide
    Dim ShapeObj As Shape
    Dim ShapeIndex As Integer
    For Each SlideObj In ActivePresentation.Slides
        For ShapeIndex = SlideObj.Shapes.Count To 1 Step -1
            Set ShapeObj = SlideObj.Shapes(ShapeIndex)
            If ShapeObj.Type = msoTextBox Then
                If Trim(ShapeObj.TextFrame.TextRange.Text) = "" Then
                    ShapeObj.Delete
                End If
            End If
        Next ShapeIndex
    Next SlideObj
End Sub
```

Be aware that this code loops through all of the slides and deletes all text boxes that don't have any text. The count variable decrements instead of increments because each time the code deletes an object, it removes that object from the collection, which reduces the count.

### Copy a contact from Outlook to Word

```vb
Sub CopyCurrentContact()
   Dim OutlookObj As Object
   Dim InspectorObj As Object
   Dim ItemObj As Object
   Set OutlookObj = CreateObject("Outlook.Application")
   Set InspectorObj = OutlookObj.ActiveInspector
   Set ItemObj = InspectorObj.CurrentItem
   Application.ActiveDocument.Range.InsertAfter (ItemObj.FullName & " from " & ItemObj.CompanyName)
End Sub
```

Be aware that this code copies the currently open contact in Outlook into the open Word document. This code only works if there is a contact currently open for inspection in Outlook.

## 更多内容

- [Language reference for Visual Basic for Applications (VBA) | Microsoft Learn](https://learn.microsoft.com/en-us/office/vba/api/overview/language-reference?source=recommendations)
- [Visual Basic for Applications (VBA) 语言参考 | Microsoft Learn](https://learn.microsoft.com/zh-cn/office/vba/api/overview/language-reference)
- [Visual Basic 概念主题 | Microsoft Learn](https://learn.microsoft.com/zh-cn/office/vba/language/reference/user-interface-help/visual-basic-conceptual-topics)
- 参考相关书籍

### 推荐的使用方法

- 如果录制宏可以满足要求,那么就可以避开自己写VB程序的环境
- 利用搜索引擎或者AI尝试搜索或生成可以完成特定任务的VBA宏
- 借助AI来解读和学习拿到手的VBA代码,例如添加注释或者功能总结

