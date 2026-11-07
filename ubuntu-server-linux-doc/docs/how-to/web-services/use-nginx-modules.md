<a id="use-nginx-modules"></a>

# How to use nginx modules

Like other web servers, nginx supports dynamically loaded modules to provide in-server support for programming languages, security mechanisms, and so on. Ubuntu provides a number of these modules as separate packages that are either installed simultaneously with nginx, or can be installed separately.

## Available modules

nginx will report the modules it has been built with via its `-V` option. A quick and dirty way to list the available modules is thus:

```console
$ nginx -V 2>&1 | tr -- - '\n' | grep _module
```

Many of these modules are built-in and thus are always available with nginx, but some exist as separate packages whose installation status can be checked via `apt`. For example:

```console
$ apt policy libnginx-mod-http-image-filter
```

`apt` can also be used to install the desired dynamic module:

```console
$ sudo apt install libnginx-mod-http-image-filter
```

## Enabling and disabling dynamic modules

Dynamic modules are automatically enabled and get reloaded by nginx on installation. If you need to manually disable an installed module, remove its file from the `/etc/nginx/modules-enabled` directory, for example:

```console
$ ls /etc/nginx/modules-*
```

```console
$ sudo mv /etc/nginx/modules-enabled/50-mod-http-image-filter.conf /etc/nginx/modules-available/
```

```console
$ service nginx restart
```

Note that built-in modules cannot be disabled/enabled.

## Configuring modules

The installed configuration file for an nginx module mainly consists of the dynamically-loaded binary library:

```text
## /etc/nginx/modules-enabled/50-mod-http-image-filter.conf
load_module modules/ngx_http_image_filter_module.so;
```

Note that you can also use the `load_module` parameter in your `/etc/nginx/nginx.conf` at the top level, if preferred for some reason.

To use a module for your website, its settings are specified in your server block. For example:

```text
location /img/ {
    image_filter resize 240 360;
    image_filter rotate 180;
    image_filter_buffer 16M;
    error_page   415 = /415.html;
}
```

### Further reading

You’ve completed the nginx guide! See the following resources for more in-depth information on further extending nginx’s capabilities:

- The [nginx documentation](https://nginx.org/en/docs/) provides detailed explanations of configuration directives.

- O’Reilly’s nginx cookbook provides guidance on solving specific needs.

---

> 来源：https://ubuntu.com/server/docs/how-to/web-services/use-nginx-modules/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
