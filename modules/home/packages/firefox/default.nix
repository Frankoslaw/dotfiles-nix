{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.packages.firefox;
in {
  options.dotfiles.packages.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles.profile_0 = {
        id = 0;
        name = "default";
        isDefault = true;

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          multi-account-containers
          simple-translate
          user-agent-string-switcher
          grammarly
          wappalyzer
          tab-session-manager
        ];

        settings = {
          "ui.systemUsesDarkTheme" = 1;
          "browser.in-content.dark-mode" = true;
        };
      };
    };
  };
}
