{pkgs, ...}: {
  home.packages = with pkgs; [
    blesh
  ];
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = ["ignoredups"];

    shellAliases = {
      nv = "nvim";
      tm = "tmux a || tmux";
    };
    bashrcExtra = ''
      [[ $- == *i* ]] && source "$(blesh-share)"/ble.sh --noattach
      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';

    profileExtra = ''
      bind 'set completion-ignore-case on'
    '';
  };

  home.sessionPath = [
    "/home/sergtco/.cargo/bin/"
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;

      config.global.hide_env_diff = true;
    };

    oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      useTheme = "pure";
    };
  };
}
