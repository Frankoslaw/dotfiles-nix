{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.suites.dev;
in {
  options.dotfiles.suites.dev = {
    enable = mkEnableOption "dev suite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thonny
      stm32cubemx
      kicad
      easyeda2kicad
      prusa-slicer
      ghidra
      dbeaver-bin
      sqlitebrowser
      insomnia
      docker-compose
      lazydocker
      x11docker
      podman-tui
      podman-compose
      rpi-imager
      heimdall-gui
      imhex
      filezilla
      toolbox
      lens
      devenv
    ];

    lib.dotfiles.programs = {
      direnv.enable = true;
      vscode.enable = true;
    };
  };
}
