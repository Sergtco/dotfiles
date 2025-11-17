{pkgs, ...}: {
  home.packages = with pkgs; [unstable.sesh];
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
    extraConfig = ''
      # Set new panes in current dir
      set -gu default-command
      set -g default-shell "$SHELL"
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      set-window-option -g window-status-current-style 'fg=white,bg=black'

      bind-key "f" run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '>  ' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(>  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}'
      )\""
    '';
  };
}
