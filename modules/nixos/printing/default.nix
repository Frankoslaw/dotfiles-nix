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
        enable = true;

        drivers = with pkgs; [
          hplip
          hplipWithPlugin
        ];
      };

      avahi = {
        enable = true;

        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
