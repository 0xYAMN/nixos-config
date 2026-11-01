{ ... }: {
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  imports = [
    ./theme.nix
    ./firefox.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./bash.nix
    ./waybar.nix
    ./rofi.nix
    ./mako.nix
    ./kitty.nix
    ./tmux.nix
    ./git.nix
    ./zed.nix
    ./screenshot.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./clipboard.nix
    ./powermenu.nix
    ./spotify.nix
    ./direnv.nix
  ];
}
