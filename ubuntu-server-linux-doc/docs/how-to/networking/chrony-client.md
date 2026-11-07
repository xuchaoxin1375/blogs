<a id="chrony-client"></a>

# Synchronize time using chrony

Ubuntu uses `chrony` for synchronizing time, which is installed by default as of Ubuntu 25.10. You can optionally use `timedatectl`/`timesyncd` to [synchronize time using systemd](timedatectl-and-timesyncd.md#timedatectl-and-timesyncd).

## Check status of `chrony` client

The current status of time synchronization can be checked with the `timedatectl status` command, which is available via `systemd` and will produce output like this:

```console
```

For more details on time accuracy, `chrony` can be queried directly, using the `chronyc -N tracking` command, producing output like this:

```console
```

### Network Time Security (NTS)

`chrony` supports “Network Time Security” (NTS) and enables it by default using the Ubuntu NTS pools. The Ubuntu pools are specified in the file `/etc/chrony/sources.d/ubuntu-ntp-pools.sources`. Here is the default configuration used by Ubuntu:

```text
pool 1.ntp.ubuntu.com iburst maxsources 1 nts prefer
pool 2.ntp.ubuntu.com iburst maxsources 1 nts prefer
pool 3.ntp.ubuntu.com iburst maxsources 1 nts prefer
pool 4.ntp.ubuntu.com iburst maxsources 1 nts prefer
pool ntp-bootstrap.ubuntu.com iburst maxsources 1 nts certset 1
```

The `nts` flag forces the use of `NTS`, and `prefer` marks that source as the preferred time source when selecting among multiple valid servers.

The line:

```text
pool ntp-bootstrap.ubuntu.com iburst maxsources 1 nts certset 1
```

adds the `ntp-bootstrap.ubuntu.com` source, which allows systems with a large clock offset to still securely adjust their clocks.

One important detail is the use of a private CA-signed certificate chain for the bootstrap server instead of a public CA-signed certificate like the one used for servers such as `1.ntp.ubuntu.com`.

The following command returns the certificate of the server `1.ntp.ubuntu.com`, and in that certificate we can see who issued it (the CA):

```console
$ openssl s_client -connect 1.ntp.ubuntu.com:4460 -servername 1.ntp.ubuntu.com
```

By contrast, the certificate of `ntp-bootstrap.ubuntu.com` is:

```console
```

This shows the issuer as `ubuntu`, which is not a publicly recognized Certificate Authority, unlike `Let's Encrypt`.

This certificate is shipped in the file `/etc/chrony/nts-bootstrap-ubuntu.crt`, and `chrony` is configured to trust it in `/etc/chrony/conf.d/ubuntu-nts.conf`:

```text
ntstrustedcerts 1 /etc/chrony/nts-bootstrap-ubuntu.crt
```

For **validation of NTS enablement**, one can list the time sources in use by executing the `chronyc -N sources` command, to find the timeserver in use, as indicated by the `^*` symbol in the first column. Then check the `authdata` of that connection using `sudo chronyc -N authdata`. If the client was able to successfully establish a NTS connection, it will show the `Mode: NTS` field and non-zero values for `KeyID`, `Type` and `KLen`:

```console
$ sudo chronyc -N authdata
```

### NTS related constraints

**Key Exchange port:** NTS/KE uses a separate port (4460/tcp)\*\* to negotiate security parameters, which are then used via the normal NTP port (123/udp). This is a new deployment, running on different IP addresses than the traditional Ubuntu NTP pool.

> **Warning**
>
> If the network does not allow access to the Ubuntu NTS servers and required ports, with the default configuration is in place, `chrony` will not be able to adjust the system’s clock. To revert to NTP, edit the configuration file in `/etc/chrony/sources.d/ubuntu-ntp-pools.sources` and revert to using the listed NTP servers in favor of the NTS ones.

**Bad Clocks and secure time syncing:** NTS is based on TLS, and TLS needs a reasonably correct clock. Due to that, an NTS-based sync might fail if the clock is too far off. On hardware affected by this problem, one can consider using the `nocerttimecheck` option, which allows to set the number of times that the time can be synced without checking validation and expiration.

> **Note**
>
> The certificate for `ntp-bootstrap.ubuntu.com` is installed in `/etc/chrony/nts-bootstrap-ubuntu.crt` and is used specifically for the Ubuntu NTS bootstrap server, needed for when the clock is too far off. This is added to certificate set ID “1”, and defined via `/etc/chrony/conf.d/ubuntu-nts.conf`.

## Configure chrony

An admin can control the timezone and how the system clock should relate to the `hwclock` using the common `timedatectl [set-timezone/set-local-rtc]` commands, provided by `systemd`. For more specific actions, like adding of time-sources, the `chronyc` command can be used. See `man chronyc` for more details.

One can edit configuration in `/etc/chrony/sources.d/` to add/remove server lines. By default these servers are configured:

```text
# Use NTS by default
# NTS uses an additional port to negotiate security: 4460/tcp
# The normal NTP port remains in use: 123/udp
pool 1.ntp.ubuntu.com iburst maxsources 1 nts prefer
pool 2.ntp.ubuntu.com iburst maxsources 1 nts prefer
pool 3.ntp.ubuntu.com iburst maxsources 1 nts prefer
pool 4.ntp.ubuntu.com iburst maxsources 1 nts prefer
# The bootstrap server is needed by systems without a hardware clock, or a very
# large initial clock offset. The specified certificate set is defined in
# /etc/chrony/conf.d/ubuntu-nts.conf.
pool ntp-bootstrap.ubuntu.com iburst maxsources 1 nts certset 1
```

After adding or removing sources, they can be reloaded using `sudo chronyc reload sources`.

Of the pool, `2.ubuntu.pool.ntp.org` and `ntp.ubuntu.com` also support IPv6, if needed. If you need to force IPv6, there is also `ipv6.ntp.ubuntu.com` which is not configured by default.

### Time sources provided by DHCP (option 42)

`chrony` consumes time sources provided by DHCP (option 42). Those could be traditional, non-authenticated NTP sources. Should one want to avoid this behavior, overruling the choices made by a local DHCP administrator, it can be disabled in `/etc/chrony/chrony.conf`. To do that one would comment out the corresponding setting:

```text
# Use time sources from DHCP.
# sourcedir /run/chrony-dhcp
```

### Chrony time-daemon

`chronyd` itself is a normal service, so you can check its status in more detail using:

```console
$ systemctl status chrony.service
```

Default configuration such as `sourcedir`, `ntsdumpdir` or `rtcsync` is provided in `/etc/chrony/chrony.conf` and additional config files can be stored in `/etc/chrony/conf.d/`. The NTS servers from which to fetch time for `chrony` are in defined in `/etc/chrony/sources.d/ubuntu-ntp-pools.sources`. There are more advanced options documented in the *[chrony.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/chrony.conf.5.html)* manual page. Common use cases are specifying an explicit trusted certificate. After changing any part of the config file you need to restart `chrony`, as follows:

```console
$ sudo systemctl restart chrony.service
```

## Next steps

If you would now like to also serve the Network Time Protocol via `chrony`, this guide will walk you through [how to configure your chrony setup](serve-ntp-with-chrony.md#serve-ntp-with-chrony).

## Further reading

- *[chronyc(1)](https://manpages.ubuntu.com/manpages/resolute/man1/chronyc.1.html)* manual page

- *[chronyd(8)](https://manpages.ubuntu.com/manpages/resolute/man8/chronyd.8.html)* manual page

- *[chrony.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/chrony.conf.5.html)* manual page

---

> 来源：https://ubuntu.com/server/docs/how-to/networking/chrony-client/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
