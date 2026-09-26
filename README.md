# NixOS -- My Personal Config

This repository contains my flake-based NixOS configuration for the machines I use daily, including my Hyprland setup, theming, and assorted dotfiles managed through home-manager.

## Hosts

| Host | Machine | Notes |
| --- | --- | --- |
| `prometheus` | Laptop | |
| `thoth` | Desktop | NVIDIA GPU |

## MATLAB

This config uses `matlab`/`matlab-shell` from [`0xYAMN/nix-matlab`](https://github.com/0xYAMN/nix-matlab) (fork of unmaintained original). 
This doesnt install MATLAB itself
1. `matlab-shell`
2. `cd <extracted installer dir> && ./install`
3. Install to a user-writable dir, e.g. `~/opt/matlab`
4. `~/.config/matlab/nix.sh`:
   ```
   INSTALL_DIR=/home/yamn/opt/matlab
   ```

## License

[GPLv3](LICENSE)
