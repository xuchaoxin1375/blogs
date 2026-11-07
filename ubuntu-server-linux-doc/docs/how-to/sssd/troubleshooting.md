# Troubleshooting SSSD

Here are some tips to help troubleshoot SSSD.

## `debug_level`

The debug level of SSSD can be changed on-the-fly via `sssctl`, from the `sssd-tools` package:

```console
$ sudo apt install sssd-tools
```

```console
$ sssctl debug-level <new-level>
```

Or add it to the config file and restart SSSD:

```ini
[sssd]
config_file_version = 2
domains = example.com

[domain/example.com]
debug_level = 6
...
```

Either approach will yield more logs in `/var/log/sssd/*.log` and can help identify what is happening. The `sssctl` approach has the clear advantage of not having to restart the service.

## Caching

Caching is useful to speed things up, but it can get in the way big time when troubleshooting. It’s useful to be able to remove the cache while chasing down a problem. This can also be done with the `sssctl` tool from the `sssd-tools` package.

You can either remove the whole cache:

```console
$ sssctl cache-remove
```

Or just one element:

```console
$ sssctl cache-expire -u john
```

Or expire everything:

```console
$ sssctl cache-expire -E
```

## DNS

Kerberos is quite sensitive to [DNS](../../reference/glossary.md#term-DNS) issues. If you suspect something related to DNS, here are two suggestions:

### FQDN hostname

Make sure `hostname -f` returns a [fully qualified domain name (FQDN)](../../reference/glossary.md#term-FQDN). Set it in `/etc/hostname` if necessary, and use `sudo hostnamectl set-hostname <fqdn>` to set it at runtime.

### Reverse name lookup

You can try disabling a default reverse name lookup, which the `krb5` libraries do, by editing (or creating) `/etc/krb5.conf` and setting `rdns = false` in the `[libdefaults]` section:

```ini
[libdefaults]
rdns = false
```

---

> 来源：https://ubuntu.com/server/docs/how-to/sssd/troubleshooting/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
