[toc]



在 Windows 中安装多个不同版本的 MySQL（例如同时安装 5.7 和 8.0），是完全可行的，但需要注意一些配置和环境管理问题，否则会引起冲突或数据损坏。

[Windows10 下安装mysql5.6,mysql5.7,mysql8并同时运行_mysql8和mysql5.6共存-CSDN博客](https://blog.csdn.net/wnw001/article/details/104537137)

------

### 安装多个 MySQL 版本的核心注意事项

| 项目                             | 说明                                                        | 示例                                               |
| -------------------------------- | ----------------------------------------------------------- | -------------------------------------------------- |
| 安装目录                         | 不同版本必须安装在不同目录                                  | 如：`C:\MySQL\mysql-5.7\` 和 `C:\MySQL\mysql-8.0\` |
| 数据目录（datadir）              | 每个版本独立数据目录，不能共享                              | `C:\MySQL\mysql-5.7\data\`                         |
| 配置文件（my.ini）               | 每个版本需对应一个独立配置文件                              | 指定不同端口、不同 socket                          |
| 服务名称（Windows Service Name） | 必须不同，否则安装时会冲突                                  | 如：`MySQL57` 与 `MySQL80`                         |
| 端口号（port）                   | 每个版本监听不同端口（默认3306只能给一个）                  | 如：`3306` 给 5.7，`3307` 给 8.0                   |
| 环境变量                         | 系统 PATH 中不能同时包含多个版本的 bin 路径（会混乱）       | 推荐临时用 cmd 进入特定版本 bin 路径操作           |
| 管理工具                         | 如用 MySQL Workbench、Navicat，要指定连接端口，避免连错版本 | Workbench 新建连接时填正确的端口号                 |

------

### 步骤建议

以安装 MySQL 5.5或5.7 或 8.0 为例

#### 1. 安装 MySQL 5.5或5.7

- 解压 ZIP 版或使用安装器。
- 安装在：`C:\MySQL\mysql-5.7\`
- 创建 `my.ini` 文件，内容如下（示例）：

```ini
[mysqld]
port=3306
basedir="C:/MySQL/mysql-5.7"
datadir="C:/MySQL/mysql-5.7/data"
default-storage-engine=INNODB
sql-mode="STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION"
log-error="mysql57.err"
server-id=1
```

- 安装服务：

```bash
mysqld --install MySQL57 --defaults-file="C:\MySQL\mysql-5.7\my.ini"
```

又比如mysql55

```powershell
mysqld --install MySQL55 --defaults-file="C:\phpstudy_pro\Extensions\MySQL5.5.29\my.ini"
```



- 初始化数据库（第一次）：

```bash
mysqld --initialize --console --defaults-file="C:\MySQL\mysql-5.7\my.ini"
```

#### 2. 安装 MySQL 8.0

- 同样解压并放在：`C:\MySQL\mysql-8.0\`
- `my.ini` 示例：

```ini
[mysqld]
port=3307
basedir="C:/MySQL/mysql-8.0"
datadir="C:/MySQL/mysql-8.0/data"
default-authentication-plugin=mysql_native_password
log-error="mysql80.err"
server-id=2
```

#### 安装服务：

```bash
mysqld --install MySQL80 --defaults-file="C:\MySQL\mysql-8.0\my.ini"
```





#### 初始化

根据需要进行初始化

```bash
mysqld --initialize --console --defaults-file="C:\MySQL\mysql-8.0\my.ini"
```

```powershell
mysqld --initialize --console --defaults-file="C:\phpstudy_pro\Extensions\MySQL5.5.29\my.ini"
```

初始化要求指定的data目录是空的,否则会报错:

```bash
2025-04-18T09:30:59.740194Z 0 [ERROR] --initialize specified but the data directory has files in it. Aborting.
2025-04-18T09:30:59.741623Z 0 [ERROR] Aborting

```



#### 移除服务

这里使用powershell来移除服务,例如移除前面安装的mysql55服务

```powershell
 Remove-Service -Name mysql55
```

正常情况下,没有返回信息

#### 3. 启动服务

```bash
net start MySQL57
net start MySQL80
```

或通过 `services.msc` 图形界面手动管理。

#### 服务检查

```powershell
gsv *mysql*|select name,ServiceName,DisplayName,binarypathname,status,StartType
```

```powershell
PS> gsv *mysql*

Status   Name               DisplayName
------   ----               -----------
Running  MySQL              MySQL
Stopped  wampmysqld64       wampmysqld6

#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL5.5.29][17:34:54][UP:15.96Days]
PS> gsv *mysql*|select name,ServiceName,DisplayName,binarypathname,status,StartType

Name           : MySQL
ServiceName    : MySQL
DisplayName    : MySQL
BinaryPathName : C:\phpstudy_pro\Extensions\MySQL5.7.26\bin\mysqld.exe MySQL
Status         : Running
StartType      : Automatic

Name           : wampmysqld64
ServiceName    : wampmysqld64
DisplayName    : wampmysqld64
BinaryPathName : c:\wamp64\bin\mysql\mysql9.1.0\bin\mysqld.exe wampmysqld64
Status         : Stopped
StartType      : Manual
```

以下命令可以查看最完整的信息

```powershell
gsv *mysql*|select *
```

## 从小皮安装便携版mysql

从小皮工具箱(phpstudy)中下载需要的数据库版本(几个经典版本都有)

小皮中只允许你一次启动一个数据库,但是我们可以绕过小皮,自己管理数据库,仅仅使用小皮来下载不同版本的mysql数据库

安装并启用mysql5.5

```powershell

#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL5.5.29\bin][18:14:25][UP:15.99Days]
PS> Remove-Service -Name mysql55

#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL5.5.29\bin][18:14:27][UP:15.99Days]
PS> .\mysqld.exe --install MySQL55 --defaults-file="C:\phpstudy_pro\Extensions\MySQL5.5.29\my.ini"
Service successfully installed.

#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL5.5.29\bin][18:14:29][UP:15.99Days]
PS> net start mysql55
MySQL55 服务正在启动 .
MySQL55 服务已经启动成功。



```

类似的,可以安装启动mysql8.0

```powershel

#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL5.5.29\bin][18:16:54][UP:15.99Days]
PS> cd C:\phpstudy_pro\Extensions\MySQL8.0.12\bin\

#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL8.0.12\bin][18:22:08][UP:16Days]
PS> .\mysqld.exe --install MySQL80 --defaults-file="C:\phpstudy_pro\Extensions\MySQL8.0.12\my.ini"
Service successfully installed.

#⚡️[Administrator@CXXUDESK][C:\phpstudy_pro\Extensions\MySQL8.0.12\bin][18:22:38][UP:16Days]
PS> net start mysql80
MySQL80 服务正在启动 .
MySQL80 服务已经启动成功。
```



------

### 环境变量使用建议

不要把两个版本的 `bin` 同时加进系统 `PATH` 环境变量！建议你用“特定版本的 cmd 窗口”来操作，比如：

```cmd
cd C:\MySQL\mysql-5.7\bin
mysql -u root -p -P3306
```

------

### MySQL Workbench/Navicat 示例设置

- 连接 5.7：端口填 `3306`
- 连接 8.0：端口填 `3307`
- 建议命名连接如 `MySQL57@3306` 便于识别

------

### 可能遇到的问题

| 问题                                    | 原因                                        | 解决方案                          |
| --------------------------------------- | ------------------------------------------- | --------------------------------- |
| 服务无法启动                            | 配置文件冲突或端口被占用                    | 检查 `my.ini`，换个端口           |
| 登录报错                                | 密码认证方式不同（8.0 默认是 caching_sha2） | 指定 `mysql_native_password` 插件 |
| 启动时报错 `The service already exists` | 服务名重复                                  | 修改安装命令中的服务名            |

------

### 总结建议

- 使用 ZIP 版安装更灵活。
- 配置文件、端口、服务名必须区分。
- 管理上建议使用脚本或 GUI 工具分版本管理。
- 不推荐在生产环境使用多个版本共存，适合测试或兼容性检查。

------

如你需要我写一个完整的 **双版本安装与配置脚本**，可以继续说，我可以直接生成批处理 `.bat` 或 PowerShell 脚本给你用。是否需要？