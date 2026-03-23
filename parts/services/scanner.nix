# Scanner — SANE + simple-scan
{ pkgs, ... }:
{
  hardware.sane.enable = true;

  # Vincent dans le groupe scanner
  users.users.vincent.extraGroups = [ "scanner" "lp" ];

  # Interface graphique
  home-manager.users.vincent.home.packages = with pkgs; [
    simple-scan
  ];
}
