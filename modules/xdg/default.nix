{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.xdg;
in {
  options.modules.xdg = {enable = mkEnableOption "xdg";};
  config = mkIf cfg.enable {
    xdg.userDirs = {
      enable = true;
    };
  };
}
