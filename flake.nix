{
  description = "My personal Nix configuration ❄️";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # BQNLSP
    bqnlsp.url = "sourcehut:~detegr/bqnlsp";
    bqnlsp.inputs.nixpkgs.follows = "nixpkgsUnstable";
    bqnlsp.inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgsUnstable";
    bqnlsp.inputs.naersk.inputs.nixpkgs.follows = "nixpkgsUnstable";

    # Uiua
    uiua.url = "github:uiua-lang/uiua";
    uiua.inputs.nixpkgs.follows = "nixpkgsUnstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      unstablePkgs = inputs.nixpkgsUnstable.legacyPackages.${system};
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        Termina = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs unstablePkgs;
            hostname = "Termina";
          };
          modules = [ ./nixos/configuration.nix ];
        };

        Hyrule = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs unstablePkgs;
            hostname = "Hyrule";
          };
          modules = [ ./nixos/configuration.nix ];
        };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };

}
