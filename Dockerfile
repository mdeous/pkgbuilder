# syntax=docker/dockerfile:1
FROM archlinux:base-devel as base

# create pkgbuilder user
RUN useradd -m -g wheel -s /bin/sh pkgbuilder && \
    echo "pkgbuilder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# install git
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm git

# install yay
USER pkgbuilder
RUN git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && \
    cd /tmp/yay-bin && \
    makepkg -si --noconfirm

FROM archlinux:base-devel

# set build folder
WORKDIR /pkg
ENV PKGDEST /pkg
ENV SRCDEST /tmp

# copy files from base stage
COPY --from=base /etc/group /etc/passwd /etc/sudoers /etc/shadow /etc/
COPY --from=base --chown=pkgbuilder:wheel /home/pkgbuilder /home/pkgbuilder
COPY --from=base /usr/sbin/yay /usr/sbin/

# copy entrypoint script
COPY --link entrypoint.sh /

# install dependencies for version-controlled packagees
RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm \
        git \
        mercurial \
        subversion \
        && \
    find /var/cache/pacman/ -type f -delete

USER pkgbuilder
ENTRYPOINT ["/entrypoint.sh"]
CMD []
