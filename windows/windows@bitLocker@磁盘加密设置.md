[toc]

## windows bitlocker

- [BitLocker 概述 - Windows Security | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/operating-system-security/data-protection/bitlocker/)

### bitlocker设置@开启@关闭

- 控制面板\系统和安全\BitLocker 驱动器加密
- 或者直接在开始菜单搜索bitLocker进行设置

### 关闭bitlocker

- 如果您十分在意数据安全,可以启用bitlocker
- 如果您更在意性能,可以考虑关闭bitlocker,并且当数据量或容量比较大的时候,解密时间可能会更加长;因此如果您打算关闭bitlocker,那么尽早关闭

## bitlocker的特点



### BitLocker的优点：

1. **全磁盘加密**：BitLocker能加密整个操作系统卷和其他固定驱动器，从而提供全面的数据保护，防止未经授权的访问，即便是硬盘被盗或遗失。

2. **TPM集成**：利用受信任的平台模块（Trusted Platform Module, TPM）技术，BitLocker可以验证启动过程的完整性，确保在未经许可的情况下，系统不会启动并且数据保持加密状态。

3. **多重身份验证**：除了TPM，BitLocker还支持多种身份验证方法，例如PIN码、智能卡、USB密钥等，增强了加密数据的解锁安全级别。

4. **BitLocker To Go**：此功能使得用户能够加密USB闪存驱动器和移动硬盘，确保便携式存储设备上的数据安全。

5. **企业级兼容性**：BitLocker与活动目录和组策略紧密结合，便于企业环境下的部署、管理和恢复。

6. **数据恢复机制**：提供了恢复密钥备份选项，以防忘记密码或主密钥丢失的情况。

### BitLocker的缺点：

1. **操作系统和硬件要求**：仅适用于Windows Vista及以上版本的操作系统，且需要特定硬件支持，如TPM，尽管也可以在无TPM的环境中通过USB密钥等方式实现。

2. **兼容性问题**：可能与一些较老或非标准的硬件、BIOS设置或第三方软件存在兼容性问题。

3. **用户管理复杂度**：用户需要妥善保管恢复密钥，否则可能导致数据不可恢复。此外，如果频繁更换硬件或在多台计算机之间移动加密驱动器，可能会增加日常使用的复杂性。

4. **可见性问题**：尽管加密了驱动器，但在Windows资源管理器中仍能看到加密卷的基本信息，如容量使用情况，这对于高度敏感环境可能存在一定风险。

5. **性能影响**：全磁盘加密会对系统性能产生一定的影响，尤其是在大量I/O操作时，加密解密过程会消耗额外的CPU资源。

6. **成本考虑**：虽然BitLocker加密功能本身是Windows的一部分，但如果需要额外购买TPM芯片或者支持BitLocker的硬件设备，会产生额外成本。不过，现代许多个人和商用电脑已内置TPM芯片。 



#### 性能问题

- [实测显示：微软 Win11 开启 BitLocker 软件加密会使 SSD 降速 20~45% - IT之家 (ithome.com)](https://www.ithome.com/0/726/194.htm)

