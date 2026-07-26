{ pkgs, pkgsUnstable, lib, config, ... }: {
  options.modules.packages.enable = lib.mkEnableOption "base system packages";

  config = lib.mkIf config.modules.packages.enable {
    programs.wireshark.enable = true;
    programs.wireshark.package = pkgs.wireshark;
    programs.firefox.enable = true;

    programs.firefox.policies.ExtensionSettings = {
      "FirefoxColor@mozilla.com" = {
        installation_mode = "force_installed";
        install_url = "file://${pkgs.fetchurl {
          url = "https://addons.mozilla.org/firefox/downloads/file/3643624/firefox_color-2.1.7.xpi";
          hash = "sha256-t/sHtniPcjPdYiPngOGJtMe5VsJcQEk8KNcCBJMkkpI=";
        }}";
      };
    };

    environment.systemPackages = with pkgs; [
      # apps
      nautilus
      localsend
      slack
      _1password-gui
      vlc
      webex

      # terminal utils
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
      gcc
      gnumake
      pkg-config
      cava

      # docker
      docker-compose

      # build tools
      cmake
      ninja
      pkg-config
      binutils

      # 
      wlogout

      # hardware development
      can-utils

      # editors
      vscode

      # ai
      pkgsUnstable.claude-code
    ];
  };
}
