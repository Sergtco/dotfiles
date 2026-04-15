{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.fish = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = pkgs.wrapFish {
            runtimeInputs = with pkgs; [
              direnv
              fzf
              zoxide
            ];

            pluginPkgs = with pkgs.fishPlugins; [
              pure
              async-prompt
            ];

            shellAliases = {
              v = "nvim";
              y = "yazi";
              d = "docker";
              dc = "docker compose";
              g = "git";
            };

            localConfig = /* fish */ ''
              fish_vi_key_bindings

              fish_add_path ~/.cargo/bin ~/go/bin

              ${lib.getExe pkgs.direnv} hook fish | source
              ${lib.getExe pkgs.fzf} --fish | source
              ${lib.getExe pkgs.zoxide} init fish | source

              set --universal fish_transient_prompt 1

              set -g async_prompt_functions _pure_prompt_git

              set --universal pure_show_numbered_git_indicator true
              set --universal pure_enable_nixdevshell true
              set --universal pure_symbol_nixdevshell_prefix '󱄅'
            '';
          };

          wrapperImplementation = "binary";
        }
      );
    };
}
