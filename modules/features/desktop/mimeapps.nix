{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktop = {config, ...}: let 
    user = config.preferences.user.name;
    defaultApps = {
        "inode/directory" = ["pcmanfm.desktop"];
        "application/pdf" = ["org.pwmt.zathura.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["writer.desktop"];

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
  in{
    xdg.mime = {
      defaultApplications = defaultApps;
    };
    hjem.users.${user}.xdg = {
      config.files."xdg-terminals.list".text = "Alacritty.desktop";
      mime-apps.default-applications = defaultApps;
    };
  };
}
