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
    stremio-linux-shell
    ffmpeg            # serveur de transcodage de Stremio (ffprobe/ffmpeg)
    mpv
    obsidian
    discord
    kdePackages.kcalc  # calculatrice native Plasma
  ];
}
