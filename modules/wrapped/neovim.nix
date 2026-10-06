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
      config.runtimePkgs = with pkgs.unstable; [
        pyrefly
        ty
        emmylua-ls
        typescript
        typescript-language-server
        gopls
        clang-tools
        marksman
        zls
        tree-sitter
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
        stylua

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
