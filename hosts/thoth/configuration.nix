{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ── Boot ─────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Storage ──────────────────────────────────────────────────────────────
  services.fstrim.enable = true;

  # ── NVIDIA ────────────────────────────────────────────────────────────────
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # open kernel module only supports RTX 2000+
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "nixos";

  # ── Locale & time ─────────────────────────────────────────────────────────
  time.timeZone = "Europe/Amsterdam";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT    = "nl_NL.UTF-8";
    LC_MONETARY       = "nl_NL.UTF-8";
    LC_NAME           = "nl_NL.UTF-8";
    LC_NUMERIC        = "nl_NL.UTF-8";
    LC_PAPER          = "nl_NL.UTF-8";
    LC_TELEPHONE      = "nl_NL.UTF-8";
    LC_TIME           = "nl_NL.UTF-8";
  };

  # ── Users ─────────────────────────────────────────────────────────────────
  users.users.yamn = {
    isNormalUser = true;
    description  = "Yannick Monjeamb";
    extraGroups  = [ "wheel" "networkmanager" "video" "audio" "docker" "wireshark"];
    initialPassword = "changeme";
  };

  users.users.yamn.shell = pkgs.bash;

  nixpkgs.config.allowUnfree = true;

  # ── NixOS modules ─────────────────────────────────────────────────────────
  modules.audio.enable          = true;
  modules.bluetooth.enable      = true;
  modules.display.enable        = true;
  modules.networking.enable     = true;
  modules.virtualisation.enable = true;
  modules.packages.enable       = true;

  # ── Home-manager user ─────────────────────────────────────────────────────
  home-manager.users.yamn = import ./home.nix;

  system.stateVersion = "25.11";

  # ── Nix settings ──────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 7d";
  };
}
