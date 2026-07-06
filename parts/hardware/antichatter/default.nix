# Module NixOS : filtre anti-chatter pour le ROG Falchion Ace.
#
# Destination prévue : ~/.config/nixos/parts/hardware/antichatter/
# (copier les 3 fichiers de ce dossier nixos/, puis importer ce module
#  comme les autres parts — voir README.md à la racine du projet).
#
# ⚠ MASQUE TEMPORAIRE en attendant le RMA du clavier — retirer l'import
#   une fois le clavier remplacé et la touche « e » validée saine.
{ pkgs, ... }:

let
  debounce = pkgs.callPackage ./debounce.nix { };
in
{
  services.interception-tools = {
    enable = true;
    # Grab exclusif du vrai clavier → filtre → clone virtuel uinput.
    # Le match NAME + EV_KEY:[KEY_E] cible les 2 interfaces clavier du
    # Falchion (event-kbd + if03, celles capturées le 2026-07-06) et
    # laisse tranquilles la souris G502 et le reste.
    # Seuil : 30 ms (rebonds mesurés ≤ 11 ms ; ré-appui humain ≥ ~60 ms).
    # Marge de réglage si le switch se dégrade : jusqu'à ~45 ms.
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${debounce}/bin/debounce 30 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          NAME: "ASUSTeK ROG FALCHION ACE"
          EVENTS:
            EV_KEY: [KEY_E]
    '';
  };
}
