{
  config,
  pkgs,
  lib,
  ...
}: let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.dotfiles.printing;
in {
    options.dotfiles.printing = {
        enable = mkEnableOption "Printing";
    };

    config = mkIf cfg.enable {
        services = {
            printing = {
                inherit (cfg) enable;

                drivers = with pkgs; [
                    hplip
                    hplipWithPlugin
                ];
            };

            avahi = {
                inherit (cfg) enable;

                nssmdns4 = true;
                openFirewall = true;
            };
        };
    };
}