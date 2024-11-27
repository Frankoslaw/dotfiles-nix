{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkAfter;

  cfg = config.dotfiles.ssh;
in {
  options.dotfiles.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      inherit (cfg) enable;
      ports = [22];

      settings = {
        PasswordAuthentication = false;
        UseDns = true;
        PermitRootLogin = "prohibit-password";
      };
    };

    networking.firewall = {
      allowedTCPPorts = mkAfter [ 22 ];
    };
  };
}
