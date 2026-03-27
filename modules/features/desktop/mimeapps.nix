{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktop = {...}: {
    xdg.mime = {
      defaultApplications = {
        "inode/directory" = ["pcmanfm.desktop"];
        "application/pdf" = ["org.pwmt.zathura.desktop"];

        "text/html" = ["helium.desktop"];
        "text/plain" = ["nvim.desktop"];
        "text/markdown" = ["nvim.desktop"];

        "video/*" = ["mpv.desktop"];
        "video/mp4" = ["mpv.desktop"];
        "video/x-matroska" = ["mpv.desktop"];
        "image/*" = ["swayimg"];

        "image/png" = ["swayimg"];
        "image/jpeg" = ["swayimg"];
        "image/gif" = ["swayimg"];
        "x-scheme-handler/terminal" = ["Alacritty.desktop"];
      };
    };
  };
}
