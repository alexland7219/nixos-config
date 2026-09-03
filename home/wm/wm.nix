{
  unstablePkgs,
  pkgs,
  ...
}: {
  home.packages = [ unstablePkgs.noctalia ];

  xdg.configFile = {
    "niri/config.kdl".source = ./niri-config.kdl;
    "noctalia/config.toml".source = ./noctalia-settings.toml;
  };

  # Some backgrounds
  home.file."Pictures/disco.png".source = pkgs.fetchurl {
    url = "https://i.redd.it/43a0onoy326h1.png";
    hash = "sha256-fs03mu9Csmn8eMaVc8uQGcQqh/1scqaRqeQ6tjP/MeU=";
  };
}
