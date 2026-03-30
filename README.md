[![Build](https://github.com/mdeous/pkgbuilder/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/mdeous/pkgbuilder/actions/workflows/build.yml)

# pkgbuilder

Docker based ArchLinux build environment.

This image provides a build environment for ArchLinux packages. It is based
on the official `archlinux:base-devel` image, and can be used to work on
packages without having to install dependencies on the host system, ensuring
the package definition is not missing a dependency that might already be
installed on the host.

It can handle dependencies coming both from the official repositories and
from AUR, as well as import PGP keys listed in `validpgpkeys` .

## Usage

Run the image with the folder containing your `PKGBUILD` file mounted on the
container's `/pkg` folder:

```shell
docker run --rm -v "$(pwd):/pkg" mdeous/pkgbuilder [build|makepkg] [ARGS]
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

* If neither `build` nor `makepkg` are passed, the container will run the
`build` command and pass all additional arguments to it.

At the end of the execution, the built package will be analyzed with
[`namcap`](https://wiki.archlinux.org/title/namcap) and results are
displayed.

Additionally, the `.SRCINFO` file for the package can be automatically
generated with the built package by passing `SRCINFO=1` as an environment
variable to the container.

### Shell Alias

To avoid having to type that long command line to run the container every
time, the following shell alias can be used:

```bash
alias pkgbuilder='docker run --rm --name="pkgbuilder-$(basename ${PWD})" -v "${PWD}":/pkg mdeous/pkgbuilder:latest'
```
