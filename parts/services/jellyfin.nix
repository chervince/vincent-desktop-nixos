# Jellyfin — serveur multimédia local (LAN)
{ ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;  # ouvre 8096 (HTTP) et 8920 (HTTPS)
  };

  # Permettre à Jellyfin d'accéder au GPU (NVENC sur RTX 4060)
  users.users.jellyfin.extraGroups = [ "video" "render" ];
}
