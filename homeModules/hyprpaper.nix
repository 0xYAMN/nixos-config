{ lib, config, pkgs, ... }: {
  options.modules.hyprpaper.enable = lib.mkEnableOption "hyprpaper wallpaper daemon";

  config = lib.mkIf config.modules.hyprpaper.enable {
    home.packages = [ pkgs.hyprpaper ];

    services.hyprpaper = {
      enable = true;
      # Hyprpaper is started by hyperland.lue exec to avoid races with monitors not init
      package = null;
      settings = {
        splash = false;
        preload = [ "${./wallpaper.jpg}" ];
        wallpaper = [
          {
            monitor = "";
            path = "${./wallpaper.jpg}";
          }
        ];
      };
    };
  };
}
