{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    extraPackages = with pkgs.unstable; [
      #lsps
      basedpyright
      clang-tools
      gopls
      lua-language-server
      nil
      rust-analyzer
      typescript-language-server
      zls
      marksman
      #formatters
      alejandra
      black
      gofumpt
      nodePackages.prettier
      python312Packages.sqlfmt
      rustfmt
      stylua
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
