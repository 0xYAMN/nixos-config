{ pkgs, lib, config, ... }: {
  options.modules.theme.enable = lib.mkEnableOption "catppuccin theme + fonts";

  config = lib.mkIf config.modules.theme.enable {
    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = "mocha";
      accent = "mauve";
      hyprland.enable = true;
      hyprlock.enable = false;

      firefox = {
        enable = true;
        accent = "mauve";
        force = true;
        flavor = "mocha";
      };

      kitty = {
        enable = true;
        flavor = "mocha";
      };

    };

    # Cursor theme — matches catppuccin macchiato/mauve setup
    home.pointerCursor = {
      package = pkgs.catppuccin-cursors.macchiatoMauve;
      name    = "catppuccin-mocha-mauve-cursors";
      size    = 24;
      gtk.enable = true;   # also applies cursor to GTK apps
    };

    home.packages = with pkgs; [ nerd-fonts.hack ];
    fonts.fontconfig.enable = true;
  };
}
