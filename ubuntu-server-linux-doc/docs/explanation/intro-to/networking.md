# Introduction to networking

Networks consist of two or more devices which are connected by either physical cabling or wireless links for the purpose of sharing information. Devices can be computer systems, printers, and related equipment.

In this overview, we’ll take a look at some of the key principles involved in networks, and some of the most popular tools available to help you manage your networks.

## Networking key concepts

If you’re new to networking, our explanatory [Networking key concepts](../networking/networking-key-concepts.md#networking-key-concepts) section provides an overview of some important concepts. It includes detailed discussion of the popular network protocols: TCP/IP; IP routing; TCP and UDP; and ICMP.

## Network configuration with Netplan

Ubuntu uses [Netplan](https://netplan.io/) to configure networks. Netplan is a high-level, distribution-agnostic tool that uses a [YAML configuration file](https://netplan.readthedocs.io/en/stable/netplan-yaml/) to define your network setup. Read [more about Netplan](../networking/about-netplan.md#about-netplan).

If you are a server administrator, check out our explanatory guide on [configuring networks”](../networking/configuring-networks.md#configuring-networks).

## Network tools and services

### DHCP

The Dynamic Host Configuration Protocol (DHCP) enables host computers to be automatically assigned settings from a server. To learn more about DHCP and how configuration works, we have [an explanatory guide](../networking/about-dhcp.md#about-dhcp).

The recommended DHCP server for Ubuntu is **`isc-kea`** (available from 23.04 onward). There are also other DHCP servers available, including `dnsmasq` which provides combined DHCP and DNS functionality.

Learn how to [install isc-kea](../../how-to/networking/install-isc-kea.md#install-isc-kea) or explore other [DHCP server options](../networking/about-dhcp.md#about-dhcp).

### Time synchronization

Network Time Protocol (NTP) synchronizes time between all devices on a network to within a few milliseconds of Coordinated Universal Time (UTC). Learn more about [time synchronization](../networking/about-time-synchronisation.md#about-time-synchronisation).

Time is primarily synchronized in Ubuntu by `chrony`. To find out how to configure this service, including Network Time Security (NTS) [read our how-to guide](../../how-to/networking/chrony-client.md#chrony-client).

If you want to set up a server to *provide* NTP information, we suggest `chrony`. Learn [how to serve NTP using chrony](../../how-to/networking/serve-ntp-with-chrony.md#serve-ntp-with-chrony) with this guide.

### The DPDK library

The [Data Plane Development Kit (DPDK)](https://www.dpdk.org/) is a set of libraries that improve network performance. Learn more [about DPDK and its use in Ubuntu](../networking/about-dpdk.md#about-dpdk).

One popular piece of software that uses DPDK is Open vSwitch (OVS). It functions as a virtual switch in virtual machine (VM) environments, providing connectivity between VMs. OVS can run inside a VM or at the hypervisor level. Check out our guide to find out [how to use DPDK with Open vSwitch](../../how-to/networking/dpdk-with-open-vswitch.md#dpdk-with-open-vswitch).

## Other networking functionality

### Samba

If you need to network Ubuntu and Microsoft devices together, use Samba. To get started, check out our [introduction to Samba](samba.md#introduction-to-samba).

---

> 来源：https://ubuntu.com/server/docs/explanation/intro-to/networking/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
