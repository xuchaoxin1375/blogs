# GnuTLS

When initialized, the [GnuTLS](../../reference/glossary.md#term-GnuTLS) library tries to read its system-wide configuration file `/etc/gnutls/config`. This file is present in Ubuntu Noble 24.04 LTS and later, but previous releases did not ship it. In that case, if you want to make configuration changes, it has to be created manually.

This config file can be used to disable (or mark as insecure) algorithms and protocols in a system-wide manner, overriding the library defaults. Note that, intentionally, any algorithms or protocols that were disabled or marked as insecure cannot then be re-enabled or marked as secure.

There are many configuration options available for GnuTLS, and we strongly recommend that you carefully read the upstream documentation listed in the References section at the end of this page if creating this file or making changes to it.

## Structure of the config file

The GnuTLS configuration file is structured as an INI-style text file. There are three sections, and each section contains `key = values` lines. For example:

```ini
[global]
override-mode = blocklist

[priorities]
SYSTEM = NORMAL:-MD5

[overrides]
tls-disabled-mac = sha1
```

## The `global` section

The `[global]` section sets the override mode used in the `[overrides]` section:

- `override-mode = blocklist`: the algorithms listed in `[overrides]` are disabled

- `override-mode = allowlist`: the algorithms listed in `[overrides]` are enabled.

Note that in the `allowlist` mode, all algorithms that should be enabled must be listed in `[overrides]`, as the library starts with marking all existing algorithms as disabled/insecure. In practice, this means that using `allowlist` tends to make the list in `[overrides]` quite large. Additionally, GnuTLS automatically constructs a `SYSTEM` keyword (that can be used in `[priorities]`) with all the allowed algorithms and ciphers specified in `[overrides]`.

When using `allowlist`, all options in `[overrides]` will be of the `enabled` form. For example:

```ini
[global]
override-mode = allowlist

[overrides]
secure-hash = sha256
enabled-curve = secp256r1
secure-sig = ecdsa-secp256r1-sha256
enabled-version = tls1.3
tls-enabled-cipher = aes-128-gcm
tls-enabled-mac = aead
tls-enabled-group = secp256r1
```

And when using `blocklist`, all `[override]` options have the opposite meaning (i.e. `disabled`):

```ini
[global]
override-mode = blocklist

[overrides]
tls-disabled-cipher = aes-128-cbc
tls-disabled-cipher = aes-256-cbc
tls-disabled-mac = sha1
tls-disabled-group = group-ffdhe8192
```

For other examples and a complete list of the valid keys in the `[overrides]` section, please refer to [disabling algorithms and protocols](https://www.gnutls.org/manual/html_node/Disabling-algorithms-and-protocols.html).

## Priority strings

The `[priorities]` section is used to construct **priority strings**. These strings are a way to specify the TLS session’s handshake algorithms and options in a compact, easy-to-use, format. Note that priority strings are not guaranteed to imply the same set of algorithms and protocols between different GnuTLS versions.

The default priority string is selected at package build time by the vendor, and in the case of Ubuntu Jammy it’s [defined in `debian/rules`](https://git.launchpad.net/ubuntu/+source/gnutls28/tree/debian/rules?h=ubuntu/jammy-devel#n38) as:

```text
NORMAL:-VERS-ALL:+VERS-TLS1.3:+VERS-TLS1.2:+VERS-DTLS1.2:%PROFILE_MEDIUM
```

A priority string can start with a single initial keyword, and then add or remove algorithms or special keywords. The `NORMAL` priority string is [defined in this table](https://gnutls.org/manual/html_node/Priority-Strings.html#tab_003aprio_002dkeywords) in the upstream documentation reference, which also includes many other useful keywords that can be used.

To see the resulting list of ciphers and algorithms from a priority string, one can use the `gnutls-cli` command-line tool. For example, to list all the ciphers and algorithms allowed with the priority string `SECURE256`:

```console
$ gnutls-cli --list --priority SECURE256
```

You can manipulate the resulting set by manipulating the priority string. For example, to remove `CHACHA20-POLY1305` from the `SECURE256` set:

```console
$ gnutls-cli --list --priority SECURE256:-CHACHA20-POLY1305
```

And you can give this a new name by adding the following to the `[priorities]` section:

```ini
[priorities]
MYSET = SECURE256:-CHACHA20-POLY1305
```

Which allows the `MYSET` priority string to be used like this:

```console
$ gnutls-cli --list --priority @MYSET
```

## Verification profile (overrides)

When verifying a certificate, or TLS session parameters, GnuTLS uses a set of profiles associated with the session to determine whether the parameters seen in the session are acceptable. These profiles are normally set using the `%PROFILE` priority string, but it is also possible to set a low bar that applications cannot override. This is done with the `min-verification-profile` setting in the `[overrides]` section.

For example:

```ini
[overrides]
# do not allow applications use the LOW or VERY-WEAK profiles.
min-verification-profile = legacy
```

The list of values that can be used, and their meaning, is shown in the [key sizes and security parameters](https://gnutls.org/manual/html_node/Selecting-cryptographic-key-sizes.html#tab_003akey_002dsizes) table in the upstream documentation.

## Practical examples

Let’s see some practical examples of how we can use the configuration file to tweak the default cryptographic settings of an application linked with GnuTLS.

Contrary to OpenSSL, GnuTLS does not allow a cipher that was once removed to be allowed again. So if you have a setting in the GnuTLS config file that prohibits `CHACHA20`, an application using GnuTLS will not be able to allow it.

### Only use TLSv1.3

One way to do it is to set a new default priority string that removes all TLS versions and then adds back just TLS 1.3:

```INI
[global]
override-mode = blocklist

[overrides]
default-priority-string = NORMAL:-VERS-TLS-ALL:+VERS-TLS1.3
```

With our test server providing everything but TLSv1.3:

```console
$ sudo openssl s_server -cert j-server.pem -key j-server.key -port 443 -no_tls1_3  -www
```

Connections will fail:

```console
$ gnutls-cli j-server.lxd
```

An application linked with GnuTLS will also fail:

```console
$ lftp -c "cat https://j-server.lxd/status"
```

But an application can override these settings, because it’s only the priority string that is being manipulated in the GnuTLS config:

```console
$ lftp -c "set ssl:priority NORMAL:+VERS-TLS-ALL; cat https://j-server.lxd/status" | grep ^New
```

Another way to limit the TLS versions is via specific protocol version configuration keys:

```INI
[global]
override-mode = blocklist

[overrides]
disabled-version = tls1.1
disabled-version = tls1.2
disabled-version = tls1.0
```

Note that setting the same key multiple times will append the new value to the previous value(s).

In this scenario, the application cannot override the config anymore:

```console
$ lftp -c "set ssl:priority NORMAL:+VERS-TLS-ALL; cat https://j-server.lxd/status" | grep ^New
```

### Use only AES256 with TLSv1.3

TLSv1.3 has a small list of ciphers, but it includes [AES](../../reference/glossary.md#term-AES)128. Let’s remove it:

```INI
[global]
override-mode = blocklist

[overrides]
disabled-version = tls1.1
disabled-version = tls1.2
disabled-version = tls1.0
tls-disabled-cipher = AES-128-GCM
```

If we now connect to a server that was brought up with this config:

```console
$ sudo openssl s_server -cert j-server.pem -key j-server.key -port 443 -ciphersuites TLS_AES_128_GCM_SHA256 -www
```

Our GnuTLS client will fail:

```console
$ gnutls-cli j-server.lxd
```

And given GnuTLS’ behavior regarding re-enabling a cipher that was once removed, we cannot allow AES128 from the command line either:

```console
$ gnutls-cli --priority="NORMAL:+AES-128-GCM"  j-server.lxd
```

## Further reading

- [System-wide configuration](https://www.gnutls.org/manual/html_node/System_002dwide-configuration-of-the-library.html)

- [Priority strings](https://gnutls.org/manual/html_node/Priority-Strings.html)

- [`min-verification-profile` values](https://gnutls.org/manual/html_node/Selecting-cryptographic-key-sizes.html#tab_003akey_002dsizes)

- [Disabling algorithms and protocols](https://www.gnutls.org/manual/html_node/Disabling-algorithms-and-protocols.html)

- [Invoking the `gnutls-cli` command line tool](https://gnutls.org/manual/html_node/gnutls_002dcli-Invocation.html)

---

> 来源：https://ubuntu.com/server/docs/explanation/crypto/gnutls/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
