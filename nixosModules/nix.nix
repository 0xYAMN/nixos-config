{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.nix.enable = lib.mkEnableOption "extra binary caches (nix-community, hyprland)";

  config = lib.mkMerge [
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.auto-optimise-store = true;

      nix.gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      systemd.services.nix-gc.preStart = ''
        ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --delete-generations +10
      '';
    }

    (lib.mkIf config.modules.nix.enable {
      nix.settings = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    })
  ];
}
