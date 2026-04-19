[toc]

## Ubuntu Server安装

- Server版的linux默认没有GUI界面,因此比较节省资源
- 安装过程需要用键盘来操作,没有图形界面用不了鼠标,好在上下左右键盘够用

## 更换镜像地址为国内源

- 在正式安装前,几个选项中有一个配置镜像地址的选项

- 通过上下箭头定位到输入框中,输入常用国内源中的一个即可(比如使用清华源或阿里源)

  - ```
    https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
    
    https://mirrors.aliyun.com/ubuntu/
    
    https://mirrors.163.com/ubuntu/
    ```

  - 于配置source时的步骤有所不同,这里填写一个https链接就可以了

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/93e6f1c2cad94017b337f043badc8d3f.png)

## ssh链接

- 既然时linux,使用命令行才是正经用途,GUI这个还是老老实实用windows
  - 虽然近几年许多软件都适配了linux,但是linux的GUI软件生态仍然无法匹敌windows
  - 我们用它的开发环境或命令行环境就是最合适的
- 在windows下使用ssh链接到linux是重要用法,也是主流用法

### 步骤



