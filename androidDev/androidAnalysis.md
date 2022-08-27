# android apk analyzer(libchecker apk分析器):分析Android手机上已安装的app(库/基础组件分析/开发技术..)

## download app(apk)

* [Release 2.2.1 · zhaobozhen/LibChecker (github.com)](https://github.com/zhaobozhen/LibChecker/releases/tag/2.2.1)
* [LibChecker - 应用架构查看(com.absinthe.libchecker) - 2.2.1.4a5a3233 - 应用 - 酷安 (coolapk.com)](https://www.coolapk.com/apk/com.absinthe.libchecker)

## introduction&documents

### functions

查看开发语言

- kotlin/java(现在基本都是kotlin)

可以查看android app四大组件

* activity
* broadcast receiver
* content provider
* services

其他信息

* native libraries
* permissions
* meta data
* dex

app SDK/targets

- targetSdkVersion
- miniSdkVersion
- arm架构版本

## 使用方式

- 支持按app查看
- 按sdk分类统计app

### What's this?

* This app is used to view the`third-party libraries`used by applications in your device.
  * 通过设置,系统应用也是可以分析的
* It can view the ABI architecture of the application's native library (in general, whether the application is 64-bit or 32-bit).
* It can also view well-known libraries marked by [The Rule Repository](https://github.com/zhaobozhen/LibChecker-Rules), and can even sort and view them according to the number of libraries references.

### Document

* [LibChecker-Docs](https://github.com/zhaobozhen/LibChecker-Docs)
