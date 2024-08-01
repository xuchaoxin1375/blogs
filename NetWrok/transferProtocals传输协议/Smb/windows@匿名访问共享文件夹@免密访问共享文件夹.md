[toc]



## 以下方案尚未经过验证(TODO)

[Win11设置无密码访问共享文件夹操作教学-Win11共享文件夹设置 - 系统之家 (xitongzhijia.net)](https://www.xitongzhijia.net/xtjc/20230414/286462.html)

Windows 11中设置匿名访问共享文件夹涉及几个步骤。以下是基本流程:

1. 启用来宾账户:
   打开命令提示符(管理员),输入:

   ```
   net user guest /active:yes
   ```

2. 修改注册表:
   使用注册表编辑器或PowerShell修改以下项:

   ```powershell
   # 允许匿名访问共享
   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictNullSessAccess" -Value 0 -PropertyType DWORD -Force
   
   # 允许网络访问匿名共享
   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "EveryoneIncludesAnonymous" -Value 1 -PropertyType DWORD -Force
   ```

3. 关闭密码保护共享:
   在PowerShell(管理员)中运行:

   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RequireSecuritySignature" -Value 0
   ```

4. #### 配置文件共享:

   - 右键点击要共享的文件夹
   - 选择"属性" > "共享" > "高级共享"
   - 勾选"共享此文件夹"
   - 点击"权限",确保"Everyone"组有读取权限

5. 配置网络发现和文件共享:

   - 打开"控制面板" > "网络和共享中心"
   - 点击"更改高级共享设置"
   - 确保"网络发现"和"文件和打印机共享"已启用

6. 重启电脑使更改生效


### Notes:

请注意,这些设置会降低系统安全性。建议:

1. 只在受信任的网络中使用
2. 仅共享必要的文件夹
3. 定期检查访问日志
4. 考虑使用更安全的方法,如设置具有密码的共享账户

###  操作检查

```powershell
PS [C:\Users\cxxu]> Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RequireSecuritySignature"

requiresecuritysignature : 0
PSPath                   : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters
PSParentPath             : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer
PSChildName              : Parameters
PSDrive                  : HKLM
PSProvider               : Microsoft.PowerShell.Core\Registry



PS [C:\Users\cxxu]> Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "EveryoneIncludesAnonymous"

everyoneincludesanonymous : 1
PSPath                    : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
PSParentPath              : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control
PSChildName               : Lsa
PSDrive                   : HKLM
PSProvider                : Microsoft.PowerShell.Core\Registry


PS [C:\Users\cxxu]> Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictNullSessAccess"

restrictnullsessaccess : 0
PSPath                 : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters
PSParentPath           : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer
PSChildName            : Parameters
PSDrive                : HKLM
PSProvider             : Microsoft.PowerShell.Core\Registry
```

## 相关组策略修改

- 本地安全策略(`secpol`)设置
  - 本地策略中的用户权限分配,确保不要将Guest添加到:**拒绝从网络访问这台计算机**
  - 