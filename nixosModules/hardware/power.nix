{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.power;

  profileOption =
    default: description:
    lib.mkOption {
      type = lib.types.enum [
        "low-power"
        "balanced"
        "performance"
      ];
      inherit default description;
    };

  # intel_pstate exposes the inverse: no_turbo = 1 disables boost.
  noTurbo = enabled: if enabled then "0" else "1";

  # Arg is the AC adapter's "online" value: 1 = charger, 0 = battery.
  applyPower = pkgs.writeShellScript "apply-power" ''
    turbo=/sys/devices/system/cpu/intel_pstate/no_turbo
    profile=/sys/firmware/acpi/platform_profile
    if [ "$1" = 1 ]; then
      no_turbo=${noTurbo cfg.turbo.ac} mode=${cfg.platformProfile.ac}
    else
      no_turbo=${noTurbo cfg.turbo.battery} mode=${cfg.platformProfile.battery}
    fi
    [ -w "$turbo" ] && echo "$no_turbo" > "$turbo"
    [ -w "$profile" ] && echo "$mode" > "$profile"
    exit 0
  '';
in
{
  options.modules.power = {
    enable = lib.mkEnableOption "AC/battery dependent CPU turbo and platform profile";

    platformProfile.ac = profileOption "performance" "ACPI platform profile while on the charger.";
    platformProfile.battery = profileOption "balanced" "ACPI platform profile while on battery.";

    turbo.ac = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether CPU turbo boost is allowed while on the charger.";
    };
    turbo.battery = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether CPU turbo boost is allowed while on battery.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ACTION=="add|change", RUN+="${applyPower} $attr{online}"
    '';
  };
}
