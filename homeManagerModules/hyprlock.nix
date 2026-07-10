{ lib, config, ... }: {
  options.modules.hyprlock.enable = lib.mkEnableOption "hyprlock screen locker";

  config = lib.mkIf config.modules.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor         = true;
        };

        background = [
          {
            path         = "${./wallpaper.jpg}";
            blur_size    = 4;
            blur_passes  = 3;
            brightness   = 0.6;
          }
        ];

        # Clock
        label = [
          {
            text        = ''cmd[update:1000] date +"%H:%M"'';
            color       = "rgba(4c4f69ff)"; # Catppuccin Latte: text
            font_size   = 90;
            font_family = "Hack Nerd Font Bold";
            position    = "0, 80";
            halign      = "center";
            valign      = "center";
          }
        ];

        "input-field" = [
          {
            size             = "200, 50";
            position         = "0, -80";
            halign           = "center";
            valign           = "center";
            outline_thickness = 2;
            dots_size        = 0.33;
            dots_spacing     = 0.15;
            dots_center      = true;
            outer_color      = "rgba(8839efff)"; # Catppuccin Latte: mauve
            inner_color      = "rgba(eff1f5ff)"; # Catppuccin Latte: base
            font_color       = "rgba(4c4f69ff)"; # Catppuccin Latte: text
            placeholder_text = "";
          }
        ];
      };
    };
  };
}
