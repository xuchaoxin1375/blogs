# iSCSI initiator (or client)

> Wikipedia [iSCSI Definition](https://en.wikipedia.org/wiki/ISCSI):
>
> iSCSI an acronym for **Internet Small Computer Systems Interface** , an [Internet Protocol](https://en.wikipedia.org/wiki/Internet_Protocol) (IP)-based storage networking standard for linking data storage facilities. It provides [block-level access](https://en.wikipedia.org/wiki/Block-level_storage) to [storage devices](https://en.wikipedia.org/wiki/Computer_data_storage) by carrying [SCSI](https://en.wikipedia.org/wiki/SCSI) commands over a [TCP/IP](https://en.wikipedia.org/wiki/TCP/IP) network.
>
> iSCSI is used to facilitate data transfers over [intranets](https://en.wikipedia.org/wiki/Intranet) and to manage storage over long distances. It can be used to transmit data over [local area networks](https://en.wikipedia.org/wiki/Local_area_network) (LANs), [wide area networks](https://en.wikipedia.org/wiki/Wide_area_network) (WANs), or the [Internet](https://en.wikipedia.org/wiki/Internet) and can enable location-independent data storage and retrieval.
>
> The [protocol](https://en.wikipedia.org/wiki/Protocol_(computing)) allows clients (called *initiators*) to send SCSI commands ([*CDBs*](https://en.wikipedia.org/wiki/SCSI_CDB)) to storage devices (*targets*) on remote servers. It is a [storage area network](https://en.wikipedia.org/wiki/Storage_area_network) (SAN) protocol, allowing organizations to consolidate storage into [storage arrays](https://en.wikipedia.org/wiki/Storage_array) while providing clients (such as database and web servers) with the illusion of locally attached SCSI disks.
>
> It mainly competes with [Fibre Channel](https://en.wikipedia.org/wiki/Fibre_Channel), but unlike traditional [Fibre Channel](../../reference/glossary.md#term-FC), which usually requires dedicated cabling, iSCSI can be run over long distances using existing network infrastructure.

Ubuntu Server can be configured as both: **iSCSI initiator** and **iSCSI target**. This guide provides commands and configuration options to setup an **iSCSI initiator** (or Client).

> **Note**
>
> It is assumed that **you already have an iSCSI target on your local network** and have the appropriate rights to connect to it. The instructions for setting up a target vary greatly between hardware providers, so consult your vendor documentation to configure your specific iSCSI target.

## Network Interfaces Configuration

Before start configuring iSCSI, make sure to have the network interfaces correctly set and configured in order to have open-iscsi package to behave appropriately, specially during boot time. In Ubuntu 20.04 LTS, the default network configuration tool is [netplan.io](https://netplan.readthedocs.io/en/latest/examples/).

For all the iSCSI examples below please consider the following netplan configuration for my iSCSI initiator:

> */etc/cloud/cloud.cfg.d/99-disable-network-config.cfg*
>
> ``` text
> {config: disabled}
> ```
>
> */etc/netplan/50-cloud-init.yaml*
>
> ``` yaml
> network:
>     ethernets:
>         enp5s0:
>             match:
>                 macaddress: 00:16:3e:af:c4:d6
>             set-name: eth0
>             dhcp4: true
>             dhcp-identifier: mac
>         enp6s0:
>             match:
>                 macaddress: 00:16:3e:50:11:9c
>             set-name: iscsi01
>             dhcp4: true
>             dhcp-identifier: mac
>             dhcp4-overrides:
>               route-metric: 300
>         enp7s0:
>             match:
>                 macaddress: 00:16:3e:b3:cc:50
>             set-name: iscsi02
>             dhcp4: true
>             dhcp-identifier: mac
>             dhcp4-overrides:
>               route-metric: 300
>     version: 2
>     renderer: networkd
> ```

With this configuration, the interfaces names change by matching their mac addresses. This makes it easier to manage them in a server containing multiple interfaces.

From this point and beyond, 2 interfaces are going to be mentioned: **iscsi01** and **iscsi02**. This helps to demonstrate how to configure iSCSI in a multipath environment as well (check the Device Mapper Multipath session in this same Server Guide).

> If you have only a single interface for the iSCSI network, make sure to follow the same instructions, but only consider the **iscsi01** interface command line examples.

## iSCSI Initiator Install

To configure Ubuntu Server as an iSCSI initiator install the open-iscsi package. In a terminal enter:

```console
$ sudo apt install open-iscsi
```

Once the package is installed you will find the following files:

- `/etc/iscsi/iscsid.conf`

- `/etc/iscsi/initiatorname.iscsi`

## iSCSI Initiator Configuration

Configure the main configuration file like the example below:

> `/etc/iscsi/iscsid.conf`

```text
### startup settings

## will be controlled by systemd, leave as is
iscsid.startup = /usr/sbin/iscsidnode.startup = manual

### chap settings

# node.session.auth.authmethod = CHAP

## authentication of initiator by target (session)
# node.session.auth.username = username
# node.session.auth.password = password

# discovery.sendtargets.auth.authmethod = CHAP

## authentication of initiator by target (discovery)
# discovery.sendtargets.auth.username = username
# discovery.sendtargets.auth.password = password

### timeouts

## control how much time iscsi takes to propagate an error to the
## upper layer. if using multipath, having 0 here is desirable
## so multipath can handle path errors as quickly as possible
## (and decide to queue or not if missing all paths)
node.session.timeo.replacement_timeout = 0

node.conn[0].timeo.login_timeout = 15
node.conn[0].timeo.logout_timeout = 15

## interval for a NOP-Out request (a ping to the target)
node.conn[0].timeo.noop_out_interval = 5

## and how much time to wait before declaring a timeout
node.conn[0].timeo.noop_out_timeout = 5

## default timeouts for error recovery logics (lu & tgt resets)
node.session.err_timeo.abort_timeout = 15
node.session.err_timeo.lu_reset_timeout = 30
node.session.err_timeo.tgt_reset_timeout = 30

### retry

node.session.initial_login_retry_max = 8

### session and device queue depth

node.session.cmds_max = 128
node.session.queue_depth = 32

### performance

node.session.xmit_thread_priority = -20
```

and re-start the iSCSI daemon:

```console
$ systemctl restart iscsid.service
```

This will set basic things up for the rest of configuration.

The other file mentioned:

> `/etc/iscsi/initiatorname.iscsi`

```text
InitiatorName=iqn.2004-10.com.ubuntu:01:60f3517884c3
```

contains this node’s initiator name and is generated during `open-iscsi` package installation. If you modify this setting, make sure that you don’t have duplicates in the same iSCSI SAN (Storage Area Network).

## iSCSI Network Configuration

Before configuring the Logical Units that are going to be accessed by the initiator, it is important to inform the iSCSI service what are the interfaces acting as paths.

A straightforward way to do that is by:

- configuring the following environment variables:

  ``` console

  $ iscsi01_ip=$(ip -4 -o addr show iscsi01 | sed -r 's:.* (([0-9]{1,3}\.){3}[0-9]{1,3})/.*:\1:')
  ```

  ``` console

  $ iscsi02_ip=$(ip -4 -o addr show iscsi02 | sed -r 's:.* (([0-9]{1,3}\.){3}[0-9]{1,3})/.*:\1:')
  ```

  ``` console

  $ iscsi01_mac=$(ip -o link show iscsi01 | sed -r 's:.*\s+link/ether (([0-f]{2}(\:|)){6}).*:\1:g')
  ```

  ``` console

  $ iscsi02_mac=$(ip -o link show iscsi02 | sed -r 's:.*\s+link/ether (([0-f]{2}(\:|)){6}).*:\1:g')
  ```

- configuring **`iscsi01`** interface:

  ``` console

  $ sudo iscsiadm -m iface -I iscsi01 --op=new
  ```

  ``` console

  $ sudo iscsiadm -m iface -I iscsi01 --op=update -n iface.hwaddress -v $iscsi01_mac
  ```

  ``` console

  $ sudo iscsiadm -m iface -I iscsi01 --op=update -n iface.ipaddress -v $iscsi01_ip
  ```

- configuring **`iscsi02`** interface

  ``` console

  $ sudo iscsiadm -m iface -I iscsi02 --op=new
  ```

  ``` console

  $ sudo iscsiadm -m iface -I iscsi02 --op=update -n iface.hwaddress -v $iscsi02_mac
  ```

  ``` console

  $ sudo iscsiadm -m iface -I iscsi02 --op=update -n iface.ipaddress -v $iscsi02_ip
  ```

- discovering the **targets**:

  ``` console

  $ sudo iscsiadm -m discovery -I iscsi01 --op=new --op=del --type sendtargets --portal storage.iscsi01
  ```

  ``` console

  $ sudo iscsiadm -m discovery -I iscsi02 --op=new --op=del --type sendtargets --portal storage.iscsi02
  ```

- configuring **automatic login**

  ``` console

  $ sudo iscsiadm -m node --op=update -n node.conn[0].startup -v automatic
  ```

  ``` console

  $ sudo iscsiadm -m node --op=update -n node.startup -v automatic
  ```

- make sure needed **services** are enabled during OS initialization:

  ``` console

  $ systemctl enable open-iscsi
  ```

  ``` console

  $ systemctl enable iscsid
  ```

- restarting **`iscsid`** service:

  ``` console

  $ systemctl restart iscsid.service
  ```

- and, finally, **login in** discovered logical units:

  ``` console

  $ sudo iscsiadm -m node --loginall=automatic
  ```

## Accessing the Logical Units (or LUNs)

Check [dmesg](../../reference/glossary.md#term-dmesg) to make sure that the new disks have been detected:

> `dmesg`

```text
[  166.840694] scsi 7:0:0:4: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
[  166.840892] scsi 8:0:0:4: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
[  166.841741] sd 7:0:0:4: Attached scsi generic sg2 type 0
[  166.841808] sd 8:0:0:4: Attached scsi generic sg3 type 0
[  166.842278] scsi 7:0:0:3: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
[  166.842571] scsi 8:0:0:3: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
[  166.843482] sd 8:0:0:3: Attached scsi generic sg4 type 0
[  166.843681] sd 7:0:0:3: Attached scsi generic sg5 type 0
[  166.843706] sd 8:0:0:4: [sdd] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
[  166.843884] scsi 8:0:0:2: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
[  166.843971] sd 8:0:0:4: [sdd] Write Protect is off
[  166.843972] sd 8:0:0:4: [sdd] Mode Sense: 2f 00 00 00
[  166.844127] scsi 7:0:0:2: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
[  166.844232] sd 7:0:0:4: [sdc] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
[  166.844421] sd 8:0:0:4: [sdd] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
[  166.844566] sd 7:0:0:4: [sdc] Write Protect is off
[  166.844568] sd 7:0:0:4: [sdc] Mode Sense: 2f 00 00 00
[  166.844846] sd 8:0:0:2: Attached scsi generic sg6 type 0
[  166.845147] sd 7:0:0:4: [sdc] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
[  166.845188] sd 8:0:0:4: [sdd] Optimal transfer size 65536 bytes
[  166.845527] sd 7:0:0:2: Attached scsi generic sg7 type 0
[  166.845678] sd 8:0:0:3: [sde] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
[  166.845785] scsi 8:0:0:1: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
[  166.845799] sd 7:0:0:4: [sdc] Optimal transfer size 65536 bytes
[  166.845931] sd 8:0:0:3: [sde] Write Protect is off
[  166.845933] sd 8:0:0:3: [sde] Mode Sense: 2f 00 00 00
[  166.846424] scsi 7:0:0:1: Direct-Access     LIO-ORG  TCMU device >      0002 PQ: 0 ANSI: 5
[  166.846552] sd 8:0:0:3: [sde] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
[  166.846708] sd 7:0:0:3: [sdf] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
[  166.847024] sd 8:0:0:1: Attached scsi generic sg8 type 0
[  166.847029] sd 7:0:0:3: [sdf] Write Protect is off
[  166.847031] sd 7:0:0:3: [sdf] Mode Sense: 2f 00 00 00
[  166.847043] sd 8:0:0:3: [sde] Optimal transfer size 65536 bytes
[  166.847133] sd 8:0:0:2: [sdg] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
[  166.849212] sd 8:0:0:2: [sdg] Write Protect is off
[  166.849214] sd 8:0:0:2: [sdg] Mode Sense: 2f 00 00 00
[  166.849711] sd 7:0:0:3: [sdf] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
[  166.849718] sd 7:0:0:1: Attached scsi generic sg9 type 0
[  166.849721] sd 7:0:0:2: [sdh] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
[  166.853296] sd 8:0:0:2: [sdg] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
[  166.853721] sd 8:0:0:2: [sdg] Optimal transfer size 65536 bytes
[  166.853810] sd 7:0:0:2: [sdh] Write Protect is off
[  166.853812] sd 7:0:0:2: [sdh] Mode Sense: 2f 00 00 00
[  166.854026] sd 7:0:0:3: [sdf] Optimal transfer size 65536 bytes
[  166.854431] sd 7:0:0:2: [sdh] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
[  166.854625] sd 8:0:0:1: [sdi] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
[  166.854898] sd 8:0:0:1: [sdi] Write Protect is off
[  166.854900] sd 8:0:0:1: [sdi] Mode Sense: 2f 00 00 00
[  166.855022] sd 7:0:0:2: [sdh] Optimal transfer size 65536 bytes
[  166.855465] sd 8:0:0:1: [sdi] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
[  166.855578] sd 7:0:0:1: [sdj] 2097152 512-byte logical blocks: > (1.07 GB/1.00 GiB)
[  166.855845] sd 7:0:0:1: [sdj] Write Protect is off
[  166.855847] sd 7:0:0:1: [sdj] Mode Sense: 2f 00 00 00
[  166.855978] sd 8:0:0:1: [sdi] Optimal transfer size 65536 bytes
[  166.856305] sd 7:0:0:1: [sdj] Write cache: enabled, read cache: > enabled, doesn't support DPO or FUA
[  166.856701] sd 7:0:0:1: [sdj] Optimal transfer size 65536 bytes
[  166.859624] sd 8:0:0:4: [sdd] Attached SCSI disk
[  166.861304] sd 7:0:0:4: [sdc] Attached SCSI disk
[  166.864409] sd 8:0:0:3: [sde] Attached SCSI disk
[  166.864833] sd 7:0:0:3: [sdf] Attached SCSI disk
[  166.867906] sd 8:0:0:2: [sdg] Attached SCSI disk
[  166.868446] sd 8:0:0:1: [sdi] Attached SCSI disk
[  166.871588] sd 7:0:0:1: [sdj] Attached SCSI disk
[  166.871773] sd 7:0:0:2: [sdh] Attached SCSI disk
```

In the output above you will find **8 x SCSI disks** recognized. The storage server is mapping **4 x LUNs** to this node, AND the node has **2 x PATHs** to each LUN. The OS recognizes each path to each device as 1 SCSI device.

You will find different output depending on the storage server your node is mapping the LUNs from, and the amount of LUNs being mapped as well.

Although not the objective of this session, let’s find the 4 mapped LUNs using multipath-tools.

You will find further details about multipath in [Introduction to device mapper multipathing (“multipath”)](../../explanation/intro-to/multipath.md#introduction-to-multipath).

```console
$ apt-get install multipath-tools
```

```console
$ sudo multipath -r
```

```console
$ sudo multipath -ll
```

Now it is much easier to understand each recognized SCSI device and common paths to same LUNs in the storage server. With the output above one can easily see that:

- **`mpatha` device** (`/dev/mapper/mpatha`) is a multipath device for:

  - `/dev/sdj`

  - `/dev/dsi`

- **`mpathb` device** (`/dev/mapper/mpathb`) is a multipath device for:

  - `/dev/sdh`

  - `/dev/dsg`

- **`mpathc` device** (`/dev/mapper/mpathc`) is a multipath device for:

  - `/dev/sdf`

  - `/dev/sdd`

- **`mpathd` device** (`/dev/mapper/mpathd`) is a multipath device for:

  - `/dev/sde`

  - `/dev/sdc`

> **Warning**
>
> **Do not use this in production** without checking appropriate multipath configuration options in the **Device Mapper Multipathing** section. The *default multipath configuration* is sub-optimal for regular usage.

Finally, to access the LUN (or remote iSCSI disk) you will:

- If accessing through a single network interface:

  - access it through /dev/sdX where X is a letter given by the OS

- If accessing through multiple network interfaces:

  - configure multipath and access the device through /dev/mapper/X

For everything else, the created devices are block devices and all commands used with local disks should work the same way:

- Creating a partition:

  ``` console

  $ sudo fdisk /dev/mapper/mpatha
  ```

- Creating a [filesystem](../../reference/glossary.md#term-filesystem):

  ``` console

  $ sudo mkfs.ext4 /dev/mapper/mpatha-part1
  ```

- Mounting the block device:

  ``` console

  $ sudo mount /dev/mapper/mpatha-part1 /mnt
  ```

- Accessing the data:

  ``` console

  $ ls /mnt
  ```

Make sure to read other important sessions in Ubuntu Server Guide to follow up with concepts explored in this one.

## Further reading

- [`iscsid`](https://linux.die.net/man/8/iscsid)

- [`iscsi.conf`](https://linux.die.net/man/5/iscsi.conf)

- [`iscsid.conf`](https://github.com/open-iscsi/open-iscsi/blob/master/etc/iscsid.conf)

- [`iscsi.service`](https://github.com/open-iscsi/open-iscsi/blob/master/etc/systemd/iscsi.service.template)

- [`iscsid.service`](https://github.com/open-iscsi/open-iscsi/blob/master/etc/systemd/iscsid.service.template)

- [Open-iSCSI](http://www.open-iscsi.com/)

- [Debian Open-iSCSI](https://wiki.debian.org/SAN/iSCSI/open-iscsi)

---

> 来源：https://ubuntu.com/server/docs/how-to/storage/iscsi-initiator-or-client/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
