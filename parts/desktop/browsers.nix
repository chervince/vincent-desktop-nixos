# Navigateurs web
{ pkgs, ... }:
{
  home-manager.users.vincent.home.packages = with pkgs; [
    brave
    google-chrome
    jellyfin-media-player  # client Jellyfin natif (mpv/NVDEC) : lit le HEVC 10-bit sans transcodage
  ];
}
