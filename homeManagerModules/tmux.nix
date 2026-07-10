{ lib, config, ... }: {
  options.modules.tmux.enable = lib.mkEnableOption "tmux terminal multiplexer";

  config = lib.mkIf config.modules.tmux.enable {
    programs.tmux = {
      enable = true;
      extraConfig = builtins.readFile ../tmux.conf;
    };
  };
}
