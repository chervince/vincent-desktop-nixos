# vincent-desktop-nixos — flake.nix (tronc)
# Point d'entrée unique : déclare les inputs et compose l'arbre dendritique.
{
  description = "vincent-desktop-nixos — NixOS personnel de Vincent";

  inputs = {
    # Canal stable NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager — gestion de l'espace utilisateur
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Assistants IA
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, claude-code, codex-cli-nix, ... }: {
    nixosConfigurations.vincent-desktop-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit claude-code codex-cli-nix; };
      modules = [
        ./hardware-configuration.nix
        ./parts
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
        }
      ];
    };
  };
}
