FROM archlinux:base-devel

# set build folder
WORKDIR /pkg
ENV PKGDEST /pkg
ENV SRCDIR /tmp

# create pkgbuilder user
RUN useradd -m -g wheel -s /bin/sh pkgbuilder && \
    echo "pkgbuilder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R pkgbuilder: ${PKGDEST}

# install dependencies for version-controlled packagees
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm \
        git \
        mercurial \
        subversion \
        && \
    find /var/cache/pacman/ -type f -delete

USER pkgbuilder
ENTRYPOINT ["makepkg", "--cleanbuild", "--force", "--noconfirm", "--syncdeps"]
CMD []
