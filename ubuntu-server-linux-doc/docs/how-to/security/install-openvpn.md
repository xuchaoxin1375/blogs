<a id="install-openvpn"></a>

# How to install and use OpenVPN

OpenVPN is a flexible, reliable and secure Virtual Private Networking (VPN) solution. It belongs to the family of SSL/TLS VPN stacks (different from IPsec VPNs). This chapter will show how to install and configure OpenVPN to create a VPN.

## Install the server

To install OpenVPN, run the following command in your terminal:

```console
$ sudo apt install openvpn easy-rsa
```

## Set up the Public Key Infrastructure (PKI)

If you want more than just pre-shared keys, OpenVPN makes it easy to set up a Public Key Infrastructure (PKI) to use SSL/TLS certificates for authentication and key exchange between the VPN server and clients.

OpenVPN can be used in a routed or bridged VPN mode and can be configured to use either UDP or TCP. The port number can be configured as well, but port 1194 is the official one; this single port is used for all communication. [VPN client implementations](../../explanation/security/openvpn-client-implementations.md#openvpn-client-implementations) are available for almost anything including all Linux distributions, macOS, Windows and OpenWRT-based WLAN routers.

The first step in building an OpenVPN configuration is to establish a PKI, which consists of:

- A separate certificate (also known as a public key) and private key for the server and each client

- A primary Certificate Authority (CA) certificate and key, used to sign the server and client certificates

OpenVPN supports bi-directional authentication based on certificates, meaning that the client must authenticate the server certificate and the server must authenticate the client certificate before mutual trust is established.

Both the server and the client will authenticate each other by first verifying that the presented certificate was signed by the primary Certificate Authority (CA), and then by testing information in the now-authenticated certificate header, such as the certificate common name or certificate type (client or server).

### Set up the Certificate Authority

OpenVPN uses its own internal Public Key Infrastructure (PKI) where every client and server holds a certificate signed by the same CA. This is different from obtaining a public TLS certificate for a web service; the CA here is private and only used to authenticate VPN participants.

To set up your own CA, and generate certificates and keys for an OpenVPN server with multiple clients, first copy the `easy-rsa` directory to `/etc/openvpn`. This will ensure that any changes to the scripts will not be lost when the package is updated. From a terminal, run:

```console
$ sudo make-cadir /etc/openvpn/easy-rsa
```

> **Note**
>
> You can alternatively edit `/etc/openvpn/easy-rsa/vars` directly, adjusting it to your needs.

As a `root` user, change to the newly created directory `/etc/openvpn/easy-rsa` and run:

```console
$ ./easyrsa init-pki && ./easyrsa build-ca
```

The PEM passphrase set when creating the CA will be asked for every time you need to encrypt the output of a command (such as a private key). The encryption here is important, to avoid printing any private key in plain text.

### Create server keys and certificates

Next, we will generate a key pair for the server:

```console
$ ./easyrsa gen-req myservername nopass
```

Diffie Hellman parameters must be generated for the OpenVPN server. The following command will place them in `pki/dh.pem`:

```console
$ ./easyrsa gen-dh
```

And finally, create a certificate for the server:

```console
$ ./easyrsa sign-req server myservername
```

All certificates and keys have been generated in subdirectories. Common practice is to copy them to `/etc/openvpn/`:

```console
$ cp pki/dh.pem pki/ca.crt pki/issued/myservername.crt pki/private/myservername.key /etc/openvpn/
```

## Simple server configuration

Included with your OpenVPN installation are these (and many more) sample configuration files:

```console
```

If these files under `/usr/share/doc/*` are not available (for example, the system was provisioned as a minimal install), you can fetch them directly from the Ubuntu package repositories:

- [client.conf](https://git.launchpad.net/ubuntu/+source/openvpn/tree/sample/sample-config-files/client.conf)

- [server.conf](https://git.launchpad.net/ubuntu/+source/openvpn/tree/sample/sample-config-files/server.conf)

Start by copying the example server configuration to `/etc/openvpn/myserver.conf`:

```console
$ sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/myserver.conf
```

> **Note**
>
> In Ubuntu 20.04 LTS or older, the file is compressed, so do this instead:
>
> ``` console
>
> $ sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/myserver.conf.gz
> ```
>
> ``` console
>
> $ sudo gzip -d /etc/openvpn/myserver.conf.gz
> ```

Edit `/etc/openvpn/myserver.conf` to make sure the following lines are pointing to the certificates and keys you created in the section above.

```text
ca ca.crt
cert myservername.crt
key myservername.key
dh dh.pem
tls-crypt ta.key
```

> **Note**
>
> The `tls-crypt` option was introduced in OpenVPN 2.4.0. If you are running an Ubuntu Server release older than 18.04 LTS (Bionic Beaver), please use `tls-auth ta.key 0` instead.

Complete this set with a TLS Authentication (TA) key in `/etc/openvpn` for `tls-crypt` like this:

```console
$ sudo openvpn --genkey secret ta.key
```

Add a config file to `/etc/sysctl.conf.d` to enable IP forwarding:

```console
$ echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/50-enable-ipv4-forwarding.conf
```

Then apply this file through `sysctl`:

```console
$ sudo sysctl -p /etc/sysctl.d/50-enable-ipv4-forwarding.conf
```

This is the minimum you need to configure to get a working OpenVPN server. You can consider studying and tweaking all the default settings we got from the sample `server.conf` file. Now you can start the server.

```console
$ sudo systemctl start openvpn@myserver
```

> **Note**
>
> Be aware that the `systemctl start openvpn` is **not** starting the `openvpn` you just defined. OpenVPN uses templated `systemd` jobs, `openvpn@CONFIGFILENAME`. So if, for example, your configuration file is `myserver.conf` your service is called `openvpn@myserver`. You can run all kinds of service and `systemctl` commands like `start/stop/enable/disable/preset` against a templated service like `openvpn@server`.

You will find logging and error messages in the journal. For example, if you started a [templated service](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html) `openvpn@server` you can filter for this particular message source with:

```console
$ sudo journalctl -u openvpn@myserver -xe
```

The same templated approach works for all of `systemctl`, which shows the current server status:

```console
$ sudo systemctl status openvpn@myserver
```

You can enable/disable various OpenVPN services on one system, but you could also let Ubuntu do it for you. There is a config for `AUTOSTART `in `/etc/default/openvpn`. Allowed values are “all”, “none” or a space-separated list of names of the VPNs. If empty, “all” is assumed. The VPN name refers to the VPN configuration file name, i.e., `home` would be `/etc/openvpn/home.conf`.

If you’re running `systemd`, changing this variable requires running `systemctl daemon-reload` followed by a restart of the `openvpn` service (if you removed entries you may have to stop those manually).

After `systemctl daemon-reload`, a restart of the “generic” OpenVPN will restart all dependent services that the generator in `/lib/systemd/system-generators/openvpn-generator` created for your `conf` files when you called `daemon-reload`.

Now, check if OpenVPN created a `tun0` interface:

```console
$ ip addr show dev tun0
```

Due to restricting it to `dev tun0` this will report just that:

```console
```

### Create client certificates

The VPN client will also need a certificate to authenticate itself to the server. Usually you create a different certificate for each client.

This can be done either on the server (as with the keys and certificates above) and then securely distributed to the client, or the client can generate and submit a request that is sent and signed by the server.

To create the certificate, enter the following in a terminal as a root user:

```console
$ ./easyrsa gen-req myclient1 nopass && ./easyrsa sign-req client myclient1
```

If the first command above was done on a remote system, then copy the `.req` file to the CA server. From there, you can import it via `easyrsa import-req /incoming/myclient1.req myclient1`. Then you can go on with the second `sign-req` command.

After this is done, in both cases you will need to copy the following files to the client using a secure method:

- `pki/ca.crt`

- `pki/issued/myclient1.crt`

- `pki/private/myclient1.key`

- `ta.key`

Since the client certificates and keys are only required on the client machine, you can remove them from the server.

## Simple client configuration

There are various different OpenVPN client implementations – both with and without [GUIs](../../reference/glossary.md#term-GUI). You can read more about clients in [our page on OpenVPN Clients](../../explanation/security/openvpn-client-implementations.md#openvpn-client-implementations). For now, we use the command-line/service-based OpenVPN client for Ubuntu, which is part of the same package as the server. So you must install the `openvpn` package again on the client machine:

```console
$ sudo apt install openvpn
```

This time, copy the `client.conf` sample config file to `/etc/openvpn/`:

```console
$ sudo cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/
```

Copy the following client keys and certificate files you created in the section above to e.g. `/etc/openvpn/` and edit `/etc/openvpn/client.conf` to make sure the following lines are pointing to those files. If you have the files in `/etc/openvpn/` you can omit the path:

```text
ca ca.crt
cert myclient1.crt
key myclient1.key
tls-crypt ta.key
```

> **Note**
>
> The `tls-crypt` option was introduced in OpenVPN 2.4.0. If you are running an Ubuntu Server release older than 18.04 LTS (Bionic Beaver), please use `tls-auth ta.key 1` instead.

And you have to specify the OpenVPN server name or address. Make sure the keyword **`client`** is in the config file, since that’s what enables client mode.

```text
client
remote vpnserver.example.com 1194
```

Now start the OpenVPN client with the same templated mechanism:

```console
$ sudo systemctl start openvpn@client
```

You can check the status as you did on the server:

```console
$ sudo systemctl status openvpn@client
```

On the server log, an incoming connection looks like the following (you can see client name and source address as well as success/failure messages):

```text
ovpn-myserver[10556]: read UDPv4 [ECONNREFUSED]: Connection refused (fd=7,code=111)
ovpn-myserver[10556]: 10.185.198.41:40732 VERIFY OK: depth=1, CN=server
ovpn-myserver[10556]: 10.185.198.41:40732 VERIFY OK: depth=0, CN=client
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_VER=2.6.15
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_PLAT=linux
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_TCPNL=1
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_MTU=1600
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_NCP=2
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_CIPHERS=AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_PROTO=990
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_LZO_STUB=1
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_COMP_STUB=1
ovpn-myserver[10556]: 10.185.198.41:40732 peer info: IV_COMP_STUBv2=1
ovpn-myserver[10556]: 10.185.198.41:40732 TLS: move_session: dest=TM_ACTIVE src=TM_INITIAL reinit_src=1
ovpn-myserver[10556]: 10.185.198.41:40732 TLS: tls_multi_process: initial untrusted session promoted to trusted
ovpn-myserver[10556]: 10.185.198.41:40732 Control Channel: TLSv1.3, cipher TLSv1.3 TLS_AES_256_GCM_SHA384, peer certificate: 2048 bits RSA, signature: RSA-SHA256, peer temporary key: 768 bits X25519MLKEM768
ovpn-myserver[10556]: 10.185.198.41:40732 [client] Peer Connection Initiated with [AF_INET]10.185.198.41:40732
ovpn-myserver[10556]: MULTI: new connection by client 'client' will cause previous active sessions by this client to be dropped.  Remember to use the --duplicate-cn option if you want multiple clients using the same certificate or username to concurrently connect.
ovpn-myserver[10556]: MULTI_sva: pool returned IPv4=10.8.0.2, IPv6=(Not enabled)
ovpn-myserver[10556]: MULTI: Learn: 10.8.0.2 -> client/10.185.198.41:40732
ovpn-myserver[10556]: MULTI: primary virtual IP for client/10.185.198.41:40732: 10.8.0.2
ovpn-myserver[10556]: SENT CONTROL [client]: 'PUSH_REPLY,route-gateway 10.8.0.1,topology subnet,ping 10,ping-restart 120,ifconfig 10.8.0.2 255.255.255.0,peer-id 0,cipher AES-256-GCM,protocol-flags cc-exit tls-ekm dyn-tls-crypt,tun-mtu 1500' (status=1)
ovpn-myserver[10556]: client/10.185.198.41:40732 Data Channel: cipher 'AES-256-GCM', peer-id: 0
ovpn-myserver[10556]: client/10.185.198.41:40732 Timers: ping 10, ping-restart 240
ovpn-myserver[10556]: client/10.185.198.41:40732 Protocol options: explicit-exit-notify 1, protocol-flags cc-exit tls-ekm dyn-tls-crypt
```

And you can check on the client if it created a `tun0` interface:

```console
$ ip addr show dev tun0
```

Check if you can ping the OpenVPN server:

```console
$ ping 10.8.0.1 -c 1
```

> **Note**
>
> The OpenVPN server always uses the first usable IP address in the client network and only that IP is pingable. E.g., if you configured a `/24` for the client network mask, the `.1` address will be used. The P-t-P address you see in the `ip addr` output above does not usually answer ping requests.

Check out your routes:

```console
$ ip route show dev tun0
```

A system might have many many routes, but this call restricts to those on `tun0`:

```console
```

## First troubleshooting

If the above didn’t work for you, check the following:

- Check your `journal -xe`, also consider limiting it to the unit with `-u` as done in the examples shown above.

- Check that you have specified the key filenames correctly in the client and server `conf` files.

- Can the client connect to the server machine? Maybe a firewall is blocking access? Check the journal on the server.

- Client and server must use same protocol and port, e.g. UDP port 1194, see `port` and `proto` config options.

- Client and server must use the same compression configuration, see `comp-lzo` config option.

- Client and server must use same config regarding bridged vs. routed mode, see `server vs server-bridge` config option

## Advanced configuration

### Advanced routed VPN configuration on server

The above is a very simple working VPN. The client can access services on the VPN server machine through an encrypted tunnel. If you want to reach more servers or anything in other networks, push some routes to the clients. E.g. if your company’s network can be summarised to the network `192.168.0.0/16`, you could push this route to the clients. But you will also have to change the routing for the way back – your servers need to know a route to the VPN client-network.

The example config files that we have been using in this guide are full of these advanced options in the form of a comment and a disabled configuration line as an example.

> **Note**
>
> Read the OpenVPN [hardening security guide](https://openvpn.net/community-docs/security.html) for further security advice.

### Advanced bridged VPN configuration on server

OpenVPN can be set up for either a routed or a bridged VPN mode. Sometimes this is also referred to as OSI layer-2 versus layer-3 VPN. In a bridged VPN all layer-2 frames – e.g. all Ethernet frames – are sent to the VPN partners and in a routed VPN only layer-3 packets are sent to VPN partners. In bridged mode, all traffic including traffic which was traditionally LAN-local (like local network broadcasts, [DHCP](../../reference/glossary.md#term-DHCP) requests, ARP requests etc) are sent to VPN partners, whereas in routed mode this would be filtered.

#### Prepare interface config for bridging on server

First, use Netplan to configure a bridge device using the desired Ethernet device like `/etc/netplan/01-netcfg.yaml` to contain:

```yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s31f6:
            dhcp4: no
    bridges:
        br0:
            interfaces: [enp0s31f6]
            dhcp4: no
            addresses: [10.0.1.100/24]
            routes:
               - to: default
                 via: 10.0.1.1
            nameservers:
                addresses: [10.0.1.1]
```

Static IP addressing is highly suggested. DHCP addressing can also work, but you will still have to encode a static address in the OpenVPN configuration file.

The next step on the server is to configure the Ethernet device for promiscuous mode on boot. To do this, ensure the `networkd-dispatcher` package is installed and create the following configuration script:

```console
$ sudo apt update && sudo apt install networkd-dispatcher
```

Then add the following contents to a file like `/etc/networkd-dispatcher/dormant.d/promisc_bridge`:

```sh
#!/bin/sh
set -e
if [ "$IFACE" = br0 ]; then
    # no networkd-dispatcher event for 'carrier' on the physical interface
    ip link set enp0s31f6 up promisc on
fi
```

And ensure it has the permission to be executed:

```console
$ sudo chmod +x /etc/networkd-dispatcher/dormant.d/promisc_bridge
```

#### Prepare server config for bridging

Edit `/etc/openvpn/server.conf` to use `tap` rather than `tun` and set the server to use the `server-bridge` directive:

```text
;dev tun
dev tap
;server 10.8.0.0 255.255.255.0
server-bridge 10.0.0.4 255.255.255.0 10.0.0.128 10.0.0.254
```

After configuring the server, restart OpenVPN by entering:

```console
$ sudo systemctl restart openvpn@myserver
```

#### Prepare client config for bridging

The only difference on the client side for bridged mode to what was outlined above is that you need to edit `/etc/openvpn/client.conf` and set `tap` mode:

```text
dev tap
;dev tun
```

Finally, restart OpenVPN:

```console
$ sudo systemctl restart openvpn@client
```

You should now be able to connect to the fully remote LAN through the VPN.

### Using OpenSSL providers

OpenVPN uses the OpenSSL 3 Default Provider on Ubuntu. However, you can include additional providers dynamically depending on your use case.

#### Legacy provider

You can still use legacy algorithms in Ubuntu, this is not recommended but might be required to support older clients not yet compatible with the more secure new algorithms. Enabling those is done by explicitly adding them through the `legacy` provider alongside `default`. To do this, add the following line to your OpenVPN configuration.

```text
providers legacy default
```

You can also run `openvpn` with the `--providers` argument.

```console
$ openvpn --providers legacy default ...
```

> **Note**
>
> On Ubuntu 22.04 LTS and earlier, legacy algorithms are included in OpenVPN by default.

#### TPM 2.0

OpenVPN also works with Trusted Platform Module (TPM) 2.0 encryption using the `tpm2` provider. Set it up by installing the `tpm2-openssl` package and including both `legacy` and `tpm2` in your provider configuration.

```text
providers legacy default tpm2
```

Alternatively, run with:

```console
$ openvpn --providers legacy default tpm2 ...
```

> **Note**
>
> The provider order matters here as tpm2 currently requires the legacy provider to load first.

## Further reading

- [EasyRSA](https://github.com/OpenVPN/easy-rsa/blob/master/README.quickstart.md)

- [OpenVPN quick start guide](https://openvpn.net/as-docs/getting-started.html)

- OpenVPN as a snap [easy-openvpn](https://snapcraft.io/easy-openvpn-server)

- Debian’s [OpenVPN Guide](https://wiki.debian.org/OpenVPN)

---

> 来源：https://ubuntu.com/server/docs/how-to/security/install-openvpn/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
