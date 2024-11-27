{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.packages.direnv;
in {
  options.dotfiles.packages.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      direnv
      nix-direnv
    ];

    programs.direnv = {
      inherit (cfg) enable;

      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
