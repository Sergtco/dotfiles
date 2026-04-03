{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.programming =
    { pkgs, config, ... }:
    let
      user = config.preferences.user.name;
    in
    {
      users.users.${user}.extraGroups = [
        "docker"
        "dialout"
      ];

      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
        autoPrune.enable = true;
      };

      environment.systemPackages = with pkgs.unstable; [
        #compilers
        gcc
        clang
        python3
        uv
        go
        rustup
        zig

        #utils
        jq
        gnumake
        perf
        nixos-firewall-tool
        postgresql

        #manuals
        man-pages
        man-pages-posix
        tlrc

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
      ];
      documentation.dev.enable = true;

      hjem.users.${user}.xdg.config.files."direnv/direnv.toml".text = ''
        [global]
        hide_env_diff=true
      '';
      environment.etc = {
        "direnv/direnvrc".text = ''
          source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
        '';
      };
    };
}
