<a id="how-to-networking"></a>

# Networking

This section contains how-to guides on most aspects of networking in Ubuntu. If you would like a broader overview of these topics before getting started, refer to our [introduction to networking](../explanation/intro-to/networking.md#introduction-to-networking).

## Configuration

Network configuration in Ubuntu is handled through Netplan. See our general walk-through on [Configuring networks](../explanation/networking/configuring-networks.md#configuring-networks), or refer to [the Netplan documentation](https://netplan.readthedocs.io/en/stable/) for more specific instructions.

## Network tools

With tools like `vsftp`, Ubuntu can run a File Transfer Protocol (FTP) server for hosting files on a network.

- [Host files with an FTP server](networking/ftp.md)

The Domain Name Service (DNS) maps IP addresses to fully qualified domain names (FQDN). The DNS Security Extensions (DNSSEC) allow DNS data to be verified.

- [Set up a name server (DNS)](networking/install-dns.md)
- [Set up DNS Security Extensions (DNSSEC)](networking/install-dnssec.md)
- [DNSSEC Troubleshooting](networking/dnssec-troubleshooting.md)

Open vSwitch (OVS) with the Data Plane Development Kit (DPDK) provides virtual switching for network automation in virtualized environments.

- [Use Open vSwitch with DPDK](networking/dpdk-with-open-vswitch.md)

NVIDIA DOCA provides the software components required for high-performance networking with NVIDIA BlueField and ConnectX devices.

- [Install DOCA-OFED](networking/install-doca-ofed.md)

## DHCP

Set up Dynamic Host Configuration Protocol (DHCP) for automatic IP address assignment for devices on your network. There are two DHCP servers available in Ubuntu: `isc-kea` is the most modern, and is available from 23.04 onward.

- [Install DHCP isc-kea](networking/install-isc-kea.md)
- [Install DHCP isc-dhcp-server](networking/install-isc-dhcp-server.md)

## Time synchronization

The Network Time Protocol (NTP) synchronizes time over a network. Ubuntu uses `chrony` by default to handle this. However, users can install and use `timedatectl`/`timesyncd` instead if preferred.

- [Time sync with chrony](networking/chrony-client.md)
- [Time sync with timedatectl and timesyncd](networking/timedatectl-and-timesyncd.md)
- [Serving time with chrony](networking/serve-ntp-with-chrony.md)

## Network shares

Sharing files and resources across a network is a common requirement - this is where the Network File System (NFS) comes in.

- [Network File System (NFS) sharing](networking/install-nfs.md)

If you need to share network resources between Linux and Windows systems, see our sections on Samba and Active Directory.

- [Samba](samba.md#how-to-samba)

- [Active Directory integration](active-directory.md#how-to-active-directory-integration)

## Traffic management

Traffic shaping allows you to prioritize certain types of network traffic, reducing latency for interactive applications when using Ubuntu as a router.

- [Traffic shaping with tc and CAKE](networking/traffic-shaping-tc-cake.md)

## Printing

The Common UNIX Printing System (CUPS) is the most common way to manage print services in Ubuntu.

- [Set up a CUPS print server](networking/cups-print-server.md)

## See also

- Explanation: [Networking section](../explanation/networking.md#explanation-networking)

---

> 来源：https://ubuntu.com/server/docs/how-to/networking/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
