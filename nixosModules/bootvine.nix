{ lib, config, ... }: {
  options.modules.bootvine.enable = lib.mkEnableOption "bootvine, a live tree of systemd jobs on the boot and shutdown console";

  config = lib.mkIf config.modules.bootvine.enable {
    services.bootvine.enable = true;
  };
}
