# Introduction to web services

Web servers are used to serve web pages requested by client computers. Clients typically request and view web pages using web browser applications such as Firefox, Opera, Chromium, or Internet Explorer.

If you’re new to web servers, see this page for more information [on the key concepts](../web-services/about-web-servers.md#about-web-servers).

## Squid proxy server

Squid is a popular, open-source, proxy caching server that can help optimize network efficiency and improve response times by saving local copies of frequently accessed content. Read more [about Squid proxy servers](../web-services/about-squid-proxy-servers.md#about-squid-proxy-servers) and what they can do, or find out [how to install a Squid server](../../how-to/web-services/install-a-squid-server.md#install-a-squid-server).

## Web servers

Apache is a widely used web server on Linux systems, and the current version is Apache2. It is robust, reliable, and highly configurable. This set of guides will show you:

- [How to install and configure Apache2](../../how-to/web-services/install-apache2.md#install-apache2)

- [How to configure Apache2 for your needs](../../how-to/web-services/configure-apache2-settings.md#configure-apache2-settings)

- [How to extend Apache2’s functionality with modules](../../how-to/web-services/use-apache2-modules.md#use-apache2-modules)

Nginx is a popular alternative web server also widely used on Linux, with a focus on static file serving performance, ease of configuration, and use as both a web server and reverse proxy server.

- [How to install Nginx](../../how-to/web-services/install-nginx.md#install-nginx)

- [How to configure Nginx](../../how-to/web-services/configure-nginx.md#configure-nginx)

- [How to use Nginx modules](../../how-to/web-services/use-nginx-modules.md#use-nginx-modules)

## Database server

The database server, when included in the LAMP stack (Linux + Apache + MySQL + PHP/Perl/Python), allows data for web applications to be stored and managed. MySQL is one of the most popular open source Relational Database Management Systems (RDBMS) available, and you can find out in this guide [how to install MySQL](../../how-to/databases/install-mysql.md#install-mysql) – or [PostgreSQL](../../how-to/databases/install-postgresql.md#install-postgresql), as another popular alternative.

## Scripting languages

Server-side scripting languages allow for the creation of dynamic web content, processing of web forms, and interacting with databases (amongst other crucial tasks). PHP is often used, and we can show you [how to install PHP](../../how-to/web-services/install-php.md#install-php), or if you prefer, we can show you [how to install Ruby on Rails](../../how-to/web-services/install-ruby-on-rails.md#install-ruby-on-rails).

Whichever scripting language you choose, you will need to have installed and configured your web and database servers beforehand.

---

> 来源：https://ubuntu.com/server/docs/explanation/intro-to/web-servers/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
