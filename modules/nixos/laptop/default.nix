{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.laptop;
in {
  options.dotfiles.laptop = {
    enable = mkEnableOption "Laptop";
  };

  config = mkIf cfg.enable {
    powerManagement = {
      inherit (cfg) enable;
    };

    services.power-profiles-daemon.enable = false;
    services.tlp = {
      inherit (cfg) enable;

      settings = {
        TLP_DEFAULT_MODE = "BAT";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      };
    };
  };
}
