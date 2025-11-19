# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    # Importing home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.overlays = [
    (import ../overlays/libpkcs11-dnie.nix)
  ];

  home-manager = {
    users = {
      # Importing home-manager configuration
      link = import ../home-manager/home.nix;
    };
  };

  # Enable experimental features and Unfree Packages
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Termina";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
    options = "lv5:rwin_switch_lock";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Locale and formatting

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };

  environment.variables = {
    LANG = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_TIME = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_ALL = "";
  };

  # Programs and fonts

  users.users.link = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "plugdev"
      "dialout"
    ];
    packages = with pkgs; [
      tree
      git
      mullvad-vpn
      qbittorrent
      dolphin-emu
      vscodium
      magic-wormhole
      vlc
      keepassxc
      texmaker
      cbc
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
      simulide
      wkhtmltopdf
      cbqn
      alttpr-opentracker
      unstablePkgs.qusb2snes
      unstablePkgs.uiua-unstable
    ];
  };

  programs.firefox = {
    enable = true;
    policies = {
      SecurityDevices = {
        Add = {
          "PKCS#11 DNIe" = "${pkgs.libpkcs11-dnie}/lib/libpkcs11-dnie.so";
        };
      };
    };
  };

  programs.thunderbird.enable = true;

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    htop
    libgcc
    file
    calibre
    gcc15
    lua
    zulu23
    erlang
    killall
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    hplip
    ares-cli
    syncthing
    libxkbcommon
    libpkcs11-dnie

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

  fonts.packages = with pkgs; [
    jetbrains-mono
    ubuntu-sans-mono
    uiua386
    bqn386
    noto-fonts-cjk-sans
    noto-fonts
    noto-fonts-lgc-plus
    nerd-fonts.jetbrains-mono
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Services

  # services.openssh.enable = true;
  services.mullvad-vpn.enable = true;
  services.pcscd.enable = true;

  services.syncthing = {
    enable = true;
    user = "link";
    dataDir = "/home/link";
    configDir = "/home/link/.config/syncthing";
  };

  system.stateVersion = "25.05";
}
