{ pkgs, ... }:

with lib;
let cfg = config.modules.gtk;

in {
    options.modules.gtk = { enable = mkEnableOption "gtk"; };
    config = mkIf cfg.enable {
        gtk = {
            enable = true;
            theme = {
                name = "Materia-dark";
                package = pkgs.materia-theme;
            };
        };
    };
}