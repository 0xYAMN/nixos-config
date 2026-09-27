{ pkgs, lib, config, ... }:
let
  # 4.7.x dev
  wireshark-dev = pkgs.wireshark.overrideAttrs (old: rec {
    version = "4.7.3";
    src = pkgs.fetchFromGitLab {
      owner = "wireshark";
      repo  = "wireshark";
      rev   = "v${version}";
      hash  = "sha256-Ttzc9kv7lOo+QrwUsS2b9ywL8wDpHluMDqZI/Y8cbb8=";
    };
  });
in {
  config = lib.mkIf config.modules.packages.enable {
    programs.wireshark.enable = true;
    programs.wireshark.package = wireshark-dev;

    environment.systemPackages = with pkgs; [
      bash
      tmux
      git
      git-lfs
      curl
      htop
      btop
      wget
      unzip
      ripgrep
      tcpdump
      wireshark-dev
      fastfetch
      cmatrix
      ffmpeg
      cava
      yazi
    ];
  };
}
