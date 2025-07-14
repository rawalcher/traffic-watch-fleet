{ config, lib, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22    # SSH
      9090  # Controller control port
      9091  # Controller data port
      9092  # Jetson receiver port
    ];
    #trustedInterfaces = [ "lo" ];
    logRefusedConnections = false;
  };
}
