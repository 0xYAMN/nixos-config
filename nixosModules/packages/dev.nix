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
    # USB access for MCUs, programmers and debug probes (ST-Link, CMSIS-DAP, FTDI, ...)
    services.udev.packages = with pkgs; [
      teensy-udev-rules
      platformio-core.udev
      openocd
      stlink
    ];
    environment.systemPackages = with pkgs; [
      # Build Tools
      gcc
      gdb
      gnumake
      pkg-config
      cmake
      clang-tools
      gtest
      lcov
      ninja
      binutils
      docker-compose
      nixd
      nil
      can-utils
      # MCU flashing / debugging
      stm32cubemx
      openocd
      stlink
      esptool
      usbutils
      # Python
      python3
      uv
      basedpyright
      # GO
      go
      gopls
      gotools
      # Tools
      pkgsUnstable.claude-code
      qwen-code
      opencode
      pkgsUnstable.deepseek-harness
      # Editors
      zed-editor
      pkgsUnstable.vscode
      #
      savvycan
      pkgsUnstable.foxglove-studio
    ];
  };
}
