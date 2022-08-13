#!/bin/bash

cmd="${1}"
case "${cmd}" in
    makepkg)
        # run makepkg directly
        shift
        makepkg $@
        ;;
    *)
        # install dependencies and build package
        yay -S --noconfirm $(\
            makepkg --printsrcinfo | \
            grep -E '\b(make)?depends' | \
            awk '{print $3}'\
        )
        makepkg --clean --cleanbuild --force --noconfirm $@
        ;;
esac
