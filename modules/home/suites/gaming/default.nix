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
      steam
      heroic
      bottles
      protonplus
      protontricks
      protonup-qt
      protonup-ng
      r2modman
      prismlauncher
      haguichi
      lime3ds
      melonDS
      gogdl
    ];
  };
}
