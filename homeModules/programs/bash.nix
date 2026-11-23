{ lib, config, ... }: {
  options.modules.bash.enable = lib.mkEnableOption "bash shell management";

  config = lib.mkIf config.modules.bash.enable {
    programs.bash = {
      enable = true;

      historyControl = [
        "ignoredups"
        "erasedups"
      ];

      shellAliases = {
        "ll" = "ls -lah";
        "la" = "ls -A";
        ".." = "cd ..";
        "nixc" = "cd /home/yamn/nixos-config";
        "z" = "zeditor .";
        "sbrc" = "source ~/.bashrc";
        "cpwd" = "pwd | tr -d '\\n' | wl-copy";
        "dev" = "cd /home/yamn/DEV";
        "trdp" = "cd /home/yamn/DEV/IFS/trdp_abstraction_layer";
      };

      initExtra = ''

        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d \'\' cwd < "$tmp"
          [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
          command rm -f -- "$tmp"
        }

        # Prompt: [exit] (nix) user@host path (branch*) $
        __set_prompt() {
          local status=$?
          # Ignore the status left over from shell startup
          [ -z "$__prompt_started" ] && { __prompt_started=1; status=0; }

          local ps=""
          [ "$status" -ne 0 ] && ps+="\[\e[1;31m\][$status] "
          case "$IN_NIX_SHELL" in
            in-pure-shell) ps+="\[\e[1;33m\](pure-nix) " ;;
            impure)        ps+="\[\e[1;33m\](nix) " ;;
          esac
          ps+="\[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]"

          local branch dirty
          if branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null); then
            [ -n "$(git status --porcelain 2>/dev/null)" ] && dirty="*"
            ps+=" \[\e[1;35m\]($branch$dirty)\[\e[0m\]"
          fi

          PS1="$ps \\$ "
        }

        # ros2 tab completion
        _ros2_argcomplete_maybe() {
          command -v ros2 >/dev/null 2>&1 || return
          complete -p ros2 >/dev/null 2>&1 && return
          eval "$(register-python-argcomplete ros2 2>/dev/null)"
        }
        PROMPT_COMMAND="_ros2_argcomplete_maybe''${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
        # __set_prompt goes first so it sees the last command's exit status
        PROMPT_COMMAND="__set_prompt''${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

        # Auto-start tmux inside kitty
        if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -n "$KITTY_PID" ]; then
          exec tmux new-session -A -s "kitty-$KITTY_PID"
        fi

      '';
    };
  };
}
