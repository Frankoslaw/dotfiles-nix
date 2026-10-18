{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optional;

  cfg = config.dotfiles.rdp;
  display = config.dotfiles.display;
  gnomeEnabled = display.enable && display.gnome.enable;
  plasmaEnabled = display.enable && display.plasma.enable;
  gnomeRemoteDesktopEnabled = cfg.gnome-remote-desktop.enable && gnomeEnabled;
  remoteDesktopEnabled = cfg.xrdp.enable || gnomeRemoteDesktopEnabled;
in {
  options.dotfiles.rdp = {
    enable = mkEnableOption "enable remote graphical access through rdp";
    xrdp.enable = mkEnableOption "xrdp";
    gnome-remote-desktop.enable = mkEnableOption "gnome-remote-desktop";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = gnomeEnabled || plasmaEnabled;
        message = "dotfiles.rdp requires an enabled GNOME or Plasma desktop.";
      }
    ];

    services.xrdp.enable = cfg.xrdp.enable;
    services.xrdp.openFirewall = cfg.xrdp.enable;
    services.xrdp.defaultWindowManager = mkIf cfg.xrdp.enable (
      if plasmaEnabled
      then "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11"
      else "${pkgs.gnome-session}/bin/gnome-session"
    );

    services.gnome.gnome-remote-desktop.enable = gnomeRemoteDesktopEnabled;
    systemd.services.gnome-remote-desktop = mkIf gnomeRemoteDesktopEnabled {
      wantedBy = [ "graphical.target" ];
    };

    networking.firewall.allowedTCPPorts = mkIf remoteDesktopEnabled [ 3389 ];
    networking.firewall.allowedUDPPorts = mkIf remoteDesktopEnabled [ 3389 ];

    services.displayManager.autoLogin.enable = false;
    services.getty.autologinUser = null;

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    environment.systemPackages =
      (optional cfg.xrdp.enable pkgs.xrdp)
      ++ (optional gnomeEnabled pkgs.gnome-session)
      ++ (optional gnomeRemoteDesktopEnabled pkgs.gnome-remote-desktop);
  };
}
