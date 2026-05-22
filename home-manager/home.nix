{
  config,
  pkgs,
  unstablePkgs,
  hostname,
  ...
}:

{
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
    qemu
    lua5_4_compat
    love
    zulu
    erlang
    qbittorrent
    dolphin-emu
    vlc
    keepassxc
    openssl
    texmaker
    bison
    yt-dlp
    spotdl
    android-tools
    mpv
    exercism
    gimp
    tauon
    telegram-desktop
    swi-prolog
    virt-viewer
    discord
    element-desktop
    anki-bin
    libreoffice-fresh
    wkhtmltopdf
    joplin-desktop
    weechat
    picard
    cbqn
    alttpr-opentracker
    qusb2snes
    unstablePkgs.uiua-unstable

    # KDE Packages
    kdePackages.okular
    kdePackages.poppler
    kdePackages.kleopatra
    kdePackages.kclock

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
        apscheduler
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
        totalcount
        cabin
        ;
    })
  ];

  programs.alacritty = {
    enable = true;
    theme = "iterm";

    settings = {
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        opacity = 0.9;
      };

      font = {
        # On machine Hyrule the font needs to be smaller
        size = if (hostname == "Hyrule") then 9.0 else 10.0;
        normal.family = "JetBrains Mono";
      };

    };
  };

  programs.jujutsu = {
    enable = true;
    package = unstablePkgs.jujutsu;
    settings = {
      user.email = "alexland7219@gmail.com";
      user.name = "Alexandre Ros";
      ui.paginate = "never";
      ui.default-command = "log";
      #colors = {
      #  author = "yellow";
      #  change_id = "#EC0868";
      #  "working_copy author" = "yellow";
      #  "working_copy change_id" = "#EC0868";
      #};
      template-aliases = {
        "format_short_signature(signature)" = "signature.email().local()";
      };
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      #custom.jj-revision = {
      #  description = "The current JJ status";
      #  when = "jj --ignore-working-copy root";
      #  command = ''
      #    jj log -r @ -n 1 --ignore-working-copy -G --color always -T '
      #      separate(" ",
      #        change_id.shortest(4),
      #        if(local_bookmarks, local_bookmarks)
      #      )
      #    '
      #  '';
      #};
    };
  };

  programs.zed-editor = {
    enable = true;
    package = unstablePkgs.zed-editor;

    userSettings = {
      disable_ai = true;
      session.trust_all_worktrees = true;
      vim_mode = true;
      cursor_blink = true;
      buffer_font_family = "JetBrains Mono";
      code_lens = "on";
      languages."Nix".tab_size = 2;
      buffer_font_size = 15;
      ui_font_size = 15;
      autosave.after_delay.milliseconds = 1000;
      base_keymap = "VSCode";
      telemetry = {
        metrics = false;
        diagnostics = true;
      };
      theme = {
        mode = "dark";
        dark = "Everforest Dark Hard (material)";
      };
    };

    extensions = [
      # Themes
      "andromeda"
      "everforest"
      "tokyo-night"

      # Grammars
      "bqn"
      "haskell"
      "lua"
      "make"
      "nix"
      "prolog"
      "uiua"
    ];
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
      "editor.fontFamily" = "'Maple Mono'";
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
        sumneko.lua
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "uiua-vscode";
          publisher = "uiua-lang";
          version = "0.0.69";
          sha256 = "Q/wJZ+ObCU+hRpZZKQGQtdt99/I6QHkSuHlNy7oe5Pk=";
        }
        {
          name = "bqn";
          publisher = "mk12";
          version = "0.2.1";
          sha256 = "nTnL75BzHrpnJVO8DFfrLZZGavCC4OzvAlyrGCXSak4=";
        }
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.5.9";
          sha256 = "jVuGQzMspbMojYq+af5fmuiaS3l3moG8L8Kyf40vots=";
        }
        {
          name = "andromeda";
          publisher = "EliverLara";
          version = "1.10.0";
          sha256 = "26K2NaYvBwQxRtk1f3ScfqwixUvtoNIBjObjoh8jmVs=";
        }
        {
          name = "better-prolog-syntax";
          publisher = "jeff-hykin";
          version = "0.3.2";
          sha256 = "sha256-P3zeOaZB4sy7hCVSu/WQwvuyj+qXwwfbcdNCRg1T0EM=";
        }
      ];
  };

  programs.thunderbird = {
    enable = true;
    profiles.alex.isDefault = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Alexandre Ros";
      user.email = "alexland7219@gmail.com";
      core.editor = "vim";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      "ls" = "ls -lAh --color=auto";
      "h++" = "g++ -std=c++26 -O3 -Wall -Wextra -Wpedantic -Werror -march=native";
    };
    initExtra = ''
      export PATH="$HOME/nixos-config/scripts:$PATH"
    '';
  };

  services.syncthing = {
    enable = true;
    settings.folders.Sync = {
      path = "/home/alex/Sync";
      label = "Main shared folder";
    };
  };

  # Enable if I were using GNOME
  #
  #dconf.settings = {
  #  "org/gnome/settings-daemon/plugins/media-keys" = {
  #    custom-keybindings = [
  #      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #    ];
  #  };

  #  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #    name = "Launch Alacritty";
  #    command = "alacritty";
  #    binding = "<Super>Return";
  #  };

  #};

  home.stateVersion = "24.05";
}
