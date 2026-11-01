{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.xrdp;
  display = config.dotfiles.display;
  gnomeEnabled = display.enable && display.gnome.enable;
  plasmaEnabled = display.enable && display.plasma.enable;
in {
  options.dotfiles.xrdp = {
    enable = mkEnableOption "xrdp";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = gnomeEnabled || plasmaEnabled;
        message = "dotfiles.xrdp requires an enabled GNOME or Plasma desktop.";
      }
    ];

    services.xrdp = {
      enable = true;
      openFirewall = false;
      defaultWindowManager =
        if plasmaEnabled
        then "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11"
        else "${pkgs.gnome-session}/bin/gnome-session";
    };

    # Keep XRDP limited to private LAN addresses. Tailscale access is provided
    # by the trusted tailscale0 interface in the VPN module.
    networking.firewall.extraInputRules = lib.mkAfter ''
      ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } tcp dport 3389 accept
      ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } udp dport 3389 accept
      ip6 saddr fc00::/7 tcp dport 3389 accept
      ip6 saddr fc00::/7 udp dport 3389 accept
    '';

    services.displayManager.autoLogin.enable = false;
    services.getty.autologinUser = null;

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
  };
}
