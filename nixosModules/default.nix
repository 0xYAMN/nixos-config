{ ... }: {
  imports = [
    ./hardware
    ./networking.nix
    ./virtualisation.nix
    ./packages
  ];
}
