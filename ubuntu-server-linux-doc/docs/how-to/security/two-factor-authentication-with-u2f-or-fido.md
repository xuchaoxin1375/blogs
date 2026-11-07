<a id="two-factor-authentication-with-u2f-or-fido"></a>

# Two factor authentication with U2F/FIDO

OpenSSH 8.2 has added [support for U2F/FIDO hardware authentication devices](https://www.openssh.org/txt/release-8.2). These devices are used to provide an extra layer of security on top of the existing key-based authentication, as the hardware token needs to be present to finish the authentication.

It’s very simple to use and setup. The only extra step is to generate a new keypair that can be used with the hardware device. For that, there are two key types that can be used: `ecdsa-sk` and `ed25519-sk`. The former has broader hardware support, while the latter might need a more recent device.

Once the keypair is generated, it can be used as you would normally use any other type of key in OpenSSH. The only requirement is that in order to use the private key, the U2F device has to be present on the host.

## Example with U2F

For example, plug the U2F device in and generate a keypair to use with it:

```console
$ ssh-keygen -t ecdsa-sk
```

Now transfer the public part to the server to `~/.ssh/authorized_keys` and you are ready to go:

```console
$ ssh -i .ssh/id_ecdsa_sk ubuntu@focal.server
```

## FIDO2 resident keys

FIDO2 private keys consist of two parts: a **key handle** part, stored in the private key file on disk, and a **per-device key**, which is unique to each FIDO2 token and cannot be exported from the token hardware. These are combined by the hardware at authentication time to derive the real key, which is used to sign authentication challenges.

For tokens that are required to move between computers, it can be cumbersome to have to move the private key file first. To avoid this, tokens implementing the newer FIDO2 standard support **resident keys**, where it is possible to retrieve the key handle part of the key from the hardware.

Using resident keys increases the likelihood of an attacker being able to use a stolen token device. For this reason, tokens normally enforce PIN authentication before allowing the download of keys, and users should set a PIN on their tokens before creating any resident keys. This is done via the hardware token management software.

OpenSSH allows resident keys to be generated using the `ssh-keygen` flag `-O resident` at key generation time:

```console
$ ssh-keygen -t ecdsa-sk -O resident -O application=ssh:mykeyname
```

This will produce a public/private key pair as usual, but it will be possible to retrieve the private key part (the key handle) from the token later. This is done by running:

```console
$ ssh-keygen -K
```

It will use the part after `ssh:` from the `application` parameter from before as part of the key filenames:

```console
$ l id_ecdsa_sk_rk_mytoken*
```

If you set a passphrase when extracting the keys from the hardware token, and later use these keys, you will be prompted for both the key passphrase *and* the hardware key PIN. You will also have to touch the token:

```console
$ ssh -i ./id_ecdsa_sk_rk_mytoken ubuntu@focal.server
```

It is also possible to download and add resident keys directly to `ssh-agent` by running

```console
$ ssh-add -K
```

In this case, no file is written and the public key can be printed by running `ssh-add -L`.

> **Note**
>
> If you used the `-O verify-required` option when generating the keys, or if that option is set on the SSH server via the `/etc/ssh/sshd_config` setting `PubkeyAuthOptions verify-required`, then using the agent won’t work (in Ubuntu 22.04 LTS).

## Further reading

- [OpenSSH 8.2 release notes](https://www.openssh.org/txt/release-8.2)

- [Yubikey documentation for OpenSSH FIDO/FIDO2 usage](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html)

---

> 来源：https://ubuntu.com/server/docs/how-to/security/two-factor-authentication-with-u2f-or-fido/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
