{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.plasma;
  kwriteconfig = "${pkgs.kdePackages.kconfig}/bin/kwriteconfig6";
in {
  options.dotfiles.plasma = {
    enable = mkEnableOption "KDE Plasma configuration";
  };

  config = mkIf cfg.enable {
    home.activation.plasmaScreenEdgeResponsiveness = config.lib.dag.entryAfter ["writeBoundary"] ''
      install -d -m 0700 "$HOME/.config"

      ${kwriteconfig} --file "$HOME/.config/kwinrc" --group Windows --key ElectricBorderDelay 0
      ${kwriteconfig} --file "$HOME/.config/kwinrc" --group Windows --key ElectricBorderCooldown 150
      ${kwriteconfig} --file "$HOME/.config/kwinrc" --group Windows --key ElectricBorderPushbackPixels 0
    '';
  };
}
