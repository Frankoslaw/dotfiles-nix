{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.security;
in {
  options.dotfiles.security = {
    enable = mkEnableOption "Securitying";
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
    };
  };
}
