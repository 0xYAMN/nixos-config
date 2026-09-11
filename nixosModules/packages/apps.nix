{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.modules.packages.enable {
    # LocalSend
    networking.firewall.allowedTCPPorts = [ 53317 ];
    networking.firewall.allowedUDPPorts = [ 53317 ];

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
      nautilus
      localsend
      slack
      _1password-gui
      vlc
      webex
      wlogout
      vscode
    ];
  };
}
