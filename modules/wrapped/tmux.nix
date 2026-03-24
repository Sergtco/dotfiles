{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, lib, ...}: {
    packages.tmux = inputs.wrapper-modules.wrappers.tmux.wrap {
      inherit pkgs;
      extraPackages = with pkgs; [
        skim
        sesh
        zoxide
      ];

      baseIndex = 1;
      clock24 = true;
      disableConfirmationPrompt = true;
      escapeTime = 0;
      terminal = "tmux-256color";
      shell = "$SHELL";
      configAfter = ''
        # Set new panes in current dir
        set-window-option -g mode-keys vi 
        set -gu default-command
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        set-window-option -g window-status-current-style 'fg=white,bg=black'

        bind-key "f" run-shell "${lib.getExe pkgs.sesh} connect \"$(
          sesh list --icons | ${lib.getExe pkgs.skim} --tmux center,80%,70% \
            --no-sort --ansi  --prompt '>  ' \
            --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(>  )+reload(sesh list --icons)' \
            --preview-window 'right:55%' \
            --preview '${lib.getExe pkgs.sesh} preview {}'
        )\""
      '';

      configBefore = ''
        # LACKLUSTER THEME BEGIN
        color_lack="#708090"
        color_luster="#deeeed"
        color_orange="#ffaa88"
        color_green="#789978"
        color_blue="#7788AA"
        color_red="#D70000"
        color_black="#000000"
        color_gray1="#080808"
        color_gray2="#191919"
        color_gray3="#2a2a2a"
        color_gray4="#444444"
        color_gray5="#555555"
        color_gray6="#7a7a7a"
        color_gray7="#aaaaaa"
        color_gray8="#cccccc"
        color_gray9="#DDDDDD"

        # NOTE: color variable expansion only works in double quotes
        set-option -g status-fg                     "$color_luster"
        set-option -g status-bg                     "$color_gray2"
        set-option -g copy-mode-current-match-style "fg=$color_gray1,bg=$color_gray8"
        set-option -g copy-mode-match-style         "fg=$color_gray1,bg=$color_gray8"
        set-option -g menu-selected-style           "fg=$color_gray1,bg=$color_luster"
        set-option -g menu-style                    "fg=$color_luster,bg=$color_gray1"
        set-option -g message-style                 "bg=$color_gray6,fg=$color_gray1" # command in vi-insert mode
        set-option -g message-command-style         "bg=$color_gray6,fg=$color_gray4" # command in vi-normal mode
        set-option -g mode-style                    "bg=$color_gray8,fg=$color_gray1"
        set-option -g pane-active-border-style      "fg=$color_gray1"
        set-option -g pane-border-lines             "heavy"
        set-option -g pane-border-style             "fg=$color_gray1"
        set-option -g pane-border-style             "fg=$color_gray5"
        set-option -g popup-border-lines            "rounded"
        set-option -g status-right-style            "fg=$color_gray6"
        set-option -g window-status-current-style   "fg=$color_gray8"
        set-option -g window-status-style           "fg=$color_gray6"
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
      '';

    };
  };
}
