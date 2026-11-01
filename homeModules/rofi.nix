{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.rofi.enable = lib.mkEnableOption "rofi application launcher";

  config = lib.mkIf config.modules.rofi.enable {
    home.packages = with pkgs; [ rofi ];

    # ── Rofi config ─────────────────────────────────────────────────────────────
    xdg.configFile."rofi/config.rasi".text = ''
      configuration {
        modi:           "drun,run";
        show-icons:     true;
        display-drun:   "";
        drun-display-format: "{name}";
        terminal:       "kitty";
      }
      @theme "~/.config/rofi/theme.rasi"
    '';

    # ── Rofi theme ──────────────────────────────────────────────────────────────
    xdg.configFile."rofi/theme.rasi".source = ./rofi_theme.rasi;
  };
}
