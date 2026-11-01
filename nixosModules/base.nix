{ pkgs, ... }:
{
  # ── Boot ─────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Storage ──────────────────────────────────────────────────────────────
  services.fstrim.enable = true;
  zramSwap.enable = true;

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "nixos";

  # ── Locale & time ─────────────────────────────────────────────────────────
  time.timeZone = "Europe/Amsterdam";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # ── Users ─────────────────────────────────────────────────────────────────
  users.users.yamn = {
    isNormalUser = true;
    description = "Yannick Monjeamb";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "wireshark"
    ];
    initialPassword = "changeme";
    shell = pkgs.bash;
  };

  nixpkgs.config.allowUnfree = true;

  # ── MATLAB ─────────
  environment.systemPackages = [
    pkgs.matlab
    pkgs.matlab-shell
  ];

  system.stateVersion = "25.11";
}
