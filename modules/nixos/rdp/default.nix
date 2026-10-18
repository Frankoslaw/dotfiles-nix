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
    # Do not open XRDP on every interface. The Tailscale module trusts
    # tailscale0, so port 3389 remains reachable over Tailscale only.
    services.xrdp.openFirewall = false;
    services.xrdp.defaultWindowManager = mkIf cfg.xrdp.enable (
      if plasmaEnabled
      then "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11"
      else "${pkgs.gnome-session}/bin/gnome-session"
    );

    services.gnome.gnome-remote-desktop.enable = gnomeRemoteDesktopEnabled;
    systemd.services.gnome-remote-desktop = mkIf gnomeRemoteDesktopEnabled {
      wantedBy = [ "graphical.target" ];
    };

    # Allow XRDP from private LAN addresses. Tailscale access is provided by
    # the trusted tailscale0 interface in the VPN module.
    networking.firewall.extraInputRules = mkIf cfg.xrdp.enable (lib.mkAfter ''
      ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } tcp dport 3389 accept
      ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } udp dport 3389 accept
      ip6 saddr fc00::/7 tcp dport 3389 accept
      ip6 saddr fc00::/7 udp dport 3389 accept
    '');

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
