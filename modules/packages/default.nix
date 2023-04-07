{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;

in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            vscode
            google-chrome
            steam
            caprine-bin
            discord
            prismlauncher
            kitty
            wofi
        ];
    };
}
