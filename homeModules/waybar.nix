{ pkgs, lib, config, ... }: {
  options.modules.waybar = {
    enable = lib.mkEnableOption "waybar status bar";

    outputs = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          output     = lib.mkOption { type = lib.types.str; };
          workspaces = lib.mkOption { type = lib.types.listOf lib.types.int; };
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
            format = "󰻠  {usage}%";
            interval = 2;
            tooltip = false;
          };

          temperature = {
            format = "󰔏  {temperatureC}°C";
            format-critical = "󰔏  {temperatureC}°C";
            critical-threshold = 80;
            tooltip = false;
          };

          memory = {
            format = "󰍛  {percentage}%";
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

          backlight = {
            format = "{icon}  {percent}%";
            format-icons = [ "󰃞" "󰃟" "󰃠" ];
            on-scroll-up = "swayosd-client --brightness raise";
            on-scroll-down = "swayosd-client --brightness lower";
            tooltip = false;
          };

          tray = {
            spacing = 8;
            icon-size = 16;
          };

          "custom/logout" = {
            format = "󰗼";
            on-click = "wlogout";
            tooltip = false;
          };
        };

        commonBar = {
          layer    = "top";
          position = "top";
          height   = 26;
          spacing  = 0;
          margin-top = 8;
          margin-left = 12;
          margin-right = 12;
          modules-left   = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right  = [ "cpu" "temperature" "memory" "backlight" "pulseaudio" "network" "battery" "tray" "custom/logout" ];
        } // commonModules;

        workspaces = persistent: {
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              "1" = "1"; "2" = "2"; "3" = "3"; "4" = "4"; "5" = "5";
              "6" = "6"; "7" = "7"; "8" = "8"; "9" = "9";
              active = "󰮯";
              urgent = "󰀦";
            };
            on-click = "activate";
            persistent-workspaces = persistent;
          };
        };
      in
      {
      enable = true;

      settings = map (o:
        commonBar // { output = o.output; } // workspaces { ${o.output} = o.workspaces; }
      ) config.modules.waybar.outputs;

      style = builtins.readFile ./waybar.css;
    };
  };
}
