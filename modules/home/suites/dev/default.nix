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
      eclipses.eclipse-java
      thonny
      stm32cubemx
      kicad
      prusa-slicer
      ghidra
      dbeaver-bin
      sqlitebrowser
      insomnia
      wireshark
      podman-tui
      podman-compose
      rpi-imager
      heimdall-gui
      imhex
      filezilla
      toolbox
      lens
    ];

    lib.dotfiles.programs = {
      direnv.enable = true;
      vscode.enable = true;
    };
  };
}
