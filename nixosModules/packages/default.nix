{ lib, ... }: {
  options.modules.packages.enable = lib.mkEnableOption "base system packages";

  imports = [
    ./apps.nix
    ./cli.nix
    ./dev.nix
  ];
}
