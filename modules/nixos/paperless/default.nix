{
  config,
  lib,
  ...
}: let
  inherit (lib) mkAfter mkEnableOption mkIf mkOption types;

  cfg = config.dotfiles.paperless;
  paperlessServices = [
    "paperless-consumer"
    "paperless-scheduler"
    "paperless-task-queue"
    "paperless-web"
  ];
in {
  options.dotfiles.paperless = {
    enable = mkEnableOption "Paperless-ngx";

    domain = mkOption {
      type = types.str;
      default = "paperless.frankoslaw.top";
      description = "Local domain used to access Paperless-ngx.";
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Address on which Paperless-ngx listens.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "Port on which Paperless-ngx listens.";
    };

    allowedHosts = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional hostnames accepted by Paperless-ngx.";
    };
  };

  config = mkIf cfg.enable {
    networking.extraHosts = lib.mkAfter "127.0.0.1 ${cfg.domain}";

    services.paperless = {
      enable = true;
      address = cfg.address;
      port = cfg.port;

      # Keep this as the small local profile: SQLite and the native broker,
      # without PostgreSQL, Tika, Gotenberg, or an nginx reverse proxy.
      database.createLocally = false;
      configureTika = false;
      domain = null;
      settings = {
        PAPERLESS_DBENGINE = "sqlite";
        PAPERLESS_ALLOWED_HOSTS = lib.concatStringsSep "," ([cfg.domain "localhost" "127.0.0.1"] ++ cfg.allowedHosts);
        PAPERLESS_URL = "http://${cfg.domain}:${toString cfg.port}";
      };
    };

    # Paperless is reachable from the private LAN, while Tailscale access is
    # provided by the trusted tailscale0 interface in the VPN module.
    networking.firewall.extraInputRules = mkAfter ''
      ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } tcp dport ${toString cfg.port} accept
      ip6 saddr fc00::/7 tcp dport ${toString cfg.port} accept
    '';

    systemd.services = lib.genAttrs paperlessServices (_: {
      serviceConfig.TimeoutStopSec = "5min";
    });
  };
}
