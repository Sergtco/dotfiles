{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      plugins = with pkgs.fishPlugins; [
        pure
      ];

      vendorDir = kind: plugin: "${plugin}/share/fish/vendor_${kind}.d";
      complPath = map (vendorDir "completions") plugins;
      funcPath = map (vendorDir "functions") plugins;
      confPath = map (vendorDir "conf") plugins;

      settings = pkgs.writeText "fish.conf" /* fish */ ''
        set --prepend fish_complete_path ${lib.escapeShellArgs complPath}
        set --prepend fish_function_path ${lib.escapeShellArgs funcPath}
        set --local fish_conf_source_path ${lib.escapeShellArgs confPath}
        for c in \$fish_conf_source_path/*; source \$c; end

        alias v="nvim"
        alias y="yazi"
        alias d="docker"
        alias dc="docker compose"
        alias g="git"

        fish_vi_key_bindings

        fish_add_path ~/.cargo/bin ~/go/bin

        ${lib.getExe pkgs.direnv} hook fish | source
        ${lib.getExe pkgs.fzf} --fish | source
        ${lib.getExe pkgs.zoxide} init fish | source
      '';
      extraPackages = with pkgs; [

        direnv
        fzf
        zoxide
      ];
    in
    {
      packages.fish = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = pkgs.fish;
          extraPackages = extraPackages;
          wrapperImplementation = "binary";
          flags = {
            "-C" = "source ${settings}";
          };
        }
      );
    };
}
