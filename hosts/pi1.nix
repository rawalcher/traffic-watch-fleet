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

