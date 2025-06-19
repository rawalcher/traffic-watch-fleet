{ config, pkgs, lib, ... }:

{
  networking.hostName = "traffic-nuc";
  swapDevices = [
    { device = "/swapfile"; size = 8192; }
  ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}