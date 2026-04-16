# Bootloader systemd-boot et paramètres de démarrage
{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limite les générations dans le menu boot (évite de remplir /boot)
  boot.loader.systemd-boot.configurationLimit = 20;

  # Btrfs : compression zstd et noatime sur tous les subvolumes
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];

  # TRIM à travers LUKS pour la longévité du SSD
  boot.initrd.luks.devices."cryptroot".allowDiscards = true;

  # Kernel Xanmod — scheduler BORE + optimisations gaming (proche du kernel CachyOS)
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
