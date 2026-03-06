{
  inputs,
  pkgs,
  ...
}: let
  vicinae = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
  manifestName = "com.vicinae.vicinae.json";
  conf_text = ''
    {
    "name": "com.vicinae.vicinae",
      "description": "Vicinae native messaging host",
      "path": "${vicinae}/libexec/vicinae/vicinae-browser-link",
      "type": "stdio",
      "allowed_origins": [
        "chrome-extension://kcmipingpfbohfjckomimmahknoddnke/"
      ]
    }
  '';
in {
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    vicinae
  ];
  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        HTTP_PROXY = "http://127.0.0.1:10809";
        HTTPS_PROXY = "http://127.0.0.1:10809";
        USE_LAYER_SHELL = 1;
        NODE_USE_ENV_PROXY = 1;
      };
    };
    settings = {
      pop_to_root_on_close = true;

      launcher_window = {
        layer_shell = {
          enabled = true;
          keyboard_interactivity = "exclusive";
          layer = "overlay";
        };
      };
      theme = {
        light.name = "stylix";
        light.icon_theme = "Tela-black-light";

        dark.name = "stylix";
        dark.icon_theme = "Tela-black-dark";
      };
      font.normal.size = 11;
      launcher_window.client_side_decorations.enabled = false;
      providers = {
        core.entrypoints.store.enabled = false;
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      process-manager
      nix
    ];
  };

  home.file.".config/chromium/NativeMessagingHosts/${manifestName}".text = conf_text;
  home.file.".config/net.imput.helium/NativeMessagingHosts/${manifestName}".text = conf_text;
  home.file.".local/share/vicinae/scripts".source = ./vicinae-scripts;
}
