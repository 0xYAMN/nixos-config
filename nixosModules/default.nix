{ ... }: {
  imports = [
    ./base.nix
    ./hardware
    ./networking.nix
    ./nix.nix
    ./virtualisation.nix
    ./packages
  ];
}
