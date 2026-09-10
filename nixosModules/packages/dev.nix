{ pkgs, pkgsUnstable, lib, config, ... }: {
  config = lib.mkIf config.modules.packages.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      libusb-compat-0_1   # for tool-teensy's teensy_loader_cli_bin
      zstd                # for the arm-none-eabi gcc toolchain (libzstd.so.1)
      libudev-zero        # for tool-teensy's teensy_reboot (libudev.so.1)
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
      foxglove-studio
      pkgsUnstable.claude-code
      python3
      go
      lmstudio
    ];
  };
}
