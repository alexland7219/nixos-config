{
  pkgs,
  ...
}: {  
  programs.gpg = {
    enable = true;
    settings = {
      no-comments      = true;
      no-emit-version  = true;
      keid-format      = "0xlong";
      with-fingerprint = true;
      keyserver        = "hkps://keys.openpgp.org";
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    maxCacheTtl     = 7200;
    pinentry.package = pkgs.pinentry-curses;
  };
}