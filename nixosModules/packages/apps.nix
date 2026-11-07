{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.packages.enable {
    # LocalSend
    networking.firewall.allowedTCPPorts = [ 53317 ];
    networking.firewall.allowedUDPPorts = [ 53317 ];

    # Webex self-updates into ~/.local/share/WebexLauncher, and its version
    # selector then prefers that unpatched generic-Linux build over the Nix one,
    # which fails to start (libX11.so.6: cannot open shared object file). The
    # selector builds the path at runtime, so it can't be patched out of the
    # binaries; wrap bin/webex to drop the downloaded build before each launch.
    # See https://github.com/NixOS/nixpkgs/issues/254950
    nixpkgs.overlays = [
      (final: prev: {
        webex = prev.webex.overrideAttrs (old: {
          postFixup = (old.postFixup or "") + ''
            rm "$out/bin/webex"
            cat > "$out/bin/webex" <<EOF
            #!${final.runtimeShell}
            launcher="\$HOME/.local/share/WebexLauncher"
            rm -rf "\$launcher"/libWebexVersionSelector.so "\$launcher"/lib "\$launcher"/[0-9]*_*
            exec $out/opt/Webex/bin/CiscoCollabHost "\$@"
            EOF
            chmod +x "$out/bin/webex"
            substituteInPlace "$out/share/applications/webex.desktop" \
              --replace-fail "$out/opt/Webex/bin/CiscoCollabHost" "$out/bin/webex"
          '';
        });
      })
    ];

    programs.firefox.enable = true;

    programs.firefox.policies.ExtensionSettings = {
      "FirefoxColor@mozilla.com" = {
        installation_mode = "force_installed";
        install_url = "file://${
          pkgs.fetchurl {
            url = "https://addons.mozilla.org/firefox/downloads/file/3643624/firefox_color-2.1.7.xpi";
            hash = "sha256-t/sHtniPcjPdYiPngOGJtMe5VsJcQEk8KNcCBJMkkpI=";
          }
        }";
      };
    };

    environment.systemPackages = with pkgs; [
      localsend
      slack
      _1password-gui
      vlc
      webex
      signal-desktop
      obsidian
      discord
    ];
  };
}
