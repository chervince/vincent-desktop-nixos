# Pilotes NVIDIA RTX 4060 pour Wayland
{ config, ... }:
{
  # Pilotes propriétaires NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Préserve les allocations VRAM au suspend/resume
    # Sans ça, KWin perd son contexte GL au réveil → crash Xid 13
    powerManagement.enable = true;

    # Sauvegarde complète de la VRAM au suspend (plus lent mais plus fiable)
    powerManagement.finegrained = false;
  };

  # Maintient le driver NVIDIA chargé en permanence (évite les crashs au reload)
  hardware.nvidia.nvidiaPersistenced = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # indispensable pour Steam/Proton (jeux 32-bit)
  };

  # Désactive le dynamic power management NVIDIA (évite que le GPU reste en P5 sur Wayland)
  # + PreserveVideoMemoryAllocations pour le suspend/resume
  boot.extraModprobeConfig = ''
    options nvidia NVreg_DynamicPowerManagement=0x00
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
  '';

  # Variables d'environnement pour Wayland + NVIDIA
  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
  };
}
