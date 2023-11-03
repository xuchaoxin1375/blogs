# linux_apt 卸载清理

- [uninstall - How can you completely remove a package? - Ask Ubuntu](https://askubuntu.com/questions/151941/how-can-you-completely-remove-a-package)

## apt 清理相关命令



- 卸载某个包(`apt remove`)

- apt autoremove

  - 清理依赖

  - ```bash
      autoremove (apt-get(8))
               autoremove is used to remove packages that were automatically installed to
               satisfy dependencies for other packages and are now no longer needed as
               dependencies changed or the package(s) needing them were removed in the
               meantime.
    ```

### 示例(卸载与清理)

```
# cxxu_kali @ CxxuWin11 in ~ [20:09:02]
$ sudo apt list --installed|grep python
libpython3.9-dev/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
libpython3.9-minimal/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
libpython3.9-stdlib/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
libpython3.9/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
python3-dev/kali-rolling,now 3.9.8-1 amd64 [installed,automatic]
python3-distutils/kali-rolling,now 3.9.10-1 all [installed,automatic]
python3-lib2to3/kali-rolling,now 3.9.10-1 all [installed,automatic]
python3-minimal/kali-rolling,now 3.9.8-1 amd64 [installed,automatic]
python3-pip/kali-rolling,now 22.0.2+dfsg-1 all [installed]
python3-pkg-resources/kali-rolling,now 59.6.0-1.2 all [installed,automatic]
python3-setuptools/kali-rolling,now 59.6.0-1.2 all [installed,automatic]
python3-wheel/kali-rolling,now 0.37.1-2 all [installed,automatic]
python3.10-minimal/kali-rolling,now 3.10.2-1 amd64 [installed,auto-removable]
python3.9-dev/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
python3.9-minimal/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
python3.9/kali-rolling,now 3.9.12-1 amd64 [installed]
python3/kali-rolling,now 3.9.8-1 amd64 [installed,automatic]

# cxxu_kali @ CxxuWin11 in ~ [20:09:15]
$ sudo apt autoclean
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Del git-man 1:2.34.1-1 [1,903 kB]
Del git 1:2.34.1-1 [5,738 kB]
Del libcurl3-gnutls 7.81.0-1 [353 kB]
Del libexpat1 2.4.4-1 [106 kB]
Del openssh-client 1:8.8p1-1 [1,040 kB]

# cxxu_kali @ CxxuWin11 in ~ [20:10:47]
$ sudo apt autoremove
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be REMOVED:
  libpython3.10-minimal libpython3.10-stdlib python3.10-minimal
0 upgraded, 0 newly installed, 3 to remove and 109 not upgraded.
After this operation, 19.0 MB disk space will be freed.
Do you want to continue? [Y/n] y
(Reading database ... 39390 files and directories currently installed.)
Removing libpython3.10-stdlib:amd64 (3.10.2-1) ...
Removing python3.10-minimal (3.10.2-1) ...
Unlinking and removing bytecode for runtime python3.10
Removing libpython3.10-minimal:amd64 (3.10.2-1) ...
Processing triggers for man-db (2.10.2-1) ...

# cxxu_kali @ CxxuWin11 in ~ [20:10:58]
$ sudo apt autoremove

# cxxu_kali @ CxxuWin11 in ~ [20:11:15] C:130
$ sudo apt list --installed|grep python

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

libpython3-dev/kali-rolling,now 3.9.8-1 amd64 [installed,automatic]
libpython3-stdlib/kali-rolling,now 3.9.8-1 amd64 [installed,automatic]
libpython3.9-dev/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
libpython3.9-minimal/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
libpython3.9-stdlib/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
libpython3.9/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
python3-dev/kali-rolling,now 3.9.8-1 amd64 [installed,automatic]
python3-distutils/kali-rolling,now 3.9.10-1 all [installed,automatic]
python3-lib2to3/kali-rolling,now 3.9.10-1 all [installed,automatic]
python3-minimal/kali-rolling,now 3.9.8-1 amd64 [installed,automatic]
python3-pip/kali-rolling,now 22.0.2+dfsg-1 all [installed]
python3-pkg-resources/kali-rolling,now 59.6.0-1.2 all [installed,automatic]
python3-setuptools/kali-rolling,now 59.6.0-1.2 all [installed,automatic]
python3-wheel/kali-rolling,now 0.37.1-2 all [installed,automatic]
python3.9-dev/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
python3.9-minimal/kali-rolling,now 3.9.12-1 amd64 [installed,automatic]
python3.9/kali-rolling,now 3.9.12-1 amd64 [installed]
python3/kali-rolling,now 3.9.8-1 amd64 [installed,automatic]

# cxxu_kali @ CxxuWin11 in ~ [20:11:17]
```

### purge and autoremove

> *
> This is a very general answer to the question about the effects of purging packages. For advice specific to your situation, you'll have to edit your question to include additional information--in particular, the complete and exact text of the error message you are getting.*
>
> Removing packages with `sudo apt purge ***...\***` or `sudo apt --purge remove ***...\***` will remove them and all their global (i.e., systemwide) configuration files. This is usually what people mean when they talk about completely removing a package.
>
> But that doesn't mean your system is the same as it was before the package was installed. In particular:
>
> - This does not remove packages that were installed as dependencies, when you installed the package you're now removing. Assuming those packages aren't dependencies of any other packages, and that you haven't marked them as manually installed, you can remove the dependencies with `sudo apt autoremove` or (if you want to delete their systemwide configuration files too) `sudo apt --purge autoremove`.



### for example:

> - try to remove python3.9 completely

```bash
# cxxu_kali @ CxxuWin11 in ~ [20:21:58]
$ sudo apt purge python3.9
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  javascript-common libexpat1-dev libjs-jquery libjs-sphinxdoc libjs-underscore libmpdec3
  libpython3-dev libpython3-stdlib libpython3.9 libpython3.9-dev libpython3.9-minimal
  libpython3.9-stdlib media-types python3-minimal python3.9-minimal zlib1g-dev
Use 'sudo apt autoremove' to remove them.
The following packages will be REMOVED:
  python3* python3-dev* python3-distutils* python3-lib2to3* python3-pip*
  python3-pkg-resources* python3-setuptools* python3-wheel* python3.9* python3.9-dev*
0 upgraded, 0 newly installed, 10 to remove and 109 not upgraded.
After this operation, 12.1 MB disk space will be freed.
Do you want to continue? [Y/n] y
(Reading database ... 38760 files and directories currently installed.)
Removing python3-dev (3.9.8-1) ...
Removing python3-pip (22.0.2+dfsg-1) ...
Removing python3-wheel (0.37.1-2) ...
Removing python3-setuptools (59.6.0-1.2) ...
Removing python3-distutils (3.9.10-1) ...
Removing python3-pkg-resources (59.6.0-1.2) ...
Removing python3-lib2to3 (3.9.10-1) ...
dpkg: warning: while removing python3-lib2to3, directory '/usr/lib/python3.10' not empty so not removed
Removing python3.9-dev (3.9.12-1) ...
Removing python3 (3.9.8-1) ...
Removing python3.9 (3.9.12-1) ...
Processing triggers for man-db (2.10.2-1) ...
(Reading database ... 37530 files and directories currently installed.)
Purging configuration files for python3 (3.9.8-1) ...


#remove the dependencies

# cxxu_kali @ CxxuWin11 in ~ [20:22:11]
$ sudo apt list --installed|grep python

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

libpython3-dev/kali-rolling,now 3.9.8-1 amd64 [installed,auto-removable]
libpython3-stdlib/kali-rolling,now 3.9.8-1 amd64 [installed,auto-removable]
libpython3.9-dev/kali-rolling,now 3.9.12-1 amd64 [installed,auto-removable]
libpython3.9-minimal/kali-rolling,now 3.9.12-1 amd64 [installed,auto-removable]
libpython3.9-stdlib/kali-rolling,now 3.9.12-1 amd64 [installed,auto-removable]
libpython3.9/kali-rolling,now 3.9.12-1 amd64 [installed,auto-removable]
python3-minimal/kali-rolling,now 3.9.8-1 amd64 [installed,auto-removable]
python3.9-minimal/kali-rolling,now 3.9.12-1 amd64 [installed,auto-removable]
```

## 一步到位(sudo apt --purge autoremove)

- `sudo apt-get purge --auto-remove packagename`

## 逐步操作

> - 之前未卸载干净时的清理
>   - remove
>   - purge
>   - autoremove
>   - autoclean

### Remove a package:(step by step)

- Get the package complete name:


```
dpkg --list | grep partial_package_name*
```

- Remove the package:


```
sudo apt-get remove package_name
```

- Remove all the dependencies:


```
sudo apt-get purge package_name
```

- Remove the unneeded packages that were once installed as a dependency:


```
sudo apt-get autoremove
```

- Remove the retrieved packages from the local cache:


```
sudo apt-get autoclean
```

- Check that it was completely removed:


```
dpkg --list | grep partial_package_name*
```

