# Polices système — développement, UI et émojis
{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # Nerd Font pour le terminal (icônes, ligatures)
    nerd-fonts.meslo-lg

    # Noto — couverture unicode complète + émojis
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    # Polices UI / web
    montserrat
    dejavu_fonts
    liberation_ttf
    roboto
    open-sans
  ];

  # Activer fontconfig pour la découverte automatique
  fonts.fontconfig.enable = true;
}
