<a id="basic-workstation-authentication"></a>

# How to set up basic workstation authentication

In this section we’ll look at configuring a Linux system as a Kerberos client. This will allow access to any “Kerber-ised” services once a user has successfully logged into the system.

Note that Kerberos alone is not enough for a user to exist in a Linux system. We cannot just point the system at a Kerberos server and expect all the Kerberos principals to be able to *log in* on the Linux system, simply because these users do not *exist* locally.

Kerberos only provides authentication: it doesn’t know about user groups, Linux [UIDs](../../reference/glossary.md#term-UID) and [GIDs](../../reference/glossary.md#term-GID), home directories, etc. Normally, another network source is used for this information, such as an LDAP or Windows server, and, in the old days, NIS was used for that as well.

## Set up a Linux system as a Kerberos client

If you have local users matching the principals in a Kerberos realm, and just want to switch the authentication from local to remote using Kerberos, you can follow this section. This is not a very usual scenario, but serves to highlight the separation between user authentication and user information (full name, UID, GID, home directory, groups, etc). If you just want to be able to grab tickets and use them, it’s enough to install `krb5-user` and run `kinit`.

We are going to use `sssd` with a trick so that it will fetch the user information from the local system files, instead of a remote source which is the more common case.

### Install the required packages

To install the packages enter the following in a terminal prompt:

```console
$ sudo apt install krb5-user sssd-krb5
```

You will be prompted for the addresses of your KDCs and admin servers. If you have followed our [how to install a Kerberos server](install-a-kerberos-server.md#install-a-kerberos-server) and [how to set up a secondary KDC](set-up-secondary-kdc.md#set-up-secondary-kdc) guides, the KDCs will be (space separated):

```text
kdc01.example.com kdc02.example.com
```

And the admin server will be:

```text
kdc01.example.com
```

Remember that `kdc02` is a read-only copy of the primary KDC, so it doesn’t run an admin server.

> **Note**
>
> If you have added the appropriate SRV records to [DNS](../../reference/glossary.md#term-DNS), none of those prompts will need answering.

### Configure Kerberos

If you missed the questions earlier, you can reconfigure the package to fill them in again:

```console
$ sudo dpkg-reconfigure krb5-config
```

You can test the Kerberos configuration by requesting a ticket using the `kinit` utility. For example:

```console
$ kinit ubuntu
```

Note that `kinit` doesn’t need the principal to exist as a local user in the system. In fact, you can `kinit` any principal you want. If you don’t specify one, then the tool will use the username of whoever is running `kinit`.

### Configure `sssd`

The only remaining configuration now is for `sssd`. Create the file `/etc/sssd/sssd.conf` with the following content:

```ini
[sssd]
config_file_version = 2
domains = example.com

[pam]

[domain/example.com]
id_provider = proxy
proxy_lib_name = files
auth_provider = krb5
krb5_server = kdc01.example.com,kdc02.example.com
krb5_kpasswd = kdc01.example.com
krb5_realm = EXAMPLE.COM
```

The above configuration will use Kerberos for **authentication** (`auth_provider`), but will use the local system users for user and group information (`id_provider`).

Adjust the permissions of the config file and start `sssd`:

```console
$ sudo chown root:root /etc/sssd/sssd.conf
```

```console
$ sudo chmod 0600 /etc/sssd/sssd.conf
```

```console
$ sudo systemctl start sssd
```

Just by having installed `sssd` and its dependencies, PAM will already have been configured to use `sssd`, with a [fallback](../../reference/glossary.md#term-fallbacks) to local user authentication. To try it out, if this is a workstation, simply switch users (in the GUI), or open a login terminal (<span class="kbd">Ctrl</span>-<span class="kbd">Alt</span>-<span class="kbd">number</span>), or spawn a login shell with `sudo login`, and try logging in using the name of a Kerberos principal. Remember that this user must already exist on the local system:

```console
$ sudo login
```

You will have a Kerberos ticket already right after login.

---

> 来源：https://ubuntu.com/server/docs/how-to/kerberos/basic-workstation-authentication/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
