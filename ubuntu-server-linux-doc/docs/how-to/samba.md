<a id="how-to-samba"></a>

# Samba

A Samba server can be deployed as a full Active Directory Domain Controller (Samba AD/DC), providing authentication to domain users – whether Linux or Windows.

- [Set up a Samba AD Domain Controller](samba/provision-samba-ad-controller.md)
- [Join an Active Directory domain](samba/member-server-in-an-ad-domain.md)

## Set up sharing services

Samba can be configured as a file server or print server, to share files and printers with Windows clients.

- [Set up a file server](samba/file-server.md)
- [Set up a print server](samba/print-server.md)

## Access controls

- [Share access controls](samba/share-access-controls.md)
- [Create AppArmor profile](samba/apparmor-profile.md)
- [Mount CIFS shares permanently](samba/mount-cifs-shares-permanently.md)

## Legacy options

These options are now deprecated, but still available.

- [NT4 domain controller](samba/nt4-domain-controller-legacy.md)
- [OpenLDAP backend](samba/openldap-backend-legacy.md)

## See also

- Explanation: [Introduction to Samba](../explanation/intro-to/samba.md#introduction-to-samba)

---

> 来源：https://ubuntu.com/server/docs/how-to/samba/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
