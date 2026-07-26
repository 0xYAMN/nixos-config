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
    { output = "eDP-1"; mode = "1920x1080@60"; position = "0x0"; scale = 1; }
  ];
  modules.hyprpaper.enable  = true;
  modules.waybar.enable     = true;
  modules.waybar.outputs    = [
    { output = "eDP-1"; workspaces = [ 1 2 3 4 5 6 7 8 ]; }
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
