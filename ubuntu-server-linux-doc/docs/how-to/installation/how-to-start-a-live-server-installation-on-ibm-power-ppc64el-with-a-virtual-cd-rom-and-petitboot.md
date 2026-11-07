# How to start a live server installation on IBM Power (ppc64el) with a virtual CD-ROM and Petitboot

> **Note**
>
> Not all IBM Power machines come with the capability of installing via a virtual CD-ROM! However, it is also possible to [boot the installer over the network](netboot-the-live-server-installer-on-ibm-power-ppc64el-with-petitboot.md#netboot-the-live-server-installer-on-ibm-power-ppc64el-with-petitboot).

A separate system (ideally in the same network, because of `ipmitool`) is needed to host the ppc64el ISO image file, which is later used as the virtual CD-ROM.

## Install ipmitool and Samba

Log in to this separate host and make sure that the `ipmitool` package is installed:

```console
$ sudo apt install ipmitool
```

as well as Samba:

```console
$ sudo apt install samba
```

## Configure Samba

Next, set up and configure Samba:

```console
$ sudo touch /etc/samba/smb.conf && sudo tee -a /etc/samba/smb.conf <<EOF
```

And do a quick verification that the required lines are present:

```console
$ tail -n 5 /etc/samba/smb.conf
```

> **Optional step**
>
> For downloading the image you may have to use a proxy server:
>
> ``` console
>
> $ sudo touch ~/.wgetrc && sudo tee -a ~/.wgetrc <<EOF
> > use_proxy=yes
> > http_proxy=squid.proxy:3128
> > https_proxy=squid.proxy:3128
> > EOF
> ```

## Download the ISO image

The ISO image needs to be downloaded now:

```console
$ wget http://cdimage.ubuntu.com/ubuntu/releases/focal/release/ubuntu-20.04-live-server-ppc64el.iso --directory-prefix=/var/winshare
```

The proxy can also be passed over as a `wget` argument, like this:

```console
$ wget -e use_proxy=yes -e http_proxy=squid.proxy:3128 http://cdimage.ubuntu.com/ubuntu/releases/focal/release/ubuntu-20.04-live-server-ppc64el.iso --directory-prefix=/var/winshare
```

Change the file mode of the ISO image file:

```console
$ sudo chmod -R 755 /var/winshare/
```

```console
$ ls -l /var/winshare/
```

## Restart and check Samba

Next we need to restart and check the Samba service:

```console
$ sudo service smbd restart
```

```console
$ sudo service smbd status
```

Test Samba share:

```console
ubuntu@host:~$ smbclient -L localhost
```

Get the IP address of the Samba host:

```console
$ ip -4 -brief address show
```

> **Optional step**
>
> Additional testing to make certain the Samba share is accessible from remote:
>
> ``` console
>
> user@workstation:~$ mkdir -p /tmp/test
> ```
>
> ``` console
>
> user@workstation:~$ sudo mount -t cifs -o
> ```
>
> ``` console
>
> user@workstation:~$ ls -la /tmp/test/
> ```

Now use a browser and navigate to the [BMC](../../reference/glossary.md#term-BMC) of the Power system, which should be installed (let’s assume the BMC’s IP address is `10.245.246.247`):

```text
firefox http://10.245.246.247/
```

Log into the BMC, then find and select:

> Virtual Media –\> CD-ROM

Enter the IP address of the Samba share:

> 10.245.246.42

and the path to the Samba share:

```text
\winshare\focal-live-server-ppc64el.iso
```

Click “Save and Mount”. Make sure that the virtual CD-ROM is really properly mounted!

```text
CD-ROM Image:

This option allows you to share a CD-ROM image over a Windows Share with a
maximum size of 4.7GB. This image will be emulated to the host as USB device.

Device 1    There is an iso file mounted.
Device 2    No disk emulation set.
Device 3    No disk emulation set.
<Refresh Status>
```

```text
Share host: 10.245.246.42
Path to image: \winshare\focal-live-server-ppc64el.iso
User (optional):
Password (optional):
<Save> <Mount> <Unmount>
```

> **Note**
>
> It’s important that you see a status like this:
>
> ``` text
> Device 1 There is an iso file mounted
> ```
>
> Then the virtual CD-ROM is properly mounted and you will see the boot/install from CD-ROM entry in Petitboot:
>
> ``` text
> [CD/DVD: sr0 / 2020-03-23-08-02-42-00]
>   Install Ubuntu Server
> ```

## Boot into the Petitboot loader

Now use `ipmitool` to boot the system into the Petitboot loader:

```console
$ ipmitool -I lanplus -H 10.245.246.247 -U ADMIN -P <password> power status
```

```console
$ ipmitool -I lanplus -H 10.245.246.247 -U ADMIN -P <password> sol activate
```

```console
$ ipmitool -I lanplus -H 10.245.246.247 -U ADMIN -P <password> power on
```

And reach the Petitboot screen:

```text
Petitboot (v1.7.5-p8f5fc86)                                   9006-12C BOS0026
 ─────────────────────────────────────────────
  [Network: enP2p1s0f0 / ac:1f:6b:09:c0:52]
    execute
    netboot enP2p1s0f0 (pxelinux.0)

  System information
  System configuration
  System status log
  Language
  Rescan devices
  Retrieve config from URL
 *Plugins (0)
  Exit to shell
─────────────────────────────────────────────
 Enter=accept, e=edit, n=new, x=exit, l=language, g=log, h=help
 Default boot cancelled
```

Make sure that booting from CD-ROM is enabled:

```text
Petitboot (v1.7.5-p8f5fc86)                                   9006-12C BOS0026
─────────────────────────────────────────────
  [Network: enP2p1s0f0 / ac:1f:6b:09:c0:52]
    Execute
    netboot enP2p1s0f0 (pxelinux.0)
  [Disk: sda2 / ebdb022b-96b2-4f4f-ae63-69300ded13f4]
    Ubuntu, with Linux 5.4.0-12-generic (recovery mode)
    Ubuntu, with Linux 5.4.0-12-generic
    Ubuntu

  System information
  System configuration
  System status log
  Language
  Rescan devices
  Retrieve config from URL
 *Plugins (0)
  Exit to shell

─────────────────────────────────────────────
 Enter=accept, e=edit, n=new, x=exit, l=language, g=log, h=help
 [sda3] Processing new Disk device
```

```text
Petitboot System Configuration

──────────────────────────────────────────────

  Autoboot:      ( ) Disabled
                 (*) Enabled

  Boot Order:    (0) Any CD/DVD device
                 (1) disk: sda2 [uuid: ebdb022b-96b2-4f4f-ae63-69300ded13f4]
                 (2) net:  enP2p1s0f0 [mac: ac:1f:6b:09:c0:52]

                 [     Add Device     ]
                 [  Clear & Boot Any  ]
                 [       Clear        ]

  Timeout:       30    seconds


  Network:       (*) DHCP on all active interfaces
                 ( ) DHCP on a specific interface
                 ( ) Static IP configuration

─────────────────────────────────────────────
 tab=next, shift+tab=previous, x=exit, h=help
```

```text
Petitboot System Configuration
─────────────────────────────────────────────
  Network:       (*) DHCP on all active interfaces
                 ( ) DHCP on a specific interface
                 ( ) Static IP configuration

  DNS Server(s):                                   (eg. 192.168.0.2)
                 (if not provided by DHCP server)
  HTTP Proxy:
  HTTPS Proxy:

  Disk R/W:      ( ) Prevent all writes to disk
                 (*) Allow bootloader scripts to modify disks

  Boot console:  (*) /dev/hvc0 [IPMI / Serial]
                 ( ) /dev/tty1 [VGA]
                 Current interface: /dev/hvc0

                 [    OK    ]  [   Help   ]  [  Cancel  ]

───────────────────────────────────────────
 tab=next, shift+tab=previous, x=exit, h=help
```

Now select the ‘Install Ubuntu Server’ entry below the CD/DVD entry:

```text
  [CD/DVD: sr0 / 2020-03-23-08-02-42-00]
  *  Install Ubuntu Server
```

And let Petitboot boot from the (virtual) CD-ROM image:

```text
Sent SIGKILL to all processes
[  119.355371] kexec_core: Starting new kernel
[  194.483947394,5] OPAL: Switch to big-endian OS
[  197.454615202,5] OPAL: Switch to little-endian OS
```

The initial Subiquity installer screen will show up in the console:

```text
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
  Willkommen! Bienvenue! Welcome! Добро пожаловать! Welkom
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
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

> 来源：https://ubuntu.com/server/docs/how-to/installation/how-to-start-a-live-server-installation-on-ibm-power-ppc64el-with-a-virtual-cd-rom-and-petitboot/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
