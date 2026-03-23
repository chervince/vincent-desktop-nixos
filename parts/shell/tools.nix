# Outils shell : zoxide, eza, bat, ripgrep
{ pkgs, ... }:
{
  home-manager.users.vincent = {
    # zoxide — navigation rapide (z, zi)
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    # eza — remplacement moderne de ls
    programs.eza = {
      enable = true;
      icons = "auto";
    };

    # bat — remplacement de cat avec coloration syntaxique
    programs.bat = {
      enable = true;
    };

    # Paquets CLI supplémentaires
    home.packages = with pkgs; [
      ripgrep
      fd
      btop
    ];
  };
}
