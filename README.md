# pkgbuilder

Docker based ArchLinux build environment.

## Introduction

This docker image provides a minimal ArchLinux package build environment to build packages custom `PKGBUILD` files.
It can be useful to find dependencies missing from the `PKGBUILD` that might already be installed on the host machine.

Unde the hood, the package is built using `makepkg -scCf --noconfirm`.

## Usage

Run the `pkgbuilder` image with the folder containing your `PKGBUILD` file mounted on the container's `/pkg` folder:

```shell
docker run --rm -v "$(pwd):/pkg" mdeous/pkgbuilder
```

Additional arguments can be passed to `makepkg`, for example to display the content of the `.SRCINFO` file in order to upload the package to AUR:

```shell
docker run --rm -v "$(pwd):/pkg" mdeous/pkgbuilder --printsrcinfo
```
