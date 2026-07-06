# Dérivation du filtre anti-chatter (à appeler via pkgs.callPackage).
{ stdenv }:

stdenv.mkDerivation {
  pname = "interception-debounce";
  version = "1.0";

  src = ./debounce.c;
  dontUnpack = true;

  buildPhase = ''
    $CC -O2 -Wall -o debounce $src
  '';

  installPhase = ''
    install -Dm755 debounce $out/bin/debounce
  '';
}
