# Troubleshooting WireGuard VPN

The following general checklist should help as a first set of steps to try when you run into problems with WireGuard.

- **Verify public and private keys**: When dealing with multiple peers, it’s easy to mix these up, especially because the contents of these keys are just random data. There is nothing identifying them, and public and private keys are basically the same (format-wise).

- **Verify `AllowedIPs` list on all peers**.

- **Check with `ip route` and `ip addr show dev <wg-interface>`** if the routes and IPs are set as you expect.

- Double check that you have **`/proc/sys/net/ipv4/ip_forward` set to `1`** where needed.

- When injecting the VPN users into an existing network, without routing, make sure **`/proc/sys/net/ipv4/conf/all/proxy_arp` is set to `1`**.

- Make sure the above `/proc` entries are in **`/etc/sysctl.conf` or a file in `/etc/sysctl.d`** so that they persist reboots.

## The watch wg command

It can be helpful to leave a terminal open with the `watch wg` command. Here is a sample output showing a system with two peers configured, where only one has established the VPN so far:

```console
```

## Kernel debug messages

WireGuard is also rather silent when it comes to logging. Being (essentially) a kernel module, we need to explicitly enable verbose logging of its module.

> **Note**
>
> To be able to use the commands outlined below *[kernel_lockdown(7)](https://manpages.ubuntu.com/manpages/resolute/man7/kernel_lockdown.7.html)* needs to be disabled. That is because the debug interfaces used are considered a way to tamper with the integrity of the kernel.
>
> Lockdown is enabled by default in secure boot mode. Check the status via:
>
> ``` console
>
> $ cat /sys/kernel/security/lockdown
> ```
>
> Or that when disabled:
>
> ``` console
>
> $ cat /sys/kernel/security/lockdown
> ```
>
> To disable it either disable secure boot in [BIOS](../../reference/glossary.md#term-BIOS) or your virtualization platform.
>
> If that is impossible, consider not using the dynamic module debug control shown below, but instead using a kernel boot parameter `wireguard.dyndbg=+p` which has the drawback that it needs a reboot to enable/disable it.
>
> Before 20.04 [Kernel Lockdown](https://documentation.ubuntu.com/security/security-features/kernel-protections/#kernel-lockdown) was not yet present, therefore such systems can skip this step.

This is done with the following command:

```console
$ echo "module wireguard +p" | sudo tee /sys/kernel/debug/dynamic_debug/control
```

This will write WireGuard logging messages to the kernel log, which can be watched live with:

```console
$ sudo dmesg -wT
```

To disable logging, run this:

```console
$ echo "module wireguard -p" | sudo tee /sys/kernel/debug/dynamic_debug/control
```

## Destination address required

If you ping an IP …

```console
$ ping 10.10.11.2
```

… and get back an error like this:

```console
```

This is happening because the WireGuard interface selected for this destination doesn’t know the endpoint for it. In other words, it doesn’t know where to send the encrypted traffic.

One common scenario for this is on a peer where there is no `Endpoint` configuration, which is perfectly valid, and the host is trying to send traffic to that peer. Let’s take the coffee shop scenario we described earlier as an example.

The laptop is connected to the VPN and exchanging traffic as usual. Then it stops for a bit (the person went to get one more cup). Traffic ceases (WireGuard is silent, remember). If the WireGuard on the home router is now restarted, when it comes back up, it won’t know how to reach the laptop, because it was never contacted by it before. This means that at this time, if the home router tries to send traffic to the laptop in the coffee shop, it will get the above error.

Now the laptop user comes back, and generates some traffic to the home network (remember: the laptop has the home network’s `Endpoint` value). The VPN “wakes up”, data is exchanged, handshakes are completed, and now the home router knows the `Endpoint` associated with the laptop, and can again initiate new traffic to it without issues.

Another possibility is that one of the peers is behind a NAT, and there wasn’t enough traffic for the stateful firewall to consider the “connection” alive, and it dropped the NAT mapping it had. In this case, the peer might benefit from the `PersistentKeepalive` configuration, which makes WireGuard send a *keepalive* probe every so many seconds.

## Required key not available

This error:

```console
$ ping 10.10.11.1
```

Can happen when you have a route directing traffic to the WireGuard interface, but that interface does not have the target address listed in its `AllowedIPs` configuration.

If you have enabled kernel debugging for WireGuard, you will also see a message like this one in the [dmesg](../../reference/glossary.md#term-dmesg) output:

```console
```

---

> 来源：https://ubuntu.com/server/docs/how-to/wireguard-vpn/troubleshooting/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
