<a id="managing-software"></a>

# Managing your software

If you are new to Ubuntu, you may be wondering what to do after installation. After all, Ubuntu is endlessly customizable according to your needs. There are two types of software found in Ubuntu: **Debian packages** (debs) and **snaps** – we will focus mainly on debs in this tutorial!

To help you get the most from your Ubuntu experience, this tutorial will walk you through managing the software on your Ubuntu machine. This tutorial can be completed using either Ubuntu Server or Ubuntu Desktop.

If you are re-using a virtual machine from a different tutorial, skip directly to [Updating the system with APT](managing-software.md#update-with-apt).

## Set up the virtual machine

To avoid making changes to your computer we will set up a virtual machine (VM), which provides us with a safe environment to run the commands in. [Multipass](https://documentation.ubuntu.com/multipass/latest/) is great for quickly creating Ubuntu virtual machines, so we will use that. It is available on Windows, Mac and Linux, so you don’t need to be already running Ubuntu on your computer to follow this tutorial.

### Prerequisites

- The Multipass VM needs **5** [GB](../reference/glossary.md#term-GB) **of disk space**, and **1 GB of memory** available.

### Install Multipass

**\[On Ubuntu\]**

You can install Multipass directly from [the Multipass page](https://snapcraft.io/multipass) in the online snap store (make sure to select the “latest/stable” version from the dropdown menu next to the install button).

**\[On other operating systems\]**

If you’re on Windows, Mac, or another Linux operating system, Multipass can be installed [using these instructions](https://documentation.ubuntu.com/multipass/stable/how-to-guides/install-multipass/).

### Open a terminal window

Now that Multipass is installed, we need a terminal window to run our commands in. How you open one depends on your operating system.

**\[On Ubuntu\]**

Press <span class="kbd">Ctrl</span> + <span class="kbd">Alt</span> + <span class="kbd">T</span> together and a terminal window will open. You can also search for “Terminal” in your application launcher.

**\[On Windows\]**

PowerShell is the most reliable option for working with Multipass on Windows.

1.  Press the <span class="kbd">Windows</span> key.

2.  Type `PowerShell`.

3.  Right-click it and select **Run as Administrator** — this helps avoid permission issues when managing virtual machines.

If you have Windows Terminal installed from the Microsoft Store, that works just as well and offers a nicer experience with tab support.

To confirm everything is working, type `multipass version` and press <span class="kbd">Enter</span>. If you see version numbers, you’re ready to continue.

**\[On macOS\]**

1.  Press <span class="kbd">⌘</span> + <span class="kbd">Space</span> to open Spotlight.

2.  Type `Terminal` and press <span class="kbd">Enter</span>.

If you use iTerm2, that works perfectly well too.

To confirm everything is working, type `multipass version` and press <span class="kbd">Enter</span>. If you see version numbers, you’re ready to continue.

### Create the virtual machine

Once you have installed Multipass and opened your terminal, we can launch a new VM using the Ubuntu 26.04 LTS release (codename “`resolute`”), and let’s give our VM the name `tutorial` using the following command in our terminal window:

```console
$ multipass launch resolute --name tutorial
```

It may take a little time, depending on the speed of your internet connection. Multipass downloads the most recent daily **image** and creates the VM for us.

> **Note**
>
> An Ubuntu **image** is a collection of files we need to install and run Ubuntu. We don’t need to specify “server” or “desktop” anywhere in our command, because the image is the same for both. The only difference between Ubuntu Server and Ubuntu Desktop is the subset of software packages we use from the Ubuntu Archive.

Once the above command has finished running, we can access the VM by running:

```console
$ multipass shell tutorial
```

We will get a “Welcome to Ubuntu” message. Notice that when we run this command, the terminal username changes to `ubuntu` and the [hostname](../reference/glossary.md#term-hostname) changes to `tutorial`:

```bash
ubuntu@tutorial:~ $
```

This shows that we are inside the VM, and this is where we will run all our commands. Now that our setup is complete, let’s carry on with the tutorial!

<a id="update-with-apt"></a>

## Updating the system with APT

The first thing we always want to do with a new system (whether a VM, container, bare metal, or cloud instance) is to make sure we have the latest versions of all the pre-installed software.

Debian packages, commonly referred to as **debs**, are the standard software package format in Ubuntu. They can be identified by the `.deb` file extension.

Every Linux distribution has their own preferred **package manager** for installing, updating and removing packages. In Ubuntu, the default package manager is [Advanced Packaging Tool](https://wiki.debian.org/AptCLI) (or APT, for short).

APT handles all of your system software (and other deb packages). It provides an interface to the Ubuntu Archive *repository*, so it can access both the **database** of all the packages available in Ubuntu, and the means to handle the **packages** themselves.

There are two APT commands we need to update our system: `update` and `upgrade`, which we will always run in that order.

### apt update

The `apt update` command is about the **database**. Any bug fixes in a package (or new versions since your last update) will be stored in the metadata about that package in the database (the **package index**).

When we run the `update` command it updates the APT database on our machine, fetching the newest available metadata from the package index:

```console
$ sudo apt update
```

As we can see, it checks (“hits”) the various archives (**pockets**) that updates can come from for the 26.04 LTS release (`resolute`, `resolute-updates`, `resolute-backports`, and `resolute-security` – remember these, as we’ll come back to them later). It has found some packages that can be upgraded to newer versions. If we want to see which packages those are, we can run the command hinted in the output:

```console
$ apt list --upgradable
```

The specific packages included in this list change over time, so the exact packages shown will be different, but the output will be structured like this:

```console
```

The output tells us:

- the package name and where the update will come from (e.g. `bind9-dnsutils` package from `resolute-updates` and `resolute-security`),

- the most up-to-date package version available (e.g. `1:9.20.18-1ubuntu2.1`),

- the hardware version the update is for (e.g. `amd64`), and

- what package version is currently installed (e.g. `1:9.20.18-1ubuntu2`)

### apt upgrade

The `apt upgrade` command is about the **packages** on your system. It looks at the metadata in the package index we just updated, finds the packages with available upgrades, and lists them for us. Once we’ve checked the proposed upgrade and are happy to proceed, it will then install the newer versions for us.

After we have updated the database (which we did by running `apt update`) we can then upgrade the packages to their newest versions by running:

```console
$ sudo apt upgrade
```

When we run this command, it will ask us to confirm if the summary of proposed changes that will be made to our system is what we want.

Let’s type <span class="kbd">Y</span>, then press <span class="kbd">Enter</span> to confirm that yes, we do want that, and then the upgrade will proceed. This may take a few minutes.

> **Tip**
>
> You can use the `-y` flag, which is a shorthand for `--assume-yes`. If we ran the command `sudo apt upgrade -y` it would proceed with the upgrade without asking us to confirm. Shorthand versions of flags are common – for most packages, you can check which flags are equivalent using [the manual pages](https://manpages.ubuntu.com/) or using the `man` command, as we’ll see later.

In the output, we’ll see where `apt upgrade` is fetching the upgrade from for each package. For example:

```console
```

APT combines the various elements; the package name (`libgcrypt20`), version (`1.12.0-2ubuntu0.1`), source (`resolute-updates/main`), etc into a single URL that it can use for the download. The package is then unpacked, and the upgrade applied to the system.

> **Note**
>
> These commands only upgrade the packages for the release of Ubuntu that we are using (26.04 LTS). If we wanted to upgrade the entire system to the next release of Ubuntu (e.g. from 22.04 LTS to 24.04 LTS), we would use the `do-release-upgrade` command. See this guide on [how to upgrade your release](../how-to/software/upgrade-your-release.md#upgrade-your-release) for more information.

It’s important to know that `apt upgrade` will only handle packages that can be straightforwardly upgraded. If the package has **dependency** issues (i.e., the version you have “depends” on other packages that also need to be added, upgraded or removed), you would need to use `sudo apt dist-upgrade` instead. The `dist-upgrade` command is able to resolve conflicts between package versions, but it *could* end up removing some packages. So while `apt upgrade` is safe to use unattended (in a script, for example), you should only use `dist-upgrade` when you can review which packages may be removed.

### Searching with APT

Now we’re up-to-date, we can start exploring! As with any other database, we can search the list of available packages using APT in order to find software. Let’s say that we want to find a web server, for example. We can run the following command:

```console
$ apt search webserver
```

This will return us a long list of all “`webserver`” packages it can find. But some of the descriptions don’t actually contain the text “`webserver`” – like in this section of the list:

```console
```

We can use `apt show` to inspect the description and summary details of any package, so let’s take a closer look at `ipcalc` from our list:

```console
$ apt show ipcalc
```

The summary has been replaced with `[...]` for brevity, but we can see that the text “`webserver`” is in the long description of the “Description” field.

```console
```

While we used `apt` in the `apt show` command, in many places you will see reference to `apt-get` and `apt-cache` instead of `apt`. Historically, the *database* part of APT was accessed using `apt-cache` (e.g. `apt-cache show ipcalc`), and the *packages* part of APT used `apt-get` (e.g. `apt-get install ipcalc`).

APT has recently been streamlined, so although it uses `apt-get` and `apt-cache` “behind the scenes” (and these commands do still work), we don’t need to worry about remembering which command to use – we can use the more convenient `apt` directly. To find out more about these packages and how to use them (or indeed, any package in Ubuntu!) we can refer to the manual pages.

Run `man apt`, `man apt-get` or `man apt-cache` in the terminal to access the manuals for these packages on the command line, or view the same content in the [online manual pages](https://manpages.ubuntu.com).

## Installing deb packages

For the examples for this section, we’re going to use the popular web server package, [Apache2](https://httpd.apache.org/).

APT gives us a lot of details about what will be included in the installation, and it’s always important to understand the implications of a command *before* we run it. We’ll be taking a close look at the details APT gives us, so we need to be careful in this section.

When we run a command that asks us “`Do you want to continue? [Y/n]`”, make sure to type <span class="kbd">N</span> for “no” and then press <span class="kbd">Enter</span> unless instructed otherwise – this will let us see the output of the commands without making changes that then need to be undone.

Installing deb packages using APT is done using the `apt install` command. We can install either a single package, or a list of packages at once, by including their names in a space-separated list after the `install` command, in this format:

```sh
sudo apt install <package 1> <package 2> <package 3>
```

### About `sudo`

We’ve seen the `sudo` prefix in a couple of commands already, and you may be wondering what that’s about. In Linux, system tasks (like installing software) need elevated administrator permissions. These permissions are often called “root access”, and a user with root access is called a “root user”.

However, it can be dangerous to operate your machine as a root user – since root access gives you full system control the whole time, it allows you to change or delete important system files. It’s very easy to accidentally break your system in root mode!

Instead, we use `sudo` (which is short for `superuser do`). This command is a safety feature that grants regular users *temporary* (per command) admin privileges to make system changes. It’s still important for us to always understand what a command does before we run it, but using `sudo` means we purposefully limit any potential mistakes to a single command.

### About dependencies

As we hinted earlier, packages often come with **dependencies** – other packages that *your* package needs so it can function. Sometimes, a package might depend on a specific version of another package. If a package has dependencies, then installing a package via `apt` will also install any dependencies, which ensures the software can function properly.

APT tells us how it will resolve any dependency conflicts or issues when we run the `install` command. Let’s try this for ourselves, but remember, we **don’t** want to proceed with the install yet, so let’s type <span class="kbd">N</span> when it asks us if we want to continue:

```console
$ sudo apt install apache2
```

The output should be similar to the below.

```console
```

It tells us:

- which packages we have but don’t need (not shown above because our Apache2 example has none),

- additional packages that will be installed (these are our dependencies),

- suggested packages, and

- a summary of which *new* packages will be present on the system after the install is done (which in this case is `apache2` itself, and all its dependencies).

Let’s try and make sense of this output.

#### Types of dependencies

The relationship between a package and any other packages follows the [Debian policy on binary dependencies](https://www.debian.org/doc/debian-policy/ch-relationships.html#binary-dependencies-depends-recommends-suggests-enhances-pre-depends), which we’ll briefly look at here. The most common ones you might come across are: `depends`, `recommends`, and `suggests` (although there are others!), so we’ll take a look at these three.

- **depends**: Absolutely required, the package won’t work without it. If we try to remove a package that is depended on by another, both will be removed!

- **recommends**: Strongly dependent, but not absolutely necessary (which means the package will work better with it, but can still function without it)

- **suggests**: Not needed, but may enhance the usefulness of the package in some way.

We can see, using `apt show`, exactly which packages fall into each of these categories. Let’s use Apache2 as our example again:

```console
$ apt show apache2
```

We see that `ssl-cert` is a recommended package. In Ubuntu, the default configuration of `apt install` is set to install recommended packages alongside `depends`, so when we ran the `apt install apache2` command, `ssl-cert` was included in the proposed packages to be installed (even though it’s only recommended, not strictly needed).

```console
```

We can override this behavior by passing the `--no-install-recommends` flag to our command, like this:

```console
$ sudo apt install apache2 --no-install-recommends
```

Then the output becomes the following (type <span class="kbd">N</span> at the prompt again to avoid installing for now):

```console
```

Now, we see that `ssl-cert` is only mentioned as a recommended package, and is excluded from the list of packages to be installed.

There is a second flag we could pass – the `--install-suggests` flag. This will not only install the strict dependencies and recommended packages, but *also* the suggested packages. From our previous output, it doesn’t look like too much, right? It’s only four additional packages.

But actually, if we run this command:

```console
$ sudo apt install apache2 --install-suggests
```

By comparing the amount of space needed with “suggests” included, to the previous output, we can see that there’s a considerable increase! Sometimes, including suggested packages will cause the package to not be installed due to a lack of space on the system.

This is because each of these suggested packages also comes with their own lists of dependencies, including suggested packages, all of which would *also* be installed. It’s perhaps clear to see why this is not the default setting!

#### What if we remove a dependency?

We’ll go into more detail about removing packages later, but for now, let’s see what happens if we remove a required *dependency*. First, we should (finally!) install the `apache2` package. Let’s run the following command again, but this time when we are asked whether we want to continue, let’s press <span class="kbd">Y</span> and then <span class="kbd">Enter</span> to confirm, and APT will install the package:

```console
$ sudo apt install apache2
```

One of the required dependencies is the `apache2-data` package. Let’s try to remove it using `apt remove`:

```console
$ sudo apt remove apache2-data
```

Once again, `apt` won’t proceed without confirmation, so we get the following output – let’s take a look before we choose anything:

```console
```

Let’s break this down a little bit, because there are some subtle differences here that we want to understand before we proceed.

- “The following packages were automatically installed and are no longer required”

  These were other dependencies that `apache2` needed, but none of them depend upon `apache2-data`, so even if we remove `apache2` and `apache2-data` they would still be functional – they just aren’t used by any other installed packages…and so have no reason to be there anymore. They won’t be removed, APT is helpfully telling us so we’re aware of them.

- “The following packages will be REMOVED”

  These are the packages that will be removed directly - we’ve told APT we want to remove `apache2-data`, so we expect that to be included, but it will also remove `apache2` itself! This is because `apache2-data` is a required dependency, and `apache2` won’t function *at all* without it.

Let’s now choose <span class="kbd">Y</span> to confirm we want to remove this dependency.

> **Warning**
>
> Removing dependencies can, at worst, cause a system to become unusable – you should always be careful when doing so. If you remove a dependency that is part of a chain, the removals will cascade up the chain as each dependency and the package that depends on it are removed. You can end up removing more than you originally anticipated!

#### Auto-remove dependencies

So, we have removed the `apache2` and `apache2-data` packages, but the other dependencies that were installed alongside `apache2` are still there. The output of our `remove` command gave us the hint about how to deal with these redundant packages – the `autoremove` command:

```console
$ sudo apt autoremove
```

When we run this command, `apt` once again gives us a summary of the operation we requested, but let’s choose <span class="kbd">N</span> for now when it asks if we want to continue:

```console
```

You may be wondering why we don’t need to specify any packages when we call the `autoremove` command – after all, we’ve just been dealing with packages related to `apache2`. This is because `apt` will check all the packages on your system. It examines the dependency tree, and if the original reason for the package to be installed no longer exists (i.e., it isn’t needed by anything), it will be flagged for auto-removal.

But!

We might, in the future, uninstall Apache2 without uninstalling the redundant packages at the time. We might have found another use for `ssl-cert`, perhaps in a script that makes use of SSL certificates. So how can we keep the `ssl-cert` package, even though it’s flagged for auto-removal?

We can solve this problem, and un-flag the `ssl-cert` package for removal, by *manually* installing it:

```console
$ sudo apt install ssl-cert
```

This sets `ssl-cert` to **manually installed**. We might well wonder “why didn’t APT didn’t ask us to confirm anything this time?”. In this case, it’s because `ssl-cert` is already present on the system so APT doesn’t need to install anything new.

```console
```

If the `ssl-cert` package is manually installed on our system, by us, then `apt` knows the package is wanted, and we can see that it has been removed from the auto-remove list so our next `autoremove` will not uninstall it. Let’s test this, just to make sure!

```console
$ sudo apt autoremove
```

This time we’ll select <span class="kbd">Y</span> when prompted, and then we can run `apt list ssl-cert` to quickly see if our `ssl-cert` package is still on the system:

```console
$ apt list ssl-cert
```

If you’re curious, you can also run `apt list apache2` to see how the output differs for a package that was once installed and then removed!

Anyway, we’re not quite finished with the Apache2 package, so let’s reinstall it:

```console
$ sudo apt install apache2
```

And this time select <span class="kbd">Y</span> to confirm when it asks.

## Customize configuration

In general, the default package configuration should just work well, and work “out of the box” when it’s installed. But it’s almost inevitable that, sooner or later, we’ll want to customize the package so that it better fits our own purposes.

Before we try to customize the package, we should probably look at what files are included in it. We can check this using *[dpkg(1)](https://manpages.ubuntu.com/manpages/resolute/man1/dpkg.1.html)*, which is the Debian package manager. Although APT is now more commonly used for basic package handling, `dpkg` retains some really helpful commands for examining files and finding out package information. It’s installed by default on Ubuntu systems so we can use it directly:

```console
$ dpkg --listfiles ssl-cert
```

This gives us the following list of files and their directory structure (the end of the list is truncated for brevity):

```console
```

If we find a file but we’re not sure what package it comes from, `dpkg` can help us there too! Let’s use the example of one of the configuration files from the previous output: `/usr/share/ssl-cert/ssleay.cnf` and do a search for it using `dpkg`:

```console
$ dpkg --search /usr/share/ssl-cert/ssleay.cnf
```

Although this is an obvious case, because we already know the source of this file, the `dpkg` search function is really useful for tracking down the sources of files we don’t know about!

### Conffiles

Most of a package’s configuration is handled through [configuration files](https://www.debian.org/doc/debian-policy/ap-pkg-conffiles.html#automatic-handling-of-configuration-files-by-dpkg) (often known as **conffiles**). Conffiles often contain things like file paths, logs and debugging configuration, kernel parameters (which can be changed to optimize system performance), access control, and other configuration settings. The actual parameters available will vary from one package to another.

Package conffiles are different from all other files delivered in a package. A package may have any number of conffiles (including none!). Conffiles are explicitly marked by the package maintainer during development to protect local configuration from being overwritten during upgrades so that your changes are saved. This is not the case for any other types of files – changes you make to regular files in that package *will be overwritten* during an upgrade.

### How upgrades are handled

Since a conffile can be changed by us, we might end up with conflicts when the package maintainer changes those same files. Therefore, it’s important to understand how such conflicts are handled.

We can show the four possible upgrade scenarios using the following table. What happens during an upgrade depends on whether the conffile on our system has been changed by us (“changed/not changed by user”), and whether the version’s default content has been changed by the package maintainer (“changed/not changed by maintainer”):

| The conffile is… | **not changed by maintainer** | **changed by maintainer** |
|----|----|----|
| **…changed by user** | Keep user’s changes | Ask user |
| **…not changed by user** | No changes to make | Apply changes from update |

So we can see that if we do make changes to a conffile, APT will never overwrite our changes without asking us first.

### Identifying conffiles

Out of the list of files in a package, how do we know which ones are the conffiles?

After all, they are not marked by any particular file extension, and although they are often found in the `/etc/` directory, they don’t *have* to be there. As we saw before, the only thing conffiles have in common is that the package maintainer decided to mark them as such.

But that’s our clue! So once more, `dpkg` can come to our rescue. The following command will show us (`--show`) the subset of files in the `apache2` package that have been marked as “`Conffiles`” (`-f='${Conffiles}\n'`) by the maintainer and shows each on a new line (`\n`) in the output:

```console
$ dpkg-query --show -f='${Conffiles}\n' apache2
```

If you want to understand more about what this command does, you can refer to the manual page by typing `man dpkg-query --show`, and it will talk you through all the options.

Unlike `dpkg --listfiles`, `dpkg-query` *also* gives us a string of letters and numbers. This string is known as the **“MD5 checksum”** or **“MD5 hash”**.

```console
```

We can see the checksum of a specific file by running this command, which returns us the checksum followed by the file and its location:

```console
$ md5sum /etc/apache2/apache2.conf
```

You might well be wondering “why do we care about that?” since they match (in this example).

The checksum is like a fingerprint - it’s unique for every *version* of a file, so any time the file is changed it will get a new checksum – which allows us to see **if a file has been changed** from the default.

### Verifying checksums

Let’s set up a situation so we can poke a bit at this idea. We can start by making some changes to a conffile. In Apache2, the main conffile is `/etc/apache2/apache2.conf`, so let’s use that. In a situation where we are setting up a new web server, we might reasonably want to increase the `LogLevel` from “warn” to “debug” to get more debugging messages, so let’s run this command and use `sed` to make that change in the conffile:

```console
$ sudo sed -e 's/LogLevel warn/LogLevel debug/' -i /etc/apache2/apache2.conf
```

We won’t be prompted to confirm if we want to make these changes – but we do need root access so we use `sudo` in our command. As we hinted in the section about `sudo`, the fact that we can make these changes without needing to confirm is why it can be so easy to break your system when you’re operating as root! Try running the command without the `sudo`, and you will get a “permission denied” error.

Next, we’ll restart our Apache2 server so that we can activate our configuration changes:

```console
$ sudo systemctl restart apache2
```

Now if we run the `md5sum` command again, we can see the hash changed:

```console
ubuntu@tutorial:~$ md5sum /etc/apache2/apache2.conf
```

This works great if we know that there’s a file *we* changed, but what about if someone else tampered with a file, and we don’t know which one? In that case, we can use:

```console
$ dpkg --verify apache2
```

This will verify the checksums of the files on our system against those held in the package index for `apache2`, and return a rather strange looking result if (or when) it finds a mismatch:

```console
```

Which is exactly what we were expecting to see, since we know we changed this file.

But what if something else was messed with…something that shouldn’t be, and something not changed by us? Let’s make a “silly” change to a different file to test this – in this case, changing all instances of the word “warning” to “silly” in a random package file:

```console
$ sudo sed -e 's/warning/silly/' -i /usr/sbin/a2enmod
```

And then run the verification again with:

```console
$ dpkg --verify apache2
```

> **Note**
>
> You might have noticed there’s a “c” next to the top line but not the bottom – the “c” shows the file is a conffile.

`dpkg` can tell that the file has been changed, but won’t tell us what the change was. However, since the file in question is not a conffile, we know that the change *won’t be preserved* if we upgrade the package. This means that we can overwrite the changes and restore the default package content by “reinstalling” Apache2. We can use the `--reinstall` flag to force `apt` to re-unpack all of the default content:

```console
$ sudo apt install --reinstall apache2
```

If we then verify once more…

```console
$ dpkg --verify apache2
```

…so we can see that our change to the conffile has been preserved because the checksums are different, but the `a2enmod` file isn’t listed anymore because it has been restored to the default. Phew!

> **Note**
>
> We can use `sudo apt install <package>` to upgrade an installed package, but this will only upgrade to the latest version. In our case, we were already on the latest version of Apache2, so we needed to force APT to re-unpack the content to overwrite our “silly” changes.

## Removing packages

Since we have just reinstalled the Apache2 package, we know it is in good shape. But what if we decide we’re done with it and just want to remove it? Then we can run:

```console
$ sudo apt remove apache2
```

Let’s type <span class="kbd">Y</span> to proceed.

As before, we see that the dependencies will still be there even when `apache2` has been removed. Let’s check with `dpkg`…

```console
$ dpkg --listfiles apache2
```

…and see what else might be left behind…

```console
```

This looks suspiciously like the list of conffiles we saw earlier, right?

### Also removing configuration

As it turns out, removing a package doesn’t automatically remove the conffiles. But – this is intentional, for our convenience.

By leaving the conffiles in place, if we decide to reinstall `apache2` again in the future, we don’t need to spend time setting up all our configuration again.

Let’s see the difference in installing `apache2` after it has been installed (and removed) compared to the first time we installed it:

```console
$ sudo apt install apache2
```

Notice that it did not ask us to confirm if we wanted to proceed this time. Why not? As we saw earlier, the “Y/n” confirmation is shown when there are dependencies, and we know that Apache2 *has* dependencies.

…Ah! But this time, we didn’t run `autoremove` when we uninstalled Apache2, so the dependencies are still installed on our system. This means that when we ask `apt` to install `apache2` now, there is nothing missing and we are getting *exactly* what we are asking for.

Since the dependencies and conffiles are still there, we can use our former config immediately. It even retains the changes we made before, which we can verify by looking at the checksum again:

```console
$ md5sum /etc/apache2/apache2.conf
```

### Removing and purging

What if we decide that we don’t want the changed conffiles? Perhaps we want to go back to the default installation, or we know we won’t want to use the package ever again – how can we ensure that all the conffiles are removed at the same time as we remove the package?

In that case, we can use the `--purge` option of the `remove` command:

```console
$ sudo apt remove --purge apache2
```

If we look very carefully, we see a little asterisk (\*) in the output.

```console
```

This tiny indicator tells us that the package will be removed AND purged. However, it still does not remove the dependencies (or the conffiles of those dependencies).

Let’s type <span class="kbd">Y</span> again to confirm we want to proceed. Then, once the removal is complete, we can check the list once more:

```console
$ dpkg --listfiles apache2
```

This time the output is very different!

> **Note**
>
> We could also use the `dpkg-query --show -f='${Conffiles}\n' apache2` command from earlier, and `dpkg-query` will find no packages matching `apache2`.

There are other ways to change package files. If you would like to read more, check out our [guide to changing package files](../explanation/software/changing-package-files.md#changing-package-files).

## What else is on our system?

As we saw earlier, we can search the APT package database for keywords using `apt search <keyword>` to find software we might want to install. We can also see all the packages we already have using `apt list`, although it can be easier to navigate and more informative if we use `dpkg -l` instead – then we can use the up and down arrow keys on our keyboard to scroll (or press <span class="kbd">Q</span> to return to our terminal prompt).

For every package, we can see what versions of it exist in the database:

```console
$ apt policy apache2
```

This will return a summary of all the versions that exist on our particular Ubuntu release, ordered by “most recent” first:

```console
```

We know that Apache2 isn’t installed right now, because we removed and purged it, which is why the installed version shows as “none”:

```console
```

If we were to install the default package, we would get this one:

```console
```

Under each version we are also shown the **source**. The newest version (`2.4.66-2ubuntu2.1`) comes from `resolute-updates` (main) and `resolute-security` (main). The *original* version (`2.4.66-2ubuntu2`) comes from `resolute` (main). This tells us that this was the version released with the with 26.04 LTS (Resolute Raccoon).

### Installing older package versions

We can install specific older versions if we want to, for example, to satisfy dependency requirements of another package. We can do that by specifying the package name and version:

```bash
sudo apt install <package>=<version>
```

However, this can be tricky and often leads to conflicts in dependency versions as APT always wants to install the most recent version. We can see an example of this if we run the following command:

```console
$ sudo apt install apache2=2.4.66-2ubuntu2
```

APT warns us that the version of apache2 we want to install depends on earlier versions of the dependencies, but it helpfully tells us which dependency versions we need to successfully install the package we want.

```console
```

So, all we need to do is first install the dependencies, and then run the install command again. Remember that we can install multiple packages at once by separating them with spaces. We can also break the command over multiple lines using backslashes (`\`) to make it easier to read, but it will still be run as a single command:

```console
$ sudo apt install apache2-bin=2.4.66-2ubuntu2 \
>   apache2-data=2.4.66-2ubuntu2 \
>   apache2-utils=2.4.66-2ubuntu2 \
>   apache2=2.4.66-2ubuntu2
```

APT will warn us that we are downgrading the package, but let us press <span class="kbd">Y</span> to confirm (when prompted), and it will go ahead and downgrade us anyway. Let’s run the following command again to get confirmation that we’re running on an older version:

```console
$ apt policy apache2
```

### Where do packages come from?

You may be wondering by now “where exactly do all these packages come from?”. We’ve spotted a few sources very briefly throughout this tutorial, but haven’t paid direct attention to them yet. Let’s take a little time now to define what we mean by all these different sources that APT can pull packages from.

The source behind APT is the **Ubuntu Package Archive**. This Archive splits into many layers, each with its own terminology. The different terminology is quite confusing at first, but we’ve seen a few of the terms already. So if we take a look, layer-by-layer, we’ll see not just what all the terms mean, but how they all fit together.

Let’s have a quick overview with this diagram. The general flow is that the Archive splits into **Ubuntu series**. Each series is split up into **pockets**, and then each pocket contains four **components**. If we tried to show all of this on one diagram, it would be quite extensive, so let’s take a look through a single path.

```text
        flowchart TD;
  A[Ubuntu Package Archive] --> B([Splits into Ubuntu **series**]);

  B --> C[e.g., mantic];
  B --> D[noble];
  B --> E[oracular, etc];

  D --> H([Series split into **pockets**]);

  H --> I[-release];
  H --> J[-proposed];
  H --> K[-updates];
  H --> L[-security];
  H --> M[-backports];

  K --> N([Splits into **components**]);

  N --> O[main];
  N --> P[universe];
  N --> Q[restricted];
  N --> R[multiverse];

  style C fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style D fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style E fill:#fff,stroke:#cfcfcf,stroke-width:2px;

  style I fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style J fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style K fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style L fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style M fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style O fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style P fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style Q fill:#fff,stroke:#cfcfcf,stroke-width:2px;
  style R fill:#fff,stroke:#cfcfcf,stroke-width:2px;

```

#### Series

The **series** is a set of packages that are released with a specific version of Ubuntu – they’re usually referred to by their codename (e.g., `mantic`, `noble` and `oracular` in our diagram). Each version of Ubuntu may have multiple releases. For example, an LTS will have an initial release when it launches (e.g. 24.04 LTS), and then “subsequent point releases” (e.g. 24.04.1 LTS) – these are all part of the same series (`noble`).

In practice, people often use the term “Ubuntu release” and “Ubuntu series” interchangeably.

#### Pockets

Every Ubuntu series (`noble`, `jammy`, etc) is split into **pockets**, which are related to the software development/release lifecycle:

- **-release** contains the packages as they are at release time.

- **-proposed** contains package updates while they are being tested.

- Once an update is released, they come from either **-security** or **-updates** depending on whether they are a security-related update or not.

- And **-backports**, which contains packages that were not available at release time.

This is why earlier, we saw that some updates came from `resolute-updates` or `resolute-security`. These refer to updates and security updates, respectively, from the `resolute` series. Pockets are usually appended to the end of the series, and it’s quite common to see the hyphen (`-`) included when referring to pockets.

Remember – the original version of the `apache2` package we saw came from `resolute`. The `-release` pocket only includes the software that was part of the original LTS release, and so it takes the name of the Ubuntu series by default (i.e., the `-release` pocket is implied).

#### Components

Each pocket is split into four **components**, depending on whether the packages they contain are *open source* or *closed source*, and whether they are officially supported by Canonical or are maintained by the Ubuntu Community:

|                          | Open source | Closed source |
|--------------------------|-------------|---------------|
| **Officially supported** | main        | restricted    |
| **Community supported**  | universe    | multiverse    |

- **main** contains the open-source packages that are officially supported by Canonical. These packages are either installed on every Ubuntu machine, or are very widely used for various types of systems and use-cases.

- **universe** holds all other open-source packages in Ubuntu, which are typically maintained by the Debian and Ubuntu communities, but may also include additional security coverage from Canonical under [Ubuntu Pro](https://ubuntu.com/pro), which is available free for personal use on up to five machines.

- **restricted** contains the packages that are officially supported by Canonical but are not available under a completely free license.

- **multiverse** contains community-maintained proprietary software – these packages are completely unsupported by Canonical.

If you would like more information about the Ubuntu release process, how packages are produced, or to learn more about the sort of terminology you might come across, you may be interested in the [Ubuntu Project documentation](https://documentation.ubuntu.com/project/), which is a great resource containing all this information (and much more!).

## Installing a .deb file

Although APT is the preferred way to install packages on your system, due to its ability to handle dependencies and keep software up-to-date, not every package is available in the APT repository – especially if they are so old they are no longer maintained, or conversely, are the newest version still in development!

We can install .deb files that aren’t in the APT repository using `dpkg` – all we need is to download the .deb file, and we can run a command like this to install it:

```bash
sudo dpkg -i <file-name.deb>
```

But – APT is helpful here too. Even if we get a .deb file that isn’t from the Ubuntu Archive, we can still install it with APT so that if there are dependencies that can be resolved automatically from the Archive – they will be!

```bash
sudo apt install ./file-name.deb
```

If we ever do want to install a .deb file, APT is definitely the most convenient way to do it. We may still need to handle *some* dependencies manually, but now we have the knowledge to be able to do that.

Luckily, most of the packages you will ever need are likely to be found through APT. If it’s not, it’s worth checking if the software is available as a **snap** instead.

<a id="tutorial-snaps"></a>

## Snaps

Snaps are a newer, self-contained software format that were developed to be a more portable and easy-to-use alternative to debs. They come with all their dependencies pre-bundled so that there is no need for a package management tool to track dependencies, and they run inside sandboxed environments that limit their interactions with the rest of the system.

Instead of **versions** as we have them in debs, snaps use the concept of [channels](https://snapcraft.io/docs/channels) to define which release of a snap is installed.

By default, snaps are kept automatically up-to-date, so we don’t need to remember to update and upgrade them. There are times on a live system, such as a server in a production environment, where we might not want to have updates automatically applied. In those cases, we can [turn off automatic updates](https://snapcraft.io/docs/managing-updates) and refresh the system snaps when it’s convenient (for example, during a maintenance window).

If you would like to try out snaps, we recommend the excellent [quickstart tour](https://snapcraft.io/docs/get-started) tutorial in the snap documentation. Feel free to continue using the VM we’ve been using in this tutorial while exploring!

## Completion!

Once you are finished and want to leave the tutorial, you can run:

```console
$ exit
```

This will take you out of the VM and back to your live machine. Then, you can run the following commands to delete the VM and remove it completely from your machine:

```console
$ multipass delete tutorial
```

```console
$ multipass purge
```

## Summary

Congratulations, we made it to the end! We’ve covered a lot of material in this tutorial, so let’s do a quick recap of what we’ve learned:

**Finding, installing and removing packages**

- How to update and upgrade all our system’s software with APT:

  - `sudo apt update && sudo apt upgrade`

- How to search for software using keywords or strings:

  - `apt search <keyword>` or `apt search "some content string"`

- How to see the description of a package, including what dependencies it has:

  - `apt show <package name>`

  Or how to check what package versions are available:

  - `apt policy <package>`

- How to install packages…

  - `sudo apt install <package1> <package2>`

- How to see all the files a package contains

  - `dpkg --listfiles <package>`

- How to find out what package a file belongs to:

  - `dpkg --search <path/to/file>`

- …And how to remove packages again! As well as the difference between removing and purging.

  - `sudo apt remove <package>`

- We even learned how to downgrade to older versions of APT packages, and all about APT sources.

**Customizing package configuration**

- How to find the conffiles in a package:

  - `dpkg-query --show -f='${Conffiles}\n' <package>`

- How to see if package files have been changed:

  - `dpkg --verify <package>`

- …And if a non-conffile has been changed by accident, we can fix it with:

  - `sudo apt install --reinstall <package>`

- We know that our changes to conffiles are always safely preserved, while changes to non-conffiles are reverted at the next upgrade or security fix.

- Importantly, we know how to verify checksums with `md5sum` or similar tools, which helps us to more safely build packages from source.

- And finally, we learned about snaps!

---

> 来源：https://ubuntu.com/server/docs/tutorial/managing-software/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
