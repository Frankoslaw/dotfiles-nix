{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.k3s;
in {
  options.dotfiles.k3s = {
    enable = mkEnableOption "k3s";
  };

  config = mkIf cfg.enable {
    services.k3s = {
      inherit (cfg) enable;
      role = "server";
      # tokenFile = "file://${../../../assets/wallpaper.png}";
      extraFlags = toString [
        "--disable=traefik"
      ];
    };
  };
}