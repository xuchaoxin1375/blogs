## references

### 服务启动失败异常排查

- [systemd apparently not finding .service file - Stack Overflow](https://stackoverflow.com/questions/34501611/systemd-apparently-not-finding-service-file)

### systemctl(1) - Linux manual page

*   [systemd(1) - Linux manual page (man7.org)](https://man7.org/linux/man-pages/man1/init.1.html)

    *   ```bash
         systemd, init - systemd system and service manager
        ```

*   systemctl(1) — Linux manual page

    *   [NAME top](https://man7.org/linux/man-pages/man1/systemctl.1.html#NAME)
    *   [SYNOPSIS top](https://man7.org/linux/man-pages/man1/systemctl.1.html#SYNOPSIS)
    *   [DESCRIPTION top](https://man7.org/linux/man-pages/man1/systemctl.1.html#DESCRIPTION)
    *   [COMMANDS top](https://man7.org/linux/man-pages/man1/systemctl.1.html#COMMANDS)
    *   [OPTIONS top](https://man7.org/linux/man-pages/man1/systemctl.1.html#OPTIONS)
    *   [EXIT STATUS top](https://man7.org/linux/man-pages/man1/systemctl.1.html#EXIT_STATUS)
    *   [ENVIRONMENT top](https://man7.org/linux/man-pages/man1/systemctl.1.html#ENVIRONMENT)
    *   [SEE ALSO top](https://man7.org/linux/man-pages/man1/systemctl.1.html#SEE_ALSO)
    *   [NOTES top](https://man7.org/linux/man-pages/man1/systemctl.1.html#NOTES)
    *   [COLOPHON top](https://man7.org/linux/man-pages/man1/systemctl.1.html#COLOPHON)

## systemctl命令

```
NAME         top
       systemctl - Control the systemd system and service manager
SYNOPSIS         top
       systemctl [OPTIONS...] COMMAND [UNIT...]
DESCRIPTION         top

systemctl may be used to introspect and control the state of the
       "systemd" system and service manager. 
       Please refer to systemd(1)
       for an introduction into the basic concepts and functionality
       this tool manages.
```



## 编写服务



- 例如服务文件名`clash.service`

```bash
[Unit]
Description=clash-core
[Service]
Type=simple
ExecStart=/usr/local/bin/clash-core/clash -f /usr/local/bin/clash-core/config.yaml
```

- 将文件保存在`/etc/systemd/system/`目录下

  - 该目录下专门存放`.service`文件等作为系统服务启动的文件

  - ```
    ┌─[cxxu@cxxuAli] - [/usr/local/bin/clash-core] - [2022-06-24 11:00:00]
    └─[0] <> ls /etc/systemd/system/ -1
    aegis.service
    aliyun.service
    AssistDaemon.service
    atd.service
    bluetooth.target.wants
    chronyd.service
    clash.service
    cloud-final.service.wants
    cloud-init.target.wants
    CmsGoAgent.service
    ```

  - 放在其他目录下,`systemctl`默认无法找到