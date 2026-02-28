# arch-images

Arch Linux base image with systemd for Ansible/Molecule testing.

## What this image contains

| Package | Version | Why |
|---------|---------|-----|
| systemd | latest (rolling) | Molecule systemd driver + service testing |
| python | latest (rolling) | Ansible connection + modules |
| sudo | latest (rolling) | Privilege escalation in test playbooks |
| base-devel (gcc, make, ...) | latest (rolling) | AUR build toolchain |
| git | latest (rolling) | AUR cloning |
| glibc (with locale data) | latest (rolling) | Locale generation roles (en_US, ru_RU) |

Non-root user `aur_builder` with passwordless `pacman` sudo is pre-created.

## Guarantees

Every image push is contract-tested. The following are always true:

- `/usr/lib/systemd/systemd` is executable
- `python`, `sudo`, `gcc`, `make`, `git`, `locale-gen` are on PATH
- `aur_builder` user exists with `/etc/sudoers.d/aur_builder`
- `/usr/share/i18n/locales/en_US` and `ru_RU` are present
- `/usr/share/i18n/SUPPORTED` exists
- `/usr/lib/systemd/system/systemd-tmpfiles-setup.service` exists

## Contract tests

- Docker: [`contracts/docker.sh`](contracts/docker.sh) — runs inside the built image
- Vagrant: [`contracts/vagrant.sh`](contracts/vagrant.sh) — runs inside a booted VM via `vagrant ssh`

## Usage

### In molecule.yml (Docker driver)

```yaml
platforms:
  - name: arch-instance
    image: ghcr.io/textyre/arch-base:rolling
    command: /usr/lib/systemd/systemd
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    pre_build_image: true
```

### As a Vagrant box

```ruby
# Vagrantfile
config.vm.box = "arch-base"
config.vm.box_url = "https://github.com/textyre/arch-images/releases/download/boxes/arch-base-latest.box"
```

### In molecule.yml (Vagrant driver)

```yaml
platforms:
  - name: arch-vm
    box: arch-base
    box_url: https://github.com/textyre/arch-images/releases/download/boxes/arch-base-latest.box
```

## Not suitable for

- Production deployments of any kind
- Environments without Docker privileged mode
- Images where a minimal footprint is required (includes base-devel, ~1 GB)

## Update schedule

Rebuilt every Monday at 02:00 UTC from the latest `archlinux:base` upstream.
Rolling release — the image always reflects the current Arch package state.

## Image tags

| Tag | Example | Use |
|-----|---------|-----|
| `:latest` | `arch-base:latest` | Local development |
| `:YYYY.MM.DD` | `arch-base:2026.02.27` | Pin to a specific weekly build |
| `:rolling` | `arch-base:rolling` | Semantically "latest Arch rolling" |
| `:sha-{short}` | `arch-base:sha-abc1234` | Immutable pin for rollback |
