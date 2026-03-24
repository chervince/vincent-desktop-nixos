# Gaming — Steam, Gamemode, MangoHUD, optimisations perf
{ pkgs, ... }:
{
  # Steam avec Proton
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Gamemode — optimise CPU governor, nice, scheduler pendant le jeu
  programs.gamemode.enable = true;

  # MangoHUD overlay (FPS, frametime, GPU/CPU stats)
  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
  ];

  # NVIDIA hardware video decode
  environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";
}
