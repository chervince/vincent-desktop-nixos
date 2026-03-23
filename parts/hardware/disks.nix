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
}
