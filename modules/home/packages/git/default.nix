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

        settings = {
          user = {
            name = "Franciszek Łopuszański";
            email = "franopusz2006@gmail.com";
          };
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
