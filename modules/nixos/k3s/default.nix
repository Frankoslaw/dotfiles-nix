{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkAfter;

  cfg = config.dotfiles.k3s;
in {
  options.dotfiles.k3s = {
    enable = mkEnableOption "k3s";
  };

  config = mkIf cfg.enable {
    services.k3s = {
      inherit (cfg) enable;
      role = "server";
      # tokenFile = "file://${../../../assets/wallpaper.png}";
    };

    networking.firewall = {
      allowedTCPPorts = mkAfter [ 80 443 6443 ];
    };
  };
}
