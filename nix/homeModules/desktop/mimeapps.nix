{...}: {
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["pcmanfm.desktop"];
      "application/pdf" = ["brave.destkop"];

      "text/html" = ["brave.desktop"];
      "text/plain" = ["nvim.desktop"];
      "text/markdown" = ["nvim.desktop"];

      "video/*" = ["mpv.desktop"];
      "video/mp4" = ["mpv.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "image/*" = ["swayimg"];

      "image/png" = ["swayimg"];
      "image/jpeg" = ["swayimg"];
      "image/gif" = ["swayimg"];
    };
  };
}
