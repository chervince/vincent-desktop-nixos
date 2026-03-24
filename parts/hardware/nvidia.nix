# Pilotes NVIDIA RTX 4060 (open) pour Wayland
{ config, ... }:
{
  # Pilotes propriétaires NVIDIA (open kernel modules pour Turing+)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {                                                                     
    enable = true;                                                                        
    enable32Bit = true;  # indispensable pour Steam/Proton (jeux 32-bit)
  };

  # Variables d'environnement pour Wayland + NVIDIA
  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
  };
}
