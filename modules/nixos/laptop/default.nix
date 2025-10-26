{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.laptop;
in {
  # TODO: Rename to power managment
  # TODO: Include nvidia power settings and other tweaks also for pc
  options.dotfiles.laptop = {
    enable = mkEnableOption "Laptop";
  };

  config = mkIf cfg.enable {
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave";
    };

    services.power-profiles-daemon.enable = false;
    services.auto-cpufreq.enable = true;
    services.auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };

    boot.kernelParams = [
      "ahci.mobile_lpm_policy=3"
      "rtc_cmos.use_acpi_alarm=1"
    ];

    systemd.tmpfiles.rules = [
      "w /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference - - - - balance_power"
    ];

    services.tlp = {
      enable = true;
      settings = {
        TLP_DEFAULT_MODE = "BAT";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
      };
    };

    #powerManagement.powertop.enable = true;
    services.thermald.enable = true;
  };
}
