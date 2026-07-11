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
      meridian = inputs.meridian.packages.${pkgs.stdenv.hostPlatform.system}.meridian;
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

        opencode
        claude-code
        nodejs_26

        devenv
      ];
      documentation.dev.enable = true;

      programs.direnv.enable = true;
      programs.direnv.settings.global.hide_env_diff = true;

    };
}
