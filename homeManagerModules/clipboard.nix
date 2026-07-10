{ lib, config, pkgs, ... }: {
  options.modules.clipboard.enable = lib.mkEnableOption "clipboard history (cliphist + wofi picker)";

  config = lib.mkIf config.modules.clipboard.enable {
    home.packages = [ pkgs.cliphist ];
  };
}
