{
  description = "yamn's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, catppuccin, ... }:
  let
    unstablePkgs = system: import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    sharedModules = host: system: [
      ./hosts/${host}/configuration.nix
      ./nixosModules/default.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules   = [
          catppuccin.homeModules.catppuccin
          ./homeManagerModules/default.nix
        ];
      }
    ];
  in {
    nixosConfigurations.prometheus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit catppuccin; pkgsUnstable = unstablePkgs "x86_64-linux"; };
      modules = sharedModules "prometheus" "x86_64-linux";
    };

    nixosConfigurations.thoth = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit catppuccin; pkgsUnstable = unstablePkgs "x86_64-linux"; };
      modules = sharedModules "thoth" "x86_64-linux";
    };
    
    homeManagerModules.default = ./homeManagerModules/default.nix;
    nixosModules.default       = ./nixosModules/default.nix;
  };
}
