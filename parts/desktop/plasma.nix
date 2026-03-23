# KDE Plasma 6 sur Wayland
{ ... }:
{
  services.desktopManager.plasma6.enable = true;

  # SDDM comme display manager (Wayland natif)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Session Wayland par défaut, X11 reste dispo en fallback
  services.displayManager.defaultSession = "plasma";

  # Portails XDG pour les apps Flatpak/sandboxed
  xdg.portal.enable = true;
}
