{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      thinkpad-home = lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/thinkpad-home/hardware-configuration.nix
          ./hosts/thinkpad-home/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      bd = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;

        username = "bd";
        homeDirectory = "/home/bd";
        configuration = {
          imports = [
            ./users/bd/home.nix
          ];
        };
      };
    };
  };
}
