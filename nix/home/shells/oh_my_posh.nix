{
  config,
  pkgs,
  input,
  ...
}:
{
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "pure";
  };
}