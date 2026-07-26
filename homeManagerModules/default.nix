{ lib, ... }: {
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  imports = [
    ./theme.nix
    ./firefox.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./bash.nix
    ./waybar.nix
    ./wofi.nix
    ./mako.nix
    ./kitty.nix
    ./tmux.nix
    ./git.nix
    ./vscode.nix
    ./screenshot.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./clipboard.nix
    ./wlogout.nix
    ./spotify.nix
    ./direnv.nix
  ];
}
