[toc]



- 提前准备好驱动或者驱动管理软件
  - 尤其是网卡（设备厂商直接下载）
  - 或者离线的万能网卡驱动
  - 联网后再安装其他驱动（显卡，蓝牙，声卡，触摸板等）
- 屏幕亮度调节问题
  - 借助Twinkle Tray等软件来调节驱动
  - 或者调节为深色模式主题
- 声卡安装网驱动可能需要troubleshoot一下启用
- 激活系统稍微麻烦点
- 启用wifi
  - 需要手动启用wifi功能，即便驱动已经安装
- 无法直接使用windows自带的应用商店
- 使用office的一些软件无法安装成功
- 默认为administrator用户
- 时刻和时区可能要调整一下，改成utc+8:00为中国区
- 默认需要按下ctrl+alt+delete才能解锁屏幕，登录密码要求足够复杂，密码会定时过期（要求定时更换），需要修改安全策略（`secpol`）

  - [Password must meet complexity requirements - Windows 10 | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/security-policy-settings/password-must-meet-complexity-requirements)

  - [关掉windows server 2019 的Ctrl+Alt+Delete解锁屏幕功能的实现 - 莳曳 - 博客园 (cnblogs.com)](https://www.cnblogs.com/cookiecheetah/p/14476709.html)