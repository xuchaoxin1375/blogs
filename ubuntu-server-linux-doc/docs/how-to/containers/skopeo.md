<a id="skopeo"></a>

# Skopeo for system admins

[Skopeo](https://github.com/containers/skopeo) works with container images and image registries. It needs no daemon and no root privileges. You can inspect a remote image before you deploy it, copy images between registries or into local storage, mirror whole repositories, and delete images from a registry.

## Install Skopeo

*[skopeo(1)](https://manpages.ubuntu.com/manpages/resolute/man1/skopeo.1.html)* is available in Ubuntu:

```console
$ sudo apt install skopeo
```

## Image names

Many Skopeo commands take an image name prefixed by a transport, which specifies where the image lives:

**docker://**

An image in a remote registry, for example `docker://docker.io/ubuntu:26.04`.

**docker-daemon:**

An image in the local Docker daemon storage.

**containers-storage:**

An image in the local storage used by [Podman](https://podman.io/) and [Buildah](https://buildah.io/).

**dir:**

An image unpacked into a local directory.

**oci: and oci-archive:**

An image in an [OCI](../../reference/glossary.md#term-OCI) layout directory or `tar` archive.

See *[containers-transports(5)](https://manpages.ubuntu.com/manpages/resolute/man5/containers-transports.5.html)* for the full list and the exact syntax of each transport.

## Inspect a remote image

*[skopeo-inspect(1)](https://manpages.ubuntu.com/manpages/resolute/man1/skopeo-inspect.1.html)* downloads only the image metadata, not its layers, so you can check what an image contains before you pull it:

```console
$ skopeo inspect docker://docker.io/ubuntu:26.04
```

You can use *[skopeo-list-tags(1)](https://manpages.ubuntu.com/manpages/resolute/man1/skopeo-list-tags.1.html)* to list the available tags in a repository.

```console
$ skopeo list-tags docker://docker.io/ubuntu
```

## Authenticate to a registry

Public images need no credentials. For a private registry, log in with *[skopeo-login(1)](https://manpages.ubuntu.com/manpages/resolute/man1/skopeo-login.1.html)*. Skopeo stores the credentials in `${XDG_RUNTIME_DIR}/containers/auth.json` (see *[containers-auth.json(5)](https://manpages.ubuntu.com/manpages/resolute/man5/containers-auth.json.5.html)*):

```console
$ skopeo login registry.example.com
```

Alternatively, pass credentials per command with `--creds user:password` (for `inspect` and `delete`), or `--src-creds` and `--dest-creds` (for `copy`).

Skopeo can also automatically use authentication credentials set by `docker login`, `podman login` or `buildah login`.

## Copy images

### Between registries

Copying an image into an internal registry with *[skopeo-copy(1)](https://manpages.ubuntu.com/manpages/resolute/man1/skopeo-copy.1.html)* doesn’t require a local daemon, and the image is never unpacked while copying:

```console
$ skopeo copy \
> docker://docker.io/ubuntu:26.04 \
> docker://registry.example.com/mirror/ubuntu:26.04
```

By default, Skopeo only copies the image that matches the architecture of your machine. Add `--all` to copy every architecture of a multi-architecture image.

Both `copy` and `sync` can sign the images they write with `--sign-by` or `--sign-by-sigstore`, but the signatures are only checked if you configure a trust policy. Refer to *[containers-policy.json(5)](https://manpages.ubuntu.com/manpages/resolute/man5/containers-policy.json.5.html)* and *[containers-registries.d(5)](https://manpages.ubuntu.com/manpages/resolute/man5/containers-registries.d.5.html)* for more details.

### To and from local storage

Copy a remote image into the local Docker daemon:

```console
$ skopeo copy docker://docker.io/ubuntu:26.04 docker-daemon:ubuntu:26.04
```

Or save it as an OCI archive:

```console
$ skopeo copy docker://docker.io/ubuntu:26.04 oci-archive:ubuntu-26.04.tar:ubuntu:26.04
```

The same command works in reverse, with the archive as the source and a registry as the destination.

## Mirror multiple images

`copy` handles one image at a time, while *[skopeo-sync(1)](https://manpages.ubuntu.com/manpages/resolute/man1/skopeo-sync.1.html)* copies a set of images in a single run and leaves out anything the destination already has. When using `sync`, specify the transports with `--src` and `--dest` instead of prefixing the image names.

To sync a single image, or a whole repository, into an internal registry:

```console
$ skopeo sync --src docker --dest docker docker.io/ubuntu:26.04 registry.example.com/mirror
```

A source repository without a tag syncs every tag in it.

You can also sync to a directory. The `--scoped` option keeps the source registry name in the path so that images from different registries cannot collide:

```console
$ skopeo sync --src docker --dest dir --scoped docker.io/ubuntu:26.04 /media/usb
```

This writes the image to `/media/usb/docker.io/library/ubuntu:26.04`. To sync it back into a registry, use `--src dir --dest docker`.

### Syncing from a YAML file

When you run the same mirror repeatedly, list the images in a [YAML](../../reference/glossary.md#term-YAML) file and pass `--src yaml`. You can name tags one by one, or match them with a regular expression:

```yaml
docker.io:
  images:
    ubuntu:
      - "24.04"
      - "26.04"
  images-by-tag-regex:
    nginx: ^1\.2[0-9]-alpine$
```

Check what a sync would do before you run it with `--dry-run`:

```console
$ skopeo sync --src yaml --dest docker --dry-run sync.yaml registry.example.com/mirror
```

Add `--keep-going` if you want the sync to carry on when one image fails instead of stopping.

## Delete an image from a registry

Use *[skopeo-delete(1)](https://manpages.ubuntu.com/manpages/resolute/man1/skopeo-delete.1.html)* to remove an image:

```console
$ skopeo delete docker://registry.example.com/mirror/ubuntu:26.04
```

This deletes the manifest, so the tag stops resolving. The registry only reclaims the layers when it runs garbage collection.

## Further reading

- [Skopeo upstream documentation](https://github.com/containers/skopeo)

- [Container tools in the Ubuntu space](../../explanation/virtualisation/container-tools-in-the-ubuntu-space.md#container-tools-in-the-ubuntu-space)

---

> 来源：https://ubuntu.com/server/docs/how-to/containers/skopeo/  
> 站点：Ubuntu Server documentation（canonical/ubuntu-server-documentation）
