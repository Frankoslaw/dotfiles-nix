{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.wireless;
in {
  options.dotfiles.wireless = {
    enable = mkEnableOption "wireless";
  };

  config = mkIf cfg.enable {
    networking.wireless.iwd = {
      inherit (cfg) enable;

      settings = {
        General.EnableNetworkConfiguration = true;
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
      };
    };

    networking.networkmanager.wifi.backend = "iwd";
    services.connman.wifi.backend = "iwd";
  };
}
