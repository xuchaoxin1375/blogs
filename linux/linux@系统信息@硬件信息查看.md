[toc]

# linux@系统信息@硬件信息查看

## 查看发行版和内核版本号相关主题命令

### 查看linux发行版以及版本号

- 第一种为通用方法`cat /etc/issue`

- ```bash
  cxxu@iZ2zef3tpqffm5ydjqi4zsZ:/etc/apt$ cat /etc/issue
  Ubuntu 18.04.6 LTS \n \l
  
  cxxu@iZ2zef3tpqffm5ydjqi4zsZ:/etc/apt$ lsb_release -a
  LSB Version:    core-9.20170808ubuntu1-noarch:security-9.20170808ubuntu1-noarch
  Distributor ID: Ubuntu
  Description:    Ubuntu 18.04.6 LTS
  Release:        18.04
  Codename:       bionic
  ```

- `lsb_release -a`(有些发行版没有该命令)

  - lsb_release (1)      - print distribution-specific information

- ```bash
  ┌─[cxxu_u22@cxxuWn11] - [/mnt/c/Users/cxxu/Desktop] - [2023-03-24 10:25:47]
  └─[0] <> lsb_release -a
  No LSB modules are available.
  Distributor ID: Ubuntu
  Description:    Ubuntu 22.04.1 LTS
  Release:        22.04
  Codename:       jammy
  
  ```

  - 其中，Distributor ID 表示发行版的标识符，Description 表示发行版的名称和版本号，Release 表示发行版的版本号，Codename 表示发行版的代号。

### 内核号(optional)

- `uname -a`
- `cat /proc/version`

```bash
 cat /proc/version
Linux version 4.15.0-169-generic (buildd@lcy02-amd64-015) (gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)) #177-Ubuntu SMP Thu Feb 3 10:50:38 UTC 2022
```

### 发行版相关主题(optional)

```bash
$ apropos distribution
debian-distro-info (1) - provides information about Debian's distributions
distro-info (1)      - provides information about the distributions' releases
dpkg-vendor (1)      - queries information about distribution vendors
iptables-extensions (8) - list of extensions in the standard iptables distribution
lsb_release (1)      - print distribution-specific information
ubuntu-distro-info (1) - provides information about Ubuntu's distributions
# cxxu @ cxxuAli in ~ [19:21:03]
$ apropos distribution |grep information
debian-distro-info (1) - provides information about Debian's distributions
distro-info (1)      - provides information about the distributions' releases
dpkg-vendor (1)      - queries information about distribution vendors
lsb_release (1)      - print distribution-specific information
ubuntu-distro-info (1) - provides information about Ubuntu's distributions
```

### 内核版本相关主题(optional)

```bash
# cxxu @ cxxuAli in ~ [19:08:31]
$ apropos kernel|grep version
linux-version (1)    - operate on Linux kernel version strings
# cxxu @ cxxuAli in ~ [19:15:16] C:16
$ whatis uname
uname (1)            - print system information
uname (2)            - get name and information about current kernel
```



- 在Linux系统中，可以使用以下命令来检查设备的硬件信息：

## 检查CPU信息

```
cat /proc/cpuinfo
```

该命令会输出CPU的详细信息，例如：

```
processor   : 0
vendor_id   : GenuineIntel
cpu family  : 6
model       : 142
model name  : Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz
stepping    : 0
microcode   : 0xea
cpu MHz     : 800.000
cache size  : 16384 KB
physical id : 0
siblings    : 16
core id     : 0
cpu cores   : 8
apicid      : 0
initial apicid  : 0
fpu     : yes
fpu_exception   : yes
cpuid level : 22
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb invpcid_single ssbd ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm mpx rdt_a avx512f avx512dq rdseed adx smap clflushopt clwb avx512cd avx512bw avx512vl xsaveopt xsavec xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local clzero irperf xsaveerptr wbnoinvd arat npt lbrv svm_lock nrip_save umip kaiser  spec_ctrl intel_stibp flush_l1d
bugs        : spectre_v1 spectre_v2 spec_store_bypass swapgs taa itlb_multihit srbds
bogomips    : 5799.80
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
```

## 检查内存信息

- `cat /proc/meminfo`

- 该命令会输出内存的详细信息，例如：

```bash
# cxxu @ u20 in ~ [21:48:25]
$ cat /proc/meminfo
MemTotal:        1987684 kB
MemFree:          142264 kB
MemAvailable:     854524 kB
Buffers:           62184 kB
Cached:           766920 kB
SwapCached:          312 kB
...
```

## 检查硬盘信息

```
sudo fdisk -l
```

该命令会输出硬盘的详细信息，例如：

```bash
Disk /dev/sda: 238.47 GiB, 256060514304 bytes, 500118192 sectors
Disk model: KINGSTON SA400S3
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 5D5F11E5-5A5E-4B23-9F9A-8F5F74D07161

Device         Start       End   Sectors   Size Type
/dev/sda1       2048  1050623   1048576   512M EFI System
/dev/sda2    1050624  1568767    518144   253M Linux filesystem
/dev/sda3    1568768 500117503 498448736 237.7G Linux L
```



