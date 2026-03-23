{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      extraPackages = with pkgs; [
        wlsunset
        hackneyed
        swaybg
        swayosd
        self'.packages.waybar
        self'.packages.fnott
        self'.packages.vicinae
      ];

      settings = {
        spawn-at-startup = [
          "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
          ["${pkgs.wlsunset}/bin/wlsunset" "-S 7:00" "-s 22:00"]
          ["vicinae" "server"]
          ["swaybg" "-i" "${../../wallpaper/dayspring_by_bisbiswas.jpg}"]
          "fnott"
          "swayosd-server"
          "helium"
          "waybar"
          "thunderbird"
          "Telegram"
        ];

        spawn-sh-at-startup = [
          "alacritty -e tmux || tmux a"
        ];

        input = {
          keyboard = {
            xkb = {
              layout = "us,ru";
              options = "grp:win_space_toggle";
            };
          };
          touchpad = {
            tap = null;
            natural-scroll = null;
            scroll-factor = 0.5;
          };
          warp-mouse-to-focus = null;
          focus-follows-mouse._attrs = {max-scroll-amount = "0%";};
        };

        # Output configuration is typically a list of sets
        outputs = {
          DP-2 = {
            variable-refresh-rate = null;
            mode = "1920x1080@165.000";
          };
          # Laptop
          eDP-1 = {
            mode = "1920x1080@60.000";
            scale = 1;
          };
        };

        window-rules = [
          {
            geometry-corner-radius = 0;
            clip-to-geometry = true;
          }
          # Picture-in-Picture / Notifications
          {
            matches = [
              {title = "^[pP]icture[ -]in[ -][pP]icture$";}
              {
                app-id = "thunderbird$";
                title = "Reminder[s]*$";
              }
            ];
            open-floating = true;
          }
          # Steam notifications
          {
            match._attrs = {
              app-id = "steam";
              title = "^notificationtoasts_\d+_desktop$";
            };
            default-floating-position._attrs = {
              x = 10;
              y = 10;
              relative-to = "bottom-right";
            };
          }
          # Startup apps
          {
            matches = [
              {
                at-startup = true;
                app-id = "^alacritty$";
              }
              {
                at-startup = true;
                app-id = "^helium$";
              }
            ];
            open-on-workspace = "1main";
            open-focused = true;
          }
          {
            matches = [
              {
                at-startup = true;
                app-id = "^org.telegram.desktop$";
              }
              {
                at-startup = true;
                app-id = "^thunderbird$";
              }
            ];
            open-on-workspace = "2comms";
            open-focused = false;
          }
        ];

        layout = {
          gaps = 5;
          center-focused-column = "never";
          preset-column-widths = [
            {proportion = 0.33333;}
            {proportion = 0.5;}
            {proportion = 0.66667;}
          ];
          default-column-width = {proportion = 0.5;};
          focus-ring = {
            width = 1;
            active-color = "#708090";
            inactive-color = "#414141";
          };
          tab-indicator = {
            place-within-column = true;
            gap = 3;
            width = 3;
            length._attrs = {total-proportion = 0.95;};
            position = "right";
            gaps-between-tabs = 2;
            corner-radius = 8;
          };
        };

        cursor = {
          xcursor-theme = "Hackneyed";
          xcursor-size = 24;
        };

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        workspaces = {
          "1main" = null;
          "2comms" = null;
        };

        hotkey-overlay.skip-at-startup = null;

        prefer-no-csd = true;

        binds = {
          "Mod+X" = {
            spawn = "alacritty";
          };
          "Mod+D" = {
            spawn = ["vicinae" "toggle"];
          };
          "Mod+B" = {
            spawn-sh = "killall -SIGUSR1 -r waybar";
          };

          "XF86AudioRaiseVolume" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "swayosd-client --output-volume raise";
          };
          "XF86AudiolowerVolume" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "swayosd-client --output-volume lower";
          };
          "XF86AudioMute" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "swayosd-client --output-volume mute-toggle";
          };
          "CTRL+XF86AudioMute" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "swayosd-client --input-volume mute-toggle";
          };
          "XF86AudioMicMute" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "swayosd-client --input-volume mute-toggle";
          };
          "XF86AudioNext" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "playerctl next";
          };
          "XF86AudioPrev" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "playerctl previous";
          };
          "XF86AudioPlay" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "playerctl play-pause";
          };
          "XF86MonBrightnessUp" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "swayosd-client --brightness raise";
          };
          "XF86MonBrightnessDown" = {
            _attrs.allow-when-locked = true;
            spawn-sh = "swayosd-client --brightness lower";
          };

          "Mod+O" = {
            _attrs.repeat = false;
            toggle-overview = null;
          };
          "Mod+Q" = {
            _attrs.repeat = false;
            close-window = null;
          };

          "Mod+H".focus-column-left = null;
          "Mod+J".focus-window-down = null;
          "Mod+K".focus-window-up = null;
          "Mod+L".focus-column-right = null;

          "Mod+Ctrl+H".move-column-left = null;
          "Mod+Ctrl+J".move-window-down = null;
          "Mod+Ctrl+K".move-window-up = null;
          "Mod+Ctrl+L".move-column-right = null;

          "Mod+Home".focus-column-first = null;
          "Mod+End".focus-column-last = null;
          "Mod+Ctrl+Home".move-column-to-first = null;
          "Mod+Ctrl+End".move-column-to-last = null;

          "Mod+Shift+H".focus-monitor-left = null;
          "Mod+Shift+J".focus-monitor-down = null;
          "Mod+Shift+K".focus-monitor-up = null;
          "Mod+Shift+L".focus-monitor-right = null;

          "Mod+Shift+Ctrl+H".move-column-to-monitor-left = null;
          "Mod+Shift+Ctrl+J".move-column-to-monitor-down = null;
          "Mod+Shift+Ctrl+K".move-column-to-monitor-up = null;
          "Mod+Shift+Ctrl+L".move-column-to-monitor-right = null;

          "Mod+U".focus-workspace-down = null;
          "Mod+I".focus-workspace-up = null;

          "Mod+Ctrl+U".move-column-to-workspace-down = null;
          "Mod+Ctrl+I".move-column-to-workspace-up = null;

          "Mod+Shift+U".move-workspace-down = null;
          "Mod+Shift+I".move-workspace-up = null;

          "Mod+WheelScrollDown" = {
            _attrs.cooldown-ms = 150;
            focus-workspace-down = null;
          };
          "Mod+WheelScrollUp" = {
            _attrs.cooldown-ms = 150;
            focus-workspace-up = null;
          };
          "Mod+Ctrl+WheelScrollDown" = {
            _attrs.cooldown-ms = 150;
            move-column-to-workspace-down = null;
          };
          "Mod+Ctrl+WheelScrollUp" = {
            _attrs.cooldown-ms = 150;
            move-column-to-workspace-up = null;
          };

          "Mod+WheelScrollRight".focus-column-right = null;
          "Mod+WheelScrollLeft".focus-column-left = null;
          "Mod+Ctrl+WheelScrollRight".move-column-right = null;
          "Mod+Ctrl+WheelScrollLeft".move-column-left = null;

          "Mod+Shift+WheelScrollDown".focus-column-right = null;
          "Mod+Shift+WheelScrollUp".focus-column-left = null;
          "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = null;
          "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = null;

          "Mod+1".focus-workspace = "1main";
          "Mod+2".focus-workspace = "2comms";
          "Mod+3".focus-workspace = "3";
          "Mod+4".focus-workspace = "4";
          "Mod+5".focus-workspace = "5";
          "Mod+6".focus-workspace = "6";
          "Mod+7".focus-workspace = "7";
          "Mod+8".focus-workspace = "8";
          "Mod+9".focus-workspace = "9";

          "Mod+Ctrl+1".move-column-to-workspace = "1main";
          "Mod+Ctrl+2".move-column-to-workspace = "2comms";
          "Mod+Ctrl+3".move-column-to-workspace = "3";
          "Mod+Ctrl+4".move-column-to-workspace = "4";
          "Mod+Ctrl+5".move-column-to-workspace = "5";
          "Mod+Ctrl+6".move-column-to-workspace = "6";
          "Mod+Ctrl+7".move-column-to-workspace = "7";
          "Mod+Ctrl+8".move-column-to-workspace = "8";
          "Mod+Ctrl+9".move-column-to-workspace = "9";

          "Mod+BracketLeft".consume-or-expel-window-left = null;
          "Mod+BracketRight".consume-or-expel-window-right = null;

          "Mod+Comma".consume-window-into-column = null;
          "Mod+Period".expel-window-from-column = null;

          "Mod+R".switch-preset-column-width = null;
          "Mod+Shift+R".switch-preset-window-height = null;
          "Mod+Ctrl+R".reset-window-height = null;

          "Mod+F".maximize-column = null;
          "Mod+Shift+F".fullscreen-window = null;
          "Mod+Ctrl+F".expand-column-to-available-width = null;

          "Mod+C".center-column = null;
          "Mod+Ctrl+C".center-visible-columns = null;

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";

          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+V".toggle-window-floating = null;
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = null;

          "Mod+W".toggle-column-tabbed-display = null;

          "Mod+N".spawn-sh = "fnottctl action";
          "Mod+Shift+N".spawn-sh = "toggle-notification";

          "Print".screenshot = null;
          "Ctrl+Print".screenshot-screen = null;
          "Alt+Print".screenshot-window = null;

          "Mod+Escape" = {
            _attrs.allow-inhibiting = false;
            toggle-keyboard-shortcuts-inhibit = null;
          };

          "Mod+Shift+E".quit = null;

          "Mod+Shift+P".spawn-sh = "niri msg action power-off-monitors && loginctl lock-session";
        };
      };
      env = {
        NIXOS_OZONE_WL = "1";
        XCURSOR_NAME = "Hackneyed";
        XCURSOR_SIZE = "24";
        XCURSOR_PATH = "$XCURSOR_PATH:${pkgs.hackneyed}/share/icons";
      };
      passthru = {
        providedSessions = ["niri"];
      };
    };
  };
}
