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
nixos-rebuild switch --flake .#<hostname> --target-host <user>@<host> --elevate=sudo --ask-elevate-password
# Or as root (no password prompt):
nixos-rebuild switch --flake .#<hostname> --target-host root@<host>
# Remote hosts: deploy with `nixos-rebuild boot --flake .#<host> --target-host root@<ip>` so the user controls when the host reboots; check locally with `switch`
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
├── base/              # Shared across all roles
├── workstation/       # Desktop/laptop modules
│   └── desktops/      # Hyprland, Gnome, Cinnamon configs
├── server/            # Headless/server modules
├── features/          # Feature modules (hermes.nix, aiTools.nix, etc.)
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

Available flags: `fsBtrfs`, `hasNvidiaPrime`, `aiTools.*`, `threeDTools`, `podman`, `virtualMachines`, `nfsClient`, `desktopApps.*`, `hermes.*`, `hermes.searxng`.

### Secrets Strategy
- **sops-nix** for secrets management
- Encrypted files live in a **separate private repo** (`nix-secrets`) fetched via SSH
- Each host has a per-host age-key file at `nix-secrets/sops/<host>.yaml`
- `.sops.yaml` maps SOPS creation-rule anchors to keys and defines per-file rules for `shared.yaml` and `sops/<host>.yaml`
- `modules/base/services/sops.nix` asserts the file's existence and extracts `keys/age` to `~/.config/sops/age/keys.txt` so home-manager can decrypt
- `scripts/helpers.sh` provides `sops_setup_user_age_key <user> <host>`, `sops_generate_all_host_keys`, and `sops_verify_host_keys`
- The dev branch on GitHub builds all systems via CI before merging to main

### Special Cases
- **Nixbook**: 4GB RAM / 16GB storage — must use `nixbook-minimal` intermediary for upgrades (see README)
- **Kronos**: Headless mini server — no desktop modules
- **Hermes**: ARM64 (Raspberry Pi 4) — architecture-aware modules; also runs **hermes-agent** (AI agent with web search, skills curation, task delegation, and cron jobs)
  - `tailscale serve` registers under the node's current hostname; after a host rename, restart the serve unit to re-register or it serves under the stale name (e.g. `hermes-1`)
- **Hyprland 0.55+**: Deprecates hyprlang config in favor of Lua
  - `hyprctl dispatch <dispatcher> <args>` args are now evaluated as Lua
  - Must use `hl.dsp.<dispatcher>(...)` forms (e.g. `hl.dsp.dpms({ action = "off" })` replaces `dpms off`)
- **Cephalon Kronos**: Forked at `github.com/Deidrael/cephalon-kronos`; Nix build infrastructure and patches maintained directly on the fork's `master` branch. Flake input in `flake.nix` tracks this fork. Patches address overlay sizing on ultrawide displays, image loading on Wayland, and screen capture compatibility. Upstream is `glowseeker/cephalon-kronos`.

## Coding Conventions

### Nix
- Formatted with **nixfmt** (enforced by pre-commit)
- Use `deadnix` to detect dead code (configured to skip lambda arg detection)
- Prefer `lib.custom.relativeToRoot` for paths relative to repo root
- Module options use `hostSpec.*` namespace for per-host configuration
- Assertions in `hostSpec.nix` validate required fields at build time
- **No `with pkgs;` or `with lib;`** — always use explicit `pkgs.` / `lib.` prefixes.
  `with` scopes hinder static analysis and can cause subtle bugs from name shadowing.
- Use `stdenv.hostPlatform.isLinux` for platform checks — `stdenv.isLinux` is deprecated (triggers evaluation warning)
- Prefer dedicated Home Manager modules over raw config when one exists (e.g. `programs.delta` with `enableGitIntegration` instead of manual `core.pager` settings)
- `WorkingDirectory=` synthesizes an implicit hard `RequiresMountsFor=` at unit load time; prefix with `-` to demote it to a soft `Wants`. Conversely, `ReadWritePaths` and `x-systemd.automount` do NOT create mount dependencies and do not redirect hard `Requires`/`After` deps — an explicit wait/retry unit may be needed for NFS-backed state.
- `network-online.target` does not wait for connectivity when `NetworkManager-wait-online` is masked (e.g. hermes) — gate network-dependent services on an explicit retry/wait unit instead.
- When packaging AppImages that need process access (e.g., reading other processes' memory), use `appimageTools.extract` + `autoPatchelfHook` instead of `appimageTools.wrapType2` — the latter uses bubblewrap sandboxing which blocks inter-process visibility.
- Tauri v2 apps on NixOS require `APPDIR` env var pointing to the store root for bundled resource resolution. Without it, `resource_dir()` falls back to the nonexistent FHS path `/usr/lib/<productName>/`.

### Git
- Conventional commits: `module: verb` (e.g. `kratos: enable hyprland`, `docs: update readme`)
- Commit titles under 50 characters (enforced by pre-commit)
- Commit body uses itemized (bullet-point) lists — never prose paragraphs
- Separate unrelated changes into distinct commits
- If a commit fails or hooks reject it, fix the issue and create a new commit; do not amend the failed commit
- Always check `git status` before taking any git actions (commit, reset, amend, etc.)
- The `dev` branch triggers CI builds for all systems before merging to `main`
- Work is committed on local `main`; push to remote `dev` via `git push origin HEAD:refs/heads/dev`
- Pushing to `dev` triggers `.github/workflows/create-pr.yml`, which auto-creates the "Merge dev to main" PR and enables auto-merge; CI builds all hosts via `.github/workflows/build.yml` on PRs targeting `main`, then auto-merge rebases into remote `main`
- After auto-merge, the user runs `git pull --rebase` on local `main` to sync commit hashes with remote `main` (agents do not perform this step)
- `origin/main` is immutable — commits that have reached it are final and must never be force-pushed or rewritten; all history rewriting (squash, amend, rebase) must happen on local branches before pushing to `dev`

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
- **Orchestrator delegates all work** — the NixOS Orchestrator is a manager, not a hands-on implementer. It gathers context and delegates everything else (research, debugging, implementation, design, documentation) to specialist sub-agents. The orchestrator should never write code, run systemctl commands, grep files, look up nixpkgs options, or investigate build failures directly. Any task that requires reading, understanding, or modifying code should be delegated.

## Multi-Host Reminders
- Before changing configs, checking logs, or debugging: run `hostname` first
- Each host's config is in `hosts/nixos/<hostname>/`
- Secrets are managed in a separate `nix-secrets` private repo
- `sudo nixos-rebuild switch --flake .#$(hostname)` rebuilds the current host
- For remote hosts: `nixos-rebuild --flake .#<hostname> --target-host ...`
