# Netboot the live server installer on IBM Power (ppc64el) with Petitboot

Open a terminal window on your workstation and make sure the `ipmitool` package is installed.

Verify if you can reach the [BMC](../../reference/glossary.md#term-BMC) of the IBM Power system via `ipmitool` with a simple `ipmitool` call like:

```console
$ ipmitool -I lanplus -H Power9Box -U <user> -P <password> power status
```

or:

```console
$ ipmitool -I lanplus -H Power9Box -U <user> -P <password> fru print 47
```

or:

```console
$ ipmitool -I lanplus -H Power9Box -U <user> -P <password> sol info
```

## Activate serial-over-LAN

Open a second terminal and activate serial-over-LAN (SOL), so that you have two terminal windows open:

1.  to control the BMC via IPMI

2.  for the serial-over-LAN console

Activate serial-over-LAN:

```console
$ ipmitool -I lanplus -H Power9Box -U <user> -P <password> sol activate
```

Power the system on in the ‘control terminal’ and watch the SOL console:

```console
$ ipmitool -I lanplus -H Power9Box -U <user> -P <password> power on
```

It takes some time to see the first lines in the SOL console:

```console
```

After a moment the system reaches the Petitboot screen:

```console
```

Select “\*Exit to shell”.

> **Note**
>
> Make sure you really watch the SOL, since the Petitboot screen (above) has a time out (usually 10 or 30 seconds) and afterwards it automatically proceeds and tries to boot from the configured devices (usually disk). This can be prevented by just navigating in Petitboot. The petitboot shell is small Linux based OS:
>
> ``` console
> ```

> **Note**
>
> In case one needs to gather system details and diagnostic data for IBM support, this can be done here by running ‘pb-sos’ (see `msg`).

## Download the ISO

Now download the ‘live-server’ ISO image (notice that ‘focal-live-server-ppc64el.iso’ uses the liver server installer, Subiquity, while ‘focal-server-s390x.iso’ uses `d-i`).

Again, for certain web locations a proxy needs to be used:

```text
/ # export http_proxy=http://squid.proxy:3128   # in case a proxy is required
/ #
/ # wget http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/focal-live-server-ppc64el.iso
Connecting to <proxy-ip>:3128 (<proxy-ip>:3128)
focal-live-server-pp 100% |....................|  922M  0:00:00 ETA
```

Next we need to loop-back mount the ISO:

```text
/ # mkdir iso
/ # mount -o loop focal-live-server-ppc64el.iso iso
```

Or, in case auto-detect of type iso9660 is not supported or not working, you should explicitly specify the ‘iso9660’ type:

```text
/ # mount -t iso9660 -o loop focal-live-server-ppc64el.iso iso
```

Now load kernel and initrd from the loop-back mount, specify any needed kernel parameters and get it going:

```text
/ # kexec -l ./iso/casper/vmlinux --initrd=./iso/casper/initrd.gz --append="ip=dhcp url=http://cdimage.ubuntu.com/ubuntu-server/daily-live/current/focal-live-server-ppc64el.iso http_proxy=http://squid.proxy:3128 --- quiet"
/ # kexec -e
The system is going down NOW!
Sent SIGTERM to all processes
Sent SIGKILL to all processes
...
```

> **Note**
>
> In order to boot with and install the HWE kernel (if available), substitute `vmlinux` with `vmlinux-hwe` in the first `kexec` line.

The system now performs the initial boot of the installer:

```text
[ 1200.687004] kexec_core: Starting new kernel
[ 1277.493883374,5] OPAL: Switch to big-endian OS
[ 1280.465061219,5] OPAL: Switch to little-endian OS
ln: /tmp/mountroot-fail-hooks.d//scripts/init-premount/lvm2: No such file or directory
Internet Systems Consortium DHCP Client 4.4.1
Copyright 2004-2018 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/
Listening on LPF/enP2p1s0f3/0c:c4:7a:87:04:db
Sending on   LPF/enP2p1s0f3/0c:c4:7a:87:04:db
Listening on LPF/enP2p1s0f2/0c:c4:7a:87:04:da
Sending on   LPF/enP2p1s0f2/0c:c4:7a:87:04:da
Listening on LPF/enP2p1s0f1/0c:c4:7a:87:04:d9
Sending on   LPF/enP2p1s0f1/0c:c4:7a:87:04:d9
Listening on LPF/enP2p1s0f0/0c:c4:7a:87:04:d8
Sending on   LPF/enP2p1s0f0/0c:c4:7a:87:04:d8
Sending on   Socket/fallback
DHCPDISCOVER on enP2p1s0f3 to 255.255.255.255 port 67 interval 3
(xid=0x8d5704c)
DHCPDISCOVER on enP2p1s0f2 to 255.255.255.255 port 67 interval 3
(xid=0x94b25b28)
DHCPDISCOVER on enP2p1s0f1 to 255.255.255.255 port 67 interval 3
(xid=0x4edd0558)
DHCPDISCOVER on enP2p1s0f0 to 255.255.255.255 port 67 interval 3
(xid=0x61c90d28)
DHCPOFFER of 10.245.71.102 from 10.245.71.3
DHCPREQUEST for 10.245.71.102 on enP2p1s0f0 to 255.255.255.255 port 67
(xid=0x280dc961)
DHCPACK of 10.245.71.102 from 10.245.71.3 (xid=0x61c90d28)
bound to 10.245.71.102 -- renewal in 236 seconds.
Connecting to 91.189.89.11:3128 (91.189.89.11:3128)
focal-live-server-pp   1% |                                | 14.0M  0:01:04 ETA
focal-live-server-pp   4% |*                               | 45.1M  0:00:38 ETA
focal-live-server-pp   8% |**                              | 76.7M  0:00:33 ETA
focal-live-server-pp  11% |***                             |  105M  0:00:31 ETA
focal-live-server-pp  14% |****                            |  133M  0:00:29 ETA
focal-live-server-pp  17% |*****                           |  163M  0:00:27 ETA
focal-live-server-pp  20% |******                          |  190M  0:00:26 ETA
focal-live-server-pp  24% |*******                         |  222M  0:00:25 ETA
focal-live-server-pp  27% |********                        |  253M  0:00:23 ETA
focal-live-server-pp  30% |*********                       |  283M  0:00:22 ETA
focal-live-server-pp  34% |**********                      |  315M  0:00:21 ETA
focal-live-server-pp  37% |***********                     |  343M  0:00:20 ETA
focal-live-server-pp  39% |************                    |  367M  0:00:19 ETA
focal-live-server-pp  42% |*************                   |  392M  0:00:18 ETA
focal-live-server-pp  45% |**************                  |  420M  0:00:17 ETA
focal-live-server-pp  48% |***************                 |  451M  0:00:16 ETA
focal-live-server-pp  52% |****************                |  482M  0:00:15 ETA
focal-live-server-pp  55% |*****************               |  514M  0:00:14 ETA
focal-live-server-pp  59% |******************              |  546M  0:00:13 ETA
focal-live-server-pp  62% |********************            |  578M  0:00:11 ETA
focal-live-server-pp  65% |*********************           |  607M  0:00:10 ETA
focal-live-server-pp  69% |**********************          |  637M  0:00:09 ETA
focal-live-server-pp  72% |***********************         |  669M  0:00:08 ETA
focal-live-server-pp  75% |************************        |  700M  0:00:07 ETA
focal-live-server-pp  79% |*************************       |  729M  0:00:06 ETA
focal-live-server-pp  82% |**************************      |  758M  0:00:05 ETA
focal-live-server-pp  85% |***************************     |  789M  0:00:04 ETA
focal-live-server-pp  88% |****************************    |  817M  0:00:03 ETA
focal-live-server-pp  91% |*****************************   |  842M  0:00:02 ETA
focal-live-server-pp  93% |******************************  |  867M  0:00:01 ETA
focal-live-server-pp  97% |******************************* |  897M  0:00:00 ETA
focal-live-server-pp 100% |********************************|  922M  0:00:00 ETA
mount: mounting /cow on /root/cow failed: No such file or directory
Connecting to plymouth: Connection refused
passwd: password expiry information changed.
[   47.202736] /dev/loop3: Can't open blockdev
[   52.672550] cloud-init[3759]: Cloud-init v. 20.1-10-g71af48df-0ubuntu1 running
 'init-local' at Wed, 18 Mar 2020 15:18:07 +0000. Up 51.87 seconds.
...
```

Once it has completed, you will reach the initial Subiquity installer screen:

```text
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
    Willkommen! Bienvenue! Welcome! Добро пожаловать! Welkom
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
    Use UP, DOWN and ENTER keys to select your language.

                  [ English                                    ▸ ]
                  [ Asturianu                                  ▸ ]
                  [ Català                                     ▸ ]
                  [ Hrvatski                                   ▸ ]
                  [ Nederlands                                 ▸ ]
                  [ Suomi                                      ▸ ]
                  [ Français                                   ▸ ]
                  [ Deutsch                                    ▸ ]
                  [ Ελληνικά                                   ▸ ]
                  [ Magyar                                     ▸ ]
                  [ Latviešu                                   ▸ ]
                  [ Norsk bokmål                               ▸ ]
                  [ Polski                                     ▸ ]
                  [ Русский                                    ▸ ]
                  [ Español                                    ▸ ]
                  [ Українська                                 ▸ ]
```

From this point, you can follow the normal Subiquity installation. For more details, refer to the [Subiquity installer documentation](https://canonical-subiquity.readthedocs-hosted.com/en/latest/index.html).

---

> 来源：https://ubuntu.com/server/docs/how-to/installation/netboot-the-live-server-installer-on-ibm-power-ppc64el-with-petitboot/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
