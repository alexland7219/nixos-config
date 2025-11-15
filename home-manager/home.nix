{ config, pkgs, ... }:

{
  home.username = "link";
  home.homeDirectory = "/home/link";

  home.stateVersion = "24.05";

  home.sessionVariables.EDITOR = "vim";

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  programs.git = {
    enable = true;
    userName = "Alexandre Ros";
    userEmail = "alexland7219@gmail.com";
    extraConfig.core.editor = "vim";
  };

  programs.alacritty = {
    enable = true;
    theme = "tokyo_night";

    settings = {
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        opacity = 0.9;
      };

      font = {
        size = 10.0;
        normal.family = "JetBrains Mono";
      };

    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      "ls" = "ls -lAh --color=auto";
      "h++" = "g++ -std=c++23 -O3 -Wall -Wextra -Wpedantic -Werror -march=native";
    };
    initExtra = ''
      export PATH="$HOME/nixos-config/scripts:$PATH"
    '';
  };

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch Alacritty";
      command = "alacritty";
      binding = "<Super>Return";
    };

  };
}
