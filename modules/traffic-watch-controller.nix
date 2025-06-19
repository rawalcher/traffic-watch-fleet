{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    rustc cargo
    gcc glibc.dev pkg-config
    docker docker-compose
  ];

  virtualisation.docker.enable = true;
  users.users.nixos.extraGroups = [ "docker" ];

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 4096 16777216";
    "net.ipv4.tcp_wmem" = "4096 4096 16777216";
  };
}
