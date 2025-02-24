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
    programs.ssh.forwardX11 = true;
    programs.ssh.setXAuthLocation = true;

    services.openssh = {
      inherit (cfg) enable;

      ports = [22];
      openFirewall = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
        X11Forwarding = true;
      };
    };
  };
}
