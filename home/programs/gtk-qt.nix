{
  pkgs,
  ...
}: {
  # GTK theming
  gtk = {
    enable = true;
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # QT theming
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  home.packages = [ pkgs.papirus-icon-theme ];
}