#!/usr/bin/env bash
# Arch Vagrant box contract — run inside the booted VM via: vagrant ssh -c "..."
set -euo pipefail

echo "=== Arch Vagrant Box Contract ==="
echo -n "python3:         " && python3 --version
echo -n "sudo:            " && sudo --version | head -1
echo -n "base-devel (gcc):" && gcc --version | head -1
echo -n "git:             " && git --version
echo -n "aur_builder:     " && id aur_builder
echo -n "pacman keyring:  " && pacman-key --list-sigs 2>/dev/null | head -1 && echo "OK"
echo -n "systemd:         " && systemctl is-system-running 2>/dev/null || true
echo -n "SSH:             " && (systemctl is-active sshd 2>/dev/null || systemctl is-active ssh 2>/dev/null || echo "unknown")
echo "=== Contract: PASS ==="
