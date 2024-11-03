{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    extraPackages = with pkgs; [
      gopls
      rust-analyzer
      rustup
      rustc
      rustfmt
      lua-language-server
    ];
  };

  xdg.configFile = {
    "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/init.lua";
    "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/lua";
    "nvim/ftplugin".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/ftplugin";
  };

}
