{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      self',
      lib,
      ...
    }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        extraPackages = with pkgs; [
          xwayland-satellite
          hackneyed
          swayosd
          fnott
          unstable.vicinae
          self'.packages.alacritty
          self'.packages.tmux
          self'.packages.waybar
        ];

        settings = {
          spawn-at-startup = [
            [
              "vicinae"
              "server"
            ]
            [
              "alacritty"
              "-e"
              "tmux"
            ]
            "helium"
            "thunderbird"
            "Telegram"
          ];

          input = {
            keyboard = {
              xkb = {
                layout = "us,ru";
                options = "grp:win_space_toggle";
              };
            };
            touchpad = {
              tap = (_: { });
              natural-scroll = (_: { });
              scroll-factor = 0.5;
            };
            warp-mouse-to-focus = (_: { });
            focus-follows-mouse = _: {
              props = {
                max-scroll-amount = "0%";
              };
            };
          };

          # Output configuration is typically a list of sets
          outputs = {
            DP-2 = {
              variable-refresh-rate = (_: { });
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
                { title = "^[pP]icture[ -]in[ -][pP]icture$"; }
                {
                  app-id = "thunderbird$";
                  title = "Reminder[s]*$";
                }
              ];
              open-floating = true;
            }
            # Steam notifications
            {
              matches = [
                {
                  app-id = "steam";
                  title = "^notificationtoasts_\\d+_desktop$";
                }
              ];
              default-floating-position = _: {
                props = {
                  x = 10;
                  y = 10;
                  relative-to = "bottom-right";
                };
              };
              open-focused = false;
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
              { proportion = 0.33333; }
              { proportion = 0.5; }
              { proportion = 0.66667; }
            ];
            default-column-width = {
              proportion = 0.5;
            };
            focus-ring = {
              width = 1;
              active-color = "#708090";
              inactive-color = "#414141";
            };
            tab-indicator = {
              place-within-column = true;
              gap = 3;
              width = 3;
              length = _: {
                props.total-proportion = 0.95;
              };
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
            "1main" = (_: { });
            "2comms" = (_: { });
          };

          hotkey-overlay.skip-at-startup = (_: { });

          prefer-no-csd = true;

          binds = {
            "Mod+X" = {
              spawn = "alacritty";
            };
            "Mod+D" = {
              spawn = [
                "vicinae"
                "toggle"
              ];
            };
            "Mod+B" = {
              spawn-sh = "${lib.getExe pkgs.killall} -SIGUSR1 -r waybar";
            };

            "XF86AudioRaiseVolume" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "swayosd-client --output-volume raise";
            };
            "XF86AudioLowerVolume" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "swayosd-client --output-volume lower";
            };
            "XF86AudioMute" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "swayosd-client --output-volume mute-toggle";
            };
            "CTRL+XF86AudioMute" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "swayosd-client --input-volume mute-toggle";
            };
            "XF86AudioMicMute" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "swayosd-client --input-volume mute-toggle";
            };
            "XF86AudioNext" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "playerctl next";
            };
            "XF86AudioPrev" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "playerctl previous";
            };
            "XF86AudioPlay" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "playerctl play-pause";
            };
            "XF86MonBrightnessUp" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "swayosd-client --brightness raise";
            };
            "XF86MonBrightnessDown" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "swayosd-client --brightness lower";
            };
            "Mod+O" = _: {
              props.repeat = false;
              content.toggle-overview = (_: { });
            };
            "Mod+Q" = _: {
              props.repeat = false;
              content.close-window = (_: { });
            };

            "Mod+H".focus-column-left = (_: { });
            "Mod+J".focus-window-down = (_: { });
            "Mod+K".focus-window-up = (_: { });
            "Mod+L".focus-column-right = (_: { });

            "Mod+Ctrl+H".move-column-left = (_: { });
            "Mod+Ctrl+J".move-window-down = (_: { });
            "Mod+Ctrl+K".move-window-up = (_: { });
            "Mod+Ctrl+L".move-column-right = (_: { });

            "Mod+Home".focus-column-first = (_: { });
            "Mod+End".focus-column-last = (_: { });
            "Mod+Ctrl+Home".move-column-to-first = (_: { });
            "Mod+Ctrl+End".move-column-to-last = (_: { });

            "Mod+Shift+H".focus-monitor-left = (_: { });
            "Mod+Shift+J".focus-monitor-down = (_: { });
            "Mod+Shift+K".focus-monitor-up = (_: { });
            "Mod+Shift+L".focus-monitor-right = (_: { });

            "Mod+Shift+Ctrl+H".move-column-to-monitor-left = (_: { });
            "Mod+Shift+Ctrl+J".move-column-to-monitor-down = (_: { });
            "Mod+Shift+Ctrl+K".move-column-to-monitor-up = (_: { });
            "Mod+Shift+Ctrl+L".move-column-to-monitor-right = (_: { });

            "Mod+U".focus-workspace-down = (_: { });
            "Mod+I".focus-workspace-up = (_: { });

            "Mod+Ctrl+U".move-column-to-workspace-down = (_: { });
            "Mod+Ctrl+I".move-column-to-workspace-up = (_: { });

            "Mod+Shift+U".move-workspace-down = (_: { });
            "Mod+Shift+I".move-workspace-up = (_: { });

            "Mod+WheelScrollDown" = _: {
              props.cooldown-ms = 150;
              content.focus-workspace-down = (_: { });
            };
            "Mod+WheelScrollUp" = _: {
              props.cooldown-ms = 150;
              content.focus-workspace-up = (_: { });
            };
            "Mod+Ctrl+WheelScrollDown" = _: {
              props.cooldown-ms = 150;
              content.move-column-to-workspace-down = (_: { });
            };
            "Mod+Ctrl+WheelScrollUp" = _: {
              props.cooldown-ms = 150;
              content.move-column-to-workspace-up = (_: { });
            };

            "Mod+WheelScrollRight".focus-column-right = (_: { });
            "Mod+WheelScrollLeft".focus-column-left = (_: { });
            "Mod+Ctrl+WheelScrollRight".move-column-right = (_: { });
            "Mod+Ctrl+WheelScrollLeft".move-column-left = (_: { });

            "Mod+Shift+WheelScrollDown".focus-column-right = (_: { });
            "Mod+Shift+WheelScrollUp".focus-column-left = (_: { });
            "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = (_: { });
            "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = (_: { });

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

            "Mod+BracketLeft".consume-or-expel-window-left = (_: { });
            "Mod+BracketRight".consume-or-expel-window-right = (_: { });

            "Mod+Comma".consume-window-into-column = (_: { });
            "Mod+Period".expel-window-from-column = (_: { });

            "Mod+R".switch-preset-column-width = (_: { });
            "Mod+Shift+R".switch-preset-window-height = (_: { });
            "Mod+Ctrl+R".reset-window-height = (_: { });

            "Mod+F".maximize-column = (_: { });
            "Mod+Shift+F".fullscreen-window = (_: { });
            "Mod+Ctrl+F".expand-column-to-available-width = (_: { });

            "Mod+C".center-column = (_: { });
            "Mod+Ctrl+C".center-visible-columns = (_: { });

            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";

            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            "Mod+V".toggle-window-floating = (_: { });
            "Mod+Shift+V".switch-focus-between-floating-and-tiling = (_: { });

            "Mod+W".toggle-column-tabbed-display = (_: { });

            "Mod+N".spawn-sh = "fnottctl action";
            "Mod+Shift+N".spawn-sh = "toggle-notification";

            "Print".screenshot = (_: { });
            "Ctrl+Print".screenshot-screen = (_: { });
            "Alt+Print".screenshot-window = (_: { });

            "Mod+Escape" = _: {
              props.allow-inhibiting = false;
              content.toggle-keyboard-shortcuts-inhibit = (_: { });
            };

            "Mod+Shift+E".quit = (_: { });

            "Mod+Shift+P".spawn-sh = "niri msg action power-off-monitors && loginctl lock-session";
          };
          layer-rule = {
            match = _: { props.namespace = "^wallpaper$"; };
            place-within-backdrop = true;
          };

          layout = {
            background-color = "transparent";
          };

          overview = {
            workspace-shadow = {
              off = (_: { });
            };
          };
        };
        env = {
          NIXOS_OZONE_WL = "1";
          XCURSOR_NAME = "Hackneyed";
          XCURSOR_SIZE = "24";
        };
        prefixVar = [
          [
            "XCURSOR_PATH"
            ":"
            "${pkgs.hackneyed}/share/icons"
          ]
        ];
        passthru = {
          providedSessions = [ "niri" ];
        };
      };
    };
}
