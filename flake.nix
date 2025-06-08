{
  description = "Flake-based NixOS config for Traffic Watch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, flake-utils, agenix, ... }: {
    nixosConfigurations = {
      pi1 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          agenix.nixosModules.default
          ./hardware/pi1-hardware.nix
          ./hosts/pi1.nix
        ];
      };
    };
  };
}