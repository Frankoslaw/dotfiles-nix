{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.vpn;
in {
  options.dotfiles.vpn = {
    enable = mkEnableOption "vpn"; # TODO: Split tailscale from generic
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    networking.nftables.enable = true;

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";
      after = ["network-online.target" "tailscale.service"];
      wants = ["network-online.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        sleep 2

        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ "$status" = "Running" ]; then
          exit 0
        fi

        authkey="$(<${config.sops.secrets.tailscale_authkey.path})"
        ${tailscale}/bin/tailscale up --authkey "$authkey"
      '';
    };

    environment.systemPackages = with pkgs; [
      trayscale # TODO: This should be a user package
      tailscale
    ];

    networking.firewall = {
      enable = true; # TODO: Should this be here?
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ]; 
      allowedTCPPorts = [ 22 ];
    };
  };
}
