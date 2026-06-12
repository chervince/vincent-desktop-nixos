# parts/desktop/niri-tools.nix — la « couche d'outils » autour de niri
#
# niri ne fait QU'UNE chose : composer des fenêtres. Tout le reste d'un
# bureau (barre, lanceur, notifications, verrouillage, fond d'écran,
# presse-papiers, captures…) est assemblé ICI, à partir de briques
# indépendantes — une brique = un rôle.
#
# /!\ INERTE tant que ce fichier n'est pas importé depuis
#     parts/desktop/default.nix. Et même importé, il n'autostart rien :
#     c'est niri (niri.nix) qui lancera ces outils via spawn-at-startup.
#     => Sous Plasma, rien de tout ceci ne tourne.
#
# Choix assumé : on dépose de VRAIS fichiers de config (xdg.configFile),
# pas les modules HM « programs.* ». Config transparente et éditable à la
# main, dans l'esprit de niri.
{ pkgs, ... }:
{
  home-manager.users.vincent = {

    # ── Les briques (un paquet = un rôle) ───────────────────────────────
    home.packages = with pkgs; [
      waybar             # barre de statut
      fuzzel             # lanceur d'applications
      mako               # démon de notifications
      libnotify          # notify-send (pour tester les notifs)
      swaybg             # fond d'écran
      swaylock           # verrouillage d'écran
      swayidle           # mise en veille / extinction écran (DPMS)
      grim               # capture d'écran (les pixels)
      slurp              # sélection d'une région à l'écran
      wl-clipboard       # wl-copy / wl-paste
      cliphist           # historique de presse-papiers
      brightnessctl      # contrôle de la luminosité
      playerctl          # contrôle média (play / pause / next)
      pamixer            # volume Pipewire/Pulse
      xwayland-satellite # pont pour faire tourner les apps X11 sous niri
    ];

    # ── Leurs fichiers de config (vrais fichiers, éditables à la main) ──

    # Lanceur — fuzzel
    xdg.configFile."fuzzel/fuzzel.ini".text = ''
      [main]
      font=MesloLGS Nerd Font:size=12
      terminal=kitty
      layer=overlay
      width=40
      lines=12

      [colors]
      background=1e1e2eee
      text=cdd6f4ff
      selection=585b70ff
      selection-text=cdd6f4ff
      border=89b4faff

      [border]
      width=2
      radius=10
    '';

    # Notifications — mako
    xdg.configFile."mako/config".text = ''
      font=MesloLGS Nerd Font 11
      background-color=#1e1e2e
      text-color=#cdd6f4
      border-color=#89b4fa
      border-size=2
      border-radius=10
      default-timeout=5000
      margin=10
      padding=12
    '';

    # Verrouillage — swaylock
    xdg.configFile."swaylock/config".text = ''
      color=1e1e2e
      font=MesloLGS Nerd Font
      indicator-radius=100
      indicator-thickness=8
      ring-color=585b70
      key-hl-color=89b4fa
      inside-color=1e1e2e
      text-color=cdd6f4
    '';

    # Barre — waybar (config minimale de départ, à enrichir plus tard)
    xdg.configFile."waybar/config.jsonc".text = ''
      {
        "layer": "top",
        "position": "top",
        "height": 30,
        "modules-left": ["clock"],
        "modules-center": [],
        "modules-right": ["pulseaudio", "network", "cpu", "memory", "tray"],
        "clock": { "format": "{:%a %d %b  %H:%M}" },
        "cpu": { "format": " {usage}%" },
        "memory": { "format": " {}%" },
        "network": {
          "format-wifi": " {essid}",
          "format-ethernet": " {ifname}",
          "format-disconnected": "⚠ off"
        },
        "pulseaudio": {
          "format": "{icon} {volume}%",
          "format-muted": "🔇 muted",
          "format-icons": { "default": ["", "", ""] },
          "on-click": "pamixer -t"
        },
        "tray": { "spacing": 8 }
      }
    '';

    xdg.configFile."waybar/style.css".text = ''
      * {
        font-family: "MesloLGS Nerd Font";
        font-size: 13px;
      }
      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
      }
      #clock, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
      }
    '';
  };
}
