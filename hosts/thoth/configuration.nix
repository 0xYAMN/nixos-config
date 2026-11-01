{ config, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ── NVIDIA ────────────────────────────────────────────────────────────────
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # open kernel module only supports RTX 2000+
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  # ── NixOS modules ─────────────────────────────────────────────────────────
  modules.audio.enable = true;
  modules.bluetooth.enable = true;
  modules.display.enable = true;
  modules.networking.enable = true;
  modules.nix.enable = true;
  modules.virtualisation.enable = true;
  modules.packages.enable = true;
  modules.packages.games.enable = true;

  # ── Home-manager user ─────────────────────────────────────────────────────
  home-manager.users.yamn = import ./home.nix;
}
