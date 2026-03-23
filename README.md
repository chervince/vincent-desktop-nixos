# vincent-desktop-nixos

Personal NixOS configuration for a desktop workstation, managed declaratively with [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://github.com/nix-community/home-manager).

## Hardware

| Component | Detail |
|---|---|
| CPU | Intel i7-10700F (8c/16t) |
| GPU | NVIDIA RTX 4060 (open kernel modules) |
| RAM | 32 GB |
| Boot drive | NVMe 500 GB — LUKS-encrypted Btrfs (subvolumes `@`, `@home`, `@nix`) |
| Data drives | 5 additional SATA drives (ext4, exFAT, NTFS, FAT32) |
| Displays | 2x 24" 1080p @ 165 Hz (DisplayPort) |

## Desktop

- **KDE Plasma 6** on Wayland with SDDM
- **Kitty** terminal (Catppuccin Mocha, 70% opacity)
- **Fish** shell + **Starship** prompt (Catppuccin Macchiato) + **zoxide**
- Modern CLI replacements: `eza`, `bat`, `ripgrep`, `fd`, `btop`

## Development

- **Languages**: Node.js/pnpm, Python, Rust (rustup), PHP
- **Editor**: VS Code (Prettier, ESLint, Nix IDE)
- **Containers**: Docker (rootless for user)
- **Android**: Android Studio + JDK + KVM emulator
- **Database clients**: PostgreSQL, SQLite
- **AI**: Claude Code CLI
- **VCS**: Git + GitHub CLI (`gh`)

## Architecture

The configuration follows a **dendritic tree** pattern — a single entry point (`flake.nix`) that branches into focused, single-responsibility modules:

```
flake.nix                      # Entry point: inputs + system composition
hardware-configuration.nix     # Auto-generated hardware detection
parts/
  system/                      # Boot, locale, networking, nix settings
  hardware/                    # NVIDIA drivers, audio (PipeWire), disk mounts
  desktop/                     # Plasma, fonts, browsers, apps, Steam
  shell/                       # Fish, Starship, Kitty, CLI tools
  dev/                         # Git, languages, VS Code, Docker, Android
  services/                    # SSH, CUPS, SANE scanner, fstrim
  users/                       # User account + Home Manager base
```

Each `default.nix` only imports its children — no logic, just composition. Leaf files (e.g. `nvidia.nix`, `fish.nix`) contain the actual configuration.

## Key design choices

- **Flakes** for reproducibility and pinned dependencies
- **Home Manager** (as NixOS module) for user-space configuration
- **LUKS + Btrfs** with zstd compression and subvolumes for clean snapshots
- **NVIDIA open modules** with Wayland-specific environment variables
- **systemd-boot** with 20-generation limit to avoid filling `/boot`
- **Weekly garbage collection** keeping 7 days of store history
- **SSH hardened** — key-only authentication, no root login

## Usage

```bash
# Apply changes
sudo nixos-rebuild switch --flake /etc/nixos#vincent-desktop-nixos

# Test without persisting to boot menu
sudo nixos-rebuild test --flake /etc/nixos#vincent-desktop-nixos

# Update all inputs (nixpkgs, home-manager)
cd /etc/nixos
nix flake update
sudo nixos-rebuild switch --flake .#vincent-desktop-nixos

# Rollback to previous generation
# Select from the systemd-boot menu, or:
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-env --switch-generation N --profile /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

## License

Personal configuration — use as inspiration at your own risk.
