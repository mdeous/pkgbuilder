#!/bin/bash

function build {
    # read package metadata
    local srcinfo=$(makepkg --printsrcinfo)
    # install missing PGP keys
    sudo pacman-key --recv-keys $(\
        echo ${srcinfo} | \
        grep validpgpkeys | \
        awk '{print $3}' \
    )
    # install dependencies
    yay -S --noconfirm $(\
        echo ${srcinfo} | \
        grep -E '\b(make)?depends' | \
        awk '{print $3}'\
    )
    # build package
    makepkg --clean --cleanbuild --force --noconfirm $@
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
