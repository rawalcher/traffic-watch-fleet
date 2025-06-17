{ config, pkgs, lib, ... }:

{
  # Nix configuration
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  networking.useDHCP = false;
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

  # Deploy keys for git operations
  age.secrets.deploy-key = {
    file = ../secrets/deploy-key.age;
    path = "/home/nixos/.ssh/deploy-key";
    owner = "nixos";
    group = "users";
    mode = "0600";
  };

  age.secrets.deploy-key-traffic = {
    file = ../secrets/deploy-key-traffic.age;
    path = "/home/nixos/.ssh/deploy-key-traffic";
    owner = "nixos";
    group = "users";
    mode = "0600";
  };

  # SSH configuration for git
  programs.ssh.extraConfig = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile /home/nixos/.ssh/deploy-key
      IdentitiesOnly yes
  '';

  programs.ssh.knownHosts."github.com" = {
    hostNames = [ "github.com" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };

  # User configuration
  users.users.nixos = {
    isNormalUser = true;
    password = "nixos";
    extraGroups = [ "wheel" "networkmanager"];
  };
  users.mutableUsers = false;

  # Auto-login
  services.getty.autologinUser = "nixos";

  environment.systemPackages = with pkgs; [
    neofetch git nano wget curl age htop tree tmux
  ];

  system.stateVersion = "23.11";
}