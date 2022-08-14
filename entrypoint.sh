#!/bin/bash

function build {
    # install dependencies and build package
    yay -S --noconfirm $(\
        makepkg --printsrcinfo | \
        grep -E '\b(make)?depends' | \
        awk '{print $3}'\
    )
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
