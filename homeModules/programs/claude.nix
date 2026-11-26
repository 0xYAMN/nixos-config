{
  pkgs,
  lib,
  config,
  ...
}:
let
  statusline = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = with pkgs; [
      bash
      jq
      git
      gnugrep
      coreutils
    ];
    text = ''
      input=$(cat)

      # Orca installs its own statusLine command to report agent status.
      # Forward the payload to it so that keeps working, then draw our line.
      orca_hook="$HOME/.orca/agent-hooks/claude-statusline.sh"
      if [ -f "$orca_hook" ]; then
        printf '%s\n' "$input" | sh "$orca_hook" >/dev/null 2>&1 || true
      fi

      model=$(jq -r '.model.display_name // "Claude"' <<<"$input")
      dir=$(jq -r '.workspace.current_dir // .cwd // "."' <<<"$input")
      size=$(jq -r '.context_window.context_window_size // 0' <<<"$input")
      used=$(jq -r '(.context_window.current_usage // {}) | (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)' <<<"$input")

      pct=0
      if [ "$size" -gt 0 ]; then
        pct=$((used * 100 / size))
      fi

      branch=""
      dirty=0
      ins=0
      del=0
      if git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        branch=$(git -C "$dir" branch --show-current 2>/dev/null || true)
        dirty=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l)
        short=$(git -C "$dir" diff --shortstat 2>/dev/null || true)
        ins=$(grep -oE '[0-9]+ insertion' <<<"$short" | grep -oE '[0-9]+' || true)
        del=$(grep -oE '[0-9]+ deletion' <<<"$short" | grep -oE '[0-9]+' || true)
        ins=''${ins:-0}
        del=''${del:-0}
      fi

      printf '\033[1;35m%s\033[0m' "$model"
      if [ -n "$branch" ]; then
        printf ' \033[34m %s\033[0m' "$branch"
      fi
      printf ' · \033[36mctx %sk/%sk (%s%%)\033[0m' "$((used / 1000))" "$((size / 1000))" "$pct"
      printf ' · \033[32m(+%s,-%s)\033[0m' "$ins" "$del"
      printf ' · \033[33m%s dirty\033[0m\n' "$dirty"
    '';
  };

  settingsFile = ".claude/settings.json";
in
{
  options.modules.claude.enable = lib.mkEnableOption "Claude Code status line";

  config = lib.mkIf config.modules.claude.enable {
    # settings.json is also written by Claude Code and Orca, so it cannot be a
    # read-only nix-generated file. Only the statusLine key is set here; every
    # other key is kept as it is.
    home.activation.claudeStatusLine = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      settings="$HOME/${settingsFile}"
      current='{}'
      if [ -f "$settings" ]; then
        current=$(cat "$settings")
      fi

      if updated=$(${lib.getExe pkgs.jq} --arg cmd "${lib.getExe statusline}" \
          '.statusLine = {type: "command", command: $cmd}' <<<"$current"); then
        if [ "$updated" != "$current" ] && [ -z "''${DRY_RUN:-}" ]; then
          run mkdir -p "$(dirname "$settings")"
          tmp="$settings.tmp"
          printf '%s\n' "$updated" > "$tmp"
          mv -f "$tmp" "$settings"
        fi
      else
        echo "claude statusline: $settings is not valid JSON, leaving it unchanged" >&2
      fi
    '';
  };
}
