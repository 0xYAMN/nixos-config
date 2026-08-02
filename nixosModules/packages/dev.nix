{ pkgs, pkgsUnstable, lib, config, ... }: {
  config = lib.mkIf config.modules.packages.enable {
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
    ];
  };
}
