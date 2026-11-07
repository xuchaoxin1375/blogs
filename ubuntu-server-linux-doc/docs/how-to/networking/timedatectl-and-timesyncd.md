<a id="timedatectl-and-timesyncd"></a>

# Synchronize time using timedatectl and timesyncd

Ubuntu can use `timedatectl` and `timesyncd` for synchronizing time, which can be installed as follows. `systemd-timesyncd` used to be part of the default installation, but was replaced by `chrony` since Ubuntu 25.10. You can optionally use `chrony` as a [Network Time Security (NTS) client](chrony-client.md#chrony-client) or to [serve the Network Time Protocol](serve-ntp-with-chrony.md#serve-ntp-with-chrony).

```console
$ sudo apt-mark auto chrony && apt install systemd-timesyncd
```

In this guide, we will show you how to configure these services.

> **Note**
>
> If `chrony` is installed, `timedatectl` steps back to let `chrony` handle timekeeping. This ensures that no two time-syncing services will be in conflict.

## Check status of `timedatectl`

The current status of time and time configuration via `timedatectl` and `timesyncd` can be checked with the `timedatectl status` command, which will produce output like this:

```console
```

If `chrony` is running, it will automatically switch to:

```console
```

### Configure `timedatectl`

By using `timedatectl`, an admin can control the timezone, how the system clock should relate to the `hwclock` and whether permanent synchronization should be enabled. See `man timedatectl` for more details.

## Check status of `timesyncd`

`timesyncd` itself is a normal service, so you can check its status in more detail using:

```console
$ systemctl status systemd-timesyncd
```

### Configure `timesyncd`

The server from which to fetch time for `timedatectl` and `timesyncd` can be specified in `/etc/systemd/timesyncd.conf`. Additional config files can be stored in `/etc/systemd/timesyncd.conf.d/`. The entries for `NTP=` and `FallbackNTP=` are space-separated lists. See `man timesyncd.conf` for more details.

## Next steps

If you would now like to serve the Network Time Protocol via `chrony`, this guide will walk you through [how to install and configure your setup](serve-ntp-with-chrony.md#serve-ntp-with-chrony).

## Further reading

- *[timedatectl(1)](https://manpages.ubuntu.com/manpages/resolute/man1/timedatectl.1.html)*

- *[systemd-timesyncd.service(8)](https://manpages.ubuntu.com/manpages/resolute/man8/systemd-timesyncd.service.8.html)*

- See the [Ubuntu Time wiki page](https://help.ubuntu.com/community/UbuntuTime) for more information.

---

> 来源：https://ubuntu.com/server/docs/how-to/networking/timedatectl-and-timesyncd/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
