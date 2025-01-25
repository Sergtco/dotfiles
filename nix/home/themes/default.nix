{pkgs, ...}: {
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.vimix-icon-theme;
      name = "Vimix-Beryl";
    };
    theme = {
      package = pkgs.amarena-theme;
      name = "amarena";
    };
  };

  qt = {
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  home.pointerCursor = {
    package = pkgs.hackneyed;
    name = "Hackneyed";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
