{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-software-center = {
      url = "github:vlinkz/nix-software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # All outputs for the system (configs)
  outputs = {
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    devenv,
    aagl,
    rust-overlay,
    ...
  } @ inputs: let
    system = "x86_64-linux"; #current system
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = { allowUnfree = true; };
    };
    formatter = pkgs.alejandra;

    lib = nixpkgs.lib;

    # This lets us reuse the code to "create" a system
    # Credits go to sioodmy on this one!
    # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
    mkSystem = pkgs: system: hostname:
      lib.makeOverridable lib.nixosSystem {
        system = system;
        modules = [
          {networking.hostName = hostname;}
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
              extraSpecialArgs = {inherit inputs devenv pkgs-unstable; };
              # Home manager config (configures programs like firefox, zsh, eww, etc)
              users.frankoslaw = ./. + "/hosts/${hostname}/user.nix";
            };
            nixpkgs.overlays = [
              nur.overlay
              rust-overlay.overlays.default
            ];
          }
          {
            imports = [ aagl.nixosModules.default ];
            nix.settings = aagl.nixConfig;
            programs.honkers-railway-launcher.enable = true; # Starail
            programs.anime-game-launcher.enable = false; # Genshin
            programs.honkers-launcher.enable = false; # Honkai impact
          }
        ];
        specialArgs = {inherit inputs;};
      };
  in {
    devShell."${system}" = import ./shell.nix { inherit pkgs; };
    nixosConfigurations = {
      # Now, defining a new system is can be done in one line
      #                                Architecture   Hostname
      laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
    };

    formatter.x86_64-linux = pkgs.alejandra;
  };
}
