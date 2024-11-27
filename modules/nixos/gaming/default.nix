{
  config,
  pkgs,
  lib,
  ...
}: let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.dotfiles.gaming;
in {
    options.dotfiles.gaming = {
        enable = mkEnableOption "Gaming";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = builtins.attrValues { inherit (pkgs) mono steam-run; };

        programs = {
            gamemode = {
                inherit (cfg) enable;
            };

            steam = {
                inherit (cfg) enable;

                remotePlay.openFirewall = true;
                extraCompatPackages = [ pkgs.proton-ge-bin ];
            };
        };
    };
}