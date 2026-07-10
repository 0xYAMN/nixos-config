{ lib, config, ... }: {
  options.modules.networking.enable = lib.mkEnableOption "networking via networkmanager";

  config = lib.mkIf config.modules.networking.enable {
    networking.networkmanager.enable = true;

    environment.etc = {
          };
  };
}
