{ lib, config, ... }: {
  options.modules.hypridle = {
    enable = lib.mkEnableOption "hypridle idle daemon";

    lockTimeout = lib.mkOption {
      type = lib.types.ints.positive;
      default = 5;
      description = "Minutes of idle time before the screen is locked.";
    };

    sleepTimeout = lib.mkOption {
      type = lib.types.ints.positive;
      default = 10;
      description = "Minutes of idle time before the display is turned off (sleep).";
    };
  };

  config = lib.mkIf config.modules.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          # Avoid spawning multiple hyprlock instances if already locked
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            # idle --> lock screen
            timeout = config.modules.hypridle.lockTimeout * 60;
            on-timeout = "loginctl lock-session";
          }
          {
            # idle --> turn off display
            timeout = config.modules.hypridle.sleepTimeout * 60;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
