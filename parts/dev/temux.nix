# parts/dev/temux.nix — workstation driver for forge-shell tmux sessions.
#
# Source script: ./temux.sh (versioned alongside this file)
# Design: github.com/chervince/temux, docs/adr/0001-temux-architecture.md §4
#
# Pairs with `temux-host` installed by ~/projects/temux/install.sh on the VPS.
{ pkgs, ... }:
let
  temux = pkgs.writeShellApplication {
    name = "temux";
    runtimeInputs = with pkgs; [ openssh git coreutils ];
    text = builtins.readFile ./temux.sh;
  };
in
{
  home-manager.users.vincent.home.packages = [ temux ];
}
