{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.packages.git;
in {
  options.dotfiles.packages.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs = {
      git = {
        inherit (cfg) enable;

        userName = "Franciszek Łopuszański";
        userEmail = "franopusz2006@gmail.com";
        extraConfig = {
          init = {
            defaultBranch = "main";
          };
        };
      };

      gpg = {
        inherit (cfg) enable;
      };
    };

    services.gpg-agent = {
      inherit (cfg) enable;
    };
  };
}
