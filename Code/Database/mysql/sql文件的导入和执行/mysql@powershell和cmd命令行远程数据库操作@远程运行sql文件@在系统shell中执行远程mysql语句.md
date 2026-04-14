[toc]

## abstract

在命令行中运行mysql导入sql文件|运行sql文件操作

## 类unix

在类unix系统上的常用Shell（主要是 Linux/Unix 境下的 Bash，也包括 macOS）中执行 MySQL 查询有多种灵活的方法。

> powershell(pwsh)风格与bash等`*nix shell`差异较大,写法在下一节说明;



------

###  命令行直接执行 (`-e` 参数)

这是最常用的方式，适用于执行单条或简单的多条语句。

```Bash
mysql -u root -p'password' -e "SELECT NOW();" database_name
```

- **`-u`**: 用户名。
- **`-p`**: 密码（建议在脚本中使用变量或配置文件以提高安全性）。
- **`-e`**: 执行 SQL 语句并立即退出。

------

###  使用标准输入 (Standard Input)

通过重定向或管道将 SQL 语句传递给 `mysql` 客户端。

#### A. 管道方式 (`echo` / `printf`)

适用于动态生成的简单查询：

```Bash
echo "SELECT * FROM users LIMIT 5;" | mysql -u root -p'password' db_name
```

#### B. Here-Doc 方式 (推荐用于脚本)

如果你有多行 SQL 语句，这种方式最清晰：

```Bash
mysql -u root -p'password' db_name <<EOF
...
...
EOF
```

------

###  执行 SQL 脚本文件

当你有一个现成的 `.sql` 文件时，可以使用以下两种方式：

#### A. 输入重定向 (`<`)

这是执行备份恢复或大型脚本的标准做法：

```Bash
mysql -u root -p'password' db_name < /path/to/script.sql
```

#### B. 进入交互模式后执行 (`source`)

如果你已经在 MySQL 提示符下，或者在 `-e` 可以执行`source`命令来运行指定sql文件中的语句：

```Bash
mysql -u root -p'password' -e "source /path/to/script.sql" db_name
```

------

如果路径中有空格,source也可以识别,不需要额外添加引号包裹(条件允许的话,文件名最好不要包含空格);

对于windows,可以使用`/`或`\`来分割路径

```bash
mysql> source C:\users\administrator\desktop\demo 1.sql
+---+
| 1 |
+---+
| 1 |
+---+
1 row in set (0.00 sec)

mysql> source C:/users/administrator/desktop/demo 1.sql
+---+
| 1 |
+---+
| 1 |
+---+
1 row in set (0.00 sec)

```

不进入mysql shell中使用`-e`也可以执行`source`语句:

```bash
 mysql -e "source $desktop/demo 1.sql"
+---+
| 1 |
+---+
| 1 |
+---+
```

> 这里配置了免密,可以只用`-e`选项

###  格式化输出结果

在 Shell 中，你可能需要将结果用于后续处理，可以通过参数控制输出格式：

- **`-N` (Skip Column Names)**: 不显示列名。
- **`-s` (Silent)**: 静默模式，去掉表格边框（通常与 `-N` 配合使用）。
- **`-H` (HTML)**: 输出为 HTML 表格。
- **`-X` (XML)**: 输出为 XML 格式。

**示例：只获取一个纯净的值（用于赋值给变量）**

```bash
user_count=$(mysql -u root -p'password' -N -s -e "SELECT COUNT(*) FROM users" db_name)
echo "当前用户总数是: $user_count"
```

------

###  安全性：使用配置文件 (`.my.cnf`)

在 Shell 脚本中明文写密码会触发警告：`mysql: [Warning] Using a password on the command line interface can be insecure.`

**解决方案：**

在用户家目录创建 `~/.my.cnf` 文件：

```ini
[client]
user=root
password=your_secure_password
```

然后修改权限：`chmod 600 ~/.my.cnf`。

之后你在 Shell 中直接执行 `mysql -e "..."` 就不再需要手动输入用户名和密码。

------

### 总结对比表

| **场景**     | **推荐方法**           | **特点**                |
| ------------ | ---------------------- | ----------------------- |
| **单条命令** | `mysql -e "SQL"`       | 快速、直接              |
| **多行语句** | `<<EOF (Here-Doc)`     | 脚本可读性最好          |
| **执行文件** | `mysql < script.sql`   | 适合处理大数据量        |
| **变量赋值** | `mysql -N -s -e "SQL"` | 方便 Shell 获取纯净结果 |

你是准备将这些命令集成到自动化部署脚本（如 CI/CD）中，还是仅仅用于日常的数据库维护？

## windows

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
