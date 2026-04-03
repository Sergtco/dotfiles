{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktop = {config, ...}: let 
    user = config.preferences.user.name;
  in{
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
    hjem.users.${user}.xdg.config.files."xdg-terminals.list".text = "Alacritty.desktop";
  };
}
