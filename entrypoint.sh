#!/bin/bash

function build {
    # install missing PGP keys
    for key in $(\
        makepkg --printsrcinfo | \
        grep validpgpkeys | \
        awk '{print $3}' \
    ); do
        sudo pacman-key --recv-keys "${key}"
    done
    # install dependencies
    yay -S --noconfirm $(\
        makepkg --printsrcinfo | \
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
