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
    services.udev.packages = [
      pkgs.teensy-udev-rules
      pkgs.stlink
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
      # Embedded
      stm32cubemx
      stlink
      openocd
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
