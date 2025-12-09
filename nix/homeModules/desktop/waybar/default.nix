{pkgs, ...}: {
  home.packages = with pkgs; [
    playerctl
    nerd-fonts.fira-code
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
    settings = {
      default = {
        layer = "top";
        position = "bottom";
        height = 30;
        mode = "dock";
        start_hidden = true;
        modules-left = ["clock" "battery" "idle_inhibitor" "niri/workspaces" "tray"];
        modules-center = ["mpris"];
        modules-right = ["wireplumber" "bluetooth" "network"];
        tray = {
          icon-size = 20;
          spacing = 10;
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-alt" = "{time} {icon}";
          "format-full" = "󰁹 {capacity}%";
          "format-icons" = [
            "󰁺"
            "󰁽"
            "󰂁"
          ];
        };
        "niri/workspaces" = {
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
          format-wifi = " {signalStrength}%";
          format-ethernet = "{ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
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
          format-muted = "󰝟";
          format-icons = [
            ""
            ""
            ""
          ];
          on-click = "pavucontrol";
        };
        bluetooth = {
          format = " {device_battery_percentage}%";
          format-on = "";
          format-off = "󰂲";
          on-click = "blueman-manager";
        };
        mpris = {
          format = "{status_icon} <b>{artist}</b> - {title}";
          status-icons = {
            paused = "󰏤";
          };
        };
        clock = {
          format = "{:%H:%M}";
          interval = 60;
          tooltip = true;
          tooltip-format = "{:%d %B %H:%M}";
        };
      };
    };
  };
}
