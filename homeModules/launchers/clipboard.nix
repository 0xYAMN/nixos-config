{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.clipboard.enable = lib.mkEnableOption "clipboard history (cliphist + rofi picker)";

  config = lib.mkIf config.modules.clipboard.enable {
    home.packages = [ pkgs.cliphist ];

    systemd.user.services.cliphist-expire = {
      Unit.Description = "Delete clipboard history entries older than 7 days";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "cliphist-expire";
            runtimeInputs = with pkgs; [
              cliphist
              coreutils
              gawk
            ];
            text = ''
              state="''${XDG_STATE_HOME:-$HOME/.local/state}/cliphist-expire"
              mkdir -p "$(dirname "$state")"
              touch "$state"

              today=$(date +%F)
              cutoff_date=$(date -d "7 days ago" +%F)
              newest=$(cliphist list | head -n1 | cut -f1 || true)
              [ -n "$newest" ] && echo "$today $newest" >> "$state"

              # newest id recorded on or before the cutoff date
              expire_id=$(awk -v d="$cutoff_date" '$1 <= d { id = $2 } END { print id }' "$state")
              [ -n "$expire_id" ] || exit 0

              cliphist list | awk -F'\t' -v id="$expire_id" '$1 <= id' | cliphist delete
              awk -v d="$cutoff_date" '$1 >= d' "$state" > "$state.tmp" && mv "$state.tmp" "$state"
            '';
          }
        );
      };
    };

    systemd.user.timers.cliphist-expire = {
      Unit.Description = "Daily clipboard history expiry";
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
