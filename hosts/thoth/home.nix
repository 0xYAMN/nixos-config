{ ... }:

{
  home.username    = "yamn";
  home.homeDirectory = "/home/yamn";

  # ── Home-manager modules ───────────────────────────────────────────────────
  modules.theme.enable      = true;
  modules.firefox.enable    = true;
  modules.bash.enable       = true;
  modules.hyprland.enable   = true;
  modules.hyprland.monitors = [
    { output = "DP-3"; mode = "2560x1440@144"; position = "0x0";    scale = 1;    }
    { output = "DP-2"; mode = "3840x2160@60";  position = "2560x0"; scale = 1; }
  ];
  modules.hyprpaper.enable  = true;
  modules.waybar.enable     = true;
  modules.waybar.outputs    = [
    { output = "DP-3"; }
    { output = "DP-2"; }
  ];
  modules.wofi.enable       = true;
  modules.mako.enable       = true;
  modules.kitty.enable      = true;
  modules.tmux.enable       = true;
  modules.git.enable        = true;
  modules.vscode.enable     = true;
  modules.screenshot.enable = true;
  modules.hyprlock.enable    = true;
  modules.hypridle.enable    = true;
  modules.clipboard.enable   = true;
  modules.wlogout.enable     = true;
  modules.spotify.enable     = true;
  modules.direnv.enable      = true;

  home.stateVersion = "25.11";
}
