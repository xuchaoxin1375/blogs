[toc]

# powershell@scoop安装@scoop安装失败的解决方案

## 安装scoop

- [Scoop](https://scoop.sh/)

- 将一下的方案粘贴到powershell中执行

  - 根据网络环境的不同，选用qi'zhong

- 方案1：

  - ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
    ```

- 方案2:

  - ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    irm get.scoop.sh | iex
    ```

  

## 重装scoop

- [reference link:重装scoop](https://github.com/neolee/pilot/wiki#%E5%A6%82%E4%BD%95%E9%87%8D%E8%A3%85-scoop)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/b2e7258a4d0c4f5f914e6db9adb6ed54.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)