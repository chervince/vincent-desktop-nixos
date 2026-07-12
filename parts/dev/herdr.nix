# parts/dev/herdr.nix — herdr, multiplexeur d'agents (tmux-like pour agents de code)
#
# Upstream: github.com/ogulcancelik/herdr (Rust)
# On installe le binaire prébuilt officiel (linux-x86_64), qui est STATIQUE
# (aucun interpréteur ELF, aucune lib NEEDED) → tourne tel quel sur NixOS,
# sans patchelf ni nix-ld. Vérifié: `herdr --version` → herdr 0.7.1.
#
# Pourquoi pas buildRustPackage : la révision nixpkgs figée a un fetch-cargo-vendor-util
# qui n'envoie pas de User-Agent → crates.io renvoie 403. Le binaire prébuilt
# contourne entièrement le problème.
#
# Cohabite avec temux.nix / tmux.nix dans la branche dev.
{ pkgs, ... }:
let
  version = "0.7.1";
  herdr = pkgs.stdenvNoCC.mkDerivation {
    pname = "herdr";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-linux-x86_64";
      hash = "sha256-uWWsr/wsIvVLbmxkr3z46Yo/SsJiJjCgWZxnpLnYplQ=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/herdr"
      runHook postInstall
    '';

    meta = {
      description = "Agent multiplexer that lives in your terminal";
      homepage = "https://github.com/ogulcancelik/herdr";
      mainProgram = "herdr";
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home-manager.users.vincent.home.packages = [ herdr ];
}
