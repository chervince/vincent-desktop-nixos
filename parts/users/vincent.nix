# Compte utilisateur principal
{ pkgs, ... }:
{
  users.users.vincent = {
    isNormalUser = true;
    description = "Vincent";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
    shell = pkgs.fish;
  };

  # Home Manager — base de la config utilisateur
  home-manager.users.vincent = {
    home.stateVersion = "24.11";
  };
}
