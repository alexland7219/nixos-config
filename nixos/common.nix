{
  pkgs,
  config,
  hostname,
  ...
}: {
  # Import submodules
  imports = [
    ./programs.nix
    ./grub-theme.nix
  ];

  # Lix
  nix.package = pkgs.lixPackageSets.stable.lix;

  # Enable experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Silence the "Git tree is dirty" warning on flake rebuilds
  nix.settings.warn-dirty = false;

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # Use GRUB bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable      = true;
    efiSupport  = true;
    device      = "nodev";
    gfxmodeBios = "1920x1080";
    gfxmodeEfi  = "1920x1080";
  };

  # Display Manager and Niri 
  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --remember \
          --remember-user-session \
          --cmd ${config.programs.niri.package}/bin/niri-session";
      };
    };
  };
  
  # Networking and Bluetooth
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Locale
  # en_GB gives proper English and metric defaults :)
  i18n.defaultLocale = "en_GB.UTF-8";

  # Layout
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Time
  time.timeZone = "Europe/Brussels";

  # Sound server
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # Nix Store optimiser
  nix.optimise = {
    automatic = true;
    dates = "weekly";
  };

  # Printing and scanning
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [pkgs.hplipWithPlugin];
  services.ipp-usb.enable = true;
  services.printing.enable = true;

  # User 'alex'
  users.users.alex = {
    isNormalUser = true;
    description = "Alexandre Ros";
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "libvirtd"
      "lp"
      "networkmanager"
      "scanner"
      "video"
      "wheel"
    ];
  };

  # Power profiles and management
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  
  # doas security
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = ["wheel"];
        persist = true;
      }
    ];
  };

  # gnome-keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Disable root login
  users.users.root.hashedPassword = "!";

  system.stateVersion = "25.11";
}
