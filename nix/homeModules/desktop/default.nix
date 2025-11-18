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
}
