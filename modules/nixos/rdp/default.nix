{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkAfter;

  cfg = config.dotfiles.rdp;
in {
  options.dotfiles.rdp = {
    enable = mkEnableOption "enable remote graphical access through rdp";
    xrdp.enable = mkEnableOption "xrdp";
    gnome-remote-desktop.enable = mkEnableOption "gnome-remote-desktop";
  };

  config = mkIf cfg.enable {
    services.xrdp.enable = cfg.xrdp.enable;
    services.xrdp.openFirewall = true;
    services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";

    services.gnome.gnome-remote-desktop.enable = true;
    systemd.services.gnome-remote-desktop = mkIf cfg.gnome-remote-desktop.enable {
      wantedBy = [ "graphical.target" ];
    };

    networking.firewall.allowedTCPPorts = [ 3389 ];
    networking.firewall.allowedUDPPorts = [ 3389 ];

    services.displayManager.autoLogin.enable = false;
    services.getty.autologinUser = null;

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    environment.systemPackages = with pkgs; [
      gnome-session
      gnome-remote-desktop
      xrdp
    ];
  };
}
