{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.suites.gaming;
in {
  options.dotfiles.suites.gaming = {
    enable = mkEnableOption "gaming suite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bubblewrap
      steam
      heroic
      protonplus
      protontricks
      protonup-qt
      protonup-ng
      gogdl
    ];
  };
}
