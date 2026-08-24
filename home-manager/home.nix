{
  config,
  pkgs,
  hostname,
  unstablePkgs,
  ...
}@args:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  fonts.fontconfig.enable = true;

  # Packages
  home.packages =
    let
      bqnlsp = args.bqnlsp.packages.${pkgs.stdenv.hostPlatform.system};
    in
    with pkgs;
    [
      alttpr-opentracker
      android-tools
      bison
      bqnlsp.lsp
      calibre
      cargo
      cbqn
      clippy
      discord
      dolphin-emu
      element-desktop
      erlang
      exercism
      gcc16
      gimp
      git
      joplin-desktop
      keepassxc
      libgcc
      libreoffice-fresh
      love
      lua5_5_compat
      mpv
      mullvad-vpn
      newsboat
      openssl
      picard
      qbittorrent
      qemu
      qusb2snes
      rustc
      spotdl
      swi-prolog
      tauon
      telegram-desktop
      texmaker
      tree
      unstablePkgs.anki-bin
      unstablePkgs.tutanota-desktop
      unstablePkgs.uiua-unstable
      unzip
      virt-viewer
      vlc
      weechat
      wkhtmltopdf
      xournalpp
      yt-dlp
      zulu

      # KDE Packages
      kdePackages.kclock
      kdePackages.kio-gdrive
      kdePackages.kleopatra
      kdePackages.okular
      kdePackages.poppler
      kdePackages.skanpage

      # Retroarch cores
      (retroarch.withCores (
        cores: with cores; [
          snes9x
        ]
      ))

      # Python 3.11 packages
      (python313.withPackages (
        ps: with ps; [
          apscheduler
          discordpy
          geopandas
          matplotlib
          numpy
          pandas
          pip
          pydantic
          python-dotenv
          python-telegram-bot
          pyyaml
          requests
          requests-toolbelt
          rich
        ]
      ))

      # Haskell packages
      haskellPackages.cabal-install
      haskellPackages.ghc
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
    theme = "flat_remix";

    settings = {
      window = {
        blur = true;
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
    package = args.unstablePkgs.jujutsu;
    settings = {
      user.email = "alexandre-ros@tuta.io";
      user.name = "Alexandre Ros";
      ui.paginate = "never";
      ui.default-command = "log";
      #colors = {
      #  author = "yellow";
      #  change_id = "#EC0868";
      #  "working_copy author" = "yellow";
      #  "working_copy change_id" = "#EC0868";
      #};
      colors.conflict_prompt = {
        fg = "red";
        bold = true;
      };
      template-aliases = {
        "format_short_signature(signature)" = "signature.email().local()";
      };
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      # Disable the built-in git modules entirely (this is a jj workflow).
      git_branch.disabled = true;
      git_commit.disabled = true;
      git_state.disabled = true;
      git_status.disabled = true;
      git_metrics.disabled = true;

      custom.jj = {
        description = "Jujutsu change id and bookmark";
        when = "jj --ignore-working-copy root";
        shell = [
          "bash"
          "--noprofile"
          "--norc"
        ];
        command = ''
          change=$(jj log --no-graph --ignore-working-copy --color always -r @ -T 'change_id.shortest(8)' 2>/dev/null)
          bookmark=$(jj log --no-graph --ignore-working-copy --color always -r 'latest(heads(::@ & bookmarks()))' -T 'local_bookmarks.join(" ")' 2>/dev/null)
          conflict=$(jj log --no-graph --ignore-working-copy --color always -r @ -T 'if(conflict, label("conflict_prompt", "[CONFLICT]"))' 2>/dev/null)
          if [ -n "$bookmark" ]; then
            printf '%s 🔖 %s' "$change" "$bookmark"
          else
            printf '%s' "$change"
          fi
          if [ -n "$conflict" ]; then
            printf ' %s' "$conflict"
          fi
        '';
        format = "[🌺 ](bold cyan)$output ";
      };
    };
  };

  programs.zed-editor = {
    enable = true;
    package = args.unstablePkgs.zed-editor;
    extraPackages =
      with pkgs;
      [
        nixd
        nil
        rust-analyzer
        lua-language-server
      ]
      ++ [ args.bqnlsp.packages.${pkgs.stdenv.hostPlatform.system}.lsp ];

    userSettings =
      let
        fontsize =
          if (hostname == "Hyrule") then
            {
              txt = 13;
              ui = 16;
            }
          else
            {
              txt = 14;
              ui = 17;
            };
      in
      {
        session.trust_all_worktrees = true;
        vim_mode = true;
        cursor_blink = true;
        buffer_font_family = "JetBrains Mono";
        code_lens = "on";
        buffer_font_size = fontsize.txt;
        ui_font_size = fontsize.ui;
        terminal.font_size = fontsize.txt;
        autosave.after_delay.milliseconds = 1000;
        base_keymap = "VSCode";
        languages = {
          "Nix".tab_size = 2;
          "Prolog".tab_size = 2;
        };
        project_panel = {
          dock = "left";
          default_width = 300;
        };
        telemetry = {
          metrics = false;
          diagnostics = true;
        };
        theme = {
          mode = "system";
          dark = "Tokyo Night";
          light = "Catppuccin Latte";
        };
        icon_theme = {
          mode = "system";
          dark = "Colored Zed Icons Theme Dark";
          light = "Colored Zed Icons Theme Light";
        };
        profiles.Uiua.settings = {
          buffer_font_family = "Uiua386";
          buffer_font_size = 18;
          autosave = "off";
        };
        agent = {
          dock = "right";
          sidebar_side = "right";
          agent_ui_font_size = fontsize.ui;
        };
        agent_servers = {
          "mistral-vibe".type = "registry";
          "claude-acp".type = "registry";
          "kimi".type = "registry";
        };
      };

    extensions = [
      # Themes
      "andromeda"
      "everforest"
      "tokyo-night"
      "github-theme"
      "colored-zed-icons-theme"
      "catppuccin"
      "nvim-nightfox"

      # Grammars
      "bqn"
      "git-firefly"
      "haskell"
      "lua"
      "make"
      "nix"
      "prolog"
      "toml"
      "uiua"
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
      user.email = "alexandre-ros@tuta.io";
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

  home.stateVersion = "24.05";
}
