{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.packages.games.enable = lib.mkEnableOption "games and related apps";

  config = lib.mkIf config.modules.packages.games.enable {
    environment.systemPackages = with pkgs; [
      ftb-app
      easyeffects
      lunar-client
      modrinth-app
    ];
  };
}
