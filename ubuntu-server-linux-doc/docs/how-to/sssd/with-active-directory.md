<a id="sssd-with-active-directory"></a>

# How to set up SSSD with Active Directory

This section describes the use of SSSD to authenticate user logins against an Active Directory via using SSSD’s “ad” provider. At the end, Active Directory users will be able to log in on the host using their AD credentials. Group membership will also be maintained.

## Group Policies for Ubuntu

SSSD manages user authentication and sets initial security policies.

[ADSys](../../reference/glossary.md#term-ADSys) serves as a Group Policy client for Ubuntu, streamlining the configuration of Ubuntu systems within a Microsoft Active Directory environment. If you are interested in Group Policies support for Ubuntu, detailed information can be found in the [ADSys documentation](https://documentation.ubuntu.com/adsys/stable/).

## Prerequisites and assumptions

This guide does not explain Active Directory, how it works, how to set one up, or how to maintain it. It assumes that a working Active Directory domain is already configured and you have access to the credentials to join a machine to that domain.

- The domain controller is:

  - Acting as an authoritative [DNS](../../reference/glossary.md#term-DNS) server for the domain.

  - The primary DNS resolver (check with `resolvectl status`).

- System time is correct and in sync, maintained via a service like `chrony` or `ntp`.

- The domain used in this example is `ad1.example.com` .

## Install necessary software

Install the following packages:

```console
$ sudo apt install sssd-ad sssd-tools realmd adcli
```

## Join the domain

We will use the `realm` command, from the `realmd` package, to join the domain and create the SSSD configuration.

Let’s verify the domain is discoverable via DNS:

```console
$ sudo realm -v discover ad1.example.com
```

This performs several checks and determines the best software stack to use with SSSD. SSSD can install the missing packages via `packagekit`, but we already installed them in the previous step.

Now let’s join the domain:

```console
$ sudo realm join ad1.example.com
```

That was quite uneventful. If you want to see what it was doing, pass the `-v` option:

```console
$ sudo realm join -v ad1.example.com
```

By default, `realm` will use the “Administrator” account of the domain to request the join. If you need to use another account, pass it to the tool with the `-U` option.

Another popular way of joining a domain is using a One Time Password (OTP) token. For that, use the `--one-time-password` option.

## SSSD configuration

The `realm` tool already took care of creating an SSSD configuration, adding the PAM and NSS modules, and starting the necessary services.

Let’s take a look at `/etc/sssd/sssd.conf`:

```ini
[sssd]
domains = ad1.example.com
config_file_version = 2
services = nss, pam

[domain/ad1.example.com]
default_shell = /bin/bash
krb5_store_password_if_offline = True
cache_credentials = True
krb5_realm = AD1.EXAMPLE.COM
realmd_tags = manages-system joined-with-adcli
id_provider = ad
fallback_homedir = /home/%u@%d
ad_domain = ad1.example.com
use_fully_qualified_names = True
ldap_id_mapping = True
access_provider = ad
```

> **Note**
>
> Something very important to remember is that this file must have permissions `0600` and ownership `root:root`, or else SSSD won’t start!

> **Note**
>
> ``` text
> [FAILED] Failed to listen on sssd-nss.socket...
> [FAILED] Failed to listen on sssd-pam.socket...
> [FAILED] Dependency failed for sssd-pam-priv.socket...
> ```
>
> If you get those errors on startup, just remove the line `services = nss, pam`

Let’s highlight a few things from this config file:

- **`cache_credentials`**: This allows logins when the AD server is unreachable

- **`fallback_homedir`**: The home directory. By default, `/home/<user>@<domain>`. For example, the AD user *john* will have a home directory of */home/john@ad1.example.com*.

- **`use_fully_qualified_names`**: Users will be of the form `user@domain`, not just `user`. This should only be changed if you are certain no other domains will ever join the AD forest, via one of the several possible trust relationships.

## Automatic home directory creation

What the `realm` tool didn’t do for us is setup `pam_mkhomedir`, so that network users can get a home directory when they login. This remaining step can be done by running the following command:

```console
$ sudo pam-auth-update --enable mkhomedir
```

## Testing our setup

You should now be able to fetch information about AD users. In this example, `John Smith` is an AD user:

```console
$ getent passwd john@ad1.example.com
```

Let’s see his groups:

```console
$ groups john@ad1.example.com
```

> **Note**
>
> If you just changed the group membership of a user, it may be a while before SSSD notices due to caching.

Finally, how about we try a login:

```console
$ sudo login
```

Notice how the home directory was automatically created.

You can also use SSH, but note that the command will look a bit funny because of the multiple `@` signs:

```console
$ ssh john@ad1.example.com@10.51.0.11
```

> **Note**
>
> In the SSH example, public key authentication was used, so no password was required. Remember that SSH password authentication is disabled by default in `/etc/ssh/sshd_config`.

## Kerberos tickets

If you install `krb5-user`, your AD users will also get a Kerberos ticket upon logging in:

```console
john@ad1.example.com@ad-client:~$ klist
```

> **Note**
>
> `realm` also configured `/etc/krb5.conf` for you, so there should be no further configuration prompts when installing `krb5-user`.

Let’s test with `smbclient` using Kerberos authentication to list the shares of the domain controller:

```console
john@ad1.example.com@ad-client:~$ smbclient -k -L server1.ad1.example.com
```

Notice how we now have a ticket for the `cifs` service, which was used for the share list above:

```console
john@ad1.example.com@ad-client:~$ klist
```

## Ubuntu Desktop authentication

The desktop login only shows local users in the list to pick from, and that’s on purpose.

To login with an Active Directory user for the first time, follow these steps:

- Click on the “Not listed?” option:

![Click "not listed"\|690x517,50%](../../../_assets/291d9ae9-not_listed.png)

- Type in the login name followed by the password:

![Type in username\|690x517,50%](../../../_assets/6940e589-login.png)

- Next time you login, the AD user will be listed as if it was a local user:

![Next time\|690x517,50%](../../../_assets/9c174441-local_user.png)

## Known issues

When logging in on a system joined with an Active Directory domain, `sssd` (the package responsible for this integration) will try to apply Group Policies by default. There are cases where if a specific policy is missing, the login will be denied.

This is being tracked in [LP: \#1934997](https://bugs.launchpad.net/bugs/1934997). Until the fix becomes available, please see comment number 5 in that bug report for existing workarounds.

## Further reading

- [GitHub SSSD Project](https://github.com/SSSD/sssd)

- [Active Directory DNS Zone Entries](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc759550(v=ws.10)?redirectedfrom=MSDN)

---

> 来源：https://ubuntu.com/server/docs/how-to/sssd/with-active-directory/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
