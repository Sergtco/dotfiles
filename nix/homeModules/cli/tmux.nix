{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    clock24 = true;
    newSession = true;
    disableConfirmationPrompt = true;
    focusEvents = true;
    escapeTime = 0;
    mouse = true;
    customPaneNavigationAndResize = true;
    terminal = "tmux-256color";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
    ];
    extraConfig = ''
      # Set new panes in current dir
      set -gu default-command
      set -g default-shell "$SHELL"
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      set-window-option -g window-status-current-style 'fg=white,bg=black'
    '';
  };
}
