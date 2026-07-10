[toc]



## shell中的字符串无缝拼接

在 Bash 中，字符串拼接其实非常直观。由于 Bash 不需要像其他语言（如 Java 或 Python）那样使用特殊的拼接符号（如 `+` 或 `.`），你只需要将变量或字符串**紧挨着放在一起**即可。

> 或者使用`+=`将两个字符串变量合并(但是会改变第一个字符串的取值;

bash中的字符串通常表示为`"..."`或`'...'`两种安全形式,还有一种不安全形式是边缘不用任何引号`...`

现在假设bash中有任意两个字符串(分被记为`a,b`);那么两个字符串的拼接可以直接将两个字符串字面量无缝拼接;

例如`a="(abc def)"`,`b='(ghj kl)'`

那么拼接`a,b`得到的新变量`c`就可以写成`c="(abc def)"'(ghj kl)'`,效果等同于`c="$a$b"`

> 如果字符串a,b之间隔着非空白字符,那么更安全的写法是`c="${a}${b}"`

```bash
a="(abc def)"
b='(ghj kl)'
c="(abc def)"'(ghj kl)'
echo "[$c]"
```



### 构造复杂字符串

通常是指需要局部变量扩展,而其他部分需要保留字面量意义的情况(典型的例子是curl命令调试api);

假设`var`是某个shell变量,那么根据bash的语法,`'part1${var}part2'`不会扩展`var`的取值;

```bash
$ var=value
$ echo 'part1${var}part2'
part1${var}part2
```

根据上一节所述(字符串无缝拼接):将上述字符串分成3部分表示:`'part1'`,`"$var"`,`part2`,即`'part1'"${var}"'part2'`

```bash
 $  echo 'part1'"${var}"'part2'
part1valuepart2
```

可以发现,我们将内嵌的`${var}`标识为`'"..."'`的形式,也就是用`'"`,`"'`组合包裹需要安全扩展的变量;

> 如果`var`表示的是一个可能带有空格的路径,那么使用`'"'$var'"'`的方式包裹,可以在替换后留下`''`,防止空格阻断问题.

### 例

```json

curl https://openrouter.ai/api/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENROUTER_API_KEY" \
    -d '{
    "model": "'"$qwen"'",
    "messages": [
      {
        "role": "user",
        "content": "你是什么模型?"
      }
    ]
  }'
```

理解为以下三部分的拼接

```json
'{
    "model": "'
```

```json
"$qwen"
```

```json
'",
    "messages": [
      {
        "role": "user",
        "content": "你是什么模型?"
      }
    ]
  }'
```

这使得原本无法被正确解释(`$qwen`无法被正确展开)的原json字符串可以被正确解释

```json
    '{
    "model": "$qwen",
    "messages": [
      {
        "role": "user",
        "content": "你是什么模型?"
      }
    ]
  }'
```

如果套用公式,直接将`$qwen`用`'"..."'`包裹,就可以得到正确的json字符串表达

```json
    '{
    "model": "'"$qwen"'",
    "messages": [
      {
        "role": "user",
        "content": "你是什么模型?"
      }
    ]
  }'
```

### 例

本例中,使用`'"'$var'"'`的方式包括路径变量,即便`var`取值包含空格,在shell解释和替换变量后也可以保留下来`''`,也可以正确识别.

这里的文本片段内容中几乎不包含引号,可用此方案处理(如果包含很多`',"`,那么因为引号可能被shell解析,则不太适合;这种情况下应该考虑heredoc的方式,甚至将文本片段保存到单独的文件中,然后用`sed`这类工具来做针对性修改,会比直接嵌入在脚本中更加易于维护和阅读.)

heredoc更加擅长包含很多引号的情况,但是如果有大量变量(`$var`)需要保留`$`字面量,则需要对这些`$`符号做引用(转义)

```shell
# 准备一些变量(将在复杂字符串中引用)
mihomo_std_home="/usr/local/bin"
mihomo_std="$mihomo_std_home/mihomo"
config_std_home="/etc/mihomo"
config_std="$config_std_home/config.yaml"
```

1. 使用`herestring`的方案

```shell


# 创建 systemd 配置文件,测试性的写入家目录的demo.txt文件中
cat <<<'
[Unit]
Description=mihomo Daemon.
After=network.target NetworkManager.service systemd-networkd.service iwd.service

[Service]
Type=simple
LimitNPROC=500
LimitNOFILE=1000000
...
Restart=always
ExecStartPre=/usr/bin/sleep 1s
ExecStart='"'$mihomo_std'"' -d '"'$config_std_home'"'
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target

' > ~/demo.txt # 通过重定向的方式将构造的复杂字符串写入到文件中.
```

对应的内容如下:

```ini

[Unit]
Description=mihomo Daemon.
After=network.target NetworkManager.service systemd-networkd.service iwd.service

[Service]
Type=simple
LimitNPROC=500
LimitNOFILE=1000000
...
Restart=always
ExecStartPre=/usr/bin/sleep 1s
ExecStart='/usr/local/bin/mihomo' -d '/etc/mihomo'
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target



```

2. 使用`heredoc`的方案:

```shell
# 创建 systemd 配置文件
cat << EOF > ~/demo-heredoc.txt
[Unit]
Description=mihomo Daemon.
After=network.target NetworkManager.service systemd-networkd.service iwd.service

[Service]
Type=simple
LimitNPROC=500
LimitNOFILE=1000000
...
Restart=always
ExecStartPre=/usr/bin/sleep 1s
ExecStart="$mihomo_std" -d "$config_std"
ExecReload=/bin/kill -HUP \$MAINPID

[Install]
WantedBy=multi-user.target

EOF

```



## curl 调试api

使用 `curl` 调试 API 确实是开发者、运维甚至测试人员的日常。这种“习惯”背后，通常指向的是那些基于 **HTTP/HTTPS 协议** 的标准接口。

以下是这类 API 的主要特征和常见类型：

### 1. RESTful API (最常见)

这是目前互联网上最主流的 API 设计风格。因为 REST 依赖标准的 HTTP 方法，而 `curl` 恰好能完美模拟这些动作，所以它们是“天生一对”。

- **GET**: 获取资源（如 `curl https://api.example.com/users`）。
- **POST**: 创建资源（配合 `-d` 参数发送 JSON 数据）。
- **PUT/PATCH**: 更新资源。
- **DELETE**: 删除资源。

### 2. 后端内部微服务接口

在公司内部，不同服务之间（如订单服务调用库存服务）经常使用轻量级的接口。

- **特点**: 路径通常比较直接，返回格式通常为 **JSON**。
- **场景**: 开发者在本地开发完一个功能，不想写完整的前端代码，直接用 `curl` 给本地端口（如 `localhost:8080`）发个请求测试逻辑是否跑通。

### 3. 公共开放平台 API

比如百度地图、GitHub、OpenAI 或者各种天气查询接口。

- **身份验证**: 这些 API 通常需要 `Authorization` 头部或 API Key。
- **调试需求**: 开发者在集成这些第三方服务前，会先用 `curl -H "Authorization: Bearer YOUR_TOKEN" ...` 来确认自己的 Key 是否有效，以及对方返回的数据结构长什么样。

### 4. Webhooks

当某个事件发生时（比如 GitHub 有人提了 PR，或者支付宝收到了款），服务器会向你指定的 URL 发送一个 POST 请求。

- **调试**: 开发者会模拟这种 Webhook 请求，用 `curl` 构造一个包含虚假事件数据的 POST 包，发给自己正在开发的服务器，观察程序反应。

------

### 小结

1. **无需界面**: 在只有命令行（SSH）的服务器上，它是唯一的“浏览器”。
2. **极速验证**: 相比打开 Postman 或编写 Python/JS 脚本，写一行 `curl` 可能只需要 5 秒钟。
3. **可复制性强**: 很多 API 文档（如 Stripe 或 OpenAI）都会提供 `curl` 示例。你只需要改个参数就能运行。
4. **无状态**: 每次请求都是独立的，不会像浏览器那样被缓存或 Cookie 干扰。

### 常用调试小技巧

- **查看详细过程**: 加 `-v` (verbose)，可以看到完整的请求头和响应头，对排查 403 或 500 错误非常有帮助。
- **格式化输出**: 如果返回的 JSON 是一团乱麻，通常会配合 `jq` 工具使用： `curl https://api.example.com | jq`
- **保存结果**: 使用 `-o` 将返回的图片或文件保存到本地。