{
  config,
  pkgs,
  unstablePkgs,
  ...
}:

{
  home.username = "alex";
  home.homeDirectory = "/home/alex";

  home.stateVersion = "24.05";

  home.sessionVariables.EDITOR = "vim";

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Packages

  home.packages = with pkgs; [
    tree
    git
    mullvad-vpn
    libgcc
    calibre
    gcc15
    lua
    zulu24
    erlang
    qbittorrent
    dolphin-emu
    vscodium
    vlc
    keepassxc
    texmaker
    bison
    anki-bin
    yt-dlp
    spotdl
    android-tools
    mpv
    exercism
    tauon
    flutter
    telegram-desktop
    kdePackages.okular
    kdePackages.poppler
    swi-prolog
    virt-viewer
    discord
    element-desktop
    libreoffice-fresh
    wkhtmltopdf
    cbqn
    alttpr-opentracker
    unstablePkgs.qusb2snes
    unstablePkgs.uiua-unstable

    # Retroarch cores
    (retroarch.withCores (
      cores: with cores; [
        snes9x
      ]
    ))

    # Python 3.11 packages
    (python313.withPackages (
      ps: with ps; [
        pip
        numpy
        requests
        matplotlib
        requests-toolbelt
        pyyaml
        rich
        pydantic
        pandas
        python-telegram-bot
        discordpy
        geopandas
        python-dotenv
      ]
    ))

    # Haskell packages
    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.hlint

    # LaTeX packages
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        fira
        geometry
        xcolor
        enumitem
        xhfill
        soul
        titlesec
        lastpage
        fancyhdr
        fontawesome5
        fontaxes
        hyperref
        ;
    })
  ];

  programs.jujutsu.enable = true;

  programs.thunderbird = {
    enable = true;
    profiles.alex.isDefault = true;
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
        normal.family = "JetBrainsMono Nerd Font";
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

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
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
