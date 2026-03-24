# Pertinence from nix-config-oj

Elements intéressants trouvés dans `/home/vincent/Documents/projects/nix-config-oj` qui ne sont pas encore dans notre config.

---

## Gains rapides (faciles à adopter)

### 1. Outils CLI manquants

- **fzf** : fuzzy finder avec intégration shell
- **tlrc** : client tldr en Rust avec service d'auto-update
- **fastfetch** : affichage d'info système moderne (remplace neofetch)

### 2. Git amélioré

```nix
programs.git.settings = {
  gpg.format = "ssh";
  commit.gpgSign = true;
  core.pager = "diff-so-fancy | less --tabs=4 -RFX";
  interactive.diffFilter = "diff-so-fancy --patch";
};
```

### 3. eza enrichi

```nix
programs.eza = {
  extraOptions = [
    "--color=always"
    "--group-directories-first"
    "--header"
    "--time-style=long-iso"
  ];
  git = true;
};
```

- Alias `lg` : listing git-aware sans taille/date

### 4. bat enrichi

```nix
programs.bat = {
  extraPackages = [ batgrep batwatch ];
  config = { style = "plain"; };
};
home.sessionVariables.MANPAGER = "sh -c 'col -bx | bat -l man -p'";
```

### 5. MangoHUD pour le gaming

- Overlay détaillé : FPS, frametime, GPU/CPU power
- Config déclarative via Home Manager

---

## Moyen terme

### 6. Ghostty (terminal GPU-accelerated)

```nix
programs.ghostty = {
  enable = true;
  settings = {
    font-family = "FiraCode Nerd Font";
    background-opacity = 0.9;
    background-blur = true;
  };
};
```

A tester en parallèle de Kitty.

### 7. Docker rootless

- Daemon system-wide désactivé, rootless uniquement
- DNS custom et registry mirrors
- Plus sécurisé que notre setup actuel (user dans le groupe docker)

### 8. Brave avec extensions déclaratives

```nix
programs.brave = {
  enable = true;
  extensions = [ "nngceckbapebfimnlniiiahkandclblb" ]; # Bitwarden
  commandLineArgs = [ "--ui-toolkit=gtk" ];
};
```

### 9. Justfile pour automatiser les rebuilds

- Commandes : `just fmt`, `just check`, `just switch`, `just update`
- Scaffolding : `just new-user`, `just new-host`
- Remplace les commandes manuelles du README

### 10. Aliases utiles à reprendre

```nix
aliases = {
  cp = "cp -i";
  mx = "chmod a+x";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  tarnow = "tar -acf";
  untar = "tar -zxvf";
  space = "sudo ncdu -x";
};
```

---

## Notable mais pas prioritaire

### Niri (tiling compositor)

- Remplacement radical de Plasma, workflow très différent
- Inclut : xwayland-satellite, cliphist, grim+slurp

### Zed Editor

- Editeur moderne mais encore jeune vs VS Code
- Config runtime depuis fichiers JSON externes

### flake-parts + import-tree

- Auto-discovery des modules (plus besoin d'imports explicites)
- Pertinent seulement si on gère plusieurs machines/utilisateurs

### DMS theming (Material Design 3)

- Theming dynamique basé sur le wallpaper via Matugen
- Overkill si on est content avec Catppuccin

### Système de config runtime avec layers

- `configs/common/` -> `configs/users/<user>/common/` -> `configs/users/<user>/hosts/<host>/`
- Fichiers copiés (pas symlinkés), modifiables par l'UI
- Pertinent pour setup multi-utilisateur

### VPN profile import automatique

- Service systemd qui importe les profils OpenVPN depuis `~/.config/ovpn/`

### nix-ld

- Dynamic linker pour binaires tiers non-NixOS
- Utile si on utilise des binaires pré-compilés

---

## Source

Config analysée : `/home/vincent/Documents/projects/nix-config-oj`
