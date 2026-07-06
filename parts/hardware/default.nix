# parts/hardware/ — GPU, audio, périphériques
{
  imports = [
    ./nvidia.nix
    ./audio.nix
    ./disks.nix
    ./gaming.nix
    ./antichatter # TEMPORAIRE — filtre chatter Falchion Ace, retirer après RMA
  ];
}
