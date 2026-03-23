# Git + GitHub CLI via Home Manager
{ pkgs, ... }:
{
  home-manager.users.vincent = {
    programs.git = {
      enable = true;
      signing.format = null;
      settings = {
        user.name = "chervince";
        user.email = "chervince@users.noreply.github.com";
        init.defaultBranch = "main";
        pull.rebase = true;
        credential.helper = "!/etc/profiles/per-user/vincent/bin/gh auth git-credential";
        safe.directory = "/etc/nixos";
      };
    };

    home.packages = with pkgs; [ gh ];
  };
}
