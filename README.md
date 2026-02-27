# arch-images

Builds Arch Linux images for CI and development:

- **Docker image** (`ghcr.io/textyre/arch-molecule`) — for Molecule Docker scenarios
- **Vagrant box** (`arch-molecule-latest.box`) — for Molecule Vagrant/KVM scenarios

Both images include: Python, sudo, base-devel, git, aur_builder user, fresh pacman keyring.

## Artifacts

| Artifact | Location | Updated |
|---|---|---|
| Docker image | `ghcr.io/textyre/arch-molecule:latest` | Weekly (Monday 02:00 UTC) |
| Vagrant box | [GitHub Releases → `boxes`](../../releases/tag/boxes) | Weekly (Monday 02:00 UTC) |

## Image Contracts

### Docker (`contracts/docker.sh`)
- systemd as PID 1
- python, sudo
- base-devel (gcc, make, …), git
- aur_builder system user with passwordless pacman sudo
- glibc locale data (for `locale` role testing)

### Vagrant (`contracts/vagrant.sh`)
- python3, sudo
- base-devel, git
- aur_builder user
- Valid pacman keyring (no stale keys)
- SSH accessible

## Architecture

```
packer/archlinux.pkr.hcl          Packer HCL2 template (QEMU + Ansible + Vagrant)
packer/archlinux.pkrvars.hcl      Arch-specific vars (cloud image URL, disk size)
packer/cloud-init/user-data       Cloud-init: MAC-agnostic networkd for libvirt

ansible/site.yml                  Provisioner entry playbook
ansible/roles/common/base/        pacman upgrade + base packages (shared with ubuntu-images)
ansible/roles/common/vagrant_user/ vagrant user + SSH key + sudo
ansible/roles/common/cleanup/     cache clean + machine-id reset
ansible/roles/archlinux/keyring/  pacman-key --init + --populate archlinux
ansible/roles/archlinux/aur_tools/ base-devel, git, aur_builder user

docker/Dockerfile                 arch-systemd Docker image
contracts/docker.sh               Docker image contract verification
contracts/vagrant.sh              Vagrant box contract verification
```

## Local Build

```bash
# Docker image
docker build -t arch-molecule docker/
docker run --rm arch-molecule sh -c "$(cat contracts/docker.sh)"

# Vagrant box (requires KVM)
pip install ansible-core
ansible-galaxy collection install community.general
packer init packer/archlinux.pkr.hcl
packer build -var-file=packer/archlinux.pkrvars.hcl packer/archlinux.pkr.hcl
```

## Inspiration

Architecture mirrors [githubixx/vagrant-boxes](https://github.com/githubixx/vagrant-boxes):
Packer HCL2 + QEMU + Ansible provisioner, built from official Arch Linux cloud images.
