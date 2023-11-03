[toc]



# 文件跟踪查看/实时查看添加到⽂件中的内容/linux日志查看

### 追踪更新中的文件

- `tail -f -n <lineNumbers> <logFile> | nl`

### 查看某个文件的末尾N行,并带上源文件中的行号

- `nl <logFile> tail -n <lineNumbers>`

## 查看linux内核日志



### 相关参考

- [What are Linux Logs? Code Examples, Tutorials &amp; More (stackify.com)](https://stackify.com/linux-logs/)

  - [A Definition of Linux Logs](https://stackify.com/linux-logs/#h-a-definition-of-linux-logs)
  - [How to View Linux Logs](https://stackify.com/linux-logs/#h-how-to-view-linux-logs)
  - [Most Important Linux Logs](https://stackify.com/linux-logs/#h-most-important-linux-logs)
  - [Critical, Must Monitor Logs](https://stackify.com/linux-logs/#h-critical-must-monitor-logs)
  - [Sample Output](https://stackify.com/linux-logs/#h-sample-output)
  - [Additional Resources and Tutorials on Linux Logs](https://stackify.com/linux-logs/#h-additional-resources-and-tutorials-on-linux-logs)
- [Classic SysAdmin: Viewing Linux Logs from the Command Line](https://www.linuxfoundation.org/blog/blog/classic-sysadmin-viewing-linux-logs-from-the-command-line#hs_cos_wrapper_name)

  - /var/log
  - Viewing logs with less
  - Viewing logs with dmesg
  - Viewing logs with tail
- [How to View System Log Files in Linux (linuxhint.com)](https://linuxhint.com/view_system_log_files_linux/)
- [Analyzing and Managing System Log Files | System Analysis and Tuning Guide | SUSE Linux Enterprise Server 12 SP4](https://documentation.suse.com/sles/12-SP4/html/SLES-all/cha-tuning-logfiles.html)

* [How to View &amp; Read Linux Log Files](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#headline-211-157)
  * [What are Linux Log Files?](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-1)
  * [How to View Linux Logs](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-2)
  * [Important Linux System Logs](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-3)
    * [System Logs](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-4)
    * [System Logging Daemon](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-5)
    * [Application Logs](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-6)
    * [Non-Human-Readable Logs](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-7)
  * [Supplemental GUIs for Viewing Linux Log Files](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-8)
  * [How to Configure Log Files on Ubuntu and CentOS](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-9)
  * [Execute Log Rotation](https://phoenixnap.com/kb/how-to-view-read-linux-log-files#ftoc-heading-10)

## 日志查看示例

### 查看开机日志

### ubuntu

- `sudo tail -f boot.log`

```bash
# cxxu @ cxxuAli in /var/log [19:00:25] C:1
$ sudo tail -f boot.log
[sudo] password for cxxu:
[  OK  ] Started Permit User Sessions.
[  OK  ] Started ECS enable networking multiqueue.
[  OK  ] Started resolvconf-pull-resolved.service.
[  OK  ] Started OpenBSD Secure Shell server.
[  OK  ] Started chrony, an NTP client/server.
[  OK  ] Started LSB: starts the nginx web server.
[  OK  ] Started LSB: Record successful boot for GRUB.
[  OK  ] Started Accounts Service.
         Starting Terminate Plymouth Boot Screen...
         Starting Hold until boot process finishes up...
```

### 授权日志

```bash
# cxxu @ cxxuAli in /var/log [19:02:53]
$ sudo tail /var/log/auth.log
Sep 29 18:59:37 cxxuAli sshd[24798]: pam_unix(sshd:session): session opened for user cxxu by (uid=0)
Sep 29 18:59:37 cxxuAli systemd-logind[584]: New session 23215 of user cxxu.
Sep 29 19:00:35 cxxuAli sudo:     cxxu : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/usr/bin/tail -f boot.log
Sep 29 19:00:35 cxxuAli sudo: pam_unix(sudo:session): session opened for user root by cxxu(uid=0)
Sep 29 19:00:45 cxxuAli sudo: pam_unix(sudo:session): session closed for user root
Sep 29 19:02:53 cxxuAli sudo:     cxxu : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/cat /var/log/auth.log
Sep 29 19:02:53 cxxuAli sudo: pam_unix(sudo:session): session opened for user root by cxxu(uid=0)
Sep 29 19:02:53 cxxuAli sudo: pam_unix(sudo:session): session closed for user root
Sep 29 19:03:10 cxxuAli sudo:     cxxu : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/usr/bin/tail /var/log/auth.log
Sep 29 19:03:10 cxxuAli sudo: pam_unix(sudo:session): session opened for user root by cxxu(uid=0)
```

## Conclusion

- Examining various log files can help in debugging system freeze and crash issues, especially when new and unsupported hardware is present in the PC. 
- These log files are also useful for finding out security breaches or security loopholes if there are any. 
- If you are getting unexpected behavior from software installed on your system or frequent reboots and crashes, <u>**the first thing you should do is to examine various system log files.**</u>

