# Docker + Docker Compose (service système)
{ ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Vincent dans le groupe docker (pas besoin de sudo)
  users.users.vincent.extraGroups = [ "docker" ];
}
