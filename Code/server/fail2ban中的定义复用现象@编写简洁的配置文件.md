[toc]

## abstract

Fail2Ban 的复用（Reusability）技巧是高效管理配置、减少重复劳动和保持配置清晰的关键。

这些技巧主要围绕文件的 **包含 (Inclusion)**、**变量的定义和覆盖 (Definition & Override)**，以及 **模板化 (Templating)** 展开。

以下是 Fail2Ban 中主要的复用技巧总结：

💡 Fail2Ban 配置复用技巧总结

Fail2Ban 配置的核心原则是：**永远不要直接修改 `.conf` 文件，而应该创建 `.local` 文件来覆盖或补充配置。**

------

### 1. 文件包含和继承 (`.conf` vs `.local`)

这是 Fail2Ban 最基础也是最重要的复用机制。此用法是隐式进行的,有fail2ban的配置加载机制实现的,是夸配置文件引用和复用的.

- **目标：** 继承默认配置并只修改需要自定义的部分。
- **方法：**
  - Fail2Ban 总是优先加载 **`.conf`** 文件，然后加载同名的 **`.local`** 文件。
  - 例如，它会先加载 `/etc/fail2ban/jail.conf`，然后加载 `/etc/fail2ban/jail.local`。
- **技巧：**
  - 在 `jail.local` 中，您不需要重新定义整个配置(相对`jail.conf`)，只需定义您想要覆盖的若干全局设置，或者定义新的 `[Jail]` 节，或覆盖现有 `[Jail]` 节中的特定参数。

### 2. 使用 `[INCLUDES]` 引用其他配置

`[INCLUDES]` 部分允许在一个文件中导入另一个文件的内容，实现模块化。此用法比较简单,是也是夸配置文件引用的.

- **用途：** 主要在 **action** 配置文件中使用。例如，您希望创建一个新的 **action**，但它的大部分逻辑与一个现有的 action 相同。

- **技巧：**

  - 在您的自定义 action 文件（例如 `action.d/my-action.local`）的开头使用 `[INCLUDES]` 来引用基础 action。

  ```toml
  [INCLUDES]
  # 引用基础的 iptables-allports action 的所有定义
  before = iptables-allports.conf
  ```

  - 然后在后面的 `[Definition]` 部分中，您只需覆盖少数几个自定义的变量或命令，如 `actionban` 或 `actionunban`。

### 3. 变量覆盖和默认值 (`[Init]` 和 `[Definition]`)

Fail2Ban 允许通过变量来配置 **filter** 和 **action**，这些变量可以在使用时被轻松覆盖。

- **核心机制：** 在 `action` 或 `filter` 文件中，变量在 `[Definition]` 或 `[Init]` 部分定义。

- **技巧 1：模板化 Action**

  - 定义一个具有灵活变量（如 `<mode>`、`<protocol>`、`<chain>` 等）的通用 Action(这里称为`generic-action.conf`,比如fail2ban自带的`action.d/iptables.conf`)。
  - 在 **`jail.local`** 中引用该 Action 时，通过**方括号语法来传递参数**，实现复用。

  ```toml
  # 在 action.d/generic-action.conf 中定义了 <mode> 变量
  
  # 在 jail.local 中复用该 action 并覆盖变量
  action = generic-action[mode="block", protocol="tcp"]
  action = generic-action[mode="drop", protocol="udp"]
  ```

  - **优点：** 只需要编写一个 `action` 文件，就可以实现多种不同的封禁行为。
  - 注意,`action=...`的配置是用在`jail`中,在其他配置文件中(比如某个action配置文件中不适用此语句,因为层次逻辑的原因),不过对于action配置文件中,可以使用`actionban=...`以及`actionunban=...`这种配置项

- **技巧 2：在 `[Init]` 中提供默认值**

  - 在 **filter** 或 **action** 的配置文件中，使用 `[Init]` 节来设置变量的默认值。

  ```toml
  [Init]
  # 如果在使用时没有指定 port，则默认使用 ssh
  port = ssh
  ```

`action.d/iptables.conf`内容示例(移除注释行)

其中的`[Init]`节

```toml
[Init]
chain = INPUT
name = default
port = ssh
protocol = tcp
blocktype = REJECT --reject-with icmp-port-unreachable
returntype = RETURN
lockingopt = -w
iptables = iptables <lockingopt>
```



```toml
[Definition]
type = oneport
actionflush = <iptables> -F f2b-<name>
actionstart = { <iptables> -C f2b-<name> -j <returntype> >/dev/null 2>&1; } || { <iptables> -N f2b-<name> || true; <iptables> -A f2b-<name> -j <returntype>; }
              <_ipt_add_rules>
actionstop = <_ipt_del_rules>
             <actionflush>
             <iptables> -X f2b-<name>
actioncheck = <_ipt_check_rules>
actionban = <iptables> -I f2b-<name> 1 -s <ip> -j <blocktype>
actionunban = <iptables> -D f2b-<name> -s <ip> -j <blocktype>
pre-rule =
rule-jump = -j <_ipt_rule_target>
_ipt_for_proto-iter = for proto in $(echo '<protocol>' | sed 's/,/ /g'); do
_ipt_for_proto-done = done
_ipt_add_rules = <_ipt_for_proto-iter>
              { %(_ipt_check_rule)s >/dev/null 2>&1; } || { <iptables> -I <chain> %(_ipt_chain_rule)s; }
              <_ipt_for_proto-done>
_ipt_del_rules = <_ipt_for_proto-iter>
              <iptables> -D <chain> %(_ipt_chain_rule)s
              <_ipt_for_proto-done>
_ipt_check_rules = <_ipt_for_proto-iter>
              %(_ipt_check_rule)s
              <_ipt_for_proto-done>
_ipt_chain_rule = <pre-rule><ipt_<type>/_chain_rule>
_ipt_check_rule = <iptables> -C <chain> %(_ipt_chain_rule)s
_ipt_rule_target = f2b-<name>

[ipt_oneport]
_chain_rule = -p $proto --dport <port> <rule-jump>
[ipt_multiport]
_chain_rule = -p $proto -m multiport --dports <port> <rule-jump>
[ipt_allports]
_chain_rule = -p $proto <rule-jump>

[Init]
chain = INPUT
name = default
port = ssh
protocol = tcp
blocktype = REJECT --reject-with icmp-port-unreachable
returntype = RETURN
lockingopt = -w
iptables = iptables <lockingopt>

[Init?family=inet6]
blocktype = REJECT --reject-with icmp6-port-unreachable
iptables = ip6tables <lockingopt>
```



### 4. 使用 `[DEFAULT]` 节实现全局复用

`jail.local` 中的 `[DEFAULT]` 节用于定义所有 Jail 都会继承的全局设置。

- **用途：** 集中设置所有 Jail 共同遵守的参数，如默认的封禁时间、尝试次数、日志路径等。

- **技巧：**

  ```toml
  [DEFAULT]
  # 设置所有 Jail 默认封禁 1 小时 (3600 秒)
  bantime = 3600
  
  # 设置所有 Jail 默认 5 次失败就封禁
  maxretry = 5
  
  # 设置所有 Jail 默认使用的 Action 列表
  banaction = firewall-cmd
  mta = sendmail
  ```

  - 在随后的单个 `[sshd]` 或 `[apache-bot]` 节中，您只需定义 `enabled = true`，所有 `[DEFAULT]` 中的设置都会被继承。

### 5. 使用 Tag 和 Macro (高级复用)

虽然不常用，但 Fail2Ban 支持使用 `Tag` 这样的变量作为宏来实现更复杂的复用。

- **用途：** 在一个配置中嵌入另一个配置。
- **技巧：**
  - 例如，在 `action` 中定义一个复杂的 IP 地址匹配模式，然后使用 `<F-CONTENT>` 标签来引用它。

