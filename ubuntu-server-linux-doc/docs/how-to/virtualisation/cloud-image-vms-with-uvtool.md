<a id="cloud-image-vms-with-uvtool"></a>

# Create cloud image VMs with UVtool

With Ubuntu being one of the most popular operating systems on many cloud platforms, the availability of stable and secure cloud images has become very important. Since Ubuntu 12.04 LTS, the use of cloud images outside of a cloud infrastructure has been improved so that it is now possible to use those images to create a virtual machine without needing a complete installation.

## Creating virtual machines using `uvtool`

Starting with Ubuntu 14.04 LTS, a tool called `uvtool` has greatly facilitated the creation of virtual machines (VMs) using cloud images. `uvtool` provides a simple mechanism for synchronizing cloud images locally and using them to create new VMs in minutes.

## Install `uvtool` packages

The following packages and their dependencies are required in order to use `uvtool`:

- `uvtool`

- `uvtool-libvirt`

To install `uvtool`, run:

```console
$ sudo apt -y install uvtool uvtool-libvirt
```

This will install `uvtool`’s main commands, `uvt-simplestreams-libvirt` and `uvt-kvm`.

> **Note**
>
> You might need to log out and log in again to use libvirt without root privilege. If not, you might encounter a Permission denied error in the later steps.

## Get the Ubuntu cloud image with `uvt-simplestreams-libvirt`

This is one of the major simplifications that `uvtool` provides. It knows where to find the cloud images so you only need one command to get a new cloud image. For instance, if you want to synchronize all cloud images for the amd64 architecture, the `uvtool` command would be:

```console
$ uvt-simplestreams-libvirt --verbose sync arch=amd64
```

After all the images have been downloaded from the Internet, you will have a complete set of locally-stored cloud images. To see what has been downloaded, use the following command:

```console
$ uvt-simplestreams-libvirt query
```

In the case where you want to synchronize only one specific cloud image, you need to use the `release=` and `arch=` filters to identify which image needs to be synchronized.

```console
$ uvt-simplestreams-libvirt sync release=DISTRO-SHORT-CODENAME arch=amd64
```

Furthermore, you can provide an alternative URL to fetch images from. A common case is the daily image, which helps you get the very latest images, or if you need access to the not-yet-released development release of Ubuntu. As an example:

```console
$ uvt-simplestreams-libvirt sync --source http://cloud-images.ubuntu.com/daily [... further options]
```

## Create a valid SSH key

To connect to the virtual machine once it has been created, you must first have a valid SSH key available for the Ubuntu user. If your environment does not have an SSH key, you can create one using the `ssh-keygen` command:

```console
$ ssh-keygen
```

## Create the VM using `uvt-kvm`

To create a new virtual machine using `uvtool`, run the following in a terminal:

```console
$ uvt-kvm create firsttest
```

This will create a VM named `firsttest` using the current locally-available LTS cloud image. If you want to specify a release to be used to create the VM, you need to use the `release=` filter, and the short codename of the release, e.g. “jammy”:

```console
$ uvt-kvm create secondtest release=DISTRO-SHORT-CODENAME
```

The `uvt-kvm wait` command can be used to wait until the creation of the VM has completed:

```console
$ uvt-kvm wait secondttest
```

### Connect to the running VM

Once the virtual machine creation is completed, you can connect to it using SSH:

```console
$ uvt-kvm ssh secondtest
```

You can also connect to your VM using a regular SSH session using the IP address of the VM. The address can be queried using the following command:

```console
$ uvt-kvm ip secondtest
```

```console
$ ssh -i ~/.ssh/id_rsa ubuntu@192.168.122.199
```

## Get the list of running VMs

You can get the list of VMs running on your system with the `uvt-kvm list` command.

## Destroy your VM

Once you are finished with your VM, you can destroy it with:

```console
$ uvt-kvm destroy secondtest
```

> **Note**
>
> Unlike libvirt’s `destroy` or `undefine` actions, this will (by default) also remove the associated virtual storage files.

## More `uvt-kvm` options

The following options can be used to change some of the characteristics of the VM that you are creating:

- `--memory` : Amount of RAM in megabytes. Default: 512.

- `--disk` : Size of the OS disk in gigabytes. Default: 8.

- `--cpu` : Number of CPU cores. Default: 1.

Some other parameters will have an impact on the cloud-init configuration:

- `--password <password>` : Allows logging into the VM using the Ubuntu account and this provided password.

- `--run-script-once <script_file>` : Run `script_file` as root on the VM the first time it is booted, but never again.

- `--packages <package_list>` : Install the comma-separated packages specified in `package_list` on first boot.

A complete description of all available modifiers is available in the *[uvt-kvm(1)](https://manpages.ubuntu.com/manpages/resolute/man1/uvt-kvm.1.html)* manual pages.

---

> 来源：https://ubuntu.com/server/docs/how-to/virtualisation/cloud-image-vms-with-uvtool/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
