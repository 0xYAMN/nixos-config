{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.mako.enable = lib.mkEnableOption "mako notification daemon";

  config = lib.mkIf config.modules.mako.enable {
    services.mako = {
      enable = true;

      settings = {
        # Layout
        anchor = "top-center";
        width = 480;
        margin = "12";
        padding = "12,16";
        border-size = 1;
        border-radius = 10;
        default-timeout = 5000;
        ignore-timeout = true;
        max-icon-size = 48;
        icons = true;

        # Catppuccin Macchiato / Mauve
        font = "Hack Nerd Font 12";
        background-color = "#24273a";
        text-color = "#cad3f5";
        border-color = "#c6a0f6";
      };

      extraConfig = ''
        [urgency=low]
        border-color=#a6da95

        [urgency=high]
        border-color=#ed8796
        default-timeout=5000
      '';
    };
  };
}
