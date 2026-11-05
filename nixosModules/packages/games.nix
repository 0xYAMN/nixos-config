{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.packages.games.enable = lib.mkEnableOption "games and related apps";

  config = lib.mkIf config.modules.packages.games.enable {
    environment.systemPackages = with pkgs; [
      ftb-app
      easyeffects
      lunar-client
      # WebKitGTK dmabuf renderer crashes on Wayland + NVIDIA (Wayland protocol error 71)
      (symlinkJoin {
        name = "modrinth-app";
        paths = [
          (modrinth-app.overrideAttrs (old: {
            # the package --sets LD_LIBRARY_PATH for the game, but leaves out the vulkan loader
            # (minecraft 26.x wants vulkan) and libs for lwjgl/glfw
            runtimeDependencies =
              old.runtimeDependencies
              + ":"
              + lib.makeLibraryPath [
                vulkan-loader
                libxi
                libxrender
                wayland
                libxkbcommon
              ];
          }))
        ];
        nativeBuildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/ModrinthApp --set WEBKIT_DISABLE_DMABUF_RENDERER 1 --set __GL_THREADED_OPTIMIZATIONS 0
        '';
      })
    ];
  };
}
