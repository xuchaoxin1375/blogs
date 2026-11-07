<a id="reference-glossary"></a>

# Glossary

We are currently compiling and defining terms for this glossary. If you would like to help, please visit our [contributions page](../contributing/index.md#contribute) for details on how to get involved.

**Jump to:**

[A](glossary.md#terms-a) – [B](glossary.md#terms-b) – [C](glossary.md#terms-c) – [D](glossary.md#terms-d) – [E](glossary.md#terms-e) – [F](glossary.md#terms-f) – [G](glossary.md#terms-g) – [H](glossary.md#terms-h) – [I](glossary.md#terms-i) – [J](glossary.md#terms-j) – [K](glossary.md#terms-k) – [L](glossary.md#terms-l) – [M](glossary.md#terms-m) – [N](glossary.md#terms-n) – [O](glossary.md#terms-o) – [P](glossary.md#terms-p) – [Q](glossary.md#terms-q) – [R](glossary.md#terms-r) – [S](glossary.md#terms-s) – [T](glossary.md#terms-t) – [U](glossary.md#terms-u) – [V](glossary.md#terms-v) – [W](glossary.md#terms-w) – [X](glossary.md#terms-x) – [Y](glossary.md#terms-y) – [Z](glossary.md#terms-z)

<a id="terms-a"></a>

## A

<a id="term-ABI"></a>

**ABI**

<a id="term-Application-Binary-Interface"></a>

**Application Binary Interface**

An ABI is an interface that defines how two modules interact with each other at the machine code level. Most often, these modules are applications using external libraries. An ABI defines a low-level and hardware-dependent interface compared to an [API](glossary.md#term-API), which is considered high-level and hardware-independent.

<a id="term-ACL"></a>

**ACL**

<a id="term-Access-Control-List"></a>

**Access Control List**

An ACL is a list of access permissions that defines entities and their access rights to resources. ACLs can specify access with varying levels of granularity, ranging from full access to a resource, to permission for a specific operation.

See also:

- *[the ACL manual page](https://manpages.ubuntu.com/manpages/resolute/man5/acl.5.html)*

Related topic(s):

- Security, [OpenLDAP](glossary.md#term-OpenLDAP), and [Kerberos](glossary.md#term-Kerberos)

<a id="term-AD"></a>

**AD**

<a id="term-Active-Directory"></a>

**Active Directory**

An AD is a Microsoft service that acts as a central database storing and managing information about network objects (user accounts, groups, computers and shared resources) and their security in a Windows-based network.

<a id="term-ADSys"></a>

**ADSys**

ADSys is an Ubuntu-specific Active Directory ([AD](glossary.md#term-AD)) client developed by Canonical. ADSys complements System Security Services Daemon ([SSSD](glossary.md#term-SSSD)) by adding native Group Policy Object support, privilege management, and custom scripts execution.

See also:

- [the ADSys documentation](https://documentation.ubuntu.com/adsys/stable/)

Related topic(s):

- [Group Policy Object](glossary.md#term-Group-Policy-Object) and [SSSD](glossary.md#term-SSSD)

<a id="term-AES"></a>

**AES**

<a id="term-Advanced-Encryption-Standard"></a>

**Advanced Encryption Standard**

An AES is a symmetric encryption algorithm designed to encrypt data securely into an unreadable format that can only be decrypted with the same key used for encryption.

Related topic(s):

- Security

<a id="term-Alertmanager"></a>

**Alertmanager**

Alertmanager is an open-source monitoring system developed by the Prometheus project to monitor and handle alerts. It offers several key features, including *Grouping* to combine alerts, *Inhibition* to suppress certain alerts when others are already firing, and *Silencing* to temporarily mute specific alerts.

See also:

- [the Alertmanager documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)

Related topic(s):

- Observability and [Prometheus](glossary.md#term-Prometheus)

<a id="term-ALUA"></a>

**ALUA**

<a id="term-Asymmetric-Logical-Unit-Access"></a>

**Asymmetric Logical Unit Access**

It is a storage concept used in Small Computer System Interface (SCSI) environments, particularly in Multi-Path Input/Output (MPIO) setups for shared storage systems like Storage Area Networks (SANs). ALUA informs a system about which paths to a storage device are optimal and which are non-optimal, enabling it to make smarter decisions about accessing shared disks.

Related topic(s):

- [MPIO](glossary.md#term-MPIO) [SCSI](glossary.md#term-SCSI), [SAN](glossary.md#term-SAN)

<a id="term-AMD"></a>

**AMD**

<a id="term-Advanced-Micro-Devices"></a>

**Advanced Micro Devices**

AMD can refer to:

- The (AMD) company: semiconductor company that designs computer components

- An AMD processor: a microprocessor designed and produced by the AMD company

- All Intel/AMD 64-bit processors: the term “amd64” is commonly used to refer to 64-bit processors due to the company’s role in developing this architecture.

Related topic(s):

- Networking

<a id="term-AMD-SME"></a>

**AMD-SME**

<a id="term-AMD-Secure-Memory-Encryption"></a>

**AMD Secure Memory Encryption**

AMD-SME is a security technology that transparently encrypts all system memory to protect data at rest. It encrypts the entire memory address space of the system using a key derived from the processor, protecting against physical attacks on memory.

Related topic(s):

- Cryptography, Security

<a id="term-AMD-SEV"></a>

**AMD-SEV**

<a id="term-AMD-Secure-Encrypted-Virtualization"></a>

**AMD Secure Encrypted Virtualization**

AMD-SEV is a security technology that encrypts the memory of virtual machines (guests) independently from the host system. It uses a dedicated memory encryption key for each guest VM, preventing the hypervisor from reading or modifying guest memory. This protects guest confidentiality even when the hypervisor is compromised.

Related topic(s):

- Cryptography, Security, Virtualization

<a id="term-AMD-SEV-ES"></a>

**AMD-SEV-ES**

<a id="term-AMD-Secure-Encrypted-Virtualization-Encrypted-State"></a>

**AMD Secure Encrypted Virtualization - Encrypted State**

AMD-SEV-ES extends [AMD-SEV](glossary.md#term-AMD-SEV) by encrypting the entire VM state, including CPU register contents, in addition to guest memory. This provides enhanced protection against hypervisor-based attacks by preventing the hypervisor from reading or modifying sensitive VM state during execution.

Related topic(s):

- Cryptography, Security, Virtualization

<a id="term-AMD-SEV-SNP"></a>

**AMD-SEV-SNP**

<a id="term-AMD-Secure-Encrypted-Virtualization-Secure-Nested-Paging"></a>

**AMD Secure Encrypted Virtualization - Secure Nested Paging**

AMD-SEV-SNP is an extension of [AMD-SEV-ES](glossary.md#term-AMD-SEV-ES) that adds integrity protection for guest memory using Secure Nested Paging. It prevents the hypervisor from modifying guest memory contents and provides cryptographic attestation of the VM’s launch state, ensuring the integrity and confidentiality of guest data.

Related topic(s):

- Cryptography, Security, Virtualization

<a id="term-Ansible"></a>

**Ansible**

Ansible is an open-source IT automation tool developed by Red Hat. It offers several automation features, enabling developers and organizations to automate provisioning, configuration management, and application deployment.

See also:

- [The Ansible website](https://docs.ansible.com/)

Related topic(s):

- Automation

<a id="term-Apache2"></a>

**Apache2**

A robust, open-source [HTTP](glossary.md#term-HTTP) server software designed for the deployment and delivery of web-based applications and content. Functioning as a request-response service, Apache 2 processes [HTTP](glossary.md#term-HTTP) requests from client applications, facilitating the transmission of static and dynamic web resources. It has a modular architecture, supporting a wide array of extensions, enabling customizable functionality including security protocols (e.g., [SSL](glossary.md#term-SSL)/[TLS](glossary.md#term-TLS)), server-side scripting, and content management.

Widely deployed in server environments, Apache 2 is a foundational component of numerous web infrastructure stacks, underpinning a substantial portion of internet-accessible services.

See also:

- [The Apache project documentation](https://httpd.apache.org/docs/2.4/)

Related topic(s):

- Web services

<a id="term-API"></a>

**API**

<a id="term-Application-Programming-Interface"></a>

**Application Programming Interface**

An API is a type of software interface that acts as a connection between different software programs, allowing them to communicate and exchange data. APIs exist on multiple layers of abstraction, from low-level APIs closest to system hardware to high-level web APIs that enable clients and remote servers to communicate.

<a id="term-AppArmor"></a>

**AppArmor**

AppArmor is a Linux security module that provides [Mandatory Access Control (MAC)](glossary.md#term-MAC) for programs. AppArmor restricts what applications can do, even when they are compromised. It enforces a set of security policies (called profiles) that define what files, capabilities, and system resources a given program is allowed to access.

See also:

- [The AppArmor website](https://apparmor.net/)

Related topic(s):

- Security

<a id="term-Apport"></a>

**Apport**

Apport is a debugging tool and crash reporting system used in Ubuntu and Debian-based Linux distributions. It can automatically detect crashes in programs and system services, collect detailed diagnostic data, generate crash reports, and prompt the user to send the report to developers via systems like Launchpad. It is typically disabled by default on production systems because it can expose sensitive information in logs, but is used during development or testing.

See also:

- [The Apport Wiki Page](https://wiki.ubuntu.com/Apport)

Related topic(s):

- Debugging

<a id="term-APT"></a>

**APT**

<a id="term-Advanced-Package-Tool"></a>

**Advanced Package Tool**

APT is a package management system used by Debian and Debian-based Linux distributions like Ubuntu. APT helps install, update, upgrade, and remove software packages from the command line.

See also:

- [Install and manage packages](../how-to/software/package-management.md#package-management)

<a id="term-armhf"></a>

**armhf**

<a id="term-ARM-hard-float"></a>

**ARM hard-float**

armhf is a designation used in Linux distributions to describe a 32-bit variant of the ARM architecture that has hardware-based floating-point support. armhf is typically used for lightweight systems or backward compatibility, especially in embedded environments.

Related topic(s):

- arm32, arm64

<a id="term-ARP"></a>

**ARP**

<a id="term-Address-Resolution-Protocol"></a>

**Address Resolution Protocol**

ARP is a network protocol used to map an IP address to a physical machine ([MAC address](glossary.md#term-MAC-address)) on a local area network (LAN).

Related topic(s):

- Networking

<a id="term-ASCII"></a>

**ASCII**

<a id="term-American-Standard-Code-for-Information-Interchange"></a>

**American Standard Code for Information Interchange**

A character encoding standard.

<a id="term-async"></a>

**async**

<a id="term-asynchronous"></a>

**asynchronous**

A term commonly used in programming to describe operations that take place without blocking the main execution thread. Instead of waiting for a particular operation to finish (such as reading a file or making a network request), “async” programs can keep running other operations in the meantime. These operations are often dispatched to the background, allowing them to run in parallel. If needed, however, the program can still wait for the result of an asynchronous operation.

Related topic(s):

- Concurrency, parallelism, and threading

<a id="term-attestation"></a>

**attestation**

In Confidential or Trusted Computing contexts, attestation refers both to the process of generating verifiable evidence about the trustworthiness of a system, and to the artifact produced by that process (commonly called an attestation report or quote).

- As a process: A TEE or TPM measures critical system components (firmware, boot chain, enclave/VM code) and cryptographically signs these measurements with keys rooted in hardware trust. The evidence is then checked by a verifier against reference values or policies.

- As a document: The signed report (attestation) is the concrete proof presented to a verifier. It contains the measurements and cryptographic signatures used to establish trust.

Attestation may be local (between components on the same host) or remote (to an external verifier). It underpins measured boot, secure provisioning, and Confidential Computing workloads.

<a id="term-Authenticator"></a>

**Authenticator**

An authenticator is any system, method, or mechanism used to verify a user’s identity during the authentication process. It can range from something as simple as a password field (e.g., LDAP [bind](glossary.md#term-bind)) to more advanced tools like biometric scanners or one-time code generators. Authenticators are essential components of authentication protocols and can be used in both single-factor and multi-factor authentication setups.

Related topic(s):

- OpenLDAP, authentication

<a id="term-autocommit"></a>

**autocommit**

autocommit is a database feature that automatically commits every individual SQL statement as soon as it is executed. When autocommit is enabled, every SQL statement is treated as its own transaction and is applied immediately and permanently.

This means it is impossible to undo or roll back a statement executed with autocommit enabled. While autocommit is a common default in many systems, behavior can vary depending on the database or language bindings. For example, in Python’s `sqlite3` module, Python 3.12 introduces changes to transaction control, allowing explicit control over autocommit mode.

See also:

- [autocommit behavior in Python’s `sqlite3` module](https://docs.python.org/3/library/sqlite3.html#transaction-control)

Related topic(s):

- Databases

<a id="term-autodetect"></a>

**autodetect**

autodetect is the ability of a system to automatically detect and configure hardware or settings without user input. In Ubuntu Server and other Linux systems, this is used during boot or installation to identify devices like disks, network interfaces, or keyboard layouts. The kernel, installers, and configuration tools rely on autodetection to simplify setup by loading the right drivers and defaults based on the system’s hardware and environment.

Related topic(s):

- Kernel modules

<a id="term-autoinstall"></a>

**autoinstall**

Autoinstall is a feature in Ubuntu Desktop and Ubuntu Server that provides fully automated installations using a pre-defined configuration file. This file describes how the system should be installed, including disk partitioning, user accounts, package selection, and network settings.

See also:

- [The Autoinstall documentation](https://canonical-subiquity.readthedocs-hosted.com/en/latest/intro-to-autoinstall.html)

Related topic(s):

- cloud-init

<a id="term-autorid"></a>

**autorid**

autorid is a Samba ID mapping backend that automatically assigns [UID](glossary.md#term-UID) and [GID](glossary.md#term-GID) values to security identifiers (SIDs) when integrating with Active Directory (AD). It ensures consistent and persistent Unix ID mapping without requiring manual configuration for each domain or user/group.

See also:

- [The autorid Samba Wiki](https://wiki.samba.org/index.php/Idmap_config_autorid)

Related topic(s):

- Samba, Active Directory

<a id="term-AWS"></a>

**AWS**

<a id="term-Amazon-Web-Services"></a>

**Amazon Web Services**

AWS is a cloud computing platform that offers a wide range of on-demand services such as compute, storage, networking, machine learning, analytics and much more. It allows individuals and companies to run applications without owning physical hardware, to scale resources up or down as needed, and to pay only for what they use.

See also:

- [The AWS documentation](https://docs.aws.amazon.com/)

Related topic(s):

- Clouds

<a id="terms-b"></a>

## B

<a id="term-backend"></a>

**backend**

*Work in Progress*

<a id="term-Backports"></a>

**Backports**

*Work in Progress*

<a id="term-Backtrace"></a>

**Backtrace**

*Work in Progress*

<a id="term-BDC"></a>

**BDC**

<a id="term-Backup-Domain-Controller"></a>

**Backup Domain Controller**

Backup Domain Controller (BDC) is a (legacy) Windows NT4 domain controller that authenticates network users using a read-only copy of the Security Account Manager database (SAM). A BDC acts as a backup for a Primary Domain Controller ([PDC](glossary.md#term-PDC)) and can authenticate users locally in a large network. A [Samba server](../explanation/intro-to/samba.md#introduction-to-samba) may be deployed as a BDC in the deprecated Windows NT4 domain controller mode.

<a id="term-bind"></a>

**bind**

*Work in Progress*

<a id="term-bindDN"></a>

**bindDN**

bindDN is a distinguished name ([DN](glossary.md#term-DN)) that specifies the client or connection to authenticate to an LDAP directory server. A bindDN is supplied during a [bind](glossary.md#term-bind) operation that authenticates and authorizes the client for subsequent operations.

<a id="term-BIOS"></a>

**BIOS**

<a id="term-Basic-Input-Output-System"></a>

**Basic Input/Output System**

Basic Input/Output System (BIOS) is the firmware that tests and initializes a system’s hardware when you power on the system. The BIOS also finds and triggers the bootloader that launches the operating system (OS). BIOS has been succeeded by [UEFI](glossary.md#term-UEFI).

<a id="term-BMC"></a>

**BMC**

<a id="term-Baseboard-Management-Controller"></a>

**Baseboard Management Controller**

A Baseboard Management Controller (BMC) is a specialized microcontroller embedded in the server’s motherboard. The BMC allows administrators to monitor and control server hardware even when the server OS is shut down, not installed or not accessible. An administrator can monitor system health, control power states, update firmware and troubleshoot a server using the BMC’s remote—out-of-band—access.

<a id="term-bootloader"></a>

**bootloader**

The bootloader is a small program that launches an OS. It is itself launched by device firmware (typically [BIOS](glossary.md#term-BIOS) or [UEFI](glossary.md#term-UEFI)).

<a id="term-BOOTP"></a>

**BOOTP**

<a id="term-Bootstrap-Protocol"></a>

**Bootstrap Protocol**

A network protocol that assigns IP addresses and boot information to a disk-less system.

<a id="term-bootstrap"></a>

**bootstrap**

*Work in Progress*

<a id="term-btrfs"></a>

**btrfs**

<a id="term-B-tree-File-System"></a>

**B-tree File System**

*Work in Progress*

<a id="terms-c"></a>

## C

<a id="term-CA"></a>

**CA**

<a id="term-Certificate-Authority"></a>

**Certificate Authority**

*Work in Progress*

<a id="term-CAC"></a>

**CAC**

<a id="term-Common-Access-Card"></a>

**Common Access Card**

*Work in Progress*

<a id="term-CARP"></a>

**CARP**

<a id="term-Cache-Array-Routing-Protocol"></a>

**Cache Array Routing Protocol**

*Work in Progress*

<a id="term-CCID"></a>

**CCID**

<a id="term-Chip-Card-Interface-Device"></a>

**Chip Card Interface Device**

*Work in Progress*

<a id="term-CDB"></a>

**CDB**

<a id="term-Command-Descriptor-Block"></a>

**Command Descriptor Block**

*Work in Progress*

<a id="term-CGNAT"></a>

**CGNAT**

<a id="term-Carrier-Grade-Network-Address-Translation"></a>

**Carrier-Grade Network Address Translation**

*Work in Progress*

<a id="term-CGI"></a>

**CGI**

<a id="term-Common-Gateway-Interface"></a>

**Common Gateway Interface**

*Work in Progress*

<a id="term-checksums"></a>

**checksums**

*Work in Progress*

<a id="term-chrony"></a>

**chrony**

*Work in Progress*

<a id="term-chroot"></a>

**chroot**

*Work in Progress*

<a id="term-CIDR"></a>

**CIDR**

<a id="term-Classless-Inter-Domain-Routing"></a>

**Classless Inter-Domain Routing**

*Work in Progress*

<a id="term-CIFS"></a>

**CIFS**

<a id="term-Common-Internet-File-System"></a>

**Common Internet File System**

*Work in Progress*

<a id="term-CIS"></a>

**CIS**

<a id="term-Center-for-Internet-Security"></a>

**Center for Internet Security**

*Work in Progress*

<a id="term-CLVM"></a>

**CLVM**

<a id="term-Clustered-Logical-Volume-Manager"></a>

**Clustered Logical Volume Manager**

*Work in Progress*

<a id="term-CMS"></a>

**CMS**

<a id="term-Configuration-Management-System"></a>

**Configuration Management System**

*Work in Progress*

<a id="term-CN"></a>

**CN**

<a id="term-Common-Name"></a>

**Common Name**

*Work in Progress*

<a id="term-colocation"></a>

**colocation**

*Work in Progress*

<a id="term-conffile"></a>

**conffile**

*Work in Progress*

<a id="term-config"></a>

**config**

*Work in Progress*

<a id="term-connectionless"></a>

**connectionless**

*Work in Progress*

<a id="term-containerization"></a>

**containerization**

*Work in Progress*

<a id="term-CPU"></a>

**CPU**

<a id="term-Central-Processing-Unit"></a>

**Central Processing Unit**

*Work in Progress*

<a id="term-CRL"></a>

**CRL**

<a id="term-Certificate-Revocation-List"></a>

**Certificate Revocation List**

*Work in Progress*

<a id="term-crypto"></a>

**crypto**

<a id="term-cryptographic"></a>

**cryptographic**

*Work in Progress*

<a id="term-CSR"></a>

**CSR**

<a id="term-Certificate-Signing-Request"></a>

**Certificate Signing Request**

*Work in Progress*

<a id="term-CVE"></a>

**CVE**

<a id="term-Common-Vulnerabilities-and-Exposures"></a>

**Common Vulnerabilities and Exposures**

*Work in Progress*

<a id="terms-d"></a>

## D

<a id="term-DAC"></a>

**DAC**

<a id="term-Discretionary-access-control"></a>

**Discretionary access control**

A form of access control where the owner of a resource can grant/revoke permissions to other users.

Related topic(s):

- Security

<a id="term-daemonize"></a>

**daemonize**

The process of converting a program to run in the background as a service, independent of user sessions.

<a id="term-DARPA"></a>

**DARPA**

<a id="term-Defense-Advanced-Research-Projects-Agency"></a>

**Defense Advanced Research Projects Agency**

A research and development agency of the United States Department of Defense responsible for the development of emerging technologies for use in the military.

<a id="term-DAS"></a>

**DAS**

<a id="term-Direct-Attached-Storage"></a>

**Direct Attached Storage**

DAS is storage that is physically and directly connected to one computer. DAS is not shared over a network and it is accessible ONLY to the host it is connected to.

See also:

- [NAS](glossary.md#term-NAS)

- [SAN](glossary.md#term-SAN)

<a id="term-DASD"></a>

**DASD**

<a id="term-Direct-Access-Storage-Device"></a>

**Direct Access Storage Device**

This term was coined by IBM to refer to a type of storage that allows random access to storage (hard-drives, optical discs, etc). It contrasts with sequential access storage such as magnetic tape or punched cards.

Related topic(s):

- Storage

<a id="term-Datagram"></a>

**Datagram**

In networking, a self contained, independent packet sent over a network. It can be routed from source to destination without relying on earlier or subsequent transfers.

Related topic(s):

- Networking

<a id="term-dblink"></a>

**dblink**

<a id="term-Database-link"></a>

**Database link**

A connection between two databases (mainly Oracle and PostgreSQL), allowing one database to query data from the other.

Related topic(s):

- Databases

<a id="term-DC"></a>

**DC**

<a id="term-Domain-Component"></a>

**Domain Component**

*Work in progress*

<a id="term-DDNS"></a>

**DDNS**

<a id="term-Dynamic-Domain-Name-System"></a>

**Dynamic Domain Name System**

A service that automatically updates DNS records when the underlying IP address changes (aka, dynamic IP).

Related topic(s):

- Networking

<a id="term-deb822"></a>

**deb822**

A structured configuration format based on RFC822.

See also:

- [RFC 822](https://datatracker.ietf.org/doc/html/rfc822)

- The *[deb822(5)](https://manpages.ubuntu.com/manpages/resolute/man5/deb822.5.html)* manual page

<a id="term-debconf"></a>

**debconf**

A [configuration management system](glossary.md#term-CMS) handling the configuration of software packages during installation or upgrades by prompting users for necessary settings and storing them for subsequent installations or updates.

<a id="term-deduplication"></a>

**deduplication**

Process of removing duplicate copies of data in storage spaces. The redundant data is then replaced with a reference to the original.

<a id="term-denylist"></a>

**denylist**

In cyber-security, a denylist is a list of entities (IP, domains, emails, etc), that are explicitly denied access to a system or service.

Related topic(s):

- Security

<a id="term-DER"></a>

**DER**

<a id="term-Distinguished-Encoding-Rules"></a>

**Distinguished Encoding Rules**

A standardized encoding format for data (mostly cryptographic certificates and keys) for transmission and storage.

<a id="term-DGC"></a>

**DGC**

<a id="term-Distributed-Garbage-Collection"></a>

**Distributed Garbage Collection**

A process used in distributed systems to manage memory across multiple interconnected computers allowing identification and reclaiming of unused memory across nodes.

<a id="term-DHCP"></a>

**DHCP**

<a id="term-Dynamic-Host-Configuration-Protocol"></a>

**Dynamic Host Configuration Protocol**

A network protocol used to automatically assign network configuration details (IP, DNS, gateway, etc) to devices allowing for easy network management and connections within the network.

<a id="term-DHCPD"></a>

**DHCPD**

<a id="term-Dynamic-Host-Configuration-Protocol-Daemon"></a>

**Dynamic Host Configuration Protocol Daemon**

Server software responsible for assigning the network configuration via DHCP.

<a id="term-DIT"></a>

**DIT**

<a id="term-Directory-Information-Tree"></a>

**Directory Information Tree**

In directory services (LDAP) this is a hierarchical tree-like structure used to organize and store information.

Related topic(s):

- OpenLDAP

<a id="term-DKMS"></a>

**DKMS**

<a id="term-Dynamic-Kernel-Module-Support"></a>

**Dynamic Kernel Module Support**

A framework used in Linux systems to automatically rebuild and install kernel modules when the kernel is updated.

Related topic(s):

- Kernel

<a id="term-DMA"></a>

**DMA**

<a id="term-Direct-Memory-Access"></a>

**Direct Memory Access**

DMA is a technology that allows peripheral devices (hard drives, network cards, etc) to access the system’s memory directly, bypassing the CPU and thus improving performance.

<a id="term-DMAR"></a>

**DMAR**

<a id="term-Direct-Memory-Access-Remapping"></a>

**Direct Memory Access Remapping**

DMAR is a technology used to control and secure [Direct Memory Access](glossary.md#term-DMA) operations and ensure that devices can only access memory regions they are authorized to. This helps to prevent unauthorized access, memory corruption, or security vulnerabilities. It is often used in virtualized environments to isolate devices between [virtual machines (VMs)](glossary.md#term-VM) and the host system.

<a id="term-dmesg"></a>

**dmesg**

A command in Linux systems that displays system logs related to hardware, drivers, and kernel events, such as system startup, device detection, and errors. It is commonly used for troubleshooting hardware issues and system diagnostics.

<a id="term-DN"></a>

**DN**

<a id="term-Distinguished-Name"></a>

**Distinguished Name**

In directory services (LDAP), this is a unique identifier used to represent an entry in a directory, such as a user or a group. It’s often composed of sub-components like [CN](glossary.md#term-CN), [OU](glossary.md#term-OU), or [DC](glossary.md#term-DC).

<a id="term-DNS"></a>

**DNS**

<a id="term-Domain-Name-System"></a>

**Domain Name System**

A system that translates human-readable domain names (e.g. `ubuntu.com`) to their IP addresses (`185.125.190.20`).

Related topic(s):

- Networking

<a id="term-dnsmasq"></a>

**dnsmasq**

A lightweight, open-source [DNS](glossary.md#term-DNS) and [DHCP](glossary.md#term-DHCP) server software.

<a id="term-DNSSEC"></a>

**DNSSEC**

<a id="term-Domain-Name-System-Security-Extensions"></a>

**Domain Name System Security Extensions**

DNSSEC is a set of security extensions to [DNS](glossary.md#term-DNS) which allow DNS data to be verified for authenticity and integrity.

Related topic(s):

- Security

<a id="term-Docker"></a>

**Docker**

One of the most popular containerization platforms, which allows developers to package applications – together with their dependencies – into lightweight containers. This provides a consistently reproducible environment for deploying applications.

Related topic(s):

- Containers

<a id="term-DocumentRoot"></a>

**DocumentRoot**

A directive in web server configuration files that specifies the directory on the server where web files are stored (root location).

<a id="term-DoT"></a>

**DoT**

<a id="term-DNS-over-TLS"></a>

**DNS over TLS**

DNS over TLS utilizes [Transport Layer Security (TLS)](glossary.md#term-TLS) to encrypt the entire DNS connection, rather than just the payload. DoT servers listen on TCP port 853.

See also:

- [RFC 7858](https://datatracker.ietf.org/doc/html/rfc7858)

Related topic(s):

- Networking

- Security

<a id="term-DoH"></a>

**DoH**

<a id="term-DNS-over-HTTPS"></a>

**DNS over HTTPS**

DNS over HTTPS is tunneling DNS query data over encrypted [HTTPS](glossary.md#term-HTTPS) connections. It uses TCP port 443, and thus looks similar to web traffic.

See also:

- [RFC 8484](https://datatracker.ietf.org/doc/html/rfc8484)

Related topic(s):

- Networking

- Security

<a id="term-dpkg"></a>

**dpkg**

`dpkg` is a package manager for Debian-based systems. It can install, remove, and build packages, but unlike other package management systems, it cannot automatically download and install packages -– or their dependencies.

<a id="term-DRBD"></a>

**DRBD**

<a id="term-Distributed-Replicated-Block-Device"></a>

**Distributed Replicated Block Device**

A software-based storage solution for Linux that allows for the mirroring of block devices between multiple hosts. The replication is transparent to other applications on the host systems. Any block device hard disks, partitions, RAID devices, logical volumes, etc can be mirrored.

Related topic(s):

- Storage

<a id="term-DSCP"></a>

**DSCP**

<a id="term-Differentiated-Services-Code-Point"></a>

**Differentiated Services Code Point**

DSCP is a 6-bit field in the IP header used to classify and prioritize network traffic, allowing different packets to receive different forwarding treatment for quality-of-service purposes.

Related topic(s):

- Networking

<a id="term-DTLS"></a>

**DTLS**

<a id="term-Datagram-Transport-Layer-Security"></a>

**Datagram Transport Layer Security**

A protocol that provides security for datagram-based communication, such as [UDP](glossary.md#term-UDP). It is designed to offer similar security features as [TLS](glossary.md#term-TLS) but adapted for the connectionless nature of datagram protocols.

<a id="terms-e"></a>

## E

<a id="term-EAL"></a>

**EAL**

<a id="term-Environment-Abstraction-Layer"></a>

**Environment Abstraction Layer**

A software layer that provides a standardized interface between an operating system and the underlying hardware. It abstracts hardware-specific details, allowing software to run on different hardware platforms without modification.

<a id="term-ECKD"></a>

**ECKD**

<a id="term-Extended-Count-Key-Data"></a>

**Extended Count Key Data**

A disk storage format used by IBM mainframe systems, which provides advanced features such as better error detection and correction, as well as enhanced management of data records.

<a id="term-EFI"></a>

**EFI**

<a id="term-Extensible-Firmware-Interface"></a>

**Extensible Firmware Interface**

A type of firmware interface designed to initialize hardware and load the operating system during the boot process of a computer. Replacement for the older [BIOS](glossary.md#term-BIOS) and ancestor of the [UEFI](glossary.md#term-UEFI).

<a id="term-ELinks"></a>

**ELinks**

A text-based web browser for Unix-like operating systems. It allows users to browse the web in a terminal, making it ideal for environments without a [GUI](glossary.md#term-GUI).

<a id="term-Engenio"></a>

**Engenio**

A company that developed and manufactured storage systems including [SAN](glossary.md#term-SAN) and [NAS](glossary.md#term-NAS). Later acquired by LSI Corporation and then by Seagate Technology.

<a id="term-EOL"></a>

**EOL**

<a id="term-End-of-life"></a>

**End of life**

When a product, service, software is no longer supported or maintained.

<a id="term-ERD"></a>

**ERD**

<a id="term-Enterprise-Ready-Drivers"></a>

**Enterprise Ready Drivers**

Drivers that are specifically designed and optimized for use in enterprise environments, where stability, performance, and reliability are critical.

<a id="term-ESM"></a>

**ESM**

<a id="term-Expanded-Security-Maintenance"></a>

**Expanded Security Maintenance**

A service provided by Canonical to extend security updates and patches for older [LTS](glossary.md#term-LTS) releases of the Ubuntu operating system after the LTS standard support period has ended.

<a id="term-ESXi"></a>

**ESXi**

A bare-metal virtualization platform created by VMWare that enables multiple virtual machines to operate on a single physical server.

<a id="terms-f"></a>

## F

<a id="term-failover"></a>

**failover**

In a [Storage Area Network (SAN)](glossary.md#term-SAN) environment, this occurs when data flows into an alternative I/O path because a cable, switch, or controller in the current path failed.

It is a common feature in high availability environments and is handled (usually automatically) by multipathing software.

<a id="term-fallbacks"></a>

**fallbacks**

This is a manual or automatic switch to an alternative method, when the primary option fails or is less preferred.

<a id="term-FastCGI"></a>

**FastCGI**

<a id="term-Fast-Common-Gateway-Interface"></a>

**Fast Common Gateway Interface**

FastCGI is an extension of the [CGI](glossary.md#term-CGI) protocol that starts a persistent FastCGI application process, allowing it to handle multiple requests instead of starting a new process for each request as a traditional CGI does.

<a id="term-FC"></a>

**FC**

<a id="term-Fiber-Channel"></a>

**Fiber Channel**

FC is a storage networking protocol used for low-latency communication between a storage device and a node in a [Storage Area Network (SAN)](glossary.md#term-SAN).

<a id="term-FDE"></a>

**FDE**

<a id="term-Full-Disk-Encryption"></a>

**Full-Disk Encryption**

FDE is a security method that encrypts data at rest on an entire storage device or volume.

<a id="term-FHS"></a>

**FHS**

<a id="term-Filesystem-Hierarchy-Standard"></a>

**Filesystem Hierarchy Standard**

FHS is a standard that defines the directory structure and contents in Linux and Unix-like operating systems.

<a id="term-Fileset"></a>

**Fileset**

A fileset defines a group of directories that will be included when performing a backup job using Bacula.

Related topic(s):

- Storage

<a id="term-filesystem"></a>

**filesystem**

A filesystem defines how data is organized, stored, and accessed on a storage device.

Related topic(s):

- Storage

<a id="term-FTP"></a>

**FTP**

<a id="term-File-Transfer-Protocol"></a>

**File Transfer Protocol**

It is one of the tools used to move files between computers. FTP was created in 1970s. It is not secure as it transfers files, usernames, and passwords in plain text. It uses port 21. Use only with legacy systems. Avoid unless wrapped in a secure network.

Related topic(s):

- [SFTP](glossary.md#term-SFTP)

- [rsync](glossary.md#term-rsync)

- [SCP](glossary.md#term-SCP)

<a id="term-FIPS"></a>

**FIPS**

<a id="term-Federal-Information-Processing-Standard"></a>

**Federal Information Processing Standard**

A set of publicly-announced US government standards for codes, data security and encryption.

See also:

- [NIST](https://en.wikipedia.org/wiki/National_Institute_of_Standards_and_Technology)

<a id="term-Fluentd"></a>

**Fluentd**

Fluentd is a data collection platform that gathers events from a container for later analysis on other platforms.

Related topic(s):

- Observability, Containers

<a id="term-FQDN"></a>

**FQDN**

<a id="term-Fully-Qualified-Domain-Name"></a>

**Fully Qualified Domain Name**

A FQDN represents a complete name that specifies the exact location of a host within the [DNS](glossary.md#term-DNS) hierarchy.

Related topic(s):

- Networking

<a id="term-FreeIPA"></a>

**FreeIPA**

<a id="term-Free-Identity-Policy-and-Audit"></a>

**Free Identity, Policy, and Audit**

FreeIPA is an open-source security solution for Linux/Unix-like systems that stores user identities in an [LDAP](glossary.md#term-LDAP) directory, manages a [CA](glossary.md#term-CA), and enables authentication, policy enforcement, and auditing through integrations with [SSSD](glossary.md#term-SSSD) and [Kerberos](glossary.md#term-Kerberos).

Related topic(s):

- Security, OpenLDAP

<a id="term-Freenode"></a>

**Freenode**

Freenode is an open-source [Internet Relay Chat (IRC)](glossary.md#term-IRC) platform used by many open-source communities for real-time discussions.

<a id="term-frontend"></a>

**frontend**

A frontend is a user-friendly interface for managing a complex system.

- In firewall management, a frontend like `ufw` simplifies configuring `iptables`.

- In QEMU/KVM graphics, a frontend is the virtual graphic adapter presented to the guest [OS](glossary.md#term-OS), allowing it to process and store graphical output in memory. The guest OS treats it like a [GPU](glossary.md#term-GPU), while the host determines how to display the output using the [backend](glossary.md#term-backend).

- In LDAP, the frontend is a unique database that defines global default settings, such as who the admin user is, who can access database entries, or the limit on the number of search results. These settings apply to all LDAP databases inside [slapd](glossary.md#term-slapd), unless overridden.

Related topic(s):

- Virtualization and containers, Security, OpenLDAP

<a id="term-fsck"></a>

**fsck**

<a id="term-File-System-Check"></a>

**File System Check**

fsck is a Linux/Unix-like system utility tool that checks for, and repairs, any [filesystem](glossary.md#term-filesystem) errors.

Related topic(s):

- Storage

<a id="term-FULLTEXT"></a>

**FULLTEXT**

FULLTEXT is an index type that allows for fast indexing and searching large quantities of text. It takes a sentence, splits it into words, and links them to row IDs. When a search query for a word is made, MySQL quickly looks up the row the word appear in, and retrieves all matching row IDs, rather than scanning the entire table. It can also find similar words using natural language processing.

See also:

- [Full-Text Search Functions](https://dev.mysql.com/doc/refman/8.4/en/fulltext-search.html)

Related topic(s):

- Databases

<a id="term-FW"></a>

**FW**

<a id="term-Firmware"></a>

**Firmware**

Firmware is a software that runs before an operating system (OS) boots.

- When a QEMU microvm starts, the firmware initializes minimal virtual hardware like allocating [RAM](glossary.md#term-RAM) to the OS, and then loads the Linux kernel into memory.

- In a physical device, firmware configures [PCIe](glossary.md#term-PCIe) devices like [GPUs](glossary.md#term-GPU) or network cards.

<a id="terms-g"></a>

## G

<a id="term-gcplogs"></a>

**gcplogs**

A logging driver that allows logs to be forwarded from a Docker container running in Google Cloud to the Google Cloud Logging service.

Related topic(s):

- Cloud, Containers, Observability

<a id="term-gcrypt"></a>

**gcrypt**

A cryptographic library that supports encryption, hashing, etc. for applications.

Related topic(s):

- Cryptographic libraries

<a id="term-GDB"></a>

**GDB**

<a id="term-GNU-Debugger"></a>

**GNU Debugger**

GDB traces the current execution of a program, with the aim of identifying any issues.

Related topic(s):

- Debugging

<a id="term-GELF"></a>

**GELF**

<a id="term-Graylog-Extended-Log-Format"></a>

**Graylog Extended Log Format**

GELF is a logging driver that allow logs to be forwarded in [JSON](glossary.md#term-JSON) format, but with extra unique fields. These logs are sent from a Docker container to a data collector platform like [Graylog](glossary.md#term-Graylog), [Logstash](glossary.md#term-Logstash), and [Fluentd](glossary.md#term-Fluentd).

Related topic(s):

- Containers, Observability

<a id="term-GFS2"></a>

**GFS2**

A shared-disk [filesystem](glossary.md#term-filesystem) that allows multiple servers to access a single disk. It uses a locking system to ensure that no two servers modify the same data simultaneously, thus preventing data corruption if one server fails. Additionally, fencing is used to isolate failed nodes, ensuring that their locks can be safely recovered.

Related topic(s):

- High availability, Storage

<a id="term-GB"></a>

**GB**

Gigabyte (unit of measurement) 1 GB = 1,000,000,000 bytes

<a id="term-GID"></a>

**GID**

<a id="term-Group-ID"></a>

**Group ID**

A GID is an identifier for a collection of users. It helps administrators enforce system or file access permissions on multiple users at once.

Related topic(s):

- Active Directory integration, Samba, Security, SSSD

<a id="term-gitolite"></a>

**gitolite**

[Gitolite](../how-to/backups/install-gitolite.md#install-gitolite) is a tool installed on a central server for managing git repositories and controlling access to them, all via the command line. The central server becomes a git server.

Related topic(s):

- Backups and version control

<a id="term-GKE"></a>

**GKE**

<a id="term-Google-Kubernetes-Engine"></a>

**Google Kubernetes Engine**

GKE is a managed Kubernetes service provided by Google cloud.

<a id="term-GL"></a>

**GL**

<a id="term-Graphics-Library"></a>

**Graphics Library**

A GL is an [API](glossary.md#term-API) for interacting with a graphics card, enabling it to perform better rendering.

Related topic(s):

- Graphics

<a id="term-GNU"></a>

**GNU**

<a id="term-GNU-s-Not-Unix"></a>

**GNU’s Not Unix**

A recursive acronym, GNU, is an operating system containing several free software packages. It can be used in combination with the Linux kernel.

<a id="term-GnuTLS"></a>

**GnuTLS**

<a id="term-GNU-s-Not-Unix-Transport-Layer-Security"></a>

**GNU’s Not Unix Transport Layer Security**

GnuTLS is a GNU software package that secures data-in-transit by implementing the [SSL](glossary.md#term-SSL), [TLS](glossary.md#term-TLS) and [DTLS](glossary.md#term-DTLS) protocol.

Related topic(s):

- Cryptography, Web services, OpenLDAP

<a id="term-GPG"></a>

**GPG**

<a id="term-GNU-Privacy-Guard"></a>

**GNU Privacy Guard**

GPG is a GNU software package that secures data-at-rest before sending it to a recipient.

Related topic(s):

- Security, Cryptography

<a id="term-GPS"></a>

**GPS**

<a id="term-Global-Positioning-System"></a>

**Global Positioning System**

GPS is a collection of satellites that provides accurate time using radio signals from their atomic clocks. A GPS receiver plugged into a computer can sync with these satellites and generate [PPS](glossary.md#term-PPS) signal, which delivers ultra-accurate time that applications can use as a time source.

Related topic(s):

- Networking

<a id="term-GPSD"></a>

**GPSD**

<a id="term-GPS-daemon"></a>

**GPS daemon**

This reads data from a GPS receiver and makes it available as a shared resource to multiple applications (e.g., [Chrony](glossary.md#term-chrony)) to use for precise time synchronization.

Related topic(s):

- Networking

<a id="term-GPU"></a>

**GPU**

<a id="term-Graphics-Processing-Unit"></a>

**Graphics Processing Unit**

A GPU enhances graphics rendering for a computer and any virtual machines running inside of it.

Related topic(s):

- Graphics, Virtualisation and containers

<a id="term-Graylog"></a>

**Graylog**

A data collector platform for storing, analysing, and interpreting logs. These logs are received from a [gelf](glossary.md#term-GELF) logging driver in Docker.

Related topic(s):

- Containers

<a id="term-GPO"></a>

**GPO**

<a id="term-Group-Policy-Object"></a>

**Group Policy Object**

A set of configuration rules used to manage and enforce security and system behaviours across users or computers within an Active Directory (AD) object.

Related topic(s):

- Active Directory integration

<a id="term-GRUB"></a>

**GRUB**

<a id="term-GRand-Unified-Bootloader"></a>

**GRand Unified Bootloader**

*Work in progress*

<a id="term-GSSAPI"></a>

**GSSAPI**

<a id="term-Generic-Security-Services-Application-Program-Interface"></a>

**Generic Security Services Application Program Interface**

GSSAPI is a vendor-agnostic [API](glossary.md#term-API) that uses an existing communication protocol to establish a secure communication between applications. It does this securely by verifying user credentials, ensuring that data being transmitted remains unchanged, preventing unauthorized access, and securely negotiating encryption keys.

Related topic(s):

- Cryptography

<a id="term-GTK"></a>

**GTK**

<a id="term-GIMP-Toolkit"></a>

**GIMP Toolkit**

GTK is a library used to create [graphical user interfaces (GUIs)](glossary.md#term-GUI). It provides a visual interface for interacting with the Bacula Director when managing backup-related operations.

Related topic(s):

- Graphics, Backups and version control

<a id="term-GUI"></a>

**GUI**

<a id="term-Graphical-User-Interface"></a>

**Graphical User Interface**

A GUI is a visual representation of operations within a computer. It is usually represented as icons rather than text only.

<a id="term-GZIP"></a>

**GZIP**

<a id="term-GNU-Zip"></a>

**GNU Zip**

GZIP is a [GNU](glossary.md#term-GNU) software package used to reduce the file size of a backup.

- When applied directly to files, it replaces the original file type with a `.gz` type.

- When used in Bacula’s [fileset](glossary.md#term-Fileset), it reduces the storage size of backed-up directories within Bacula’s storage volumes.

- When used to reduce the size of a folder, it works in combination with a `tar` tool which first combines multiple files into a single archive, before applying GZIP’s size-reduction technique.

Related topic(s):

- Backups and version control

<a id="terms-h"></a>

## H

<a id="term-HA"></a>

**HA**

<a id="term-High-Availability"></a>

**High Availability**

HA is the process of ensuring that a system is always up. To achieve this, a redundant system is set up that either takes over when the main system is down or runs alongside the main system to load-balance the workload.

Related topic(s):

- High availability

<a id="term-HBA"></a>

**HBA**

<a id="term-Host-Bus-Adapter"></a>

**Host Bus Adapter**

HBAs are interface cards that connect a server to a storage device.

Related topic(s):

- Device mapper multipathing

<a id="term-HMAC"></a>

**HMAC**

<a id="term-Hash-based-Message-Authentication-Code"></a>

**Hash-based Message Authentication Code**

A HMAC is a type of [Message Authentication Code](glossary.md#term-MAC). While a general MAC may use various techniques during combination, HMAC follows a structured way. When a message and its HMAC are sent, the receiver verifies the integrity by computing the HMAC again – if the message is altered, the value will differ.

Related topic(s):

- Cryptography, Security

<a id="term-HMC"></a>

**HMC**

<a id="term-Hardware-Management-Console"></a>

**Hardware Management Console**

A HMC is used to manage IBM servers. It can handle tasks like configuring network settings, loading Ubuntu installation files and installing the [OS](glossary.md#term-OS).

<a id="term-hostgroup"></a>

**hostgroup**

A group of backend web or database servers with similar configurations.

Related topic(s):

- Observability

<a id="term-hostname"></a>

**hostname**

A hostname identifies a server using a word rather than an [IP address](glossary.md#term-IP-address). This makes it easier to remember.

<a id="term-HOTP"></a>

**HOTP**

<a id="term-HMAC-based-One-Time-Password"></a>

**HMAC-based One-Time Password**

HOTP generates a one-time password by using the [HMAC](glossary.md#term-HMAC) algorithm in combination with a counter. When a client presents the [OTP](glossary.md#term-OTP), the server compares it with OTPs generated within a specific counter window to find a match.

<a id="term-hotplug"></a>

**hotplug**

The process of adding or removing a device (USB, disks, etc.) while a virtual machine is running.

<a id="term-HPB"></a>

**HPB**

<a id="term-Host-Physical-Bits"></a>

**Host Physical Bits**

HPB are appended to the name of an Ubuntu machine type. It signifies that a virtual machine will use the same number of bits the host [CPU](glossary.md#term-CPU) uses to point to physical memory.

<a id="term-HPC"></a>

**HPC**

<a id="term-High-Performance-Computing"></a>

**High Performance Computing**

HPC is the use of multiple servers to improve the performance of a task.

<a id="term-HSG"></a>

**HSG**

<a id="term-High-availability-Storage-Group"></a>

**High-availability Storage Group**

*Work in Progress*

<a id="term-HSV"></a>

**HSV**

<a id="term-Highly-available-Storage-Virtualization"></a>

**Highly-available Storage Virtualization**

*Work in Progress*

<a id="term-HTCP"></a>

**HTCP**

<a id="term-Hyper-Text-Caching-Protocol"></a>

**Hyper Text Caching Protocol**

A protocol for querying, monitoring and managing [HTTP](glossary.md#term-HTTP) caches. It is described in detail in [RFC2756](https://www.rfc-editor.org/info/rfc2756/)

<a id="term-HTML"></a>

**HTML**

<a id="term-HyperText-Markup-Language"></a>

**HyperText Markup Language**

A language for adding display and formatting information to text that is intended for display in web browsers. It is standardized by the Web Hypertext Application Technology Working Group (WHATWG) at [HTML Living Standard](https://html.spec.whatwg.org/multipage/).

<a id="term-HTTP"></a>

**HTTP**

<a id="term-HyperText-Transfer-Protocol"></a>

**HyperText Transfer Protocol**

A protocol for transferring [HyperText Markup Language (HTML)](glossary.md#term-HTML) documents between web servers and web clients (typically web browsers). It defined by a number of [IETF Request for Comment (RFC)](glossary.md#term-RFC) documents, available at [HTTP Documentation](https://httpwg.org/specs/).

<a id="term-HTTPD"></a>

**HTTPD**

<a id="term-HyperText-Transfer-Protocol-Daemon"></a>

**HyperText Transfer Protocol Daemon**

A server process that serves [HTML](glossary.md#term-HTML) documents to client applications (typically web browsers) according to the [HTTP](glossary.md#term-HTTP) protocol.

<a id="term-HTTPS"></a>

**HTTPS**

<a id="term-HyperText-Transfer-Protocol-Secure"></a>

**HyperText Transfer Protocol Secure**

An extension to the [HTTP](glossary.md#term-HTTP) protocol to implement encryption between web servers and clients. It is implemented using [TLS](glossary.md#term-TLS).

<a id="term-hugepage"></a>

**hugepage**

A hugepage increases the page size on a host, and as a result, when virtual memory is allocated to an application, there are fewer page table entries required to map the virtual memory to physical memory. The page table entries are stored in Random Access Memory (RAM) and cached in the [Translation Lookaside Buffer (TLB)](glossary.md#term-TLB).

<a id="term-HWE"></a>

**HWE**

<a id="term-Hardware-Enablement"></a>

**Hardware Enablement**

*Work in Progress*

<a id="terms-i"></a>

## I

<a id="term-ICMP"></a>

**ICMP**

<a id="term-Internet-Control-Message-Protocol"></a>

**Internet Control Message Protocol**

*Work in Progress*

<a id="term-ICP"></a>

**ICP**

<a id="term-Internet-Cache-Protocol"></a>

**Internet Cache Protocol**

*Work in Progress*

<a id="term-IDENT"></a>

**IDENT**

<a id="term-Identification-Protocol"></a>

**Identification Protocol**

*Work in Progress*

<a id="term-IMAP"></a>

**IMAP**

<a id="term-Internet-Messages-Access-Protocol"></a>

**Internet Messages Access Protocol**

*Work in Progress*

<a id="term-init"></a>

**init**

<a id="term-initialization"></a>

**initialization**

*Work in Progress*

<a id="term-Intel-TDX"></a>

**Intel-TDX**

<a id="term-Intel-Trust-Domain-Extensions"></a>

**Intel Trust Domain Extensions**

Intel-TDX is a hardware-based confidential computing technology that creates isolated execution environments called Trust Domains (TDs) for virtual machines. It provides memory encryption, CPU state protection, and integrity verification to protect guest VMs from unauthorized access by the host and hypervisor. TDX is available on 4th generation Intel Xeon Scalable processors and later.

Related topic(s):

- Cryptography, Security, Virtualization

<a id="term-I-O"></a>

**I/O**

<a id="term-Input-Output"></a>

**Input/Output**

*Work in Progress*

<a id="term-IOMMU"></a>

**IOMMU**

<a id="term-Input-Output-Memory-Management-Unit"></a>

**Input-Output Memory Management Unit**

*Work in Progress*

<a id="term-IoT"></a>

**IoT**

<a id="term-Internet-of-Things"></a>

**Internet of Things**

*Work in Progress*

<a id="term-IP"></a>

**IP**

<a id="term-Internet-Protocol"></a>

**Internet Protocol**

IP is a connectionless network protocol responsible for routing packets across networks. It uses the IP [datagram](glossary.md#term-Datagram) as its basic unit of network information.

See also:

- [Networking key concepts](../explanation/networking/networking-key-concepts.md#networking-key-concepts)

Related topic(s):

- Networking

<a id="term-IP-address"></a>

**IP address**

An IP address is a unique numerical identifier for a device on a network. Common versions include IPv4 (32-bit, i.e. 192.168.1.1) and IPv6 (128-bit).

See also:

- [Networking key concepts](../explanation/networking/networking-key-concepts.md#networking-key-concepts)

Related topic(s):

- Networking

<a id="term-IPC"></a>

**IPC**

<a id="term-Inter-Process-Communication"></a>

**Inter-Process Communication**

*Work in Progress*

<a id="term-IPL"></a>

**IPL**

<a id="term-Initial-Program-Load"></a>

**Initial Program Load**

*Work in Progress*

<a id="term-IPMI"></a>

**IPMI**

<a id="term-Intelligent-Platform-Management-Interface"></a>

**Intelligent Platform Management Interface**

*Work in Progress*

<a id="term-IPP"></a>

**IPP**

<a id="term-Internet-Printing-Protocol"></a>

**Internet Printing Protocol**

*Work in Progress*

<a id="term-IPSec"></a>

**IPSec**

<a id="term-Internet-Protocol-Security"></a>

**Internet Protocol Security**

*Work in Progress*

<a id="term-IPVS"></a>

**IPVS**

<a id="term-IP-Virtual-Server"></a>

**IP Virtual Server**

*Work in Progress*

<a id="term-IQN"></a>

**IQN**

<a id="term-iSCSI-Qualified-Name"></a>

**iSCSI Qualified Name**

*Work in Progress*

<a id="term-IRC"></a>

**IRC**

<a id="term-Internet-Relay-Chat"></a>

**Internet Relay Chat**

*Work in Progress*

<a id="term-IRQ"></a>

**IRQ**

<a id="term-Interrupt-Request"></a>

**Interrupt Request**

A hardware signal sent to the processor that temporarily stops a running program and allows a special program, an interrupt handler, to run instead. Hardware interrupts are used to handle events such as receiving data from a network card, key presses, or mouse movements.

<a id="term-ISC"></a>

**ISC**

<a id="term-Internet-Systems-Consortium"></a>

**Internet Systems Consortium**

*Work in Progress*

<a id="term-iSCSI"></a>

**iSCSI**

<a id="term-Internet-Small-Computer-System-Interface"></a>

**Internet Small Computer System Interface**

iSCSI is a storage protocol that carries [SCSI](glossary.md#term-SCSI) commands over a TCP/IP network, providing access to remote storage devices as if they were locally attached.

See also:

- [iSCSI initiator (or client)](../how-to/storage/iscsi-initiator-or-client.md#iscsi-initiator-or-client)

Related topic(s):

- Networking

- Storage

<a id="term-ISO"></a>

**ISO**

<a id="term-International-Organization-for-Standardization"></a>

**International Organization for Standardization**

*Work in Progress*

<a id="term-ISP"></a>

**ISP**

<a id="term-Internet-Service-Provider"></a>

**Internet Service Provider**

*Work in Progress*

<a id="terms-j"></a>

## J

<a id="term-jitter"></a>

**jitter**

Jitter is the variation in delay or latency between when data packets are sent and when they are received over a network, causing irregular arrival times at the destination. This variation is often caused by network congestion, packet loss, poor hardware performance or differences in the path packets take.

Related topic(s):

- Networking

<a id="term-journald"></a>

**journald**

journald, also known as systemd-journald, is a logging service developed by the [systemd](glossary.md#term-Systemd) project as part of the systemd suite. It collects and stores log messages from various sources, including systemd services, kernel messages, system logs, and application logs. journald stores logs in a binary format offering advantages, such as storage efficiency, searchability, and most especially structured logging. In containerized systems like Docker, it functions as a logging driver for containers.

See also:

- The *[journald.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/journald.conf.5.html)* manual page

- [Docker journald documentation](https://docs.docker.com/engine/logging/drivers/journald/) for details on using journald as a logging driver

Related topic(s):

- Logging, Observability

<a id="term-JSON"></a>

**JSON**

<a id="term-JavaScript-Object-Notation"></a>

**JavaScript Object Notation**

This is a language-independent text format that uses conventions familiar to programmers of the C-family of languages, including C, C++, C#, Java, JavaScript, Perl, Python, and many others. Due to its simplicity, it is an ideal lightweight data interchange language.

See also:

- [The JSON website](https://www.json.org/json-en.html)

<a id="terms-k"></a>

## K

<a id="term-KDC"></a>

**KDC**

<a id="term-Key-Distribution-Center"></a>

**Key Distribution Center**

*Work in Progress*

<a id="term-keepalive"></a>

**keepalive**

*Work in Progress*

<a id="term-Kerberos"></a>

**Kerberos**

*Work in Progress*

<a id="term-keypair"></a>

**keypair**

*Work in Progress*

<a id="term-keyring"></a>

**keyring**

*Work in Progress*

<a id="term-keysalt"></a>

**keysalt**

*Work in Progress*

<a id="term-keyservers"></a>

**keyservers**

*Work in Progress*

<a id="term-keytab"></a>

**keytab**

*Work in Progress*

<a id="term-keytool"></a>

**keytool**

*Work in Progress*

<a id="term-KVM"></a>

**KVM**

<a id="term-Kernel-based-Virtual-Machine"></a>

**Kernel-based Virtual Machine**

*Work in Progress*

<a id="terms-l"></a>

## L

<a id="term-LAN"></a>

**LAN**

<a id="term-Local-Area-Network"></a>

**Local Area Network**

*Work in Progress*

<a id="term-LDAP"></a>

**LDAP**

<a id="term-Lightweight-Directory-Access-Protocol"></a>

**Lightweight Directory Access Protocol**

*Work in Progress*

<a id="term-LDIF"></a>

**LDIF**

<a id="term-LDAP-Data-Interchange-Format"></a>

**LDAP Data Interchange Format**

*Work in Progress*

<a id="term-lightervisor"></a>

**lightervisor**

*Work in Progress*

<a id="term-LinuxONE"></a>

**LinuxONE**

IBM Linux-only enterprise server platform.

<a id="term-Load-balancing"></a>

**Load-balancing**

*Work in Progress*

<a id="term-localhost"></a>

**localhost**

localhost is a [hostname](glossary.md#term-hostname) that points back to the machine itself using the loopback network interface. It is used to access services running locally without the need for an external network. The reserved [IP address](glossary.md#term-IP-address) for this is 127.0.0.1 (IPv4).

Related topic(s):

- Networking

<a id="term-Log-files"></a>

**Log files**

*Work in Progress*

<a id="term-Logstash"></a>

**Logstash**

*Work in Progress*

<a id="term-Logwatch"></a>

**Logwatch**

*Work in Progress*

<a id="term-LPAR"></a>

**LPAR**

<a id="term-Logical-Partition"></a>

**Logical Partition**

*Work in Progress*

<a id="term-LSI"></a>

**LSI**

<a id="term-Logic-Systems-Incorporated"></a>

**Logic Systems Incorporated**

*Work in Progress*

<a id="term-LTS"></a>

**LTS**

<a id="term-Long-Term-Support"></a>

**Long-Term Support**

LTS is a release policy that provides a stable version of a product for an extended period of time. For example, Ubuntu LTS releases receive 5 years of standard support, including security patches, bug fixes and hardware compatibility updates, prioritizing stability over newer package versions.

See also:

- [Ubuntu Releases](https://documentation.ubuntu.com/project/release-team/ubuntu-releases/)

<a id="term-LU"></a>

**LU**

<a id="term-Logical-Unit"></a>

**Logical Unit**

*Work in Progress*

<a id="term-LUA"></a>

**LUA**

<a id="term-Lua-Scripting-Language"></a>

**Lua Scripting Language**

*Work in Progress*

<a id="term-LUKS"></a>

**LUKS**

<a id="term-Linux-Unified-Key-Setup"></a>

**Linux Unified Key Setup**

LUKS is an open specification for Linux block-device encryption. It defines how encrypted volumes store metadata and keyslots.

<a id="term-LUN"></a>

**LUN**

<a id="term-Logical-Unit-Number"></a>

**Logical Unit Number**

*Work in Progress*

<a id="term-LV"></a>

**LV**

<a id="term-Logical-Volume"></a>

**Logical Volume**

*Work in Progress*

<a id="term-LVM"></a>

**LVM**

<a id="term-Logical-Volume-Manager"></a>

**Logical Volume Manager**

A storage management framework in Linux that provides a layer of abstraction over physical storage devices. It allows disks or partitions to be pooled into a single storage space, enabling the creation of flexible logical volumes that can be easily resized or moved.

<a id="term-LXC"></a>

**LXC**

<a id="term-Linux-Containers"></a>

**Linux Containers**

*Work in Progress*

<a id="term-LXD"></a>

**LXD**

<a id="term-Linux-Container-Daemon"></a>

**Linux Container Daemon**

*Work in Progress*

<a id="terms-m"></a>

## M

<a id="term-MAAS"></a>

**MAAS**

<a id="term-Metal-as-a-Service"></a>

**Metal as a Service**

*Work in Progress*

<a id="term-MAC"></a>

**MAC**

<a id="term-Message-Authentication-Code"></a>

**Message Authentication Code**

A MAC verifies that a message hasn’t been modified during transmission by combining a shared secret key between the sender and receiver, and a hash function.

<a id="term-MAC-address"></a>

**MAC address**

*Work in Progress*

<a id="term-spellexception-manpage-spellexception"></a>

**manpage**

<a id="term-manual-page"></a>

**manual page**

*Work in Progress*

<a id="term-MCE"></a>

**MCE**

<a id="term-Machine-Check-Exception"></a>

**Machine Check Exception**

*Work in Progress*

<a id="term-MD5"></a>

**MD5**

<a id="term-Message-Digest-Algorithm-5"></a>

**Message Digest Algorithm 5**

A cryptographic hash function producing a 128-bit checksum.

<a id="term-MDA"></a>

**MDA**

<a id="term-Mail-Delivery-Agent"></a>

**Mail Delivery Agent**

*Work in Progress*

<a id="term-mdev"></a>

**mdev**

<a id="term-Minimal-Device-Manager"></a>

**Minimal Device Manager**

*Work in Progress*

<a id="term-metapackage"></a>

**metapackage**

*Work in Progress*

<a id="term-METAR"></a>

**METAR**

<a id="term-Meteorological-Aerodrome-Report"></a>

**Meteorological Aerodrome Report**

*Work in Progress*

<a id="term-microservices"></a>

**microservices**

*Work in Progress*

<a id="term-microVMs"></a>

**microVMs**

*Work in Progress*

<a id="term-MOTD"></a>

**MOTD**

<a id="term-Message-of-the-Day"></a>

**Message of the Day**

*Work in Progress*

<a id="term-mount-points"></a>

**mount points**

*Work in Progress*

<a id="term-MPIO"></a>

**MPIO**

<a id="term-Multipath-Input-Output"></a>

**Multipath Input/Output**

*Work in Progress*

<a id="term-MSA"></a>

**MSA**

<a id="term-Modular-Smart-Array"></a>

**Modular Smart Array**

*Work in Progress*

<a id="term-MTA"></a>

**MTA**

<a id="term-Mail-Transfer-Agent"></a>

**Mail Transfer Agent**

*Work in Progress*

<a id="term-MTU"></a>

**MTU**

<a id="term-Maximum-Transmission-Unit"></a>

**Maximum Transmission Unit**

*Work in Progress*

<a id="term-MUA"></a>

**MUA**

<a id="term-Mail-User-Agent"></a>

**Mail User Agent**

*Work in Progress*

<a id="term-Multipass"></a>

**Multipass**

*Work in Progress*

<a id="term-Multipath"></a>

**Multipath**

*Work in Progress*

<a id="term-Multiview"></a>

**Multiview**

*Work in Progress*

<a id="term-MySQL"></a>

**MySQL**

*Work in Progress*

<a id="terms-n"></a>

## N

<a id="term-nameserver"></a>

**nameserver**

*Work in Progress*

<a id="term-namespace"></a>

**namespace**

*Work in Progress*

<a id="term-NAS"></a>

**NAS**

<a id="term-Network-Attached-Storage"></a>

**Network Attached Storage**

NAS is a file-level computer data storage server connected to a computer network providing data access to a heterogeneous group of clients. In this context, the term “NAS” can refer to both the technology and systems involved, and a specialized computer appliance device unit built for such functionality, a NAS appliance or NAS box.

See also:

- [DAS](glossary.md#term-DAS)

- [SAN](glossary.md#term-SAN)

<a id="term-NAT"></a>

**NAT**

<a id="term-Network-Address-Translation"></a>

**Network Address Translation**

*Work in Progress*

<a id="term-Netboot"></a>

**Netboot**

*Work in Progress*

<a id="term-Netfilter"></a>

**Netfilter**

*Work in Progress*

<a id="term-Netplan"></a>

**Netplan**

*Work in Progress*

<a id="term-NFS"></a>

**NFS**

<a id="term-Network-File-System"></a>

**Network File System**

*Work in Progress*

<a id="term-NFV"></a>

**NFV**

<a id="term-Network-Functions-Virtualization"></a>

**Network Functions Virtualization**

*Work in Progress*

<a id="term-nginx"></a>

**nginx**

*Work in Progress*

<a id="term-NIC"></a>

**NIC**

<a id="term-Network-Interface-Card"></a>

**Network Interface Card**

*Work in Progress*

<a id="term-NIS"></a>

**NIS**

<a id="term-Network-Information-Service"></a>

**Network Information Service**

*Work in Progress*

<a id="term-NMI"></a>

**NMI**

<a id="term-Non-Maskable-Interrupt"></a>

**Non-Maskable Interrupt**

*Work in Progress*

<a id="term-NRPE"></a>

**NRPE**

<a id="term-Nagios-Remote-Plugin-Executor"></a>

**Nagios Remote Plugin Executor**

*Work in Progress*

<a id="term-NSCQ"></a>

**NSCQ**

<a id="term-Network-System-Configuration-Queue"></a>

**Network System Configuration Queue**

*Work in Progress*

<a id="term-NSS"></a>

**NSS**

<a id="term-Name-Service-Switch"></a>

**Name Service Switch**

*Work in Progress*

<a id="term-NTP"></a>

**NTP**

<a id="term-Network-Time-Protocol"></a>

**Network Time Protocol**

*Work in Progress*

<a id="term-NTS"></a>

**NTS**

<a id="term-Network-Time-Security"></a>

**Network Time Security**

*Work in Progress*

<a id="term-NUMA"></a>

**NUMA**

<a id="term-Non-Uniform-Memory-Access"></a>

**Non-Uniform Memory Access**

A memory architecture where processors and system memory are grouped into nodes. A CPU can access memory on remote nodes, but at higher latency than local memory. See [CPU affinity, NUMA placement, and isolation](../explanation/performance/perf-tune-affinity-numa.md#perf-tune-affinity-numa) for tools that inspect and configure this placement.

<a id="term-Nvidia"></a>

**Nvidia**

*Work in Progress*

<a id="term-NVMe"></a>

**NVMe**

<a id="term-Non-Volatile-Memory-Express"></a>

**Non-Volatile Memory Express**

*Work in Progress*

<a id="term-NVRAM"></a>

**NVRAM**

<a id="term-Non-Volative-Random-Access-Memory"></a>

**Non-Volative Random Access Memory**

*Work in Progress*

<a id="term-NVSwitch"></a>

**NVSwitch**

<a id="term-NVIDIA-NVLink-Switch"></a>

**NVIDIA NVLink Switch**

*Work in Progress*

<a id="terms-o"></a>

## O

<a id="term-OCF"></a>

**OCF**

<a id="term-Open-Cluster-Framework"></a>

**Open Cluster Framework**

*Work in Progress*

<a id="term-OCFS"></a>

**OCFS**

<a id="term-Oracle-Cluster-File-System"></a>

**Oracle Cluster File System**

*Work in Progress*

<a id="term-OCI"></a>

**OCI**

<a id="term-Open-Container-Initiative"></a>

**Open Container Initiative**

*Work in Progress*

<a id="term-OCSP"></a>

**OCSP**

<a id="term-Online-Certificate-Status-Protocol"></a>

**Online Certificate Status Protocol**

*Work in Progress*

<a id="term-OpenLDAP"></a>

**OpenLDAP**

*Work in Progress*

<a id="term-OpenSC"></a>

**OpenSC**

<a id="term-Open-Smart-Card"></a>

**Open Smart Card**

*Work in Progress*

<a id="term-OpenSSH"></a>

**OpenSSH**

*Work in Progress*

<a id="term-OpenSSL"></a>

**OpenSSL**

*Work in Progress*

<a id="term-OpenStack"></a>

**OpenStack**

*Work in Progress*

<a id="term-OpenSUSE"></a>

**OpenSUSE**

*Work in Progress*

<a id="term-OpenVPN"></a>

**OpenVPN**

*Work in Progress*

<a id="term-OpenVZ"></a>

**OpenVZ**

*Work in Progress*

<a id="term-OpenWRT"></a>

**OpenWRT**

*Work in Progress*

<a id="term-OS"></a>

**OS**

<a id="term-Operating-System"></a>

**Operating System**

*Work in Progress*

<a id="term-OSA"></a>

**OSA**

<a id="term-Open-Systems-Adapter"></a>

**Open Systems Adapter**

*Work in Progress*

<a id="term-OSI"></a>

**OSI**

<a id="term-Open-Systems-Interconnection"></a>

**Open Systems Interconnection**

*Work in Progress*

<a id="term-OSPF"></a>

**OSPF**

<a id="term-Open-Shortest-Path-First"></a>

**Open Shortest Path First**

Open Shortest Path First (OSPF) is a widely used Interior Gateway Protocol (IGP) for IP networks, classifying as a link-state protocol that helps routers find the most efficient paths within a single Autonomous System (AS). It works by each router building a complete map (Link-State Database) of the network topology and using Dijkstra’s algorithm to calculate the shortest path to all destinations, ensuring fast convergence and scalability, especially in large enterprise network.

Related topic(s):

- Networking

<a id="term-OTE"></a>

**OTE**

<a id="term-Operational-Test-and-Evaluation"></a>

**Operational Test and Evaluation**

*Work in Progress*

<a id="term-OTP"></a>

**OTP**

<a id="term-One-Time-Password"></a>

**One-Time Password**

*Work in Progress*

<a id="term-OU"></a>

**OU**

<a id="term-Organizational-Unit"></a>

**Organizational Unit**

*Work in Progress*

<a id="term-OverlayFS"></a>

**OverlayFS**

*Work in Progress*

<a id="term-OVS"></a>

**OVS**

<a id="term-Open-vSwitch"></a>

**Open vSwitch**

*Work in Progress*

<a id="terms-p"></a>

## P

<a id="term-PAM"></a>

**PAM**

<a id="term-Pluggable-Authentication-Module"></a>

**Pluggable Authentication Module**

*Work in Progress*

<a id="term-page-fault"></a>

**page fault**

<a id="term-page-faults"></a>

**page faults**

An event raised by the memory management unit when a process accesses a virtual memory page not currently mapped to physical RAM. The kernel handles the fault by allocating a physical page frame, loading data from storage, or terminating an invalid access. See the [Linux kernel memory management documentation](https://docs.kernel.org/admin-guide/mm/index.html) for details.

<a id="term-passthrough"></a>

**passthrough**

*Work in Progress*

<a id="term-PB"></a>

**PB**

Petabyte (unit of measurement) 1 PB = 1024 [TB](glossary.md#term-TB)

<a id="term-PCI"></a>

**PCI**

<a id="term-Peripheral-Component-Interconnect"></a>

**Peripheral Component Interconnect**

*Work in Progress*

<a id="term-PCIe"></a>

**PCIe**

<a id="term-Peripheral-Component-Interconnect-Express"></a>

**Peripheral Component Interconnect Express**

*Work in Progress*

<a id="term-PCS"></a>

**PCS**

<a id="term-Pacemaker-Corosync-Stack"></a>

**Pacemaker/Corosync Stack**

*Work in Progress*

<a id="term-PDC"></a>

**PDC**

<a id="term-Primary-Domain-Controller"></a>

**Primary Domain Controller**

*Work in Progress*

<a id="term-PEM"></a>

**PEM**

<a id="term-Privacy-Enhanced-Mail"></a>

**Privacy Enhanced Mail**

*Work in Progress*

<a id="term-Petitboot"></a>

**Petitboot**

*Work in Progress*

<a id="term-PgSQL"></a>

**PgSQL**

*Work in Progress*

<a id="term-PHP"></a>

**PHP**

<a id="term-PHP-HyperText-Preprocessor"></a>

**PHP: HyperText Preprocessor**

*Work in Progress*

<a id="term-PID"></a>

**PID**

<a id="term-Process-Identifier"></a>

**Process Identifier**

*Work in Progress*

<a id="term-pingable"></a>

**pingable**

*Work in Progress*

<a id="term-PIV"></a>

**PIV**

<a id="term-Personal-Identity-Verification"></a>

**Personal Identity Verification**

*Work in Progress*

<a id="term-PKCS"></a>

**PKCS**

<a id="term-Public-Key-Cryptography-Standards"></a>

**Public-Key Cryptography Standards**

*Work in Progress*

<a id="term-PKI"></a>

**PKI**

<a id="term-Public-Key-Infrastructure"></a>

**Public Key Infrastructure**

*Work in Progress*

<a id="term-pluggable"></a>

**pluggable**

*Work in Progress*

<a id="term-PMD"></a>

**PMD**

<a id="term-Poll-Mode-Driver"></a>

**Poll Mode Driver**

*Work in Progress*

<a id="term-pockets"></a>

**pockets**

Sub-repositories within the Ubuntu Package Archive.

See also:

- [Ubuntu Project: pockets](https://documentation.ubuntu.com/project/how-ubuntu-is-made/concepts/package-archive/#pockets)

<a id="term-POSIX"></a>

**POSIX**

<a id="term-Portable-Operating-System-Interface-for-UNIX"></a>

**Portable Operating System Interface (for UNIX)**

*Work in Progress*

<a id="term-Postcopy"></a>

**Postcopy**

*Work in Progress*

<a id="term-Postfix"></a>

**Postfix**

*Work in Progress*

<a id="term-PostgreSQL"></a>

**PostgreSQL**

*Work in Progress*

<a id="term-PostScript"></a>

**PostScript**

*Work in Progress*

<a id="term-Power-8"></a>

**Power 8**

<a id="term-Power-9"></a>

**Power 9**

IMB POWER processor architectures used in enterprise servers.

<a id="term-PowerShell"></a>

**PowerShell**

*Work in Progress*

<a id="term-PPA"></a>

**PPA**

<a id="term-Personal-Package-Archive"></a>

**Personal Package Archive**

*Work in Progress*

<a id="term-ppc"></a>

**ppc**

<a id="term-PowerPC"></a>

**PowerPC**

*Work in Progress*

<a id="term-PPD"></a>

**PPD**

<a id="term-PostScript-Printer-Description"></a>

**PostScript Printer Description**

*Work in Progress*

<a id="term-PPPoE"></a>

**PPPoE**

<a id="term-Point-to-Point-Protocol-over-Ethernet"></a>

**Point-to-Point Protocol over Ethernet**

PPPoE is a network protocol that encapsulates Point-to-Point Protocol (PPP) frames inside Ethernet frames. It is commonly used by Internet service providers to manage and authenticate broadband connections such as DSL.

Related topic(s):

- Networking

<a id="term-PPS"></a>

**PPS**

<a id="term-Pulse-Per-Second"></a>

**Pulse Per Second**

*Work in Progress*

<a id="term-Preboot"></a>

**Preboot**

*Work in Progress*

<a id="term-preseed"></a>

**preseed**

*Work in Progress*

<a id="term-Prometheus"></a>

**Prometheus**

*Work in Progress*

<a id="term-proxy"></a>

**proxy**

*Work in Progress*

<a id="term-PTP"></a>

**PTP**

<a id="term-Precision-Time-Protocol"></a>

**Precision Time Protocol**

*Work in Progress*

<a id="term-PTR"></a>

**PTR**

<a id="term-Pointer-Record"></a>

**Pointer Record**

*Work in Progress*

<a id="term-PXE"></a>

**PXE**

<a id="term-Preboot-Execution-Environment"></a>

**Preboot Execution Environment**

*Work in Progress*

<a id="term-PXELINUX"></a>

**PXELINUX**

<a id="term-PXE-Linux-Loader"></a>

**PXE Linux Loader**

*Work in Progress*

<a id="terms-q"></a>

## Q

<a id="term-QA"></a>

**QA**

<a id="term-Quality-Assurance"></a>

**Quality Assurance**

*Work in Progress*

<a id="term-QDevice"></a>

**QDevice**

<a id="term-Quorum-Device"></a>

**Quorum Device**

*Work in Progress*

<a id="term-QEMU"></a>

**QEMU**

<a id="term-Quick-Emulator"></a>

**Quick Emulator**

*Work in Progress*

<a id="term-QETH"></a>

**QETH**

<a id="term-QDIO-Ethernet"></a>

**QDIO Ethernet**

*Work in Progress*

<a id="term-quickstart"></a>

**quickstart**

*Work in Progress*

<a id="terms-r"></a>

## R

<a id="term-RAM"></a>

**RAM**

<a id="term-Random-Access-Memory"></a>

**Random Access Memory**

*Work in Progress*

<a id="term-RangeSize"></a>

**RangeSize**

*Work in Progress*

<a id="term-RDAC"></a>

**RDAC**

<a id="term-Redundant-Disk-Array-Controller"></a>

**Redundant Disk Array Controller**

*Work in Progress*

<a id="term-RDBMS"></a>

**RDBMS**

<a id="term-Relational-Database-Management-System"></a>

**Relational Database Management System**

*Work in Progress*

<a id="term-RDN"></a>

**RDN**

<a id="term-Relative-Distinguished-Name"></a>

**Relative Distinguished Name**

*Work in Progress*

<a id="term-renderer"></a>

**renderer**

*Work in Progress*

<a id="term-REXX"></a>

**REXX**

<a id="term-Restructured-Extended-Executor"></a>

**Restructured Extended Executor**

*Work in Progress*

<a id="term-RFC"></a>

**RFC**

<a id="term-Request-For-Comments"></a>

**Request For Comments**

*Work in Progress*

<a id="term-rid"></a>

**rid**

<a id="term-Relative-Identifier"></a>

**Relative Identifier**

*Work in Progress*

<a id="term-RIP"></a>

**RIP**

<a id="term-Router-Information-Protocol"></a>

**Router Information Protocol**

Routing Information Protocol (RIP) is an older, simple distance-vector routing protocol that helps routers find the best path in small networks by counting “hops” (routers passed), using the Bellman-Ford algorithm, and periodically sending full routing tables to neighbors, though its 15-hop limit and bandwidth usage make it outdated for large networks, with OSPF or IS-IS being modern alternatives.

Related topic(s):

- Networking

<a id="term-RISC-V"></a>

**RISC-V**

<a id="term-Reduced-Instruction-Set-Computing-Version-Five"></a>

**Reduced Instruction Set Computing - Version Five**

*Work in Progress*

<a id="term-Rocks"></a>

**Rocks**

*Work in Progress*

<a id="term-ROM"></a>

**ROM**

<a id="term-Read-Only-Memory"></a>

**Read-Only Memory**

*Work in Progress*

<a id="term-rootDN"></a>

**rootDN**

<a id="term-Root-Distinguished-Name"></a>

**Root Distinguished Name**

*Work in Progress*

<a id="term-rootfs"></a>

**rootfs**

<a id="term-Root-File-System"></a>

**Root File System**

*Work in Progress*

<a id="term-routable"></a>

**routable**

*Work in Progress*

<a id="term-RSA"></a>

**RSA**

<a id="term-RivestShamirAdleman"></a>

**Rivest–Shamir–Adleman**

RSA is an asymmetric encryption algorithm. *Work in Progress*

<a id="term-rsync"></a>

**rsync**

<a id="term-Remote-Sync"></a>

**Remote Sync**

Rsync is not strictly a protocol. Rsync is a file synchronization and transfer tool. It uses port 22, when over SSH, or 873 for rsync daemon. Rsync is the most efficient tool to synchronise backup tasks because it uses the Delta Transfer Algorithm method.

See also:

- [FTP](glossary.md#term-FTP)

- [SCP](glossary.md#term-SCP)

- [SFTP](glossary.md#term-SFTP)

<a id="term-RTC"></a>

**RTC**

<a id="term-Real-Time-Clock"></a>

**Real-Time Clock**

*Work in Progress*

<a id="term-runtime"></a>

**runtime**

*Work in Progress*

<a id="terms-s"></a>

## S

<a id="term-Samba"></a>

**Samba**

Open source software that implements the SMB/CIFS protocol for file and printer sharing with Windows systems.

See also:

- [Introduction to Samba](../explanation/intro-to/samba.md#introduction-to-samba)

<a id="term-SAN"></a>

**SAN**

<a id="term-Storage-Area-Network"></a>

**Storage Area Network**

A SAN is a dedicated network that connects servers to storage devices such as disk arrays and tape libraries. It is a specialized high-speed network that provides access to consolidated block-level data storage. It makes storage devices appear as locally attached to the operating system, even though they are on a separate network.

See also:

- [NAS](glossary.md#term-NAS)

<a id="term-sandboxed"></a>

**sandboxed**

Sandboxed means running software in an isolated environment where it cannot affect anything outside the sandbox. Sandboxing does two things:

- Isolates: The sandboxed program cannot access:

  - Your files (unless explicitly allowed)

  - Other running programs

  - System settings

  - Network resources (in some cases)

- Secures: If the sandboxed program is malicious or gets compromised, the damage is contained. It cannot spread to your whole system.

Related topic(s):

- Virtualization and containers

<a id="term-SANLOCK"></a>

**SANLOCK**

<a id="term-Storage-Area-Network-Locking-Daemon"></a>

**Storage Area Network Locking Daemon**

SAN Locking Daemon is a lock manager designed for shared storage in [SAN](glossary.md#term-SAN) environments.

<a id="term-SASL"></a>

**SASL**

<a id="term-Simple-Authentication-and-Security-Layer"></a>

**Simple Authentication and Security Layer**

SASL is a framework that adds authentication and security to network protocols. SASL itself does not define how to authenticate. It defines how to negotiate and use authentication mechanisms.

<a id="term-SBD"></a>

**SBD**

<a id="term-Storage-Based-Death"></a>

**Storage-Based Death**

SBD is a fencing mechanism used in high-availability (HA) Linux clusters to prevent split-brain scenarios and data corruption. SBD uses shared storage as a communication channel to coordinate cluster nodes and forcibly reboot (“fence”) problematic nodes that might cause issues.

<a id="term-sbin"></a>

**sbin**

<a id="term-System-Binaries"></a>

**System Binaries**

`sbin/` is a directory in Unix/Linux systems that contains essential system administration commands and executables. It holds programs needed for system administration, booting, and repair. On many modern Linux distributions, `/sbin` is often symlinked to `/usr/sbin`, and both directories are merged as part of filesystem simplification efforts. The distinction is becoming less strict, but historically `/sbin` was for boot-essential tools.

<a id="term-schema"></a>

**schema**

Schema (plural: schemas or schemata) refers to a structured framework or blueprint that defines how data is organized. The meaning varies slightly depending on context.

<a id="term-SCP"></a>

**SCP**

<a id="term-Secure-Copy-Protocol"></a>

**Secure Copy Protocol**

SCP is a network protocol for securely transferring files between computers over [SSH](glossary.md#term-SSH). SCP allows you to copy files between a local and remote host, or between two remote hosts, with encryption to protect the data during transfer.

See also:

- [FTP](glossary.md#term-FTP)

- [SFTP](glossary.md#term-SFTP)

- [rsync](glossary.md#term-rsync)

<a id="term-Scrollback"></a>

**Scrollback**

Scrollback refers to the ability to scroll back through previous content in a terminal or console window. Scrollback is the buffer that stores older content so you can scroll up to see it. Limitations are lost on close, not infinite, and the performance may suffer if the buffer is very large.

Related topic(s):

- Command history

<a id="term-SCSI"></a>

**SCSI**

<a id="term-Small-Computer-System-Interface"></a>

**Small Computer System Interface**

SCSI (pronounced “scuzzy”) is both a physical interface (cables and connectors) and a command protocol (set of standards) for communicating with storage and peripheral devices like hard drives, tape drives, and scanners. Each device gets a unique ID number (0-7 or 0-15 depending on version). The last device in a SCSI chain needs a terminator to prevent signal reflection.

<a id="term-SDN"></a>

**SDN**

<a id="term-Software-Defined-Networking"></a>

**Software-Defined Networking**

*Work in Progress*

<a id="term-seccomp"></a>

**seccomp**

<a id="term-Secure-computing-mode"></a>

**Secure computing mode**

*Work in Progress*

<a id="term-SFTP"></a>

**SFTP**

<a id="term-SSH-File-Transfer-Protocol"></a>

**SSH File Transfer Protocol**

SFTP is a secure file transfer protocol that runs over [SSH](glossary.md#term-SSH). SFTP is fully encrypted. The port used is 22.

See also:

- [FTP](glossary.md#term-FTP)

- [SCP](glossary.md#term-SCP)

- [rsync](glossary.md#term-rsync)

<a id="term-SGI"></a>

**SGI**

<a id="term-Silicon-Graphics-Inc."></a>

**Silicon Graphics Inc.**

*Work in Progress*

<a id="term-SHA"></a>

**SHA**

<a id="term-Secure-Hash-Algorithm"></a>

**Secure Hash Algorithm**

*Work in Progress*

<a id="term-sharding"></a>

**sharding**

*Work in Progress*

<a id="term-Shell"></a>

**Shell**

*Work in Progress*

<a id="term-SHM"></a>

**SHM**

<a id="term-Shared-Memory"></a>

**Shared Memory**

*Work in Progress*

<a id="term-Shorewall"></a>

**Shorewall**

<a id="term-Shoreline-Firewall"></a>

**Shoreline Firewall**

*Work in Progress*

<a id="term-SIDs"></a>

**SIDs**

<a id="term-Security-Identifiers"></a>

**Security Identifiers**

*Work in Progress*

<a id="term-SIMD"></a>

**SIMD**

<a id="term-Single-Instruction-Multiple-Data"></a>

**Single Instruction, Multiple Data**

*Work in Progress*

<a id="term-slapd"></a>

**slapd**

<a id="term-Standalone-LDAP-Daemon"></a>

**Standalone LDAP Daemon**

*Work in Progress*

<a id="term-SLAT"></a>

**SLAT**

<a id="term-Second-Level-Address-Translation"></a>

**Second Level Address Translation**

*Work in progress*

<a id="term-smart-card"></a>

**smart card**

*Work in Progress*

<a id="term-SMB"></a>

**SMB**

<a id="term-Server-Message-Block"></a>

**Server Message Block**

*Work in Progress*

<a id="term-SMS"></a>

**SMS**

<a id="term-Short-Message-Service"></a>

**Short Message Service**

*Work in Progress*

<a id="term-SMTP"></a>

**SMTP**

<a id="term-Simple-Mail-Transfer-Protocol"></a>

**Simple Mail Transfer Protocol**

*Work in Progress*

<a id="term-SMTPS"></a>

**SMTPS**

<a id="term-SMTP-Secure"></a>

**SMTP Secure**

*Work in Progress*

<a id="term-Snap"></a>

**Snap**

*Work in Progress*

<a id="term-snapd"></a>

**snapd**

*Work in Progress*

<a id="term-snapshot"></a>

**snapshot**

*Work in Progress*

<a id="term-Snap-store"></a>

**Snap store**

*Work in Progress*

<a id="term-SNMP"></a>

**SNMP**

<a id="term-Simple-Network-Management-Protocol"></a>

**Simple Network Management Protocol**

*Work in Progress*

<a id="term-SOA"></a>

**SOA**

<a id="term-Start-of-Authority"></a>

**Start of Authority**

*Work in Progress*

<a id="term-Solaris"></a>

**Solaris**

*Work in Progress*

<a id="term-SPC"></a>

**SPC**

<a id="term-SCSI-Primary-Commands"></a>

**SCSI Primary Commands**

*Work in Progress*

<a id="term-Splunk"></a>

**Splunk**

*Work in Progress*

<a id="term-SRU"></a>

**SRU**

<a id="term-Stable-Release-Update"></a>

**Stable Release Update**

*Work in Progress*

<a id="term-SSD"></a>

**SSD**

<a id="term-Solid-State-Drive"></a>

**Solid State Drive**

*Work in Progress*

<a id="term-SSH"></a>

**SSH**

<a id="term-Secure-Shell"></a>

**Secure Shell**

*Work in Progress*

<a id="term-SSH-key"></a>

**SSH-key**

<a id="term-Secure-Shell-Key"></a>

**Secure Shell Key**

A cryptographic encryption key pair for [SSH](glossary.md#term-SSH), usually used and created with [OpenSSH](glossary.md#term-OpenSSH). It’s split in two parts: a *public* and a *private* key files. The private key is secret and belongs to the owning user, and it’s used to prove possession of that secret. The public key is not secret and is used to securely identify only the private key holder. That way, entering a public key on a server for [SSH](glossary.md#term-SSH) access, only the private key holder can log in.

<a id="term-SSI"></a>

**SSI**

<a id="term-Server-Side-Includes"></a>

**Server-Side Includes**

*Work in Progress*

<a id="term-SSL"></a>

**SSL**

<a id="term-Secure-Sockets-Layer"></a>

**Secure Sockets Layer**

*Work in Progress*

<a id="term-SSO"></a>

**SSO**

<a id="term-Single-Sign-On"></a>

**Single Sign-On**

*Work in Progress*

<a id="term-SSSD"></a>

**SSSD**

<a id="term-System-Security-Services-Daemon"></a>

**System Security Services Daemon**

*Work in Progress*

<a id="term-stateful"></a>

**stateful**

*Work in Progress*

<a id="term-STDIN"></a>

**STDIN**

<a id="term-Standard-Input"></a>

**Standard Input**

*Work in Progress*

<a id="term-STDOUT"></a>

**STDOUT**

<a id="term-Standard-Output"></a>

**Standard Output**

*Work in Progress*

<a id="term-STDERR"></a>

**STDERR**

<a id="term-Standard-Error"></a>

**Standard Error**

*Work in Progress*

<a id="term-STK"></a>

**STK**

<a id="term-StorageTek"></a>

**StorageTek**

*Work in Progress*

<a id="term-storage"></a>

**storage**

*Work in Progress*

<a id="term-subcommand"></a>

**subcommand**

*Work in Progress*

<a id="term-Subiquity"></a>

**Subiquity**

*Work in Progress*

<a id="term-subnet"></a>

**subnet**

<a id="term-subnetwork"></a>

**subnetwork**

*Work in Progress*

<a id="term-substring"></a>

**substring**

*Work in Progress*

<a id="term-subvolume"></a>

**subvolume**

*Work in Progress*

<a id="term-sudo"></a>

**sudo**

<a id="term-superuser-do"></a>

**superuser do**

*Work in Progress*

<a id="term-superblock"></a>

**superblock**

*Work in Progress*

<a id="term-symlink"></a>

**symlink**

*Work in Progress*

<a id="term-syslog"></a>

**syslog**

*Work in Progress*

<a id="term-systemctl"></a>

**systemctl**

*Work in Progress*

<a id="term-Systemd"></a>

**Systemd**

*Work in Progress*

<a id="terms-t"></a>

## T

<a id="term-tasksel"></a>

**tasksel**

<a id="term-Task-selector"></a>

**Task selector**

Tasksel is a Debian/Ubuntu tool that simplifies the installation of collections of related packages (called “tasks”) for specific purposes, like setting up a mail server, LAMP stack, or desktop environment. Instead of manually installing dozens of packages, tasksel lets you install entire pre-configured software bundles with a single command.

<a id="term-TB"></a>

**TB**

Terabyte (unit of measurement) 1 TB = 1024 [GB](glossary.md#term-GB)

<a id="term-TCP"></a>

**TCP**

<a id="term-Transmission-Control-Protocol"></a>

**Transmission Control Protocol**

TCP is one of the core protocols of the Internet Protocol Suite, providing reliable, ordered, and error-checked delivery of data between applications over a network. It is the “reliable” protocol that most internet applications depend on. You use [TCP](glossary.md#term-TCP) whenever you need to be sure your data arrives intact and in order.

<a id="term-TDX"></a>

**TDX**

<a id="term-Trust-domain-extensions"></a>

**Trust domain extensions**

It is security technology from Intel that creates isolated, encrypted virtual machines called “Trust Domains”. TDX:

- Protects confidential workloads in cloud environments

- Encrypts VM memory to protect it from the host system or hypervisor

<a id="term-TEE"></a>

**TEE**

<a id="term-Trusted-Execution-Environment"></a>

**Trusted Execution Environment**

A secure processor enclave that isolates code and data to ensure confidentiality, integrity, and verifiable trust, forming the foundation of Confidential Computing.

<a id="term-TFTP"></a>

**TFTP**

<a id="term-Trivial-File-Transfer-Protocol"></a>

**Trivial File Transfer Protocol**

TFTP is a very simple, lightweight file transfer protocol that uses [UDP](glossary.md#term-UDP) instead of [TCP](glossary.md#term-TCP), designed for basic file transfers where simplicity is more important than features or security. It is “trivial” because it has minimal functionality - no authentication, no encryption, no directory listing, just basic reading and writing of files.

<a id="term-TGS"></a>

**TGS**

<a id="term-Ticket-Granting-Service"></a>

**Ticket Granting Service**

TGS is a credential issued by Kerberos used in the Kerberos authentication protocol, a key component of the Key Distribution Center (KDC) that issues service tickets to clients after initial authentication.

<a id="term-TGT"></a>

**TGT**

<a id="term-Ticket-Granting-Ticket"></a>

**Ticket Granting Ticket**

TGT is a credential issued by Kerberos authentication systems. TGT allows users to request service tickets without re-entering their password.

<a id="term-TLB"></a>

**TLB**

<a id="term-Translation-Lookaside-Buffer"></a>

**Translation Lookaside Buffer**

TLB is a specialized cache in the [CPU](glossary.md#term-CPU) that stores recent virtual-to-physical address translations, dramatically speeding up memory access by avoiding repeated page table lookups. It is a critical component of virtual memory systems that makes address translation fast enough to be practical. When the CPU translates a virtual address, it first checks the TLB. If the mapping is found, the translation is fast. If it is missing, the CPU retrieves the mapping from the page table in memory, which takes longer.

<a id="term-TLS"></a>

**TLS**

<a id="term-Transport-Layer-Security"></a>

**Transport Layer Security**

TLS is a cryptographic protocol that provides secure communication over a network by encrypting data transmitted between clients and servers. It is the successor to SSL (Secure Sockets Layer) and is what makes [HTTPS](glossary.md#term-HTTPS) secure (the padlock icon in your browser).

<a id="term-tmpfs"></a>

**tmpfs**

<a id="term-Temporary-Filesystem"></a>

**Temporary Filesystem**

tmpfs is a filesystem that stores all files in virtual memory (RAM) instead of on a physical disk, making it fast but also volatile - data disappears when the system reboots or loses power.

<a id="term-tmux"></a>

**tmux**

<a id="term-Terminal-Multiplexer"></a>

**Terminal Multiplexer**

tmux is a powerful command-line tool that allows you to manage multiple terminal sessions from a single window, with the ability to detach and reattach sessions. It is a way to have multiple terminal windows and split-screen layouts, all within a single terminal, with sessions that persist even when you disconnect.

<a id="term-topologies"></a>

**topologies**

Topologies (in a networking context) refer to the physical or logical arrangement of devices and connections in a network - essentially how computers, switches, routers, and other devices are interconnected.

<a id="term-TOTP"></a>

**TOTP**

<a id="term-Time-based-One-Time-Password"></a>

**Time-based One-Time Password**

TOTP is an algorithm that generates temporary, single-use passwords based on the current time and a shared secret key. It is one of the most common forms of two-factor authentication (2FA) used by apps like Google Authenticator, Microsoft Authenticator, and many others.

<a id="term-TPM"></a>

**TPM**

<a id="term-Trusted-Platform-Module"></a>

**Trusted Platform Module**

A hardware security chip that securely stores cryptographic keys, measures system integrity during boot, and enables features such as secure storage, encryption, and attestation.

<a id="term-Traceback"></a>

**Traceback**

traceback is a term used in Python. Traceback is a report of the function call stack printed when an exception occurs. It shows the sequence of calls leading to the error, including file names, line numbers, and the exception type. It helps developers identify and debug issues by tracing execution backward from the failure point.

<a id="term-Traceroute"></a>

**Traceroute**

Traceroute is a network diagnostic tool that shows the path packets take from your computer to a destination across the internet, revealing each hop (router) along the way.

<a id="term-TTYS"></a>

**TTYS**

<a id="term-Teletype-Terminals"></a>

**Teletype Terminals**

TTYS were electromechanical typewriter-like devices used as input/output terminals for telegraph networks and early computers. They sent and received text over serial lines, printing characters on paper instead of displaying them on a screen. Even though the physical machines are mostly gone, the term TTY still exists in Unix/Linux systems to represent:

- A text-based input/output device

- A terminal session

- A console connection

<a id="term-TXT"></a>

**TXT**

<a id="term-Trusted-Execution-Technology"></a>

**Trusted Execution Technology**

TXT is Intel’s hardware-based security technology that creates a trusted execution environment to protect systems from software-based attacks. In other words, TXT was designed to make sure that a computer boots into a trusted and verified state before loading the operating system or applications. It protects against:

- Rootkits

- Boot-level malware

- Unauthorized changes to firmware or system software

<a id="terms-u"></a>

## U

<a id="term-UDA"></a>

**UDA**

<a id="term-Unified-Data-Architecture"></a>

**Unified Data Architecture**

UDA is an approach that provides a unified framework for integrating and managing data across an organization in a cohesive, standardized manner.

<a id="term-UDP"></a>

**UDP**

<a id="term-User-Datagram-Protocol"></a>

**User Datagram Protocol**

UDP is a network protocol used to send data between devices without creating or maintaining a connection. In other words, UDP is a connectionless transport layer protocol used for fast, low-overhead data transmission in iptables rules.

<a id="term-UEFI"></a>

**UEFI**

<a id="term-Unified-Extensible-Firmware-Interface"></a>

**Unified Extensible Firmware Interface**

UEFI is the modern replacement for BIOS (Basic Input/Output System). UEFI is the firmware interface between a computer’s hardware and its operating system. UEFI initializes hardware during boot and hands control over to the operating system.

<a id="term-UFW"></a>

**UFW**

<a id="term-Uncomplicated-Firewall"></a>

**Uncomplicated Firewall**

UFW is a user-friendly command-line tool for managing netfilter firewalls on Linux systems, simplifying complex iptables commands.

<a id="term-UID"></a>

**UID**

<a id="term-User-Identifier"></a>

**User Identifier**

UID known as User Identifier (in Unix/Linux contexts) or Unique Identifier (in general computing). In Unix-like systems, a UID is a numeric value assigned to each user account to uniquely identify them to the operating system.

<a id="term-UI"></a>

**UI**

<a id="term-User-Interface"></a>

**User Interface**

UI is the point of interaction between a user and a digital product, system, or application - essentially everything the user sees, touches, or interacts with when using software or hardware.

<a id="term-unicast"></a>

**unicast**

Unicast is a one-to-one network communication method where data is sent from a single sender to a single specific receiver.

<a id="term-unmount"></a>

**unmount**

Unmount is the process of safely detaching a filesystem from the system’s directory tree, making it inaccessible until it is mounted again. Unmount is the opposite of mounting. Unmount is important for data integrity, file system consistency, and the safe removal of USB drives or SD cards.

<a id="term-untrusted"></a>

**untrusted**

Untrusted refers to:

1.  data coming from outside the system, such as files uploaded by users

2.  code coming from an external, unknown, or non-verified source, such as third-party plug-ins

3.  network that cannot be assumed secure, such as public WI-FI

<a id="term-uptime"></a>

**uptime**

Uptime is a measure of how long a system has been running continuously since its last boot, crash, or restart. Uptime indicates system stability and availability.

<a id="term-URI"></a>

**URI**

<a id="term-Uniform-Resource-Identifier"></a>

**Uniform Resource Identifier**

URI is a compact string of characters that uniquely identifies an abstract or physical resource, such as a webpage, file, email address, or concept, without specifying how to access it.

<a id="term-URL"></a>

**URL**

<a id="term-Uniform-Resource-Locator"></a>

**Uniform Resource Locator**

URL is a standardized string that specifies the address of a web resource, such as webpages, image, or file, enabling browsers to locate and retrieve it over the internet.

<a id="term-userspace"></a>

**userspace**

userspace (also appears as “user space” or “user-space”) is the memory area and execution environment where normal applications and user programs run, as opposed to kernel space where the operating system kernel runs.

<a id="term-USN"></a>

**USN**

<a id="term-Update-Sequence-Number"></a>

**Update Sequence Number**

USN is a 64-bit monotonically increasing integer in Windows NTFS file system used by the change journal to log and track file/directory modifications like creations, deletions, renames, or data changes.

<a id="term-usr"></a>

**usr**

Refers to the `/usr/` directory and stands for “Unix System Resources”.

<a id="term-UUIDs"></a>

**UUIDs**

<a id="term-Universally-Unique-Identifiers"></a>

**Universally Unique Identifiers**

UUIDs are 128-bit numbers (typically represented as 32 hexadecimal digits in groups like 8-4-4-4-12) designed to uniquely identify objects, resources, or entities across systems without requiring a central authority.

<a id="terms-v"></a>

## V

<a id="term-vCPU"></a>

**vCPU**

<a id="term-Virtual-Central-Processing-Unit"></a>

**Virtual Central Processing Unit**

vCPU is a virtualized processor core allocated to a virtual machine, representing the [VM](glossary.md#term-VM)’s share of the physical [CPU](glossary.md#term-CPU) resources available on the host.

<a id="term-VCS"></a>

**VCS**

<a id="term-Version-Control-System"></a>

**Version Control System**

VCS is a software tool that tracks, manages, and stores changes to files, over time, recording who made the modifications, when, and enabling reversion to prior versions.

<a id="term-veth"></a>

**veth**

<a id="term-Virtual-Ethernet"></a>

**Virtual Ethernet**

veth is a Linux networking feature that creates a pair of connected virtual network interfaces that act like a virtual cable - whatever goes into one end comes out of the other.

<a id="term-VFIO"></a>

**VFIO**

<a id="term-Virtual-Function-I-O"></a>

**Virtual Function I/O**

VFIO is a Linux kernel framework that allows safe, direct access to physical hardware devices (like GPUs, network cards, or storage controllers) from user space or [VM](glossary.md#term-VM), using IOMMU ([Input-Output Memory Management Unit](glossary.md#term-Input-Output-Memory-Management-Unit)) hardware for security and isolation.

<a id="term-VFS"></a>

**VFS**

<a id="term-Virtual-File-System"></a>

**Virtual File System**

VFS is a kernel abstraction layer in operating systems like Linux that provides a uniform interface for applications to access diverse underlying file systems without needing to know their specifics.

<a id="term-VFs"></a>

**VFs**

<a id="term-Virtual-Functions"></a>

**Virtual Functions**

*Work in Progress*

<a id="term-VG"></a>

**VG**

<a id="term-Volume-Group"></a>

**Volume Group**

VG is a key component of LVM ([Logical Volume Manager](glossary.md#term-Logical-Volume-Manager)), which is a flexible storage management system for Linux. The VG is a pool created from one or more physical volumes (PVs).

<a id="term-vGPU"></a>

**vGPU**

<a id="term-Virtual-Graphics-Processing-Unit"></a>

**Virtual Graphics Processing Unit**

vGPU is a technology that allows a physical [GPU](glossary.md#term-GPU) to be shared among multiple virtual machines, with each [VM](glossary.md#term-VM) getting its own portion of GPU resources for graphics rendering, compute tasks, or AI/ML workloads.

<a id="term-virsh"></a>

**virsh**

<a id="term-Virtual-Shell"></a>

**Virtual Shell**

virsh refers to ‘/usr/bin/virsh’. It is a command-line program (from the libvirt-clients software package) that lets you create, start, stop, and manage virtual machines on Linux.

<a id="term-VirtIO"></a>

**VirtIO**

<a id="term-Virtualization-I-O"></a>

**Virtualization I/O**

VirtIO is a standardized, open-source framework for creating efficient virtual device drivers in virtualized environments. VirtIO is a specification that defines how virtual machines communicate with the hypervisor for I/O operations (disk, network, etc.) in a more efficient way than emulating real hardware.

<a id="term-virtual"></a>

**virtual**

Virtual refers to something implemented in software or by abstraction rather than being a single, dedicated physical object or device. It behaves as if it were physical (from the user’s or system’s point of view), but it is created and controlled by software.

<a id="term-virtualization"></a>

**virtualization**

Virtualization is the technology that creates software-based ([virtual](glossary.md#term-virtual)) representations of physical computing resources like servers, storage, networks, or operating systems. Virtualization is the fundamental concept of abstracting physical hardware to create multiple simulated environments or dedicated resources from a single physical system.

<a id="term-VLAN"></a>

**VLAN**

<a id="term-Virtual-Local-Area-Network"></a>

**Virtual Local Area Network**

VLAN is a way to split one physical network (like a switch or group of switches) into multiple, separate logical networks at Layer 2. Each VLAN is its own broadcast domain. In other words, devices in different VLANs are isolated unless a router or Layer 3 switch is used between them.

<a id="term-VM"></a>

**VM**

<a id="term-Virtual-Machine"></a>

**Virtual Machine**

VM is a software-based emulation of a physical computer that runs an operating system and applications just like a real computer, but it exists as a file or set of files on a host system. A hypervisor creates and manages the VMs by allocating portions of the physical hardware ([CPU](glossary.md#term-CPU), [RAM](glossary.md#term-RAM), storage, network) to each virtual machine. Each VM is isolated and thinks it has its own dedicated hardware.

<a id="term-VNC"></a>

**VNC**

<a id="term-Virtual-Network-Computing"></a>

**Virtual Network Computing**

VNC is a system for remotely viewing and controlling another computer’s graphical desktop over a network. VNC uses the remote frame buffer (RFB) to send screen updates from the remote machine and to receive keyboard and mouse input from the local machine.

<a id="term-VPN"></a>

**VPN**

<a id="term-Virtual-Private-Network"></a>

**Virtual Private Network**

VPN is a technology that creates an encrypted “tunnel” over a public network, such as the internet, so that devices may communicate as if they were in a private network. It hides or masks your real [IP](glossary.md#term-IP) address and protects the data that travels between your device and the VPN end point.

<a id="term-VRRP"></a>

**VRRP**

<a id="term-Virtual-Router-Redundancy-Protocol"></a>

**Virtual Router Redundancy Protocol**

VRRP is a standard first-hop redundancy protocol that keeps a LAN’s default gateway highly available. In other words, the VRRP is a router that lets multiple routers on the same subnet work together as a single “virtual” router with one shared IP or MAC address, so if one fails another can take over with minimal disruption, without changing host settings.

<a id="term-vsftpd"></a>

**vsftpd**

<a id="term-Very-Secure-FTP-Daemon"></a>

**Very Secure FTP Daemon**

vsftpd is an FTP (File Transfer Protocol) server software for Unix-like systems (Linux, BSD) that is designed with security, performance, and stability as top priorities.

<a id="terms-w"></a>

## W

<a id="term-WAL"></a>

**WAL**

<a id="term-Write-Ahead-Log"></a>

**Write-Ahead Log**

WAL is a fundamental technique used in databases and storage systems to ensure data durability and consistency. The basic principle is simple: Write what you are going to do before you do it, so if things go wrong you can always know what was happening. In other words, before any changes are made to the actual database files, the system first writes a record of what it is about to do to a sequential log file. If the system crashes mid-operation, it can replay the log during recovery to complete interrupted operations or roll them back.

<a id="term-WAN"></a>

**WAN**

<a id="term-Wide-Area-Network"></a>

**Wide Area Network**

WAN is a telecommunications network that extends over a large geographical area, typically connecting multiple smaller networks (like LANs) across cities, countries, or even continents.

<a id="term-WCCP"></a>

**WCCP**

<a id="term-Web-Cache-Communication-Protocol"></a>

**Web Cache Communication Protocol**

WCCP is a Cisco-developed protocol used to transparently redirect network traffic (often web traffic) from routers or switches to caching or proxy devices. It is mainly used to improve performance, enable content filtering, and provide load balancing and fault tolerance for web or proxy services.

<a id="term-Web-server"></a>

**Web server**

A web server is software (and sometimes the hardware it runs on) that serves web content to clients over the internet or an intranet using [HTTP](glossary.md#term-HTTP)/[HTTPS](glossary.md#term-HTTPS) protocols.

<a id="term-winbind"></a>

**winbind**

<a id="term-Windows-Bind"></a>

**Windows Bind**

winbind is a component of [Samba](glossary.md#term-Samba) on Linux/UNIX systems that lets those systems use accounts from an [AD](glossary.md#term-AD) domain for logins and identity information. winbind makes a Linux machine “look like” a Windows client to AD, so the AD users and groups can log in to Linux and be resolved just like local Unix accounts.

<a id="term-WireGuard"></a>

**WireGuard**

WireGuard is a modern, open-source [VPN](glossary.md#term-VPN) protocol designed to create fast, secure, and simple encrypted tunnels between devices. It is now built into the Linux kernel and widely used by VPN providers because of its performance and small codebase.

<a id="term-WLAN"></a>

**WLAN**

<a id="term-Wireless-Local-Area-Network"></a>

**Wireless Local Area Network**

WLAN is a local area network that uses wireless communication (typically Wi-Fi) instead of physical cables to connect devices within a limited area.

<a id="term-WSGI"></a>

**WSGI**

<a id="term-Web-Server-Gateway-Interface"></a>

**Web Server Gateway Interface**

WSGI is a specification that defines a standard interface between web servers and Python web applications or frameworks, creating portability and flexibility. It is a universal translator that allows any WSGI-compliant web server to communicate with any WSGI-compliant Python application.

<a id="term-WWID"></a>

**WWID**

<a id="term-World-Wide-Identifier"></a>

**World Wide Identifier**

WWID is a globally unique ID, long numeric/hex value, burned into or associated with a storage device like a disk or [LUN](glossary.md#term-LUN), so the system can recognize that device reliably, regardless of which cable, port, or path it is attached through.

<a id="terms-x"></a>

## X

<a id="term-X.509"></a>

**X.509**

X.509 is a standard format for public key certificates used in cryptography and network security. It is a digital certificate that binds a public key to an identity (like a website, person, or organization). X.509 is signed by a trusted [Certificate Authority](glossary.md#term-CA) to verify authenticity.

<a id="term-xhtml"></a>

**xhtml**

<a id="term-Extensible-HyperText-Markup-Language"></a>

**Extensible HyperText Markup Language**

xhtml is a stricter [HTML](glossary.md#term-HTML) language. It reformulates [HTML](glossary.md#term-HTML) as XML by combining [HTML](glossary.md#term-HTML) elements with XML’s strict syntax rules, so documents are well-formed, more consistent across browsers, and easier to process with XML tools.

<a id="term-XML"></a>

**XML**

<a id="term-Extensible-Markup-Language"></a>

**Extensible Markup Language**

XML is a markup language designed to store and transport data in a format that is both human and machine readable. Unlike HTML which focuses on displaying data, XML focuses on describing and structuring data.

<a id="terms-y"></a>

## Y

<a id="term-YAML"></a>

**YAML**

<a id="term-YAML-Ain-t-Markup-Language"></a>

**YAML Ain’t Markup Language**

YAML is a data serialization language used mainly for configuration files and structured data exchange between programmes. YAML represents data as key-value pairs, lists, and nested structures, using indentation instead of brackets or tags, to show hierarchy.

<a id="term-Yubikey"></a>

**Yubikey**

A YubiKey is a physical security key made by Yubico that provides hardware-based authentication for securing access to computers, networks, and online services. It is a small USB device (about the size of a USB stick) that acts as a second factor for two-factor authentication (2FA) or multi-factor authentication (MFA).

<a id="terms-z"></a>

## Z

<a id="term-zFCP"></a>

**zFCP**

<a id="term-zSeries-Fibre-Channel-Protocol"></a>

**zSeries Fibre Channel Protocol**

zFCP is a Linux device driver that enables IBM Z mainframes (formerly System z) to access storage devices over a Fibre Channel network using the [SCSI](glossary.md#term-SCSI) protocol.

<a id="term-ZFS"></a>

**ZFS**

<a id="term-Zettabyte-File-System"></a>

**Zettabyte File System**

ZFS is an advanced 64-bit file system that also includes its own built-in volume manager. It is designed for high-capacity and reliable storage. It is known for its strong data-integrity features, easy pooling of disks, and convenient features like snapshots, compression, and built in RAID (RAID-Z).

<a id="term-z-VM"></a>

**z/VM**

z/VM is IBM’s virtualization operating system for their mainframe computers (IBM Z systems, formerly known as System z). z/VM is a hypervisor that allows multiple operating systems to run simultaneously on a single mainframe, effectively turning one physical machine into many virtual machines.

---

> 来源：https://ubuntu.com/server/docs/reference/glossary/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
