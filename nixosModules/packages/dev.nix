{
  pkgs,
  pkgsUnstable,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.packages.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      libusb-compat-0_1 # for tool-teensy's teensy_loader_cli_bin
      zstd # for the arm-none-eabi gcc toolchain (libzstd.so.1)
      libudev-zero # for tool-teensy's teensy_reboot (libudev.so.1)
      stdenv.cc.cc.lib
      zlib
    ];
    services.udev.packages = [ pkgs.teensy-udev-rules ];
    environment.systemPackages = with pkgs; [
      gcc
      gnumake
      pkg-config
      cmake
      ninja
      binutils
      docker-compose
      can-utils
      (foxglove-studio.overrideAttrs (old: rec {
        version = "3.3.0";
        src = fetchurl {
          url = "https://get.foxglove.dev/desktop/v${version}/foxglove-studio-${version}-linux-amd64.deb";
          hash = "sha256-LWSpJ4lnsLpwrxFvade0fZl3sWgAgFU+MEdwyfFcDSo=";
        };
      }))
      helix
      antigravity
      zed-editor
      nil
      nixd
      pkgsUnstable.claude-code
      python3
      uv
      go
      lmstudio
      savvycan
      glab
      gh
      openssl
      opencode
      qwen-code
    ];
  };
}
