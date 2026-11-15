{ lib, config, ... }:
let
  warpProxyPort = 40000;
in
{
  options.modules.networking.enable = lib.mkEnableOption "networking via networkmanager";

  config = lib.mkIf config.modules.networking.enable {
    networking.networkmanager.enable = true;
    services.cloudflare-warp.enable = true;

    # WARP runs in SOCKS5 proxy mode instead of tunneling the whole machine,
    # so only apps pointed at the proxy (the nixd here) use the tunnel.
    systemd.services.warp-proxy-setup = {
      description = "Configure Cloudflare WARP in SOCKS5 proxy mode";
      after = [ "cloudflare-warp.service" ];
      requires = [ "cloudflare-warp.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        warp=${config.services.cloudflare-warp.package}/bin/warp-cli
        ready=
        for _ in $(seq 1 30); do
          if "$warp" --accept-tos status >/dev/null 2>&1; then
            ready=1
            break
          fi
          sleep 1
        done
        [ -n "$ready" ] || { echo "warp-cli: daemon not ready after 30s" >&2; exit 1; }
        "$warp" --accept-tos mode proxy
        "$warp" --accept-tos proxy port ${toString warpProxyPort}
        "$warp" --accept-tos connect
      '';
    };

    systemd.services.nix-daemon = {
      after = [ "warp-proxy-setup.service" ];
      environment.ALL_PROXY = "socks5h://127.0.0.1:${toString warpProxyPort}";
    };
  };
}
