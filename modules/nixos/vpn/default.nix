{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkAfter;

  cfg = config.dotfiles.vpn;
in {
  options.dotfiles.vpn = {
    enable = mkEnableOption "vpn"; # TODO: Split tailscale from generic
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    networking.nftables.enable = true;

    environment.systemPackages = with pkgs; [
      trayscale # TODO: This should be a user package
      tailscale
    ];

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale # TODO: Move to secrets repo
        ${tailscale}/bin/tailscale up -authkey tskey-auth-<REDACTED>
      '';
    };

    networking.firewall = {
      enable = true; # TODO: Should this be here?
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ]; 
      allowedTCPPorts = [ 22 ];
    };
  };
}
