# Terminal Kitty — Catppuccin Mocha, MesloLG Nerd Font
{ ... }:
{
  home-manager.users.vincent.programs.kitty = {
    enable = true;
    font = {
      name = "MesloLGL Nerd Font Mono";
      size = 14;
    };
    settings = {
      background_opacity = "0.7";
      hide_window_decorations = "yes";
      window_padding_width = 10;
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
    themeFile = "Catppuccin-Mocha";
  };
}
