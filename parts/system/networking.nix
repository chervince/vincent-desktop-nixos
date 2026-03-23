# Réseau et firewall
{ ... }:
{
  networking.hostName = "vincent-desktop-nixos";
  networking.networkmanager.enable = true;

  # Firewall activé — bloque tout en entrée par défaut
  networking.firewall.enable = true;
}
