<a id="introduction-to-crypto-libraries"></a>

# Introduction to cryptographic libraries

When choosing a crypto library, the following aspects should be considered to maintain security and compliance. Typically, you will want to answer questions such as: How can we ensure legacy crypto systems with known vulnerabilities are not being used? How can we enforce minimum key size requirements? And what criteria should we use to accept X.509 certificates when connecting to remote servers?

However, the cryptographic library landscape is vast and complex, and there are many crypto libraries available on an Ubuntu system. When an application developer chooses a crypto library, they will consider many aspects, such as:

- Technical requirements

- Language bindings

- License

- Community

- Ease of use

- General availability

- Upstream maintenance

Among the most popular and widely used libraries and frameworks are:

- OpenSSL

- [GnuTLS](../../reference/glossary.md#term-GnuTLS)

- NSS

- GnuPG

- [gcrypt](../../reference/glossary.md#term-gcrypt)

Each one of these has its own implementation details, API, behavior, configuration file, and syntax.

## Determining which libraries are being used by an application

Ultimately, the only reliable way to determine how an application uses cryptography is by reading its documentation or inspecting its source code. But even then, you may discover that the code is not available and sometimes the documentation might lack this information. If you are having problems finding answers to your crypto-related questions, there are some practical checks that can be made.

To find out what libraries are being used, one generally needs to check all of the installed crypto implementations and their respective configurations. To make things even more complicated, sometimes an application implements its own crypto, without using anything external.

If you are having problems finding answers to your crypto-related questions, there are some practical checks that can be made.

### Follow dynamic links

This is the most common way, and very easy to spot via package dependencies and helper tools. A detailed example of this approach to determining crypto is discussed later in this page.

### Check static linking

This is harder, as there is no dependency information in the binary package, and this usually requires inspection of the source package to see build dependencies. A detailed example of this approach is shown later in this page.

### Look at the plugins

The main binary of an application can not depend directly on a crypto library, but it could load dynamic plugins which do. Usually these would be packaged separately, and then we fall under the dynamic or static linking cases above. Note that via such a plugin mechanism, an application could depend on multiple external cryptographic libraries.

### Examine the execution of external binaries

The application could just plain call external binaries at runtime for its cryptographic operations, like calling out to `openssl` or `gnupg` to encrypt/decrypt data. This will hopefully be expressed in the dependencies of the package. If it’s not, then it’s a bug that should be reported.

### Indirect use of libraries or executables

The application could be using a third party library or executable which in turn could fall into any of the above categories.

### Check documentation more carefully

Read the application documentation again. It might have crypto options directly in its own configuration files, or point at specific crypto configuration files installed on the system. This may also clarify whether the application uses external crypto libraries or it has its own implementation of crypto.

## Detailed examples of how to locate crypto libraries

### Use dpkg to check package dependencies

Since package dependencies are a good way to check what is needed at runtime by the application, you can find out which package owns what file with the `dpkg -S` command. For example:

```console
$ dpkg -S /usr/bin/lynx
```

Now that you have the package name, check the package’s dependencies. You should also look for `Recommends`, as they are installed by default. Using the current example, we can now do the following:

```console
$ dpkg -s lynx | grep -E "^(Depends|Recommends)"
```

Now we can see that `lynx` links with `libgnutls30`, which answers our question: `lynx` uses the GnuTLS library for its cryptography operations.

### Using ldd to list dynamic libraries

If a dynamic library is needed by an application, it should always be correctly identified in the list of application package dependencies. When that is not the case, or you need to identify what is needed by some plugin that is not part of the package, you can use some system tools to help identify the dependencies.

In this situation, you can use the `ldd` tool, which is installed in all Ubuntu systems. It lists all the dynamic libraries needed by the given binary, including dependencies of dependencies, i.e. the command is recursive. Going back to the `lynx` example:

```console
$ ldd /usr/bin/lynx
```

We again see the GnuTLS library (via `libgnutls.so.30`) in the list, and can reach the same conclusion.

Another way to check for such dependencies (without recursion) is via `objdump`. You may need to install it with the `binutils` package, as it’s not mandatory. The way to use it is to grep for the `NEEDED` string:

```console
$ objdump -x /usr/bin/lynx|grep NEEDED
```

Finally, if you want to see the dependency *tree*, you can use `lddtree` from the `pax-utils` package:

```console
$ lddtree /usr/bin/lynx
```

### Check package headers for static linking

Identifying which libraries were used in a static build is a bit more involved. There are two ways, and they are complementary most of the time:

- look for the `Built-Using` header in the binary package

- inspect the `Build-Depends` header in the source package

For example, let’s try to discover which crypto libraries, if any, the `rclone` tool uses. First, let’s try the packaging dependencies:

```console
$ dpkg -s rclone | grep -E "^(Depends|Recommends)"
```

Uh, that’s a short list. But `rclone` definitely supports encryption, so what is going on? Turns out this is a tool written in the Go language, and that uses static linking of libraries. So let’s try to inspect the package data more carefully, and this time look for the `Built-Using` header:

```console
$ dpkg -s rclone | grep Built-Using
```

Ok, this time we have a lot of information (truncated above for brevity, since it’s all in one very long line). If we look at the full output carefully, we can see that `rclone` was built statically using the `golang-go.crypto` package, and documentation about that package and its crypto implementations is what we should look for.

If the `Built-Using` header was not there, or didn’t yield any clues, we could try one more step and look for the build dependencies. These can be found in the `debian/control` file of the source package. In the case of `rclone` for Ubuntu Jammy, that can be seen at <https://git.launchpad.net/ubuntu/+source/rclone/tree/debian/control?h=ubuntu/jammy-devel#n7>, and a quick look at the `Build-Depends` list shows us the `golang-golang-x-crypto-dev` build dependency, whose source package is `golang-go.crypto` as expected:

```console
$ apt-cache show golang-golang-x-crypto-dev | grep ^Source:
```

> **Note**
>
> If there is no `Source:` line, then it means the name of the source package is the same as the binary package that was queried.

## Next steps

Once you have uncovered which library your application is using, the following guides may help you to understand the associated configuration files and what options you have available (including some handy examples).

- [OpenSSL guide](../crypto/openssl.md#openssl)

- [GnuTLS guide](../crypto/gnutls.md#gnutls)

- [Troubleshooting TLS/SSL](../crypto/troubleshooting-tls-ssl.md#troubleshooting-tls-ssl)

---

> 来源：https://ubuntu.com/server/docs/explanation/intro-to/crypto-libraries/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
