[![Build and ](https://github.com/mdeous/pkgbuilder/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/mdeous/pkgbuilder/actions/workflows/build.yml)

# pkgbuilder

Docker based ArchLinux build environment.

This image provides a build environment for ArchLinux packages. It is based
on the official `archlinux:basee-devel` image, and can be used for example to
work on packages without having to install dependencies on the host system.

It can handle dependencies coming both from the official repositories and
from AUR, as well as importing PGP keys listed in `validpgpkeys` .

## Usage

Run the image with the folder containing your `PKGBUILD` file mounted on the
container's `/pkg` folder:

```shell
docker run -it --rm -v "$(pwd):/pkg" mdeous/pkgbuilder [build|makepkg] [ARGS]
```

* `build`: the container will install all the build dependencies using
[`yay`](https://github.com/Jguer/yay), and will then build the package
using `makepkg --clean --cleanbuild --force --noconfirm`. Any additional
arguments will be added to the call to `makepkg`. The resulting built
package will be stored alongside the `PKGBUILD` file.

* `makepkg`: the container will run `makepkg` directly and pass all
remaining arguments to it. This can be useful to run `makepkg` commands
that don't require dependencies to be installed, like for example to
show the package `.SRCINFO` content, or to compute dependencies checksums.

* If neither `build` nor `makepkg` is passed, the container will run the
`build` and pass all additional arguments to it.

### Shell Alias

To avoid having to type that long command line to run the container every
time, the following shell alias can be used:

```bash
alias pkgbuilder='docker run -it --rm --name="pkgbuilder-$(basename ${PWD})" -v "${PWD}":/pkg mdeous/pkgbuilder:latest'
```
