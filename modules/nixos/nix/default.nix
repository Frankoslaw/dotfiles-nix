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
    programs.nix-ld.dev.enable = true;
    
    nix = {
      settings = {
        auto-optimise-store = true;
        allowed-users = ["frankoslaw"];
        trusted-users = [
          "root"
          "frankoslaw"
          "@wheel"
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
