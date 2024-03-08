[toc]



## 计算机名

- 开始菜单中直接搜索`计算机名`可以进入到设置查看

- 更通用的办法是打开cmd或powershell

  - 输入`hostname.exe`

    - ```
      PS>HOSTNAME.EXE
      ColorfulCxxu
      ```

    - 返回的`ColorfulCxxu`就是计算机名

  - 或者输入`whoami`,可以看到返回的内容是一个字符串,包含一个斜杆`/`;斜杠前面的部分就是计算机名

    - ```bash
      PS>whoami
      colorfulcxxu\cxxu
      ```

  - 例如上述结果表示,主机的名字叫`colorfulcxxu`



- 记下(复制)改名字(也可以自行修改计算机名)
  如果需要,可以修改计算机名(修改后需要重启计算机)
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/f771969303d24248b114ca79c64ff391.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_19,color_FFFFFF,t_70,g_se,x_16)



## 获取ip地址

- 这里主要关心的是ipv4地址

### 方式0(最可靠)

- 对于较新windows,打开系统设置,点击网络(Internet),查看网络属性,其中包括了ip地址
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/5e1dbf4fbcb64afca5ff57ca843a4045.png)

### 方式1

- 使用`arp -a`,观察他返回的第一个结果

- 如果只想查看第一个结果,使用`arp -a|sls '---'|Select-Object -First 1`即可

  - 例如

    ```bash
    PS>arp -a|sls '---'|Select-Object -First 1
    
    接口: 192.168.1.178 --- 0x3
    ```

### 方式2

- 使用`ipconfig`查看,这种方法是最多人提到的,但是观察起来不方便

  - 我们可以用命令行,输入`ipconfig | findstr /i "IPv4.*:.*"`进行查询

  - 有时候可以查到多个地址

    - ```bash
      PS>ipconfig | findstr /i "IPv4.*:.*"
         IPv4 地址 . . . . . . . . . . . . : 192.168.219.1
         IPv4 地址 . . . . . . . . . . . . : 192.168.32.1
         IPv4 地址 . . . . . . . . . . . . : 192.168.1.178
      ```

  - 如果有多个地址,为了区分他们,我们可以运行`ipconfig`,或者更加详细的`ipconfig /all`查看详情

- 从经验上看,一般都是192.168开头,并且第3个字段是`1`的往往就是我们想要的ipv4地址(但这不必然)





## 查看到多个ip

### 安装了vmware

- 在您的主机上安装了VMware虚拟机软件之后，您可能会看到多个IPv4地址，这是因为主机操作系统自身至少有一个物理网络接口，而VMware会为虚拟机创建额外的网络适配器，例如：

  1. **主机的IPv4地址**：
     - 这通常是您主机通过物理网络接口连接到网络所获得的IP地址。在Windows操作系统的命令提示符中，您可以运行`ipconfig`命令查看所有网络接口的信息，包括名称（如“以太网适配器”或“无线局域网适配器”）及其对应的IPv4地址。

  2. **虚拟网络适配器的IPv4地址**：
     - VMware会在主机上创建虚拟网络适配器，用于与虚拟机通信。常见的VMware虚拟网络类型有三种：
       - **VMnet1（Host-only）**: 这种模式下，虚拟机只能与主机以及在同一网络下的其他虚拟机通信，其IPv4地址一般不同于主机的真实网络地址。
       - **VMnet8 (NAT)**: 使用NAT模式时，虚拟机通过NAT共享主机的网络连接，虚拟机会有独立的私有IPv4地址，且可以通过NAT转换与外部网络通信。
       - **VMnet0 (Bridged)**: 桥接模式下，虚拟机直接桥接到主机的一个物理网络接口，虚拟机可以获得与主机同一网络段的IPv4地址，就像网络上的另一台独立计算机。
- 要区分这些IPv4地址，请在运行`ipconfig`命令后，仔细查看输出的结果，每一部分都会标明网络适配器的名称。
- 如果想单独查看某个网络适配器的配置，可以使用`ipconfig /all`命令，它会列出所有网络接口的详细信息，从中你可以根据适配器描述来判断哪个是主机的真实IP地址，哪个是VMware虚拟网络适配器的IP地址。

### 其他情况

- 不仅仅是VMware会注册虚拟网卡,其他软件也可能会类似的行为

