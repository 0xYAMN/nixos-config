{ lib, config, ... }: {
  options.modules.virtualisation.enable = lib.mkEnableOption "virtualisation via docker";

  config = lib.mkIf config.modules.virtualisation.enable {
    virtualisation.docker.enable = true;
  };
}
