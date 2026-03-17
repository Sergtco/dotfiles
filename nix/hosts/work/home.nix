{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../homeModules/nvim
    ../../homeModules/shell
    ../../homeModules/cli
    ../../homeModules/terminal
    ../../homeModules/desktop/browser.nix
    inputs.stylix.homeModules.stylix
    inputs.paneru.homeModules.paneru
  ];
  stylix = let
    themes = import ../../modules/themes/themes.nix {};
  in {
    enable = true;
    base16Scheme = themes.lackluster;
    fonts = {
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Apple Color Emoji";
      };
      sizes.desktop = 13;
      sizes.terminal = 13;
      sizes.popups = 14;
    };
    targets.neovim.enable = false;
  };
  programs.home-manager.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = lib.mkForce "ZedMono Nerd Font Mono";
      window.decorations = "None";
    };
  };
  fonts.fontconfig.enable = true;

  services.paneru = {
    enable = true;
    # Equivalent to what you would put into `~/.paneru` (See Configuration options below).
    settings = {
      options = {
        preset_column_widths = [
          0.33
          0.5
          0.66
        ];
        swipe_gesture_fingers = 4;
        animation_speed = 40;
      };
      bindings = {
        window_focus_west = "cmd - h";
        window_focus_east = "cmd - l";
        window_focus_north = "cmd - k";
        window_focus_south = "cmd - j";
        window_swap_west = "alt - h";
        window_swap_east = "alt - l";
        window_swap_first = "alt + shift - h";
        window_swap_last = "alt + shift - l";
        window_center = "alt - c";
        window_resize = "alt - r";
        window_fullwidth = "alt - f";
        window_manage = "ctrl + alt - t";
        window_stack = "alt - ]";
        window_unstack = "alt + shift - ]";
        quit = "ctrl + alt - q";
      };
      windows.all = {
        title = ".*";
        horizontal_padding = 2;
      };
    };
  };
  home.stateVersion = "25.05";
}
