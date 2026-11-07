<a id="dnssec-troubleshooting"></a>

# Basic DNSSEC troubleshooting

Some of the troubleshooting tips that will be shown here are focused on the BIND9 [DNS](../../reference/glossary.md#term-DNS) server and its tools, but the general principle applies to [DNSSEC](../../reference/glossary.md#term-DNSSEC) in all implementations.

## Handy “bad” and “good” DNSSEC domains

It helps to have some good known domains with broken and working DNSSEC available for testing, so we can be sure our tooling is catching those, and not just failing everywhere. There is no guarantee that these domains will be up forever, and certainly there are more out there, but this list is a good first choice:

- These should fail DNSSEC validation:

  - *[dnssec-failed.org](http://dnssec-failed.org)*

  - *sigfail.ippacket.stream*

- These should pass DNSSEC validation:

  - *[isc.org](http://isc.org)*

  - *sigok.ippacket.stream*

## Logs

By default, the [BIND9 server](install-dnssec.md#install-dnssec) will log certain DNSSEC failures, and the journal log should be the first place to check.

For example, if we ask a BIND9 Validating Resolver for the IP address of the `www.dnssec-failed.org` name, we get a failure:

```console
$ dig @127.0.0.1 -t A www.dnssec-failed.org
```

That’s a very generic failure: it just says `SERVFAIL`, and gives us no IP: `IN A` is empty. The BIND9 logs, however, tell a more detailed story:

```console
$ journalctl -u named.service -f
```

## Client-side tooling: dig

One of the more versatile DNS troubleshooting tools is `dig`, generally used for interrogating DNS name servers to lookup and display domain information, but its broad functionality makes it a flexible aid for DNS troubleshooting. It provides direct control over setting most of the DNS flags in queries, and displays detailed responses for inspection.

For DNSSEC troubleshooting purposes, we are interested in the following features:

- `+dnssec`: Set the “DNSSEC OK” bit in the queries, which tells the resolver to include in its responses the DNSSEC RRSIG records. This is also shown as a `do` flag in queries.

- `+cd`: This means *check disabled* and tells the resolver we can accept unauthenticated data in the DNS responses.

- `ad`: When included in a response, this flag means *authenticated data*, and tells us that the resolver who provided this answer has performed DNSSEC validation.

- `@<IP>`: This parameter lets us direct the query to a specific DNS server running at the provided IP address.

For example, let’s query the local systemd-resolved DNS stub resolver (running at **127.0.0.53**) for the *[isc.org](http://isc.org)* type *A* record, and request DNSSEC data:

> **Note**
>
> We need to (temporarily) enable DNSSEC validation and potentially set DNSSEC capable upstream servers (e.g. Cloudflare’s `1.1.1.1`, in case your upstream DNS server cannot properly handle it) in systemd-resolved, as shown below. After our experiments, we might want to restore the default settings, using: `resolvectl revert eth0`

```console
$ resolvectl dnssec eth0 true
```

```console
$ resolvectl dns eth0 1.1.1.1
```

```console
$ dig @127.0.0.53 -t A +dnssec +multiline isc.org
```

Let’s unpack this answer for the important troubleshooting parts:

- The answer has the `ad` flag set, meaning this data was authenticated. In other words, DNSSEC validation was successful.

- The status of the query is `NOERROR`, and we have 5 records in the answer section.

- An RRSIG record for the “A” Resource Record was returned as requested by the `+dnssec` command-line parameter. This is also confirmed by the presence of the “do” flag in the “OPT PSEUDOSECTION”.

If we repeat this query with a domain that we know fails DNSSEC validation, we get the following reply:

```console
$ dig @127.0.0.53 -t A +dnssec +multiline dnssec-failed.org
```

This time:

- There is no `ad` flag set in the answer.

- The status of the query is a generic `SERVFAIL`, and zero answers were provided.

- An error logged in `journalctl`

```console
$ journalctl -u systemd-resolved.service -f
```

We can tell the local stub resolver (systemd-resolved running at `@127.0.0.53` address) that we don’t want it to perform DNSSEC validation. We do that by setting the `+cd` (check disabled) flag. Then things change in our answer:

```console
$ dig @127.0.0.53 -t A +dnssec +cd +multiline dnssec-failed.org
```

Looks like we have some sort of answer, but:

- There is no `ad` flag in the answer, so this data was not authenticated.

- The status is `NOERROR`, and we got two answers.

- Note there is a `cd` flag in the answer, meaning “check disabled”. No attempt at validating the answer was done by the resolver, as requested.

In none of these cases, though, did `dig` perform DNSSEC validation: it just presented the results provided by the resolver, which in some cases was no validation at all (via the `+cd` flag). To perform the validation ourselves, we have to use a different tool.

## Digging a bit deeper: `delv`

The `delv` tool is very similar to `dig`, and can perform the same DNS queries, but with a crucial difference: it can also validate DNSSEC. This is very useful in troubleshooting, because rather than returning a generic `SERVFAIL` error when something goes wrong with DNSSEC validation, it can tell us what was wrong in more detail.

But to bring the responsibility of doing DNSSEC validation to the tool itself, we use the `+cd` flag in our queries, to tell the resolver to not attempt that validation. Otherwise we will just get back a generic `SERVFAIL` error:

```console
$ delv @127.0.0.53 -t A +dnssec +multiline dnssec-failed.org
```

With the `+cd` flag present, however, `delv` itself will do the validation. It will fail again, but now with a DNSSEC-specific error:

```console
$ delv @127.0.0.53 -t A +dnssec +cd +multiline dnssec-failed.org
```

If needed, `delv` can be told to not perform DNSSEC validation at all, by passing the `-i` flag. Together with the `+cd` flag, which instructs the Validating Resolver to not perform validation either, we get this result:

```console
$ delv @127.0.0.53 -i -t A +dnssec +cd +multiline dnssec-failed.org
```

For a good DNSSEC domain, `delv` will return a validated answer:

```console
$ delv @127.0.0.53 -t A +multiline +cd isc.org
```

Given that above we used the `+cd` flag, this means that the validation was done by `delv` itself. We will get the same result without that flag if the resolver also succeeds in the DNSSEC validation, and provides an answer.

## Client-side tooling: resolvectl

The local stub resolver *systemd-resolved* can perform DNSSEC validation locally using its high-level `resolvectl` tool. The local cache and state about DNS servers should be reset in systemd-resolved, to get reliable results.

> **Note**
>
> We need to (temporarily) enable DNSSEC validation and potentially set DNSSEC capable upstream servers (e.g. Cloudflare’s `1.1.1.1`, in case your upstream DNS server cannot properly handle it) in systemd-resolved, as shown below. After our experiments, we might want to restore the default settings, using: `resolvectl revert eth0`

Flush systemd-resolved caches & state and confirm DNSSEC is enabled:

```console
$ sudo resolvectl flush-caches
```

```console
$ sudo resolvectl reset-server-features
```

```console
$ sudo resolvectl dnssec eth0 yes
```

```console
$ sudo resolvectl dns eth0 1.1.1.1
```

```console
$ resolvectl dnssec
```

Query a DNSSEC enabled domain and confirm the data was fetched from the network and authenticated, as displayed by the `Data is authenticated` and `Data from` fields:

```console
$ resolvectl query --type=MX isc.org
```

## Incorrect time

As with everything related to cryptography, having an accurate measurement of time is of crucial importance. In a nutshell, digital signatures and keys have expiration dates.

An RRSIG record (a digital signature of a Resource Record) has a validity. For example, this record:

```text
noble.example.internal. 86400 IN RRSIG A 13 3 86400 (
                                20241106131533 20241023195023 48112 example.internal.
                                5fL4apIwCD9kt4XbzzlLxMXY3mj8Li1WZu3qzlcBpERp
                                lXPgLODbRrWyp7L81xEFnfhecKtEYv+6Y0Xa5iVRug== )
```

Has this validity range:

- valid until: 20241106131533 (2024-11-06 13:15:33 UTC)

- valid since: 20241023195023 (2024-10-23 19:50:23 UTC)

If the DNSSEC validator has an incorrect clock, outside of the validity range, the DNSSEC validation will fail. For example, with the clock incorrectly set to before the beginning of the validity period, `delv` will complain like this:

```console
$ date
```

```console
$ delv @10.10.17.229 -a example.internal.key +root=example.internal +multiline noble.example.internal
```

Any other Validating Resolver will fail in a similar way, and should indicate this error in its logs.

BIND9 will complain loudly if it’s running on a system with an incorrect clock, as the root zones will fail validation:

```text
named[3593]: managed-keys-zone: DNSKEY set for zone '.' could not be verified with current keys
named[3593]:   validating ./DNSKEY: verify failed due to bad signature (keyid=20326): RRSIG validity period has not begun
named[3593]:   validating ./DNSKEY: no valid signature found (DS)
named[3593]: broken trust chain resolving './NS/IN': 199.7.83.42#53
named[3593]: resolver priming query complete: broken trust chain
```

## Third-party web-based diagnostics

There are some public third-party web-based tools that will check the status of DNSSEC of a public domain. Here are some:

- <https://dnsviz.net>: Returns a graphical diagram showing the chain of trust and where it breaks down, if that’s the case.

- <https://dnssec-debugger.verisignlabs.com>: A DNSSEC debugger which also shows the chain of trust and where it breaks down, in a table format.

## Further reading

- [bind9’s guide to DNSSEC troubleshooting](https://bind9.readthedocs.io/en/latest/dnssec-guide.html#basic-dnssec-troubleshooting)

- [How to validate DNSSEC using the command line](https://www.cyberciti.biz/faq/unix-linux-test-and-validate-dnssec-using-dig-command-line/)

- *[delv(1)](https://manpages.ubuntu.com/manpages/resolute/man1/delv.1.html)* manual page

- *[dig(1)](https://manpages.ubuntu.com/manpages/resolute/man1/dig.1.html)* manual page

---

> 来源：https://ubuntu.com/server/docs/how-to/networking/dnssec-troubleshooting/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
