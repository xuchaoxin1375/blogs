[toc]

## abstract

在 Ubuntu 系统中，有多种方法可以列出当前系统上的所有用户。最常用和直接的方法是查看系统账户文件。

---

### 查看 `/etc/passwd` 文件（推荐）

这是最标准的方法，该文件包含了系统中所有用户的基本信息。
```bash
cat /etc/passwd
```
这会列出所有用户，包括系统用户（如 `root`, `daemon`, `www-data` 等）和普通用户。

**输出格式**：
每行代表一个用户，格式为 `用户名:密码占位符:UID:GID:描述:家目录:登录Shell`。
例如：
```bash
root:x:0:0:root:/root:/bin/bash
alice:x:1000:1000:Alice Smith,,,:/home/alice:/bin/bash
bob:x:1001:1001:Bob Jones,,,:/home/bob:/bin/bash
```



这个列表可能很长,如果要查询是否存在自己感兴趣的用户名,可以配合过滤,例如查询是否存在用户名cxxu

```bash
cat /etc/passwd|grep cxxu
cxxu:x:1004:1005:cxxu,cxxu,,:/home/cxxu:/bin/bash
```



---

### 仅提取用户名

如果您只想看用户名列表，可以使用 `cut` 命令从 `/etc/passwd` 中提取第一列：
```bash
cut -d: -f1 /etc/passwd
```
*   `-d:` 指定分隔符为冒号 `:`
*   `-f1` 表示提取第一列（即用户名）

同样可以查询用户(比如cxxu)

```bash
#( 09/14/25@ 9:15AM )( root@s1 ):~
   cut -d: -f1 /etc/passwd |grep cxxu
cxxu
```



---

### 使用 `getent` 命令

`getent` 是一个更通用的命令，用于从系统数据库（如 `passwd`）中获取条目。
```bash
getent passwd
```
它的输出与 `cat /etc/passwd` 相同。

同样，可以只提取用户名：
```bash
getent passwd | cut -d: -f1
```

---

### 列出“普通用户”（UID >= 1000）

系统用户通常有较低的 UID（如 0-999），而新创建的普通用户 UID 通常从 1000 开始。可以使用以下命令过滤出普通用户：
```bash
getent passwd | awk -F: '$3 >= 1000 { print $1 }'
```
*   `awk -F:` 使用冒号作为分隔符。
*   `$3 >= 1000` 检查第三列（UID）是否大于等于 1000。
*   `{ print $1 }` 如果条件满足，则打印第一列（用户名）。

> **注意**：这个方法在大多数 Ubuntu/Debian 系统上有效，但并非绝对标准。有些系统可能有不同的 UID 分配策略。



