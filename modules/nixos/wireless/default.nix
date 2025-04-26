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
    sops.secrets."wireless.env" = { };

    networking.extraHosts = ''192.168.0.95 homelab'';

    networking.wireless.iwd = {
      enable = true;

      settings = {
        General.EnableNetworkConfiguration = true;
        Settings.AutoConnect = true;
      };
    };
    networking.networkmanager.wifi.backend = "iwd";

    networking.networkmanager.enable = true;
    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."wireless.env".path ];
    networking.networkmanager.ensureProfiles.profiles = {
      fast-wifi = {
        connection = { id = "fast-wifi"; type = "wifi"; autoconnect = true; autoconnect-priority = 300; };
        wifi.ssid = "$WIFI1_SSID";
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI1_PSK";
        };
      };
      wired = {
        connection = { id = "wired"; type = "ethernet"; autoconnect = true; autoconnect-priority = 200;};
      };
      personal-wifi = {
        connection = { id = "personal-wifi"; type = "wifi"; autoconnect = true; autoconnect-priority = 100; };
        wifi.ssid = "$WIFI2_SSID";
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI2_PSK";
        };
      };
    };
  };
}