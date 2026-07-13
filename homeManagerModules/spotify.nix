{ pkgs, lib, config, spicetify-nix, ... }:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  options.modules.spotify.enable = lib.mkEnableOption "spotify";

  config = lib.mkIf config.modules.spotify.enable {
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
