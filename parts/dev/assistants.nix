# Assistants IA — Claude Code, Codex
# mcp-nixos retiré du paquet (build cassé upstream aioboto3) — utiliser via nix run
{ pkgs, claude-code, codex-cli-nix, ... }:
let
  system = "x86_64-linux";
in
{
  home-manager.users.vincent = {
    home.packages = [
      claude-code.packages.${system}.default
      codex-cli-nix.packages.${system}.default
      pkgs.bubblewrap
    ];

    home.sessionVariables = {
      CLAUDE_CONFIG_DIR = "$HOME/.config/claude";
      CODEX_HOME = "$HOME/.config/codex";
    };

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

    # Config MCP pour Codex (mcp-nixos via nix run)
    home.file.".config/codex/config.toml".text = ''
      [mcp_servers.nixos]
      command = "bash"
      args = ["-lc", "exec nix run github:utensils/mcp-nixos --"]
    '';
  };
}
