{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.moonshine;
in {
  options.dotfiles.moonshine = {
    enable = mkEnableOption "Moonshine";
  };

  config = mkIf cfg.enable {
    services.moonshine = {
      enable = true;
      package = pkgs.moonshine;
      user = "frankoslaw";
      openFirewall = true;

      settings.application_scanner = [
        {
          type = "bottles";
          command = [
            "dbus-run-session"
            "--"
            "flatpak"
            "run"
            "--command=bottles-cli"
            "com.usebottles.bottles"
            "run"
            "-b"
            "{bottle}"
            "--program-id"
            "{program_id}"
          ];
          umu_command = [
            "dbus-run-session"
            "--"
            "flatpak"
            "run"
            "--command=bottles-cli"
            "com.usebottles.bottles"
            "umu"
            "run"
            "--game"
            "{umu_game}"
          ];
        }
      ];
    };
  };
}
