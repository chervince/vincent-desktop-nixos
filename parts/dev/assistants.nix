# Assistants IA — Claude Code, Codex
# mcp-nixos retiré du paquet (build cassé upstream aioboto3) — utiliser via nix run
{ pkgs, claude-code, codex-cli-nix, ... }:
let
  system = "x86_64-linux";
in
{
  home-manager.users.vincent = { config, lib, pkgs, ... }:
  let
    # Semence *writable* pour Codex : il réécrit config.toml au runtime (voir
    # l'activation plus bas), donc on ne peut pas le figer en symlink du store.
    codexConfigSeed = pkgs.writeText "codex-config-seed.toml" ''
      [mcp_servers.nixos]
      command = "bash"
      args = ["-lc", "exec nix run github:utensils/mcp-nixos --"]

      [projects."/home/vincent"]
      trust_level = "trusted"

      [projects."/home/vincent/.config/nixos"]
      trust_level = "trusted"
    '';
  in
  {
    home.packages = [
      claude-code.packages.${system}.default
      codex-cli-nix.packages.${system}.default
      pkgs.pi-coding-agent      # ← Pi (terminal coding agent)
      pkgs.bubblewrap
    ];

    home.sessionVariables = {
      CLAUDE_CONFIG_DIR = "$HOME/.config/claude";
      CODEX_HOME = "$HOME/.config/codex";
    };

    # Kimi CLI — binaire auto-installé hors Nix (~/.kimi-code/bin), on déclare juste le PATH
    programs.fish.shellInit = ''
      fish_add_path $HOME/.kimi-code/bin
    '';

    # Sourcer les clés API depuis un fichier .env non versionné
    programs.fish.interactiveShellInit = ''
      if test -f ~/.config/ai-keys.env
        for line in (grep -v '^#' ~/.config/ai-keys.env | grep -v '^\s*$')
          set -gx (string split -m 1 '=' $line)
        end
      end
    '';

    # Config MCP pour Claude Code (mcp-nixos via nix run)
    home.file.".config/claude/.mcp.json".text = builtins.toJSON {
      mcpServers = {
        nixos = {
          command = "bash";
          args = [ "-lc" "exec nix run github:utensils/mcp-nixos --" ];
          type = "stdio";
        };
      };
    };

    # Config MCP + trust pour Codex.
    # Codex réécrit lui-même config.toml au runtime (trust des dossiers, trust
    # des hooks, activation de plugins, modèle via /model…). On ne peut donc pas
    # le figer en symlink read-only du store, sinon chaque écriture échoue avec
    # « config/batchWrite failed: failed to persist config.toml ».
    # On sème à la place un fichier *writable* que Codex possède et met à jour,
    # en ré-injectant notre bloc MCP s'il venait à disparaître (self-healing).
    home.activation.codexConfigSeed = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      cfg="$HOME/.config/codex/config.toml"
      if [ -L "$cfg" ] || [ ! -e "$cfg" ]; then
        # Absent, ou reliquat de symlink read-only : (re)crée un fichier writable.
        rm -f "$cfg"
        install -m600 -D ${codexConfigSeed} "$cfg"
      elif ! ${pkgs.gnugrep}/bin/grep -q '^\[mcp_servers\.nixos\]' "$cfg"; then
        # Fichier writable existant sans notre bloc MCP : on le ré-injecte.
        printf '\n' >> "$cfg"
        cat ${codexConfigSeed} >> "$cfg"
      fi
    '';
  };
}
