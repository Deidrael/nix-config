# nix-config
My Nix Config

Resources I used the most (alphabetically):
- EmergentMind/nix-config
- KonradMalik/dotfiles
- Vimjoyer on YT

## Systems
### NixOS

| Hostname | Year | System | CPU | Graphics | Memory | Role | Desktop |
| -------- | ---- | ------ | --- | -------- | ------ | ---- | ------- |
| Blade | 2019 | Razer Blade 15 | i7-8750H | RTX 2070 | 16 GB | Gaming Laptop | Gnome |
| Hermes | 2018 | Raspberry Pi 4 Model B| ARM Coretex-A72 | VideoCore VI | 4 GB | Tailscale Exit Node | Headless |
| iNix | 2014 | iMac | i5-4570 | GT 755M | 8 GB | Desktop | Cinnamon |
| Kratos | 2024 | Gigabyte Aorus 17X | i9-14900HX | RTX4090 | 32 GB | Gaming Laptop | Hyprland |
| Kronos | 2016 | Lenovo M700 Desktop Tiny | i7-6700T | i915 | 16 GB | Mini Server | Headless |
| Nixbook | 2014 | Acer CB3-431 | N3160 | i915 | 4 GB | Laptop | Hyprland |

### Still to nixify:
| Hostname | Year | System | CPU | Graphics | Memory | Role | Desktop |
| --- | --- | --- | --- | --- | --- | --- | --- |
| raspberrypi | 2016 | Raspberry Pi 3 B | ARM Cortex-A53 | VideoCore IV | 1 GB | Tailscale Exit Node | Headless |

# Nix-Secrets Configuration
## Structure
### nix-secrets/flake.nix
- This contains basic outputs such as primaryUsername, email.user and email.github, NAS info (nfsClient.server for hostname, nfsClient.shares for shares), etc.
### nix-secrets/secrets.yaml
- This contains my user password hashs, private ssh keys, etc.

# Need to look into:
### lib.MkAliasOptionModule
https://noogle.dev/f/lib/modules/mkAliasOptionModule#aliases

# Personal Reminders
## Push to dev branch (creates if needed):
git push origin main:refs/heads/dev

## hostSpec Options
### User Options
| Variable | Default | Description |
| -------- | ------- | ----------- |
| primaryUsername | | The primary username of the host |
| primaryUserFullName | | The full name of the primary user |
| handle | | The handle of the user (eg: github user) |
| home | /home/\${user} | The home directory of the user |
| email | | The email of the user |
| secondaryUsername | | The secondary username of the host |
| secondaryUserFullName | | The full name of the secondary user |
| users | [ config.hostSpec.primaryUsername ] | An attribute set of all users on the host |
### System Options
| Variable | Default | Description |
| -------- | ------- | ----------- |
| hostName | | The hostname of the host |
| domain | localdomain | The domain of the host |
| fsBtrfs | true | Indicates btrfs is used |
| hasNvidia | false | Indicate host has Nvidia graphics |
### Role options: hostSpec.role.* (submodule)
| Variable | Default | Description |
| -------- | ------- | ----------- |
| type | "server" | The primary role of the host (server, workstation) |
| gaming | false | Enable gaming features |
### Service Options
| Variable | Default | Description |
| -------- | ------- | ----------- |
| podman | false | Installs podman |
| ollama | false | Installs ollama |
| nfsClient.enable | false | Whether to map NFS shares |
| nfsClient.server | | NFS server address |
| nfsClient.shares | [ ] | NFS share names to map |
| nfsClient.mountBase | /mnt/nfs | Base directory for NFS mounts |
| nfsClient.options | [...] | NFS mount options
### Desktop options: hostSpec.desktop.* (submodule)
| Variable | Default | Description |
| ------------------ | ------- | ----------- |
| displayManager | "sddm" | The display manager to use (sddm, gdm, lightdm) |
| hyprland.enable | false | Enable Hyprland desktop environment |
| gnome.enable | false | Enable GNOME desktop environment |
| cinnamon.enable | false | Enable Cinnamon desktop environment |
