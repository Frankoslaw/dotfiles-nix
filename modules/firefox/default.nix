{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.firefox;
in {
  options.modules.firefox = {enable = mkEnableOption "firefox";};
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        # See nixpkgs' firefox/wrapper.nix to check which options you can use
        cfg = {
          # Gnome shell native connector
          enableGnomeExtensions = true;
        };
      };

      profiles.default = {
        id = 0;
        name = "Default";
        isDefault = true;
        
        # Install extensions from NUR
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          tree-style-tab
          # metamask
          gsconnect
          multi-account-containers
          enhanced-github
          # enhancer-for-youtube
          clearurls
          sponsorblock
          # darkreader
          h264ify
          # df-youtube
          user-agent-string-switcher
        ];
      };
    };
  };
}
