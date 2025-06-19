{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Rust toolchain
    rustc cargo

    # Python with ML packages
    (python3.withPackages (ps: with ps; [
      pip wheel setuptools
      torch torchvision
      opencv4 pillow numpy pandas matplotlib seaborn
      ultralytics
      requests pyyaml tqdm psutil
      scipy scikit-learn scikit-image
    ]))

    # Build tools
    gcc glibc.dev pkg-config cmake
    zlib.dev libffi.dev openssl.dev
  ];

  boot.kernel.sysctl = {
    "kernel.shmmax" = 134217728;
    "kernel.shmall" = 32768;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 4096 16777216";
    "net.ipv4.tcp_wmem" = "4096 4096 16777216";
  };
}