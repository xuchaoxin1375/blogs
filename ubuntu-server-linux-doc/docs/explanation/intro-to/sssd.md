# Introduction to network user authentication with SSSD

The [System Security Services Daemon (SSSD)](https://sssd.io/) is a collection of daemons that handle authentication, authorisation, and user and group information from a variety of network sources. It’s a useful tool for administrators of Linux and UNIX-based systems, particularly if enterprise systems need to integrate with other directory, access control and authentication services.

## Common deployment scenarios

The SSSD supports a variety of authorization and identity services, such as Active Directory, LDAP, and Kerberos. The following guides will help you set up SSSD for:

- [Active Directory](../../how-to/sssd/with-active-directory.md#sssd-with-active-directory)

- [LDAP](../../how-to/sssd/with-ldap.md#sssd-with-ldap)

- [LDAP and Kerberos](../../how-to/sssd/with-ldap-and-kerberos.md#sssd-with-ldap-and-kerberos)

## Integration with PAM and NSS

If you need to integrate remote sources into your system, SSSD’s Pluggable Authentication Modules (PAM) and Name Service Switch (NSS) modules allow you to recognize remote users as valid users and identify them as members in user groups. In the event of network failure or other related problems, SSSD also can also cache this information, so that users can continue to login to the system.

## Troubleshooting

Canonical’s [SSSD troubleshooting guide](../../how-to/sssd/troubleshooting.md#troubleshooting-sssd) can provide you with information on managing problems with SSSD.

---

> 来源：https://ubuntu.com/server/docs/explanation/intro-to/sssd/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
