[toc]

## windows上使用openclaw browser

如果已经用chrome默认安装方法,并且设置chrome为默认浏览器,openclaw会检测到浏览器chrome路径(可执行文件路径)

```bash
#⚡️[opcxxu@OP-XCX][<以:192.168.1.32>][~]
 openclaw browser status

🦞 OpenClaw 2026.3.24 (cff6dc9) — Half butler, half debugger, full crustacean.

│
◇
profile: openclaw
enabled: true
running: false
transport: cdp
cdpPort: 18800
cdpUrl: http://127.0.0.1:18800
browser: unknown
detectedBrowser: chrome
detectedPath: C:\Program Files\Google\Chrome\Application\chrome.exe
profileColor: #FF4500
```

切换默认使用的浏览器:

```powershell
openclaw config set browser.executablePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
```



```bash
profile: openclaw
enabled: true
running: true
transport: cdp
cdpPort: 18800
cdpUrl: http://127.0.0.1:18800
browser: chrome
detectedBrowser: custom
detectedPath: C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
profileColor: #FF4500
```

但在安装了多个浏览器(chrome+edge)的情况下,上述更改可能不生效,尤其是将chrome设置为windows的默认浏览器的情况下;

## wsl中使用openclaw browser

即使安装了 wslu，在 WSL 中使用 Windows Edge 浏览器仍可能遇到配置问题。 

我使用wsl(ubuntu)安装的openclaw 推荐用户手动安装浏览器才能使用openclaw browser.

### 方案 1：ubunut安装 Google Chrome（推荐）

```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb  
sudo dpkg -i google-chrome-stable_current_amd64.deb  
sudo apt --fix-broken install -y
```

可以检查安装的可执行文件路径:`ls -l /usr/bin/google-chrome-stable`.

如果路径正确,然后可以配置 OpenClaw：(关键)

```json
{  
  "browser": {  
    "enabled": true,  
    "executablePath": "/usr/bin/google-chrome-stable",  
    "headless": true,  
    "noSandbox": true  
  }  
}
```

默认情况下,openclaw browser配置可能如下:

```bash
$ openclaw browser status

🦞 OpenClaw 2026.3.23-2 (7ffe7e4) — Ah, the fruit tree company! 🍎

│
◇
profile: openclaw
enabled: true
running: false
transport: cdp
cdpPort: 18800
cdpUrl: http://127.0.0.1:18800
browser: unknown
detectedBrowser: chrome
detectedPath: /usr/bin/google-chrome-stable
profileColor: #FF4500
```

如果没有安装浏览器,启动`openclaw browser open ...`会失败.

### 无头浏览器模式

在wsl中,即便安装了chrome浏览器,默认的无头模式,可以工作,我们可以调用它打开一些网页

```bash
# 设置有头模式
openclaw config set browser.headless true
```

但是如果更改为无头模式

```bash
# 设置有头模式
openclaw config set browser.headless false
```

> 更改后要重启网关

```bash
openclaw gateway restart
```

就会报错

```bash
# (base) (node:v22.22.1)[wsl][Ubuntu 24.04][bash]opcxxu@OP-XCX in /mnt/c/Users/opcxxu [16:13:26]
$ openclaw browser open https://www.baidu.com

🦞 OpenClaw 2026.3.24 (cff6dc9) — Say "stop" and I'll stop—say "ship" and we'll both learn a lesson.

│
◇
GatewayClientRequestError: Error: Failed to start Chrome CDP on port 18800 for profile "openclaw".
Chrome stderr:
[6402:6402:0326/161554.846757:ERROR:ui/ozone/platform/x11/ozone_platform_x11.cc:256] Missing X server or $DISPLAY
[6402:6402:0326/161554.847622:ERROR:ui/aura/env.cc:246] The platform failed to initialize.  Exiting.
[ble: exit 1]
```

估计是因为wsl和带桌面的linux系统还是有差异.

## 其他浏览器使用方案

###  使用 remote CDP 模式（推荐）

对于 WSL + Windows 浏览器组合，使用 remote CDP 模式更稳定 browser.md:165-166 ：

1. **在 Windows 上启动 Edge 并启用远程调试**：

   - 关闭所有 Edge 实例
   - 以管理员身份运行 PowerShell：

   ```bash
   & "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --remote-debugging-port=9222 --user-data-dir="C:\temp\edge-debug"
   ```

2. **在 WSL 中配置 remote CDP**：

   ```
   openclaw config set browser.profiles.remote.cdpUrl "http://localhost:9222"  
   openclaw config set browser.defaultProfile "remote"
   ```

3. **测试连接**：

   ```
   openclaw browser --browser-profile remote status
   ```

###  使用 existing-session 模式

如果你已经在 Windows 上运行了 Edge，可以使用 Chrome MCP 连接 browser.md:300-304 ：

```
# 使用内置的 user 配置文件  
openclaw browser --browser-profile user start
```

## 常见错误及解决

| 错误信息                             | 解决方案                                                     |
| ------------------------------------ | ------------------------------------------------------------ |
| `Failed to start Chrome CDP on port` | 检查浏览器路径，添加 `noSandbox: true` browser-linux-troubleshooting.md:40-58 |
| `browser.executablePath not found`   | 确认路径正确，使用 `/mnt/c/` 格式                            |
| `No Chrome tabs found`               | 确保 Edge 有打开的标签页，或使用 remote CDP 模式             |

## 验证配置

```
# 重启 Gateway 以应用配置  
openclaw gateway restart  
  
# 测试浏览器功能  
openclaw browser --browser-profile openclaw start  
openclaw browser open https://example.com
```

## Notes

- WSL2 访问 Windows 文件系统使用 `/mnt/c/` 路径格式 browser.md:146-151
- `noSandbox: true` 在 WSL 环境下通常是必需的 browser-linux-troubleshooting.md:54-55
- 如果仍有问题，查看专门的 WSL2 + Windows remote CDP 故障排除文档 troubleshooting.md:292-294

如果以上方法都不行，请运行 `openclaw doctor` 并分享输出结果，这样可以更精确地定位问题。

Wiki pages you might want to explore:

- [Getting Started (openclaw/openclaw)](https://deepwiki.com/openclaw/openclaw/1.1-getting-started)
- [System Prompt & Context (openclaw/openclaw)](https://deepwiki.com/openclaw/openclaw/3.2-system-prompt-and-context)
- [Browser Automation (openclaw/openclaw)](https://deepwiki.com/openclaw/openclaw/3.4.4-browser-automation)