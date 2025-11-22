{
  config,
  pkgs,
  unstablePkgs,
  ...
}:

{
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

  programs.jujutsu = {
    enable = true;
    package = unstablePkgs.jujutsu;
    settings = {
      user.email = "alexland7219@gmail.com";
      user.name = "Alexandre Ros";
      ui.paginate = "never";
      colors = {
        author = "yellow";
        change_id = "#EC0868";
        "working_copy author" = "yellow";
        "working_copy change_id" = "#EC0868";
      };
      template-aliases = {
        "format_short_signature(signature)" = "signature.email().local()";
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.userSettings = {
      "files.autoSave" = "afterDelay";
      "[nix]"."editor.tabSize" = 2;
      "workbench.iconTheme" = "vscode-icons";
      "workbench.colorTheme" = "GitHub Dark";
      "editor.cursorBlinking" = "smooth";
      "editor.fontFamily" = "'JetBrains Mono'";
      "editor.formatOnPaste" = true;
      "terminal.integrated.stickyScroll.enabled" = false;
    };

    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        vscodevim.vim
        vscode-icons-team.vscode-icons
        github.github-vscode-theme
        enkia.tokyo-night
        teabyii.ayu
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "uiua-vscode";
          publisher = "uiua-lang";
          version = "0.0.67";
          sha256 = "Q/wJZ+ObCU+hRpZZKQGQtdt99/I6QHkSuHlNy7oe5Pk=";
        }
        {
          name = "bqn";
          publisher = "mk12";
          version = "0.2.0";
          sha256 = "nTnL75BzHrpnJVO8DFfrLZZGavCC4OzvAlyrGCXSak4=";
        }
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.5.0";
          sha256 = "jVuGQzMspbMojYq+af5fmuiaS3l3moG8L8Kyf40vots=";
        }
      ];
  };

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
