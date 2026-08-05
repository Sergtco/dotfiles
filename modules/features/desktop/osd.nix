_: {
  # On-screen display for the volume and brightness keys. There is no dedicated
  # OSD daemon: the keybinds call the `osd-*` scripts below, which apply the
  # change and then hand the new percentage to fnott as a notification carrying
  # a progress value, which it draws as a bar.
  flake.nixosModules.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      user = config.preferences.user.name;
      cfg = config.preferences.brightness;

      wpctl = lib.getExe' pkgs.wireplumber "wpctl";
      notify-send = lib.getExe' pkgs.libnotify "notify-send";
      awk = lib.getExe pkgs.gawk;
      brightnessctl = lib.getExe pkgs.brightnessctl;
      ddcutil = lib.getExe pkgs.ddcutil;

      # show <tag> <percent> <summary>
      #
      # x-canonical-private-synchronous makes fnott replace whatever it is
      # already showing under the same tag rather than stacking another
      # notification, so holding a key down updates one bar instead of filling
      # the screen. int:value is what turns it into a progress bar.
      preamble = ''
        set -eu

        show() {
          ${notify-send} \
            --app-name=osd \
            --expire-time=1000 \
            --hint="string:x-canonical-private-synchronous:$1" \
            --hint="int:value:$2" \
            "$3"
        }

        clamp() {
          if [ "$1" -lt "$2" ]; then
            echo "$2"
          elif [ "$1" -gt "$3" ]; then
            echo "$3"
          else
            echo "$1"
          fi
        }

        step=5
      '';

      osd-volume = pkgs.writeShellScriptBin "osd-volume" ''
        ${preamble}
        case "''${1-}" in
          up)
            tag=volume
            label=Volume
            target="@DEFAULT_AUDIO_SINK@"
            ${wpctl} set-volume -l 1.0 "$target" "''${step}%+"
            ;;
          down)
            tag=volume
            label=Volume
            target="@DEFAULT_AUDIO_SINK@"
            ${wpctl} set-volume -l 1.0 "$target" "''${step}%-"
            ;;
          mute)
            tag=volume
            label=Volume
            target="@DEFAULT_AUDIO_SINK@"
            ${wpctl} set-mute "$target" toggle
            ;;
          mic-mute)
            tag=microphone
            label=Microphone
            target="@DEFAULT_AUDIO_SOURCE@"
            ${wpctl} set-mute "$target" toggle
            ;;
          *)
            echo "usage: osd-volume up|down|mute|mic-mute" >&2
            exit 1
            ;;
        esac

        # Either "Volume: 0.35" or "Volume: 0.35 [MUTED]".
        state=$(${wpctl} get-volume "$target")
        pct=$(printf '%s' "$state" | ${awk} '{printf "%.0f", $2 * 100}')

        case "$state" in
          *MUTED*) show "$tag" "$pct" "$label muted" ;;
          *) show "$tag" "$pct" "$label ''${pct}%" ;;
        esac
      '';

      osd-brightness = pkgs.writeShellScriptBin "osd-brightness" (
        preamble
        + ''
          case "''${1-}" in
            up) delta="$step" ;;
            down) delta="-$step" ;;
            *)
              echo "usage: osd-brightness up|down" >&2
              exit 1
              ;;
          esac

        ''
        + (
          if cfg.backend == "brightnessctl" then
            ''
              cur=$(${brightnessctl} -m get)
              max=$(${brightnessctl} -m max)

              # Never all the way to 0: that is an unreadable screen, and no way
              # to see the bar that would let you turn it back up.
              pct=$(clamp $(( cur * 100 / max + delta )) 1 100)

              ${brightnessctl} -q set "''${pct}%"
            ''
          else
            ''
              # --brief prints "VCP 10 C <current> <max>".
              vcp=$(${ddcutil} --bus ${toString cfg.i2cBus} --brief getvcp 10)
              cur=$(printf '%s' "$vcp" | ${awk} '{print $4}')
              max=$(printf '%s' "$vcp" | ${awk} '{print $5}')

              pct=$(clamp $(( cur * 100 / max + delta )) 0 100)

              ${ddcutil} --bus ${toString cfg.i2cBus} setvcp 10 $(( pct * max / 100 ))
            ''
        )
        + ''

          show brightness "$pct" "Brightness ''${pct}%"
        ''
      );
    in
    {
      assertions = [
        {
          assertion = cfg.backend == "ddcci" -> cfg.i2cBus != null;
          message = "preferences.brightness.i2cBus must be set when the brightness backend is ddcci.";
        }
      ];

      environment.systemPackages = [
        osd-volume
        osd-brightness
        (if cfg.backend == "brightnessctl" then pkgs.brightnessctl else pkgs.ddcutil)
      ];

      # brightnessctl ships udev rules that hand the backlight class to `video`;
      # ddcutil needs raw i2c, which `hardware.i2c` hands to `i2c`.
      services.udev.packages = lib.mkIf (cfg.backend == "brightnessctl") [ pkgs.brightnessctl ];
      hardware.i2c.enable = lib.mkIf (cfg.backend == "ddcci") true;
      users.users.${user}.extraGroups =
        if cfg.backend == "brightnessctl" then [ "video" ] else [ "i2c" ];
    };
}
