{ pkgs, ... }:

let 
  wallpapers = pkgs.symlinkJoin {
    name = "wallpapers";
    paths = [
      "${pkgs.pantheon.elementary-wallpapers}/share/backgrounds"
      "${pkgs.cosmic-wallpapers}/share/backgrounds/cosmic"
      "${pkgs.gnome-backgrounds}/share/backgrounds/gnome"
    ];
  };
in
{
  home.file."Pictures/Wallpapers" = {
    force     = true;
    recursive = true;
    source    = wallpapers;
  };
}