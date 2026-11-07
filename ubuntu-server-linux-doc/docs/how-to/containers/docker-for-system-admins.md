# Docker for system admins

We are going to explore set-ups for configuring storage, networking, and logging in the subsequent sections. This will also help you get familiarized with Docker command line interface (CLI).

## Installation

First, install Docker if it’s not already installed:

```console
$ sudo apt-get install -y docker.io docker-compose
```

> **Note**
>
> This guide uses the Docker packages provided by Ubuntu (`docker.io`), which are supported by Canonical. The instructions and examples below are written for these packages.
>
> Canonical also provides a [Docker snap](https://snapcraft.io/docker). This guide does not cover the snap installation path.

## Configuring storage

### How to configure volumes

- Create a volume

  ``` console

  $ docker volume create my-vol
  ```

- List volumes

  ``` console

  $ docker volume ls
  ```

- Inspect volume

  ``` console

  $ docker volume inspect my-vol
  ```

- Run a container and mount a volume

  ``` console

  $ docker run --name web-server -d \
  > --mount source=my-vol,target=/app \
  > ubuntu/apache2
  ```

- Inspect your container to make sure the volume is mounted correctly:

  ``` console

  $ docker inspect web-server --format '{{ json .Mounts }}' | jq .
  ```

  By default, all your volumes will be stored in `/var/lib/docker/volumes`.

- Stop and remove the container, then remove its volume.

  ``` console

  $ docker stop web-server
  ```

  ``` console

  $ docker rm web-server
  ```

  ``` console

  $ docker volume rm my-vol
  ```

### How to configure bind mounts

- Create a Docker container and bind mount your host directory:

  ``` console

  $ docker run -d \
  > --name web-server \
  > --mount type=bind,source="$(pwd)",target=/app \
  > ubuntu/apache2
  ```

- Inspect your container to check for the bind mount:

  ``` console

  $ docker inspect web-server --format '{{ json .Mounts }}' | jq .
  ```

- Stop and remove the container

  ``` console

  $ docker stop web-server
  ```

  ``` console

  $ docker rm web-server
  ```

### How to configure tmpfs

- Create a Docker container and mount a tmpfs:

  ``` console

  $ docker run --name web-server -d \
  > --mount type=tmpfs,target=/app \
  > ubuntu/apache2
  ```

- Inspect your container to check for the tmpfs mount:

  ``` console

  $ docker inspect web-server --format '{{ json .Mounts }}' | jq .
  ```

### Choosing the right containerd snapshotter

Before changing the configuration and restarting the daemon, make sure that the specified filesystem (zfs, btrfs, or device mapper) is mounted at `/var/lib/docker`. Otherwise, if you configure the Docker daemon to use a storage driver different from the filesystem mounted at `/var/lib/docker`, a failure will happen. The Docker daemon expects that `/var/lib/docker` is correctly set up when it starts.

- Ensure the required filesystem is available. We will be using the ZFS filesystem.

  Set the default mount point:

  ``` console

  $ export MOUNT_POINT="/var/lib/containerd/io.containerd.snapshotter.v1.zfs"
  ```

  Install ZFS:

  ``` console

  $ apt install zfsutils-linux -y
  ```

  Create a 5GB file to use as a ZFS pool:

  ``` console

  $ fallocate -l 5G /zfs-pool.img
  ```

  Create the pool:

  ``` console

  $ sudo zpool create mypool /zfs-pool.img
  ```

  Create the ZFS dataset and mount it to your chosen mount point:

  ``` console

  $ sudo zfs create -o mountpoint=$MOUNT_POINT mypool/docker
  ```

  Verify that it mounted successfully:

  ``` console

  $ sudo zfs list
  ```

- Check the existing snapshotter.

  ``` console

  $ docker info | grep "Storage Driver"
  ```

  ``` console

  $ docker info | grep "driver-type"
  ```

- Change the snapshotter

  1.  Stop the docker daemon

      ``` console

      $ systemctl stop docker
      ```

  2.  If you’re using a non-default mount point, set that in `/etc/containerd/config.toml` to configure the snapshotter:

      ``` toml
      [plugins."io.containerd.snapshotter.v1.zfs"]
      root_path = "/my/cool/new/mount/point.zfs"
      ```

  3.  Edit the docker config itself at `/etc/docker/daemon.json`:

      ``` json
      {
        "storage-driver": "zfs"
      }
      ```

  4.  Restart the docker daemon

      ``` console

      $ systemctl restart docker
      ```

- Verify the change

  ``` console

  $ docker info | grep "Storage Driver"
  > Storage Driver: zfs
  ```

  ``` console

  $ docker info | grep "driver-type"
  ```

## Configuring networking

This is how you can create a user-defined network using the Docker CLI:

- Create a network

  ``` console

  $ docker network create --driver bridge my-net
  ```

- List networks

  ``` console

  $ docker network ls
  ```

- Inspect the network we created

  ``` console

  $ docker network inspect my-net
  ```

Containers can connect to a defined network when they are created (via `docker run`) or at any time of its lifecycle.

### Connecting a new container to an existing network

```console
$ docker run -d --name c1 --network my-net ubuntu/apache2
```

- View the network connected to the container

  ``` console

  $ docker inspect c1 --format '{{ json .NetworkSettings }}' | jq .
  ```

### Connecting a running container to an existing network

- Make a running container connect to the existing network

  1.  Create the container

      ``` console

      $ docker run -d --name c2 ubuntu/nginx
      ```

  2.  Connect the running container to the network and verify that it’s connected.

      ``` console

      $ docker network connect my-net c2
      ```

      ``` console

      $ docker inspect c2 --format '{{ json .NetworkSettings }}' | jq .
      ```

The container c2 is connected to two networks `bridge` and `my-net`.

The default network created by the Docker daemon is called `bridge` using the **bridge network driver**.

### Modifying the default network “bridge”

- A system administrator can modify this default networks IP address by editing `/etc/docker/daemon.json` and including the below into the JSON object

  ``` console

  $ vim /etc/docker/daemon.json
  ```

- Restart the Docker daemon

  ``` console

  $ systemctl restart docker
  ```

- Verify your changes

  ``` console

  $ docker network inspect bridge
  ```

### Exposing a container port to the host

After deciding how you are going to manage the network and selecting the most appropriate driver, there are some specific deployment details that a system administrator has to bear in mind when running containers.

Exposing ports of any system is always a concern, since it increases the surface for malicious attacks. For containers, we also need to be careful, analysing whether we really need to publish ports to the host. For instance, if the goal is to allow containers to access a specific port from another container, there is no need to publish any port to the host. This can be solved by connecting all the containers to the same network. You should publish ports of a container to the host only if you want to make it available to non-Docker workloads. When a container is created no port is published to the host, the option `--publish` (or `-p`) should be passed to `docker run` or `docker create` listing which port will be exposed and how.

The `--publish` option of Docker CLI accepts the following options:

- First, the host port that will be used to publish the container’s port. It can also contain the IP address of the host. For example, `0.0.0.0:8080`.

- Second, the container’s port to be published. For example, `80`.

- Third (optional), the type of port that will be published which can be TCP or UDP. For example, `80/tcp` or `80/udp`.

An example of how to publish port `80` of a container to port `8080` of the host:

- Create a container and expose it’s port to the host

  ``` console

  $ docker run -d --name web-server --publish 8080:80 ubuntu/nginx
  ```

- View the container’s network settings

  ``` console

  $ docker inspect web-server --format '{{ json .NetworkSettings.Ports }}' | jq .
  ```

The `HostIp` values are `0.0.0.0` (IPv4) and `::` (IPv6), and the service running in the container is accessible to everyone in the network (reaching the host), if you want to publish the port from the container and let the service be available just to the host you can use `--publish 127.0.0.1:8080:80` instead. The published port can be TCP or UDP and one can specify that passing `--publish 8080:80/tcp` or `--publish 8080:80/udp`.

The system administrator might also want to manually set the IP address or the [hostname](../../reference/glossary.md#term-hostname) of the container. To achieve this, one can use the `--ip` (IPv4), `--ip6` (IPv6), and `--hostname` options of the `docker network connect` command to specify the desired values.

Another important aspect of networking with containers is the [DNS](../../reference/glossary.md#term-DNS) service. By default containers will use the DNS setting of the host, defined in `/etc/resolv.conf`. Therefore, if a container is created and connected to the default `bridge` network it will get a copy of host’s `/etc/resolv.conf`. If the container is connected to a user-defined network, then it will use Docker’s embedded DNS server. The embedded DNS server forwards external DNS lookups to the DNS servers configured on the host. In case the system administrator wants to configure the DNS service, the `docker run` and `docker create` commands have options to allow that, such as `--dns` (IP address of a DNS server) and `--dns-opt` (key-value pair representing a DNS option and its value). For more information, check the manual pages of those commands.

## Managing logs

The default logging driver is called `json file`, and the system administrator can change it to suite their needs.

### Modifying the logging driver via the docker daemon file

- Edit the docker daemon file and update the logging driver

  ``` console

  $ vim /etc/docker/daemon.json
  ```

### Modifying the logging driver when creating a container

Another option is specifying the logging driver during container creation time:

- Specify a log driver when executing a `docker run`

  ``` console

  $ docker run -d --name web-server --log-driver=journald ubuntu/nginx
  ```

- Verify your configuration

  ``` console

  $ docker inspect web-server --format '{{ json .HostConfig.LogConfig }}' | jq .
  ```

- View logs

  ``` console

  $ docker logs web-server
  ```

Depending on the driver you might also want to pass some options. You can do that via the CLI, passing `--log-opt` or in the daemon config file adding the key `log-opts`. For more information check the [logging driver documentation](https://docs.docker.com/engine/logging/configure/).

Docker CLI also provides the `docker logs` and `docker service logs` commands which allows one to check for the logs produced by a given container or service (set of containers) in the host. However, those two commands are functional only if the logging driver for the containers is `json-file`, `local` or `journald`. They are useful for debugging in general, but there is the downside of increasing the storage needed in the host.

The remote logging drivers are useful to store data in an external service/host, and they also avoid spending more disk space in the host to store log files. Nonetheless, sometimes, for debugging purposes, it is important to have log files locally. Considering that, Docker has a feature called “dual logging”, which is enabled by default, and even if the system administrator configures a logging driver different from `json-file`, `local` and `journald`, the logs will be available locally to be accessed via the Docker CLI. If this is not the desired behavior, the feature can be disabled in the `/etc/docker/daemon.json` file:

```json
{
  "log-driver": "syslog",
  "log-opts": {
    "cache-disabled": "true",
    "syslog-address": "udp://1.2.3.4:1111"
  }
}
```

The option `cache-disabled` is used to disable the “dual logging” feature. If you try to run `docker logs` with that configuration you will get the following error:

```console
$ docker logs web-server
```

## Rootless Docker

Starting in Ubuntu 26.04 (package version `docker.io-app_29.1.3-0ubuntu4`), Docker supports running both containers and the Docker daemon itself as a non-root user. This is a useful way to provide extra security if it is not desirable to run the Docker daemon as root. As long as the prerequisites are all met, you do not need root privileges to convert a rootful Docker installation into a rootless one.

### Prerequisites

Install the following packages:

```console
$ sudo apt install rootlesskit uidmap slirp4netns fuse-overlayfs
```

- `rootlesskit`: A tool for running rootless containers.

- `uidmap`: Provides `newuidmap` and `newgidmap` commands for managing UID and GID mappings.

- `slirp4netns`: Required for user-mode networking in rootless containers.

- `fuse-overlayfs`: User-space overlay filesystem for rootless containers.

Ensure that the user in question has at least 65,536 subordinate UIDs and GIDs. To check this, consult the `/etc/subuid` and `/etc/subgid` files:

```console
$ grep ^$(whoami): /etc/subuid
```

```console
$ grep ^$(whoami): /etc/subgid
```

Each of these should output a line like

```console
```

The second number is the number of subordinate UIDs or GIDs that the user has available. This value should be at least 65,536. If it is not, edit the `/etc/subuid` and `/etc/subgid` files to increase it.

### Installation

> **Note**
>
> If you are already running the rootful Docker daemon, disable it before proceeding:
>
> ``` console
>
> $ sudo systemctl disable --now docker.service docker.socket
> ```
>
> ``` console
>
> $ sudo rm /var/run/docker.sock
> ```

Ubuntu installs the scripts related to rootless Docker in `/usr/share/docker.io/contrib`. Run `dockerd-rootless-setuptool.sh` **as a non-root user** to install the rootless daemon:

```console
$ /usr/share/docker.io/contrib/dockerd-rootless-setuptool.sh install
```

This command also shows help if any of the prerequisites are not met.

After completing the installation, confirm Docker is running in rootless mode with `docker info` and checking the context:

```console
$ docker info | grep Context
```

### Persisting the rootless daemon

If you want to persist the rootless daemon across reboots and user logouts, enable the `docker` systemd user service and enable linger for your user:

```console
$ systemctl --user enable docker
```

```console
$ loginctl enable-linger $(whoami)
```

### Expose Docker API socket

Exposing the Docker API Socket allows you to control the rootless Docker daemon from another machine. After connecting to a remote host, commands such as `docker ps` or `docker compose` will execute there. This could be useful if you, for instance, have a powerful server and a weak laptop, and you want to run containers on the server while controlling them from the laptop.

#### Over SSH (recommended)

Ensure `$DOCKER_HOST` is set:

```console
$ ssh -l <REMOTEUSER> <REMOTEHOST> 'echo $DOCKER_HOST'
> unix:///run/user/1001/docker.sock
```

Run `docker` with `-H` set to the SSH connection string:

```console
$ docker -H ssh://<REMOTEUSER>@<REMOTEHOST> run ...
```

You can also create a Docker context to avoid specifying the remote host for every command:

```console
$ docker context create remote --docker "host=ssh://<REMOTEUSER>@<REMOTEHOST>"
```

```console
$ docker context use remote
```

#### Over TCP

Run `docker-rootless.sh` with `DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="-p 0.0.0.0:2376:2376/tcp"` and the following flags:

```console
$ DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="-p 0.0.0.0:2376:2376/tcp" /usr/share/docker.io/contrib/docker-rootless.sh \
>    -H tcp://0.0.0.0:2376 \
>    --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem
```

### Expose privileged ports

To expose ports less than 1024 (e.g 22 for SSH), set `CAP_NET_BIND_SERVICE` on the `rootlesskit` binary and restart the daemon:

```console
$ sudo setcap cap_net_bind_service=ep /usr/bin/rootlesskit
```

```console
$ systemctl --user restart docker
```

## Further reading

To read an explanatory guide to Docker storage, networking, and logging see:

- [Docker storage, networking, and logging](../../explanation/virtualisation/docker-storage-networking-and-logging.md#docker-storage-networking-and-logging)

---

> 来源：https://ubuntu.com/server/docs/how-to/containers/docker-for-system-admins/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
