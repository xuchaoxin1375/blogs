<a id="serve-ntp-with-chrony"></a>

# How to serve the Network Time Protocol with Chrony

As of Ubuntu 25.10 `chrony` is installed by default, [functioning as a client](chrony-client.md#chrony-client) and keeping your time in sync. However, if you also want to serve NTP information then you need an NTP server.

Between `chrony`, the now-deprecated `ntpd`, and `open-ntp`, there are plenty of options. The solution we recommend is `chrony`.

The NTP daemon `chronyd` calculates the drift and offset of your system clock and continuously adjusts it, so there are no large corrections that could lead to inconsistent logs, for instance. The cost is a little processing power and memory, but for a modern server this is usually negligible.

## Install `chronyd`

To install `chrony`, run the following command from a terminal prompt:

```console
$ sudo apt install chrony
```

This will provide two binaries:

- `chronyd` - the actual daemon to sync and serve via the Network Time Protocol

- `chronyc` - command-line interface for the `chrony` daemon

## Enable serving the Network Time Protocol

You can install `chrony` (above) and configure special Hardware (below) for a local synchronization and as-installed that is the default to stay on the secure and conservative side. But if you want to *serve* NTP you need adapt your configuration.

To enable serving NTP you’ll need to at least set the `allow` rule. This controls which clients/networks you want `chrony` to serve NTP to. An example would be:

```text
allow 1.2.3.4
```

See the section “NTP server” in the *[chrony.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/chrony.conf.5.html)* manual page for more details on how you can control and restrict access to your NTP server.

## View `chrony` status

You can use `chronyc` to see query the status of the `chrony` daemon. For example, to get an overview of the currently available and selected time sources, run `chronyc sources`, which provides output like this:

```console
```

You can also make use of the `chronyc sourcestats` command, which produces output like this:

```console
```

Certain `chronyc` commands are privileged and cannot be run via the network without explicitly allowing them. See the **Command and monitoring access** section in `man chrony.conf` for more details. A local admin can use `sudo` since this will grant access to the local admin socket `/var/run/chrony/chronyd.sock`.

## Pulse-Per-Second (PPS) support

`Chrony` supports various PPS types natively. It can use kernel PPS API as well as Precision Time Protocol (PTP) hardware clocks. Most general GPS receivers can be leveraged via [GPSD](../../reference/glossary.md#term-GPSD). The latter (and potentially more) can be accessed via **SHM** or via a **socket** (recommended). All of the above can be used to augment `chrony` with additional high quality time sources for better accuracy, [jitter](../../reference/glossary.md#term-jitter), drift, and longer- or shorter-term accuracy. Usually, each kind of clock type is good at one of those, but non-perfect at the others. For more details on configuration see some of the external PPS/GPSD resources listed below.

### Example configuration for GPSD to feed `chrony`

For the installation and setup you will first need to run the following command in your terminal window:

```console
$ sudo apt install gpsd chrony
```

However, since you will want to test/debug your setup (especially the GPS reception), you should also install:

```console
$ sudo apt install pps-tools gpsd-clients
```

GPS devices usually communicate via serial interfaces. The most common type these days are USB GPS devices, which have a serial converter behind USB. If you want to use one of these devices for PPS then please be aware that the majority do not signal PPS via USB. Check the [GPSD hardware](https://gpsd.gitlab.io/gpsd/hardware.html) list for details. The examples below were run with a Navisys GR701-W.

When plugging in such a device (or at boot time) [dmesg](../../reference/glossary.md#term-dmesg) should report a serial connection of some sort, as in this example:

```console
```

We see in this example that the device appeared as `ttyUSB0`. So that `chrony` later accepts being fed time information by this device, we have to set it up in `/etc/chrony/chrony.conf` (please replace `USB0` with whatever applies to your setup):

```text
refclock SHM 0 refid GPS precision 1e-1 offset 0.9999 delay 0.2
refclock SOCK /var/run/chrony.ttyUSB0.sock refid PPS
```

Next, we need to restart `chrony` to make the socket available and have it waiting.

```console
$ sudo systemctl restart chrony
```

We then need to tell `gpsd` which device to manage. Therefore, in `/etc/default/gpsd` we set:

```text
DEVICES="/dev/ttyUSB0"
```

It should be noted that since the *default* use-case of `gpsd` is, well, for *gps position tracking*, it will normally not consume any CPU since it is just waiting on a **socket** for clients. Furthermore, the client will tell `gpsd` what it requests, and `gpsd` will only provide what is asked for.

For the use case of `gpsd` as a PPS-providing-daemon, you want to set the option to:

- Immediately start (even without a client connected). This can be set in `GPSD_OPTIONS` of `/etc/default/gpsd`:

  - `GPSD_OPTIONS="-n"`

- Enable the service itself and not wait for a client to reach the socket in the future:

  - `sudo systemctl enable /lib/systemd/system/gpsd.service`

Restarting `gpsd` will now initialize the PPS from GPS and in `dmesg` you will see:

```console
```

If you have multiple PPS sources, the tool `ppsfind` may be useful to help identify which PPS belongs to which GPS. In our example, the command `sudo ppsfind /dev/ttyUSB0` would return the following:

```console
```

Now we have completed the basic setup. To proceed, we now need our GPS to get a lock. Tools like `cgps` or `gpsmon` need to report a 3D “fix” in order to provide accurate data. Let’s run the command `cgps`, which in our case returns:

```console
```

You would then want to use `ppstest` in order to check that you are really receiving PPS data. So, let us run the command `sudo ppstest /dev/pps0`, which will produce an output like this:

```console
```

Ok, `gpsd` is now running, the GPS reception has found a fix, and it has fed this into `chrony`. Let’s check on that from the point of view of `chrony`.

Initially, before `gpsd` has started or before it has a lock, these sources will be new and “untrusted” - they will be marked with a “?” as shown in the example below. If your devices remain in the “?” state (even after some time) then `gpsd` is not feeding any data to `chrony` and you will need to debug why.

```console
```

Over time, `chrony` will classify all of the unknown sources as “good” or “bad”. In the example below, the raw GPS had too much deviation (+- 200ms) but the PPS is good (+- 63us).

```console
```

Finally, after a while it used the hardware PPS input (as it was better):

```console
```

The PPS might also be OK – but used in a combined way with the selected server, for example. See `man chronyc` for more details about how these combinations can look:

```console
```

If you’re wondering if your SHM-based GPS data is any good, you can check on that as well. `chrony` will not only tell you if the data is classified as good or bad – using `sourcestats` you can also check the details:

```console
```

You can also track the raw data that `gpsd` or other `ntpd`-compliant reference clocks are sending via shared memory by using `ntpshmmon`. Let us run the command `sudo ntpshmmon -o`, which should provide the following output:

```console
$ sudo ntpshmmon -o
```

## NTS Support

In Chrony 4.0 (which first appeared in Ubuntu 21.04 Hirsute) support for [Network Time Security “NTS”](https://web.archive.org/web/20241130024605/http://networktimesecurity.org/) was added.

### NTS server

To set up your server with NTS you’ll need certificates so that the server can authenticate itself and, based on that, allow the encryption and verification of NTP traffic.

In addition to the `allow` statement that any `chrony` (while working as an NTP server) needs there are two mandatory config entries that will be needed. Example certificates for those entries would look like:

```text
ntsservercert /etc/chrony/fullchain.pem
ntsserverkey /etc/chrony/privkey.pem
```

It is important to note that for isolation reasons `chrony`, by default, runs as user and group `_chrony`. Therefore you need to grant access to the certificates for that user, by running the following command:.

```console
$ sudo chown _chrony:_chrony /etc/chrony/*.pem
```

Then restart `chrony` with `systemctl restart chrony` and it will be ready to provide NTS-based time services.

A running `chrony` server measures various statistics. One of them counts the number of NTS connections that were established (or dropped) – we can check this by running `sudo chronyc -N serverstats`, which shows us the statistics:

```console
$ sudo chronyc -N serverstats
```

There is also a per-client statistic which can be enabled by the `-p` option of the `clients` command.

```console
$ sudo chronyc -N clients -k
```

For more complex scenarios there are many more advanced options for configuring NTS. These are documented in the *[chrony.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/chrony.conf.5.html)* manual page.

> **About certificate placement**
>
> `chrony`, by default, is isolated via AppArmor and uses a number of `protect*` features of `systemd`. Due to that, there are not many paths `chrony` can access for the certificates. But `/etc/chrony/*` is allowed as read-only and that is enough. Check `/etc/apparmor.d/usr.sbin.chronyd` if you want other paths or allow custom paths in `/etc/apparmor.d/local/usr.sbin.chronyd`.

## Further reading

- [`chrony` FAQ](https://chrony-project.org/faq.html)

- [ntp.org: home of the Network Time Protocol project](http://www.ntp.org/)

- [pool.ntp.org: project of virtual cluster of timeservers](https://www.ntppool.org/en/)

- [Freedesktop.org info on `timedatectl`](https://www.freedesktop.org/software/systemd/man/latest/timedatectl.html)

- [Freedesktop.org info on systemd-timesyncd service](https://www.freedesktop.org/software/systemd/man/latest/systemd-timesyncd.service.html)

- [Feeding `chrony` from GPSD](https://gpsd.gitlab.io/gpsd/gpsd-time-service-howto.html#_feeding_chrony_from_gpsd)

- See the [Ubuntu Time](https://help.ubuntu.com/community/UbuntuTime) wiki page for more information.

---

> 来源：https://ubuntu.com/server/docs/how-to/networking/serve-ntp-with-chrony/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
