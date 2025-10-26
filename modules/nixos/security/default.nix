{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkAfter;

  cfg = config.dotfiles.security;
in {
  # TODO: Make this optional
  options.dotfiles.security = {
    enable = mkEnableOption "Security";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      clamav
      clamtk
    ];

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
      allowedTCPPorts = mkAfter [22];
    };
  };
}
