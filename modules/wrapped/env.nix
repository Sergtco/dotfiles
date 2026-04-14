{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.env = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;

          package = self'.packages.fish;

          extraPackages = with pkgs; [
            sesh
            fzf
            direnv
            zoxide

            ripgrep
            fd
            bat
            file
            usbutils
            ffmpeg
            bottom
            imagemagick
            progress

            jq

            bash
            curl
            p7zip
            zip
            unzip
            rar
            killall
            wget

            yazi

            self'.packages.tmux
            self'.packages.neovim
            self'.packages.neovimDev
            self'.packages.git
          ];

          env = {
            EDITOR = "${lib.getExe self'.packages.neovim}";
            MANPAGER = "${lib.getExe self'.packages.neovim} +Man!";
          };
        }
      );
    };
}
