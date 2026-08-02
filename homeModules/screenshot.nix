{ pkgs, lib, config, ... }: {
  options.modules.screenshot.enable = lib.mkEnableOption "screenshot tools (grim + slurp + wl-clipboard)";

  config = lib.mkIf config.modules.screenshot.enable {
    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];
  };
}
