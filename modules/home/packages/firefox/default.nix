{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.dotfiles.packages.firefox;
  firefoxAddons = pkgs.nur.repos.rycee.firefox-addons;
  mendeley-web-importer = firefoxAddons.buildFirefoxXpiAddon {
    pname = "mendeley-web-importer";
    version = "3.2.78";
    addonId = "webapps@mendeley.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/3999604/mendeley_web_importer-3.2.78.xpi";
    sha256 = "7a288bde4ad791885069d0f408d351640332318b015ab5273a88378749534f47";
  };
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

        extensions.packages = with firefoxAddons; [
          ublock-origin
          multi-account-containers
          simple-tab-groups
          simple-translate
          grammarly
          passbolt
          wappalyzer
          tab-session-manager
          mendeley-web-importer
        ];

        settings = {
          "ui.systemUsesDarkTheme" = 1;
          "browser.in-content.dark-mode" = true;
        };
      };
    };
  };
}
