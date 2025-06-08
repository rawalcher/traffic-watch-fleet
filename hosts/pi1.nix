{ config, pkgs, lib, ... }:

{
  networking.hostName = "pi1";

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  networking.useDHCP = true;

  # WiFi configuration using encrypted password
  age.secrets.wifi-password = {
    file = ../secrets/wifi-password.age;
    owner = "root";
    group = "root";
    mode = "0400";
  };

  networking.wireless = {
    enable = true;
    networks = {
      "Das Internetz" = {
        pskRaw = builtins.readFile config.age.secrets.wifi-password.path;
      };
    };
  };

  # Deploy key for git operations
  age.secrets.deploy-key = {
    file = ../secrets/deploy-key.age;
    path = "/home/nixos/.ssh/deploy-key";
    owner = "nixos";
    group = "users";
    mode = "0600";
  };

  # SSH config for git operations
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

  users.users.nixos = {
    isNormalUser = true;
    password = "nixos";
    extraGroups = [ "wheel" ];
  };
  users.mutableUsers = false;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git vim wget curl age
  ];

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "23.11";
}