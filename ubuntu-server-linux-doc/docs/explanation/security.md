<a id="explanation-security"></a>

# Security

There are many steps you can take to strengthen the security posture of your system. In this section you will find explanations of various concepts related to security.

## General configuration

- [Introduction to security](intro-to/security.md#introduction-to-security) for a high-level overview of security in Ubuntu

- [Security suggestions](security/security_suggestions.md#security-suggestions) provides general recommendations for any Ubuntu system, from straightforward setups to more advanced and complex systems

## Authentication

- [Introduction to Kerberos](intro-to/kerberos.md#introduction-to-kerberos), the network authentication system

- [Introduction to SSSD](intro-to/sssd.md#introduction-to-network-user-authentication-with-sssd), the collection of daemons that handle authentication from various network sources

- [About DNSSEC](dnssec/dnssec.md#dnssec), the security extension for the Domain Name System (DNS).

## Cryptography

- [Our cryptography section](cryptography.md#explanation-cryptography) explains in detail about the different cryptographic libraries and configurations you might encounter.

- [Certificates](security/certificates.md#certificates) are issued, stored and signed by a Certificate Authority (CA) to create trusted connections.

- [How to obtain certificates](../how-to/security/obtain-tls-certificates.md#obtain-tls-certificates) is a step-by-step guide covering Let’s Encrypt (via Certbot) and local CA implementation.

## Virtual Private Network (VPN)

VPNs are commonly used to provide encrypted, secure access to a network.

- [Introduction to WireGuard VPN](intro-to/wireguard-vpn.md#introduction-to-wireguard-vpn), a popular and modern VPN implementation

- [OpenVPN clients](security/openvpn-client-implementations.md#openvpn-client-implementations) provides a list of client implementations that can be used with a GUI across platforms.

## See also

- How-to: [Security](../how-to/security.md#how-to-security)

---

> 来源：https://ubuntu.com/server/docs/explanation/security/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
