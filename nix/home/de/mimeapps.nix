{...}: {
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["thunar.desktop"];
      "application/pdf" = ["firefox.destkop"];

      "text/html" = ["firefox.desktop"];
      "text/plain" = ["nvim.desktop"];
      "text/markdown" = ["nvim.desktop"];

      "video/*" = ["mpv.desktop"];
      "video/mp4" = ["mpv.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "image/*" = ["org.nomacs.ImageLounge.desktop"];

      "image/png" = ["org.nomacs.ImageLounge.desktop"];
      "image/jpeg" = ["org.nomacs.ImageLounge.desktop"];
      "image/gif" = ["org.nomacs.ImageLounge.desktop"];
    };
  };
}
