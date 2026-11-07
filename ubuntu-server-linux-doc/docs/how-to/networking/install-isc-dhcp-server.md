<a id="install-isc-dhcp-server"></a>

# How to install and configure isc-dhcp-server

> **Warning**
>
> The `isc-dhcp-server` package is deprecated and unsupported since Ubuntu 24.04 LTS. It is no longer supported by its vendor. Please use [Kea](https://www.isc.org/kea/) or [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) instead.

In this guide we show how to install and configure `isc-dhcp-server`, which installs the dynamic host configuration protocol daemon, [DHCPD](../../reference/glossary.md#term-DHCPD). For `isc-kea` instructions, [refer to this guide instead](install-isc-kea.md#install-isc-kea).

## Install isc-dhcp-server

At a terminal prompt, enter the following command to install `isc-dhcp-server`:

```console
$ sudo apt install isc-dhcp-server
```

> **Note**
>
> You can find diagnostic messages from `dhcpd` in `syslog`.

## Configure isc-dhcp-server

You will probably need to change the default configuration by editing `/etc/dhcp/dhcpd.conf` to suit your needs and particular configuration.

Most commonly, what you want to do is assign an IP address randomly. This can be done with `/etc/dhcp/dhcpd.conf` settings as follows:

```text
# minimal sample /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;

subnet 192.168.1.0 netmask 255.255.255.0 {
 range 192.168.1.150 192.168.1.200;
 option routers 192.168.1.254;
 option domain-name-servers 192.168.1.1, 192.168.1.2;
 option domain-name "mydomain.example";
}
```

This will result in the DHCP server giving clients an IP address from the range `192.168.1.150 - 192.168.1.200`. It will lease an IP address for 600 seconds if the client doesn’t ask for a specific time frame. Otherwise the maximum (allowed) lease will be 7200 seconds. The server will also “advise” the client to use `192.168.1.254` as the default-gateway and `192.168.1.1` and `192.168.1.2` as its [DNS](../../reference/glossary.md#term-DNS) servers.

You also may need to edit `/etc/default/isc-dhcp-server` to specify the interfaces `dhcpd` should listen to.

In the example below, `eth4` is used, but you should replace this with the appropriate interface for your system. The name of the network interface can vary depending on your setup. For instance, it could be `eth0`, `ens33`, or any other name depending on the device you’re using.

```text
INTERFACESv4="eth4"
```

After changing the config files you need to restart the `dhcpd` service:

```console
$ sudo systemctl restart isc-dhcp-server.service
```

## Further reading

- For more `/etc/dhcp/dhcpd.conf` options see the *[dhcpd.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/dhcpd.conf.5.html)* manual page

- [ISC dhcp-server](https://www.isc.org/dhcp/)

---

> 来源：https://ubuntu.com/server/docs/how-to/networking/install-isc-dhcp-server/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
