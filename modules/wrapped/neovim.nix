{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      package = inputs'.neovim-nightly.packages.default;
      settings.config_directory = ./../../config/nvim;
      extraPackages = with pkgs.unstable; [
        pyrefly
        ty
        emmylua-ls
        typescript-go
        typescript-language-server
        gopls
        clang-tools
        marksman
        zls
        inputs'.tree-sitter.packages.default
        nodejs-slim

        # language utils
        ruff
        alejandra
        gofumpt
        nodePackages.prettier
        clang-tools
        gdb
        delve
        typst
        tinymist
        typstyle
      ];
    };
  };
}
