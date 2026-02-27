FROM archlinux:base

ENV container=docker

# Full system update + Ansible requirements (python, sudo)
RUN pacman -Syu --noconfirm python sudo && \
    rm -rf /var/cache/pacman/pkg/*

# Restore glibc locale data stripped by NoExtract in the base image.
# Required by roles that call locale-gen (e.g., the locale role).
RUN sed -i '/^NoExtract/d' /etc/pacman.conf && \
    pacman -S --noconfirm --overwrite='*' glibc && \
    rm -rf /var/cache/pacman/pkg/*

# AUR build toolchain: needed by yay, zen_browser, hostctl, etc.
RUN pacman -S --noconfirm base-devel git && \
    rm -rf /var/cache/pacman/pkg/*

# Non-root AUR builder with passwordless pacman sudo
RUN useradd -r -s /usr/bin/nologin aur_builder && \
    echo 'aur_builder ALL=(root) NOPASSWD: /usr/bin/pacman' \
      > /etc/sudoers.d/aur_builder && \
    chmod 0440 /etc/sudoers.d/aur_builder

# Trim unnecessary systemd units so systemd starts cleanly inside Docker.
# Keep only systemd-tmpfiles-setup.service from sysinit.target.wants.
RUN (for i in /lib/systemd/system/sysinit.target.wants/*; do \
      [ "$i" = "/lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup.service" ] \
        || rm -f "$i"; \
    done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/*

STOPSIGNAL SIGRTMIN+3
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/lib/systemd/systemd"]
