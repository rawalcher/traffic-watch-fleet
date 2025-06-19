{ config, pkgs, lib, ... }:

{
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

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
    };
  };

  age.secrets.deploy-key-nixos = {
    file = ../secrets/deploy-key-nixos.age;
    path = "/home/nixos/.ssh/deploy-key-nixos";
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

  programs.ssh.extraConfig = ''
    Host github-nixos
      HostName github.com
      User git
      IdentityFile /home/nixos/.ssh/deploy-key-nixos
      IdentitiesOnly yes

    Host github-traffic
      HostName github.com
      User git
      IdentityFile /home/nixos/.ssh/deploy-key-traffic
      IdentitiesOnly yes
  '';

  programs.ssh.knownHosts."github.com" = {
    hostNames = [ "github.com" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
  };

  users.users.nixos = {
    isNormalUser = true;
    password = "nixos";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  users.mutableUsers = false;

  services.getty.autologinUser = "nixos";

  environment.systemPackages = with pkgs; [
    neofetch git nano wget curl age htop tree tmux
  ];

  system.stateVersion = "23.11";
}