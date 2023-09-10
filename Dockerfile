FROM archlinux:base-devel as base

# create pkgbuilder user
RUN useradd -m -g wheel -s /bin/sh pkgbuilder && \
    echo "pkgbuilder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# install yay
RUN pacman -Sy --noconfirm
USER pkgbuilder
ADD --chown=pkgbuilder:wheel https://aur.archlinux.org/yay-bin.git#master /tmp/yay-bin/
RUN cd /tmp/yay-bin && \
    makepkg -si --noconfirm

FROM archlinux:base-devel
ENV PKGDEST /pkg
ENV SRCDEST /tmp
ENV SRCINFO 0

# set build folder
WORKDIR /pkg

# copy files from base stage
COPY --from=base /etc/group /etc/passwd /etc/sudoers /etc/shadow /etc/
COPY --from=base --chown=pkgbuilder:wheel /home/pkgbuilder /home/pkgbuilder
COPY --from=base /usr/sbin/yay /usr/sbin/

# initialize pacman keyring
RUN pacman-key --init

# install dependencies
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm \
        archlinux-keyring \
        git \
        glibc \
        mercurial \
        namcap \
        subversion \
        && \
    find /var/cache/pacman/ -type f -delete

# copy entrypoint script
COPY --link entrypoint.sh /

USER pkgbuilder
ENTRYPOINT ["/entrypoint.sh"]
CMD []
