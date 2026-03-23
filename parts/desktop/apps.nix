# Applications graphiques du quotidien
{ pkgs, ... }:
{
  home-manager.users.vincent.home.packages = with pkgs; [
    gimp
    inkscape
    masterpdfeditor4
    filezilla
  ];
}
