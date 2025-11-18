{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./mimeapps.nix
    ./browser
    ./waybar
    ./fuzzel
    ./music.nix
  ];
  xdg.userDirs.enable = true;
  services = {
    udiskie.enable = true;
    fnott = {
      enable = true;
      settings = {
        main = {
          default-timeout = 5;
          max-timeout = 10;
          selection-helper = "fuzzel --dmenu";
          layer = "overlay";
        };
      };
    };

    swayosd.enable = true;
    hyprpaper.enable = true;
    hyprpolkitagent.enable = true;
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.configFile = {
    "niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/niri/config.kdl";
  };

  programs.vesktop.enable = true;
  home.packages = with pkgs; [
    pavucontrol
    mpv
    gedit
    swayimg
    brightnessctl
    thunderbird

    libnotify
    (pkgs.writeShellScriptBin "toggle-notification" (builtins.readFile ./scripts/toggle-notification.sh))
  ];

  home.file = {
    tmux = {
      target = ".config/tmux";
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux";
      recursive = true;
    };
  };

  home.file = {

    ".config/hypr/hypridle.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/hypr/hypridle.conf";
  };

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["thunar.desktop"];
      "application/pdf" = ["firefox.destkop"];

      "text/html" = ["firefox.desktop"];
      "text/plain" = ["nvim.desktop"];
      "text/markdown" = ["nvim.desktop"];

      "video/*" = ["mpv.desktop"];
      "video/mp4" = ["mpv.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "image/*" = ["org.nomacs.ImageLounge.desktop"];

      "image/png" = ["org.nomacs.ImageLounge.desktop"];
      "image/jpeg" = ["org.nomacs.ImageLounge.desktop"];
      "image/gif" = ["org.nomacs.ImageLounge.desktop"];
    };
  };
}
