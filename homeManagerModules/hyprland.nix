{ lib, config, ... }: {
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
