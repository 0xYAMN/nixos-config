{
  description = "my nixos config";

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

    nix-matlab = {
      url = "github:0xYAMN/nix-matlab?ref=fix-new-naming-of-xorg-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      catppuccin,
      spicetify-nix,
      nix-matlab,
      git-hooks,
      ...
    }:
    let
      unstablePkgs =
        system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

      sharedModules = host: system: [
        ./hosts/${host}/configuration.nix
        ./nixosModules/default.nix
        home-manager.nixosModules.home-manager
        { nixpkgs.overlays = [ nix-matlab.overlay ]; }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit spicetify-nix; };
          home-manager.sharedModules = [
            catppuccin.homeModules.catppuccin
            spicetify-nix.homeManagerModules.spicetify
            ./homeModules/default.nix
          ];
        }
      ];

      preCommit = git-hooks.lib.x86_64-linux.run {
        src = ./.;
        hooks.nixfmt = {
          enable = true;
          package = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
        };
      };
    in
    {
      nixosConfigurations.prometheus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit catppuccin;
          pkgsUnstable = unstablePkgs "x86_64-linux";
        };
        modules = sharedModules "prometheus" "x86_64-linux";
      };

      nixosConfigurations.thoth = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit catppuccin;
          pkgsUnstable = unstablePkgs "x86_64-linux";
        };
        modules = sharedModules "thoth" "x86_64-linux";
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      checks.x86_64-linux.pre-commit = preCommit;

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        inherit (preCommit) shellHook;
        packages = preCommit.enabledPackages;
      };

      homeModules.default = ./homeModules/default.nix;
      nixosModules.default = ./nixosModules/default.nix;
    };
}
