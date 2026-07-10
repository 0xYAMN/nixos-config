{ pkgs, lib, config, ... }: {
  options.modules.kitty.enable = lib.mkEnableOption "kitty terminal emulator";

  config = lib.mkIf config.modules.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
        background_opacity = "0.95";
      };
    };

    xdg.desktopEntries."kitty" = {
      name = "kitty";
      genericName = "Terminal emulator";
      comment = "";
      exec = "kitty";
      icon = "kitty";
      startupNotify = false;
      categories = [ "System" "TerminalEmulator" ];
      settings = {
        TryExec = "kitty";
        X-TerminalArgExec = "--";
        X-TerminalArgTitle = "--title";
        X-TerminalArgAppId = "--class";
        X-TerminalArgDir = "--working-directory";
        X-TerminalArgHold = "--hold";
      };
    };
  };
}
