# Paramètres du gestionnaire de paquets Nix
{ ... }:
{
  # Version d'installation initiale — ne pas modifier
  system.stateVersion = "24.11";
  # Autorise les paquets non-libres (NVIDIA, Steam, VS Code, etc.)
  nixpkgs.config.allowUnfree = true;

  # Active les commandes modernes (nix build, nix flake, etc.)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Nettoyage automatique du store Nix (hebdomadaire, garde 7 jours)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
