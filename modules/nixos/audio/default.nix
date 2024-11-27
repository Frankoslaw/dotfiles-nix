{
  config,
  pkgs,
  lib,
  ...
}: let
    inherit (lib) mkEnableOption mkIf;

    cfg = config.dotfiles.audio;
in {
    options.dotfiles.audio = {
        enable = mkEnableOption "Audio";
    };

    config = mkIf cfg.enable {
        services.pipewire = {
            inherit (cfg) enable;

            audio = {
                inherit (cfg) enable;
            };
            pulse = {
                inherit (cfg) enable;
            };
            alsa = {
                inherit (cfg) enable;
                support32Bit = true;
            };
        };

        hardware.pulseaudio.enable = false;
    };
}