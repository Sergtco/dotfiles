{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      theme = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/slugbyte/lackluster.nvim/refs/heads/main/extra/fish/lackluster.fish";
        sha256 = "1nfx989v2fg1bkb81y7p4a5hrxqm5gr78ik9glj3z8kh0zxzzvvi";
      };
    in
    {
      packages.fish = inputs.wrapper-modules.wrappers.fish.wrap {
        inherit pkgs;
        runtimePkgs = with pkgs; [
          direnv
          fzf
          zoxide
        ];

        plugins = with pkgs.fishPlugins; [
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

        flags."--no-config" = false;

        configFile.content = /* fish */ ''
          set -U fish_greeting
          fish_vi_key_bindings

          fish_add_path ~/.cargo/bin ~/go/bin ~/.npm-global/bin

          ${lib.getExe pkgs.direnv} hook fish | source
          ${lib.getExe pkgs.fzf} --fish | source
          ${lib.getExe pkgs.zoxide} init fish | source

          set --universal fish_transient_prompt 1

          set -g async_prompt_functions _pure_prompt_git

          set --universal pure_show_numbered_git_indicator true
          set --universal pure_enable_nixdevshell true
          set --universal pure_symbol_nixdevshell_prefix '󱄅'
          ${builtins.readFile theme}
        '';
      };
    };
}
