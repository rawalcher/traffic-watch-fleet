{ config, pkgs, lib, ... }:

{
  networking.hostName = "traffic-nuc";

  swapDevices = [
    { device = "/swapfile"; size = 8192; }
  ];

  environment.systemPackages = with pkgs; [
    docker docker-compose
  ];

  virtualisation.docker.enable = true;
  users.users.nixos.extraGroups = [ "docker" ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}