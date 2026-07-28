{ lib, config, ... }: {
  options.modules.bash.enable = lib.mkEnableOption "bash shell management";

  config = lib.mkIf config.modules.bash.enable {
    programs.bash = {
      enable = true;

      historyControl = [ "ignoredups" "erasedups" ];

      shellAliases = {
        "ll"  = "ls -lah";
        "la"  = "ls -A";
        ".." = "cd ..";
        "nixc" = "cd /home/yamn/nixos-config";
        "dev" = "cd /home/yamn/DEV";
        "trdp" = "cd /home/yamn/DEV/IFS/trdp_abstraction_layer";
	      "sbrc" = "source ~/.bashrc";      
      };

      initExtra = ''
        
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d \'\' cwd < "$tmp"
          [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
          command rm -f -- "$tmp"
        }

        nix_shell_status() {
            if [ "$IN_NIX_SHELL" = "in-pure-shell" ]; then
                echo "(pure-nix) "
            elif [ "$IN_NIX_SHELL" = "impure" ]; then
                echo "(nix) "
            fi
        }

        if [ -n "$IN_NIX_SHELL" ]; then
          # Ensure terminal escape sequences \[\ stories \] are correctly wrapped if using colors
          PS1="$(nix_shell_status)[\u@\h:\w]\$ "
        fi

        # Auto-start tmux inside kitty
        if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -n "$KITTY_PID" ]; then
          exec tmux new-session -A -s "kitty-$KITTY_PID"
        fi

      '';
    };
  };
}
