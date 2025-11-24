[toc]



## abstract

本文介绍为现代浏览器(以edge)为例,配置浏览器对不同url配置不同代理,尤其是根据协议选择是否走代理

以`http://`和`https://`为例,假设我希望前者不走代理(或者总是直连),而后者走代理(或者更加精细的代理规则)

## 插件选择

功能类似的插件较多,这里选择相对功能比较完善的,对chromium和系和火狐系浏览器都支持良好的**ZeroOmega**

[GitHub - zero-peak/ZeroOmega: Manage and switch between multiple proxies quickly & easily.](https://github.com/zero-peak/ZeroOmega)

- edge:[Proxy SwitchyOmega 3 (ZeroOmega) - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/proxy-switchyomega-3-zer/dmaldhchmoafliphkijbfhaomcgglmgd)
- 火狐:
  - [ZeroOmega--Proxy Switchy manifest v3 version – 下载 🦊 Firefox 扩展（zh-CN）](https://addons.mozilla.org/zh-CN/firefox/addon/zeroomega/)
  - [ZeroOmega--Proxy SwitchyOmega V3 – Get this Extension for 🦊 Firefox (en-US)](https://addons.mozilla.org/en-US/firefox/addon/zeroomega/)

## 配置案例

将配置保存为.json文件(或.txt等任何文本文件)

然后在插件设置中导入此文本文件

> 供参考的在线版本(包含三组规则,不过每组规则都差不多,只是端口不一样而已):(可能会失效)
>
> ```http
> https://gitee.com/xuchaoxin1375/scripts/raw/main/Config/ZeroOmegaOptions.json
> ```

下面是使用本地透明代理http://localhost:10808 创建的代理规则

为了实现根据url链接分流,需要创建一个自动切换[auto-switch]的情景模式(profile),在两种模式在自动切换:

- 如果url是`http://`链接,则走[Direct]模式(直连不走代理),注意,[直接连接]模式是默认存在的模式,不需要手动创建,在自动切换模式中编写切换规则时,可以直接引用直接连接模式
- 如果url是`https://`链接,则走代理,这里需要通过选择已经创建好的普通情景模式

第一个重要步骤是创建一个普通代理情景模式(proxy profile,代理服务器)

例如下面的简单情景模式(几乎是默认的,不过普通情景模式允许你通过域名通配符绕过一些不需要走代理的网站,例如访问特征明显的国内网站(.cn)网站,具体比如bt.cn),这种即便是https链接也不推荐走代理

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/c79210b057b04fb080a2cc1c5bf58d28.png)

第二个重要步骤,在自动情景模式中配置模式切换规则

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/886a7504d049428985bca2c16954da1c.png)

## 导出的备份参考(json)

```json
{
    "+auto-direct-10808": {
        "color": "#ca0",
        "defaultProfileName": "direct",
        "name": "auto-direct-10808",
        "profileType": "SwitchProfile",
        "revision": "19aa60318dc",
        "rules": [
            {
                "condition": {
                    "conditionType": "UrlWildcardCondition",
                    "pattern": "http://*"
                },
                "profileName": "direct"
            },
            {
                "condition": {
                    "conditionType": "UrlWildcardCondition",
                    "pattern": "https://*"
                },
                "profileName": "https10808"
            }
        ]
    },
    "+https10808": {
        "bypassList": [
            {
                "conditionType": "BypassCondition",
                "pattern": "127.0.0.1"
            },
            {
                "conditionType": "BypassCondition",
                "pattern": "[::1]"
            },
            {
                "conditionType": "BypassCondition",
                "pattern": "localhost"
            },
            {
                "conditionType": "BypassCondition",
                "pattern": "*.cn"
            },
            {
                "conditionType": "BypassCondition",
                "pattern": "*.test"
            }
        ],
        "color": "#9ce",
        "fallbackProxy": {
            "host": "localhost",
            "port": 10808,
            "scheme": "http"
        },
        "name": "https10808",
        "profileType": "FixedProfile",
        "revision": "19aa9545f9f"
    },
    "-addConditionsToBottom": false,
    "-confirmDeletion": true,
    "-downloadInterval": 1440,
    "-enableQuickSwitch": false,
    "-monitorWebRequests": true,
    "-quickSwitchProfiles": [],
    "-refreshOnProfileChange": true,
    "-revertProxyChanges": true,
    "-showConditionTypes": 1,
    "-showExternalProfile": true,
    "-showInspectMenu": true,
    "-showResultProfileOnActionBadgeText": false,
    "-startupProfileName": "",
    "schemaVersion": 2
}
```

