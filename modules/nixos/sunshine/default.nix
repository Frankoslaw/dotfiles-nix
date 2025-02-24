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

  cfg = config.dotfiles.sunshine;
in
{
  options.dotfiles.sunshine = {
    enable = mkEnableOption "Enable sunshine";
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
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
    };

    services.avahi = {
        enable = false;
        openFirewall = true;

        publish = {
            enable = false;
            userServices = false;
        };
    };
  };
}