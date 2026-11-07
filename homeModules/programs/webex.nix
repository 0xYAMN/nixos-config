{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.webex.enable = lib.mkEnableOption "webex desktop entry";

  config = lib.mkIf config.modules.webex.enable {
    # Webex also writes its own ~/.local/share/applications/webex.desktop
    # pointing at /opt/Webex, which doesn't exist on NixOS and shadows the
    # packaged entry. Own that path and force-replace whatever Webex left there.
    xdg.dataFile."applications/webex.desktop" = {
      force = true;
      text = ''
        [Desktop Entry]
        Name=Webex
        Comment=Webex
        Exec=${pkgs.webex}/bin/webex %U
        Icon=${pkgs.webex}/opt/Webex/bin/sparklogosmall.png
        Terminal=false
        Type=Application
        Categories=Utility;Application;
        MimeType=x-scheme-handler/webexteams;x-scheme-handler/ciscospark;x-scheme-handler/webex
      '';
    };
  };
}
