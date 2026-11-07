<a id="install-nginx"></a>

# How to install nginx

The nginx HTTP server is a powerful alternative to [Apache](install-apache2.md#install-apache2). In this guide, we will demonstrate how to install and use nginx for web services.

## Install nginx

To install nginx, enter the following command at the terminal prompt:

```console
$ sudo apt update && sudo apt install nginx
```

This will also install any required dependency packages, and some common mods for your server, and then start the nginx web server.

### Verify nginx is running

You can verify that nginx is running via this command:

```console
$ sudo systemctl status nginx
```

### Restarting nginx

To restart nginx, run:

```console
$ sudo systemctl restart nginx
```

### Enable/disable nginx manually

By default, Nginx will automatically start at boot time. To disable this behavior so that you can start it up manually, you can disable it:

```console
$ sudo systemctl disable nginx
```

Then, to re-enable it, run:

```console
$ sudo systemctl enable nginx
```

### The default nginx homepage

A default nginx home page is also set up during the installation process. You can load this page in your web browser using your web server’s IP address; http://*your_server_ip*.

The default home page should look similar to:

```text
                                                                                        Welcome to nginx!
                                              Welcome to nginx!

If you see this page, the nginx web server is successfully installed and working. Further configuration is
required.

For online documentation and support please refer to nginx.org.
Commercial support is available at nginx.com.

Thank you for using nginx.
```

### Setting up nginx

For more information on customizing nginx for your needs, see these follow-up guides:

- Part 2: [How to configure nginx](configure-nginx.md#configure-nginx)

- Part 3: [How to use nginx modules](use-nginx-modules.md#use-nginx-modules)

### Further reading

- The [nginx documentation](https://nginx.org/en/docs/) provides detailed explanations of configuration directives.

- O’Reilly’s nginx cookbook provides guidance on solving specific needs

---

> 来源：https://ubuntu.com/server/docs/how-to/web-services/install-nginx/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
