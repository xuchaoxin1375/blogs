[toc]





## 一、文档总体结构与背景

- 该手册指的是 **jail.conf** 的语法和配置规则。
- Fail2Ban 的配置分为四类文件：
  1. `fail2ban.conf` — 全局设置（例如日志、数据库等）
  2. `filter.d/*.conf` — 定义如何检测失败（“filter” 即过滤器）
  3. `action.d/*.conf` — 定义对被封 IP 的操作，比如封禁和解封命令（“action” 即动作）
  4. `jail.conf` — “监狱”（jail）配置，把 filter 和 action 组合起来，并指定监控哪些日志、封禁策略等。

------

## 二、配置文件格式与组织原则

- **.conf vs .local**
   配置文件中，`.conf` 文件是 Fail2Ban 自带的、默认提供的，不建议直接修改。推荐方式是通过 `.local` 文件来做定制化。这样升级时更安全。
- **目录优先级和加载顺序**
  - `jail.conf`（主配置）
  - `jail.d/*.conf`（按字母顺序）
  - `jail.local`（用户覆盖）
  - `jail.d/*.local`（按字母顺序）
  - 后加载的配置项会覆盖前面的（相同节 / 选项名）。这种机制使你可以在 local 文件中只写你想改动的部分。
- **变量插值（interpolation）**
  - 支持 Python 风格字符串插值：`%(name)s`。
  - 支持跨节引用：`%(section/parameter)s`。
  - `%(known/parameter)s`：引用 “已知的、最后一次定义”的值，这个机制让你在 `.local` 文件里扩展已有设置，而不是完全覆盖。
  - 对于 filter 或 action 的 “init” 参数（初始设置），也可以使用 `<known/parameter>` 语法进行扩展。
- **注释**
  - 使用 `#` 开始整行注释。
  - 使用 `; `（分号后加空格）作行内注释。但在某些老版本 Python 环境中（Python2.x），`; ` 只能用于第一行，因为库有 bug。

------

## 三、jail.conf（监狱 / Jail）配置项详解

在 `jail.conf` 或对应的 `.local` 文件里，每个 **监狱（jail）** 是一个节（section），节名通常就是 jail 名称，也可以有一个 `[DEFAULT]` 节定义通用默认值。以下是主要配置项和含义：

| 参数                 | 含义                                              | 说明 / 举例                                                  |
| -------------------- | ------------------------------------------------- | ------------------------------------------------------------ |
| `filter`             | 该 jail 所用的过滤器（filter）                    | 这个名字对应 `filter.d/` 下的 `.conf` 文件名（不带后缀） |
| `logpath`            | 要监控的日志文件路径                              | 可以是多个路径，用换行分隔。可使用通配符（globs），例如 `*.log`。但只有在启动时已存在的文件会被监控。 还可以在路径后加 `tail`，表示从日志末尾开始读取；默认行为是从头（head）开始。 **注意**：如果日志系统压缩相同消息（例如 rsyslog 的 “RepeatedMsgReduction”），可能会影响 Fail2Ban 检测，因此建议关闭这种压缩。 |
| `logencoding`        | 日志文件的编码                                    | 默认是 `"auto"`（使用系统 locale）。 |
| `logtimezone`        | 如果日志行中不包含时区，强制指定时区              | 例如 `UTC`, `UTC+0200`, `GMT-0100` 等。 |
| `banaction`          | 封禁动作                                          | 默认是 `iptables-multiport`。指定某个 jail 使用特定封禁策略。 |
| `banaction_allports` | 当监控所有端口（all-ports）的 jail 使用的封禁动作 | 与 `banaction` 类似，但适用于 “allports” 类型的 jail。 |
| `action`             | 定义一个或多个 action（动作）                     | Action 来自 `/etc/fail2ban/action.d/`（不带 `.conf` 或 `.local` 扩展名）可以传递参数给 action，例如 `action = iptables[name=ssh, port=sshd]`。如果指定多个 action，可以写多行。 |
| `ignoreself`         | 是否忽略自己（本机）IP                            | 布尔值（或 “true/false”），默认 `true`。防止把自己的 IP 封禁。 |
| `ignoreip`           | 指定不封禁的 IP 地址 / 网络                       | 可以写多个 IP，支持 DNS 名称或者 CIDR。即使 `ignoreself` 为 false，也可以通过这个选项排除某些地址。 |
| `ignorecommand`      | 通过命令决定是否忽略某个 IP                       | 指定一个命令（shell 脚本或命令），在决定封禁之前运行。命令返回状态码 0 则表示 “不要封禁”。在命令里可以使用 `<ip>` 等标签。 |
| `ignorecache`        | 缓存 ignore 结果                                  | 用于缓存 `ignoreip`、`ignoreself`、`ignorecommand` 的结果，减少重复执行命令。格式类似 `key="<F-USER>@<ip-host>", max-count=100, max-time=5m`。 |
| `bantime`            | 封禁持续时间                                      | 可以是秒数，也可以用时间缩写（如 `10m` 表示 10 分钟）。 |
| `findtime`           | 检测失败的时间窗口                                | 指定一个时间段（秒或缩写），在这个时间窗口内如果失败次数达到了 `maxretry`，就封禁。 |
| `maxretry`           | 最大失败次数                                      | 在 `findtime` 指定的时间窗口内，失败次数达到这个值则触发封禁。 |
| `backend`            | 日志监控后台方式                                  | 可选值有 `auto`（自动选择）、`pyinotify`、`gamin`、`polling`、`systemd` 等。默认是 `auto`。 `systemd` 模式下，不使用 `logpath`，而是用 systemd 日志（journal）匹配。 |
| `usedns`             | 是否解析主机名                                    | 如果日志里记录的是主机名而非 IP，这个选项决定是否进行 DNS 反向解析。默认是 `warn`（解析但警告），可以设为 `yes` 或 `no`。 |
| `prefregex`          | 日志前缀正则（prefix regex）                      | 一个正则表达式，用来先匹配日志行的通用部分（如时间戳、进程名等），再应用具体的 `failregex` / `ignoreregex`。 |
| `failregex`          | 捕获失败（fail）的正则表达式                      | 这是核心规则：定义哪些日志行代表 “失败（failed attempt）”。可以使用 filter 文件中定义的 failregex，再扩展或覆盖。 |
| `ignoreregex`        | 忽略某类日志行的正则                              | 如果一行日志既匹配 `failregex` 又匹配 `ignoreregex`，将被忽略。 |
| `maxmatches`         | 每个 ticket 能保存的最大匹配行数                  | 默认与 `maxretry` 一致。这个值还影响 action 模板里的 `<matches>` / `<ipmatches>` 之类标签。 |

------

## 四、后端（Backend）机制

- Fail2Ban 支持多种监控后端（backend）用来读取日志或接收事件： `pyinotify`、`gamin`、`systemd`、`polling`。
- `auto` 模式：Fail2Ban 会按顺序尝试 `pyinotify`、`gamin`、再 `polling`。
- 如果选择 `systemd` 后端：
  - `logpath` 选项无效，此时使用 `journalmatch`（在 filter 配置里定义）来匹配 systemd 日志。
  - 可以通过 `journalpath`、`journalfiles`、`journalflags` 等参数指定具体 journal 文件或标志。

------

## 五、动作（Action）机制

- 每个 jail 可以关联 **多个 action**（封禁、解封、检查等）。

- 默认 action 名字是 action 文件名（在 `action.d/` 目录下，不带 `.conf` 或 `.py` 后缀）。

- 对于 Python 写的 action（扩展名 `.py`）：Fail2Ban 会去掉 `.py`。如果用同一个 action 多次，可以通过 `actname` 参数指定不同标识。 举例：

  ```ini
  [ssh-iptables-ipset]
  enabled = true
  action = smtp.py[dest=chris@example.com, actname=smtp-chris]
           smtp.py[dest=sally@example.com, actname=smtp-sally]
  ```

 

- **action 文件结构**：通常包含两个 section：

  - `[Definition]`：定义具体命令（封禁、解封、启动、停止等）
  - `[Init]`：初始化参数（如超时时间 `timeout`）在具体 jail 中可以覆盖。

- **常见命令类型**：

  - `actionstart`：启动 jail 时执行
  - `actionstop`：停止 jail 时执行
  - `actioncheck`：在封禁之前执行，检查环境是否仍然正常
  - `actionban`：真正封禁 IP
  - `actionunban`：解封 IP

- **标签 (tags)**：在 action 命令中可以用 `<…>` 占位符，Fail2Ban 会替换为具体值：

  - `<ip>`：封禁目标 IP
  - `<failures>`：这次失败次数
  - `<ipfailures>`：该 IP 所有 jail 的失败总数（需要持久化数据库）
  - `<time>`：UNIX 时间戳
  - `<matches>` / `<ipmatches>` / `<ipjailmatches>`：匹配的日志行内容（全部或该 jail）

- 执行这些命令是通过 shell，所以可以使用重定向、管道等 shell 特性。命令必须返回退出码 0，否则视为错误。

- `actioncheck` 如果返回非 0（失败），Fail2Ban 会认为防火墙或环境发生了变化，会重新初始化（先 stop 再 start）对应 jail。

------

## 六、时间格式（Time Abbreviation）

- 对于 `bantime`、`findtime` 等参数，可以用简洁的时间缩写（abbreviation），而不仅仅是秒数。
- 支持的时间单位（tokens）示例：
  - 年 (years, yy)
  - 月 (months, mon)
  - 周 (weeks, ww)
  - 日 (days, dd)
  - 小时 (hours, hh)
  - 分钟 (minutes, mm)
  - 秒 (seconds, ss)
- 可以组合：例如 `1d12h30m` 表示 **1 天 12 小时 30 分钟**。
- 可以用 `fail2ban-client --str2sec` 命令测试这个格式。

------

## 七、Filter（过滤器）和 Python action 的补充（与 jail.conf 的关系）

- **Filter 文件** (`filter.d/*.conf`)
  - 定义 `failregex`、`ignoreregex` 等关键正则。 ([Debian Manpages](https://manpages.debian.org/bookworm/fail2ban/jail.conf.5.en.html?utm_source=chatgpt.com))
  - 也可能有 `[Init]` 和 `[Definition]` 两个部分。 `[Init]` 部分的参数可以被 jail.conf（或 jail.local）重写。 ([Debian Manpages](https://manpages.debian.org/bookworm/fail2ban/jail.conf.5.en.html?utm_source=chatgpt.com))
  - 支持 `[INCLUDES]` 节，可以包含别的配置文件（“before”、“after”）顺序控制。
- **Python Action**
  - 如果动作是用 Python 写的（`.py` 文件），它必须定义一个 `Action` 类（实现 Fail2Ban 的 ActionBase 接口 / 基类）。 ([Debian Manpages](https://manpages.debian.org/bookworm/fail2ban/jail.conf.5.en.html?utm_source=chatgpt.com))
  - 这样你可以写更灵活、复杂的封禁逻辑（例如通知、API 调用等）。 ([Debian Manpages](https://manpages.debian.org/bookworm/fail2ban/jail.conf.5.en.html?utm_source=chatgpt.com))

------

## 八、使用建议 & 实践技巧

- **不要直接改 `.conf`**
  - 推荐把修改写在 `.local` 文件里，这样未来升级 Fail2Ban 时不会覆盖你的配置。
- **合理使用 ignore 功能**
  - `ignoreip` 用来白名单，比如本地 IP、可信网络。
  - `ignorecommand` 用脚本逻辑判断是否封禁，可以实现更灵活策略（比如，如果是某类服务 IP，就不封禁）。
  - `ignorecache` 可以减少 `ignorecommand` 执行频率，节省资源。
- **选择合适后台 (backend)**
  - 对于 systemd 日志服务（很多现代系统是这样），可以考虑 `backend = systemd`，效率更高；但要用 `journalmatch` 匹配日志。
  - 如果日志是传统文件（/var/log/...），`pyinotify` 或 `polling` 比较合适。
- **多个 action**
  - 可以组合多个 action，比如既封禁 IP，也发送邮件通知。
  - 利用 action 的标签 (tags) 可以把具体 IP、时间、匹配日志行等信息插入命令 / 邮件 /脚本中。
- **时间单位灵活用**
  - 使用人性化的时间表示（如 `1d`、`2h30m`）更直观，也便于配置和维护。
- **测试正则**
  - 使用 `fail2ban-regex` 命令测试你的 filter（failregex / ignoreregex）是否正确匹配日志。
- **保持日志格式一致**
  - 确保日志系统 (syslog、rsyslog、journald) 没有做压缩、摘要化 (比如 “last message repeated”)，否则 Fail2Ban 可能漏掉日志。文档里也特别提到这一点。

