{config, ...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = config.lib.file.mkOutOfStoreSymlink ./style.css;
    settings = [
      {
        layer = "top";
        position = "bottom";
        height = 30;
        mode = "dock";
        start_hidden = false;
        modules-left =
          [
            "clock"
          ]
          ++ ["battery"]
          ++ [
            "idle_inhibitor"
            "hyprland/workspaces"
            "tray"
          ];
        modules-right = [
          "custom/notification"
          "wireplumber"
          "bluetooth"
          "network"
          "hyprland/language"
        ];
        tray = {
          icon-size = 20;
          spacing = 10;
        };
        battery = {
        };
        "hyprland/language" = {
          format = "󰌓 {long}";
          keyboard-name = "ergohaven-k:03";
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          all-outputs = true;
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "6" = "󰲪";
            "7" = "󰲬";
            "8" = "󰲮";
            "9" = "󰲰";
            "10" = "󰝚";
            "-99" = "";
            default = "";
          };
        };
        network = {
          format-wifi = "  {signalStrength}% ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{essid}: {ipaddr}/{cidr}";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰌵";
            deactivated = "󰌶";
          };
        };
        wireplumber = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          restart-interval = 1;
          scroll-step = 1;
          on-click = "pavucontrol";
        };
        bluetooth = {
          format = " {device_battery_percentage}%";
          format-on = "";
          format-off = "󰂲";
          on-click = "blueberry";
        };
        clock = {
          format = "{:%H:%M}";
          interval = 60;
          tooltip = true;
          tooltip-format = "{:%d %B %H:%M}";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
        };
      }
    ];
  };
}
