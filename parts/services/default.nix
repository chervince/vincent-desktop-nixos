# parts/services/ — services système
{
  imports = [
    ./fstrim.nix
    ./ssh.nix
    ./cups.nix
    ./scanner.nix
    ./jellyfin.nix
  ];
}
