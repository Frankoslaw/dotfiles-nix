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
    services.tlp.enable = false;
    services.auto-cpufreq = {
      inherit (cfg) enable;

      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };
}
