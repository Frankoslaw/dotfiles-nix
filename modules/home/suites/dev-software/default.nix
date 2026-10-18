{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.suites.dev-software;
in {
  options.dotfiles.suites.dev-software = {
    enable = mkEnableOption "software dev suite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      insomnia
      docker-compose
      podman-compose
      filezilla
      distrobox
      devenv
      tree
      fzf
    ];

    lib.dotfiles.programs = {
      direnv.enable = true;
      vscode.enable = true;
    };
  };
}
