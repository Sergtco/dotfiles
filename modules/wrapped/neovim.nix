{
  self,
  inputs,
  ...
}:
{
  flake.nvimWrapper =
    {
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.neovim ];
      config.extraPackages = with pkgs.unstable; [
        pyrefly
        ty
        emmylua-ls
        typescript-go
        typescript-language-server
        gopls
        clang-tools
        marksman
        zls
        inputs.tree-sitter.packages.${pkgs.stdenv.hostPlatform.system}.default
        nodejs-slim

        # language utils
        ruff
        nixfmt
        gofumpt
        prettier
        clang-tools
        gdb
        delve
        typst
        tinymist
        typstyle

        fzf
      ];
    };
  perSystem =
    {
      pkgs,
      inputs',
      self',
      lib,
      ...
    }:
    {
      packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;
        package = pkgs.unstable.neovim-unwrapped;
        settings.config_directory = ./../../config/nvim;
        imports = [ self.nvimWrapper ];
      };

      packages.neovimDev = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;
        package = pkgs.unstable.neovim-unwrapped;
        binName = "neodev";
        settings.config_directory = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/dotfiles/config/nvim'";
        imports = [ self.nvimWrapper ];
      };
    };
}
