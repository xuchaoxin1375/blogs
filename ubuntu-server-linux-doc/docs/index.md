# Ubuntu Server documentation

**Ubuntu Server** is a version of the Ubuntu operating system designed and engineered as a backbone for the internet.

Ubuntu Server brings economic and technical scalability to your data center, public or private. Whether you want to deploy an OpenStack cloud, a Kubernetes cluster or a 50,000-node render farm, Ubuntu Server delivers the best value scale-out performance available.

This documentation always targets the latest LTS version of Ubuntu. When there are differences towards older LTS releases, they are noted in the guide.

## In this documentation

### Getting started

The tutorial walks you through a fresh installation and the first steps of operating an Ubuntu Server.

- **Installation**: [System requirements](reference/installation/system-requirements.md#system-requirements) • [Basic installation](tutorial/basic-installation.md#basic-installation) • [Ubuntu Pro subscription](tutorial/attach-your-ubuntu-pro-subscription.md#attach-your-ubuntu-pro-subscription)

- **System basics**: [Managing software](tutorial/managing-software.md#managing-software) • [Customizing package files](explanation/software/changing-package-files.md#changing-package-files) • [Third party repository usage](explanation/software/third-party-repository-usage.md#third-party-repository-usage)

- **The Ubuntu command line**: [Welcome to the terminal](tutorial/welcome-to-the-terminal.md#welcome-to-the-terminal) • [The command line in depth](tutorial/cli-in-depth.md#cli-in-depth) • [Command-line cheat sheet](reference/cli-cheatsheet.md#command-line-cheat-sheet)

### Networking

Configure network interfaces, provide name and address services, share resources, and synchronize time.

- **Understanding networks**: [Key concepts](explanation/networking/networking-key-concepts.md#networking-key-concepts) • [About Netplan](explanation/networking/about-netplan.md#about-netplan) • [Time synchronization](explanation/networking/about-time-synchronisation.md#about-time-synchronisation)

- **Configuration**: [Using Netplan](explanation/networking/configuring-networks.md#configuring-networks) • [Domain Name System (DNS)](how-to/networking/install-dns.md#install-dns) • [Dynamic Host Configuration Protocol (DHCP)](how-to/networking/install-isc-kea.md#install-isc-kea)

- **Securing your network**: [Install OpenSSH](how-to/security/openssh-server.md#openssh-server) • [Firewalls](how-to/security/firewalls.md#firewalls) • [DNS Security Extensions (DNSSEC)](explanation/dnssec/dnssec.md#dnssec)

- **High throughput**: [Open vSwitch with DPDK](how-to/networking/dpdk-with-open-vswitch.md#dpdk-with-open-vswitch) • [About DPDK](explanation/networking/about-dpdk.md#about-dpdk)

- **Sharing**: [Files with NFS](how-to/networking/install-nfs.md#install-nfs) • [Printers with CUPS](how-to/networking/cups-print-server.md#cups-print-server)

- **With Windows systems**: [Samba](how-to/samba.md#how-to-samba) • [Windows Active Directory](how-to/active-directory.md#how-to-active-directory-integration)

### Security

Protect your system with access controls, firewalls, encrypted communications, and network authentication. For more general information about security in Ubuntu, refer also to the [Ubuntu Security documentation](https://documentation.ubuntu.com/security/).

- **Understanding security**: [Introduction](explanation/intro-to/security.md#introduction-to-security) • [Security suggestions](explanation/security/security_suggestions.md#security-suggestions)

- **Basic security**: [User management](how-to/security/user-management.md#user-management) • [AppArmor](how-to/security/apparmor.md#apparmor)

- **Authentication**: [Install Kerberos](how-to/kerberos/install-a-kerberos-server.md#install-a-kerberos-server) • [Set up SSSD with LDAP](how-to/sssd/with-ldap.md#sssd-with-ldap) • [Smart cards](how-to/security/smart-card-authentication.md#smart-card-authentication)

- **Cryptography**: [Cryptographic libraries](explanation/intro-to/crypto-libraries.md#introduction-to-crypto-libraries) • [About certificates](explanation/security/certificates.md#certificates) • [OpenSSL](explanation/crypto/openssl.md#openssl)

- **VPNs**: [OpenVPN](how-to/security/install-openvpn.md#install-openvpn) • [WireGuard VPN](how-to/wireguard-vpn/on-an-internal-system.md#wireguard-on-an-internal-system)

### Managing your system

Install, update, upgrade, and troubleshoot the software packages running on your system.

- **Managing software**: [Package management](how-to/software/package-management.md#package-management) • [etckeeper](how-to/backups/install-etckeeper.md#install-etckeeper) • [Get older package versions using snapshots](how-to/software/snapshot-service.md#snapshot-service)

- **Update considerations**: [Automatic updates](how-to/software/automatic-updates.md#automatic-updates) • [Phased updates](explanation/software/about-apt-upgrade-and-phased-updates.md#about-apt-upgrade-and-phased-updates) • [Testing updates in advance](explanation/software/advance-testing-of-updates-in-best-practice-server-deployments.md#advance-testing-of-updates-in-best-practice-server-deployments)

- **Upgrade Ubuntu version**: [Release upgrades](how-to/software/upgrade-your-release.md#upgrade-your-release)

- **Troubleshooting**: [Report a bug](how-to/software/report-a-bug.md#report-a-bug) • [Debugging with debuginfod](how-to/debugging/about-debuginfod.md#about-debuginfod) • [Kernel crash dump](how-to/software/kernel-crash-dump.md#kernel-crash-dump)

### Data and storage

Store and manage data using directory services, databases, logical volumes, and backup tools.

- **Databases**: [MySQL](how-to/databases/install-mysql.md#install-mysql) • [PostgreSQL](how-to/databases/install-postgresql.md#install-postgresql)

- **Directory services**: [Introduction to OpenLDAP](explanation/intro-to/openldap.md#introduction-to-openldap) • [Install OpenLDAP](how-to/openldap/install-openldap.md#install-openldap) • [OpenLDAP replication](how-to/openldap/replication.md#ldap-replication)

- **Device mapper multipathing**: [Intro to multipathing](explanation/intro-to/multipath.md#introduction-to-multipath) • [Multipath configuration options and overview](explanation/multipath/configuring-multipath.md#configuring-multipath)

- **Storage**: [About LVM](explanation/storage/about-lvm.md#about-lvm) • [Manage logical volumes](how-to/storage/manage-logical-volumes.md#manage-logical-volumes) • [Sharing data storage with iSCSI](how-to/storage/iscsi-initiator-or-client.md#iscsi-initiator-or-client)

- **Version control**: [gitolite](how-to/backups/install-gitolite.md#install-gitolite)

### Web and mail services

Serve web content, proxy traffic, write server-side applications, and handle email.

- **Web servers**: [About web servers](explanation/web-services/about-web-servers.md#about-web-servers) • [Apache2](how-to/web-services/install-apache2.md#install-apache2) • [nginx](how-to/web-services/install-nginx.md#install-nginx)

- **Squid proxy server**: [About Squid proxy](explanation/web-services/about-squid-proxy-servers.md#about-squid-proxy-servers) • [Install a Squid proxy server](how-to/web-services/install-a-squid-server.md#install-a-squid-server)

- **Mail services**: [Postfix](how-to/mail-services/install-postfix.md#install-postfix) • [Exim4](how-to/mail-services/install-exim4.md#install-exim4) • [Dovecot](how-to/mail-services/install-dovecot.md#install-dovecot)

### Virtualisation and containers

Run workloads in virtual machines and containers using lightweight and full-virtualisation tooling.

- **Understand virtualization**: [Intro to virtualisation](explanation/intro-to/virtualisation.md#introduction-to-virtualization)

- **Virtual machines**: [Multipass](how-to/virtualisation/multipass.md#create-vms-with-multipass) • [QEMU](how-to/virtualisation/qemu.md#qemu) • [QEMU microvm](explanation/virtualisation/qemu-microvm.md#qemu-microvm)

- **VM tooling**: [libvirt and virsh](how-to/virtualisation/libvirt.md#libvirt) • [virt-manager](how-to/virtualisation/virtual-machine-manager.md#virtual-machine-manager) • [Nested virtualization](how-to/virtualisation/enable-nested-virtualisation.md#enable-nested-virtualisation)

- **Containers**: [Docker for system admins](how-to/containers/docker-for-system-admins.md#docker-for-system-admins) • [Docker storage, networking, and logging](explanation/virtualisation/docker-storage-networking-and-logging.md#docker-storage-networking-and-logging) • [Run rocks on your server](how-to/containers/run-rocks-on-your-server.md#run-rocks-on-your-server)

- **Deployment**: [Find cloud images](explanation/clouds/find-cloud-images.md#cloud-images) • [About cloud-init](explanation/intro-to/cloud-init.md#introduction-to-cloud-init) • [LXD](how-to/virtualisation/lxd.md#lxd)

- **Confidential computing**: [AMD SEV](how-to/virtualisation/sev-snp.md#sev-snp) • [Intel TDX](how-to/virtualisation/intel-tdx.md#intel-tdx)

### Performance

Set up GPU resources and optimize system performance.

- **GPU resources**: [Install Nvidia drivers](how-to/graphics/install-nvidia-drivers.md#nvidia-drivers-installation) • [GPU virtualization](how-to/graphics/gpu-virtualization-with-qemu-kvm.md#gpu-virtualization-with-qemu-kvm)

- **Performance**: • [CPU P-states](explanation/performance/perf-p-states.md#perf-p-states) • [hwloc](explanation/performance/perf-tune-hwloc.md#perf-tune-hwloc)

- **Optimization**: [CPU power management](explanation/performance/perf-tune-cpupower.md#perf-tune-cpupower) • [TuneD](explanation/performance/perf-tune-tuned.md#perf-tune-tuned) • [Profile-Guided Optimization](explanation/performance/perf-pgo.md#perf-pgo)

- **High availability**: [Introduction to High Availability](explanation/intro-to/high-availability.md#introduction-to-high-availability) • [Set up DRBD](how-to/high-availability/install-drbd.md#install-drbd) • [Migrate from crmsh to pcs](reference/high-availability/migrate-from-crmsh-to-pcs.md#migrate-from-crmsh-to-pcs)

## How this documentation is organized

This documentation uses the [Diátaxis documentation structure](https://diataxis.fr/).

- The [Tutorial](tutorial/index.md#tutorial) takes you step-by-step through installing and setting up your first Ubuntu Server system.

- [How-to guides](how-to/index.md#how-to) assume basic familiarity with Ubuntu Server and walk you through specific tasks.

- [Reference](reference/index.md#reference) provides system requirements, a glossary, and other technical specifications.

- [Explanation](explanation/index.md#explanation) includes topic overviews, background and context, and detailed discussion of key concepts.

## Project and community

Ubuntu Server is a member of the Ubuntu family. It’s an open source project that welcomes community projects, contributions, suggestions, fixes and constructive feedback.

- [Read our Code of Conduct](https://ubuntu.com/community/docs/ethos/code-of-conduct)

- [Get community support](https://ubuntu.com/support/community-support)

- [Join the Discourse forum](https://discourse.ubuntu.com/c/project/server/17)

- [Chat to us on Matrix](https://matrix.to/#/#server:ubuntu.com)

- [Contribute to this documentation](contributing/index.md#contribute)

If you find any errors or have suggestions for improvements, please use the “Give feedback” button at the top of every page. This will take you to GitHub where you can share your comments or let us know about bugs with any page.

**Releases**

[Download Ubuntu Server](https://ubuntu.com/download/server)

[Ubuntu Release Notes](https://documentation.ubuntu.com/release-notes/)

**PDF versions of this documentation**

[Current PDF](https://ubuntu.com/server/docs/_/downloads/en/latest/pdf/) (for Ubuntu 20.04 LTS onward)

[Ubuntu 18.04 LTS PDF](https://assets.ubuntu.com/v1/8f8ea0cf-18-04-serverguide.pdf) (and earlier)

**Commercial support**

Thinking about using Ubuntu Server for your next project? [Get in touch!](https://ubuntu.com/server/contact-us?product=server)

---

> 来源：https://ubuntu.com/server/docs/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
