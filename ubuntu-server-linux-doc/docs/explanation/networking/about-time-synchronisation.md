<a id="about-time-synchronisation"></a>

# About time synchronization

Network Time Protocol (NTP) is a networking protocol for synchronizing time over a network. Basically, a client requests the current time from a server, and uses it to set its own clock.

Behind this simple description, there is a lot of complexity. There are three tiers of NTP servers; tier one NTP servers are connected to atomic clocks, while tier two and tier three three servers spread the load of actually handling requests across the Internet.

The client software is also a lot more complex than you might expect. It must factor in communication delays and adjust the time in a way that does not upset all the other processes that run on the server. Luckily, all that complexity is hidden from you!

Since Ubuntu 25.10 `chrony` is used to synchronize time by default. See our guides, if you would like to know how to [synchronize time with chrony](../../how-to/networking/chrony-client.md#chrony-client) or [use chrony to serve NTP](../../how-to/networking/serve-ntp-with-chrony.md#serve-ntp-with-chrony).

Users can optionally use [timedatectl and timesyncd](../../how-to/networking/timedatectl-and-timesyncd.md#timedatectl-and-timesyncd).

> **Note**
>
> Chrony is replacing `systemd-timesyncd` as the default in Ubuntu 25.10 and `ntpdate`/`ntpd`, which was the default before Ubuntu 18.04 LTS.
>
> On upgraded systems (from Ubuntu 25.04 or below) `systemd-timesyncd` might still be the active time-daemon and thus render the new `chrony` service disabled. Similarly, while the use of `ntpd` is no longer recommended, it might still be installed to retain any previous behavior/config on upgrades (up to Ubuntu 22.04 LTS).

## How time synchronization works

### About `chrony`

`chrony` replaces not only `ntpdate`, but also the Simple Network Time Protocol (SNTP) client of `timesyncd`, still allowing for basic usage of systemd’s `timedatectl`. So, on top of the one-shot action that `ntpdate` provided on boot and network activation, `chrony` now regularly checks and keeps your local time in sync. It also stores time updates locally, so that after reboots the time monotonically advances (if applicable).

### About `timedatectl`

If `chrony` is installed, `timedatectl` can still be used to configure basic settings, such as the timezone. But more complex configuration needs to be set up using the `chronyc` command. This ensures that no two time-syncing services can conflict with each other.

`chrony` will generally keep your time in sync and can be set up as a time server, `timesyncd` can help with simpler cases. But if you had one of a few known special `ntpdate` use cases, consider the following:

- If you require a one-shot sync, use: `chronyd -q`

- If you require a one-shot time check (without setting the time), use: `chronyd -Q`

## Further reading

- [ntp.org: home of the Network Time Protocol project](http://www.ntp.org/)

- [pool.ntp.org: project of virtual cluster of timeservers](https://www.ntppool.org/en/)

- *[timedatectl(1)](https://manpages.ubuntu.com/manpages/resolute/man1/timedatectl.1.html)*

- *[systemd-timesyncd.service(8)](https://manpages.ubuntu.com/manpages/resolute/man8/systemd-timesyncd.service.8.html)*

- [`chrony` FAQ](https://chrony-project.org/faq.html)

- [Feeding `chrony` from GPSD](https://gpsd.gitlab.io/gpsd/gpsd-time-service-howto.html#_feeding_chrony_from_gpsd)

- Also see the [Ubuntu Time wiki page](https://help.ubuntu.com/community/UbuntuTime) for more information.

---

> 来源：https://ubuntu.com/server/docs/explanation/networking/about-time-synchronisation/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
