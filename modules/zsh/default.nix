{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.zsh;

in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };
    config = mkIf cfg.enable {
        programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;

            oh-my-zsh = {
                enable = true;
                theme = "agnoster";

                plugins = [
                    "aws"
                    "docker"
                    "encode64"
                    "git"
                    "git-extras"
                    "man"
                    "nmap"
                    "ssh-agent"
                    "sudo"
                    "systemd"
                    "tig"
                    "tmux"
                    "vi-mode"
                    "yarn"
                    "zsh-navigation-tools"
                    "direnv"
                ];
            };
        };
    };
}