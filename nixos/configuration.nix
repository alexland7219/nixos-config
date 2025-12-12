# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  unstablePkgs,
  hostname,
  ...
}:

{
  imports = [
    (./. + "/hardware-${hostname}.nix")
    # Importing home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.overlays = [
    (import ../overlays/libpkcs11-dnie.nix)
  ];

  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit unstablePkgs; };
    users = {
      # Importing home-manager configuration
      alex = import ../home-manager/home.nix;
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

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome = {
    enable = true;

    # On machine Hyrule the interface needs to be scaled by 0.9
    extraGSettingsOverrides = lib.optionalString (hostname == "Hyrule") ''
      [org/gnome/desktop/interface]
      text-scaling-factor=0.9
    '';
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
    LC_TIME = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_ALL = "en_US.UFT-8";
    EDITOR = "vim";
  };

  # Users and fonts

  users.users.alex = {
    isNormalUser = true;
    description = "Alexandre Ros";
    extraGroups = [
      "wheel"
      "networkmanager"
      "plugdev"
      "dialout"
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

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    alacritty
    htop
    file
    killall
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    wireguard-tools
    man-pages
    hplip
    ares-cli
    libpkcs11-dnie
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
    maple-mono.variable
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Services

  # services.openssh.enable = true;
  services.mullvad-vpn.enable = true;
  services.pcscd.enable = true;

  system.stateVersion = "25.05";
}
