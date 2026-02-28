#!/usr/bin/env bash
# Arch Docker image contract — run inside container:
#   docker run --rm <image> bash contracts/docker.sh
set -euo pipefail

echo "=== arch-base Docker image contract ==="

# Core tools
echo -n "systemd:           " && test -x /usr/lib/systemd/systemd && echo "OK"
echo -n "python:            " && python --version
echo -n "sudo:              " && sudo --version | head -1
echo -n "gcc (base-devel):  " && gcc --version | head -1
echo -n "make (base-devel): " && make --version | head -1
echo -n "git:               " && git --version

# AUR builder user
echo -n "aur_builder user:  " && id aur_builder
echo -n "aur_builder sudo:  " && test -f /etc/sudoers.d/aur_builder && echo "OK"

# Locale data (required for en_US/ru_RU locale generation in bootstrap roles)
echo -n "locale SUPPORTED:  " && test -f /usr/share/i18n/SUPPORTED && echo "OK"
echo -n "locale en_US:      " && test -f /usr/share/i18n/locales/en_US && echo "OK"
echo -n "locale ru_RU:      " && test -f /usr/share/i18n/locales/ru_RU && echo "OK"
echo -n "locale-gen:        " && command -v locale-gen

# Systemd minimal (required for Molecule systemd driver)
echo -n "systemd-tmpfiles:  " && test -f /usr/lib/systemd/system/systemd-tmpfiles-setup.service && echo "OK"

echo "=== arch-base contract: PASS ==="
