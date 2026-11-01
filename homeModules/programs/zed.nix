{ lib, config, ... }: {
  options.modules.zed.enable = lib.mkEnableOption "zed editor";

  config = lib.mkIf config.modules.zed.enable {
    programs.zed-editor.enable = true;
    catppuccin.zed.enable = true;

    programs.zed-editor.userSettings = {
      vim_mode = false;

      disable_ai = true;

      lsp.clangd.binary.arguments = [
        "--query-driver=/home/yamn/.platformio/packages/toolchain-*/bin/*,/nix/store/*/bin/*"
      ];
    };

    programs.zed-editor.userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-f12" = "editor::GoToImplementation";
          "ctrl-shift-f12" = "editor::GoToImplementationSplit";
        };
      }
    ];
  };
}
