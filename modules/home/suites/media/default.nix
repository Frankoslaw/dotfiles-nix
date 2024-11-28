{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.suites.media;
in {
  options.dotfiles.suites.media = {
    enable = mkEnableOption "media suite";
  };

  config = mkIf cfg.enable {    
    home.packages = with pkgs; [
      mpv
      vlc
      krita
      gimp
      inkscape
      kdenlive
      youtube-music
      ani-cli
    ];
  };
}
