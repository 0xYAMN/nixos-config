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

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, catppuccin, spicetify-nix, ... }:
  let
    unstablePkgs = system: import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    sharedModules = host: system: [
      ./hosts/${host}/configuration.nix
      ./nixosModules/default.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit spicetify-nix; };
        home-manager.sharedModules   = [
          catppuccin.homeModules.catppuccin
          spicetify-nix.homeManagerModules.spicetify
          ./homeModules/default.nix
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
    
    homeModules.default   = ./homeModules/default.nix;
    nixosModules.default  = ./nixosModules/default.nix;
  };
}
