{ lib, config, pkgs, ... }: {
  options.modules.vscode.enable = lib.mkEnableOption "vscode editor";

  config = lib.mkIf config.modules.vscode.enable {
    programs.vscode.enable = true;
    catppuccin.vscode.profiles.default.enable = true;
    home.sessionVariables.EDITOR = "code --wait";
    programs.vscode.profiles.default.userSettings = {
      "git.confirmSync" = false;
      "scm.repositories.visibe" = 1;
      "scm.defaultViewMode" = "tree";
      "direnv.restart.automatic" = true;
    };
    programs.vscode.mutableExtensionsDir = false;
    programs.vscode.profiles.default.extensions = [
      pkgs.vscode-extensions.mhutchie.git-graph
      pkgs.vscode-extensions.golang.go
      pkgs.vscode-extensions.ms-vscode.cpptools-extension-pack
      pkgs.vscode-extensions.ms-vscode.cpptools
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.ms-vscode.makefile-tools
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.mkhl.direnv
      pkgs.vscode-extensions.twxs.cmake
      pkgs.vscode-extensions.platformio.platformio-vscode-ide
    ];

  };
}
