# parts/dev/tmux.nix — tmux workstation, meme prefix Ctrl-a que la VPS
{ ... }:
{
  home-manager.users.vincent.programs.tmux = {
    enable = true;
    shortcut = "a";              # prefix Ctrl-a (defaut tmux = Ctrl-b)
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      set -g focus-events on
      set -g renumber-windows on

      # splits gardent le cwd
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "config reloaded"

      # status bar minimaliste
      set -g status-interval 5
      set -g status-style "fg=white,bg=default"
      set -g status-left "#[fg=cyan,bold] #S #[default]"
      set -g status-left-length 40
      set -g status-right "#[fg=yellow]#h #[fg=white]%H:%M "
      set -g status-right-length 40
      set -g window-status-current-style "fg=black,bg=cyan,bold"
      set -g window-status-format " #I:#W "
      set -g window-status-current-format " #I:#W "
    '';
  };
}
