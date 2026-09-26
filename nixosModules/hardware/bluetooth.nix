{ lib, config, ... }: {
  options.modules.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf config.modules.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # AirPods:
    hardware.bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
        FastConnectable = true;
        Experimental = true;
      };
    };

    boot.kernelParams = [ "bluetooth.disable_ertm=1" ];

    services.blueman.enable = true;
  };
}
