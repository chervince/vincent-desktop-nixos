# Localisation : langue, clavier, fuseau horaire
{ ... }:
{
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
  };

  # Clavier AZERTY — console TTY et Xorg/Wayland
  console.keyMap = "fr";
  services.xserver.xkb.layout = "fr";

  # Nouméa, Nouvelle-Calédonie (+11)
  time.timeZone = "Pacific/Noumea";

  # Synchronisation NTP
  services.timesyncd.enable = true;
}
