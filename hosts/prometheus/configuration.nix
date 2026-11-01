{ ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ── NixOS modules ─────────────────────────────────────────────────────────
  modules.audio.enable = true;
  modules.bluetooth.enable = true;
  modules.display.enable = true;
  modules.networking.enable = true;
  modules.nix.enable = true;
  modules.power.enable = true;
  modules.power.turbo.battery = true;
  modules.power.platformProfile.battery = "low-power";
  modules.power.turbo.ac = true;
  modules.power.platformProfile.ac = "performance";
  modules.virtualisation.enable = true;
  modules.packages.enable = true;

  # ── Home-manager user ─────────────────────────────────────────────────────
  home-manager.users.yamn = import ./home.nix;
}
