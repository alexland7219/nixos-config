{...}: {
  imports = [
    ./programs/zed.nix
    ./programs/vcs.nix
    ./programs/alacritty.nix
    ./programs/gtk-qt.nix
    ./programs/starship.nix
    ./programs/shell.nix
    ./programs/gnupg.nix
    ./programs/mozilla.nix
    ./programs/retroarch.nix
    ./wm/wm.nix
    ./packages.nix
    ./fonts.nix
  ];
  
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  # udiskie mount daemon
  services.udiskie.enable = true;

  # EDITOR environment variable
  home.sessionVariables.EDITOR = "vim";

  home.stateVersion = "24.05";
}
