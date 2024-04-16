[toc]

## abstract

- **JDK 发展简史**

  Java Development Kit (JDK) 自Java诞生起就伴随着其发展。Java 由Sun Microsystems于1995年推出，作为一种面向对象、可移植性强的编程语言，并很快因其“一次编写，到处运行”（Write Once, Run Anywhere, WORA）的理念而受到广泛欢迎。

- **早期JDK版本**：最初的JDK版本包括了Java编译器（javac）、Java运行时环境（JRE）和其他开发工具，比如Java调试器（jdb），以及文档和示例。随着Java的迭代更新，JDK不断添加新特性和优化。

- **JDK授权模式变更**：历史上，Oracle JDK曾作为商业产品提供，包含对企业的技术支持和长期维护保障。但随着时间推移，Oracle调整了策略，特别是在2019年后，Oracle JDK也开始提供免费版本，即Oracle OpenJDK。

## OpenJDK vs Oracle JDK

1. **开源性**：
   - **OpenJDK** 是Java SE平台的一个开源参考实现，任何个人或组织都可以自由获取、使用和贡献源代码。它是基于GPLv2+CE许可证分发的。
   - **Oracle JDK** 早期是闭源的商业产品，包含了额外的商业特性（如Flight Recorder和Mission Control等高级管理工具）。但后来Oracle推出了免费的Oracle OpenJDK版本，其核心代码与OpenJDK基本一致，但可能包含部分非开源的功能或模块。

2. **更新频率与生命周期**：
   - OpenJDK遵循较频繁的发布节奏，通常每六个月会有一个新的功能更新版本，同时提供长期支持（LTS）版本，这些LTS版本会得到若干年的安全更新支持。
   - Oracle JDK则曾经按照不同的发布周期进行更新，例如在Java 11及以后版本采用了每三年一个LTS版本的策略，并且也有商业支持的选项。

3. **稳定性和兼容性**：
   - 两者在稳定性上并无绝对优劣之分，但OpenJDK因为更广泛的社区参与和支持，通常被认为是Java标准实现的基础，许多第三方JDK如Amazon Corretto、Azul Zulu、Adoptium（原AdoptOpenJDK）等均基于OpenJDK构建，并承诺向后兼容和长期支持。
   - Oracle JDK在特定时期内由于商业支持的原因，可能对于企业级用户来说更加看重其稳定性和服务保障。

4. **支持和维护**：
   - OpenJDK主要依赖社区支持，很多大型公司也会为其提供企业级的支持和服务。
   - Oracle JDK除了社区支持外，还可以通过购买Oracle的技术支持获得专业的商业支持服务。

总之，OpenJDK和Oracle JDK在技术层面上非常相似，大多数开发者在日常开发中不会感受到显著差别。选择哪一个取决于项目需求，包括是否需要特定的商业功能、长期稳定的官方支持程度，以及对开源软件的态度等因素。随着Java生态的发展，越来越多的企业和开发者转向OpenJDK及其衍生的受支持版本，这些版本在不牺牲功能和稳定性的同时，提供了灵活的授权方式和持续的更新支持。

## OpenJDK

- [OpenJDK](https://openjdk.org/)

- 下载:[JDK Builds from Oracle (java.net)](https://jdk.java.net/)
- 其他方式:[WEJDK学习站 (injdk.cn)](https://www.injdk.cn/)

## 配置jdk环境变量

### windows下配置

在Windows操作系统下配置JDK环境变量的过程如下：

1. **查找JDK安装路径**：
   首先，确保您已成功安装JDK，并记下其安装路径。例如，常见的安装路径可能是 `C:\Program Files\Java\jdk-11.0.1`（其中 "11.0.1" 是JDK的具体版本号）。

2. **配置环境变量**：
   - **JAVA_HOME**：
     - 打开环境变量设置：
       - 按快捷键 `Win + I` 进入设置界面，找到“系统”>“关于”>“相关链接”下的“高级系统设置”。
       - 或者右键点击“计算机”/“此电脑”，选择“属性”，然后点击“高级系统设置”。
     - 在“系统属性”窗口中，转到“高级”选项卡，点击“环境变量”按钮。
     - 在“系统变量”区域，点击“新建”按钮，创建一个新的环境变量：
       - 变量名：`JAVA_HOME`
       - 变量值：填写JDK的安装路径，如上面提到的示例路径。

   - **Path**：
     - 找到系统变量中的`Path`变量，选择“编辑”。
     - 在“编辑环境变量”窗口中，点击“新建”按钮，然后将 `%JAVA_HOME%\bin` 添加到路径列表中，这会确保系统可以在任何地方识别并执行Java相关的可执行文件（如`java.exe`和`javac.exe`）。

3. **验证配置**：
   - 完成上述步骤后，重新打开命令提示符窗口，输入 `java -version` 或 `javac -version` 来验证是否正确配置了JDK环境变量。如果显示出正确的Java版本信息，则说明配置成功。

注意：不同版本的Windows系统的操作可能会有些许差异，但基本思路和关键步骤是一致的。务必按照实际操作系统版本的指引来操作。从上述信息来看，即使到了Windows 11系统，设置JDK环境变量的基本流程也是类似的。





