{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkAfter;

  cfg = config.dotfiles.security;
in {
  options.dotfiles.security = {
    enable = mkEnableOption "Security";
  };

  config = mkIf cfg.enable {
    security = {
      rtkit = {
        inherit (cfg) enable;
      };

      sudo = {
        inherit (cfg) enable;
      };

      protectKernelImage = true;
    };

    networking.firewall = {
      inherit (cfg) enable;
      allowedTCPPorts = mkAfter [ 22 ];
    };
  };
}
