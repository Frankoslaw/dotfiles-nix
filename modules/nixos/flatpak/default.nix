{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.types) listOf str;

  cfg = config.dotfiles.flatpak;
in {
  options.dotfiles.flatpak = {
    enable = mkEnableOption "Enable flatpak";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
