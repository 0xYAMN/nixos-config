{ lib, config, pkgs, ... }: {
  options.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland window manager";

    monitors = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          output   = lib.mkOption { type = lib.types.str; };
          mode     = lib.mkOption { type = lib.types.str; };
          position = lib.mkOption { type = lib.types.str; default = "0x0"; };
          scale    = lib.mkOption { type = lib.types.number; default = 1; };
        };
      });
      default = [];
    };

    workspaceMonitors = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          workspace = lib.mkOption { type = lib.types.str; };
          monitor   = lib.mkOption { type = lib.types.str; };
        };
      });
      default = [];
    };
  };

  config = lib.mkIf config.modules.hyprland.enable {
    home.packages = [
      pkgs.jq
      (pkgs.writeShellScriptBin "hypr-workspace" ''
        set -euo pipefail
        NUM_WORKSPACES=8

        local_ws="$1"
        mode="$2"

        monitor_id=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq '[.[] | select(.focused == true)][0].id')
        global_ws=$(( monitor_id * NUM_WORKSPACES + local_ws ))

        case "$mode" in
          focus)      ${pkgs.hyprland}/bin/hyprctl dispatch "hl.dsp.focus({workspace=$global_ws})" ;;
          movesilent) ${pkgs.hyprland}/bin/hyprctl dispatch "hl.dsp.window.move({workspace=$global_ws})" ;;
          movefollow) ${pkgs.hyprland}/bin/hyprctl dispatch "hl.dsp.window.move({workspace=$global_ws, follow=true})" ;;
          *) echo "hypr-workspace: unknown mode '$mode'" >&2; exit 1 ;;
        esac
      '')
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      configType = "lua";
      extraConfig =
        let
          monitorLines = lib.concatMapStringsSep "\n" (m:
            ''hl.monitor({ output = "${m.output}", mode = "${m.mode}", position = "${m.position}", scale = ${toString m.scale} })'')
            config.modules.hyprland.monitors;

          workspaceLines = lib.concatMapStringsSep "\n" (w:
            ''hl.workspace_rule({ workspace = "${w.workspace}", monitor = "${w.monitor}" })'')
            config.modules.hyprland.workspaceMonitors;

          monitorSection = lib.optionalString (config.modules.hyprland.monitors != [])
            ("-- ── Monitors ─────────────────────────────────────────────────────────────────\n"
              + monitorLines + "\n");

          workspaceSection = lib.optionalString (config.modules.hyprland.workspaceMonitors != [])
            ("\n-- ── Workspace assignments ────────────────────────────────────────────────────\n"
              + workspaceLines + "\n");
        in
        monitorSection + workspaceSection + "\n" + builtins.readFile ./hyprland.lua;
    };
  };
}
