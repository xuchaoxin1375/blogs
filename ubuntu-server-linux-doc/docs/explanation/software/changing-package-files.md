# Changing package files

Many packages in Ubuntu will create extra files when installed. These files can contain metadata, configurations, rules for operating system interaction, and so on. In many cases, these files will be fully managed by updates to a package, leading to issues when they are modified manually. This page goes over some methods for changing the behavior of a package without causing conflicts in maintained files.

## Configuration files

Configuration files are often provided by packages. They come in many forms, but the majority can be found in the `/etc/` directory with either a `.conf` or `.cnf` extension. Most of the time, these files are managed by the package and editing them could lead to a conflict when updating. To get around this, packages will check in additional `<config>.d/` directories where you can place personal changes.

For example, if you would like `mysql-server` to run on port 3307 instead of 3306, you can open the file `/etc/mysql/mysql.conf.d/mysqld.cnf`, and edit the port option.

```ini
[mysqld]
#
# * Basic Settings
#
user            = mysql
# pid-file      = /var/run/mysqld/mysqld.pid
# socket        = /var/run/mysqld/mysqld.sock
port            = 3307
```

> **Note**
>
> Some packages do not automatically create files for you to edit in their `.d` directories. In these cases it is often acceptable to just create an additional config file by any name there. When in doubt, check the package’s documentation to confirm.

After saving the file, restart the service.

```console
$ systemctl restart mysql
```

The `netstat` command shows that this was successful:

```console
$ netstat -tunpevaW | grep -i 3307
```

## Systemd files

Many packages ship service unit files for interacting with [Systemd](https://systemd.io/). Unit files allow packages to define background tasks, initialization behavior, and interactions with the operating system. The files, or symlinks of them, will automatically be placed in the `/lib/systemd/system/` directory. Likewise, the files can also show up in `/etc/systemd/system`. If these are edited manually they can cause major issues when updating or even running in general.

Instead, if you would like to modify a unit file, do so through Systemd. It provides the command `systemctl edit <service>` which creates an override file and brings up a text editor for you to edit it.

For example, if you want to edit Apache2 such that it restarts after a failure instead of just when it aborts, you can run the following:

```console
$ sudo systemctl edit apache2
```

This will open a text editor containing:

```ini
### Editing /etc/systemd/system/apache2.service.d/override.conf
### Anything between here and the comment below will become the new contents of the file

### Lines below this comment will be discarded

### /lib/systemd/system/apache2.service
# [Unit]
# Description=The Apache HTTP Server
# After=network.target remote-fs.target nss-lookup.target
# Documentation=https://httpd.apache.org/docs/2.4/
#
# [Service]
# Type=forking
# Environment=APACHE_STARTED_BY_SYSTEMD=true
# ExecStart=/usr/sbin/apachectl start
# ExecStop=/usr/sbin/apachectl graceful-stop
# ExecReload=/usr/sbin/apachectl graceful
# KillMode=mixed
# PrivateTmp=true
# Restart=on-abort
...
```

Override the on-abort option by adding a new line in the designated edit location.

```ini
### Editing /etc/systemd/system/apache2.service.d/override.conf
### Anything between here and the comment below will become the new contents of the file

[Service]
Restart=on-failure

### Lines below this comment will be discarded
...
```

> **Note**
>
> Some options, such as `ExecStart` are additive. If you would like to fully override them add an extra line that clears it (e.g. `ExecStart=`) before providing new options. See [Systemd’s man page](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html) for more information.

Once the changes are saved, the override file will be created in `/etc/systemd/system/apache2.service.d/override.conf`. To apply changes, run

```console
$ sudo systemctl daemon-reload
```

To verify the change was successful, you can run the status command.

```console
$ systemctl status apache2
```

## AppArmor

Packages that use [AppArmor](../../how-to/security/apparmor.md#apparmor) will install AppArmor profiles in the `/etc/apparmor.d/` directory. These files are often named after the process being protected, such as `usr.bin.firefox` and `usr.sbin.libvirtd`.

When these files are modified manually, it can lead to a conflict during updates. This will show up in `apt` with something like:

```console
```

Updating to the maintainer’s version will override your changes, which could cause problems with your setup. However, using your version could cause security issues.

If you would like to modify these rules to provide the application with additional permissions, you can instead update the local profile, most often found in `/etc/apparmor.d/local/`.

For example, if you would like `swtpm` to access a custom directory called `/var/customtpm`, you can append the following line to `/etc/apparmor.d/local/usr.bin.swtpm` :

```text
/var/customtpm/** rwk,
```

This method will work for all [AppArmor syntax](https://ubuntu.com/tutorials/beginning-apparmor-profile-development).

> **Note**
>
> Although most local profiles have the same name as the maintainer’s, you can often check what file is included based on the main profile’s contents. In `swtpm`’s case, `/etc/apparmor.d/usr.bin.swtpm` contains the lines:
>
> ``` text
> # Site-specific additions and overrides. See local/README for details.
> #include <local/usr.bin.swtpm>
> ```
>
> showing that the local profile is located at `/etc/apparmor.d/local/usr.bin.swtpm`

## Restoring configuration files

Since config files are meant to be intentional changes by the user/admin, they are not overwritten by updates or even re-installs of the package. However, it’s possible you might change it by accident or may just want to go back to step one of a trial-and-error phase that you are in. In those situations you can use `apt` to restore the original config files. Note that while we call `apt`, it is [dpkg](../../reference/glossary.md#term-dpkg) that actually handles the restoration.

If you have a particular config file, like in the example `/etc/rsyslog.conf`, you first want to find out which package owns that config file:

```console
$ dpkg -S /etc/rsyslog.conf
```

So we now know that the package `rsyslog` owns the config file `/etc/rsyslog.conf`. This command just queries package metadata and works even if the file has been deleted.

```console
$ rm /etc/rsyslog.conf
```

```console
$ dpkg -S /etc/rsyslog.conf
```

To restore that file you can re-install the package, telling `dpkg` to bring any missing files back. To do so you pass `dpkg` options through `apt` using `-o Dpkg::Options::="` and then set `--force-...` depending on what action you want. For example:

```console
$ sudo apt install --reinstall -o Dpkg::Options::="--force-confmiss" rsyslog
```

More details on these options can be found in the *[dpkg(1)](https://manpages.ubuntu.com/manpages/resolute/man1/dpkg.1.html)* manual page, but the most common and important ones are:

- `confmiss` Always install the missing conffile without prompting.

- `confnew` If a conffile has been modified and the version in the package changed, always install the new version without prompting.

- `confold` If a conffile has been modified and the version in the package changed, always keep the old version without prompting.

- `confdef` If a conffile has been modified and the version in the package changed, always choose the default action without prompting.

- `confask` If a conffile has been modified, always offer to replace it with the version in the package, even if the version in the package did not change.

So in the case of an accidental bad config entry, if you want to go back to the package default you could use `--force-confask` to check the difference and consider restoring the content.

```console
$ echo badentry >> /etc/rsyslog.conf
```

```console
$ sudo apt install --reinstall -o Dpkg::Options::="--force-confask" rsyslog
```

The same can be used if you removed a whole directory by accident, to detect and re-install all related packages config files.

```console
$ rm -rf /etc/vim
```

```console
$ dpkg -S /etc/vim
```

```console
$ sudo apt install --reinstall -o Dpkg::Options::="--force-confmiss" vim-common vim-tiny
```

---

> 来源：https://ubuntu.com/server/docs/explanation/software/changing-package-files/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
