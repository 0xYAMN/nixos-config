{ lib, config, ... }: {
  options.modules.bootvine.enable = lib.mkEnableOption "bootvine, a live tree of systemd jobs on the boot and shutdown console";

  config = lib.mkIf config.modules.bootvine.enable {
    services.bootvine.enable = true;

    boot.kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
    ];
    boot.consoleLogLevel = 3;
    boot.initrd.verbose = false;
  };
}
