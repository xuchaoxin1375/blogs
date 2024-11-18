[toc]



[windows11 更新安装失败0x800736b3 - Microsoft Community](https://answers.microsoft.com/zh-hans/windows/forum/all/windows11/8da3e92d-6f01-415b-9e6f-48d34ae5aa95)

```cmd
net stop wuauserv

net stop cryptSvc

net stop bits

net stop msiserver

ren C:\Windows\SoftwareDistribution SoftwareDistribution.old

ren C:\Windows\System32\catroot2 catroot2.old

net start wuauserv

net start cryptSvc

net start bits

net start msiserver

DISM /Online /Cleanup-image /Checkhealth

DISM /Online /Cleanup-image /Scanhealth

DISM /Online /Cleanup-image /Restorehealth

sfc /scannow

```

