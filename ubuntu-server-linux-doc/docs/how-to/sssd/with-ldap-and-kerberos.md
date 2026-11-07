<a id="sssd-with-ldap-and-kerberos"></a>

# How to set up SSSD with LDAP and Kerberos

With SSSD we can create a setup that is very similar to Active Directory in terms of the technologies used: using LDAP for users and groups, and Kerberos for authentication.

## Prerequisites and assumptions

For this setup, we will need:

- An existing [OpenLDAP server](../openldap/install-openldap.md#install-openldap) using the RFC2307 schema for users and groups. SSL support is recommended, but not strictly necessary because authentication in this setup is being done via Kerberos, and not LDAP.

- A [Kerberos server](../kerberos/install-a-kerberos-server.md#install-a-kerberos-server). It doesn’t have to be [using the OpenLDAP backend](../kerberos/kerberos-with-openldap-backend.md#kerberos-with-openldap-backend).

- A client host where we will install and configure SSSD.

## Install necessary software

On the client host, install the following packages:

```console
$ sudo apt install sssd-ldap sssd-krb5 ldap-utils krb5-user
```

You may be asked about the default Kerberos realm. For this guide, we are using `EXAMPLE.COM`.

At this point, you should already be able to obtain tickets from your Kerberos server, assuming [DNS](../../reference/glossary.md#term-DNS) records point at it:

```console
$ kinit ubuntu
```

But we want to be able to login as an LDAP user, authenticated via Kerberos. Let’s continue with the configuration.

## Configure SSSD

Create the `/etc/sssd/sssd.conf` configuration file, with permissions `0600` and ownership `root:root`, and add the following content:

```ini
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
ldap_uri = ldap://ldap01.example.com
ldap_search_base = dc=example,dc=com
auth_provider = krb5
krb5_server = kdc01.example.com,kdc02.example.com
krb5_kpasswd = kdc01.example.com
krb5_realm = EXAMPLE.COM
cache_credentials = True
```

This example uses two KDCs, which made it necessary to also specify the `krb5_kpasswd` server because the second KDC is a replica and is not running the admin server.

Start the `sssd` service:

```console
$ sudo systemctl start sssd.service
```

## Automatic home directory creation

To enable automatic home directory creation, run the following command:

```console
$ sudo pam-auth-update --enable mkhomedir
```

## Final verification

In this example, the LDAP server has the following user and group entry we are going to use for testing:

```text
dn: uid=john,ou=People,dc=example,dc=com
uid: john
objectClass: inetOrgPerson
objectClass: posixAccount
cn: John Smith
sn: Smith
givenName: John
mail: john@example.com
uidNumber: 10001
gidNumber: 10001
loginShell: /bin/bash
homeDirectory: /home/john

dn: cn=john,ou=Group,dc=example,dc=com
cn: john
objectClass: posixGroup
gidNumber: 10001
memberUid: john

dn: cn=Engineering,ou=Group,dc=example,dc=com
cn: Engineering
objectClass: posixGroup
gidNumber: 10100
memberUid: john
```

Note how the user `john` has no `userPassword` attribute.

The user `john` should be known to the system:

```console
ubuntu@ldap-client:~$ getent passwd john
```

```console
ubuntu@ldap-client:~$ id john
```

Let’s try a login as this user:

```console
ubuntu@ldap-krb-client:~$ sudo login
```

```console
john@ldap-krb-client:~$ klist
```

We logged in using the Kerberos password, and user/group information from the LDAP server.

## SSSD and KDC spoofing

When using SSSD to manage Kerberos logins on a Linux host, there is an attack scenario you should be aware of: KDC spoofing.

The objective of the attacker is to login on a workstation that is using Kerberos authentication. Let’s say they know `john` is a valid user on that machine.

The attacker first deploys a rogue Key Distribution Center (KDC) server in the network, and creates the `john` principal there with a password of the attacker’s choosing. What they must do now is have their rogue KDC respond to the login request from the workstation, before (or instead of) the real KDC. If the workstation isn’t authenticating the KDC, it will accept the reply from the rogue server and let `john` in.

There is a configuration parameter that can be set to protect the workstation from this type of attack. It will have SSSD authenticate the KDC, and block the login if the KDC cannot be verified. This option is called `krb5_validate`, and it’s `false` by default.

To enable it, edit `/etc/sssd/sssd.conf` and add this line to the domain section:

```ini
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
id_provider = ldap
...
krb5_validate = True
```

The second step is to create a `host` principal on the KDC for this workstation. This is how the KDC’s authenticity is verified. It’s like a “machine account”, with a shared secret that the attacker cannot control and replicate in the rogue KDC. The `host` principal has the format `host/<fqdn>@REALM`.

After the host principal is created, its keytab needs to be stored on the workstation. This two step process can be easily done on the workstation itself via `kadmin` (not `kadmin.local`) to contact the KDC remotely:

```console
$ sudo kadmin -p ubuntu/admin
```

Then exit the tool and make sure the permissions on the keytab file are tight:

```console
$ sudo chmod 0600 /etc/krb5.keytab
```

```console
$ sudo chown root:root /etc/krb5.keytab
```

You can also do it on the KDC itself using `kadmin.local`, but you will have to store the keytab temporarily in another file and securely copy it over to the workstation.

Once these steps are complete, you can restart SSSD on the workstation and perform the login. If the rogue KDC notices the attempt and replies, it will fail the host verification. With debugging we can see this happening on the workstation:

```console
```

And the login is denied. If the real KDC picks it up, however, the host verification succeeds:

```console
```

And the login is accepted.

---

> 来源：https://ubuntu.com/server/docs/how-to/sssd/with-ldap-and-kerberos/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
