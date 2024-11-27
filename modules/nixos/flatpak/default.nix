{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.flatpak;
in {
  options.dotfiles.flatpak = {
    enable = mkEnableOption "Flatpak";
  };

  config = mkIf cfg.enable {
    services.flatpak = {
      inherit (cfg) enable;
    };

    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
