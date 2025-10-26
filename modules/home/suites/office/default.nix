{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.suites.office;
in {
  options.dotfiles.suites.office = {
    enable = mkEnableOption "office suite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      mendeley
      xmind
      anki-bin
      libreoffice-fresh
      corefonts
    ];

    programs.firefox.enable = true;
  };
}
