# TRIM périodique pour la longévité du SSD NVMe
{ ... }:
{
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
