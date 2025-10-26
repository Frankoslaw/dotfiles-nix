{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.boot;
in {
  options.dotfiles.boot = {
    enable = mkEnableOption "Booting";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        inherit (cfg) enable;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    time.hardwareClockInLocalTime = true;
  };
}
