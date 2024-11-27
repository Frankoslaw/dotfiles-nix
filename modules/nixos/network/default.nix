{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.network;
in {
  options.dotfiles.network = {
    enable = mkEnableOption "Network";
  };

  config = mkIf cfg.enable {
    networking.wireless.iwd = {
      inherit (cfg) enable;

      settings = {
        IPv6 = {
          Enabled = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };

    networking.networkmanager = {
      inherit (cfg) enable;
      wifi.backend = "iwd";
    };

    networking.extraHosts = ''
      109.199.97.139 contabo.local
    '';
  };
}
