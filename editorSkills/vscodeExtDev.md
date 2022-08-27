# vscode 插件开发

## 某些概念

### contribution point

> 插件功能增强点(功能拓展归类)

* 这里的contribution

  * the part played by a person or thing in bringing about a result or `helping something to advance.`

  - eg."he made a lasting contribution by designing the modern radio telescope"


**Contribution Points** are a set of JSON declarations that you make in the `contributes` field of the `package.json` [Extension Manifest](https://code.visualstudio.com/api/references/extension-manifest).

Your extension registers(`v.`) **Contribution Points** to `extend various functionalities within Visual Studio Code`.
