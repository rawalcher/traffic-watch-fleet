{
  description = "Traffic Watch NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, flake-utils, agenix, ... }:
    let
      commonModules = [
        agenix.nixosModules.default
        ./modules/common.nix
        ./modules/firewall.nix
      ];

      piModules = commonModules ++ [
        ./modules/traffic-watch-pi.nix
      ];

      controllerModules = commonModules ++ [
        ./modules/traffic-watch-controller.nix
      ];

      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnsupportedSystem = true;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nuc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = controllerModules ++ [
            ./hardware/nuc-hardware.nix
            ./hosts/nuc.nix
          ];
        };

        # Raspberry Pi 4 1GB variant
        pi4-1gb = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = piModules ++ [
            ./hardware/pi4-hardware.nix
            ./hosts/pi4-1gb.nix
          ];
        };

        # Raspberry Pi 4 2GB variant
        pi4-2gb = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = piModules ++ [
            ./hardware/pi4-hardware.nix
            ./hosts/pi4-2gb.nix
          ];
        };

        # Raspberry Pi 4 8GB variant
        pi4-8gb = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = piModules ++ [
            ./hardware/pi4-hardware.nix
            ./hosts/pi4-8gb.nix
          ];
        };
      };
    };
}