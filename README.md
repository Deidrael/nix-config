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
| Kronos | ? | Lenovo | i7-6700T | i915 | 16 GB | Mini Server | Headless |
| Nixbook | 2014 | Acer CB3-431 | N3160 | i915 | 4 GB | Laptop | Hyprland |

### Still to nixify:
| Hostname | Year | System | CPU | Graphics | Memory | Role | Desktop |
| --- | --- | --- | --- | --- | --- | --- | --- |
| raspberrypi | 2016 | Raspberry Pi 3 B | ARM Cortex-A53 | VideoCore IV | 1 GB | Tailscale Exit Node | Headless |


# Need to look into:
### lib.MkAliasOptionModule
https://noogle.dev/f/lib/modules/mkAliasOptionModule#aliases

# Personal Reminders
## Push to dev branch (creates if needed):
git push origin main:refs/heads/dev

## hostSpec Options
| Variable | Default | Description |
| -------- | ------- | ----------- |
| primaryUsername | | The primary username of the host |
| primaryUserFullName | | The full name of the primary user |
| handle | | The handle of the user (eg: github user) |
| home | /home/\${user} | The home directory of the user |
| email | | The email of the user |
| secondaryUsername | | The secondary username of the host |
| secondaryUserFullName | | The full name of the secondary user |
| hostName | | The hostname of the host |
| networking | { } | An attribute set of networking information |
| wifi | false | Used to indicate if a host has wifi |
| domain | localdomain | The domain of the host |
| persistFolder |  | The folder to persist data if impermenance is enabled |
| work | { } | An attribute set of work-related information if isWork is true |
| users | [ config.hostSpec.primaryUsername ] | An attribute set of all users on the host |
| isMinimal | false | Indicate a minimal host |
| isProduction | true | Indicate a production host |
| isServer | false | Indicate a server host |
| isWork | false | Indicate a host that uses work resources |
| isDevelopment | false | Indicate a host used for development |
| isMobile | false | Indicate a mobile host |
| useYubikey | false | Indicate if the host uses a yubikey |
| voiceCoding | false | Indicate a host that uses voice coding |
| isAutoStyled | false | Indicate a host that wants auto styling like stylix |
| theme | dracula | The theme to use for the host (stylix, vscode, neovim, etc) |
| useNeovimTerminal | false | Indicate a host that uses neovim for terminals |
| useWindowManager | true | Indicate a host that uses a window manager |
| hdr | false | Indicate a host that uses HDR |
| scaling | 1 | Indicate what scaling to use. Floating point number |
| wallpaper | ~/zen-01.png | Path to wallpaper to use for system |
| useWayland | false | Indicate a host that uses Wayland |
| defaultBrowser | firefox | The default browser to use on the host |
| defaultEditor | nvim | The default editor command to use on the host |
| defaultDesktop | Hyprland | The default desktop environment to use on the host |
