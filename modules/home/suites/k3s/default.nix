{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.suites.k3s;
in {
  options.dotfiles.suites.k3s = {
    enable = mkEnableOption "k3s suite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      k3s
      k3d
      kubernetes-helm
      fluxcd
      k9s
      kustomize
    ];
  };
}
