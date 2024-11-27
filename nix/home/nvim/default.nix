{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    extraPackages = with pkgs.unstable; [
      gopls
      gofumpt

      rust-analyzer
      rustfmt

      lua-language-server

      nil
      alejandra

      black
      basedpyright

      python312Packages.sqlfmt

      typescript-language-server
    ];
    defaultEditor = true;
  };

  xdg.configFile = {
    "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/init.lua";
    "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/lua";
    "nvim/ftplugin".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/ftplugin";
  };
}
