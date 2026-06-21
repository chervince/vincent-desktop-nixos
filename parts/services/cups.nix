# Impression CUPS
{ ... }:
{
  services.printing.enable = true;

  # Découverte réseau mDNS — restaure l'auto-détection des imprimantes/services
  # (UDP 5353 ouvert via openFirewall)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Brother DCP-J1050DW — driverless (IPP Everywhere / AirPrint), aucun pilote Brother requis.
  # URI en nom mDNS stable (.local) : indépendant de l'IP DHCP.
  hardware.printers = {
    ensurePrinters = [{
      name = "Brother_DCP-J1050DW";
      location = "Bureau";
      deviceUri = "ipp://BRWF889D2A32666.local/ipp/print";
      model = "everywhere";
    }];
    ensureDefaultPrinter = "Brother_DCP-J1050DW";
  };
}
