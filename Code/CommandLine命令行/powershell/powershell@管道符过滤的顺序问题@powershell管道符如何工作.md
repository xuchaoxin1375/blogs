[toc]

## select 和 where谁先执行

- 在执行筛选时，指定命令的顺序确实很重要。

- 例如，考虑这样一种情况：使用 Select-Object 只选择几个属性(比如Name,Date)，而使用 Where-Object 过滤的属性是(size)不在选择范围内的属性。在这种情况下，必须先进行过滤，否则在尝试执行过滤时，管道中将不存在该属性。

- 下面的例子返回的内容会是空的

  ```powershell
  Get-Service -ErrorAction Ignore |
  Select-Object -Property DisplayName, Running, Status |
  Where-Object CanPauseAndContinue
  ```

- 更改select和where的顺序,就是正确的用法

  ```powershell
  PS>Get-Service -ErrorAction Ignore |
  >> Where-Object CanPauseAndContinue |
  >> Select-Object -Property DisplayName, Status
  
  DisplayName                                           Status
  -----------                                           ------
  Control Center Hotkey Service                        Running
  Intel(R) Dynamic Tuning Technology Telemetry Service Running
  Intel(R) Graphics Command Center Service             Running
  Intel(R) Innovation Platform Framework Service       Running
  Workstation                                          Running
  Web Threat Defense Service                           Running
  Web Threat Defense User Service_1bd31e               Running
  Windows Management Instrumentation                   Running
  ```

## powershell管道符

- 这里解释powershell管道符是如何工作的,编写支持管道符的函数另见它文(阅读本文有助于理解和编写这类支持管道符函数)

- [One-liners and the pipeline - PowerShell | Microsoft Learn ~ 单行代码和管道 - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/04-pipelines?view=powershell-7.4#the-pipeline)

- 我们知道,有些命令可以接受管道符传递过来的参数,例如
  - `Stop-Service`,简写别名为`spsv`
  - `Stop-process`,简写为`spps`
- 下面介绍它们怎么处理管道符输入

### stop-service 为例查看文档中的典型参数介绍

- 为了说明问题,这里截取了`stop-service`的部分参数的文档

  - 这里截取的是三个典型的参数

    ```powershell
    ...
    -DisplayName <String[]>
        Specifies the display names of the services to stop. Wildcard characters are
        permitted.
    
        Required?                    true
        Position?                    named
        Default value                None
        Accept pipeline input?       False
        Accept wildcard characters?  false
    
    -InputObject <ServiceController[]>
        Specifies ServiceController objects that represent the services to stop. Enter a
        variable that contains the objects, or type a command or expression that gets the
        objects.
    
        Required?                    true
        Position?                    0
        Default value                None
        Accept pipeline input?       True (ByValue)
        Accept wildcard characters?  false
    
    -Name <String[]>
        Specifies the service names of the services to stop. Wildcard characters are
        permitted.
    
        Required?                    true
        Position?                    0
        Default value                None
        Accept pipeline input?       True (ByPropertyName, ByValue)
        Accept wildcard characters?  false
    ...
    ```

    

  - 当一个参数同时接受按属性名和值输入的管道输入时，它总是先尝试按值输入。

  - 如果按值输入失败，它就会尝试按属性名输入。

  - 按值输入有点误导。我更喜欢称之为按类型。这意味着如果你将产生 ServiceController 对象类型的命令结果导入 Stop-Service，它会将该输入绑定到 InputObject 参数。

  - 但如果将产生字符串输出的命令结果导入 Stop-Service，则会将其绑定到 Name 参数。

  - 如果将一条不产生 ServiceController 或 String 对象的命令的结果导入 Stop-Service，不意味着绑定一定失败

  - 如果它产生(返回)的某个对象的属性包含了Name，那么它会将输出中的 Name 属性绑定到 Stop-Service 的 Name 参数。

### stop-process为例介绍管道符传参是怎么工作的

- 经典命令`stop-process`,结束进程的cmdlet

  - ```powershell
      -Id <System.Int32[]>
            Specifies the process IDs of the processes to stop. To specify multiple IDs, use commas to separate the IDs. To
             find the PID of a process, type `Get-Process`.
    
            Required?                    true
            Position?                    0
            Default value                None
            Accept pipeline input?       True (ByPropertyName)
            Accept wildcard characters?  false
    
        -InputObject <System.Diagnostics.Process[]>
            Specifies the process objects to stop. Enter a variable that contains the objects, or type a command or express
            ion that gets the objects.
    
            Required?                    true
            Position?                    0
            Default value                None
            Accept pipeline input?       True (ByValue)
            Accept wildcard characters?  false
    
        -Name <System.String[]>
            Specifies the process names of the processes to stop. You can type multiple process names, separated by commas,
             or use wildcard characters.
    
            Required?                    true
            Position?                    named
            Default value                None
            Accept pipeline input?       True (ByPropertyName)
            Accept wildcard characters?  true
    ```

- 为了便于介绍,这里创建两个notepad进程

  - ```powershell
    PS C:\Users\cxxu\Desktop> $pss=ps Notepad
    PS C:\Users\cxxu\Desktop> $pss
    
     NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
     ------    -----      -----     ------      --  -- -----------
         44    74.81     123.38       0.58     440   1 Notepad
         12     2.70      13.02       0.02   21176   1 Notepad
    ```

#### Id参数

- 可以看到,`Id`参数接受管道符的输入,并且是管道符前的表达式输出的对象包含名为`Id`的属性(而且属性值类型兼容`<System.Int32[]>`时才会被绑定到这个参数上

#### InputObject 参数

- 然而`stop-process`还有其他参数支持管道符的形式输入,例如`InputObject`,并且通常具有更高的优先级,因为powershell管道符传参时,优先检查`ByValue`的参数,然后才是`ByPropertyName`的参数

- 正如前面所讲的那样,文档里面`InputObject`是带有类型的,类型为`<System.Diagnostics.Process[]>`,当管道符前面的表达式产生的刚好是这个类型的对象,那么就会被`InputObject`所捕获绑定

- 执行`$pss|stop-Process`仿佛执行的是以下遍历语句

  ```powershell
  foreach ($p in $pss){
  	stop-process -InputObject $p
  }
  
  ```

  

- 在PowerShell中，`-InputObject` 参数通常用于指定直接传递给 cmdlet 的输入对象。

- 例如参数声明`    -InputObject <System.Diagnostics.Process[]>`,其中`<System.Diagnostics.Process[]>` 表示 `InputObject` 参数应该是 `System.Diagnostics.Process` 类型的对象数组，这个类型代表系统中的进程。

- 这种参数类型经常用于那些接收进程作为输入的cmdlet，比如 `Stop-Process`。

- 例如，如果你有一个 `System.Diagnostics.Process` 对象的数组，你可以使用 `Stop-Process` cmdlet 来结束这些进程：

  ```powershell
  # 获取所有名为 "notepad" 的进程对象的数组
  $processes = Get-Process -Name "notepad"
  
  # 将进程对象数组传递给 Stop-Process cmdlet 来结束这些进程
  Stop-Process -InputObject $processes
  ```

  - 在这个例子中，`-InputObject` 参数接收了一个 `Process` 对象的数组，然后 `Stop-Process` cmdlet 将结束数组中的每一个进程。

  - 当你直接使用 `-InputObject` 参数时，通常不需要通过管道传递对象，因为你已经直接提供了要处理的对象数组。

#### Name参数

- 和`Id`参数类似,当管道符传入的对象包含了`Id`属性,并且类型为`<System.String[]>`时,有机会绑定到这个参数上

#### 额外的试验

- 我们提到说管道符输入时,会分别检查byValue和byPropertyName类型的参数

- 下面自定义一个类型,然后看看通过管道符传递能否按照预期工作

- 自定义一个类型,包含一个字段`Name`,值为`notepad`

  ```powershell
  $custObj = [PSCustomObject]@{
      Name = 'notepad'
  }
  ```

- 检查`$custObj`对象的成员

  ```bash
  PS C:\repos\scripts> $custObj = [PSCustomObject]@{
  >>     Name = 'notepad'
  >> }
  PS C:\repos\scripts> $custObj | Get-Member
  
     TypeName: System.Management.Automation.PSCustomObject
  
  Name        MemberType   Definition
  ----        ----------   ----------
  Equals      Method       bool Equals(System.Object obj)
  GetHashCode Method       int GetHashCode()
  GetType     Method       type GetType()
  ToString    Method       string ToString()
  Name        NoteProperty string Name=notepad
  ```

  - 可以发现powershell会自定让其继承一些必要的成员方法和特殊属性

- 使用这个对象传递给`Stop-Service`

  - ```powershell
    #启动一个notepad进程,用来试验杀死
    PS C:\repos\scripts>  notepad
    #将$custObj传递给Stop-Process,检验其是否能够解析出$custObj对象中有Name属性,从而杀死所有Name为notepad的进程
    PS C:\repos\scripts> $custObj | Stop-Process   
    ```

  - 经过检验,上述语句顺利执行

#### 反面例子

- ```powershell
  PS> 'notepad'|Stop-Process
  Stop-Process: The input object cannot be bound to any parameters for the command either because the command does not take pipeline input or the input and its properties do not match any of the parameters that take pipeline input.
  ```

  - 输入对象无法绑定到该命令的任何参数，原因可能是该命令不接受管道输入，或者输入及其属性与接受管道输入的任何参数都不匹配。

  - 在这个例子中，语句尝试传递一个字符串`notepad`给`stop-process`,我们可以猜测其意图是杀死所有名为`notepad`的进程,然而`stop-process`不支持这种用法,不会达到以下语句的效果

    - ```powershell
      stop-process -name 'notepad'
      ```

  - 在`stop-process`的所有参数中,有3个参数会尝试绑定来自管道符的输入,正如文档指出的,`Id,InputObject,Name`三个参数,并且都有各自的类型要求,注明在了文档中

    - 其中`Id`和`Name`都是ByPropertyName类型的,而`InputObject`优先级高,是ByValue型的
    - 上述反面例子中,管道符前的字符串`notepad`不是`InputObject`要求的类型,因此不会被绑定到`InputObject`
    - 而`notepad`作为字符串对象,没有`Id`和`Name`属性,自然也不会绑定到`Id`和`Name`参数

  - 综上,字符串作为管道符传递给`stop-process`必然报错

- 事实上,`stop-process`第一个默认的位置参数是`Id`,也就是进程号,而不是进程对应的程序名字
  - 这是合理的,因为一个程序可能有多个运行示例,例如notepad被打开多个进程,而我们要关闭notepad时可能要保留其中的一个或者只想关闭其中的具体某一个,为了防止轻易关闭所有进程造成误杀,因此要显式使用`-Name`参数指出您确实想要关闭所有具有指定程序名字的进程
  - 否则您应该通过`get-process`来查看相关进程,然后记住或者复制Id号,执行`stop-process <Id>`

#### 应用:get-process 和stop-process配合

- 假设有以下对象

  - ```powershell
    PS> $pss=get-process notepad
    PS>$pss
    
     NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
     ------    -----      -----     ------      --  -- -----------
         47    73.11     117.62       0.17   12772   1 Notepad
         13     2.83      12.51       0.00   13768   1 Notepad
    ```

- 我们看看`$pss`对象能否传递给`stop-process`这个cmdlet呢?

  - 利用`Get-Member`(alias:`gm`)来检查`$pss`对象的成员(属性,成员函数等),这个输出通常是比较长的

    - 事实上,传递给`gm`的如果是一个容器类型(比如数组),那么`gm`返回的是容器保存的对象的类型

    - 例如某个变量是包含2个字符串的数组,那么传给`gm`返回的是字符串类型的成员列表

    - 我们检查以下`$pss`是什么类型,调用对象的`.GetType()`方法即可

      ```bash
      PS> $pss.GetType()
      
      IsPublic IsSerial Name                                     BaseType
      -------- -------- ----                                     --------
      True     True     Object[]                                 System.Array
      ```

      - 可以看到,`$pss`的类型是一个数组(可迭代对象)

  - 这里看看`$pss`数组中的对象有哪些成员,以便于我们对`$pss`进一步处理,比如便利迭代等操作

    ```powershell
    PS C:\Users\cxxu\Desktop> $pss|gm
    
       TypeName: System.Diagnostics.Process
    
    Name                       MemberType     Definition
    ----                       ----------     ----------
    Handles                    AliasProperty  Handles = Handlecount
    Name                       AliasProperty  Name = ProcessName
    NPM                        AliasProperty  NPM = NonpagedSystemMemorySize64
    PM                         AliasProperty  PM = PagedMemorySize64
    SI                         AliasProperty  SI = SessionId
    VM                         AliasProperty  VM = VirtualMemorySize64
    WS                         AliasProperty  WS = WorkingSet64
    Parent                     CodeProperty   System.Object Parent{get=GetParentProcess;}
    Disposed                   Event          System.EventHandler Disposed(System.Object…
    ErrorDataReceived          Event          System.Diagnostics.DataReceivedEventHandle…
    Exited                     Event          System.EventHandler Exited(System.Object, …
    OutputDataReceived         Event          System.Diagnostics.DataReceivedEventHandle…
    BeginErrorReadLine         Method         void BeginErrorReadLine()
    BeginOutputReadLine        Method         void BeginOutputReadLine()
    CancelErrorRead            Method         void CancelErrorRead()
    ...
    Id                         Property       int Id {get;}
    MachineName                Property       string MachineName {get;}
    MainModule                 Property       System.Diagnostics.ProcessModule MainModul…
    MainWindowHandle           Property       System.IntPtr MainWindowHandle {get;}
    ...
    ```

  - 我们可以利用`group`来统计一下结果,比如我们`gm`返回的结果,按照对象的成员的各种类型来统计

    - ```powershell
      PS> $pss|gm |group -Property MemberType
      
      Count Name                      Group
      ----- ----                      -----
          7 AliasProperty             {Handles = Handlecount, Name = ProcessName, NPM = No…
          1 CodeProperty              {System.Object Parent{get=GetParentProcess;}}
         52 Property                  {int BasePriority {get;}, System.ComponentModel.ICon…
          1 NoteProperty              {string __NounName=Process}
          8 ScriptProperty            {System.Object CommandLine {get=…
          2 PropertySet               {PSConfiguration {Name, Id, PriorityClass, FileVersi…
         19 Method                    {void BeginErrorReadLine(), void BeginOutputReadLine…
          4 Event                     {System.EventHandler Disposed(System.Object, System.…
      
      ```

    - 可以看到,`$pss`中的对象包含的成员的类型有8种,最重要的两类是Property,Method

  - ```powershell
    PS C:\Users\cxxu\Desktop> $pss|gm |?{$_.Name -eq 'Id'}
    
       TypeName: System.Diagnostics.Process
    
    Name MemberType Definition
    ---- ---------- ----------
    Id   Property   int Id {get;}
    ```

  - 回到`stop-process`,经过上面的操作可知,`get-process`返回的对象(如果是数组,自动迭代其中的元素)包含了名为`Id`的属性,那么可以通过管道接受`Get-Process`的输出

    - ```bash
      PS> $pss|Stop-Process
      ```

    - 上述命令会杀死所有`$pss`中列出的进程,仿佛执行的是

      - ```powershell
        foreach ($p in $pss){
            stop-process -id $p.Id
        }
        ```

- 处理上面的`$pss`是一个包含多个进程对象的数组情况以外,也可以处理单个进程的情况

  - 例如

    ```powershell
    PS[BAT:84%][MEM:37.91% (12.02/31.70)GB][21:36:45]
    # [~\Desktop]
    PS> ps gopeed
    
     NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
     ------    -----      -----     ------      --  -- -----------
         51   147.82     155.86     223.50   16432   1 gopeed
    
    
    PS[BAT:84%][MEM:37.91% (12.02/31.70)GB][21:36:47]
    # [~\Desktop]
    PS> $p=ps gopeed
    
    PS[BAT:84%][MEM:37.91% (12.02/31.70)GB][21:37:03]
    # [~\Desktop]
    PS> $p
    
     NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
     ------    -----      -----     ------      --  -- -----------
         52   148.82     157.17     223.62   16432   1 gopeed
    
    
    PS[BAT:84%][MEM:37.91% (12.02/31.70)GB][21:37:04]
    # [~\Desktop]
    PS> $p.GetType()
    
    IsPublic IsSerial Name                                     BaseType
    -------- -------- ----                                     --------
    True     False    Process                                  System.ComponentModel.Com…
    
    
    PS[BAT:84%][MEM:37.90% (12.02/31.70)GB][21:37:10]
    # [~\Desktop]
    PS> $p|gm
    
       TypeName: System.Diagnostics.Process
    
    Name                       MemberType     Definition
    ----                       ----------     ----------
    Handles                    AliasProperty  Handles = Handlecount
    Name                       AliasProperty  Name = ProcessName
    NPM                        AliasProperty  NPM = NonpagedSystemMemorySize64
    PM                         AliasProperty  PM = PagedMemorySize64
    
    ...
    ```

    

​	