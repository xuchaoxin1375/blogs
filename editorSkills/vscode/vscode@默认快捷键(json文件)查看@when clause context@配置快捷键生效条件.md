[toc]



##  ref

* [Visual Studio Code Key Bindings](https://code.visualstudio.com/docs/getstarted/keybindings)
* 这是Visual Studio Code文档中的一个页面，介绍了when条件上下文的使用方式。在Visual Studio Code中，when条件上下文被用于定义一个命令或菜单项何时可见或可用。 该页面列出了一些预定义的上下文，描述了它们的含义以及如何在when条件中使用它们。例如，config.editorLangId上下文表示当前的编辑器语言标识符，可以使用它来定义一个命令只在某种语言的编辑器中可见。 
* 此外，该页面还介绍了如何自定义上下文，以及如何在扩展中使用它们。如果您正在开发Visual Studio Code扩展程序，这些信息可能会对您很有帮助，因为您可以使用自定义上下文来控制您的扩展程序何时可见或可用。 总之，when条件上下文是Visual Studio Code中一个非常有用的功能，可以帮助您更好地控制您的命令和菜单项的可见性和可用性。如果您想深入了解它们的用法和实现方式，建议您参考该文档页面。

## 控制快捷键生效条件@when clause context

- 使用when条件可以让你更加精细的配置快捷键

- 这样,同一个快捷键可以在编辑不同类型文件的时候执行不同的指令
- [when clause contexts | Visual Studio Code Extension API](https://code.visualstudio.com/api/references/when-clause-contexts)

| Operator     | Symbol   | Example                                                      |
| :----------- | :------- | :----------------------------------------------------------- |
| Equality     | `==`     | `"editorLangId == typescript"`                               |
| Inequality   | `!=`     | `"resourceExtname != .js"`                                   |
| Or           | `||`     | `"isLinux"||"isWindows"`                                     |
| And          | `&&`     | `"textInputFocus && !editorReadonly"`                        |
| Not          | `!`      | `!editorReadonly`                                            |
| Matches      | `=~`     | `"resourceScheme =~ /^untitled$|^file$/"`                    |
| Greater than | `>` `>=` | `"gitOpenRepositoryCount >= 1"`                              |
| Less than    | `<` `<=` | `"workspaceFolderCount < 2"`                                 |
| In           | `in`     | `resourceFilename in supportedFolders` ([details](https://code.visualstudio.com/api/references/when-clause-contexts#in-conditional-operator) below) |

##  快捷键重置

- 如果您的快捷绑定设置乱了,可以参考这里恢复出厂配置

###  本地查看:

- 随便打开一个文件,再打开command palette:`Open Default Keyboard Shortcuts`
  - Note:`command palette`可用的命令会随当前打开的内容而有所不同,例如再快捷键配置页面上述指令将无效
  - 正常情况下将打开一个`Default Keybindings.json`文件

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a998e4f4ebc74ab7ba843aad32b3b377.png)



