{ config, pkgs, lib, ... }:

{
  networking.hostName = "traffic-pi4-1gb";
  swapDevices = [
    { device = "/swapfile"; size = 7168; }
  ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    RuntimeMaxUse=50M
  '';
}