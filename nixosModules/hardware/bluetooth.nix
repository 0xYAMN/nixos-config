{ lib, config, ... }: {
  options.modules.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf config.modules.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;
  };
}
