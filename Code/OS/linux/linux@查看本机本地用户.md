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

## 仅提取用户名

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

按字母排序：

```bash
cut -d: -f1 /etc/passwd | sort
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



## 像powershell的Get-LocalUser 一样显示用户信息

Linux 没有完全统一的 `Get-LocalUser`，但可以组合 `/etc/passwd`、`getent`、`passwd -S`，得到很直观的表格。



```bash
awk -F: '
BEGIN {
    printf "%-20s %-8s %-8s %-30s %s\n",
           "NAME", "UID", "GID", "HOME", "SHELL"
}
{
    printf "%-20s %-8s %-8s %-30s %s\n",
           $1, $3, $4, $6, $7
}' /etc/passwd
```

输出类似：

```text
NAME                 UID      GID      HOME                           SHELL
root                 0        0        /root                          /bin/bash
daemon               1        1        /usr/sbin                      /usr/sbin/nologin
alice                1000     1000     /home/alice                    /bin/bash
postgres             113      119      /var/lib/postgresql            /bin/bash
```

也可以借助 `column` 自动对齐：

```bash
printf 'NAME:UID:GID:HOME:SHELL\n'
awk -F: '{print $1 ":" $3 ":" $4 ":" $6 ":" $7}' /etc/passwd
```

将两部分组合：

```bash
{
    printf 'NAME:UID:GID:HOME:SHELL\n'
    awk -F: '{print $1 ":" $3 ":" $4 ":" $6 ":" $7}' /etc/passwd
} | column -t -s:
```

## 推荐脚本：区分普通用户和系统用户

下面的脚本会读取系统配置中的 `UID_MIN`，将账户粗略分为：

- `root`
- `human`：通常由人登录使用
- `system`：通常供服务或系统组件使用

```bash
#!/usr/bin/env bash

set -euo pipefail

uid_min=$(
    awk '
        $1 == "UID_MIN" && $2 ~ /^[0-9]+$/ {
            value = $2
        }
        END {
            print value
        }
    ' /etc/login.defs 2>/dev/null
)

uid_min=${uid_min:-1000}

{
    printf 'NAME:UID:GID:TYPE:HOME:SHELL\n'

    awk -F: -v uid_min="$uid_min" '
        {
            if ($3 == 0) {
                type = "root"
            } else if ($3 >= uid_min) {
                type = "human"
            } else {
                type = "system"
            }

            print $1 ":" $3 ":" $4 ":" type ":" $6 ":" $7
        }
    ' /etc/passwd
} | column -t -s:
```

保存并执行：

```bash
nano local-users.sh
chmod +x local-users.sh
./local-users.sh
```

输出类似：

```text
NAME      UID   GID   TYPE    HOME                  SHELL
root      0     0     root    /root                 /bin/bash
daemon    1     1     system  /usr/sbin             /usr/sbin/nologin
postgres  113   119   system  /var/lib/postgresql   /bin/bash
alice     1000  1000  human   /home/alice           /bin/bash
bob       1001  1001  human   /home/bob             /bin/zsh
```

需要注意，UID 分类只是惯例，不是严格安全规则。管理员可以创建 UID 较高的服务账户，也可以创建 UID 较低的特殊账户。

## 只显示普通用户

### 从/etc/login.defs获取信息

```bash
uid_min=$(awk '$1 == "UID_MIN" {print $2}' /etc/login.defs | tail -n1)
uid_min=${uid_min:-1000}

awk -F: -v min="$uid_min" '
    $3 >= min && $3 != 65534 {
        printf "%-20s UID=%-8s HOME=%-30s SHELL=%s\n",
               $1, $3, $6, $7
    }
' /etc/passwd
```

### 根据用户id判断

其中排除了常见的 `nobody` 账户，其 UID 经常是 `65534`。

更紧凑的版本：

```bash
awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd
```

但硬编码 `1000` 不一定适用于所有系统，因此读取 `/etc/login.defs` 更可靠。

## 只显示能够交互登录的账户

许多系统账户使用以下 Shell 禁止登录：

```text
/usr/sbin/nologin
/sbin/nologin
/bin/false
```

可以排除这些账户：

```bash
awk -F: '
    $7 !~ /(nologin|false)$/ {
        printf "%-20s %-8s %-30s %s\n",
               $1, $3, $6, $7
    }
' /etc/passwd
```

不过，这也只是筛选“Shell 看起来允许登录”的账户。账户仍可能因为以下原因无法登录：

- 密码已锁定
- 没有设置密码
- SSH 策略禁止
- PAM 策略禁止
- 登录 Shell 文件不存在
- 账户已过期
- 仅允许密钥认证

## 查看账户是否锁定

在多数 Linux 发行版上，可以使用：

```bash
sudo passwd -Sa
```

有些系统要求写成：

```bash
sudo passwd -S -a
```

输出示例：

```text
root L 2026-01-10 0 99999 7 -1
alice P 2026-05-20 0 99999 7 -1
service L 2026-04-01 0 99999 7 -1
```

常见状态：

| 状态 | 含义           |
| ---- | -------------- |
| `P`  | 已设置可用密码 |
| `L`  | 密码已锁定     |
| `NP` | 没有密码       |

这里描述的是密码状态，不一定代表账户整体是否能够登录。例如，密码被锁定的账户仍可能允许 SSH 公钥登录，具体取决于系统配置。

查看单个用户：

```bash
sudo passwd -S alice
```

## 更接近 Get-LocalUser 的完整脚本

该脚本显示账户名称、UID、类型、密码状态、主目录和 Shell：

```bash
#!/usr/bin/env bash

set -euo pipefail

uid_min=$(
    awk '
        $1 == "UID_MIN" && $2 ~ /^[0-9]+$/ {
            value = $2
        }
        END {
            print value
        }
    ' /etc/login.defs 2>/dev/null
)

uid_min=${uid_min:-1000}

declare -A password_status

if [[ $EUID -eq 0 ]]; then
    while read -r user status _; do
        password_status["$user"]=$status
    done < <(passwd -Sa 2>/dev/null || passwd -S -a 2>/dev/null || true)
fi

{
    printf 'NAME:UID:TYPE:PASSWORD:HOME:SHELL\n'

    while IFS=: read -r name _ uid _ _ home shell; do
        if (( uid == 0 )); then
            type="root"
        elif (( uid >= uid_min && uid != 65534 )); then
            type="human"
        else
            type="system"
        fi

        status=${password_status[$name]:-unknown}

        case "$status" in
            P)
                status="set"
                ;;
            L|LK)
                status="locked"
                ;;
            NP)
                status="none"
                ;;
        esac

        printf '%s:%s:%s:%s:%s:%s\n' \
            "$name" "$uid" "$type" "$status" "$home" "$shell"
    done < /etc/passwd
} | column -t -s:
```

以 root 权限运行可以显示密码状态：

```bash
sudo ./local-users.sh
```

普通用户运行时，密码状态通常显示为 `unknown`：

```bash
./local-users.sh
```

## `/etc/passwd` 和 `getent passwd` 的区别

这是“本机用户”查询中特别重要的区别。

| 命令                  | 数据来源                 | 适用场景                 |
| --------------------- | ------------------------ | ------------------------ |
| `cat /etc/passwd`     | 仅本机文件               | 查真正的本地账户         |
| `getent passwd`       | NSS 配置的全部身份源     | 查系统能够识别的所有账户 |
| `getent passwd alice` | NSS 中指定用户           | 查询单个账户             |
| `compgen -u`          | Shell 可识别的用户名来源 | 快速列用户名             |

如果机器接入了以下系统：

- LDAP
- Active Directory
- SSSD
- NIS
- systemd 用户数据库

那么：

```bash
getent passwd
```

可能同时列出本地账户和远程目录账户。

因此，严格意义上的“本机用户”应使用：

```bash
cat /etc/passwd
```

或解析该文件。

而“这台机器当前能识别的所有用户”应使用：

```bash
getent passwd
```

直观显示所有可识别用户：

```bash
{
    printf 'NAME:UID:GID:HOME:SHELL\n'
    getent passwd |
        awk -F: '{print $1 ":" $3 ":" $4 ":" $6 ":" $7}'
} | column -t -s:
```

## 查询单个用户

查询所有身份源：

```bash
getent passwd alice
```

只检查是否存在本地账户：

```bash
grep '^alice:' /etc/passwd
```

脚本中更严谨的本地账户判断：

```bash
if getent passwd alice >/dev/null; then
    echo "系统能够识别 alice"
fi

if grep -q '^alice:' /etc/passwd; then
    echo "alice 是 /etc/passwd 中的本地账户"
fi
```

## 实用推荐

日常查看本机账户，推荐：

```bash
{
    printf 'NAME:UID:GID:HOME:SHELL\n'
    awk -F: '{print $1 ":" $3 ":" $4 ":" $6 ":" $7}' /etc/passwd
} | column -t -s:
```

只看普通用户，推荐：

```bash
uid_min=$(awk '$1 == "UID_MIN" {value=$2} END {print value}' /etc/login.defs)
uid_min=${uid_min:-1000}

awk -F: -v min="$uid_min" '
    $3 >= min && $3 != 65534 {
        print $1, $3, $6, $7
    }
' /etc/passwd | column -t
```

需要类似 `Get-LocalUser` 的账户状态报告，使用上面的完整脚本并通过 `sudo` 执行。
