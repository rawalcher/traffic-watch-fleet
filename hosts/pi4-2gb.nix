{ config, pkgs, lib, ... }:

{
  networking.hostName = "traffic-pi4-2gb";
  swapDevices = [
    { device = "/swapfile"; size = 6144; }
  ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    RuntimeMaxUse=50M
  '';
}
