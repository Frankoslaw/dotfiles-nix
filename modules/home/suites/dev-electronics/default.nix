{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.suites.dev-electronics;
in {
  options.dotfiles.suites.dev-electronics = {
    enable = mkEnableOption "electronics dev suite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kicad
      blender
      arduino-ide
      arduino-cli
      arduinoOTA
      minicom
      screen
      openocd
      imhex
      avrdude
      rpi-imager
    ];
  };
}
