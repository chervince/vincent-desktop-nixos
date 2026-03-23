# Navigateurs web
{ pkgs, ... }:
{
  home-manager.users.vincent.home.packages = with pkgs; [
    brave
    google-chrome
  ];
}
