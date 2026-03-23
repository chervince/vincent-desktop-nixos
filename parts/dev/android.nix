# Android Studio + SDK + émulateur
{ pkgs, ... }:
{
  home-manager.users.vincent.home.packages = with pkgs; [
    android-studio
    jdk
  ];

  # KVM pour l'émulateur Android
  users.users.vincent.extraGroups = [ "kvm" ];
}
