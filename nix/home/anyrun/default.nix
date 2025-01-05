{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
    ./kidex_service.nix
  ];
  home.packages = [
    inputs.anyrun.packages.${pkgs.system}.anyrun
  ];
  programs.anyrun = {
    enable = true;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = 10;

      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.kidex
        inputs.anyrun.packages.${pkgs.system}.rink
        inputs.anyrun.packages.${pkgs.system}.translate
        inputs.anyrun.packages.${pkgs.system}.symbols
        inputs.anyrun.packages.${pkgs.system}.websearch
      ];
    };

    extraConfigFiles = {
      "applications.ron".text =
        #ron
        ''
          Config(
            desktop_actions: false,
            max_entries: 10,
            terminal: Some("ghostty"),
          )
        '';
      "symbols.ron".text =
        #ron
        ''
          Config(
            prefix: ":s",
            symbols: {
            },
            max_entries: 10,
          )
        '';
      "translate.ron".text =
        #ron
        ''
          Config(
            prefix: ":t",
            language_delimiter: ">",
            max_entries: 3,
          )
        '';
    };

    extraCss =
      /*
      css
      */
      ''
        @define-color bg-color #1f1f28;
        @define-color fg-color #7E9CD8;
        @define-color primary-color #54546D;
        @define-color secondary-color #252535;
        @define-color text-color #DCD7BA;
        @define-color border-color @primary-color;
        @define-color selected-bg-color @primary-color;
        @define-color selected-fg-color @bg-color;

        * {
          all: unset;
          font-family: "JetBrainsMono Nerd Font";
        }

        #window {
        }

        box#main {
          border-radius: 16px;
          background-color: alpha(@bg-color, 0.8);
          /* border: 0.5px solid alpha(@fg-color, 0.25); */
        }

        entry#entry {
          font-size: 16px;
          color: @text-color;
          box-shadow: none;
          border: none;
          border-radius: 16px;
          padding: 16px 24px;
          min-height: 40px;
          caret-color: @primary-color;
        }

        list#main {
          background-color: transparent;
        }

        #plugin {
          background-color: transparent;
          padding-bottom: 4px;
        }

        #match {
          font-size: 15px;
          color: @text-color;
          padding: 2px 4px;
        }

        #match:selected,
        #match:hover {
          background-color: @selected-bg-color;
          color: @selected-fg-color;
        }

        #match:selected label#info,
        #match:hover label#info {
          color: @selected-fg-color;
        }

        #match:selected label#match-desc,
        #match:hover label#match-desc {
          color: alpha(@selected-fg-color, 0.9);
        }

        #match label#info {
          color: transparent;
          color: @fg-color;
        }

        label#match-desc {
          font-size: 12px;
          color: @text-color;
          color: @fg-color;
        }

        label#plugin {
          font-size: 16px;
          color: @text-color;
        }
      '';
  };
  nix.settings = {
    extra-substituters = [
      "https://anyrun.cachix.org"
    ];

    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
}
