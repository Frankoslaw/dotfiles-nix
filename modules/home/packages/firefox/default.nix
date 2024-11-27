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

                extensions = with pkgs.nur.repos.rycee.firefox-addons; [
                    ublock-origin
                    multi-account-containers
                    react-devtools
                    simple-translate
                    user-agent-string-switcher
                    simple-tab-groups
                    clearurls
                    tree-style-tab
                    grammarly
                    wappalyzer
                    # TODO: Medneley
                ];

                settings = {
                    "ui.systemUsesDarkTheme" = 1;
                    "browser.in-content.dark-mode" = true;
                };
            };
        };
    };
}