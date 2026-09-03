{
  hostname,
  ...
}: {
  programs.alacritty = {
    enable = true;

    settings = {
      general.import = [ "~/.config/alacritty/themes/noctalia.toml" ];
      window = {
        blur = true;
       	decorations = "None"; 
        padding = {
          x = 8;
          y = 8;
        };
        opacity = 0.9;
      };

      font = {
        # On machine Hyrule the font needs to be smaller
        size = if (hostname == "Hyrule") then 10.5 else 11;
        normal.family = "JetBrainsMonoNerdFontPropo";
      };
    };
  };
}
