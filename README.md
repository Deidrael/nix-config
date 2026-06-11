# nix-config
My Nix Config

## Systems
### NixOS

| Hostname          | Year | System                     | CPU           | Graphics     | Memory | Role                  | Desktop |
| ----------------- | ---- | -------------------------- | ------------- | ------------ | ------ | --------------------- | ------- |
| Blade | 2019 | Razer Blade 15 | i7-8750H | RTX 2070 | 16 GB | Gaming Laptop | Gnome |
| Hermes | 2018 | Raspberry Pi 4 Model B| ARM Cortex-A72 | VideoCore VI | 4 GB | Tailscale Exit Node | Headless |
| iNix | 2014 | iMac | i5-4570 | GT 755M | 8 GB | Desktop | Cinnamon |
| Kratos | 2024 | Gigabyte Aorus 17X | i9-14900HX | RTX4090 | 32 GB | Gaming Laptop | Hyprland |
| Kronos | 2016 | Lenovo M700 Desktop Tiny | i7-6700T | i915 | 16 GB | Mini Server | Headless |
| Nixbook / Nixbook-minimal | 2014 | Acer CB3-431 | N3160 | i915 | 4 GB | Laptop | Hyprland |

> [!NOTE]
> **Nixbook upgrade process**: With only 4 GB of RAM and 16 GB of storage, the full Nixbook config can't be built directly. The `nixbook-minimal` config is a stripped-down variant used as an intermediary:
> 1. Build and reboot into `nixbook-minimal`
> 2. `nix-collect-garbage -d` to free space
> 3. Build and reboot into the *upgraded* `nixbook-minimal`
> 4. `nix-collect-garbage -d`
> 5. Build and reboot into the full `nixbook` config
> 6. `nix-collect-garbage -d`

### Still to nixify:
| Hostname | Year | System | CPU | Graphics | Memory | Role | Desktop |
| --- | --- | --- | --- | --- | --- | --- | --- |
| raspberrypi | 2016 | Raspberry Pi 3 B | ARM Cortex-A53 | VideoCore IV | 1 GB | Tailscale Exit Node | Headless |

## hostSpec Options
### User Options: hostSpec.users.* (submodule)
| Variable | Default | Description |
| -------- | ------- | ----------- |
| primary.username | | The primary username of the host |
| primary.fullName | | The full name of the primary user |
| primary.handle | | The handle of the user (eg: github user) |
| primary.home | /home/${primary.username} | The home directory of the primary user |
| primary.email | | The email addresses of the primary user |
| secondary.enable | false | Whether to enable the secondary user |
| secondary.username | | The secondary username of the host |
| secondary.fullName | | The full name of the secondary user |
| secondary.home | /home/${secondary.username} | The home directory of the secondary user |
| users | [primary.username] ++ optional secondary | List of all usernames on the host |
### System Options
| Variable | Default | Description |
| -------- | ------- | ----------- |
| hostName | | The hostname of the host |
| domain | localdomain | The domain of the host |
| fsBtrfs | true | Indicates btrfs is used |
| hasNvidiaPrime | false | Indicate host has NVIDIA Prime/Optimus dual-GPU setup |
### Role options: hostSpec.role.* (submodule)
| Variable | Default | Description |
| -------- | ------- | ----------- |
| type | "server" | The primary role of the host (server, workstation) |
| gaming | false | Enable gaming features |
### Service Options
| Variable | Default | Description |
| -------- | ------- | ----------- |
| podman | false | Installs podman |
| aiTools | false | Installs AI tools (ollama, open-webui) |
| threeDTools | false | Installs 3D design/printing tools |
| virtualMachines | false | Enables virtual machine support |
| nfsClient.enable | false | Whether to map NFS shares |
| nfsClient.server | | NFS server address |
| nfsClient.shares | [...] | NFS share names to map |
| nfsClient.mountBase | /mnt/nfs | Base directory for NFS mounts |
| nfsClient.options | [...] | NFS mount options |
### Desktop options: hostSpec.desktop.* (submodule)
| Variable | Default | Description |
| -------- | ------- | ----------- |
| displayManager | "sddm" | The display manager to use (sddm, gdm, lightdm) |
| hyprland.enable | false | Enable Hyprland desktop environment |
| hyprland.brightnessDevice | null | Brightness device for hypridle |
| gnome.enable | false | Enable GNOME desktop environment |
| cinnamon.enable | false | Enable Cinnamon desktop environment |
### Desktop Applications: hostSpec.desktopApps.* (submodule)
| Variable | Default | Description |
| -------- | ------- | ----------- |
| brave | false | Install Brave browser |
| firefox | false | Install Firefox browser |
| social | false | Install social/chat applications |
| media | false | Install media editing applications |
| tools | false | Install desktop utility applications |

## Secrets Configuration

Sensitive data is kept in a private flake input (`nix-secrets`) that is fetched at build time. Below is the expected structure.

### `nix-secrets/flake.nix`

A flake with no inputs of its own, exporting three top-level attributes:

```nix
{
  outputs = { ... }: {
    users = {
      primary = {
        username = "john";
        fullName = "John Doe";
        handle = "jdoe";              # e.g. GitHub username
        email = {
          personal = "john@example.com";
          gitHub = "john@gmail.com";
        };
      };
      secondary = {
        enable = true;
        username = "jane";
        fullName = "Jane Doe";
      };
    };

    domain = "example.com";           # optional, defaults to "localdomain"

    nfsClient = {
      server = "192.168.1.100";
      shares = [ "data" "media" ];
    };
  };
}
```

### `nix-secrets/secrets.yaml`

A [SOPS](https://github.com/getsops/sops)-encrypted file containing user password hashes, SSH private keys, and other sensitive values. Referenced throughout the config by the key path (e.g. `passwords/adam`, `passwords/brenda`).

### `nix-secrets/.sops.yaml`

SOPS creation rules that define which age keys can decrypt which files.

### Directory layout

```
nix-secrets/
├── flake.nix           # Outputs: users, domain, nfsClient
├── secrets.yaml        # SOPS-encrypted secrets (passwords, SSH keys, etc.)
└── .sops.yaml          # SOPS creation rules
```

### CI secrets

If you use GitHub Actions / Dependabot, the following secrets need to be set in the repository:

| Secret | Purpose |
| ------ | ------- |
| `SSH_PRIVATE_KEY` | SSH auth to clone the private nix-secrets repo |
| `CACHIX_AUTH_TOKEN` | Push build artifacts to Cachix |
| `GH_TOKEN_FOR_UPDATES` | Create PRs and enable auto-merge for flake updates |

---

## Need to look into
### Make alias option module
`lib.mkAliasOptionModule` — <https://noogle.dev/f/lib/modules/mkAliasOptionModule#aliases>

## Personal Reminders
### Push current to dev branch (creates if needed):
```
git push origin HEAD:refs/heads/dev
```
> [!NOTE]
> You can also use `HEAD~2` to skip the last 2 local commits.

## Credits

*Inspired by:*
- [EmergentMind/nix-config](https://github.com/EmergentMind/nix-config)
- [KonradMalik/dotfiles](https://github.com/KonradMalik/dotfiles)
- [Vimjoyer](https://www.youtube.com/@vimjoyer)
