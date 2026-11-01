{
  pkgs,
  lib,
  config,
  ...
}:
let
  powermenu = pkgs.writeShellApplication {
    name = "rofi-powermenu";
    runtimeInputs = with pkgs; [
      rofi
      systemd
      hyprland
    ];
    text = ''
      menu() {
        rofi -dmenu -i -p "$1" -theme-str "listview { lines: $2; }"
      }

      confirm() {
        [ "$(printf 'No\nYes\n' | menu "$1" 2)" = "Yes" ]
      }

      choice=$(printf '%s\n' "󰌾  Lock" "󰍃  Logout" "󰒲  Suspend" "󰋊  Hibernate" "󰜉  Reboot" "󰐥  Shutdown" | menu "Power" 6)

      case "$choice" in
        *Lock)      loginctl lock-session ;;
        *Logout)    confirm "Logout?" && hyprctl dispatch exit 0 ;;
        *Suspend)   systemctl suspend ;;
        *Hibernate) systemctl hibernate ;;
        *Reboot)    confirm "Reboot?" && systemctl reboot ;;
        *Shutdown)  confirm "Shutdown?" && systemctl poweroff ;;
      esac
    '';
  };
in
{
  options.modules.powermenu.enable = lib.mkEnableOption "rofi power menu";

  config = lib.mkIf config.modules.powermenu.enable {
    home.packages = [ powermenu ];
  };
}
