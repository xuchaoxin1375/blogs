<a id="samba-print-server"></a>

# Set up Samba as a print server

Another common way to network Ubuntu and Windows computers is to configure Samba as a *print server*. This will allow it to share printers installed on an Ubuntu server, whether locally or over the network.

Just as we did in [using Samba as a file server](file-server.md#samba-file-server), this section will configure Samba to allow any client on the local network to use the installed printers without prompting for a username and password.

If your environment requires stricter Access Controls see [Share access controls](share-access-controls.md#share-access-controls).

## Install and configure CUPS

Before installing and configuring Samba as a print server, it is best to already have a working CUPS installation. See [our guide on CUPS](../networking/cups-print-server.md#cups-print-server) for details.

## Install Samba

To install the `samba` package, run the following command in your terminal:

```console
$ sudo apt install samba
```

## Configure Samba

After installing `samba`, edit `/etc/samba/smb.conf`. Change the *workgroup* attribute to what is appropriate for your network, and set printing to cups:

```ini
workgroup = EXAMPLE
printing = cups
```

In the *`[printers]`* section, change the *guest ok* option to ‘yes’:

```ini
browsable = yes
guest ok = yes
```

After editing `smb.conf`, restart Samba:

```console
$ sudo systemctl restart smbd.service nmbd.service
```

The default Samba configuration will automatically share any printers installed. Now all you need to do is install the printer locally on your Windows clients.

## Further reading

- The `[printers]` section of the *[smb.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/smb.conf.5.html)* manual page

- [Samba wiki](https://wiki.samba.org/index.php/Main_Page)

- The [CUPS Website](http://www.cups.org/) has more information on configuring CUPS

---

> 来源：https://ubuntu.com/server/docs/how-to/samba/print-server/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
