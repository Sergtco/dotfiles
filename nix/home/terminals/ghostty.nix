{
  inputs,
  pkgs,
  config,
  ...
}: {
  home = {
    sessionVariables = {
      TERMINAL = "ghostty";
    };
  };
  home.packages = [
    inputs.ghostty.packages.${pkgs.system}.ghostty
  ];

  home.file.".config/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/ghostty/config";
  nix.settings = {
    extra-substituters = [
      "https://ghostty.cachix.org"
    ];

    extra-trusted-public-keys = [
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    ];
  };
}
