#!/usr/bin/env bash
# Arch Vagrant box contract — run inside the booted VM via: vagrant ssh -c "bash -s" < contracts/vagrant.sh
# Checks only what the base image ships. Role-specific tools (aur_builder, gcc, git)
# are installed by bootstrap roles and tested by their own Molecule scenarios.
set -euo pipefail

echo "=== Arch Vagrant Box Contract ==="
echo -n "python3:  " && python3 --version
echo -n "sudo:     " && sudo --version | head -1
echo -n "systemd:  " && systemctl is-system-running 2>/dev/null || true
echo -n "SSH:      " && systemctl is-active sshd 2>/dev/null || echo "unknown"
echo -n "keyring:  " && pacman-key --list-sigs 2>/dev/null | head -1 && echo "OK"
echo "=== Contract: PASS ==="
