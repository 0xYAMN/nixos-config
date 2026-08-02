{ pkgs, lib, config, ... }: {
  options.modules.wofi.enable = lib.mkEnableOption "wofi application launcher";

  config = lib.mkIf config.modules.wofi.enable {
    home.packages = with pkgs; [ wofi ];

    # ── Wofi config ─────────────────────────────────────────────────────────────
    xdg.configFile."wofi/config".text = ''
      width=600
      height=400
      location=center
      allow_markup=true
      allow_images=true
      image_size=32
      columns=1
      prompt=Search...
      terminal=kitty
    '';

    # ── Wofi CSS ─────────────────────────────────────────────────────────────────
    xdg.configFile."wofi/style.css".source = ./wofi_style.css;
  };
}
