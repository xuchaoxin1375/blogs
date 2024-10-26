[toc]

## windows版本切换

windows版本(edition)切换不是任意两个版本都可以切换,比如pro无法直接切换到enterprise LTSC,只能切换到IOT enterprise

- [Windows-Edition-Switcher/Windows-Edition-Switcher.bat at master · jetfir3/Windows-Edition-Switcher · GitHub](https://github.com/jetfir3/Windows-Edition-Switcher)
- [Change Windows Edition | MAS (massgrave.dev)](https://massgrave.dev/change_windows_edition)
- [Windows 版本升级 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/deployment/upgrade/windows-edition-upgrades)

- [OSSQ - Windows10 Windows11 版本切换](https://ossq.cn/switching.html)

### 版本升级可用版本检查

使用管理员命令行窗口执行以下命令

```cmd
dism /online /get-targeteditions

```

例如

```powershell
PS[Mode:1][BAT:76%][MEM:29.23% (9.27/31.71)GB][Win 11 Pro@24H2:10.0.26100.2152][5:18:21 PM][UP:0.02Days]
#⚡️[cxxu@CXXUCOLORFUL][<W:192.168.1.154>][~\Desktop]
PS> dism /online /get-targeteditions

Deployment Image Servicing and Management tool
Version: 10.0.26100.1150

Image Version: 10.0.26100.2152

Editions that can be upgraded to:

Target Edition : Education
Target Edition : ProfessionalCountrySpecific
Target Edition : ProfessionalEducation
Target Edition : ProfessionalSingleLanguage
Target Edition : ProfessionalWorkstation
Target Edition : Enterprise
Target Edition : IoTEnterprise
Target Edition : IoTEnterpriseK
Target Edition : ServerRdsh
Target Edition : CloudEdition

The operation completed successfully.
```



### 激活状态查看

方式一、powershell中输入命令：`slmgr /xpr`
方式二、`win+r` 窗口中输入命令：`slmgr.vbs /xpr`

### 命令行方式切换版本

获取不同windows edition key

- [HWID Activation | MAS](https://massgrave.dev/hwid#supported-products)



```powershell
cscript.exe c:\windows\system32\slmgr.vbs /ipk XQQYW-NFFMW-XJPBH-K8732-CKFFD
```

