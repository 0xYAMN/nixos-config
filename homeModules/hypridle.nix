{ lib, config, ... }: {
  options.modules.hypridle.enable = lib.mkEnableOption "hypridle idle daemon";

  config = lib.mkIf config.modules.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          # Avoid spawning multiple hyprlock instances if already locked
          lock_cmd         = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd  = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            # 5 min idle --> lock screen
            timeout    = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            # 10 min idle --> turn off display
            timeout    = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume  = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
