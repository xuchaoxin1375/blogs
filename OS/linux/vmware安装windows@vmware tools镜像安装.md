[toc]

参考

[windows虚拟机安装VMware tools的方法，特别是重新安装VMware tools为灰色，不可选状态。_win10虚拟机无法安装vmware tools-CSDN博客](https://blog.csdn.net/zhumeng_csdn/article/details/130675407)

- 注意vmware-tools在安装目录中的名字是`windows.iso`

- 可以在虚拟机设置中

  - 硬件->更改或添加(CD/DVD)->选择vmware安装目录下的windwos.iso文件

  - 例如使用scoop 安装的vmware目录如下

    ```powershell
    C:\ProgramData\scoop\apps\vmware-workstation-pro\current
    ```

    