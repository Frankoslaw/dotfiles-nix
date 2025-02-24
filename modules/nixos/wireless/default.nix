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
    iwd = mkEnableOption "iwd";
    networkmanager = mkEnableOption "networkmanager";
  };

  config = mkIf cfg.enable {
    sops.secrets."wireless.env" = { };

    networking.wireless.iwd.enable = cfg.iwd;
    networking.networkmanager.enable = cfg.networkmanager;

    networking.wireless.iwd.settings = mkIf cfg.iwd {
      General.EnableNetworkConfiguration = true;
      IPv6.Enabled = true;
      Settings.AutoConnect = true;
    };

    networking = {
      hostName = "homelab-ms7970";
      defaultGateway = "192.168.0.1";
      nameservers = [ "192.168.0.1" "8.8.8.8" ];

      extraHosts = ''
        192.168.0.95 homelab
      '';
    };

    networking.interfaces."enp6s0" = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.0.95";
        prefixLength = 24;
      }];
    };

    networking.networkmanager.ensureProfiles.environmentFiles = [ config.sops.secrets."wireless.env".path ];
    networking.networkmanager.ensureProfiles.profiles = mkIf cfg.networkmanager {
      fast-wifi = {
        connection = { id = "fast-wifi"; type = "wifi"; autoconnect = true; autoconnect-priority = 30; };
        wifi.ssid = "$WIFI1_SSID";
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI1_PSK";
        };
      };
      homelab-wifi = {
        connection = { id = "homelab-wifi"; type = "wifi"; autoconnect = true; autoconnect-priority = 10; };
        wifi.ssid = "$WIFI2_SSID";
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI2_PSK";
        };
      };
      wired = {
        connection = { id = "wired"; type = "ethernet"; autoconnect = true; autoconnect-priority = 20;};
      };
    };

    networking.networkmanager.wifi.backend = mkIf cfg.iwd "iwd";
    services.connman.wifi.backend = mkIf cfg.iwd "iwd";
  };
}