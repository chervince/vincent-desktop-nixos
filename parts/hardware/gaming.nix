# Gaming — MangoHUD, NVIDIA hardware decode
{ pkgs, ... }:
{
  # MangoHUD overlay (FPS, frametime, GPU/CPU stats)
  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
  ];

  # NVIDIA hardware video decode
  environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
}
