{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.nix;
in {
  options.dotfiles.nix = {
    enable = mkEnableOption "Nix";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = true;
        # TODO: Thhis should not be hardcoded
        allowed-users = ["frankoslaw"];
        trusted-users = [
          "root"
          "frankoslaw"
          "@wheel"
        ];
        max-jobs = lib.mkDefault 12;
        cores = 12;
        # TODO: Reshearch more about benefits and drawbacks of using caching on nixos
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 2d";
      };
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true
        keep-derivations = true
      '';
    };
  };
}
