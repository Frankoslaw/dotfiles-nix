{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
  inherit (lib.types) listOf str;

  cfg = config.dotfiles.zsh;
in {
  options.dotfiles.zsh = {
    enable = mkEnableOption "Enable Zsh configuration";

    ohMyZsh = {
      enable = mkEnableOption "Enable Oh My Zsh framework";
      theme = mkOption {
        type = str;
        default = "robbyrussell";
      };
      plugins = mkOption {
        type = listOf str;
        default = ["git" "sudo" "direnv" "poetry"];
      };
    };
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;
    programs.zsh = {
      enable = cfg.enable;

      ohMyZsh = mkIf cfg.ohMyZsh.enable {
        inherit (cfg.ohMyZsh) enable theme plugins;
      };
    };
  };
}
