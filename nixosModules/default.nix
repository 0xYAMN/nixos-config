{ ... }: {
  imports = [
    ./base.nix
    ./bootvine.nix
    ./hardware
    ./networking.nix
    ./nix.nix
    ./virtualisation.nix
    ./packages
  ];
}
