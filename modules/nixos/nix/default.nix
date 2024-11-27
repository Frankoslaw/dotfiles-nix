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
            settings.auto-optimise-store = true;
            settings.allowed-users = ["frankoslaw"];
            
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