# Montage des disques data (btrfs, ext4, exFAT, NTFS, FAT32)
{ ... }:
{
  # Support exFAT et NTFS
  boot.supportedFilesystems = [ "exfat" "ntfs" ];

  fileSystems."/mnt/Evo250" = {
    device = "/dev/disk/by-uuid/35ac427d-e219-4e63-a92e-2b6feb476efe";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/ssd90" = {
    device = "/dev/disk/by-uuid/5efc2d71-0059-497d-91bf-1394161c968a";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/serveur" = {
    device = "/dev/disk/by-uuid/1216-10E0";
    fsType = "exfat";
    options = [ "nofail" "uid=1000" "gid=100" "dmask=022" "fmask=133" ];
  };

  fileSystems."/mnt/OCZ112" = {
    device = "/dev/disk/by-uuid/8d27fec2-fbd6-496a-95a0-be39c3638cd6";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/data_meca" = {
    device = "/dev/disk/by-uuid/62E033EBE033C457";
    fsType = "ntfs-3g";
    options = [ "nofail" "uid=1000" "gid=100" "dmask=022" "fmask=133" ];
  };

  fileSystems."/mnt/M2_data" = {
    device = "/dev/disk/by-uuid/ba04c230-eb01-4e20-b741-595593af292a";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/navette" = {
    device = "/dev/disk/by-uuid/7072-08BC";
    fsType = "vfat";
    options = [ "nofail" "uid=1000" "gid=100" "dmask=022" "fmask=133" ];
  };

  # ── Swap à deux étages ────────────────────────────────────────────────
  # 1) zram = RAM compressée (zstd), rapide, première ligne de défense.
  #    NOTE : c'est de la RAM, pas de la capacité en plus (25% de 31 Gio ≈ 7,7 Gio).
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
    priority = 5;            # prioritaire sur le swap disque
  };

  # 2) Filet de secours DISQUE (16 Gio) sur le btrfs/LUKS. Absorbe le pic
  #    mémoire d'un jeu AAA au lieu de déclencher l'OOM-killer / le freeze.
  #    Priorité < zram ⇒ utilisé seulement quand le zram est saturé.
  #    Fichier créé une fois via `btrfs filesystem mkswapfile` (NoCoW, non compressé).
  #    Pas de `size` ici ⇒ NixOS ne le recrée pas (évite le piège CoW btrfs).
  swapDevices = [
    { device = "/swap/swapfile"; priority = 1; }
  ];

  # zram reste prioritaire ; 80 suffit dès qu'un fallback disque existe.
  boot.kernel.sysctl."vm.swappiness" = 80;
}
