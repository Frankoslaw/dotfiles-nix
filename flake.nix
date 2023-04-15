{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        rust-nix-test = {
            url = "github:Frankoslaw/rust-nix-test";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        devenv.url = "github:cachix/devenv/latest";
    };

	# All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, devenv, rust-nix-test, ... }@inputs: 
        let
            system = "x86_64-linux"; #current system
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            lib = nixpkgs.lib;

            # This lets us reuse the code to "create" a system
            # Credits go to sioodmy on this one!
            # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
            mkSystem = pkgs: system: hostname:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        { networking.hostName = hostname; }
                        # General configuration (users, networking, sound, etc)
                        ./modules/system/configuration.nix
                        # Hardware config (bootloader, kernel modules, filesystems, etc)
                        # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
                        (./. + "/hosts/${hostname}/hardware-configuration.nix")
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                extraSpecialArgs = { inherit inputs devenv rust-nix-test; };
                                # Home manager config (configures programs like firefox, zsh, eww, etc)
                                users.frankoslaw = (./. + "/hosts/${hostname}/user.nix");
                            };
                            nixpkgs.overlays = [
                                nur.overlay
                            ];
                        }
                    ];
                    specialArgs = { inherit inputs; };
                };

        in {
            nixosConfigurations = {
                # Now, defining a new system is can be done in one line
                #                                Architecture   Hostname
                laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
            };
    };
}
