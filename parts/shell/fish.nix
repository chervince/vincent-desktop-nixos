# Fish shell + aliases personnalisés via Home Manager
{ ... }:
{
  # Fish doit aussi être déclaré au niveau système pour servir de login shell
  programs.fish.enable = true;

  home-manager.users.vincent = {
    programs.fish = {
      enable = true;
      shellAliases = {
        cc = "claude";
        ccc = "claude --continue";
        please = "sudo";
        ll = "eza -la --icons";
        la = "eza -a --icons";
        lt = "eza --tree --icons";
        cat = "bat";
      };
    };
  };
}
