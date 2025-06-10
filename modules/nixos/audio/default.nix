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
      enable = true;

      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    services.pulseaudio.enable = false;
  };
}
