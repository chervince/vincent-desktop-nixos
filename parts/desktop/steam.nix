# Steam — gaming
{ ... }:
{
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = false;
  };

  programs.gamescope.enable = true;
}
