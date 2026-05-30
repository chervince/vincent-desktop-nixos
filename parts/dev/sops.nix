# Outils SOPS + age — gestion des secrets chiffrés dans les projets dev
{ pkgs, ... }:
{
  home-manager.users.vincent.home.packages = with pkgs; [
    age
    sops
  ];
}
