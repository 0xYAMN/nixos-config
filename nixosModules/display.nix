{ lib, config, pkgs, ... }: {
  options.modules.display.enable = lib.mkEnableOption "display via hyprland + greetd";

  config = lib.mkIf config.modules.display.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.cage}/bin/cage -s -- ${pkgs.gtkgreet}/bin/gtkgreet";
          user = "greeter";
        };
        initial_session = {
          command = "${pkgs.hyprland}/bin/start-hyprland";
          user = "yamn";
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      start-hyprland
      bash
    '';
  };
}
