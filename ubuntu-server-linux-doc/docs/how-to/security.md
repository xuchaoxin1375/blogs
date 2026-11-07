<a id="how-to-security"></a>

# Security

While a fresh Ubuntu installation is usually safe for immediate use, there are some additional steps you can take to introduce a layered approach to your system’s security. If you are new to Ubuntu, you may want to refer to our [Introduction to security](../explanation/intro-to/security.md#introduction-to-security) first for a general overview.

## General configuration

- [Users and groups management](security/user-management.md#user-management) for setting up user accounts, permissions and password policies

- [Firewalls](security/firewalls.md#firewalls) are recommended for network security

- [AppArmor](security/apparmor.md#apparmor) limits permissions and access for the software running on your system

- [Console security](security/console-security.md#console-security) for an additional physical security barrier

- [TPM-backed LUKS decryption](security/tpm-backed-luks-decryption-with-clevis.md#tpm-backed-luks-decryption-with-clevis) to automate decryption of disks

## Authentication

These tools are particularly useful for more advanced or complex setups.

- [Kerberos](kerberos.md#how-to-kerberos) is a network authentication protocol providing identity verification for distributed systems

- [Network user authentication with SSSD](sssd.md#how-to-network-user-authentication-with-sssd) handles authentication, user/group information and authorisation from disparate network sources

- [Smart card authentication](security/smart-card-authentication.md#smart-card-authentication) provides a physical authentication method

## Cryptography

The Secure Shell (SSH) cryptographic protocol that provides secure channels on an unsecured network. In Ubuntu, OpenSSH is the most commonly used implementation of SSH. It provides a suite of utilities for encrypting data transfers and can also be used for remote login and authentication.

- [Obtain TLS certificates](security/obtain-tls-certificates.md#obtain-tls-certificates) covers both Let’s Encrypt (for internet-facing servers) and running your own Certificate Authority (CA) for internal networks

<!-- -->

- [OpenSSH](security/openssh-server.md)
- [Obtain TLS certificates](security/obtain-tls-certificates.md)
- [Install a root CA certificate](security/install-a-root-ca-certificate-in-the-trust-store.md)

## Virtual Private Network (VPN)

VPNs are commonly used to provide encrypted, secure access to a network. Two of the most popular choices in Ubuntu are OpenVPN and WireGuard VPN.

- [OpenVPN](security/install-openvpn.md#install-openvpn) is a well-established option that supports many platforms besides Linux

- [WireGuard VPN](wireguard-vpn.md#how-to-wireguard-vpn) is a modern and performant option that removes a lot of the complexity from configuring a VPN

## See also

- Explanation: [Introduction to security](../explanation/intro-to/security.md#introduction-to-security)

- Explanation: [Security topics](../explanation/security.md#explanation-security)

---

> 来源：https://ubuntu.com/server/docs/how-to/security/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
