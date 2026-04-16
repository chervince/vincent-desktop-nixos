# Applications graphiques du quotidien
{ pkgs, ... }:
{
  home-manager.users.vincent.home.packages = with pkgs; [
    gimp
    inkscape
    masterpdfeditor4
    filezilla
    nextcloud-client
    thunderbird
    onlyoffice-desktopeditors
    qbittorrent
    mpv
    obsidian
  ];
}
