{ inputs, lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.eww;

in {
    options.modules.firefox = { enable = mkEnableOption "firefox"; };

    config = mkIf cfg.enable {
        programs.firefox = {
            enable = true;

            # Install extensions from NUR
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
                ublock-origin
                tree-style-tab
                metamask
                gsconnect
                multi-account-containers
                enhanced-github
                enhancer-for-youtube
                clearurls
                sponsorblock
                darkreader
                h264ify
                df-youtube
            ];
        };
    };
}