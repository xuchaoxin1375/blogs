<a id="openssh-gssapi"></a>

# OpenSSH with GSSAPI/Kerberos authentication

OpenSSH can be configured to use [GSSAPI](../../reference/glossary.md#term-GSSAPI)/[Kerberos](../../reference/glossary.md#term-Kerberos) authentication, which allows users to authenticate using their Kerberos tickets. This is particularly useful in environments where Kerberos is already in use, such as in many enterprise networks.

This guide assumes you have a working Kerberos realm, and does not cover setting one up. For background on Kerberos concepts, see [Introduction to Kerberos](../../explanation/intro-to/kerberos.md#introduction-to-kerberos); to deploy a realm on Ubuntu, see [the Kerberos how-to guides](../kerberos.md#how-to-kerberos).

## Which OpenSSH package to use

The packages to install depend on the Ubuntu release in use:

**\[Ubuntu Resolute 26.04 LTS and earlier\]**

The GSSAPI/Kerberos support is included in the main OpenSSH packages:

- `openssh-server` on the server

- `openssh-client` on the client

**\[Ubuntu Stonking 26.10 and later\]**

The GSSAPI/Kerberos support is split into separate packages, so use these:

- `openssh-server-gssapi` on the server

- `openssh-client-gssapi` on the client

To connect to a remote host using GSSAPI/Kerberos authentication, both the client and the server need to support it.

## Configure OpenSSH on the server

GSSAPI/Kerberos support is available on the server, but not enabled by default. To enable it, create a configuration file in `/etc/ssh/sshd_config.d/`, for example `/etc/ssh/sshd_config.d/gssapi.conf`, with the following line:

```text
GSSAPIAuthentication yes
```

For more information about configuration snippets, see [Configure OpenSSH](openssh-server.md#openssh-server-configure). The *[sshd_config(5)](https://manpages.ubuntu.com/manpages/resolute/man5/sshd_config.5.html)* manual page covers other GSSAPI/Kerberos configuration options.

Restart the OpenSSH server to apply the changes:

```console
$ sudo systemctl restart ssh.service
```

In order to participate in a Kerberos realm, the OpenSSH server needs to have a so-called service principal in the Kerberos database. The service principal for OpenSSH is of the form `host/<hostname>@<REALM>`, where `<hostname>` is the fully qualified domain name of the server and `<REALM>` is the Kerberos realm.

The service principal needs to be created in the Kerberos database and a keytab file needs to be generated for it. The keytab file should be placed in `/etc/krb5.keytab` on the OpenSSH server.

> **Note**
>
> For more information on service principals, consult [Kerberos service principals](../kerberos/configure-service-principals.md#configure-service-principals).

To create the service principal and extract its key into the keytab, use the *[kadmin(1)](https://manpages.ubuntu.com/manpages/resolute/man1/kadmin.mit.1.html)* tool on the OpenSSH server. You need a principal with administrative privileges in the Kerberos realm for this. The `kadmin` tool is in the `krb5-user` package:

```console
$ sudo apt install krb5-user
```

During installation, it will ask you for the Kerberos realm, and the KDC (Key Distribution Center) and Admin server hostnames. This guide uses the `EXAMPLE.COM` realm, and `server.example.com` as the hostname of the OpenSSH server.

Create the service principal, and extract its key into `/etc/krb5.keytab`. Run `kadmin` with `sudo`, because writing to `/etc/krb5.keytab` requires root privileges. Each command asks for the password of the administrative principal:

```console
$ sudo kadmin -p ubuntu/admin@EXAMPLE.COM -q "addprinc -randkey host/server.example.com@EXAMPLE.COM"
```

```console
$ sudo kadmin -p ubuntu/admin@EXAMPLE.COM -q "ktadd host/server.example.com@EXAMPLE.COM"
```

> **Note**
>
> `user/admin` is normally how administrative principals are named. You would have the normal `user@REALM` principal for everyday tasks, and the admin “instance” (denoted by `/admin`) is recognized as having extra privileges. See [Configure the Kerberos server](../kerberos/install-a-kerberos-server.md#install-a-kerberos-server-configure) for more information.

The contents of the keytab can be verified with the *[klist(1)](https://manpages.ubuntu.com/manpages/resolute/man1/klist.mit.1.html)* command:

```console
$ sudo klist -ke
```

The server is now ready to accept GSSAPI/Kerberos authentication from clients that have valid Kerberos tickets.

## Configure OpenSSH on the client

In Ubuntu, the `openssh-client` (or `openssh-client-gssapi`) package already defaults to allowing GSSAPI/Kerberos authentication, so no additional configuration is needed on the client side. However, you may want to verify that the following line is present in `/etc/ssh/ssh_config`, or in a configuration file in `/etc/ssh/ssh_config.d/`:

```text
GSSAPIAuthentication yes
```

This can also be configured on a per-user and per-target-host basis in `~/.ssh/config`.

Like with the server options, there are multiple configuration options related to GSSAPI/Kerberos for the client. Consult the *[ssh_config(5)](https://manpages.ubuntu.com/manpages/resolute/man5/ssh_config.5.html)* manual page for more information.

Since the client needs to have a valid Kerberos ticket in order to authenticate with GSSAPI/Kerberos, you will need to obtain a ticket with *[kinit(1)](https://manpages.ubuntu.com/manpages/resolute/man1/kinit.mit.1.html)* before connecting to the server. Install the `krb5-user` package on the client, answering the same questions as on the server:

```console
$ sudo apt install krb5-user
```

> **Note**
>
> Some Ubuntu deployments may be configured to obtain a Kerberos ticket automatically at login, in which case you may not need to run `kinit` manually. But it’s still useful to have the `krb5-user` package installed, as it provides the `klist` command to verify that you have a valid ticket.

First obtain the [TGT](../../reference/glossary.md#term-TGT) (Ticket Granting Ticket) for your user principal, if you don’t have it already. This example uses an `ubuntu` principal:

```console
ubuntu@client:~$ kinit
```

Confirm you have the TGT:

```console
ubuntu@client:~$ klist
```

And now ssh to the GSSAPI/Kerberos-enabled OpenSSH server:

```console
ubuntu@client:~$ ssh server.example.com
```

The server administrator can check the `/var/log/auth.log` file to verify that the user authenticated with GSSAPI/Kerberos:

```text
sshd-session[954]: Accepted gssapi-with-mic for ubuntu from 10.0.10.157 port 55992 ssh2: ubuntu@EXAMPLE.COM
```

If you log out and run `klist` on the client, you will see that you now have a service ticket for the OpenSSH server:

```console
ubuntu@client:~$ klist
```

## Forwarding Kerberos tickets

It is possible to forward a Kerberos ticket to the remote server when logging in via SSH. This allows the user to use their Kerberos credentials on the remote server, for example to access other services that require Kerberos authentication.

This is controlled by the client option called `GSSAPIDelegateCredentials`. To enable it, add the following line to your `~/.ssh/config` file, or have an administrator add it to the system-wide `/etc/ssh/ssh_config` file:

```text
GSSAPIDelegateCredentials yes
```

With this in place, the next time you ssh into the server, you will notice that you also have a Kerberos ticket there:

```console
ubuntu@client:~$ ssh server.example.com
```

```console
ubuntu@server:~$ klist
```

> **Note**
>
> Tickets can only be forwarded if allowed by the Kerberos server. That is the default, but it may be disallowed in your realm. You can check if your ticket is forwardable by running `klist -f` on the client. It should have the “`F`” flag set if it’s forwardable.

The ticket cache file on the server is again created in `/tmp` by default, but this time with an extra random suffix appended to the filename to avoid collisions if the same user forwards another ticket from another client.

### Ticket cache location

The ccache type and location are normally controlled by the `default_ccache_name` option in the `[libdefaults]` section of `/etc/krb5.conf` (see *[krb5.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/krb5.conf.5.html)*). This option is read by the Kerberos library, and is treated as a library-provided default for tools linked with it.

For example, to store tickets in the kernel keyring instead of a file in `/tmp`, add or edit the following line in `/etc/krb5.conf` on the client:

```text
default_ccache_name = KEYRING:persistent:%{uid}
```

Running `kinit` and then `klist` on the client confirms the change:

```console
ubuntu@client:~$ kinit
```

```console
ubuntu@client:~$ klist
```

For forwarded tickets, it’s the OpenSSH server that creates the ccache, not `kinit`, and the `/etc/krb5.conf` that matters is the one on the server. The same setting on the server doesn’t always take effect, though: it depends on the Ubuntu release the server is running.

OpenSSH in Ubuntu Resolute 26.04 LTS and earlier ignores the `default_ccache_name` setting in `/etc/krb5.conf` on the server, so the forwarded ticket will still be stored in `/tmp` with a random suffix.

But starting with Ubuntu Stonking 26.10, the OpenSSH server will follow the `default_ccache_name` setting in `/etc/krb5.conf` on the server by default for forwarded tickets. This OpenSSH behavior is controlled by the `KerberosUniqueCCache` option in `/etc/ssh/sshd_config`. If this option is set to `no` (the default), the server will use the `default_ccache_name` setting in `/etc/krb5.conf` to determine the location and type of the ticket cache for forwarded tickets. If it is changed to `yes`, the server will always use `/tmp` with a random suffix as in previous Ubuntu releases.

If there is no `default_ccache_name` setting in `/etc/krb5.conf` on the server, the behavior is unchanged from Ubuntu Resolute 26.04 LTS and earlier.

The following table summarizes where the OpenSSH server stores forwarded tickets:

| Ubuntu release | `default_ccache_name` on the server | `KerberosUniqueCCache` on the server | Forwarded ticket ccache |
|----|----|----|----|
| ≤ 26.04 LTS | Ignored by OpenSSH | Not available | `FILE:/tmp/krb5cc_<uid>_<random>` |
| ≥ 26.10 | Not set | `no` (default) or `yes` | `FILE:/tmp/krb5cc_<uid>_<random>` |
| ≥ 26.10 | Set | `yes` | `FILE:/tmp/krb5cc_<uid>_<random>` |
| ≥ 26.10 | Set | `no` (default) | As specified by `default_ccache_name` |

Here is an example forwarding a Kerberos ticket to an Ubuntu Stonking 26.10 server with the `default_ccache_name` set to `KEYRING:persistent:%{uid}` in `/etc/krb5.conf` on the server:

```console
ubuntu@client:~$ ssh stonking-server.example.com
```

```console
ubuntu@stonking-server:~$ klist
```

```console
ubuntu@stonking-server:~$ grep default_ccache_name /etc/krb5.conf
```

## See also

- [Introduction to Kerberos](../../explanation/intro-to/kerberos.md#introduction-to-kerberos)

- [How to deploy Kerberos on Ubuntu](../kerberos.md#how-to-kerberos)

- [Configuring Kerberos service principals](../kerberos/configure-service-principals.md#configure-service-principals)

---

> 来源：https://ubuntu.com/server/docs/how-to/security/openssh-gssapi/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
