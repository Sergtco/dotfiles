{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.nvim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      package = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings.config_directory = ../../../config/nvim;
    };
  };
}
