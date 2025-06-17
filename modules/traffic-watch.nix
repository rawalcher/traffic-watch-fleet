{ config, pkgs, lib, ... }:

{
  # Development tools and libraries for Traffic Watch
  environment.systemPackages = with pkgs; [
    # Rust toolchain
    rustc cargo

    # Python and packages
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.wheel
    python3Packages.numpy
    python3Packages.pillow

    # Build tools
    gcc glibc.dev pkg-config cmake

    # Development libraries
    zlib.dev libffi.dev openssl.dev
  ];

  # Setup script for Python virtual environment
  environment.etc."setup-traffic-venv.sh" = {
    text = ''
      #!/bin/bash
      set -euo pipefail

      VENV_DIR="/home/nixos/rust-traffic-watch/.venv"

      cd /home/nixos/rust-traffic-watch

      if [ ! -d "$VENV_DIR" ]; then
        echo "Creating virtual environment..."
        python3 -m venv "$VENV_DIR"
        source "$VENV_DIR/bin/activate"

        echo "Upgrading pip and installing wheel..."
        pip install --upgrade pip wheel

        echo "Installing PyTorch (CPU version)..."
        pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

        echo "Installing computer vision and ML packages..."
        pip install ultralytics opencv-python-headless

        echo "Installing utility packages..."
        pip install pillow numpy pandas matplotlib seaborn requests pyyaml tqdm psutil

        echo "Virtual environment setup complete!"
      else
        echo "Virtual environment already exists at $VENV_DIR"
        echo "To recreate, remove the directory and run this script again."
      fi
    '';
    mode = "0755";
  };
}