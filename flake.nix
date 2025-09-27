{
  description = "System wide flake";
  
  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Your system's configuration
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # The main configuration file
        ./configuration.nix

	home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true; # <-- Step 1: Use system's pkgs
          home-manager.useUserPackages = true; # <-- Allows packages in home.packages

          # Step 2: Link your user to your home.nix file
          home-manager.users.km3to = import ./home.nix;

          # Optional: You can pass arguments to your home.nix here
          # home-manager.extraSpecialArgs = { ... };
        }
      ];
    };
  };
}
