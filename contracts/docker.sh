#!/usr/bin/env bash
# Arch Docker image contract — run inside container:
#   docker run --rm <image> sh -c "$(cat contracts/docker.sh)"
set -euo pipefail

echo "=== Arch Docker Image Contract ==="
echo -n "systemd:          " && test -x /usr/lib/systemd/systemd && echo "OK"
echo -n "python:           " && python --version
echo -n "sudo:             " && sudo --version | head -1
echo -n "gcc (base-devel): " && gcc --version | head -1
echo -n "git:              " && git --version
echo -n "aur_builder:      " && id aur_builder
echo -n "locale SUPPORTED: " && test -f /usr/share/i18n/SUPPORTED && echo "OK"
echo -n "locale en_US:     " && test -f /usr/share/i18n/locales/en_US && echo "OK"
echo -n "locale-gen:       " && command -v locale-gen
echo "=== Contract: PASS ==="
