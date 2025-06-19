{ config, lib, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22    # SSH
      8080  # Pi sender port
      9090  # Controller port
      9092  # Jetson receiver port (if jetson would be on NixOS
    ];
    #trustedInterfaces = [ "lo" ];
    logRefusedConnections = false;
  };
}