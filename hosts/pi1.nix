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
      psk = builtins.replaceStrings ["\n"] [""] (builtins.readFile config.age.secrets.wifi-password.path);
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

  # Deploy key for rust traffic watch repo
  age.secrets.deploy-key-traffic = {
    file = ../secrets/deploy-key-traffic.age;
    path = "/home/nixos/.ssh/deploy-key-traffic";
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

  services.getty.autologinUser = "nixos";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git vim wget curl age rustc cargo

    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.wheel

    gcc
    glibc.dev
    pkg-config

    zlib.dev
    libffi.dev
    openssl.dev

    cmake

    python3Packages.numpy
    python3Packages.pillow
  ];

  hardware.raspberry-pi."4".fkms-3d.enable = true;
  boot.kernelParams = [
    "gpu_mem=256"
  ];

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

  # setup script for the venv
  environment.etc."setup-traffic-venv.sh" = {
    text = ''
      #!/bin/bash
      cd /home/nixos/rust-traffic-watch

      if [ ! -d ".venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv .venv
        source .venv/bin/activate

        pip install --upgrade pip wheel

        pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
        pip install ultralytics
        pip install opencv-python-headless
        pip install pillow numpy pandas matplotlib seaborn
        pip install requests pyyaml tqdm psutil

        echo "Virtual environment setup complete!"
      else
        echo "Virtual environment already exists"
      fi
    '';
    mode = "0755";
  };

  system.stateVersion = "23.11";
}