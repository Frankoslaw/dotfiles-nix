{ pkgs, lib, config, devenv, ... }:

with lib;
let cfg = 
    config.modules.packages;

in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            vscode google-chrome steam
            caprine-bin discord
            prismlauncher file
            anime-downloader hakuneko ani-cli 
            anup adl filebot 
            ffmpeg mpv vlc
            python3 pypy3 devenv.packages.${system}.devenv
            tmux
        ];
    };
}
