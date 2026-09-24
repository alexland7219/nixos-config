{ pkgs, config, ...}: 

let
  qtctSettings = {
    Appearance = {
      style             = "Fusion";
      custom_palette    = true;
      color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf";
      icon_theme        = "Papirus-Dark";
      standard_dialogs  = "default";
    };
    Fonts = {
      general = ''"Noto Sans,10"'';
      fixed   = ''"JetBrainsMono Nerd Font,10"'';
    };
  };
in

{
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
    qt6ctSettings = qtctSettings;
    qt5ctSettings = qtctSettings;
  };

  home.packages = [ pkgs.papirus-icon-theme ];
}