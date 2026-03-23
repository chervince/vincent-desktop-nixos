# Android Studio + SDK + émulateur
  { pkgs, ... }:
  let
    android-emulator-fhs = pkgs.buildFHSEnv {
      name = "emulator";
      targetPkgs = pkgs: with pkgs; [
        # Libs exactement comme nixpkgs android-studio common.nix
        fontconfig freetype
        libxext libxi libxrender libxtst
        libxrandr libxcomposite libxcursor libxdamage libxfixes
        libx11 libxcb libxkbcommon libxkbfile
        libxcb-wm libxcb-render-util libxcb-keysyms libxcb-image libxcb-cursor
        libice libsm
        alsa-lib dbus expat
        libbsd libuuid libsecret
        libpulseaudio
        libGL libdrm libpng
        zlib glib
        nspr nss_latest
        gtk2 glib wayland
        e2fsprogs systemd
        stdenv.cc.cc.lib
      ];
      runScript = pkgs.writeShellScript "android-emulator-run" ''
        export ANDROID_HOME="$HOME/Android/Sdk"
        export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
        export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
        export LD_LIBRARY_PATH="$HOME/Android/Sdk/emulator/lib64:$HOME/Android/Sdk/emulator/lib64/gles_swiftshader:$LD_LIBRARY_PATH"
        exec "$HOME/Android/Sdk/emulator/emulator" "$@"
      '';
    };
  in
  {
    programs.nix-ld.enable = true;

    home-manager.users.vincent.home.packages = with pkgs; [
      android-studio
      jdk
      android-emulator-fhs
    ];

    home-manager.users.vincent.home.sessionVariables = {
      ANDROID_HOME = "$HOME/Android/Sdk";
      ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    };

    home-manager.users.vincent.programs.fish.shellInit = ''
      fish_add_path $HOME/Android/Sdk/platform-tools
    '';

    users.users.vincent.extraGroups = [ "kvm" ];
  }