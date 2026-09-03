{
  pkgs,
  ...
}: {
  
  fonts.fontconfig.enable = true;
  
  # Fonts 
  home.packages = with pkgs;
    [
      bqn386
      geist-font
      ioskeley-mono.normal-NF
      maple-mono.variable
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-lgc-plus
      nunito
      uiua386
    ];

  # Pointer Cursor
  home.pointerCursor = {
    package    = pkgs.bibata-cursors;
    name       = "Bibata Modern Ice";
    gtk.enable = true;
  };
}
