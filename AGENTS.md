# nix-config — NixOS Flake

## Commands

> `just` recipes are only used where they provide real value — chaining multiple steps or handling cleanup/safety. Simple one-aliases are shown as raw commands instead.

### Build & Check
```bash
# Flake checks (pre-commit hooks, bats tests)
nix flake check --impure

# Build a specific host configuration
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# List available hosts
nix flake show

# Apply nixfmt to all .nix files
nix fmt
```

### Deployment
```bash
# Rebuild current host — use the script (auto-detects hostname)
scripts/rebuild.sh

# Or the raw command:
sudo nixos-rebuild switch --flake .#$(hostname) --impure --show-trace

# Rebuild a specific remote host
nixos-rebuild switch --flake .#<hostname> --target-host <user>@<host> --use-remote-sudo
```

### ISO & Disko
```bash
# Build installer ISO (handles result dir cleanup + symlink)
just iso

# Configure drive with disko (BTRFS + LUKS + impermanence)
# (writes/cleans up password to a temp file safely)
just disko /dev/sdX <password>
```

### Development
```bash
# Enter dev shell (has nixfmt, statix, bats, yq)
nix develop

# Run sops tests
bats tests/
```

### Secrets (sops-nix)
```bash
# Check sops decryption
scripts/check-sops.sh
```

## Architecture

### Directory Structure
```
flake.nix              # Flake entrypoint — auto-discovers hosts/nixos/*/
modules/
├── hostSpec.nix       # Per-host options (hostName, role, desktop, users, etc.)
├── default.nix        # Core: imports HM, sops-nix, hostSpec, users
├── common/            # Shared across all roles
├── workstation/       # Desktop/laptop modules
│   └── desktops/      # Hyprland, Gnome, Cinnamon configs
├── server/            # Headless/server modules
├── disks/             # Btrfs filesystem options (compression, auto-scrub)
└── home/              # Home Manager NixOS-side modules
hosts/
├── nixos/             # Per-host configs (auto-discovered by flake)
│   ├── blade/         # Razer Blade 15 (gaming laptop, Gnome)
│   ├── hermes/        # Raspberry Pi 4 (Tailscale exit node)
│   ├── inix/          # iMac (desktop, Cinnamon)
│   ├── kratos/        # Aorus 17X (gaming laptop, Hyprland)
│   ├── kronos/        # Lenovo M700 (mini server, headless)
│   ├── nixbook/       # Acer CB3-431 (laptop, Hyprland)
│   └── nixbook-minimal/ # Upgrade intermediary (stripped)
├── users/
│   ├── adam/          # Adam's user config
│   └── brenda/        # Brenda's user config
home/
├── common/            # Shared HM config (core, desktopApps, games, etc.)
├── adam/              # Adam's HM overrides
└── brenda/            # Brenda's HM overrides
lib/default.nix        # Custom lib functions (relativeToRoot)
overlays/default.nix   # Package overlays/overrides
scripts/               # rebuild.sh, helpers.sh, check-sops.sh, etc.
tests/                 # Bats tests for sops helpers
checks.nix             # Pre-commit hook definitions
```

### Host Spec System
Every host defines its identity via `hostSpec` in `hosts/nixos/<host>/default.nix`:

```nix
hostSpec = {
  hostName = "kratos";
  fsBtrfs = true;
  hasNvidiaPrime = true;
  role = {
    type = "workstation";   # "server" or "workstation"
    gaming = true;
  };
  desktop = {
    displayManager = "sddm";
    hyprland.enable = true;
  };
};
```

Available flags: `fsBtrfs`, `hasNvidiaPrime`, `aiTools`, `threeDTools`, `podman`, `virtualMachines`, `nfsClient`, `desktopApps.*`.

### Secrets Strategy
- **sops-nix** for secrets management
- Encrypted files live in a **separate private repo** (`nix-secrets`) fetched via SSH
- Age keys per user+host; see `scripts/helpers.sh` for key management tooling
- The dev branch on GitHub builds all systems via CI before merging to main

### Special Cases
- **Nixbook**: 4GB RAM / 16GB storage — must use `nixbook-minimal` intermediary for upgrades (see README)
- **Kronos**: Headless mini server — no desktop modules
- **Hermes**: ARM64 (Raspberry Pi 4) — architecture-aware modules

## Coding Conventions

### Nix
- Formatted with **nixfmt** (enforced by pre-commit)
- Use `deadnix` to detect dead code (configured to skip lambda arg detection)
- Prefer `lib.custom.relativeToRoot` for paths relative to repo root
- Module options use `hostSpec.*` namespace for per-host configuration
- Assertions in `hostSpec.nix` validate required fields at build time
- **No `with pkgs;` or `with lib;`** — always use explicit `pkgs.` / `lib.` prefixes.
  `with` scopes hinder static analysis and can cause subtle bugs from name shadowing.

### Git
- Conventional commits: `module: verb` (e.g. `kratos: enable hyprland`, `docs: update readme`)
- Commit titles under 50 characters (enforced by pre-commit)
- Commit body uses itemized (bullet-point) lists — never prose paragraphs
- Separate unrelated changes into distinct commits
- If a commit fails or hooks reject it, fix the issue and create a new commit; do not amend the failed commit
- Always check `git status` before taking any git actions (commit, reset, amend, etc.)
- The `dev` branch triggers CI builds for all systems before merging to `main`

### General
- Prefer `hostSpec` booleans to control feature inclusion over conditional imports
- Keep host configs minimal — push shared logic into `modules/`
- Always verify `hostname` before debugging — this repo manages 7+ machines
- Use `nix store prefetch-file` instead of `nix-prefetch-url` for hash lookup
- Code comments should state facts only — no opinions or action descriptions (those belong in commit messages)
- New files must be `git add`-ed (changed files don't need explicit add)

### Agent Workflow Preferences
- **Discuss before acting** — always propose changes and get approval before committing, deleting files, or taking action
- **Generalized commit bodies** — avoid naming specific hosts in commit messages; use phrasing like "already imported at the host level" instead of "kratos and blade already import it"
- **Neutral language** — no "never used" or other dismissive phrasing in commit messages or documentation

## Multi-Host Reminders
- Before changing configs, checking logs, or debugging: run `hostname` first
- Each host's config is in `hosts/nixos/<hostname>/`
- Secrets are managed in a separate `nix-secrets` private repo
- `sudo nixos-rebuild switch --flake .#$(hostname)` rebuilds the current host
- For remote hosts: `nixos-rebuild --flake .#<hostname> --target-host ...`
