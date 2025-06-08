{
  description = "Flake-based NixOS config for Raspberry Pi 4B";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: {
    nixosConfigurations = {
	pi1 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hardware/pi1-hardware.nix
            ./hosts/pi1.nix
          ];
        };
      };
  };
}
