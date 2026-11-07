<a id="troubleshooting-tls-ssl"></a>

# Troubleshooting TLS/SSL

Debugging TLS/SSL connections and protocols can be daunting due to their complexity. Here are some troubleshooting tips.

## Separate the client and server

Whenever testing TLS/SSL connections over the network, it’s best to really separate the client and the server. Remember that the crypto library configuration file is read by the library, not just by a server or a client. It’s read by both. Therefore having separate systems acting as clients and servers, with their own configuration files, makes things simpler to analyze.

## Tools

Here are some tools to help troubleshooting a TLS/SSL configuration.

### OpenSSL server and client apps

The OpenSSL server and client tools are very handy to quickly bring up a server with a selection of ciphers and protocols and test it with a client. Being part of OpenSSL, these tools will also initialize the library defaults directly from the OpenSSL config file, so they are very useful to test your configuration changes.

To bring up an OpenSSL server, a certificate with a private key is needed. There are many ways to generate a pair, and here is a quick one:

```console
$ openssl req -new -x509 -nodes -days 30 -out myserver.pem -keyout myserver.key
```

Answer the questions as you prefer, but the one that needs special attention is the `commonName` (`CN`) one, which should match the [hostname](../../reference/glossary.md#term-hostname) of this server. Then bring up the OpenSSL server with this command:

```console
$ openssl s_server -cert myserver.pem -key myserver.key
```

That will bring up a TLS/SSL server on port 4433. Extra options that can be useful:

- `-port N`: Set a port number. Remember that ports below 1024 require root privileges, so use `sudo` if that’s the case.

- `-www`: Will send back a summary of the connection information, like ciphers used, protocols, etc.

- `-tls1_2`, `-tls1_3`, `-no_tls1_3`, `-no_tls1_2`: Enable only the mentioned protocol version, or, with the `no_` prefix variant, disable it.

- `-cipher <string>`: Use the specified cipher string for TLS1.2 and lower.

- `-ciphersuite <string>`: Use the specified string for TLS1.3 ciphers.

The client connection tool can be used like this when connecting to `server`:

```console
$ echo | openssl s_client -connect server:port 2>&1 | grep '^New'
```

That will generally show the TLS version used, and the selected cipher:

```console
$ echo | openssl s_client -connect j-server.lxd:443 2>&1  | grep '^New'
```

The ciphers and protocols can also be selected with the same command line options as the server:

```console
$ echo | openssl s_client -connect j-server.lxd:443 -no_tls1_3 2>&1  | grep '^New'
```

```console
$ echo | openssl s_client -connect j-server.lxd:443 -no_tls1_3 2>&1 -cipher DEFAULT:-AES256 | grep '^New'
```

### The `sslscan` tool

The `sslscan` tool comes from a package with the same name, and it will scan a server and list the supported algorithms and protocols. It’s super useful for determining if your configuration has really disabled or enabled a particular cipher or TLS version.

To use the tool, point it at the server you want to scan:

```console
$ sslscan j-server.lxd
```

And you will get a report of the ciphers and algorithms supported by that server. Consult the *[sslscan(1)](https://manpages.ubuntu.com/manpages/resolute/man1/sslscan.1.html)* manual page.

## Further reading

- *[OpenSSL s_server](https://manpages.ubuntu.com/manpages/resolute/man1/openssl-s_server.1.html)*

- *[OpenSSL s_client](https://manpages.ubuntu.com/manpages/resolute/man1/openssl-s_client.1.html)*

- *[sslscan(1)](https://manpages.ubuntu.com/manpages/resolute/man1/sslscan.1.html)*

- [`https://badssl.com`](https://badssl.com/): excellent website that can be used to test a client against a multitude of certificates, algorithms, key sizes, protocol versions, and more.

---

> 来源：https://ubuntu.com/server/docs/explanation/crypto/troubleshooting-tls-ssl/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
