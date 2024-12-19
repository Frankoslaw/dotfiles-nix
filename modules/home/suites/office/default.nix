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
      lyx
      mendeley
      xmind
      anki-bin
      libreoffice-fresh
      
      corefonts
      texstudio
      texmaker
      (pkgs.texlive.combine {
        inherit (pkgs.texlive)
          scheme-full
          pgf
          titling
          pgfplots
          tex-gyre
          ;
      })
    ];

    programs.firefox.enable = true;
  };
}
