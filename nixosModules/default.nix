{ ... }: {
  imports = [
    ./hardware
    ./networking.nix
    ./nix.nix
    ./virtualisation.nix
    ./packages
  ];
}
