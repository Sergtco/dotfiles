{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${pkgs.system}.default;
    extraPackages = with pkgs.unstable; [
      pyrefly
      ty
      emmylua-ls
      typescript-go
      gopls
      clang-tools
      marksman
      zls
      inputs.tree-sitter.packages.${pkgs.system}.default
      nodejs-slim
    ];
    defaultEditor = true;
  };

  xdg.configFile = {
    "nvim" = {
      source =
	      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
	      recursive =true;
      };
  };

  home.file.".clang-format" = {
    text = ''
      IndentWidth: 4
      AccessModifierOffset: -4
    '';
  };
}
