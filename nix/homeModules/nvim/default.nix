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
      tree-sitter
      pyrefly
      lua-language-server
      typescript-language-server
      gopls
      clang-tools
      marksman
      zls
    ];
    defaultEditor = true;
  };

  xdg.configFile = {
    "nvim/init.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/init.lua";
    "nvim/lazy-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/lazy-lock.json";
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
