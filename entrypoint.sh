#!/bin/bash

SRCINFO="${SRCINFO:-0}"
CLEANUP="${CLEANUP:-1}"

function build {
    # update pacman cache
    sudo pacman -Syq
    # update pacman keyring
    sudo pacman -Sq --noconfirm --needed archlinux-keyring
    # install missing PGP keys
    for key in $(\
        makepkg --printsrcinfo | \
        grep validpgpkeys | \
        awk '{print $3}' \
    ); do
        sudo pacman-key --recv-keys "${key}"
    done
    # install dependencies
    yay -Sq --noconfirm --needed $(\
        makepkg --printsrcinfo | \
        grep -E '\b(make)?depends' | \
        awk '{print $3}'\
    )
    # generate SRCINFO
    if [ "${SRCINFO}" = "1" ]; then
        makepkg --printsrcinfo > .SRCINFO
    fi
    # build package
    makepkg_args=(--cleanbuild --force --noconfirm)
    if [ "${CLEANUP}" = "1" ]; then
        makepkg_args+=(--clean)
    fi
    makepkg ${makepkg_args[@]} $@
    # check package
    namcap ./*.pkg.tar.zst
}

cmd="${1}"
case "${cmd}" in
    makepkg)
        # run makepkg directly
        shift
        makepkg $@
        ;;
    build)
        # install deps and build
        shift
        build $@
        ;;
    *)
        # install deps and build
        build $@
        ;;
esac
