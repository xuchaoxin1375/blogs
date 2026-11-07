# Security suggestions

Although a fresh install of Ubuntu is relatively safe for immediate use on the Internet, in this guide we’ll take a look at some steps you can take to help keep your Ubuntu system safe and secure.

## For any Ubuntu system

The following suggestions are applicable generally to most Ubuntu systems. It is not necessary to use all of these steps – use the ones that are most relevant for your setup.

### Keep your system up-to-date

1.  **Regularly update** your Ubuntu system to keep it protected from known vulnerabilities. Run the following command periodically to update your system software:

    ``` console

    $ sudo apt update && sudo apt upgrade
    ```

    You may want to use the `unattended-upgrade` package to fetch and install security updates and bug fixes automatically:

    ``` console

    $ sudo apt install unattended-upgrades
    ```

    By default, `unattended-upgrade` runs daily, but this can be configured. See the *[unattended-upgrades(8)](https://manpages.ubuntu.com/manpages/resolute/man8/unattended-upgrades.8.html)* manual page for details.

2.  **Manage your software**:

    - Remove packages you don’t need, to minimize the potential attack surface you are exposing. See our article on [Package management](../../how-to/software/package-management.md#package-management) for more details.

    - Avoid using third party repositories. If you need to download a package from a third party repository, make sure you [understand the risks and how to minimize them.](../software/third-party-repository-usage.md#third-party-repository-usage).

3.  **Use the most up-to-date release** of Ubuntu. If you are on an older Ubuntu release we have instructions on [how to upgrade](../../how-to/software/upgrade-your-release.md#upgrade-your-release).

4.  **Use [Ubuntu Pro](https://ubuntu.com/pro)**, particularly if you are on an older release of Ubuntu. Pro provides Enterprise-level security patching, but is free for personal/business use on up to 5 machines. The most useful Pro features for *any* Ubuntu Server are:

    - [Expanded Security Maintenance (ESM)](https://documentation.ubuntu.com/security/security-updates/esm/) which expands the Ubuntu LTS commitment on packages in Main from 5 years to 10 years – and now also covers packages in Ubuntu Universe.

    - [Livepatch](https://ubuntu.com/security/livepatch/docs) applies kernel patches for high and critical severity vulnerabilities while the system is running. This avoids the need for an immediate reboot.

    Most security patches can be fetched and applied automatically through the `unattended-upgrade` package. For more details on using and monitoring Ubuntu Pro via the command line, refer to the [official documentation](https://documentation.ubuntu.com/pro-client/en/latest/).

### Access Control

1.  **Use and enforce** the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege):

    - This means creating non-root user accounts with as few privileges as possible.

    - Not using `sudo` (root access) except for administration tasks.

    - For more details on basic access control, see our [guide on user management](../../how-to/security/user-management.md#user-management).

### Network security

1.  **Use a firewall**. In Ubuntu, the uncomplicated firewall (`ufw`) tool is used to configure firewalls. `ufw` is a wrapper around the `iptables` utility (which experienced system admins may prefer to use directly). To get started with `ufw`, check out our [Firewall](../../how-to/security/firewalls.md#firewalls) guide.

2.  **Use the Secure Shell (SSH)** protocol to secure remote access. In Ubuntu, this is managed through OpenSSH. For details on setting up OpenSSH, refer to our [guide to OpenSSH](../../how-to/security/openssh-server.md#openssh-server).

### Physical security

There are also steps you can take to protect the physical security of your system. These how-to guides will help you set up these additional precautions:

- [Smart card authentication](../../how-to/security/smart-card-authentication.md#smart-card-authentication).

- [Smart card authentication with SSH](../../how-to/security/smart-card-authentication-with-ssh.md#smart-card-authentication-with-ssh).

- [Console security](../../how-to/security/console-security.md#console-security).

<a id="advanced-security"></a>

## Suggestions for complex setups

The following section will help direct you to the security-related packages for which we provide documentation. For more discussion about advanced security considerations, refer to the [Ubuntu Security](https://documentation.ubuntu.com/security/) documentation.

### Advanced Access Control

1.  **Lightweight Directory Access Protocol (LDAP)** is the usual way to gate access control for larger or more complex setups. In Ubuntu, this is implemented through OpenLDAP. Refer to our [introduction to OpenLDAP](../intro-to/openldap.md#introduction-to-openldap) for more details, or see our section [on how to set up OpenLDAP](../../how-to/openldap.md#how-to-openldap).

2.  **Kerberos** is a network authentication protocol that provides identity verification for distributed environments, commonly used in enterprise systems. Learn more in our [introduction to Kerberos](../intro-to/kerberos.md#introduction-to-kerberos), or see our section on how to [set up and use Kerberos](../../how-to/kerberos.md#how-to-kerberos).

3.  **System Security Services Daemon (SSSD)** is a collection of daemons that handle authentication, authorisation and user/group information from disparate network sources. It integrates with OpenLDAP, Kerberos, and Active Directory as we discuss in more detail in our [introduction to SSSD](../intro-to/sssd.md#introduction-to-network-user-authentication-with-sssd) or get started setting it up with our [how-to section](../../how-to/sssd.md#how-to-network-user-authentication-with-sssd).

4.  **Active Directory**, the directory service for Windows domain networks, can be set up to allow your Ubuntu Server to integrate with a Windows network. Find out more about [Active Directory integration](../active-directory.md#explanation-active-directory-integration), or [learn how to set it up](../../how-to/active-directory.md#how-to-active-directory-integration). You may also find [ADSys](../../reference/glossary.md#term-ADSys), the Group Policy client for Ubuntu, helpful. See the [ADSys documentation](https://documentation.ubuntu.com/adsys/latest/) for more details.

5.  **AppArmor** is strongly recommended in order to limit the system access and capabilities of the software running on your systems. It enforces Mandatory Access Control (MAC) policies for individual applications to ensure that even if an application is compromised, the amount of damage caused is limited. We have a how-to guide that will show you [how to set up AppArmor](../../how-to/security/apparmor.md#apparmor).

### Security of communications

VPNs are an important tool for system administrators. They provide encrypted, secure connections between a network and the users connecting to it. Two of the most popular choices in Ubuntu are **WireGuard VPN** and **OpenVPN**.

1.  **WireGuard VPN** is a modern and performant option, and it removes much of the complexity from the configuration and deployment of a VPN. To get an overview, see our [Introduction to WireGuard VPN](../intro-to/wireguard-vpn.md#introduction-to-wireguard-vpn). You can then find out how to [set up WireGuard VPN](../../how-to/wireguard-vpn.md#how-to-wireguard-vpn).

2.  **OpenVPN** is a well-established and widely supported option with a large user base. It supports many platforms besides Linux, including Windows, macOS and iOS. Find out more [about the available clients](openvpn-client-implementations.md#openvpn-client-implementations), or see our guide on [how to install OpenVPN](../../how-to/security/install-openvpn.md#install-openvpn).

It’s also important to consider **Transport Layer Security (TLS)** and/or **Secure Sockets Layer (SSL)** for securely encrypting data in transit. These cryptographic protocols provide privacy, integrity and authenticity to the communications being passed between two clients, or between a client and server. The exact implementation you choose will depend upon your setup, and there are many options available.

### Cryptography

There are many **cryptographic libraries** available in Ubuntu. For an overview of the most common ones, including some more details about TLS and SSL, refer to our page [about crypto libraries](../cryptography.md#explanation-cryptography). For a more high level overview of cryptographic libraries in general, see our [Introduction to cryptographic libraries](../intro-to/crypto-libraries.md#introduction-to-crypto-libraries)

Of course, no discussion of cryptography would be complete without including **certificates**. For more details about what certificates are and how they are used, see our [About certificates](certificates.md#certificates) page. Alternatively, if you are familiar with the concepts of certificates and Certification Authorities (CA), our how-to guide will show you how to [Install root CA certificate in the trust store](../../how-to/security/install-a-root-ca-certificate-in-the-trust-store.md#install-a-root-ca-certificate-in-the-trust-store)

### Compliance and auditing

If you need to adhere to specific industry standards, or are otherwise operating in a high security environment, refer to the [Ubuntu Security documentation](https://documentation.ubuntu.com/security/compliance/).

---

> 来源：https://ubuntu.com/server/docs/explanation/security/security_suggestions/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
