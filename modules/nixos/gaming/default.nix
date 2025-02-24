{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.gaming;
in {
  options.dotfiles.gaming = {
    enable = mkEnableOption "Gaming";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = builtins.attrValues {inherit (pkgs) mono steam-run;};

    programs = {
      gamemode = {
        enable = true;
        enableRenice = true;
      };

      steam = {
        enable = true;

        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
    };
  };
}
