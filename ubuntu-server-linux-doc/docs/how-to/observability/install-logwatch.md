<a id="install-logwatch"></a>

# How to install and configure Logwatch

Logs are an invaluable source of information about problems that may arise in your server. [Logwatch](https://sourceforge.net/projects/logwatch/) keeps an eye on your logs for you, flags items that may be of interest, and reports them via email.

## Install Logwatch

Install `logwatch` using the following command:

```console
$ sudo apt install logwatch
```

## Configure Logwatch

Logwatch’s default configuration is kept in `/usr/share/logwatch/default.conf/logwatch.conf`. However, configuration changes made directly to that file can be overwritten during updates, so instead the file should be copied into `/etc` and modified there:

```console
$ sudo cp /usr/share/logwatch/default.conf/logwatch.conf /etc/logwatch/conf/
```

With your favorite editor, open `/etc/logwatch/conf/logwatch.conf`. The uncommented lines indicate the default configuration values. First, lets customize some of the basics:

```text
Output = mail
MailTo = me@mydomain.org
MailFrom = logwatch@host1.mydomain.org
Detail = Low
Service = All
```

This assumes you’ve already set up mail services on `host1` that will allow mail to be delivered to your `me@mydomain.org` address. These emails will be addressed from `logwatch@host1.mydomain.org`.

The **Detail** level defines how much information is included in the reports. Possible values are: `Low`, `Medium`, and `High`.

Logwatch will then monitor logs for all services on the system, unless specified otherwise with the **Service** parameter. If there are undesired services included in the reports, they can be disabled by removing them with additional **Service** fields. E.g.:

```text
Service = "-http"
Service = "-eximstats"
```

Next, run `logwatch` manually to verify your configuration changes are valid:

```console
$ sudo logwatch --detail Low --range today
```

## Further reading

- The Ubuntu *[logwatch(8)](https://manpages.ubuntu.com/manpages/resolute/man8/logwatch.8.html)* manual page contains many more detailed options.

---

> 来源：https://ubuntu.com/server/docs/how-to/observability/install-logwatch/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
