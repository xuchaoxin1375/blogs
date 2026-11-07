<a id="install-drbd"></a>

# Distributed Replicated Block Device (DRBD)

Distributed Replicated Block Device (DRBD) mirrors block devices between multiple hosts. The replication is transparent to other applications on the host systems. Any block device hard disks, partitions, RAID devices, logical volumes, etc can be mirrored.

## Install DRBD

To get started using DRBD, first install the necessary packages. In a terminal window, run the following command:

```console
$ sudo apt install drbd-utils
```

> **Note**
>
> If you are using the **virtual kernel** as part of a virtual machine, the `drbd` module may not be available by default. On Ubuntu 25.04 and earlier, you can install `linux-modules-extra-$(uname -r)` to obtain additional kernel modules.
>
> Starting with Ubuntu 25.10 (Questing), the `linux-modules-extra-*` packages are no longer provided. All kernel modules are now provided by the `linux-modules-<version>-<flavor>` package, which is installed by default.

## Configure DRBD

This section covers setting up a DRBD to replicate a separate `/srv` partition, with an `ext3` [filesystem](../../reference/glossary.md#term-filesystem) between two hosts. The partition size is not particularly relevant, but both partitions need to be the same size.

The two hosts in this example will be called **`drbd01`** and **`drbd02`**. They will need to have name resolution configured either through [DNS](../../reference/glossary.md#term-DNS) or the `/etc/hosts` file. See our [guide to DNS](../networking/install-dns.md#install-dns) for details.

On the first host, edit `/etc/drbd.conf` as follows:

```text
global { usage-count no; }
common { syncer { rate 100M; } }
resource r0 {
        protocol C;
        startup {
                wfc-timeout  15;
                degr-wfc-timeout 60;
        }
        net {
                cram-hmac-alg sha1;
                shared-secret "secret";
        }
        on drbd01 {
                device /dev/drbd0;
                disk /dev/sdb1;
                address 192.168.0.1:7788;
                meta-disk internal;
        }
        on drbd02 {
                device /dev/drbd0;
                disk /dev/sdb1;
                address 192.168.0.2:7788;
                meta-disk internal;
        }
}
```

> **Note**
>
> There are many other options in `/etc/drbd.conf`, but for this example the default values are enough.

Now copy `/etc/drbd.conf` to the second host:

```console
$ scp /etc/drbd.conf drbd02:~
```

And, on `drbd02`, move the file to `/etc`:

```console
$ sudo mv drbd.conf /etc/
```

Now using the `drbdadm` utility, initialize the meta data storage. On both servers, run:

```console
$ sudo drbdadm create-md r0
```

Next, on both hosts, start the `drbd` daemon:

```console
$ sudo systemctl start drbd.service
```

On `drbd01` (or whichever host you wish to be the primary), enter the following:

```console
$ sudo drbdadm -- --overwrite-data-of-peer primary all
```

After running the above command, the data will start syncing with the secondary host. To watch the progress, on `drbd02` enter the following:

```console
$ watch -n1 cat /proc/drbd
```

To stop watching the output press <span class="kbd">Ctrl</span> + <span class="kbd">C</span>.

Finally, add a filesystem to `/dev/drbd0` and mount it:

```console
$ sudo mkfs.ext3 /dev/drbd0
```

```console
$ sudo mount /dev/drbd0 /srv
```

## Testing

To test that the data is actually syncing between the hosts copy some files on `drbd01`, the primary, to `/srv`:

```console
$ sudo cp -r /etc/default /srv
```

Next, unmount `/srv`:

```console
$ sudo umount /srv
```

Now demote the **primary** server to the **secondary** role:

```console
$ sudo drbdadm secondary r0
```

Now on the **secondary** server, promote it to the **primary** role:

```console
$ sudo drbdadm primary r0
```

Lastly, mount the partition:

```console
$ sudo mount /dev/drbd0 /srv
```

Using `ls` you should see `/srv/default` copied from the former primary host `drbd01`.

## Further reading

- For more information on DRBD see the [DRBD web site](https://linbit.com/linbit-software-download-page-for-linstor-and-drbd-linux-driver/).

- The *[drbd.conf(5)](https://manpages.ubuntu.com/manpages/resolute/man5/drbd.conf.5.html)* manual page contains details on the options not covered in this guide.

- Also, see the *[drbdadm(8)](https://manpages.ubuntu.com/manpages/resolute/man8/drbdadm.8.html)* manual page.

---

> 来源：https://ubuntu.com/server/docs/how-to/high-availability/install-drbd/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
