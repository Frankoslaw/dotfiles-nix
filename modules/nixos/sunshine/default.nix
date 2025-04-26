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
  inherit (lib.types) listOf str bool;

  cfg = config.dotfiles.sunshine;
in
{
  options.dotfiles.sunshine = {
    enable = mkEnableOption "Enable sunshine";

    autoStart = mkOption {
      type = bool;
      default = false;
      description = "Adds sunshine to autostart";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
        ffmpeg
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
        libva
        libva-utils
    ];

    services.sunshine = {
        enable = true;
        autoStart = cfg.autoStart;
        capSysAdmin = true;
        openFirewall = true;
    };

    services.avahi = {
        enable = true;
        openFirewall = true;

        publish = {
            enable = true;
            userServices = true;
        };
    };
  };
}