{pkgs, ...}: let
in {
  programs.chromium = {
    enable = true;
    package = pkgs.nur.repos.forkprince.helium-nightly;
    commandLineArgs = ["--disable-gpu-vsync" "--disable-frame-rate-limit" "--max-gum-fps=\"9999\""];
  };
}
