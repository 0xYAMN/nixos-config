{ pkgs, lib, config, ... }: {
  options.modules.mako.enable = lib.mkEnableOption "mako notification daemon";

  config = lib.mkIf config.modules.mako.enable {
    services.mako.settings = {
      enable = true;

      # Layout
      anchor         = "top-center";
      width          = 480;
      margin         = "12";
      padding        = "12,16";
      borderSize     = 1;
      borderRadius   = 10;
      defaultTimeout = 5000;
      ignoreTimeout  = true;
      maxIconSize    = 48;
      icons          = true;

      # Catppuccin Macchiato / Mauve
      font            = "Hack Nerd Font 12";
      backgroundColor = "#24273a";
      textColor       = "#cad3f5";
      borderColor     = "#c6a0f6";

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
