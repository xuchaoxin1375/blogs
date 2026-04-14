[toc]



## 在命令行中运行mysql导入sql文件|运行sql文件操作

利用`cmd /c`执行mysql查询命令,尤其是从指定sql文件导入sql语句;

在 PowerShell 中，**输入重定向**（Input Redirection）的使用频率通常比输出重定向低，因为 PowerShell 的核心逻辑是基于**管道（Pipeline）**的对象传递。

虽然powershell支持一系列输出重定向(例如`>,>>`等),但是对于输入重定向支持的不向传统shell那样,`<`目前还是保留符号;

```powershell
 cat < .\table-s1.conf
ParserError:
Line |
   1 |  cat < .\table-s1.conf
     |      ~
     | The '<' operator is reserved for future use.
```



### powershell内用cmd 包装命令行

以内联sql语句的方式执行查询:



```powershell

PS> write-host cmd /c "mysql -uroot -h 23.110.230.202 < `"$home/desktop/BatchSiteDBCreate-zw.sql`" "

cmd /c mysql -uroot -h 23.110.230.202 < "C:\Users\Administrator/desktop/BatchSiteDBCreate-zw.sql"

```

这种方式执行比较严格,而且在**powershell**中套变量等操作容易让语句结构变得复杂;

```powershell

PS> cmd /c "mysql -uroot -h 23.110.230.202 < `"$home/desktop/BatchSiteDBCreate-zw.sql`" "

```

注意,上面的例子中,`<`符号右侧的是一个路径`$home/desktop/BatchSiteDBCreate-zw.sql`,路径中为了防止路径中包含空格导致错误,这里为其安排了一对引号,而且是**双引号**(**单引号**不行,因为语句被传递到`cmd`中执行)

> 在 Windows CMD 中，**双引号 `"`** 是唯一具有特殊功能（处理空格和部分特殊字符）的引号;如果你在 CMD 中使用单引号包裹路径或字符串，它会产生以下后果：
>
> - **视为普通字符：** CMD 会把单引号当作文件名或文本的一部分。
> - **路径报错：** 比如 `cd 'C:\Program Files'` 会报错，因为 CMD 认为文件夹名字开头和结尾真的带有一个 `'` 字符。

而且为了在powershell中利用字符串变量插值,所以这个串放在了一对双引号中

而且`<`要防止被powershell解释为运算符号,需要放在字符串中避免被错误解释

还可以稍微借助`()`运算包裹内部的字符串链接运算,稍微简化一下语句结构,分为前后两部分

```powershell
 cmd /c ("mysql -uroot -h 23.110.230.202 < " + " `"$home/desktop/BatchSiteDBCreate-zw.sql`" ")
```

```powershell
cmd /c ("mysql -uroot -h 23.110.230.202 < " + '"' + "$home/desktop/BatchSiteDBCreate-zw.sql" + '"')
```



### 管道的方式指定sql查询

```bash
(base) #Admin[Administrator@CXXUDESK][C:\repos\scripts][11:44:07]{Git:main} PS >
 echo "select 1;"|mysql
1
1

```

从sql文件文件读sql语句执行查询

```powershell
(base) #Admin[Administrator@CXXUDESK][C:\repos\scripts][11:44:18]{Git:main} PS >
 cat 'C:\Users\Administrator\Desktop\demo 1.sql'|mysql -u root -h localhost
1
1
```



## 参考资料(未完全验证)

### powershell和mysql运行sql文件

在 PowerShell 中，`<` 是一个 **重定向操作符**，它通常用于将文件内容作为输入传递给命令，但在 PowerShell 中可能会引发解析错误或无法正确执行 MySQL 命令。

### **解决方案**

你可以使用以下几种方式来正确执行 `mysql` 命令，并避免 PowerShell 误解析 `<`。

------

### **方法 1：使用 `Get-Content` 和管道 `|`**

PowerShell 允许使用 `Get-Content` 读取 SQL 文件内容，并通过管道 `|` 传递给 `mysql` 命令：

```powershell
Get-Content "C:\path\to\create_db.sql" | mysql -u root -p
```

**说明：**

- `Get-Content "C:\path\to\create_db.sql"` 读取 SQL 文件内容。
- `| mysql -u root -p` 通过管道 `|` 将内容传递给 MySQL。

> **注意**：这可能不适用于大文件，因为 `Get-Content` 可能会一次性加载整个文件。

------

### **方法 2：使用 `cmd.exe /c`**

你可以在 PowerShell 中调用 `cmd.exe /c`，让它解析 `mysql` 命令：

```powershell
cmd.exe /c "mysql -u root -p < C:\path\to\create_db.sql"
```

**说明：**

- `cmd.exe /c` 让 PowerShell 运行 `cmd` 解释器，并执行命令。
- 这样 `<` 就会被 `cmd.exe` 识别为输入重定向，而不会被 PowerShell 误解。

------

### 方法 3：使用 `Start-Process`

如果你希望更精确地控制进程，可以使用 `Start-Process`：

```powershell
Start-Process mysql -ArgumentList "-u root -p < C:\path\to\create_db.sql" -NoNewWindow -Wait
```

**说明：**

- `Start-Process` 启动 `mysql` 进程。
- `-ArgumentList` 传递参数。
- `-NoNewWindow` 让命令运行在当前 PowerShell 窗口中，而不是打开新窗口。
- `-Wait` 让 PowerShell 等待 `mysql` 命令执行完再继续。

------

### **方法 4：使用 `Invoke-Expression`**

```powershell
Invoke-Expression 'mysql -u root -p < "C:\path\to\create_db.sql"'
```

**说明**：

- `Invoke-Expression` 让 PowerShell 直接解析字符串命令。
- 适用于简单场景，但可能会有安全风险（容易受到代码注入攻击）。

------

## 最佳方案

推荐 **方法 2（使用 `cmd.exe /c`）**，因为它最接近 Linux/Windows CMD 的行为，同时不会有 `Get-Content` 可能导致大文件加载慢的问题。

**示例最终推荐命令：**

```powershell
cmd.exe /c "mysql -u root -p < C:\path\to\create_db.sql"
```

这样可以在 PowerShell 中正确执行 `mysql` 命令并加载 SQL 文件 🎯。