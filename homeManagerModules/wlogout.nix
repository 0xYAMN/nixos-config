{ pkgs, lib, config, ... }: {
  options.modules.wlogout.enable = lib.mkEnableOption "wlogout session menu";

  config = lib.mkIf config.modules.wlogout.enable {
    home.packages = [ pkgs.wlogout ];

    xdg.configFile."wlogout/layout".text = ''
      {
          "label" : "lock",
          "action" : "loginctl lock-session",
          "text" : "Lock",
          "keybind" : "l"
      }
      {
          "label" : "logout",
          "action" : "hyprctl dispatch exit 0",
          "text" : "Logout",
          "keybind" : "e"
      }
      {
          "label" : "suspend",
          "action" : "systemctl suspend",
          "text" : "Suspend",
          "keybind" : "s"
      }
      {
          "label" : "hibernate",
          "action" : "systemctl hibernate",
          "text" : "Hibernate",
          "keybind" : "h"
      }
      {
          "label" : "reboot",
          "action" : "systemctl reboot",
          "text" : "Reboot",
          "keybind" : "r"
      }
      {
          "label" : "shutdown",
          "action" : "systemctl poweroff",
          "text" : "Shutdown",
          "keybind" : "u"
      }
    '';

    xdg.configFile."wlogout/style.css".text = ''
      * {
        font-family: "Hack Nerd Font", monospace;
        font-size: 14px;
      }

      window {
        background-color: rgba(30, 30, 46, 0.85);
      }

      button {
        background-color: #313244;
        color:            #cdd6f4;
        border:           2px solid transparent;
        border-radius:    12px;
        margin:           12px;
        box-shadow:       none;
        outline:          none;
        text-shadow:      none;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 40%;
        transition: background-color 0.2s ease, border-color 0.2s ease;
      }

      button:hover {
        background-color: #45475a;
        border-color:     #cba6f7;
        box-shadow:       none;
        outline:          none;
      }

      button:focus {
        box-shadow: none;
        outline:    none;
      }

      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }
      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }
      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }
      #hibernate {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }
      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }
    '';
  };
}
