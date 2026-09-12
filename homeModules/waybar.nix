{ pkgs, lib, config, ... }: {
  options.modules.waybar = {
    enable = lib.mkEnableOption "waybar status bar";

    outputs = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          output = lib.mkOption { type = lib.types.str; };
        };
      });
      default = [];
    };
  };

  config = lib.mkIf config.modules.waybar.enable {
    home.packages = [ pkgs.swayosd ];

    programs.waybar =
      let
        commonModules = {
          clock = {
            format = "  {:%a %d %b   %H:%M}";
            tooltip = false;
          };

          battery = {
            bat = "BAT0";
            format = "{icon}  {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            states = { warning = 30; critical = 15; };
            tooltip = false;
          };

          network = {
            format-wifi         = "󰤨  {essid}";
            format-ethernet     = "󰈀  eth";
            format-disconnected = "󰤮  offline";
            tooltip = false;
          };

          cpu = {
            format = "CPU {usage}%";
            interval = 2;
            tooltip = false;
          };

          temperature = {
            hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
            format = "TEMP {temperatureC}°C";
            format-critical = "TEMP {temperatureC}°C";
            critical-threshold = 80;
            tooltip = false;
          };

          memory = {
            format = "RAM {used:0.1f}GB";
            interval = 2;
            tooltip = false;
          };

          pulseaudio = {
            format = "{icon}  {volume}%";
            format-muted = "󰝟  muted";
            format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
            on-click = "swayosd-client --output-volume mute-toggle";
            on-scroll-up = "swayosd-client --output-volume raise";
            on-scroll-down = "swayosd-client --output-volume lower";
            tooltip = false;
          };

          tray = {
            spacing = 8;
            icon-size = 16;
          };

          "custom/logout" = {
            format = "󰐥";
            on-click = "wlogout";
            tooltip = false;
          };
        };

        commonBar = {
          layer    = "top";
          position = "top";
          height   = 32;
          spacing  = 0;
          margin-top = 0;
          margin-left = 0;
          margin-right = 0;
          modules-left   = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right  = [ "cpu" "temperature" "memory" "pulseaudio" "network" "battery" "tray" "custom/logout" ];
        } // commonModules;

        workspacesPerMonitor = 8;
        maxMonitorsSupported = 8;
        numberIcons = lib.listToAttrs (map (n: {
          name  = toString n;
          value = toString (lib.mod (n - 1) workspacesPerMonitor + 1);
        }) (lib.range 1 (workspacesPerMonitor * maxMonitorsSupported)));

        workspacesModule = {
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = numberIcons;
            on-click = "activate";
            persistent-workspaces = {
              "*" = workspacesPerMonitor;
            };
          };
        };
      in
      {
      enable = true;

      settings = map (o:
        commonBar // { output = o.output; } // workspacesModule
      ) config.modules.waybar.outputs;

      style = builtins.readFile ./waybar.css;
    };
  };
}
