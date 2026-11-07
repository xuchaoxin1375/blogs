<a id="create-vms-with-multipass"></a>

# How to create a VM with Multipass

[Multipass](https://canonical.com/multipass) is the recommended method for creating Ubuntu VMs on Ubuntu. It’s designed for developers who want a fresh Ubuntu environment with a single command, and it works on Linux, Windows and macOS.

On Linux it’s available as a snap:

```console
$ sudo snap install multipass
```

If you’re running an older version of Ubuntu where `snapd` isn’t pre-installed, you will need to install it first:

```console
$ sudo apt update && sudo apt install snapd
```

## Find available images

To find available images you can use the `multipass find` command, which will produce a list like this:

```console
```

## Launch a fresh instance of Ubuntu 26.04 LTS

You can launch a fresh instance by specifying either the image name from the list (in this example, 26.04) or using an alias, if the image has one.

```console
$ multipass launch 26.04
```

This command is equivalent to: `multipass launch resolute` or `multipass launch lts` in the list above. It will launch an instance based on the specified image, and provide it with a random name – in this case, `cleansing-guanaco`.

## Check out the running instances

You can check out the currently running instance(s) by using the `multipass list` command:

```console
$ multipass list
```

## Learn more about the VM instance you just launched

You can use the `multipass info` command to find out more details about the VM instance parameters:

```console
$ multipass info cleansing-guanaco
```

## Connect to a running instance

To enter the VM you created, use the `shell` command:

```console
$ multipass shell cleansing-guanaco
```

### Disconnect from the instance

Don’t forget to log out (or <span class="kbd">Ctrl</span> + <span class="kbd">D</span>) when you are done, or you may find yourself heading all the way down the Inception levels…

## Run commands inside an instance from outside

```console
$ multipass exec cleansing-guanaco -- lsb_release -a
```

## Stop or start an instance

You can stop an instance to save resources using the `stop` command:

```console
$ multipass stop cleansing-guanaco
```

You can start it back up again using the `start` command:

```console
$ multipass start cleansing-guanaco
```

## Delete the instance

Once you are finished with the instance, you can delete it as follows:

```console
$ multipass delete cleansing-guanaco
```

It will now show up as deleted when you use the `list` command:

```console
$ multipass list
```

And when you want to completely get rid of it (and any other deleted instances), you can use the `purge` command:

```console
$ multipass purge
```

Which we can check again using `list`:

```console
$ multipass list
```

## Integrate with the rest of your virtualisation

If you already have a hypervisor interacting with [Libvirt](libvirt.md#libvirt), such as [QEMU](../../reference/glossary.md#term-QEMU), [KVM](../../reference/glossary.md#term-KVM), or [ESXi](../../reference/glossary.md#term-ESXi), you might be managing virtual machines through tools like [virt-manager](https://virt-manager.org/) or the older [uvtool](cloud-image-vms-with-uvtool.md#cloud-image-vms-with-uvtool).

In that case, integrating Multipass with your existing setup would allow VMs to share the same network bridge for communication and be managed using `virsh`. However, Multipass runs as a headless system, so you don’t have direct GUI access through virt-viewer. Follow this [guide](https://documentation.ubuntu.com/multipass/latest/how-to-guides/customise-multipass/set-up-a-graphical-interface/) to set up a GUI.

To begin, integrate Multipass into your existing setup by selecting `libvirt` as your local driver:

```console
$ sudo multipass set local.driver=libvirt
```

> **Note**
>
> If you are having issues interacting with Multipass after switching to the libvirt driver, check if there is a restriction by [AppArmor](../../reference/glossary.md#term-AppArmor), for example. AppArmor may have a default policy which restricts the Multipass service from interacting with the [libvirt service](https://libvirt.org/daemons.html). So you need to add an explicit permission that allows it.

Start a guest, and access it via tools like [virt-manager](https://virt-manager.org/) or `virsh`:

```console
$ multipass launch lts
```

```console
$ virsh list
```

For more detailed and comprehensive instructions on changing your drivers, refer to the [Multipass drivers documentation](https://documentation.ubuntu.com/multipass/latest/how-to-guides/customise-multipass/set-up-the-driver/).

## Get help

You can use the following commands on the CLI:

```console
$ multipass help
```

```console
$ multipass help <command>
```

```console
$ multipass help --all
```

Or, check out the [Multipass documentation](https://documentation.ubuntu.com/multipass/latest/) for more details on how to use it.

---

> 来源：https://ubuntu.com/server/docs/how-to/virtualisation/multipass/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
