{ lib, config, ... }: {
  options.modules.audio.enable = lib.mkEnableOption "audio via pipewire";

  config = lib.mkIf config.modules.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
