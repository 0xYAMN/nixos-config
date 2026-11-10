{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.can;
in
{
  options.modules.can = {
    enable = lib.mkEnableOption "automatic CAN interface bring-up (systemd-networkd)";
    interface = lib.mkOption {
      type = lib.types.str;
      default = "can0";
      description = "CAN interface name to configure.";
    };
    bitrate = lib.mkOption {
      type = lib.types.int;
      default = 1000000;
      description = "CAN bitrate in bit/s.";
    };
    restartSec = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        Seconds before the controller auto-restarts after bus-off. Leave null for
        adapters whose driver lacks restart support
      '';
    };
    busOffRecovery = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Watch the interface and cycle it down/up when it enters BUS-OFF.
          Needed for drivers without restart-ms support
        '';
      };
      interval = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Seconds between state checks, and the delay before each recovery attempt.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.network.enable = true;
    systemd.network.networks."40-${cfg.interface}" = {
      matchConfig.Name = cfg.interface;
      canConfig = {
        BitRate = cfg.bitrate;
      }
      // lib.optionalAttrs (cfg.restartSec != null) {
        RestartSec = "${toString cfg.restartSec}s";
      };
      linkConfig.RequiredForOnline = "no";
    };

    systemd.services."can-bus-off-recovery" = lib.mkIf cfg.busOffRecovery.enable {
      description = "Recover ${cfg.interface} from CAN bus-off";
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.iproute2
        pkgs.gnugrep
      ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 5;
        ExecStart = pkgs.writeShellScript "can-bus-off-recovery" ''
          while true; do
            if ip -details link show ${cfg.interface} 2>/dev/null | grep -q "state BUS-OFF"; then
              echo "${cfg.interface} is BUS-OFF, cycling link"
              ip link set ${cfg.interface} down && ip link set ${cfg.interface} up \
                || echo "failed to recover ${cfg.interface}"
            fi
            sleep ${toString cfg.busOffRecovery.interval}
          done
        '';
      };
    };
    systemd.network.wait-online.enable = false;
  };
}
