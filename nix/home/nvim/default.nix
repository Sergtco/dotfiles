{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs.unstable; [
      # lsps
      basedpyright
      clang-tools
      gopls
      lua-language-server
      nil
      zls
      marksman
      # formatters
      alejandra
      black
      gofumpt
      nodePackages.prettier
      nixfmt-rfc-style
      python312Packages.sqlfmt
      stylua
      # linters
      golangci-lint
    ];
    defaultEditor = true;
  };

  xdg.configFile = {
    "nvim/init.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/init.lua";
    "nvim/lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/lua";
    "nvim/ftplugin".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/ftplugin";
  };

  home.file.".clang-format" = {
    text = ''
      IndentWidth: 4
      AccessModifierOffset: -4
    '';
  };
}
