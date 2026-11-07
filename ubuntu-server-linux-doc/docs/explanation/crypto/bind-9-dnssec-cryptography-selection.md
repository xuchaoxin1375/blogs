# BIND 9 DNSSEC cryptography selection

Domain Name System Security Extensions (DNSSEC), which provides a set of security features to [DNS](../../reference/glossary.md#term-DNS), is a broad topic. In this article, we will briefly show DNSSEC validation happening on a `bind9` DNS server, and then introduce the topic of how we can disable certain cryptographic algorithms from being used in this validation.

## DNSSEC validation

Out of the box, the BIND 9 DNS server is configured to try to use DNSSEC whenever it’s available, doing all the validation checks automatically. This is done via the `dnssec-validation auto` setting in `/etc/bind/named.conf.options`, which became the implicit default as of version `1:9:18.34-1` in Ubuntu 24.10 and above.

DNSSEC can be quickly checked with the help of `dig`. Right after you installed `bind9`, you can run `dig` and ask it about the `isc.org` domain:

```console
$ dig @127.0.0.1 isc.org +dnssec +multiline
```

We can see that a `RRSIG` DNSSEC record was returned, but the important information in this output is the `ad` flag near the top. That stands for “authenticated data”, and means that the DNSSEC records in the response were validated.

To see an example where this verification fails, we can use the `www.dnssec-failed.org` domain, which is specially crafted for this:

```console
$ dig @127.0.0.1 www.dnssec-failed.org +dnssec +multiline
```

Here we see that:

- There is no `IN A` IP address shown in the reply

- The status is `SERVFAIL`

- There is no `ad` flag

In the `bind9` logs, we will see DNSSEC validation errors:

```console
$ journalctl -u named.service -n 10
```

We can run `dig` with the `+cd` command line parameter which disables this verification, but notice that still we don’t get the `ad` flag in the reply:

```console
$ dig @127.0.0.1 www.dnssec-failed.org +dnssec +multiline +cd
```

## Restricting DNSSEC algorithms

It’s possible to limit the cryptographic algorithms used by BIND to validate DNSSEC records. This is done via two configuration settings, located inside the `options { }` block of `/etc/named/named.conf.options`:

- `disable-algorithms "<domain>" { a; b; ... };` Disables the listed algorithms for the specified domain and all subdomains of it.

- `disable-ds-digests "<domain>" { a; b; ... };` Disables the listed digital signature digests for the specified domain and all subdomains of it.

For example, the following disables `RSAMD5`, `DSA` and `GOST` for all zones:

```text
disable-algorithms "." {
    RSAMD5;
    DSA;
};
disable-ds-digest "." {
    GOST;
};
```

The list of algorithm names can be obtained at [DNSSEC Algorithm Numbers](https://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml), in the **Mnemonic** column of the **Available Formats** table. The algorithm number is also standardised, and is part of the DNSSEC records.

For example, if we go back to the `dig` result from before where we inspected the `isc.org` domain, the `RRSIG` record had this (showing just the first line for brevity):

```text
isc.org.        300 IN RRSIG A 13 2 300 (
```

In that record, the number `13` is the algorithm number, and in this case it means the algorithm `ECDSAP256SHA256` was used.

Just to see how BIND would react to an algorithm being disabled, let’s temporarily add `ECDSAP256SHA256` to the list of disabled algorithms:

```text
disable-algorithms "." {
   RSAMD5;
   DSA;
   ECDSAP256SHA256;
};
```

And restart BIND:

```console
$ sudo systemctl restart bind9.service
```

Now the `ad` flag is gone, meaning that this answer wasn’t validated:

```console
$ dig @127.0.0.1 isc.org +dnssec +multiline
```

The logs only say there was no valid signature found:

```text
Apr 19 14:23:01 j-bind9 named[2786]: validating isc.org/A: no valid signature found
```

Note this is different from rejecting the response: it just means that this response is being treated as if it didn’t have any DNSSEC components in it, or in other words, it’s treated as “insecure”.

In general, as always with cryptography, be careful with which algorithms you decide to disable and remove from DNSSEC validation, as such errors can be hard to diagnose. To help with troubleshooting, the Internet Systems Consortium (ISC) has published a very extensive DNSSEC guide, which contains a detailed troubleshooting section (see below).

> **Note**
>
> Remember now to remove the disabling of `ECDSAP256SHA256` from `/etc/bind/named.conf.options` and restart BIND 9. This change was just a quick test!

## Further reading

- [ISC DNSSEC Guide](https://bind9.readthedocs.io/en/v9.18.14/dnssec-guide.html)

- [DNSSEC troubleshooting section of the ISC DNSSEC guide](https://bind9.readthedocs.io/en/v9.18.14/dnssec-guide.html#basic-dnssec-troubleshooting)

- [Standard algorithms used for DNSSEC](https://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml)

---

> 来源：https://ubuntu.com/server/docs/explanation/crypto/bind-9-dnssec-cryptography-selection/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
