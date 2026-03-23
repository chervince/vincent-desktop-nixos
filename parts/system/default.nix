# parts/system/ — configuration système de base
{
  imports = [
    ./boot.nix
    ./locale.nix
    ./networking.nix
    ./nix-settings.nix
  ];
}
