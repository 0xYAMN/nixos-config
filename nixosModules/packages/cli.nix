{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.modules.packages.enable {
    programs.wireshark.enable = true;
    programs.wireshark.package = pkgs.wireshark;

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
      wireshark
      fastfetch
      cmatrix
      ffmpeg
      cava
      yazi
    ];
  };
}
