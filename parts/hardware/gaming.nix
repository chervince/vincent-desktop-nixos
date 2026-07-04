# Gaming — MangoHUD, NVIDIA hardware decode
{ pkgs, ... }:
{
  # MangoHUD overlay (FPS, frametime, GPU/CPU stats)
  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
    luanti # ex-Minetest (voxel sandbox)
    lm_sensors # `sensors` : température CPU par cœur (angle mort thermique levé)
  ];

  # NVIDIA hardware video decode
  environment.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";

  # Observabilité thermique : charge coretemp (Intel) pour exposer les temps
  # CPU par cœur — sinon `sensors` ne sort rien. Capteurs carte-mère : lancer
  # une fois `sudo sensors-detect`.
  boot.kernelModules = [ "coretemp" ];

  # systemd-oomd agit sur les user slices : sous pression mémoire il tue
  # proprement le cgroup fautif (le jeu) au lieu de laisser l'OOM kernel
  # choisir une victime au hasard (plasmashell…). Complète le swap 2-étages.
  systemd.oomd.enableUserSlices = true;
}
