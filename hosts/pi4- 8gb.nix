{ config, pkgs, lib, ... }:

{
  networking.hostName = "traffic-pi4-8gb";

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    RuntimeMaxUse=50M
  '';
}