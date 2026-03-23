# parts/default.nix — racine de l'arbre dendritique
# Importe chaque branche. Aucune logique ici, juste la composition.
{
  imports = [
    ./system
    ./hardware
    ./desktop
    ./shell
    ./dev
    ./services
    ./users
  ];
}
