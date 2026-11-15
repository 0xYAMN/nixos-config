{ lib, config, ... }: {
  options.modules.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf config.modules.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # AirPods:
    hardware.bluetooth.settings = {
      General = {
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
        FastConnectable = true;
        Experimental = true;
        KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e";
      };
    };

    services.blueman.enable = true;

    nixpkgs.overlays = [
      (final: prev: {
        blueman = prev.blueman.overrideAttrs (old: {
          propagatedUserEnvPkgs = [ ];
        });
      })
    ];
  };
}
