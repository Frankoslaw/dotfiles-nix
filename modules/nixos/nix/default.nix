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
        allowed-users = ["frankoslaw"];
        trusted-users = [
          "root"
          "frankoslaw"
          "@wheel"
        ];
        max-jobs = lib.mkDefault 12;
        cores = 12;
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
