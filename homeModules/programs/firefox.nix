{ lib, config, ... }: {
  options.modules.firefox.enable = lib.mkEnableOption "Firefox browser";

  config = lib.mkIf config.modules.firefox.enable {
    programs.firefox = {
      enable = true;

      configPath = ".mozilla/firefox";

      profiles.default = {
        settings = {
          # Required for catppuccin-nix
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };
}
