{...}: {
  programs.retroarch = {
    enable = true;

    cores.mgba.enable   = true;
    cores.snes9x.enable = true;

    # TODO: Settings to connect with qusb2snes
  };
}