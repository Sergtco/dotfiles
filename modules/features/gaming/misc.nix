{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.gaming =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      returnToGamingMode = pkgs.writeShellScriptBin "return-to-gaming-mode" ''
        set -eu

        state="$HOME/.local/state/steamos-session"
        mkdir -p "$(dirname "$state")"
        printf 'gamescope\n' > "$state"

        if [ -n "''${NIRI_SOCKET:-}" ]; then
          exec niri msg action quit --skip-confirmation
        else
          exec loginctl terminate-session "''${XDG_SESSION_ID:-$(loginctl --no-legend list-sessions | awk -v u="$USER" '$3==u{print $1; exit}')}"
        fi
      '';

      returnToGamingModeItem = pkgs.makeDesktopItem {
        name = "return-to-gaming-mode";
        desktopName = "Gaming Mode";
        exec = "${returnToGamingMode}/bin/return-to-gaming-mode";
        icon = "steam";
        terminal = false;
        categories = [ "Game" ];
      };
    in
    {
      environment.systemPackages = [ returnToGamingModeItem ];
    };
}
