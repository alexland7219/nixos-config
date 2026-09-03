{
  pkgs,
  ...
}:

let
  hyperfluent-grub-theme = pkgs.stdenvNoCC.mkDerivation {
    pname   = "hyperfluent-grub-theme";
    version = "1.0.1";

    src = pkgs.fetchFromGitHub {
      owner  = "Coopydood";
      repo   = "HyperFluent-GRUB-Theme";
      rev    = "v1.0.1";
      sha256 = "sha256-zryQsvue+YKGV681Uy6GqnDMxGUAEfmSJEKCoIuu2z8=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r nixos/* $out/
    '';
  };
in
{
  boot.loader.grub.theme = hyperfluent-grub-theme;
}