{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
  };
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs.unstable; [
      basedpyright
      black

      lua-language-server
      stylua

      nil
      alejandra

      gofumpt
      gopls
      golangci-lint

      nodePackages.prettier
      clang-tools

      python312Packages.sqlfmt

      marksman

      zls

      gdb
      delve
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
