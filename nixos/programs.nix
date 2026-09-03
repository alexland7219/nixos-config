{pkgs, ...}: {
  # System-wide packages
  environment.systemPackages = with pkgs; [
    curl
    dosfstools
    efibootmgr
    file
    git
    gnumake
    htop
    killall
    lm_sensors
    man-pages
    nautilus
    pciutils
    smartmontools
    sushi
    usbutils
    vim
    wget
  ];

  # Nautilus features
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  
  # Steam, Wireshark and default system-wide fonts
  programs.steam.enable = true;
  programs.wireshark.enable = true;
  fonts.enableDefaultPackages = true;

  # VPN
  services.mullvad-vpn = {
    enable = true;
    enableEarlyBootBlocking = true;
  };

  # AppImage support
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.zsh.enable = true;

  # Run unpatched dynamic binaries
  programs.nix-ld.enable = true;
}
