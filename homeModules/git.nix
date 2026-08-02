{ lib, config, ... }: {
  options.modules.git.enable = lib.mkEnableOption "git version control";

  config = lib.mkIf config.modules.git.enable {
    programs.git = {
      enable = true;
      settings.user.name = "Yannick Monjeamb";
      settings.user.email = "yannick.monjeamb@rwth-aachen.de";
      signing = {
        signByDefault = true;
        key = "~/.ssh/id_ed25519.pub";
      };
      settings = {
        gpg = {
          format = "ssh";
        };
      };
    };
  };
}
